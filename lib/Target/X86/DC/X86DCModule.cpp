//===-- X86DCModule.cpp - X86 Module Translation ----------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "X86DCModule.h"
#include "MCTargetDesc/X86MCTargetDesc.h"
#include "llvm/DC/DCRegisterSetDesc.h"
#include "llvm/DC/DCTranslator.h"
#include "llvm/IR/IRBuilder.h"

using namespace llvm;

X86DCModule::X86DCModule(DCTranslator &DCT, Module &M) : DCModule(DCT, M) {}

// FIXME: this is all very much amd64 sysv specific
// What about using the stuff in CallingConvLower.h?
void X86DCModule::insertCodeForInitRegSet(BasicBlock *InsertAtEnd,
                                          Value *RegSet, Value *StackPtr,
                                          Value *StackSize, Value *ArgC,
                                          Value *ArgV) {
  IRBuilder<> Builder(InsertAtEnd);
  Type *I64Ty = Builder.getInt64Ty();

  // Initialize RSP to point to the end of the stack
  Value *RSP = Builder.CreatePtrToInt(StackPtr, I64Ty);
  RSP = Builder.CreateAdd(RSP, Builder.CreateZExtOrBitCast(StackSize, I64Ty));

  // push ~0 to simulate a call
  RSP = Builder.CreateSub(RSP, Builder.getInt64(8));
  Builder.CreateStore(Builder.getInt(APInt::getAllOnesValue(64)),
                      Builder.CreateIntToPtr(RSP, I64Ty->getPointerTo()));

  auto InitRegTo = [&](unsigned RegNo, Value *Val) {
    unsigned RegLargestSuper =
        getTranslator().getRegSetDesc().RegLargestSupers[RegNo];
    assert(RegLargestSuper == RegNo);
    unsigned RegOffsetInSet =
        getTranslator().getRegSetDesc().RegOffsetsInSet[RegLargestSuper];
    Value *Idx[] = {Builder.getInt32(0), Builder.getInt32(RegOffsetInSet)};
    Builder.CreateStore(Val, Builder.CreateInBoundsGEP(RegSet, Idx));
  };

  // put a pointer to the test stack in RSP
  InitRegTo(X86::RSP, RSP);
  // ac comes in EDI
  InitRegTo(X86::RDI, Builder.CreateZExt(ArgC, Builder.getInt64Ty()));
  // av comes in RSI
  InitRegTo(X86::RSI, Builder.CreatePtrToInt(ArgV, Builder.getInt64Ty()));
  // Initialize EFLAGS to 0x202 (empirical).
  InitRegTo(X86::EFLAGS, Builder.getInt32(0x202));
  InitRegTo(X86::CtlSysEFLAGS, Builder.getInt32(0x202));
}

Value *X86DCModule::insertCodeForFiniRegSet(BasicBlock *InsertAtEnd,
                                            Value *RegSet) {
  IRBuilder<> Builder(InsertAtEnd);

  // Result comes out of EAX
  Value *Idx[2];
  Idx[0] = Builder.getInt32(0);
  Idx[1] = Builder.getInt32(
      getTranslator().getRegSetDesc().RegOffsetsInSet
          [getTranslator().getRegSetDesc().RegLargestSupers[X86::EAX]]);

  return Builder.CreateTrunc(
      Builder.CreateLoad(Builder.CreateInBoundsGEP(RegSet, Idx)),
      Builder.getInt32Ty());
}
