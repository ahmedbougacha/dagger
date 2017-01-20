//===-- llvm/DC/DCRegisterSetDesc.h - Register Set Description --*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_DCREGISTERSET_H
#define LLVM_DC_DCREGISTERSET_H

#include "llvm/CodeGen/MachineValueType.h"
#include <cstdint>
#include <vector>

namespace llvm {
class Constant;
class LLVMContext;
class MCRegisterInfo;
class StructType;
class Type;

class DCRegisterSetDesc {
public:
  LLVMContext &Ctx;
  StructType *RegSetType;

  // Reg* vectors contain all MRI.getNumRegs() registers.
  unsigned NumRegs;
  // Largest* vectors contain NumLargest registers.
  unsigned NumLargest;

  // The size of each register, in bits.
  std::vector<unsigned> RegSizes;

  // The type of each register (the first type of the last register class
  // containing the register).
  // FIXME: Is there a better heuristic for register class selection?
  std::vector<Type *> RegTypes;

  // The largest super register of each register, 0 if undefined, itself if the
  // register has no super-register.
  std::vector<unsigned> RegLargestSupers;

  // Whether a register partially aliases other registers: this is usually the
  // case for tuples of registers, which alias the other permutations.
  // These registers don't participate in the regset and are materialized lazily
  // from their sub-registers.
  std::vector<bool> RegAliased;

  // The offset of each register in RegSetType, or -1 if not present.
  // Only the largest super registers are present, meaning there are only
  // NumLargest elements not equal to -1.
  std::vector<int> RegOffsetsInSet;

  std::vector<unsigned> LargestRegs;

  std::vector<Constant *> RegConstantVals;

  DCRegisterSetDesc(LLVMContext &Ctx, const MCRegisterInfo &MRI,
                    const MVT::SimpleValueType *RegClassVTs);
};

} // end namespace llvm

#endif
