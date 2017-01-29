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
#include "llvm/DC/RegisterValueUtils.h"
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
#include "llvm/MC/MCRegisterInfo.h"
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
    Type *RegSetTy = getTranslator().getRegSetDesc().RegSetType;
    Value *SavedRegSet = EntryBuilder.CreateAlloca(RegSetTy);
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

    ExitBuilder.CreateCall(DCM.getOrCreateRegSetDiffFunction(),
                           {FnAddr, SavedRegSet, RegSetArg});
  }

  // Create a ret void in the exit basic block.
  ExitBuilder.CreateRetVoid();

  // Create a br from the entry basic block to the first basic block, at
  // StartAddr.
  EntryBuilder.CreateBr(getOrCreateBasicBlock(StartAddr));

  // Prepare the register state.
  const unsigned NumRegs = getTranslator().getMRI().getNumRegs();
  RegPtrs.resize(NumRegs);
  RegAllocas.resize(NumRegs);
  RegInits.resize(NumRegs);
  RegDefCount.resize(NumRegs);
}

DCFunction::~DCFunction() {
  for (auto CallI : Calls) {
    saveLocalRegs(CallI->getParent(), CallI);
    restoreLocalRegs(CallI->getParent(), ++CallI);
  }
  saveLocalRegs(ExitBB, ExitBB->getTerminator()->getIterator());
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

void DCFunction::saveLocalRegs(BasicBlock *BB, BasicBlock::iterator IP) {
  IRBuilder<> LocalBuilder(BB, IP);
  auto &RSD = getTranslator().getRegSetDesc();

  for (unsigned RI = 1, RE = RegAllocas.size(); RI != RE; ++RI) {
    if (!RegAllocas[RI])
      continue;
    int OffsetInSet = RSD.RegOffsetsInSet[RI];
    if (OffsetInSet != -1)
      LocalBuilder.CreateStore(LocalBuilder.CreateLoad(RegAllocas[RI]),
                               RegPtrs[RI]);
  }
}

void DCFunction::restoreLocalRegs(BasicBlock *BB, BasicBlock::iterator IP) {
  IRBuilder<> LocalBuilder(BB, IP);
  auto &RSD = getTranslator().getRegSetDesc();

  for (unsigned RI = 1, RE = RegAllocas.size(); RI != RE; ++RI) {
    if (!RegAllocas[RI])
      continue;
    int OffsetInSet = RSD.RegOffsetsInSet[RI];
    if (OffsetInSet != -1)
      LocalBuilder.CreateStore(LocalBuilder.CreateLoad(RegPtrs[RI]),
                               RegAllocas[RI]);
  }
}

unsigned DCFunction::incrementRegDefCount(unsigned RegNo) {
  return RegDefCount[RegNo]++;
}

AllocaInst *DCFunction::getOrCreateRegAlloca(unsigned RegNo) {
  AllocaInst *&RA = RegAllocas[RegNo];

  // If we already have an alloca, nothing to do here.
  if (RA)
    return RA;

  auto &MRI = getTranslator().getMRI();
  auto &RSD = getTranslator().getRegSetDesc();
  StringRef RegName = MRI.getName(RegNo);
  Value *&RP = RegPtrs[RegNo];
  Value *&RI = RegInits[RegNo];

  assert(RP == 0 && "Register has a pointer but no alloca!");
  assert(RI == 0 && "Register has an init value but no alloca!");

  BasicBlock *EntryBB = &TheFunction.getEntryBlock();
  IRBuilder<> Builder(EntryBB, EntryBB->getTerminator()->getIterator());

  const unsigned LargestSuper = RSD.RegLargestSupers[RegNo];

  auto *RegIntTy = IntegerType::get(getContext(), RSD.RegSizes[RegNo]);
  auto *RegTy = RSD.RegTypes[RegNo];
  if (!RegTy)
    RegTy = RegIntTy;

  if (LargestSuper != RegNo) {
    // If the register has a super-register, extract from the largest super,
    // directly from the regset.

    // Make sure the super-register itself has an alloca (and an init value).
    getOrCreateRegAlloca(LargestSuper);
    auto *LargestSuperInitVal = RegInits[LargestSuper];
    assert(LargestSuperInitVal != 0 && "Super-register non initialized!");

    // Extract from the super-register, to initialize our register.
    RI = llvm::extractSubRegFromSuper(Builder.saveIP(), MRI, LargestSuper,
                                      RegNo, LargestSuperInitVal);

    // And give it the proper type.
    RI = Builder.CreateBitCast(RI, RegTy);
  } else {
    // Else, it should be in the regset, load it from there.
    // Get the regset pointer argument.
    Value *RegSetArg = &TheFunction.getArgumentList().front();

    // Get the offset of our largest super-register into the regset.
    int OffsetInRegSet = RSD.RegOffsetsInSet[RegNo];
    assert(OffsetInRegSet != -1 && "Getting a register not in the regset!");

    // Compute the pointer to our largest super-register's entry in the regset.
    RP = Builder.CreateInBoundsGEP(
        RegSetArg, {Builder.getInt32(0), Builder.getInt32(OffsetInRegSet)});
    RP->setName((RegName + "_ptr").str());

    // Finally, extract the register's value from the incoming regset.
    RI = Builder.CreateLoad(RegTy, RP);
  }

  // At this point, we have an initial (entry-block) value for our register.
  // Name it.
  RI->setName((RegName + "_init").str());

  // Then, create an alloca for the register.
  RA = Builder.CreateAlloca(RI->getType());
  RA->setName(RegName);

  // Finally, initialize the local copy of the register.
  Builder.CreateStore(RI, RA);
  return RA;
}
