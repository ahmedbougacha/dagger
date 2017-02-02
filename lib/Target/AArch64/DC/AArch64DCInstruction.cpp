//===-- AArch64DCInstruction.cpp - AArch64 DCInstruction --------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AArch64DCInstruction.h"
#include "AArch64ISelLowering.h"
#include "InstPrinter/AArch64InstPrinter.h"
#include "MCTargetDesc/AArch64AddressingModes.h"
#include "MCTargetDesc/AArch64MCTargetDesc.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/DC/DCModule.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/TypeBuilder.h"
#include <algorithm>

#define GET_INSTR_SEMA
#include "AArch64GenSema.inc"
using namespace llvm;

#define DEBUG_TYPE "aarch64-dc-sema"

AArch64DCInstruction::AArch64DCInstruction(DCBasicBlock &DCB,
                                           const MCDecodedInst &MCI)
    : DCInstruction(DCB, MCI, AArch64::OpcodeToSemaIdx, AArch64::InstSemantics,
                    AArch64::ConstantArray) {}

bool AArch64DCInstruction::translateTargetInst() {
  unsigned Opcode = TheMCInst.Inst.getOpcode();

  switch (Opcode) {
  case AArch64::RET: {
    setReg(AArch64::PC, getReg(getRegOp(0)));
    Builder.CreateBr(getParent().getParent().getExitBlock());
    return true;
  }
  }
  return false;
}

bool AArch64DCInstruction::translateTargetOpcode(unsigned Opcode) {
  switch (Opcode) {
  case AArch64ISD::CALL: {
    Value *Op1 = getOperand(0);
    insertCall(Op1);
    return true;
  }
  default:
    break;
  }
  errs() << "Unknown AArch64 opcode found in semantics: " + utostr(Opcode)
         << "\n";
  return false;
}

Value *AArch64DCInstruction::translateComplexPattern(unsigned Pattern) {
  return nullptr;
}

Value *AArch64DCInstruction::translateCustomOperand(unsigned OperandType,
                                                    unsigned MIOperandNo) {
  switch (OperandType) {
  case AArch64::OpTypes::am_bl_target: {
    auto *ResTy = Builder.getInt8PtrTy();

    // bl target is an offset in number of (4byte) instructions from PC
    // target = PC + (imm * 4)
    // TODO: add check that offset is +-128MB from PC?
    signed offset = getImmOp(MIOperandNo)*4;
    Value *blTarget = Builder.getInt64(TheMCInst.Address + offset);
    return Builder.CreateIntToPtr(blTarget, ResTy);
  }
  case AArch64::OpTypes::logical_shifted_reg32:
  case AArch64::OpTypes::logical_shifted_reg64: {
    Value *R = getReg(getRegOp(MIOperandNo));
    const unsigned LSLImm = getImmOp(MIOperandNo + 1);

    const auto ShiftType = AArch64_AM::getShiftType(LSLImm);
    const auto ShiftImm = AArch64_AM::getShiftValue(LSLImm);

    if (ShiftImm) {
      if (ShiftType != AArch64_AM::LSL)
        return nullptr;

      R = Builder.CreateShl(R, ConstantInt::get(R->getType(), ShiftImm));
    }

    return R;
  }
  case AArch64::OpTypes::simm7s4: {
    return translateScaledImmediate(MIOperandNo, 4, true);
  }
  case AArch64::OpTypes::simm7s8: {
    return translateScaledImmediate(MIOperandNo, 8, true);
  }
  case AArch64::OpTypes::simm7s16: {
    return translateScaledImmediate(MIOperandNo, 16, true);
  }
  default:
    errs() << "Unknown AArch64 operand type found in semantics: "
           << utostr(OperandType) << "\n";

    return nullptr;
  }
}

bool AArch64DCInstruction::translateImplicit(unsigned RegNo) { return false; }

bool AArch64DCInstruction::doesSubRegIndexClearSuper(unsigned SubRegIdx) {
  switch (SubRegIdx) {
  case AArch64::sub_32:
  case AArch64::bsub:
  case AArch64::hsub:
  case AArch64::ssub:
  case AArch64::dsub:
    return true;
  }
  return false;
}

Value *AArch64DCInstruction::translateScaledImmediate(unsigned MIOperandNo,
                                                      unsigned Scale,
                                                      bool IsSigned) {
  APInt Val = APInt(32, getImmOp(MIOperandNo), IsSigned);
  APInt APScale = APInt(32, Scale, false);
  return Builder.getInt(Val * APScale);
}
