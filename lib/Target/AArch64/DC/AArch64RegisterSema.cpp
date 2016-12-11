//===-- AArch64RegisterSema.cpp - AArch64 DC Register Semantics ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AArch64RegisterSema.h"
#include "AArch64.h"
#include "AArch64InstrInfo.h"
#include "llvm/IR/Intrinsics.h"

#define GET_REGISTER_SEMA
#include "AArch64GenSema.inc"
using namespace llvm;

#define DEBUG_TYPE "aarch64-dc-regsema"

AArch64RegisterSema::AArch64RegisterSema(LLVMContext &Ctx,
                                         const MCRegisterInfo &MRI,
                                         const MCInstrInfo &MII,
                                         const DataLayout &DL)
    : DCRegisterSema(Ctx, MRI, MII, DL, AArch64::RegClassVTs) {
  RegConstantVals[AArch64::XZR] =
      Constant::getNullValue(IntegerType::get(Ctx, 64));
  RegConstantVals[AArch64::WZR] =
      Constant::getNullValue(IntegerType::get(Ctx, 32));
}

bool AArch64RegisterSema::doesSubRegIndexClearSuper(unsigned Idx) const {
  switch (Idx) {
  case AArch64::sub_32:
  case AArch64::bsub:
  case AArch64::hsub:
  case AArch64::ssub:
  case AArch64::dsub:
    return true;
  }
  return false;
}

// FIXME: What about using the stuff in CallingConvLower.h?
void AArch64RegisterSema::insertInitRegSetCode(Function *InitFn) {
  IRBuilderBase::InsertPointGuard IPG(*Builder);
  Type *I64Ty = Builder->getInt64Ty();
  Builder->SetInsertPoint(BasicBlock::Create(Ctx, "", InitFn));

  Function::arg_iterator ArgI = InitFn->getArgumentList().begin();
  Value *RegSet = &*ArgI++;
  Value *StackPtr = &*ArgI++;
  Value *StackSize = &*ArgI++;
  Value *ArgC = &*ArgI++;
  Value *ArgV = &*ArgI++;

  // Initialize SP to point to the end of the stack
  Value *SP = Builder->CreatePtrToInt(StackPtr, I64Ty);
  SP = Builder->CreateAdd(SP, Builder->CreateZExtOrBitCast(StackSize, I64Ty));

  // push ~0 to simulate a call
  SP = Builder->CreateSub(SP, Builder->getInt64(8));
  Builder->CreateStore(Builder->getInt(APInt::getAllOnesValue(64)),
                       Builder->CreateIntToPtr(SP, I64Ty->getPointerTo()));

  auto InitRegTo = [&](unsigned RegNo, Value *Val) {
    unsigned RegLargestSuper = RegLargestSupers[RegNo];
    assert(RegLargestSuper == RegNo);
    unsigned RegOffsetInSet = RegOffsetsInSet[RegLargestSuper];
    Value *Idx[] = {Builder->getInt32(0), Builder->getInt32(RegOffsetInSet)};
    Builder->CreateStore(Val, Builder->CreateInBoundsGEP(RegSet, Idx));
  };

  // put a pointer to the test stack in SP
  InitRegTo(AArch64::SP, SP);
  // ac comes in X0
  InitRegTo(AArch64::X0, Builder->CreateZExt(ArgC, Builder->getInt64Ty()));
  // av comes in X1
  InitRegTo(AArch64::X1, Builder->CreatePtrToInt(ArgV, Builder->getInt64Ty()));

  // FIXME: Initialize NZCV?

  Builder->CreateRetVoid();
}

void AArch64RegisterSema::insertFiniRegSetCode(Function *FiniFn) {
  IRBuilderBase::InsertPointGuard IPG(*Builder);
  Value *Idx[] = {Builder->getInt32(0), 0};
  Builder->SetInsertPoint(BasicBlock::Create(Ctx, "", FiniFn));

  Function::arg_iterator ArgI = FiniFn->getArgumentList().begin();
  Value *RegSet = &*ArgI;

  // Result comes out of W0
  Idx[1] = Builder->getInt32(RegOffsetsInSet[RegLargestSupers[AArch64::W0]]);
  Builder->CreateRet(Builder->CreateTrunc(
      Builder->CreateLoad(Builder->CreateInBoundsGEP(RegSet, Idx)),
      Builder->getInt32Ty()));
}

void AArch64RegisterSema::insertExternalWrapperAsm(BasicBlock *WrapperBB,
                                                   Value *ExtFn) {
  llvm_unreachable("Implement");
}
