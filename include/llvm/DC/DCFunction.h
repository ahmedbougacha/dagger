//===-- llvm/DC/DCFunction.h - Function Translation -------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines DCFunction, the main interface that can be used to
// translate machine code functions (represented by an MCFunction) to IR.
//
// DCFunction provides various methods - some provided by a Target-specific
// subclassing implementation - that translate function-level MC constructs
// into a corresponding IR Function.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_DCFUNCTION_H
#define LLVM_DC_DCFUNCTION_H

#include "llvm/DC/DCModule.h"
#include "llvm/IR/BasicBlock.h"
#include <cstdint>
#include <map>
#include <vector>

namespace llvm {
class AllocaInst;
class CallInst;
class ConstantInt;
class MCFunction;

class DCFunction {
  DCModule &DCM;

  Function &TheFunction;
  const MCFunction &TheMCFunction;
  std::map<uint64_t, BasicBlock *> BBByAddr;
  BasicBlock *ExitBB;
  std::vector<BasicBlock::iterator> Calls;


  std::vector<Value *> RegPtrs;
  std::vector<AllocaInst *> RegAllocas;
  std::vector<Value *> RegInits;

  /// A counter representing the number of times each register was defined in
  /// this function.
  /// This is used for giving slightly more readable Value names than the usual
  /// IR scheme of appending a global number to duplicate Value names.
  std::vector<unsigned> RegDefCount;

  /// Copy all of the largest super-registers that have ever been accessed in
  /// the function from their function-level alloca to the register set struct.
  void saveLocalRegs(BasicBlock *BB, BasicBlock::iterator IP);

  /// Copy all of the largest super-registers that have ever been accessed in
  /// the function from the register set struct to their function-level alloca.
  void restoreLocalRegs(BasicBlock *BB, BasicBlock::iterator IP);

public:
  DCFunction(DCModule &DCM, const MCFunction &MCF);
  virtual ~DCFunction();

  BasicBlock *getOrCreateBasicBlock(uint64_t StartAddress);

  void createExternalTailCallBB(uint64_t Addr);

  LLVMContext &getContext() { return DCM.getContext(); }
  Module *getModule() { return DCM.getModule(); }
  Function *getFunction() { return &TheFunction; }

  DCModule &getParent() { return DCM; }
  DCTranslator &getTranslator() { return getParent().getTranslator(); }

  BasicBlock *getExitBlock() { return ExitBB; }

  /// Track the (inserted) call instruction \p CI to later insert regset saves/
  /// restores around it, when the function is finalized.
  void addCallForRegSetSaveRestore(CallInst *CI);

  /// Increment a counter representing the number of times register \p RegNo was
  /// defined in this function, returning its old value.
  /// This is used for giving slightly more readable Value names than the usual
  /// IR scheme of appending a global number to duplicate Value names.
  unsigned incrementRegDefCount(unsigned RegNo);


  /// Get the AllocaInst created in the entry block, to hold the cross-block
  /// value of register \p RegNo.  If there is none, create it.
  ///
  /// This local value is intended as a function-level "cache" for register
  /// values out of the register set structure.  This alloca is meant to be
  /// eliminated and replaced with function-wide SSA form using mem2reg.
  ///
  /// Note that, as opposed to the register set, all registers get an alloca,
  /// not only the largest super-registers.
  ///
  /// Consistency with the register set is achieved by:
  /// - In the entry block, the register allocas are initialized with the value
  ///   stored in the register set structure.
  /// - In the exit block, the value of each register alloca is saved to the
  ///   register set structure.
  /// - Calls tracked using addCallForRegSetSaveRestore will be prepended with
  ///   save copies from the register allocas to the register set, and followed
  ///   by restore copies from the register set to the register allocas.
  AllocaInst *getOrCreateRegAlloca(unsigned RegNo);
};

} // end namespace llvm

#endif
