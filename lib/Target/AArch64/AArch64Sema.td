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

// LDR
def : Semantics<LDRWl, [(set GPR32:$Rt,  (load am_ldrlit:$label))]>;
def : Semantics<LDRXl, [(set GPR64:$Rt,  (load am_ldrlit:$label))]>;
def : Semantics<LDRSl, [(set FPR32:$Rt,  (f32 (load am_ldrlit:$label)))]>;
def : Semantics<LDRDl, [(set FPR64:$Rt,  (f64 (load am_ldrlit:$label)))]>;
def : Semantics<LDRQl, [(set FPR128:$Rt, (f128 (load am_ldrlit:$label)))]>;

// load sign-extended word
def : Semantics<LDRSWl, [(set GPR64:$Rt, (sext (i32 (load am_ldrlit:$label))))]>;

def : Semantics<LDRSWpre, [(set GPR64:$Rt, (sext (i32 (load (bitconvert (add GPR64sp:$Rn, simm9:$offset)))))),
        (set GPR64sp:$wback, (add GPR64sp:$Rn, simm9:$offset))]>;

def : Semantics<LDRSWpost, [(set GPR64:$Rt, (sext (i32 (load (bitconvert GPR64sp:$Rn))))),
        (set GPR64sp:$wback, (add GPR64sp:$Rn, simm9:$offset))]>;

def : Semantics<LDRSWui, [(set GPR64:$Rt, (sext (i32 (load (bitconvert (add GPR64sp:$Rn, uimm12s4:$offset))))))]>;

// STR
multiclass StorePrePostIndex<string regname, RegisterClass regtype, ValueType Ty, int scale> {
  def : Semantics<!cast<Instruction>("STR" # regname # "ui"), [
          (store (Ty regtype:$Rt),  (bitconvert (add GPR64sp:$Rn, (i64 !cast<Operand>("uimm12s" # scale):$offset))))]>;

  def : Semantics<!cast<Instruction>("STR" # regname # "pre"), [
          (store (Ty regtype:$Rt),  (bitconvert (add GPR64sp:$Rn, simm9:$offset))),
          (set GPR64sp:$wback, (bitconvert (add GPR64sp:$Rn, simm9:$offset)))]>;

  def : Semantics<!cast<Instruction>("STR" # regname # "post"), [
          (store (Ty regtype:$Rt), GPR64sp:$Rn),
          (set GPR64sp:$wback, (bitconvert (add GPR64sp:$Rn, simm9:$offset)))]>;
}

defm : StorePrePostIndex<"W", GPR32, i32, 4>;
defm : StorePrePostIndex<"X", GPR64, i64, 8>;
defm : StorePrePostIndex<"H", FPR16, f16, 2>;
defm : StorePrePostIndex<"S", FPR32, f32, 4>;
defm : StorePrePostIndex<"D", FPR64, f64, 8>;
defm : StorePrePostIndex<"Q", FPR128, f128, 16>;


// Load/Store Instructions: given a register, regtype, and operand type generates
// semantics for offset, pre, and post addressing modes
multiclass LoadStorePairPrePostIndex<string regname, RegisterClass regtype, ValueType Ty, int scale> {
  def : Semantics<!cast<Instruction>("STP" # regname # "i"), [
          (store (Ty regtype:$Rt), (bitconvert (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))),
          (store (Ty regtype:$Rt2), (bitconvert (add scale, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))))]>;

  def : Semantics<!cast<Instruction>("LDP" # regname # "i"), [
          (set (Ty regtype:$Rt), (Ty (load (bitconvert (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))))),
          (set (Ty regtype:$Rt2), (Ty (load (bitconvert (add scale, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))))))]>;

  def : Semantics<!cast<Instruction>("STP" # regname # "pre"), [
          (store (Ty regtype:$Rt), (bitconvert (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))),
          (store (Ty regtype:$Rt2), (bitconvert (add scale, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset))))),
          (set GPR64sp:$wback, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))]>;

  def : Semantics<!cast<Instruction>("LDP" # regname # "pre"), [
          (set (Ty regtype:$Rt), (Ty (load (bitconvert (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))))),
          (set (Ty regtype:$Rt2), (Ty (load (bitconvert (add scale, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset))))))),
          (set GPR64sp:$wback, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))]>;

  def : Semantics<!cast<Instruction>("STP" # regname # "post"), [
          (store (Ty regtype:$Rt), GPR64sp:$Rn),
          (store (Ty regtype:$Rt2), (bitconvert (add scale, GPR64sp:$Rn))),
          (set GPR64sp:$wback, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))]>;

  def : Semantics<!cast<Instruction>("LDP" # regname # "post"), [
          (set (Ty regtype:$Rt), (Ty (load GPR64sp:$Rn))),
          (set (Ty regtype:$Rt2), (Ty (load (bitconvert (add scale, GPR64sp:$Rn))))),
          (set GPR64sp:$wback, (add GPR64sp:$Rn, (sext !cast<Operand>("simm7s" # scale):$offset)))]>;
}

// LSP/STP instructions
defm : LoadStorePairPrePostIndex<"W", GPR32, i32, 4>;
defm : LoadStorePairPrePostIndex<"X", GPR64, i64, 8>;
defm : LoadStorePairPrePostIndex<"S", FPR32, f32, 4>;
defm : LoadStorePairPrePostIndex<"D", FPR64, f64, 8>;
defm : LoadStorePairPrePostIndex<"Q", FPR128, f128, 16>;

//===
// Data Processing Instructions
//===

// Arithmetic Instruction
def : Semantics<SUBXri, [(set GPR64sp:$Rd, (sub GPR64sp:$Rn, addsub_shifted_imm64:$imm))]>;

// Move Instructions
def : Semantics<MOVZWi, [(set GPR32:$Rd, (shl movimm32_imm:$imm, movimm32_shift:$shift))]>;
def : Semantics<MOVZXi, [(set GPR64:$Rd, (zext (shl movimm32_imm:$imm, movimm64_shift:$shift)))]>;
def : Semantics<MOVNWi, [(set GPR32:$Rd, (xor (shl movimm32_imm:$imm, movimm32_shift:$shift), -1))]>;
def : Semantics<MOVNXi, [(set GPR64:$Rd, (xor (zext (shl movimm32_imm:$imm, movimm64_shift:$shift)), -1))]>;
