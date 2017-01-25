//===-- AArch64DCBasicBlock.h - AArch64 Targeting of DCBasicBlock - C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_AARCH64DCBASICBLOCK_H
#define LLVM_LIB_TARGET_AARCH64_AARCH64DCBASICBLOCK_H

#include "AArch64DCFunction.h"
#include "llvm/DC/DCBasicBlock.h"

namespace llvm {

class AArch64DCBasicBlock final : public DCBasicBlock {
public:
  AArch64DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB);

  AArch64DCFunction &getParent() {
    return static_cast<AArch64DCFunction &>(DCBasicBlock::getParent());
  }
};

} // end llvm namespace

#endif
