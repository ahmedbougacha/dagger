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
#include "llvm/DC/DCBasicBlock.h"
#include "llvm/DC/DCFunction.h"
#include "llvm/DC/DCInstruction.h"
#include "llvm/DC/DCModule.h"
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
                           unsigned OptLevel,
                           const DCRegisterSetDesc RegSetDesc)
    : Ctx(Ctx), DL(DL), RegSetDesc(RegSetDesc), ModuleSet(),
      CurrentModule(nullptr), CurrentFPM(), OptLevel(OptLevel) {}

Module *DCTranslator::finalizeTranslationModule() {
  Module *OldModule = CurrentModule;
  assert(OldModule);
  DEBUG(OldModule->dump());

  initializeTranslationModule();
  return OldModule;
}

void DCTranslator::initializeTranslationModule() {
  ModuleSet.emplace_back(
      CurrentModule = new Module(
          (Twine("dct module #") + utohexstr(ModuleSet.size())).str(), Ctx));
  CurrentModule->setDataLayout(DL);

  DCM = createDCModule(*CurrentModule);

  getDRS().SwitchToModule(CurrentModule);

  CurrentFPM.reset(new legacy::FunctionPassManager(CurrentModule));
  if (OptLevel >= 1)
    CurrentFPM->add(createPromoteMemoryToRegisterPass());
  if (OptLevel >= 2)
    CurrentFPM->add(createDeadCodeEliminationPass());
  if (OptLevel >= 3)
    CurrentFPM->add(createInstructionCombiningPass());
}

DCTranslator::~DCTranslator() {}

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
  StringRef Opcode;
  InstPrettyStackTraceEntry(uint64_t Addr, StringRef Opcode)
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
  Function *F = DCM->getOrCreateFunction(MCFN.getStartAddr());
  if (F->isDeclaration()) {
    AddrPrettyStackTraceEntry X(MCFN.getStartAddr(), "Function");
    std::unique_ptr<DCFunction> DCF = createDCFunction(*DCM, MCFN);

    assert(F == DCF->getFunction() &&
           "DCFunction unexpectedly created a new function");

    // First, make sure all basic blocks are created, and sorted.
    std::vector<const MCBasicBlock *> BasicBlocks;
    std::copy(MCFN.begin(), MCFN.end(), std::back_inserter(BasicBlocks));
    std::sort(BasicBlocks.begin(), BasicBlocks.end(), BBBeginAddrLess);
    for (auto &BB : BasicBlocks)
      DCF->getOrCreateBasicBlock(BB->getStartAddr());

    for (auto &BB : MCFN) {
      AddrPrettyStackTraceEntry X(BB->getStartAddr(), "Basic Block");
      DEBUG(dbgs() << "Translating basic block starting at "
                   << utohexstr(BB->getStartAddr()) << ", with " << BB->size()
                   << " instructions.\n");

      std::unique_ptr<DCBasicBlock> DCB = createDCBasicBlock(*DCF, *BB);

      for (auto &I : *BB) {
        StringRef InstName = getDRS().MII.getName(I.Inst.getOpcode());
        InstPrettyStackTraceEntry X(I.Address, InstName);
        DEBUG(dbgs() << "Translating instruction:\n ";
              dbgs() << InstName << ": " << I.Inst << "\n";);


        std::unique_ptr<DCInstruction> DCI = createDCInstruction(*DCB, I);

        if (!DCI->translate()) {
          errs() << "Cannot translate instruction: \n  "
                 << "  " << InstName << ": " << I.Inst << "\n";
          llvm_unreachable("Couldn't translate instruction\n");
        }
      }
    }

    for (uint64_t TailCallTarget : MCFN.tailcallees())
      DCF->createExternalTailCallBB(TailCallTarget);
  }

  // Now that the DCFunction is out of scope and complete, we can optimize it.
  {
    // ValueToValueMapTy VMap;
    // Function *OrigFn = CloneFunction(Fn, VMap, false);
    // OrigFn->setName(Fn->getName() + "_orig");
    // CurrentModule->getFunctionList().push_back(OrigFn);
    CurrentFPM->run(*F);
  }
  return F;
}
