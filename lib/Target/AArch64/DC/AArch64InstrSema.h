//===-- AArch64InstrSema.h - AArch64 DC Instruction Semantics ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_DC_AARCH64INSTRSEMA_H
#define LLVM_LIB_TARGET_AARCH64_DC_AARCH64INSTRSEMA_H

#include "llvm/DC/DCInstrSema.h"
#include "llvm/Support/Compiler.h"

namespace llvm {

class AArch64RegisterSema;

class AArch64InstrSema : public DCInstrSema {
  // FIXME: This goes away once we have something like TargetMachine.
  AArch64RegisterSema &AArch64DRS;

public:
  AArch64InstrSema(DCRegisterSema &DRS);

  bool translateTargetInst() override;
  bool translateTargetOpcode(unsigned Opcode) override;
  Value *translateComplexPattern(unsigned CP) override;
  Value *translateCustomOperand(unsigned OperandType,
                                unsigned MIOperandNo) override;
  bool translateImplicit(unsigned RegNo) override;
};

} // end namespace llvm

#endif
