//===-- llvm/DC/DCModule.h - Module Translation -----------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines DCModule, the main interface that can be used to
// translate module-level constructs from an MCModule to an IR Module.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_DCMODULE_H
#define LLVM_DC_DCMODULE_H

#include "llvm/ADT/StringRef.h"
#include "llvm/DC/DCTranslator.h"
#include "llvm/IR/Module.h"
#include <cstdint>
#include <string>

namespace llvm {
class FunctionType;
class DCRegisterSema;
class Value;

class DCModule {
public:
  DCModule(DCTranslator &DCT, Module &M);
  virtual ~DCModule();

  Function *createExternalWrapperFunction(uint64_t Addr, Value *ExtFn);
  Function *createExternalWrapperFunction(uint64_t Addr, StringRef Name);
  Function *createExternalWrapperFunction(uint64_t Addr);

  Function *getOrCreateMainFunction(Function *EntryFn);
  Function *getOrCreateInitRegSetFunction();
  Function *getOrCreateFiniRegSetFunction();

  std::string getFunctionName(uint64_t Addr);
  Function *getOrCreateFunction(uint64_t Addr);

  DCRegisterSema &getDRS() { return getTranslator().getDRS(); }
  DCTranslator &getTranslator() { return DCT; }
  Module *getModule() { return &TheModule; }
  LLVMContext &getContext() { return getModule()->getContext(); }

  FunctionType *getFuncTy() { return &FuncTy; }

protected:
  /// Insert, at the end of basic block \p InsertAtEnd, the target-specific ABI
  /// code for initializing the register set with the dynamic environment, as
  /// if immediately before calling the 'main' function.
  virtual void insertCodeForInitRegSet(BasicBlock *InsertAtEnd, Value *RegSet,
                                       Value *StackPtr, Value *StackSize,
                                       Value *ArgC, Value *ArgV) = 0;

  /// Insert, at the end of basic block \p InsertAtEnd, the target-specific ABI
  /// code for extracting the 'main' i32 result from the regset.
  virtual Value *insertCodeForFiniRegSet(BasicBlock *InsertAtEnd,
                                         Value *RegSet) = 0;

  /// Insert, at the end of basic block \p InsertAtEnd, the target-specific
  /// context-switching code to expose the register set \p RegSet to the native
  /// external function \p ExternalFunc, call it, and return to the translated
  /// code, saving the native register state to \p RegSet.
  /// This is only well-defined when translating to the same target as the
  /// original code, but can be made to work in limited cross-translation cases.
  virtual void insertExternalWrapperAsm(BasicBlock *InsertAtEnd,
                                        Value *ExternalFunc, Value *RegSet) = 0;

private:
  DCTranslator &DCT;
  Module &TheModule;
  FunctionType &FuncTy;
};

} // end namespace llvm

#endif
