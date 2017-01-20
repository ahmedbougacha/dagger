//===-- llvm/DC/LowerDCTranslateAt.h - Lower dc.translate.at ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Lower calls to the @llvm.dc.translate.at intrinsic to calls to an arbitrary
// callback function, with the same signature, responsible for providing a
// translating IR function pointer from a raw (non-translated) indirect call
// target pointer.
//
// This can, for instance, involve falling back to a dynamic translator runtime.
//
// FIXME: This can also be used, for instance, to emit a switch containing all
// known function targets.
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_LOWERDCTRANSLATEAT_H
#define LLVM_DC_LOWERDCTRANSLATEAT_H

namespace llvm {
class Pass;
class Value;

Pass *createLowerDCTranslateAtPass(Value *DynTranslateAtCallback);

} // end namespace llvm

#endif
