//===-- lib/DC/DCFunction.cpp - Function Translation ------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCFunction.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/DC/DCRegisterSema.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "dc-sema"

static cl::opt<bool> EnableRegSetDiff("enable-dc-regset-diff", cl::desc(""),
                                      cl::init(false));

DCFunction::DCFunction(DCModule &DCM, const MCFunction &MCF)
    : DCM(DCM), TheFunction(*DCM.getOrCreateFunction(MCF.getStartAddr())),
      TheMCFunction(MCF), BBByAddr(), ExitBB(nullptr), Calls() {
  assert(!TheMCFunction.empty() && "Trying to translate empty MC function");
  const uint64_t StartAddr = TheMCFunction.getStartAddr();

  assert(getFunction()->empty() && "Translating into non-empty function!");

  getFunction()->setDoesNotAlias(1);
  getFunction()->setDoesNotCapture(1);

  // Create the entry and exit basic blocks.
  auto *EntryBB = BasicBlock::Create(
      getContext(), "entry_fn_" + utohexstr(StartAddr), getFunction());
  ExitBB = BasicBlock::Create(getContext(), "exit_fn_" + utohexstr(StartAddr),
                              getFunction());

  // Prepare the entry/exit blocks.
  IRBuilder<> EntryBuilder(EntryBB);
  IRBuilder<> ExitBuilder(ExitBB);

  if (EnableRegSetDiff) {
    Value *SavedRegSet = EntryBuilder.CreateAlloca(getDRS().getRegSetType());
    Value *RegSetArg = &getFunction()->getArgumentList().front();

    // First, save the previous regset in the entry block.
    EntryBuilder.CreateStore(EntryBuilder.CreateLoad(RegSetArg), SavedRegSet);

    // Second, insert a call to the diff function, in a separate exit block.
    // Move the return to that block, and branch to it from ExitBB.
    auto *DiffExitBB = BasicBlock::Create(
        getContext(), "diff_exit_fn_" + utohexstr(StartAddr), getFunction());

    ExitBuilder.CreateBr(DiffExitBB);
    ExitBuilder.SetInsertPoint(DiffExitBB);

    Value *FnAddr = ExitBuilder.CreateIntToPtr(
        ExitBuilder.getInt64(reinterpret_cast<uint64_t>(StartAddr)),
        ExitBuilder.getInt8PtrTy());

    ExitBuilder.CreateCall(getDRS().getOrCreateRegSetDiffFunction(),
                           {FnAddr, SavedRegSet, RegSetArg});
  }

  // Create a ret void in the exit basic block.
  ExitBuilder.CreateRetVoid();

  // Create a br from the entry basic block to the first basic block, at
  // StartAddr.
  EntryBuilder.CreateBr(getOrCreateBasicBlock(StartAddr));

  getDRS().SwitchToFunction(getFunction());
}

DCFunction::~DCFunction() {
  for (auto CallI : Calls) {
    getDRS().saveAllLocalRegs(CallI->getParent(), CallI);
    getDRS().restoreLocalRegs(CallI->getParent(), ++CallI);
  }

  getDRS().FinalizeFunction(ExitBB);
}

void DCFunction::createExternalTailCallBB(uint64_t Addr) {
  // First create a basic block for the tail call.
  auto *TCBB = getOrCreateBasicBlock(Addr);
  IRBuilder<> TCBuilder(TCBB);

  // Now do the call to that function.
  Value *RegSetArg = &getFunction()->getArgumentList().front();
  auto *CI = TCBuilder.CreateCall(DCM.getOrCreateFunction(Addr), {RegSetArg});
  addCallForRegSetSaveRestore(CI);

  // FIXME: should this still insert a regset diffing call?
  // Finally, return directly, bypassing the ExitBB.
  TCBuilder.CreateRetVoid();
}

BasicBlock *DCFunction::getOrCreateBasicBlock(uint64_t Addr) {
  BasicBlock *&BB = BBByAddr[Addr];
  if (!BB) {
    BB = BasicBlock::Create(getContext(), "bb_" + utohexstr(Addr),
                            getFunction());
    IRBuilder<> BBBuilder(BB);
    BBBuilder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::trap));
    BBBuilder.CreateUnreachable();
  }
  return BB;
}

void DCFunction::addCallForRegSetSaveRestore(CallInst *CI) {
  Calls.push_back(CI->getIterator());
}
