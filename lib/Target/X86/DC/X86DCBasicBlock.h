//===-- X86DCBasicBlock.h - X86 Targeting of DCBasicBlock -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_X86_X86DCBASICBLOCK_H
#define LLVM_LIB_TARGET_X86_X86DCBASICBLOCK_H

#include "X86DCFunction.h"
#include "X86InstrInfo.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/DC/DCBasicBlock.h"

namespace llvm {

namespace X86 {
enum StatusFlag {
  CF = 0,
  PF = 2,
  AF = 4,
  ZF = 6,
  SF = 7,
  OF = 11,
  MAX_FLAGS = OF
};
} // end namespace X86

class Value;

class X86DCBasicBlock final : public DCBasicBlock {
  // This is set to the last definition that should update EFLAGS.
  // This is used to lazily compute each status flag when EFLAGS is actually
  // needed.
  Value *LastEFLAGSChangingDef;
  Value *LastEFLAGSDef;
  // Whether the last EFLAGS def was an INC/DEC, and shouldn't update CF.
  bool LastEFLAGSDefWasPartialINCDEC;
  SmallVector<Value *, 16> SFVals;
  SmallVector<unsigned, 16> SFAssignments;
  SmallVector<Value *, 16> CCVals;
  SmallVector<unsigned, 16> CCAssignments;

public:
  X86DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB);
  ~X86DCBasicBlock();

  X86DCFunction &getParent() {
    return static_cast<X86DCFunction &>(DCBasicBlock::getParent());
  }

  // Prefix instruction encoutered just before. This changes the behavior
  // of translateTargetInst to take into account the prefix.
  // FIXME: Should we instead support this in DCInstruction, so we can directly
  // ask for the next instruction?
  unsigned LastPrefix;

  // Update EFLAGS with the result of comparing LHS to RHS.
  // If they are float values, this is an unordered comparison (UCOMI).
  Value *getEFLAGSforCMP(Value *LHS, Value *RHS);

  Value *getSF(X86::StatusFlag SF);
  Value *getCC(X86::CondCode CC);

  void updateEFLAGS(Value *Def, bool IsINCDEC = false);

  void setSF(X86::StatusFlag SF, Value *Val);
  void setCC(X86::CondCode CC, Value *Val);

protected:
  void materializeRegister(unsigned RegNo) override;
  void dematerializeRegister(unsigned RegNo, Value *RegVal) override;

private:
  void clearCCSF();

  Value *computeEFLAGSForDef(Value *Def, bool DontUpdateCF = false);
  Value *createEFLAGSFromSFs();

  void materializeEFLAGS();
};

} // end llvm namespace

#endif
