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
class CallInst;
class MCFunction;

class DCFunction {
  DCModule &DCM;

  Function &TheFunction;
  const MCFunction &TheMCFunction;
  std::map<uint64_t, BasicBlock *> BBByAddr;
  BasicBlock *ExitBB;
  std::vector<BasicBlock::iterator> Calls;

public:
  DCFunction(DCModule &DCM, const MCFunction &MCF);
  virtual ~DCFunction();

  BasicBlock *getOrCreateBasicBlock(uint64_t StartAddress);

  void createExternalTailCallBB(uint64_t Addr);

  DCRegisterSema &getDRS() { return getParent().getDRS(); }
  LLVMContext &getContext() { return DCM.getContext(); }
  Module *getModule() { return DCM.getModule(); }
  Function *getFunction() { return &TheFunction; }

  DCModule &getParent() { return DCM; }

  BasicBlock *getExitBlock() { return ExitBB; }

  /// Track the (inserted) call instruction \p CI to later insert regset saves/
  /// restores around it, when the function is finalized.
  void addCallForRegSetSaveRestore(CallInst *CI);
};

} // end namespace llvm

#endif
