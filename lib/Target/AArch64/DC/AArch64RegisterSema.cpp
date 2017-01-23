//===-- AArch64RegisterSema.cpp - AArch64 DC Register Semantics ---------*- C++
//-*-===//
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
#include "llvm/DC/DCRegisterSetDesc.h"
#include "llvm/IR/Intrinsics.h"

using namespace llvm;

#define DEBUG_TYPE "aarch64-dc-regsema"

AArch64RegisterSema::AArch64RegisterSema(LLVMContext &Ctx,
                                         const MCRegisterInfo &MRI,
                                         const MCInstrInfo &MII,
                                         const DataLayout &DL,
                                         const DCRegisterSetDesc &RegSetDesc)
    : DCRegisterSema(Ctx, MRI, MII, DL, RegSetDesc) {}

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

void AArch64RegisterSema::insertExternalWrapperAsm(BasicBlock *WrapperBB,
                                                   Value *ExtFn) {
  llvm_unreachable("Implement");
}
