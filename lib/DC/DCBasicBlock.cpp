//===-- lib/DC/DCBasicBlock.cpp - Basic Block Translation -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCBasicBlock.h"
#include "llvm/DC/RegisterValueUtils.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Instructions.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "dc-sema"

namespace llvm {
extern cl::opt<bool> EnableMockIntrin;
}

DCBasicBlock::DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB)
    : DCF(DCF), TheBB(*DCF.getOrCreateBasicBlock(MCB.getStartAddr())),
      TheMCBB(MCB), RegValues(getTranslator().getMRI().getNumRegs()),
      Builder(&TheBB) {
  // Remove the @llvm.trap(), but keep the unreachable, to use as an insertion
  // point for our builder.
  assert(
      (TheBB.size() == 2 && isa<UnreachableInst>(std::next(TheBB.begin()))) &&
      "Several BBs at the same address?");
  TheBB.begin()->eraseFromParent();

  Builder.SetInsertPoint(TheBB.getTerminator());

  // The PC at the start of the basic block is known, just set it.
  const unsigned PC = getTranslator().getMRI().getProgramCounter();
  auto *PCIntTy = IntegerType::get(
      getContext(), getTranslator().getRegSetDesc().RegSizes[PC]);
  setReg(PC, ConstantInt::get(PCIntTy, TheMCBB.getStartAddr()));
}

DCBasicBlock::~DCBasicBlock() {
  // Erase the 'unreachable' terminator.
  TheBB.back().eraseFromParent();

  // If we didn't translate a branch, fallthrough to the next block.
  if (!TheBB.getTerminator())
    BranchInst::Create(DCF.getOrCreateBasicBlock(TheMCBB.getEndAddr()),
                       getBasicBlock());
  Builder.SetInsertPoint(TheBB.getTerminator());

  // Finally, save the last assigned value of each register to its alloca.
  saveAllLiveRegs();
}

void DCBasicBlock::saveAllLiveRegs() {
  for (unsigned RI = 1, RE = RegValues.size(); RI != RE; ++RI) {
    // Make sure to flush any pending registers.
    materializeRegister(RI);

    // If the register is live, save it to its alloca.
    auto *RegValue = RegValues[RI];
    if (!RegValue)
      continue;
    auto *RegAlloca = DCF.getOrCreateRegAlloca(RI);
    Builder.CreateStore(
        Builder.CreateBitCast(RegValue, RegAlloca->getAllocatedType()),
        RegAlloca);
    RegValues[RI] = 0;
  }
}

void DCBasicBlock::setReg(unsigned RegNo, Value *Val) {
  if (EnableMockIntrin) {
    auto &MRI = getTranslator().getMRI();
    Value *MDRegName = MetadataAsValue::get(
        getContext(), MDString::get(getContext(), MRI.getName(RegNo)));
    Function *SetRegIntrin = Intrinsic::getDeclaration(
        getModule(), Intrinsic::dc_setreg, Val->getType());
    // FIXME: val type or regtype?
    Builder.CreateCall(SetRegIntrin, {Val, MDRegName});
    return;
  }

  dematerializeRegister(RegNo, Val);

  DCF.getOrCreateRegAlloca(RegNo);

  RegValues[RegNo] = Val;
  if (!Val->hasName()) {
    auto &MRI = getTranslator().getMRI();
    Val->setName((Twine(MRI.getName(RegNo)) + "_" +
                  utostr(DCF.incrementRegDefCount(RegNo)))
                     .str());
  }
}

Value *DCBasicBlock::getReg(unsigned RegNo) {
  if (EnableMockIntrin) {
    auto &MRI = getTranslator().getMRI();
    auto &RSD = getTranslator().getRegSetDesc();
    Value *MDRegName = MetadataAsValue::get(
        getContext(), MDString::get(getContext(), MRI.getName(RegNo)));
    Function *GetRegIntrin = Intrinsic::getDeclaration(
        getModule(), Intrinsic::dc_getreg, RSD.RegTypes[RegNo]);
    return Builder.CreateCall(GetRegIntrin, MDRegName);
  }

  materializeRegister(RegNo);

  Value *RV = RegValues[RegNo];

  // Return the last assigned value if there is any.
  if (RV)
    return RV;

  auto &MRI = getTranslator().getMRI();
  auto &RSD = getTranslator().getRegSetDesc();

  // Otherwise, the register has never been assigned to in the block.
  // If it has a super-register, extract from that.
  const unsigned LargestSuper = RSD.RegLargestSupers[RegNo];
  if (LargestSuper != RegNo) {
    auto *LargestSuperVal = getReg(LargestSuper);

    auto *RegIntTy = IntegerType::get(getContext(), RSD.RegSizes[RegNo]);
    auto *RegTy = RSD.RegTypes[RegNo];
    if (!RegTy)
      RegTy = RegIntTy;

    RV = llvm::extractSubRegFromSuper(Builder.saveIP(), MRI, LargestSuper,
                                      RegNo, LargestSuperVal);
  } else {
    // Otherwise, it's the largest super-register.  Load it from the
    // function-level alloca.
    RV = Builder.CreateLoad(DCF.getOrCreateRegAlloca(RegNo));
  }

  // Finally, assign the value to the register.
  // Use setReg() to also give it a name.
  setReg(RegNo, RV);
  return RV;
}
