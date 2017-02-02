//===-- X86DCInstruction.h - X86 Targeting of DCInstruction -----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_X86_X86DCINSTRUCTION_H
#define LLVM_LIB_TARGET_X86_X86DCINSTRUCTION_H

#include "X86DCBasicBlock.h"
#include "llvm/DC/DCInstruction.h"

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

class X86DCInstruction final : public DCInstruction {
public:
  X86DCInstruction(DCBasicBlock &DCB, const MCDecodedInst &MCI);

  X86DCBasicBlock &getParent() {
    return static_cast<X86DCBasicBlock &>(DCInstruction::getParent());
  }

protected:
  bool translateTargetOpcode(unsigned Opcode) override;
  Value *translateCustomOperand(unsigned OperandType,
                                unsigned MIOperandNo) override;
  bool translateImplicit(unsigned RegNo) override;

  bool translateTargetInst() override;

  bool doesSubRegIndexClearSuper(unsigned SubRegIdx) override;

  StringRef getDCOpcodeName(unsigned Opcode) const override;
  StringRef getDCCustomOpName(unsigned OperandKind) const override;
  StringRef getDCPredicateName(unsigned PredicateKind) const override;
  StringRef getDCComplexPatternName(unsigned CPKind) const override;

private:
  Value *translateAddr(unsigned MIOperandNo,
                       MVT::SimpleValueType VT = MVT::iPTRAny);
  Value *translateMemOffset(unsigned MIOperandNo, MVT::SimpleValueType VT);

  void translatePush(Value *Val);
  Value *translatePop(unsigned SizeInBytes);

  void translateDivRem(bool isThreeOperand, bool isSigned);
  void translateHorizontalBinop(Instruction::BinaryOps BinOp);

  void translateShuffle(SmallVectorImpl<int> &Mask, Value *V0,
                        Value *V1 = nullptr);
  Value *translatePSHUFB(Value *V, Value *Mask);

  void translateCMPXCHG(unsigned MemOpType, unsigned CmpReg);
};

} // end llvm namespace

#endif
