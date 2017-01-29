//===-- X86DCModule.h - X86 Module Translation ------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_X86_X86DCMODULE_H
#define LLVM_LIB_TARGET_X86_X86DCMODULE_H

#include "llvm/DC/DCModule.h"

namespace llvm {

class X86DCModule final : public DCModule {
public:
  X86DCModule(DCTranslator &DCT, Module &M);

protected:
  void insertCodeForInitRegSet(BasicBlock *InsertAtEnd, Value *RegSet,
                               Value *StackPtr, Value *StackSize, Value *ArgC,
                               Value *ArgV) override;

  Value *insertCodeForFiniRegSet(BasicBlock *InsertAtEnd,
                                 Value *RegSet) override;

  void insertExternalWrapperAsm(BasicBlock *InsertAtEnd, Value *ExternalFunc,
                                Value *RegSet) override;
};

} // end namespace llvm

#endif
