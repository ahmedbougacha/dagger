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
#include "llvm/DC/DCBasicBlock.h"

namespace llvm {

class X86DCBasicBlock final : public DCBasicBlock {
public:
  X86DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB);

  X86DCFunction &getParent() {
    return static_cast<X86DCFunction &>(DCBasicBlock::getParent());
  }

  // Prefix instruction encoutered just before. This changes the behavior
  // of translateTargetInst to take into account the prefix.
  // FIXME: Should we instead support this in DCInstruction, so we can directly
  // ask for the next instruction?
  unsigned LastPrefix;
};

} // end llvm namespace

#endif
