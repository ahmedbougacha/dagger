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
#include "llvm/ExecutionEngine/Orc/LambdaResolver.h"
#include "llvm/ExecutionEngine/Orc/LazyEmittingLayer.h"
#include "llvm/ExecutionEngine/Orc/ObjectLinkingLayer.h"
#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/IR/Instructions.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/MC/MCAnalysis/MCObjectDisassembler.h"
#include "llvm/MC/MCAnalysis/MCObjectSymbolizer.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDisassembler/MCDisassembler.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstBuilder.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Object/MachO.h"
#include "llvm/Object/MachOUniversal.h"
#include "llvm/Object/ObjectFile.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/DynamicLibrary.h"
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

static const Target *getTarget(const ObjectFile &Obj) {
  // Figure out the target triple.
  Triple TheTriple("unknown-unknown-unknown");
  if (TripleName.empty()) {
    TheTriple.setArch(Triple::ArchType(Obj.getArch()));
    // TheTriple defaults to ELF, and COFF doesn't have an environment:
    // the best we can do here is indicate that it is mach-o.
    if (Obj.isMachO())
      TheTriple.setObjectFormat(Triple::MachO);
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

static OwningBinary<MachOObjectFile> openObjectFileAtPath(StringRef Path) {
  Expected<OwningBinary<Binary>> BinaryOrErr = createBinary(Path);
  if (auto E = BinaryOrErr.takeError()) {
    logAllUnhandledErrors(std::move(E), errs(),
                          (ToolName + ": '" + Path + "': ").str());
    exit(1);
  }

  std::unique_ptr<Binary> Bin;
  std::unique_ptr<MemoryBuffer> Buf;
  std::tie(Bin, Buf) = BinaryOrErr.get().takeBinary();

  auto *BinPtr = Bin.release();
  std::unique_ptr<MachOObjectFile> MOOF;

  if (auto *FatBinPtr = dyn_cast<MachOUniversalBinary>(BinPtr)) {
    for (auto &Obj : FatBinPtr->objects()) {
      // FIXME: Realistically, we only support x86_64 for now.
      // This won't be hardest place to fix.
      if (Obj.getArchTypeName() != "x86_64")
        continue;
      auto SliceOrErr = Obj.getAsObjectFile();
      if (auto E = SliceOrErr.takeError()) {
        logAllUnhandledErrors(std::move(E), errs(),
                              (ToolName + ": '" + Path + "': ").str());
        exit(1);
      }
      MOOF = std::move(SliceOrErr.get());
      break;
    }
  } else if (auto *MOOFPtr = dyn_cast<MachOObjectFile>(BinPtr)) {
    MOOF.reset(MOOFPtr);
  }

  if (!MOOF) {
    errs() << ToolName << ": '" << Path << "': "
           << "Unrecognized file type.\n";
    exit(1);
  }

  return OwningBinary<MachOObjectFile>(std::move(MOOF), std::move(Buf));
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
      : DL(TM.createDataLayout()), CompileLayer(ObjectLayer, SimpleCompiler(TM)),
        LazyEmitLayer(CompileLayer) {}

  std::string mangle(const std::string &Name) {
    std::string MangledName;
    {
      raw_string_ostream MangledNameStream(MangledName);
      Mangler::getNameWithPrefix(MangledNameStream, Name, DL);
    }
    return MangledName;
  }

  ModuleHandleT addModule(Module *M) {
    // Dump the IR we found.
    DEBUG(M->dump());
    // We need a memory manager to allocate memory and resolve symbols for this
    // new module. Create one that resolves symbols by looking back into the
    // JIT.
    auto Resolver = createLambdaResolver(
        [&](const std::string &Name) {
          if (auto Sym = findSymbol(Name))
            return JITSymbol(Sym.getAddress(), Sym.getFlags());
          else if (auto Addr =
                       RTDyldMemoryManager::getSymbolAddressInProcess(Name))
            return JITSymbol(Addr, JITSymbolFlags::Exported);
          return JITSymbol(nullptr);
        },
        [](const std::string &S) { return nullptr; });

    return LazyEmitLayer.addModuleSet(singletonSet(std::move(M)),
                                      make_unique<SectionMemoryManager>(),
                                      std::move(Resolver));
  }

  void removeModule(ModuleHandleT H) { LazyEmitLayer.removeModuleSet(H); }

  JITSymbol findSymbol(const std::string &Name) {
    return LazyEmitLayer.findSymbol(Name, true);
  }

  JITSymbol findUnmangledSymbol(const std::string Name) {
    return findSymbol(mangle(Name));
  }

private:
  const DataLayout DL;
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

static DCTranslator *__dc_DT;
static DYNJIT *__dc_JIT;

// FIXME: We need to handle cache invalidation when functions are freed.
//static DenseMap<void *, void *> TranslationCache(128);

static void *__llvm_dc_translate_at(void *addr) {
  void *ptr = nullptr;
  Function *F = __dc_DT->translateRecursivelyAt((uint64_t)addr);
  DEBUG(dbgs() << "__llvm_dc_translate_at " << addr << "\n");
  DEBUG(dbgs() << "Jumping to " << F->getName() << "\n");
  ptr = (void*)__dc_JIT->findUnmangledSymbol(F->getName()).getAddress();
  if (!ptr) {
    __dc_JIT->addModule(__dc_DT->finalizeTranslationModule());
    auto FnSymbol = __dc_JIT->findUnmangledSymbol(F->getName());
    ptr = (void*)FnSymbol.getAddress();
  }
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
#include <iostream>

void dyn_entry(int argc, char **argv, const char **envp, const char **apple,
               struct ProgramVars *pvars) __attribute__((constructor));
void dyn_entry(int argc, char **argv, const char **envp, const char **apple,
               struct ProgramVars *pvars) {

  sys::PrintStackTraceOnErrorSignal(/*Filename=*/StringRef());
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

  OwningBinary<MachOObjectFile> MOOFAndBuffer =
      openObjectFileAtPath(InputFilename);
  MachOObjectFile &MOOF = *MOOFAndBuffer.getBinary();

  const Target *TheTarget = getTarget(MOOF);

  // FIXME: why are there unique_ptrs everywhere?

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
      TheTarget->createMCInstPrinter(Triple(TripleName), 0, *MAI, *MII, *MRI));
  if (!MIP) {
    errs() << "error: no instprinter for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<const MCInstrAnalysis> MIA(
      TheTarget->createMCInstrAnalysis(MII.get()));
  std::unique_ptr<const MCObjectFileInfo> MOFI(new MCObjectFileInfo);
  MCContext MCCtx(MAI.get(), MRI.get(), MOFI.get());

  std::unique_ptr<MCDisassembler> DisAsm(
      TheTarget->createMCDisassembler(*STI, MCCtx));
  if (!DisAsm) {
    errs() << "error: no disassembler for target " << TripleName << "\n";
    exit(1);
  }

  std::unique_ptr<MCRelocationInfo> RelInfo(
      TheTarget->createMCRelocationInfo(TripleName, MCCtx));
  if (!RelInfo) {
    errs() << "error: no reloc info for target " << TripleName << "\n";
    exit(1);
  }

  // FIXME: Mach-O specific

  // FIXME: We need to handle shared libraries. For now everything we do is only
  // in the main executable, we don't look at anything beyond object boundaries.
  // The first image is the main executable.
  uint64_t VMAddrSlide = _dyld_get_image_vmaddr_slide(0);

  // Explicitly use a Mach-O-specific symbolizer to give it dyld info.
  std::unique_ptr<MCMachObjectSymbolizer> MOS(
      new MCMachObjectSymbolizer(MCCtx, std::move(RelInfo), MOOF, VMAddrSlide));

  std::unique_ptr<MCObjectDisassembler> OD(
      new MCObjectDisassembler(MOOF, *DisAsm, *MIA, MOS.get()));

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

  EngineBuilder Builder;
  Builder.setOptLevel(CodeGenOpt::Default);
  TargetMachine *TM = Builder.selectTarget();
  if (!TM)
    llvm_unreachable("Unable to select target machine for JIT!");

  const DataLayout DL = TM->createDataLayout();
  LLVMContext Ctx;

  std::unique_ptr<DCRegisterSema> DRS(
      TheTarget->createDCRegisterSema(TripleName, Ctx, *MRI, *MII, DL));
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

  DIS->setDynTranslateAtCallback(
      reinterpret_cast<void *>(&__llvm_dc_translate_at));

  // Add the program's symbols into the JIT's search space.
  if (sys::DynamicLibrary::LoadLibraryPermanently(nullptr)) {
    errs() << "error: unable to load program symbols.\n";
    exit(1);
  }

  DYNJIT J(*TM);

  std::unique_ptr<DCTranslator> DT(new DCTranslator(Ctx, DL, TransOpt::Default,
                                                    *DIS, *DRS, *MIP, *STI,
                                                    *MCM, OD.get(), MOS.get()));

  __dc_DT = DT.get();
  __dc_JIT = &J;

  // Now run it !

  // First, get the init/fini functions.
  Function *InitRegSetFn = DT->getInitRegSetFunction();
  Function *FiniRegSetFn = DT->getFiniRegSetFunction();

  // Add these to the JIT.
  J.addModule(DT->finalizeTranslationModule());

  const StructLayout *SL = DL.getStructLayout(DRS->getRegSetType());
  std::vector<uint8_t> RegSet(SL->getSizeInBytes());
  const unsigned StackSize = 4096 * 1024;
  std::vector<uint8_t> StackPtr(StackSize);

  unsigned RegSetPCSize, RegSetPCOffset;
  std::tie(RegSetPCSize, RegSetPCOffset) =
      DRS->getRegSizeOffsetInRegSet(MRI->getProgramCounter());

  auto InitRegSetFnFP =
      (void (*)(uint8_t *, uint8_t *, uint32_t, uint32_t, char **))
        (intptr_t)J.findUnmangledSymbol(InitRegSetFn->getName()).getAddress();
  auto RunInitRegSet = [&]() {
    InitRegSetFnFP(RegSet.data(), StackPtr.data(), StackSize, argc, argv);
  };

  RunInitRegSet();

  auto GetIRFunction = [&](Function *Fn) {
    auto FnSymbol = J.findUnmangledSymbol(Fn->getName());
    uint64_t Addr = FnSymbol.getAddress();
    DEBUG(dbgs() << "Jitted " << (void *)Addr << " for " << Fn->getName()
                 << "\n");
    return Addr;
  };

  auto RunIRFunction = [&](Function *Fn) {
    DEBUG(dbgs() << "Jumping to " << Fn->getName() << "\n");
    auto FnPointer = (void (*)(uint8_t *))(intptr_t)GetIRFunction(Fn);
    return FnPointer(RegSet.data());
  };

  // Translate all static init functions.
  auto TranslateAndRunStaticInitExit = [&](ArrayRef<uint64_t> Fns) {
    std::vector<Function *> TranslatedFns;
    TranslatedFns.reserve(Fns.size());
    for (auto FnAddr : Fns)
      TranslatedFns.push_back(
          DT->translateRecursivelyAt(MOS->getEffectiveLoadAddr(FnAddr)));

    // Add these to the JIT, and run them.
    Module *M = DT->finalizeTranslationModule();
    DEBUG(M->print(dbgs(), nullptr));
    J.addModule(M);
    for (auto Fn : TranslatedFns) {
      DEBUG(dbgs() << "Executing static init/fini function " << Fn->getName()
                   << "\n");
      RunIRFunction(Fn);
      // Reset the register state. Since we don't look at the return address,
      // this takes care of faking the push/pop.
      RunInitRegSet();
    }
  };

  TranslateAndRunStaticInitExit(MOS->getStaticInitFunctions());

  // Now we can start running real code.
  uint64_t CurPC = MOS->getEffectiveLoadAddr(MOS->getEntrypoint());
  assert(dlsym(RTLD_MAIN_ONLY, "main") == (void *)CurPC);
  do {
    Function *Fn = DT->translateRecursivelyAt(CurPC);
    DEBUG(dbgs() << "Executing function " << Fn->getName() << "\n");
    J.addModule(DT->finalizeTranslationModule());
    RunIRFunction(Fn);
    CurPC = loadRegFromSet(RegSet.data(), RegSetPCOffset, RegSetPCSize);
  } while (CurPC != ~0ULL);

  auto FiniRegSetFnFP =
      (int (*)(uint8_t *))(intptr_t)J.findUnmangledSymbol(
                                          FiniRegSetFn->getName()).getAddress();
  auto RunFiniRegSet = [&]() { return FiniRegSetFnFP(RegSet.data()); };

  int exitVal = RunFiniRegSet();

  TranslateAndRunStaticInitExit(MOS->getStaticExitFunctions());

  exit(exitVal);
}
