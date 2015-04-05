#define DEBUG_TYPE "dyn"
#include "dyncore.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/Triple.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/DC/DCInstrSema.h"
#include "llvm/DC/DCRegisterSema.h"
#include "llvm/DC/DCTranslator.h"
#include "llvm/ExecutionEngine/Orc/CompileUtils.h"
#include "llvm/ExecutionEngine/Orc/IRCompileLayer.h"
#include "llvm/ExecutionEngine/Orc/LazyEmittingLayer.h"
#include "llvm/ExecutionEngine/Orc/ObjectLinkingLayer.h"
#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/IR/Instructions.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/MC/MCAnalysis/MCObjectSymbolizer.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDisassembler.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstBuilder.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCObjectDisassembler.h"
#include "llvm/MC/MCObjectFileInfo.h"
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
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include <dlfcn.h>
#include <mach-o/dyld.h>
#include <memory>

// See dyncore.h, this makes sure the DYNCore library is loaded.
extern "C" void LLVMLinkInDYNCore() {}

using namespace llvm;
using namespace object;
using namespace orc;

static std::string TripleName;

static StringRef ToolName;

static const Target *getTarget(const ObjectFile *Obj) {
  // Figure out the target triple.
  Triple TheTriple("unknown-unknown-unknown");
  if (TripleName.empty()) {
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
  TripleName = TheTriple.getTriple();
  return TheTarget;
}

template <typename T>
static std::vector<T> singletonSet(T t) {
  std::vector<T> Vec;
  Vec.push_back(std::move(t));
  return Vec;
}

class DYNJIT {
public:
  typedef ObjectLinkingLayer<> ObjLayerT;
  typedef IRCompileLayer<ObjLayerT> CompileLayerT;
  typedef LazyEmittingLayer<CompileLayerT> LazyEmitLayerT;

  typedef LazyEmitLayerT::ModuleSetHandleT ModuleHandleT;

  DYNJIT(TargetMachine &TM)
    : Mang(TM.getDataLayout()),
      CompileLayer(ObjectLayer, SimpleCompiler(TM)),
      LazyEmitLayer(CompileLayer) {}

  std::string mangle(const std::string &Name) {
    std::string MangledName;
    {
      raw_string_ostream MangledNameStream(MangledName);
      Mang.getNameWithPrefix(MangledNameStream, Name);
    }
    return MangledName;
  }

  ModuleHandleT addModule(Module *M) {
    // We need a memory manager to allocate memory and resolve symbols for this
    // new module. Create one that resolves symbols by looking back into the
    // JIT.
    auto MM = createLookasideRTDyldMM<SectionMemoryManager>(
                [&](const std::string &Name) {
                  if (uint64_t Addr = findSymbol(Name).getAddress())
                    return Addr;
                  assert(Name.length() > 1 && Name.front() == '_');
                  return (uint64_t)dlsym(RTLD_DEFAULT, Name.c_str()+1);
                },
                [](const std::string &S) {
                  return 0;
                } );
    return LazyEmitLayer.addModuleSet(singletonSet(std::move(M)),
                                      std::move(MM));
  }

  void removeModule(ModuleHandleT H) { LazyEmitLayer.removeModuleSet(H); }

  JITSymbol findSymbol(const std::string &Name) {
    return LazyEmitLayer.findSymbol(Name, true);
  }

  JITSymbol findUnmangledSymbol(const std::string Name) {
    return findSymbol(mangle(Name));
  }

private:
  Mangler Mang;
  ObjLayerT ObjectLayer;
  CompileLayerT CompileLayer;
  LazyEmitLayerT LazyEmitLayer;
};

static uint64_t loadRegFromSet(uint8_t *RegSet, unsigned Offset, unsigned Size){
  RegSet += Offset;
  switch (Size) {
  default:
    llvm_unreachable("Loading unhandled size from register set!");
    // FIXME: Is this ever unaligned?  shouldn't be, since the StructType should
    // have its members properly aligned
  case 1: return *(uint8_t  *)RegSet;
  case 2: return *(uint16_t *)RegSet;
  case 4: return *(uint32_t *)RegSet;
  case 8: return *(uint64_t *)RegSet;
  }
}

//static DCTranslator *__dc_DT;
//static ExecutionEngine *__dc_EE;

// FIXME: We need to handle cache invalidation when functions are freed.
//static DenseMap<void *, void *> TranslationCache(128);

// FIXME: This should be configurable (to at least remove the global state).
//extern "C" void *__llvm_dc_translate_at(void *addr) {
//  void *&ptr = TranslationCache[addr];
//  if (ptr == 0)
//    ptr = __dc_EE->getPointerToFunction(__dc_DT->getFunctionAt((uint64_t)addr));
//  return ptr;
//}

// FIXME: This is all mach-o hacks to get this working.
struct ProgramVars {
  const void*   mh;
  int*          NXArgcPtr;
  const char*** NXArgvPtr;
  const char*** environPtr;
  const char**  __prognamePtr;
};
#include <iostream>

void dyn_entry(int ac, char **av, const char **envp, const char **apple,
               struct ProgramVars *pvars) __attribute__((constructor));
void dyn_entry(int ac, char **av, const char **envp, const char **apple,
               struct ProgramVars *pvars) {
  int argc = ac;
  char **argv = av;

  sys::PrintStackTraceOnErrorSignal();
  PrettyStackTraceProgram X(argc, argv);
  llvm_shutdown_obj Y;

  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();
  InitializeNativeTargetAsmParser();
  InitializeAllTargets();
  InitializeAllTargetInfos();
  InitializeAllTargetDCs();
  InitializeAllTargetMCs();
  InitializeAllAsmParsers();
  InitializeAllDisassemblers();

  // Remove ourselves from the environment, in case the process decides to fork.
  // Translating the child as well should be done on purpose, but affecting the
  // environment is unacceptable anyway.
  // For now, it messes with stuff like ASAN's symbolizer, so just disable it.
  unsetenv("DYLD_INSERT_LIBRARIES");

  ToolName = "dyn";
  cl::ParseEnvironmentOptions(ToolName.str().c_str(), "DCDYN_OPTIONS");

  std::string InputFilename = argv[0];

  ErrorOr<OwningBinary<Binary>> BinaryOrErr = createBinary(InputFilename);
  if (std::error_code EC = BinaryOrErr.getError()) {
    errs() << ToolName << ": '" << InputFilename << "': " << EC.message() << ".\n";
    exit(1);
  }
  Binary &Binary = *BinaryOrErr.get().getBinary();


  ObjectFile *Obj;
  if (!(Obj = dyn_cast<ObjectFile>(&Binary))) {
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

  std::unique_ptr<MCInstPrinter> MIP(
      TheTarget->createMCInstPrinter(0, *MAI, *MII, *MRI, *STI));
  if (!MIP) {
    errs() << "error: no instprinter for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<const MCInstrAnalysis> MIA(
      TheTarget->createMCInstrAnalysis(MII.get()));
  std::unique_ptr<const MCObjectFileInfo> MOFI(new MCObjectFileInfo);
  MCContext Ctx(MAI.get(), MRI.get(), MOFI.get());

  std::unique_ptr<MCDisassembler> DisAsm(TheTarget->createMCDisassembler(*STI, Ctx));
  if (!DisAsm) {
    errs() << "error: no disassembler for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<MCRelocationInfo> RelInfo(
      TheTarget->createMCRelocationInfo(TripleName, Ctx));
  if (!RelInfo) {
    errs() << "error: no reloc info for target " << TripleName << "\n";
    exit(1);
  }
  // FIXME: why are there unique_ptrs everywhere?
  std::unique_ptr<MCObjectSymbolizer> MOS(
      MCObjectSymbolizer::createObjectSymbolizer(Ctx, std::move(RelInfo),
                                                 Obj));

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
    OD->setFallbackRegion(0x1000,
        ArrayRef<uint8_t>((uint8_t *)0x1000, (uint8_t *)0x7FFFFFFFFFFFFFFFULL));
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

  EngineBuilder Builder;
  Builder.setOptLevel(CodeGenOpt::Aggressive);
  TargetMachine *TM = Builder.selectTarget();
  if (!TM)
    llvm_unreachable("Unable to select target machine for JIT!");

  const DataLayout *DL = TM->getDataLayout();

  DYNJIT J(*TM);

  std::unique_ptr<DCTranslator> DT(
    new DCTranslator(getGlobalContext(), DL->getStringRepresentation(),
                     TransOpt::Aggressive, *DIS, *DRS,
                     *MIP, *MCM, OD.get()));

  // Now run it !

  // First, get the init/fini functions.
  Function *InitRegSetFn = DT->getInitRegSetFunction();
  Function *FiniRegSetFn = DT->getFiniRegSetFunction();

  // Add these to the JIT.
  J.addModule(DT->finalizeTranslationModule());

  const StructLayout *SL = DL->getStructLayout(DRS->getRegSetType());
  std::unique_ptr<uint8_t[]> RegSet(new uint8_t[SL->getSizeInBytes()]);
  const unsigned StackSize = 4096 * 1024;
  std::unique_ptr<uint8_t[]> StackPtr(new uint8_t[StackSize]);

  unsigned RegSetPCSize, RegSetPCOffset;
  std::tie(RegSetPCSize, RegSetPCOffset) =
      DRS->getRegSizeOffsetInRegSet(DL, MRI->getProgramCounter());

  auto InitRegSetFnFP =
      (void (*)(uint8_t *, uint8_t *, uint32_t, uint32_t, char **))
        (intptr_t)J.findUnmangledSymbol(InitRegSetFn->getName()).getAddress();
  auto RunInitRegSet = [&]() {
    InitRegSetFnFP(RegSet.get(), StackPtr.get(), StackSize, argc, argv);
  };

  RunInitRegSet();

  auto RunIRFunction = [&](Function *Fn) {
    auto FnSymbol = J.findUnmangledSymbol(Fn->getName());
    DEBUG(dbgs() << "Jumping to " << Fn->getName() << "\n");
    auto FnPointer = (void (*)(uint8_t *))(intptr_t)FnSymbol.getAddress();
    return FnPointer(RegSet.get());
  };

  // Translate all static init functions.
  auto TranslateAndRunStaticInitExit = [&](ArrayRef<uint64_t> Fns) {
    std::vector<Function *> TranslatedFns;
    TranslatedFns.reserve(Fns.size());
    for (auto FnAddr : Fns)
      TranslatedFns.push_back(
          DT->translateRecursivelyAt(OD->getEffectiveLoadAddr(FnAddr)));
    DEBUG(DT->printCurrentModule(dbgs()));

    // Add these to the JIT, and run them.
    J.addModule(DT->finalizeTranslationModule());
    for (auto Fn : TranslatedFns) {
      DEBUG(dbgs() << "Executing static init/fini function " << Fn->getName()
                   << "\n");
      RunIRFunction(Fn);
      // Reset the register state. Since we don't look at the return address,
      // this takes care of faking the push/pop.
      RunInitRegSet();
    }
  };

  TranslateAndRunStaticInitExit(OD->getStaticInitFunctions());

  // Now we can start running real code.
  uint64_t CurPC = MCM->getEntrypoint();
  assert(dlsym(RTLD_MAIN_ONLY, "main") == (void *)CurPC);
  do {
    Function *Fn = DT->translateRecursivelyAt(CurPC);
    DEBUG(dbgs() << "Executing function " << Fn->getName() << "\n");
    // Dump the IR we found.
    DEBUG(DT->printCurrentModule(dbgs()));
    J.addModule(DT->finalizeTranslationModule());
    RunIRFunction(Fn);
    CurPC = loadRegFromSet(RegSet.get(), RegSetPCOffset, RegSetPCSize);
  } while (CurPC != ~0ULL);

  auto FiniRegSetFnFP =
      (int (*)(uint8_t *))(intptr_t)J.findUnmangledSymbol(
                                          FiniRegSetFn->getName()).getAddress();
  auto RunFiniRegSet = [&]() { return FiniRegSetFnFP(RegSet.get()); };

  int exitVal = RunFiniRegSet();

  TranslateAndRunStaticInitExit(OD->getStaticExitFunctions());

  exit(exitVal);
}
