//===-- AArch64DCModule.cpp - AArch64 Module Translation ----------------*- C++
//-*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AArch64DCModule.h"
#include "MCTargetDesc/AArch64MCTargetDesc.h"
#include "llvm/DC/DCRegisterSetDesc.h"
#include "llvm/DC/DCTranslator.h"
#include "llvm/IR/IRBuilder.h"

using namespace llvm;

AArch64DCModule::AArch64DCModule(DCTranslator &DCT, Module &M)
    : DCModule(DCT, M) {}

// FIXME: What about using the stuff in CallingConvLower.h?
void AArch64DCModule::insertCodeForInitRegSet(BasicBlock *InsertAtEnd,
                                              Value *RegSet, Value *StackPtr,
                                              Value *StackSize, Value *ArgC,
                                              Value *ArgV) {
  IRBuilder<> Builder(InsertAtEnd);
  Type *I64Ty = Builder.getInt64Ty();

  // Initialize SP to point to the end of the stack
  Value *SP = Builder.CreatePtrToInt(StackPtr, I64Ty);
  SP = Builder.CreateAdd(SP, Builder.CreateZExtOrBitCast(StackSize, I64Ty));

  // push ~0 to simulate a call
  SP = Builder.CreateSub(SP, Builder.getInt64(8));
  Builder.CreateStore(Builder.getInt(APInt::getAllOnesValue(64)),
                      Builder.CreateIntToPtr(SP, I64Ty->getPointerTo()));

  auto InitRegTo = [&](unsigned RegNo, Value *Val) {
    unsigned RegLargestSuper =
        getTranslator().getRegSetDesc().RegLargestSupers[RegNo];
    assert(RegLargestSuper == RegNo);
    unsigned RegOffsetInSet =
        getTranslator().getRegSetDesc().RegOffsetsInSet[RegLargestSuper];
    Value *Idx[] = {Builder.getInt32(0), Builder.getInt32(RegOffsetInSet)};
    Builder.CreateStore(Val, Builder.CreateInBoundsGEP(RegSet, Idx));
  };

  // put a pointer to the test stack in SP
  InitRegTo(AArch64::SP, SP);
  // ac comes in X0
  InitRegTo(AArch64::X0, Builder.CreateZExt(ArgC, Builder.getInt64Ty()));
  // av comes in X1
  InitRegTo(AArch64::X1, Builder.CreatePtrToInt(ArgV, Builder.getInt64Ty()));

  // FIXME: Initialize NZCV?
}

Value *AArch64DCModule::insertCodeForFiniRegSet(BasicBlock *InsertAtEnd,
                                                Value *RegSet) {
  IRBuilder<> Builder(InsertAtEnd);

  // Result comes out of W0
  Value *Idx[] = {Builder.getInt32(0), 0};
  Idx[1] = Builder.getInt32(
      getTranslator().getRegSetDesc().RegOffsetsInSet
          [getTranslator().getRegSetDesc().RegLargestSupers[AArch64::W0]]);
  return Builder.CreateTrunc(
      Builder.CreateLoad(Builder.CreateInBoundsGEP(RegSet, Idx)),
      Builder.getInt32Ty());
}

void AArch64DCModule::insertExternalWrapperAsm(BasicBlock *InsertAtEnd,
                                               Value *ExternalFunc,
                                               Value *RegSet) {
  llvm_unreachable("Implement");
}
