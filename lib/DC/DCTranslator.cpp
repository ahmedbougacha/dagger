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
#include "llvm/DC/DCFunction.h"
#include "llvm/DC/DCRegisterSema.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
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
                           TransOpt::Level TransOptLevel, DCFunction &DCF,
                           DCRegisterSema &DRS, MCInstPrinter &IP,
                           const MCSubtargetInfo &STI,
                           bool EnableIRAnnotation)
    : Ctx(Ctx), DL(DL), ModuleSet(),
      CurrentModule(nullptr), CurrentFPM(),
      EnableIRAnnotation(EnableIRAnnotation), DTIT(), DCF(DCF),
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

  DCF.SwitchToModule(CurrentModule);

  if (EnableIRAnnotation)
    DTIT.reset(new DCTranslatedInstTracker);
}

DCTranslator::~DCTranslator() {}

Function *DCTranslator::getInitRegSetFunction() {
  return DCF.getOrCreateInitRegSetFunction();
}
Function *DCTranslator::getFiniRegSetFunction() {
  return DCF.getOrCreateFiniRegSetFunction();
}
Function *DCTranslator::createMainFunctionWrapper(Function *Entrypoint) {
  return DCF.getOrCreateMainFunction(Entrypoint);
}

Function *DCTranslator::createExternalWrapperFunction(uint64_t Addr,
                                                      Value *ExtFn) {
  return DCF.createExternalWrapperFunction(Addr, ExtFn);
}

Function *DCTranslator::createExternalWrapperFunction(uint64_t Addr,
                                                      StringRef Name) {
  return DCF.createExternalWrapperFunction(Addr, Name);
}

Function *DCTranslator::createExternalWrapperFunction(uint64_t Addr) {
  return DCF.createExternalWrapperFunction(Addr);
}

Function *DCTranslator::getFunction(StringRef Name) {
  for (auto &M : ModuleSet)
    if (Function *F = M->getFunction(Name))
      return F;
  return nullptr;
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

Function *DCTranslator::translateFunction(const MCFunction &MCFN) {
  AddrPrettyStackTraceEntry X(MCFN.getStartAddr(), "Function");

  // If we already translated this function, bail out.
  // FIXME: The naming logic belongs in a 'DCModule'.
  if (Function *F = getFunction(getDCFunctionName(MCFN.getStartAddr())))
    if (!F->isDeclaration())
      return F;

  DCF.SwitchToFunction(&MCFN);

  // First, make sure all basic blocks are created, and sorted.
  std::vector<const MCBasicBlock *> BasicBlocks;
  std::copy(MCFN.begin(), MCFN.end(), std::back_inserter(BasicBlocks));
  std::sort(BasicBlocks.begin(), BasicBlocks.end(), BBBeginAddrLess);
  for (auto &BB : BasicBlocks)
    DCF.getOrCreateBasicBlock(BB->getStartAddr());

  for (auto &BB : MCFN) {
    AddrPrettyStackTraceEntry X(BB->getStartAddr(), "Basic Block");

    DEBUG(dbgs() << "Translating basic block starting at "
                 << utohexstr(BB->getStartAddr()) << ", with " << BB->size()
                 << " instructions.\n");
    DCF.SwitchToBasicBlock(BB);
    for (auto &I : *BB) {
      InstPrettyStackTraceEntry X(I.Address, I.Inst.getOpcode());
      DEBUG(dbgs() << "Translating instruction:\n "; dbgs() << I.Inst << "\n";);
      DCTranslatedInst TI(I);
      if (!DCF.translateInst(I, TI)) {
        errs() << "Cannot translate instruction: \n  "
               << "  " << DCF.getDRS().MII.getName(I.Inst.getOpcode()) << ": "
               << I.Inst << "\n";
        llvm_unreachable("Couldn't translate instruction\n");
      }
      if (EnableIRAnnotation)
        DTIT->trackInst(TI);
    }
    DCF.FinalizeBasicBlock();
  }

  for (uint64_t TailCallTarget : MCFN.tailcallees())
    DCF.createExternalTailCallBB(TailCallTarget);

  Function *Fn = DCF.FinalizeFunction();
  {
    // ValueToValueMapTy VMap;
    // Function *OrigFn = CloneFunction(Fn, VMap, false);
    // OrigFn->setName(Fn->getName() + "_orig");
    // CurrentModule->getFunctionList().push_back(OrigFn);
    CurrentFPM->run(*Fn);
  }
  return Fn;
}
