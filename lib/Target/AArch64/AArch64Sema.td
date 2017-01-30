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


//===
// Memory Access Instructions
//===

// Store Instructions: given a register, regtype, and operand type generates
// semantics for offset, pre, and post addressing modes
multiclass StorePairPrePostIndex<string regname, RegisterClass regtype, ValueType Ty, int scale> {
  def : Semantics<!cast<Instruction>("STP" # regname # "i"), [
          (store (Ty regtype:$Rt), (bitconvert (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))),
          (store (Ty regtype:$Rt2), (bitconvert (add scale, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))))]>;

  def : Semantics<!cast<Instruction>("STP" # regname # "pre"), [
          (store (Ty regtype:$Rt), (bitconvert (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))),
          (store (Ty regtype:$Rt2), (bitconvert (add scale, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset))))),
          (set GPR64sp:$wback, (bitconvert (add scale, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))))]>;

  def : Semantics<!cast<Instruction>("STP" # regname # "post"), [
          (store (Ty regtype:$Rt), GPR64sp:$Rn),
          (store (Ty regtype:$Rt2), (bitconvert (add scale, GPR64sp:$Rn))),
          (set GPR64sp:$wback, (bitconvert (add scale, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))))]>;
}

// STP instructions
defm : StorePairPrePostIndex<"W", GPR32, i32, 4>;
defm : StorePairPrePostIndex<"X", GPR64, i64, 8>;
defm : StorePairPrePostIndex<"S", FPR32, f32, 4>;
defm : StorePairPrePostIndex<"D", FPR64, f64, 8>;
defm : StorePairPrePostIndex<"Q", FPR128, f128, 16>;
