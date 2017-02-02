//===- AArch64Sema.td - Describe AArch64 Semantics ----------*- tablegen -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes AArch64 instruction and register semantics that aren't
// already described by the regular register file and instruction descriptions.
//
//===----------------------------------------------------------------------===//

include "llvm/DC/Semantics.td"

//===
// Control Flow Instructions
//===

// Branching instructions
def : Semantics<BL, [(set LR, PC), (AArch64call imm:$addr)]>;
def : Semantics<BLR, [(set LR, PC), (AArch64call GPR64:$Rn)]>;
