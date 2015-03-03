//===-- llvm/DC/DCOpcodes.h - DC Semantics Opcodes --------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines target-independent DC opcodes used by the TableGen backend
// for semantics generation.
// The opcodes are in the same space as ISD opcodes.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_DCOPCODES_H
#define LLVM_DC_DCOPCODES_H

#include "llvm/CodeGen/ISDOpcodes.h"

namespace llvm {
namespace DCINS {

enum DCOpcodes {
  // We live in the same space as *ISD, this doesn't overlap.
  DC_OPCODE_START = 0xFFFFFF00,
  /// Get the value of a register operand, only defined by its Register Class.
  GET_RC,

  /// Put a value in a register operand, only defined by its Register Class.
  PUT_RC,

  /// Get the value of a specific register (imp-use)
  GET_REG,

  /// Put a value in a specific register. (imp-def)
  PUT_REG,

  /// Get the value of a custom target-specific operand.
  CUSTOM_OP,

  /// Get the value of an immediate operand.
  CONSTANT_OP,

  /// Get a constant value.
  MOV_CONSTANT,

  /// Update an implicitly defined register, as defined by the target.
  IMPLICIT,
  END_OF_INSTRUCTION
};

/// Target-specific DC opcodes start at this value.
static const int FIRST_TARGET_DC_OPCODE = ISD::FIRST_TARGET_MEMORY_OPCODE + 500;

} // end namespace DCINS
} // end namespace llvm

#endif // !DCOPCODES_H
