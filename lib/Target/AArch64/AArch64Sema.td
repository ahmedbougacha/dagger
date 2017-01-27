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

// Branching instructions
def : Semantics<BL, [(set LR, PC), (AArch64call imm:$addr)]>;
def : Semantics<BLR, [(set LR, PC), (AArch64call GPR64:$Rn)]>;


// Store instructions
// indexed
def : Semantics<STPXi,[(store GPR64:$Rt, (bitconvert (add GPR64sp:$Rn, (sext simm7s8:$offset)))),
                       (store GPR64:$Rt2, (bitconvert (add 8, (add GPR64sp:$Rn, (sext simm7s8:$offset)))))]>;
def : Semantics<STPWi,[(store GPR32:$Rt, (bitconvert (add GPR64sp:$Rn, (sext simm7s4:$offset)))),
                       (store GPR32:$Rt2, (bitconvert (add 4, (add GPR64sp:$Rn, (sext simm7s4:$offset)))))]>;

// pre-indexed
def : Semantics<STPXpre,[(store GPR64:$Rt, (bitconvert (add GPR64sp:$Rn, (sext simm7s8:$offset)))),
                       (store GPR64:$Rt2, (bitconvert (add 8, (add GPR64sp:$Rn, (sext simm7s8:$offset))))),
                       (set GPR64sp:$wback, (bitconvert (add 8, (add GPR64sp:$Rn, (sext simm7s8:$offset)))))]>;
def : Semantics<STPWpre,[(store GPR32:$Rt, (bitconvert (add GPR64sp:$Rn, (sext simm7s4:$offset)))),
                       (store GPR32:$Rt2, (bitconvert (add 8, (add GPR64sp:$Rn, (sext simm7s4:$offset))))),
                       (set GPR64sp:$wback, (bitconvert (add 8, (add GPR64sp:$Rn, (sext simm7s4:$offset)))))]>;
