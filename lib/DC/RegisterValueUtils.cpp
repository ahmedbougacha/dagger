//===-- lib/DC/RegisterValueUtils.cpp - Utility functions --------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/RegisterValueUtils.h"
#include "llvm/ADT/APInt.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Value.h"
#include "llvm/MC/MCRegisterInfo.h"

using namespace llvm;

Value *llvm::extractSubRegFromSuper(IRBuilderBase::InsertPoint InsertPt,
                                    const MCRegisterInfo &MRI, unsigned Super,
                                    unsigned Sub, Value *SRV) {
  auto &Ctx = SRV->getContext();
  IRBuilder<> Builder(Ctx);
  Builder.restoreIP(InsertPt);

  unsigned Idx = MRI.getSubRegIndex(Super, Sub);
  assert(Idx && "Superreg's subreg doesn't have an index?");
  unsigned Offset = MRI.getSubRegIdxOffset(Idx),
           Size = MRI.getSubRegIdxSize(Idx);
  if (Offset == (unsigned)-1 || Size == (unsigned)-1)
    llvm_unreachable("Used subreg index doesn't cover a bit range?");

  assert(SRV && "Can't extract subreg from nil super value!");

  Type *SRVIntTy =
      IntegerType::get(Ctx, SRV->getType()->getPrimitiveSizeInBits());
  SRV = Builder.CreateBitCast(SRV, SRVIntTy);

  return llvm::extractBitsFromValue(InsertPt, Offset, Size, SRV);
}

Value *llvm::recreateSuperRegFromSub(IRBuilderBase::InsertPoint InsertPt,
                                     const MCRegisterInfo &MRI, unsigned Super,
                                     unsigned Sub, Value *SuperVal,
                                     Value *SubVal, bool ClearSuper) {
  auto &Ctx = SuperVal->getContext();
  IRBuilder<> Builder(Ctx);
  Builder.restoreIP(InsertPt);

  unsigned Idx = MRI.getSubRegIndex(Super, Sub);
  assert(Idx && "Superreg's subreg doesn't have an index?");
  unsigned Offset = MRI.getSubRegIdxOffset(Idx),
           Size = MRI.getSubRegIdxSize(Idx);
  if (Offset == (unsigned)-1 || Size == (unsigned)-1)
    llvm_unreachable("Used subreg index doesn't cover a bit range?");

  return llvm::insertBitsInValue(InsertPt, SuperVal, SubVal, Offset,
                                 ClearSuper);
}

Value *llvm::extractBitsFromValue(IRBuilderBase::InsertPoint InsertPt,
                                  unsigned LoBit, unsigned NumBits,
                                  Value *Val) {
  auto &Ctx = Val->getContext();
  IRBuilder<> Builder(Ctx);
  Builder.restoreIP(InsertPt);

  Value *LShr = Val;
  if (LoBit)
    LShr = Builder.CreateLShr(Val, ConstantInt::get(Val->getType(), LoBit));
  return Builder.CreateTruncOrBitCast(LShr, IntegerType::get(Ctx, NumBits));
}

Value *llvm::insertBitsInValue(IRBuilderBase::InsertPoint InsertPt,
                               Value *FullVal, Value *ToInsert, unsigned Offset,
                               bool ClearOldValue) {
  auto &Ctx = FullVal->getContext();
  IRBuilder<> Builder(Ctx);
  Builder.restoreIP(InsertPt);

  IntegerType *ValType = cast<IntegerType>(FullVal->getType());
  IntegerType *ToInsertType = cast<IntegerType>(ToInsert->getType());

  Value *Cast = Builder.CreateZExtOrBitCast(ToInsert, ValType);
  if (Offset)
    Cast = Builder.CreateShl(Cast, ConstantInt::get(Cast->getType(), Offset));

  // If we clear FullVal, then this is enough, we don't need to use it.
  if (ClearOldValue)
    return Cast;

  APInt Mask = ~APInt::getBitsSet(ValType->getBitWidth(), Offset,
                                  Offset + ToInsertType->getBitWidth());
  return Builder.CreateOr(
      Cast, Builder.CreateAnd(FullVal, ConstantInt::get(ValType, Mask)));
}

