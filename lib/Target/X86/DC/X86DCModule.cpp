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
#include "llvm/IR/Constants.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InlineAsm.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/raw_ostream.h"

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

void X86DCModule::insertExternalWrapperAsm(BasicBlock *InsertAtEnd,
                                           Value *ExternalFunc, Value *RegSet) {
  IRBuilder<> Builder(InsertAtEnd);
  auto &DCT = getTranslator();
  auto &DL = DCT.getDataLayout();

  auto getRegOffset = [&](unsigned Reg) {
    return DCT.getRegSetDesc()
        .getRegSizeOffsetInRegSet(Reg, DL, DCT.getMRI())
        .second;
  };

  std::string IAStr;
  raw_string_ostream(IAStr)
      << "mov $0, %r12  \n" // r12 <- regset
      << "mov $1, %r13  \n" // r13 <- fn
      << "mov %rsp, %r14\n" // r14 <- old_sp

      // switch to regset sp
      << "mov " << getRegOffset(X86::RSP) << "(%r12), %rsp  \n"

      // "pop" the return address
      << "pop %rax                                          \n"
      << "mov %rax, " << getRegOffset(X86::RIP) << "(%r12)  \n"

      << "mov " << getRegOffset(X86::RDI) << "(%r12), %rdi  \n"
      << "mov " << getRegOffset(X86::RSI) << "(%r12), %rsi  \n"
      << "mov " << getRegOffset(X86::RDX) << "(%r12), %rdx  \n"
      << "mov " << getRegOffset(X86::RCX) << "(%r12), %rcx  \n"
      << "mov " << getRegOffset(X86::R8) << "(%r12), %r8   \n"
      << "mov " << getRegOffset(X86::R9) << "(%r12), %r9   \n"

      << "movaps " << getRegOffset(X86::XMM0) << "(%r12), %xmm0 \n"
      << "movaps " << getRegOffset(X86::XMM1) << "(%r12), %xmm1 \n"
      << "movaps " << getRegOffset(X86::XMM2) << "(%r12), %xmm2 \n"
      << "movaps " << getRegOffset(X86::XMM3) << "(%r12), %xmm3 \n"
      << "movaps " << getRegOffset(X86::XMM4) << "(%r12), %xmm4 \n"
      << "movaps " << getRegOffset(X86::XMM5) << "(%r12), %xmm5 \n"
      << "movaps " << getRegOffset(X86::XMM6) << "(%r12), %xmm6 \n"
      << "movaps " << getRegOffset(X86::XMM7) << "(%r12), %xmm7 \n"

      // used for vararg sse count
      << "mov " << getRegOffset(X86::RAX) << "(%r12), %rax   \n"

      << "call *%r13\n"

      << "mov %rax, " << getRegOffset(X86::RAX) << "(%r12)   \n"
      << "mov %rdx, " << getRegOffset(X86::RDX) << "(%r12)   \n"

      << "movaps %xmm0, " << getRegOffset(X86::XMM0) << "(%r12) \n"
      << "movaps %xmm1, " << getRegOffset(X86::XMM1) << "(%r12) \n"
      << "movaps %xmm2, " << getRegOffset(X86::XMM2) << "(%r12) \n"
      << "movaps %xmm3, " << getRegOffset(X86::XMM3) << "(%r12) \n"
      << "movaps %xmm4, " << getRegOffset(X86::XMM4) << "(%r12) \n"
      << "movaps %xmm5, " << getRegOffset(X86::XMM5) << "(%r12) \n"
      << "movaps %xmm6, " << getRegOffset(X86::XMM6) << "(%r12) \n"
      << "movaps %xmm7, " << getRegOffset(X86::XMM7) << "(%r12) \n"

      << "mov %rsp, " << getRegOffset(X86::RSP) << "(%r12)      \n"

      // restore old_sp
      << "mov %r14, %rsp\n";

  Type *IAArgTypes[] = {RegSet->getType(), ExternalFunc->getType()};
  InlineAsm *IA = InlineAsm::get(
      FunctionType::get(Builder.getVoidTy(), IAArgTypes, /*isVarArg=*/false),
      IAStr, "r,r,"
             "~{rax},~{rdi},~{rsi},~{rdx},~{rcx},~{r8},"
             "~{r9},~{r10},~{r11},~{r12},~{r13},~{r14},"
             "~{xmm0},~{xmm1},~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7}",
      /*hasSideEffects=*/true, /*isAlignStack=*/false);

  Builder.CreateCall(IA, {RegSet, ExternalFunc});
}
