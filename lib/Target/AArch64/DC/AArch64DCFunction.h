//===-- AArch64DCFunction.h - AArch64 Function Translation ------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_DC_AARCH64INSTRSEMA_H
#define LLVM_LIB_TARGET_AARCH64_DC_AARCH64INSTRSEMA_H

#include "llvm/DC/DCFunction.h"
#include "llvm/Support/Compiler.h"

namespace llvm {

class AArch64RegisterSema;

class AArch64DCFunction : public DCFunction {
public:
  AArch64DCFunction(DCModule &DCM, const MCFunction &MCF);
};

} // end namespace llvm

#endif
