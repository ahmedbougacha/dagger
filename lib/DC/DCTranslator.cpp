//===-- lib/DC/DCTranslator.cpp - DC Translation Engine ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCTranslator.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/DC/DCInstrSema.h"
#include "llvm/DC/DCRegisterSema.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/MC/MCAnalysis/MCObjectDisassembler.h"
#include "llvm/MC/MCAnalysis/MCObjectSymbolizer.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/Pass.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include <algorithm>
#include <memory>
#include <vector>
using namespace llvm;

#define DEBUG_TYPE "dctranslator"

DCTranslator::DCTranslator(LLVMContext &Ctx, const DataLayout &DL,
                           TransOpt::Level TransOptLevel, DCInstrSema &DIS,
                           DCRegisterSema &DRS, MCInstPrinter &IP,
                           const MCSubtargetInfo &STI, MCModule &MCM,
                           MCObjectDisassembler *MCOD, MCObjectSymbolizer *MOS,
                           bool EnableIRAnnotation)
    : Ctx(Ctx), DL(DL), ModuleSet(), MCOD(MCOD), MOS(MOS), MCM(MCM),
      CurrentModule(nullptr), CurrentFPM(),
      EnableIRAnnotation(EnableIRAnnotation), DTIT(), DIS(DIS),
      OptLevel(TransOptLevel) {


  initializeTranslationModule();
}

Module *DCTranslator::finalizeTranslationModule(
    std::unique_ptr<DCTranslatedInstTracker> *OldDTIT) {
  Module *OldModule = CurrentModule;
  assert(OldModule);
  DEBUG(OldModule->dump());

  // If we have IR annotation enabled, return the old tracker if needed.
  if (EnableIRAnnotation && OldDTIT)
    *OldDTIT = std::move(DTIT);

  initializeTranslationModule();
  return OldModule;
}

void DCTranslator::initializeTranslationModule() {
  ModuleSet.emplace_back(
      CurrentModule = new Module(
          (Twine("dct module #") + utohexstr(ModuleSet.size())).str(), Ctx));
  CurrentModule->setDataLayout(DL);

  CurrentFPM.reset(new legacy::FunctionPassManager(CurrentModule));
  if (OptLevel >= TransOpt::Less)
    CurrentFPM->add(createPromoteMemoryToRegisterPass());
  if (OptLevel >= TransOpt::Default)
    CurrentFPM->add(createDeadCodeEliminationPass());
  if (OptLevel >= TransOpt::Aggressive)
    CurrentFPM->add(createInstructionCombiningPass());

  DIS.SwitchToModule(CurrentModule);

  if (EnableIRAnnotation)
    DTIT.reset(new DCTranslatedInstTracker);
}

DCTranslator::~DCTranslator() {}

Function *DCTranslator::getInitRegSetFunction() {
  return DIS.getOrCreateInitRegSetFunction();
}
Function *DCTranslator::getFiniRegSetFunction() {
  return DIS.getOrCreateFiniRegSetFunction();
}
Function *DCTranslator::createMainFunctionWrapper(Function *Entrypoint) {
  return DIS.getOrCreateMainFunction(Entrypoint);
}

static bool
isDefinedInModuleSet(std::vector<std::unique_ptr<Module>> &ModuleSet,
                     Function *F) {
  for (auto &M : ModuleSet) {
    if (Function *MF = M->getFunction(F->getName())) {
      if (!MF->isDeclaration())
        return true;
    }
  }
  return false;
}

Function *DCTranslator::translateRecursivelyAt(uint64_t EntryAddr) {
  SmallSetVector<uint64_t, 16> WorkList;
  WorkList.insert(EntryAddr);
  for (size_t i = 0; i < WorkList.size(); ++i) {
    uint64_t Addr = WorkList[i];
    Function *F = DIS.getFunction(Addr);
    if (F && !F->isDeclaration())
      continue;

    if (isDefinedInModuleSet(ModuleSet, F))
      continue;

    DEBUG(dbgs() << "Translating function at " << utohexstr(Addr) << "\n");

    // Look for an external function.
    // If the function isn't even in the main object, just call it by address.
    // FIXME: original/effective?
    if (MOS) {
      if (!MOS->isInObject(MOS->getOriginalLoadAddr(Addr))) {
        DEBUG(dbgs() << "Found external (not in object) function: " << Addr << "\n");
        DIS.createExternalWrapperFunction(Addr);
        continue;
      }

      // If the function is explicitly referenced by the main object, emit a
      // direct call to the function, by name.
      StringRef ExtFnName = MOS->findExternalFunctionAt(Addr);
      if (!ExtFnName.empty()) {
        DEBUG(dbgs() << "Found external function: " << ExtFnName << "\n");
        DIS.createExternalWrapperFunction(Addr, ExtFnName);
        continue;
      }
    }

    // Now look for the function if it was already in the module.
    MCFunction *MCFN = MCM.findFunctionAt(Addr);
    // If it wasn't, we need to disassemble it.
    if (!MCFN) {
      if (!MCOD)
        report_fatal_error(("Unable to translate unknown function at " +
                            utohexstr(Addr) + " without a disassembler!")
                               .c_str());
      MCFN = MCOD->createFunction(&MCM, Addr);
    }
    assert(MCFN && "Wasn't able to translate function!");

    translateFunction(*MCFN);
    for (uint64_t CallTarget : MCFN->callees())
      WorkList.insert(CallTarget);
  }
  return DIS.getFunction(EntryAddr);
}

namespace {
class AddrPrettyStackTraceEntry : public PrettyStackTraceEntry {
public:
  uint64_t StartAddr;
  const char *Kind;
  AddrPrettyStackTraceEntry(uint64_t StartAddr, const char *Kind)
      : PrettyStackTraceEntry(), StartAddr(StartAddr), Kind(Kind) {}

  void print(raw_ostream &OS) const override {
    OS << "DC: Translating " << Kind << " at address " << utohexstr(StartAddr)
       << "\n";
  }
};
class InstPrettyStackTraceEntry : public PrettyStackTraceEntry {
public:
  uint64_t Addr;
  unsigned Opcode;
  InstPrettyStackTraceEntry(uint64_t Addr, unsigned Opcode)
      : PrettyStackTraceEntry(), Addr(Addr), Opcode(Opcode) {}

  void print(raw_ostream &OS) const override {
    OS << "DC: Translating instruction " << Opcode << " at address "
       << utohexstr(Addr) << "\n";
  }
};
} // end anonymous namespace

static bool BBBeginAddrLess(const MCBasicBlock *LHS, const MCBasicBlock *RHS) {
  return LHS->getStartAddr() < RHS->getStartAddr();
}

void DCTranslator::translateFunction(const MCFunction &MCFN) {
  AddrPrettyStackTraceEntry X(MCFN.getStartAddr(), "Function");

  // If we already translated this function, bail out.
  if (!DIS.getFunction(MCFN.getStartAddr())->empty())
    return;

  DIS.SwitchToFunction(&MCFN);

  // First, make sure all basic blocks are created, and sorted.
  std::vector<const MCBasicBlock *> BasicBlocks;
  std::copy(MCFN.begin(), MCFN.end(), std::back_inserter(BasicBlocks));
  std::sort(BasicBlocks.begin(), BasicBlocks.end(), BBBeginAddrLess);
  for (auto &BB : BasicBlocks)
    DIS.getOrCreateBasicBlock(BB->getStartAddr());

  for (auto &BB : MCFN) {
    AddrPrettyStackTraceEntry X(BB->getStartAddr(), "Basic Block");

    DEBUG(dbgs() << "Translating basic block starting at "
                 << utohexstr(BB->getStartAddr()) << ", with " << BB->size()
                 << " instructions.\n");
    DIS.SwitchToBasicBlock(BB);
    for (auto &I : *BB) {
      InstPrettyStackTraceEntry X(I.Address, I.Inst.getOpcode());
      DEBUG(dbgs() << "Translating instruction:\n "; dbgs() << I.Inst << "\n";);
      DCTranslatedInst TI(I);
      if (!DIS.translateInst(I, TI)) {
        errs() << "Cannot translate instruction: \n  "
               << "  " << DIS.getDRS().MII.getName(I.Inst.getOpcode()) << ": "
               << I.Inst << "\n";
        llvm_unreachable("Couldn't translate instruction\n");
      }
      if (EnableIRAnnotation)
        DTIT->trackInst(TI);
    }
    DIS.FinalizeBasicBlock();
  }

  for (uint64_t TailCallTarget : MCFN.tailcallees())
    DIS.createExternalTailCallBB(TailCallTarget);

  Function *Fn = DIS.FinalizeFunction();
  {
    // ValueToValueMapTy VMap;
    // Function *OrigFn = CloneFunction(Fn, VMap, false);
    // OrigFn->setName(Fn->getName() + "_orig");
    // CurrentModule->getFunctionList().push_back(OrigFn);
    CurrentFPM->run(*Fn);
  }
}
