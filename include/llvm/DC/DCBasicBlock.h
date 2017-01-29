//===-- llvm/DC/DCBasicBlock.h - Basic Block Translation --------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines DCBasicBlock, the main interface that can be used to
// translate machine code basic blocks (represented by an MCBasicBlock) to IR.
//
// DCBasicBlock provides various methods - some provided by a Target-specific
// subclassing implementation - that translate block-level MC constructs into
// the corresponding IR constructs.
//
//===----------------------------------------------------------------------===//


#ifndef LLVM_DC_DCBASICBLOCK_H
#define LLVM_DC_DCBASICBLOCK_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/DC/DCFunction.h"
#include "llvm/DC/DCRegisterSema.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/Support/ErrorHandling.h"

namespace llvm {

class DCBasicBlock {
  DCFunction &DCF;

  BasicBlock &TheBB;
  const MCBasicBlock &TheMCBB;

public:
  DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB);
  virtual ~DCBasicBlock();

  DCRegisterSema &getDRS() { return getParent().getDRS(); }
  LLVMContext &getContext() { return DCF.getContext(); }
  Module *getModule() { return DCF.getModule(); }
  Function *getFunction() { return DCF.getFunction(); }
  BasicBlock *getBasicBlock() { return &TheBB; }

  DCFunction &getParent() { return DCF; }
  DCModule &getParentModule() { return getParent().getParent(); }
  DCTranslator &getTranslator() { return getParentModule().getTranslator(); }
};

} // end namespace llvm

#endif
