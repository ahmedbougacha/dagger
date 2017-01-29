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
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/NoFolder.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/Support/ErrorHandling.h"

namespace llvm {

class DCBasicBlock {
  DCFunction &DCF;

  BasicBlock &TheBB;
  const MCBasicBlock &TheMCBB;

  std::vector<Value *> RegValues;

protected:
  IRBuilder<NoFolder> Builder;

public:
  DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB);
  virtual ~DCBasicBlock();

  LLVMContext &getContext() { return DCF.getContext(); }
  Module *getModule() { return DCF.getModule(); }
  Function *getFunction() { return DCF.getFunction(); }
  BasicBlock *getBasicBlock() { return &TheBB; }

  DCFunction &getParent() { return DCF; }
  DCModule &getParentModule() { return getParent().getParent(); }
  DCTranslator &getTranslator() { return getParentModule().getTranslator(); }

  /// Assign \p Val to register \p RegNo.
  /// It will not be stored to its function-level alloca immediately. Instead,
  /// the last assigned (live) value for each register will be stored to their
  /// alloca once, at the end of the block.
  /// This doesn't assign the sub-/super-registers of \p RegNo.
  void setReg(unsigned RegNo, Value *Val);

  /// Get the current value of register \p RegNo.
  /// If the register hasn't been defined previously in this basic block, it
  /// will be extracted from its largest super-register.  If its super-register
  /// hasn't been defined in this block either, the register will be loaded
  /// from its function-level alloca.
  Value *getReg(unsigned RegNo);

  /// Save the last assigned value of each register to its function-level
  /// alloca.  This clears RegValues: all registers are now dead.
  void saveAllLiveRegs();

  /// The last opportunity for the implementation to materialize a register
  /// to the live register value.  This can involve computing it from extra data
  /// and calling setReg() with the computed data.
  /// This is called when inserting calls to ensure saveAllLiveRegs will save
  /// all live registers, even if they haven't been materialized to a value yet.
  /// This is also called by getReg().
  /// The implementation is responsible for doing the equivalent work, if
  /// necessary, upon destruction, as we will need to save all live regs at
  /// the end of the block as well.
  virtual void materializeRegister(unsigned RegNo) {}

  /// This gives an opportunity for the implementation to be informed of
  /// register assignments, to, possibly, keep extra data to enable lazy
  /// materialization.
  /// This is called by setReg().
  virtual void dematerializeRegister(unsigned RegNo, Value *Val) {}
};

} // end namespace llvm

#endif
