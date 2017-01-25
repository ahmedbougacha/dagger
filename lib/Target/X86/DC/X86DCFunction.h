//===-- X86DCFunction.h - X86 Function Translation --------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_X86_DC_X86DCFUNCTION_H
#define LLVM_LIB_TARGET_X86_DC_X86DCFUNCTION_H

#include "X86DCModule.h"
#include "llvm/DC/DCFunction.h"

namespace llvm {

class X86DCFunction final : public DCFunction {
public:
  X86DCFunction(DCModule &DCM, const MCFunction &MCF);

  X86DCModule &getParent() {
    return static_cast<X86DCModule &>(DCFunction::getParent());
  }
};

} // end namespace llvm

#endif
