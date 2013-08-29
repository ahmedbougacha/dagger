#define DEBUG_TYPE "dyn"
#include "dyncore.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/Triple.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/DC/DCInstrSema.h"
#include "llvm/DC/DCRegisterSema.h"
#include "llvm/DC/DCTranslator.h"
#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/ExecutionEngine/JIT.h"
#include "llvm/ExecutionEngine/JITEventListener.h"
#include "llvm/IR/Instructions.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCAtom.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDisassembler.h"
#include "llvm/MC/MCFunction.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstBuilder.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCModule.h"
#include "llvm/MC/MCObjectDisassembler.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCObjectSymbolizer.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Object/MachO.h"
#include "llvm/Object/ObjectFile.h"
#include "llvm/Pass.h"
#include "llvm/PassManager.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/MemoryObject.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/StringRefMemoryObject.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include <dlfcn.h>
#include <mach-o/dyld.h>

// See dyncore.h, this makes sure the DYNCore library is loaded.
extern "C" void LLVMLinkInDYNCore() {}

using namespace llvm;
using namespace object;

static const char *TripleName = 0;

static StringRef ToolName;

static const Target *getTarget(const ObjectFile *Obj) {
  // Figure out the target triple.
  Triple TheTriple("unknown-unknown-unknown");
  if (TripleName == 0) {
  if (Obj) {
    TheTriple.setArch(Triple::ArchType(Obj->getArch()));
    // TheTriple defaults to ELF, and COFF doesn't have an environment:
    // the best we can do here is indicate that it is mach-o.
    if (Obj->isMachO())
      TheTriple.setObjectFormat(Triple::MachO);
  }
  } else {
    TheTriple.setTriple(TripleName);
  }

  // Get the Target.
  std::string Error;
  const Target *TheTarget = TargetRegistry::lookupTarget("", TheTriple, Error);
  if (!TheTarget) {
    errs() << ToolName << ": " << Error;
    return 0;
  }

  // Update the triple name and return the found target.
  TripleName = TheTriple.getTriple().c_str();
  return TheTarget;
}

static uint64_t loadRegFromSet(uint8_t *RegSet, unsigned Offset, unsigned Size){
  RegSet += Offset;
  switch (Size) {
  default:
    llvm_unreachable("Loading unhandled size from register set!");
  case 1: return *(uint8_t  *)RegSet;
  case 2: return *(uint16_t *)RegSet;
  case 4: return *(uint32_t *)RegSet;
  case 8: return *(uint64_t *)RegSet;
  }
}

static DCTranslator *__dc_DT;
static ExecutionEngine *__dc_EE;

// FIXME: We need to handle cache invalidation when functions are freed.
static DenseMap<void *, void *> TranslationCache(128);

// FIXME: This should be configurable (to at least remove the global state).
extern "C" void *__llvm_dc_translate_at(void *addr) {
  void *&ptr = TranslationCache[addr];
  if (ptr == 0)
    ptr = __dc_EE->getPointerToFunction(__dc_DT->getFunctionAt((uint64_t)addr));
  return ptr;
}

// FIXME: This is all mach-o hacks to get this working.
struct ProgramVars {
  const void*   mh;
  int*          NXArgcPtr;
  const char*** NXArgvPtr;
  const char*** environPtr;
  const char**  __prognamePtr;
};

void dyn_entry(int ac, char **av, const char **envp, const char **apple,
               struct ProgramVars *pvars) __attribute__((constructor));
void dyn_entry(int ac, char **av, const char **envp, const char **apple,
               struct ProgramVars *pvars) {
  int argc = ac;
  char **argv = av;

  sys::PrintStackTraceOnErrorSignal();
  PrettyStackTraceProgram X(argc, argv);
  llvm_shutdown_obj Y;

  InitializeAllTargets();
  InitializeAllTargetInfos();
  InitializeAllTargetDCs();
  InitializeAllTargetMCs();
  InitializeAllAsmParsers();
  InitializeAllDisassemblers();

  ToolName = "dyn";
  std::string InputFilename = argv[0];

  std::unique_ptr<MemoryBuffer> FileBuf;
  if (error_code ec = MemoryBuffer::getFile(InputFilename, FileBuf)) {
    errs() << ToolName << ": '" << InputFilename << "': " << ec.message()
           << ".\n";
    exit(1);
  }

  ErrorOr<Binary *> BinaryOrErr = createBinary(FileBuf.get());
  if (error_code ec = BinaryOrErr.getError()) {
    errs() << ToolName << ": '" << InputFilename << "': "
           << ec.message() << ".\n";
    exit(1);
  }
  std::unique_ptr<Binary> binary(BinaryOrErr.get());


  ObjectFile *Obj;
  if (!(Obj = dyn_cast<ObjectFile>(binary.get()))) {
    errs() << ToolName << ": '" << InputFilename << "': "
           << "Unrecognized file type.\n";
    exit(1);
  }

  const Target *TheTarget = getTarget(Obj);

  std::unique_ptr<const MCRegisterInfo> MRI(
    TheTarget->createMCRegInfo(TripleName));
  if (!MRI) {
    errs() << "error: no register info for target " << TripleName << "\n";
    exit(1);
  }

  // Set up disassembler.
  std::unique_ptr<const MCAsmInfo> MAI(
    TheTarget->createMCAsmInfo(*MRI, TripleName));
  if (!MAI) {
    errs() << "error: no assembly info for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<const MCSubtargetInfo> STI(
      TheTarget->createMCSubtargetInfo(TripleName, "", ""));
  if (!STI) {
    errs() << "error: no subtarget info for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<const MCInstrInfo> MII(TheTarget->createMCInstrInfo());
  if (!MII) {
    errs() << "error: no instruction info for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<MCDisassembler> DisAsm(TheTarget->createMCDisassembler(*STI));
  if (!DisAsm) {
    errs() << "error: no disassembler for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<MCInstPrinter> MIP(
      TheTarget->createMCInstPrinter(0, *MAI, *MII, *MRI, *STI));
  if (!MIP) {
    errs() << "error: no instprinter for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<const MCInstrAnalysis> MIA(
      TheTarget->createMCInstrAnalysis(MII.get()));
  std::unique_ptr<const MCObjectFileInfo> MOFI(new MCObjectFileInfo);
  std::unique_ptr<MCContext> Ctx(
    new MCContext(MAI.get(), MRI.get(), MOFI.get()));

  std::unique_ptr<MCRelocationInfo> RelInfo(
      TheTarget->createMCRelocationInfo(TripleName, *Ctx.get()));
  if (!RelInfo) {
    errs() << "error: no reloc info for target " << TripleName << "\n";
    exit(1);
  }
  std::unique_ptr<MCObjectSymbolizer> MOS(
      MCObjectSymbolizer::createObjectSymbolizer(*Ctx.get(), RelInfo, Obj));

  // FIXME: Mach-O specific

  // FIXME: We need to handle shared libraries. For now everything we do is only
  // in the main executable, we don't look at anything beyond object boundaries.
  // The first image is the main executable.
  uint64_t VMAddrSlide = _dyld_get_image_vmaddr_slide(0);
  uint64_t HeaderLoadAddress = (uint64_t)_dyld_get_image_header(0);

  std::unique_ptr<MCObjectDisassembler> OD(new MCMachOObjectDisassembler(
      *cast<object::MachOObjectFile>(Obj), *DisAsm, *MIA, VMAddrSlide,
      HeaderLoadAddress));
  OD->setSymbolizer(MOS.get());
  // FIXME: We need either:
  //  - a custom non-contiguous memory object, for every mapped region.
  //  - a "raw" memory object, that just forwards to memory accesses.
  // The problem with the latter is that it just crashes when we do invalid
  // accesses. But, in general, we don't really care about undefined behavior
  // anyway, so this isn't that big a deal right now.
  // Just do a hack to access a big deal of reachable memory.
  {
    std::unique_ptr<MemoryObject> FallbackRegion(new StringRefMemoryObject(
        StringRef((char *)0x1000, 0x7FFFFFFFFFFFFFFFULL), 0x1000));
    OD->setFallbackRegion(FallbackRegion);
  }

  std::unique_ptr<MCModule> MCM(OD->buildEmptyModule());

  if (!MCM)
    exit(1);

  std::unique_ptr<DCRegisterSema> DRS(
      TheTarget->createDCRegisterSema(TripleName, *MRI, *MII));
  if (!DRS) {
    errs() << "error: no dc register sema for target " << TripleName << "\n";
    exit(1);
  }
  std::unique_ptr<DCInstrSema> DIS(
      TheTarget->createDCInstrSema(TripleName, *DRS, *MRI, *MII));
  if (!DIS) {
    errs() << "error: no dc instruction sema for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<DCTranslator> DT(
    new DCTranslator(getGlobalContext(), TransOpt::Aggressive, *DIS, *DRS,
                     *MIP, *MCM, OD.get()));

  // Now run it !

  Module *Mod = DT->getModule();

  std::string ErrorMsg;

  EngineBuilder Builder(Mod);
  Builder.setErrorStr(&ErrorMsg);
  Builder.setOptLevel(CodeGenOpt::Aggressive);
  Builder.setEngineKind(EngineKind::JIT);
  Builder.setAllocateGVsWithCode(false);

  ExecutionEngine *EE = Builder.create();
  if (!EE) {
    errs() << "error: Unable to create ExecutionEngine: " << ErrorMsg << "\n";
    exit(1);
  }

  const DataLayout *DL = EE->getDataLayout();
  Mod->setDataLayout(DL->getStringRepresentation());

  const StructLayout *SL = DL->getStructLayout(DRS->getRegSetType());
  uint8_t *RegSet = new uint8_t[SL->getSizeInBytes()];
  const unsigned StackSize = 4096 * 1024;
  uint8_t *StackPtr = new uint8_t[StackSize];

  std::vector<GenericValue> InitArgs;
  GenericValue GV;
  GV.PointerVal = RegSet;
  InitArgs.push_back(GV);
  GV.PointerVal = StackPtr;
  InitArgs.push_back(GV);
  GV.IntVal = APInt(32, StackSize);
  InitArgs.push_back(GV);
  GV.IntVal = APInt(32, argc);
  InitArgs.push_back(GV);
  GV.PointerVal = argv;
  InitArgs.push_back(GV);

  EE->runFunction(DT->getInitRegSetFunction(), InitArgs);

  std::vector<GenericValue> Args;
  GV.PointerVal = RegSet;
  Args.push_back(GV);

  unsigned PCSize, PCOffset;
  DRS->getRegOffsetInRegSet(DL, MRI->getProgramCounter(), PCSize, PCOffset);

  __dc_DT = DT.get();
  __dc_EE = EE;

  class DynListener : public JITEventListener {
  public:
    void NotifyFunctionEmitted(const Function &fn, void *ptr, size_t size,
                               const EmittedFunctionDetails &) {
      DEBUG(dbgs() << "Function was emitted !! " << fn.getName() << " at "
                   << ptr << "\n");
    }

    void NotifyFreeingMachineCode(void *ptr) {
      DEBUG(dbgs() << "Function was freed !! " << ptr << "\n");
    }
  };
  DynListener dynlistener;
  // debug
  EE->RegisterJITEventListener(&dynlistener);

  ArrayRef<uint64_t> StaticInits = OD->getStaticInitFunctions();
  // FIXME: This doesn't check the return address.
  for (size_t i = 0, e = StaticInits.size(); i != e; ++i) {
    Function *Fn = DT->getFunctionAt(OD->getEffectiveLoadAddr(StaticInits[i]));
    DEBUG(dbgs() << "Executing static init function " << Fn->getName() << "\n");
    // Mod->dump();
    EE->runFunction(Fn, Args);

    // Reset the register state. Since we don't look at the return address,
    // this takes care of faking the push/pop.
    EE->runFunction(DT->getInitRegSetFunction(), InitArgs);
  }

  uint64_t CurPC = DT->getEntrypoint();
  assert(dlsym(RTLD_MAIN_ONLY, "main") == (void *)CurPC);
  while (CurPC != ~0ULL) {
    Function *Fn = DT->getFunctionAt(CurPC);
    DEBUG(dbgs() << "Executing function " << Fn->getName() << "\n");
    // Mod->dump();
    EE->runFunction(Fn, Args);
    CurPC = loadRegFromSet(RegSet, PCOffset, PCSize);
  }

  // Dump the IR we found.
  DEBUG(Mod->print(dbgs(), 0));

  GV = EE->runFunction(DT->getFiniRegSetFunction(), Args);
  exit(GV.IntVal.getZExtValue());
}
