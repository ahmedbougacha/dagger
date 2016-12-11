//===-- AArch64RegisterSema.h - AArch64 DC Register Semantics ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_DC_AARCH64REGISTERSEMA_H
#define LLVM_LIB_TARGET_AARCH64_DC_AARCH64REGISTERSEMA_H

#include "AArch64InstrInfo.h"
#include "llvm/DC/DCRegisterSema.h"

namespace llvm {

class DataLayout;
class LLVMContext;
class MCInstrInfo;
class MCRegisterInfo;

class AArch64RegisterSema : public DCRegisterSema {
public:
  AArch64RegisterSema(LLVMContext &Ctx, const MCRegisterInfo &MRI,
                      const MCInstrInfo &MII, const DataLayout &DL);

  bool doesSubRegIndexClearSuper(unsigned Idx) const override;

  void insertInitRegSetCode(Function *InitFn) override;
  void insertFiniRegSetCode(Function *FiniFn) override;

  void insertExternalWrapperAsm(BasicBlock *WrapperBB, Value *ExtFn) override;
};

} // end namespace llvm

#endif
