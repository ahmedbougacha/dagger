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

  /// A complex pattern operator.
  COMPLEX_PATTERN,

  /// An ISD operation predicate (an ISD opcode variant of sorts).
  PREDICATE,

  END_OF_INSTRUCTION
};

/// Target-specific DC opcodes start at this value.
static const int FIRST_TARGET_DC_OPCODE = ISD::FIRST_TARGET_MEMORY_OPCODE + 500;

} // end namespace DCINS

// FIXME: We should generate this once for all target, with TargetOpcodes.def.
namespace TargetOpcode {
namespace Predicate {
enum {
  FROUND_CURRENT,
  FROUND_NO_EXC,
  alignedload,
  alignedload256,
  alignedload512,
  alignednontemporalstore,
  alignedstore,
  alignedstore256,
  alignedstore512,
  and_su,
  atomic_swap_16,
  atomic_swap_32,
  atomic_swap_64,
  atomic_swap_8,
  extloadi16,
  extloadi8,
  extloadvf32,
  fpimm0,
  immAllOnesV,
  immAllZerosV,
  load,
  loadi16,
  loadi32,
  memop,
  mgatherv16i32,
  mgatherv2i64,
  mgatherv4i32,
  mgatherv4i64,
  mgatherv8i32,
  mgatherv8i64,
  mscatterv16i32,
  mscatterv2i64,
  mscatterv4i32,
  mscatterv4i64,
  mscatterv8i32,
  mscatterv8i64,
  nontemporalstore,
  post_store,
  post_truncsti16,
  post_truncsti8,
  pre_store,
  pre_truncsti16,
  pre_truncsti8,
  sextloadi16,
  sextloadi32,
  sextloadi8,
  sextloadvi16,
  sextloadvi32,
  sextloadvi8,
  store,
  truncstorei16,
  truncstorei8,
  zextloadi16,
  zextloadi8,
  zextloadvi16,
  zextloadvi32,
  zextloadvi8,

  FIRST_TARGET_PREDICATE
};
} // end namespace Predicate
} // end namespace TargetOpcode

} // end namespace llvm

#endif // !DCOPCODES_H
