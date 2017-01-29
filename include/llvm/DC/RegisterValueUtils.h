//===-- llvm/DC/RegisterValueUtils.h - Utility functions ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines helper functions related to manipulating register values.
//
//===----------------------------------------------------------------------===//


#ifndef LLVM_DC_REGISTERVALUEUTILS_H
#define LLVM_DC_REGISTERVALUEUTILS_H

#include "llvm/IR/IRBuilder.h"

namespace llvm {
class MCRegisterInfo;
class Value;

/// Create a value assignable to register \p Sub, based on the contents of its
/// super-register \p Super.
/// This will extract the current value of \p Sub into a standalone value.
Value *extractSubRegFromSuper(IRBuilderBase::InsertPoint InsertPt,
                              const MCRegisterInfo &MRI, unsigned Super,
                              unsigned Sub, Value *SuperValue);

/// Create a value assignable to register \p Super, based on the contents of
/// its sub-register \p Sub.
/// This will insert the current value of \p Sub into the current value of
/// \p Super.  If doesSubRegIndexClearSuper returns true for this sub-reg
/// access, the bits of \p Super not overwritten by \p Sub will be cleared.
Value *recreateSuperRegFromSub(IRBuilderBase::InsertPoint InsertPt,
                               const MCRegisterInfo &MRI, unsigned Super,
                               unsigned Sub, Value *SuperVal, Value *SubVal,
                               bool ClearSuper = false);

/// Extract \p NumBits starting at \p LoBit from \p Val.
Value *extractBitsFromValue(IRBuilderBase::InsertPoint InsertPt, unsigned LoBit,
                            unsigned NumBits, Value *Val);

/// Insert \p ValToInsert at \p Offset in \p FullVal.
/// Both FullVal and ValToInsert have to be integers.
/// ValToInsert also has to fit: Offset + size of ValToInsert < FullVal.
/// If \p ClearOldValue is true, then this resets FullVal to 0 before
/// inserting.
Value *insertBitsInValue(IRBuilderBase::InsertPoint InsertPt, Value *FullVal,
                         Value *ValToInsert, unsigned Offset = 0,
                         bool ClearOldValue = false);

} // end namespace llvm

#endif
