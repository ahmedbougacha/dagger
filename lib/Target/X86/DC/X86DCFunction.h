//===-- X86DCFunction.h - X86 Function Translation --------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_X86_DC_X86INSTRSEMA_H
#define LLVM_LIB_TARGET_X86_DC_X86INSTRSEMA_H

#include "llvm/DC/DCFunction.h"
#include "llvm/Support/Compiler.h"

namespace llvm {
namespace X86DCISD {
enum {
  FIRST_NUMBER = DCINS::FIRST_TARGET_DC_OPCODE,
  IDIV,
  DIV,
  // Variants for 8bit division (AX div r/m8)
  IDIV8,
  DIV8
};
} // end namespace X86DCISD

class X86RegisterSema;

class X86DCFunction : public DCFunction {
  // FIXME: This goes away once we have something like TargetMachine.
  X86RegisterSema &X86DRS;

  // Prefix instruction encoutered just before. This changes the behavior
  // of translateTargetInst to take into account the prefix.
  // FIXME: Should we instead support this in DCFunction, so we can directly
  // ask for the next instruction?
  unsigned LastPrefix;

public:
  X86DCFunction(DCModule &DCM, const MCFunction &MCF, DCRegisterSema &DRS);

  bool translateTargetOpcode(unsigned Opcode) override;
  Value *translateCustomOperand(unsigned OperandType,
                                unsigned MIOperandNo) override;
  bool translateImplicit(unsigned RegNo) override;

  bool translateTargetInst() override;

private:
  Value *translateAddr(unsigned MIOperandNo,
                       MVT::SimpleValueType VT = MVT::iPTRAny);
  Value *translateMemOffset(unsigned MIOperandNo, MVT::SimpleValueType VT);

  void translatePush(Value *Val);
  Value *translatePop(unsigned SizeInBytes);

  void translateDivRem(bool isThreeOperand, bool isSigned);
  void translateHorizontalBinop(Instruction::BinaryOps BinOp);

  void translateShuffle(SmallVectorImpl<int> &Mask, Value *V1,
                        Value *V2 = nullptr);
  Value *translatePSHUFB(Value *V, Value *Mask);

  void translateCMPXCHG(unsigned MemOpType, unsigned CmpReg);
};

} // end namespace llvm

#endif
