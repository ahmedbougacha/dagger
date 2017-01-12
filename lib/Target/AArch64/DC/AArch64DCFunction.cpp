//===-- AArch64DCFunction.cpp - AArch64 Function Translation ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AArch64DCFunction.h"
#include "AArch64ISelLowering.h"
#include "AArch64RegisterSema.h"
#include "MCTargetDesc/AArch64AddressingModes.h"
#include "MCTargetDesc/AArch64MCTargetDesc.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/CodeGen/ValueTypes.h"

#define GET_INSTR_SEMA
#include "AArch64GenSema.inc"
using namespace llvm;

#define DEBUG_TYPE "aarch64-dc-sema"

AArch64DCFunction::AArch64DCFunction(DCRegisterSema &DRS)
    : DCFunction(AArch64::OpcodeToSemaIdx, AArch64::InstSemantics,
                 AArch64::ConstantArray, DRS),
      AArch64DRS((AArch64RegisterSema &)DRS) {}

bool AArch64DCFunction::translateTargetInst() {
  unsigned Opcode = CurrentInst->Inst.getOpcode();

  switch (Opcode) {
  case AArch64::RET: {
    setReg(AArch64::PC, getReg(getRegOp(0)));
    Builder->CreateBr(ExitBB);
    return true;
  }
  }
  return false;
}

bool AArch64DCFunction::translateTargetOpcode(unsigned Opcode) {
  errs() << "Unknown AArch64 opcode found in semantics: " + utostr(Opcode)
         << "\n";
  return false;
}

Value *AArch64DCFunction::translateComplexPattern(unsigned Pattern) {
  return nullptr;
}

Value *AArch64DCFunction::translateCustomOperand(unsigned OperandType,
                                                 unsigned MIOperandNo) {
  switch (OperandType) {
  case AArch64::OpTypes::logical_shifted_reg32:
  case AArch64::OpTypes::logical_shifted_reg64: {
    Value *R = getReg(getRegOp(MIOperandNo));
    const unsigned LSLImm = getImmOp(MIOperandNo + 1);

    const auto ShiftType = AArch64_AM::getShiftType(LSLImm);
    const auto ShiftImm = AArch64_AM::getShiftValue(LSLImm);

    if (ShiftImm) {
      if (ShiftType != AArch64_AM::LSL)
        return nullptr;

      R = Builder->CreateShl(R, ConstantInt::get(R->getType(), ShiftImm));
    }

    return R;
  }
  default:
    return nullptr;
  }
}

bool AArch64DCFunction::translateImplicit(unsigned RegNo) { return false; }
