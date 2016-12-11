//===-- AArch64InstrSema.cpp - AArch64 DC Instruction Semantics -*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AArch64InstrSema.h"
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

AArch64InstrSema::AArch64InstrSema(DCRegisterSema &DRS)
    : DCInstrSema(AArch64::OpcodeToSemaIdx, AArch64::InstSemantics,
                  AArch64::ConstantArray, DRS),
      AArch64DRS((AArch64RegisterSema &)DRS) {}

bool AArch64InstrSema::translateTargetInst() {
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

bool AArch64InstrSema::translateTargetOpcode(unsigned Opcode) {
  errs() << "Unknown AArch64 opcode found in semantics: " + utostr(Opcode)
         << "\n";
  return false;
}

Value *AArch64InstrSema::translateComplexPattern(unsigned Pattern) {
  switch (Pattern) {
  case AArch64::ComplexPattern::AddrModeWRO_8:
  case AArch64::ComplexPattern::AddrModeWRO_16:
  case AArch64::ComplexPattern::AddrModeWRO_32:
  case AArch64::ComplexPattern::AddrModeWRO_64:
  case AArch64::ComplexPattern::AddrModeXRO_8:
  case AArch64::ComplexPattern::AddrModeXRO_16:
  case AArch64::ComplexPattern::AddrModeXRO_32:
  case AArch64::ComplexPattern::AddrModeXRO_64: {
    Value *Base = getNextOperand();
    Value *Offset = getNextOperand();
    ConstantInt *ro_Wextend = cast<ConstantInt>(getNextOperand());

    const unsigned Signed = ro_Wextend->getZExtValue() & 1;
    const unsigned DoShift = ro_Wextend->getZExtValue() & 2;
    assert(!(ro_Wextend->getZExtValue() & ~3ULL));
    if (DoShift != 0)
      return nullptr;

    if (Signed)
      Offset = Builder->CreateSExt(Offset, Base->getType());
    else
      Offset = Builder->CreateZExt(Offset, Base->getType());

    return Builder->CreateAdd(Base, Offset);
  }

  case AArch64::ComplexPattern::AddrModeIndexed8:
  case AArch64::ComplexPattern::AddrModeIndexed16:
  case AArch64::ComplexPattern::AddrModeIndexed32:
  case AArch64::ComplexPattern::AddrModeIndexed64:
  case AArch64::ComplexPattern::AddrModeIndexed128: {
    Value *Base = getNextOperand(), *Idx = getNextOperand();
    return Builder->CreateAdd(Base, Idx);
  }
  }
  return nullptr;
}

Value *AArch64InstrSema::translateCustomOperand(unsigned OperandType,
                                                unsigned MIOperandNo) {
  switch (OperandType) {
  case AArch64::OpTypes::addsub_shifted_imm32:
  case AArch64::OpTypes::addsub_shifted_imm64: {
    auto *ResTy = cast<IntegerType>(ResEVT.getTypeForEVT(Ctx));

    const uint64_t Imm = getImmOp(MIOperandNo);
    const unsigned ShiftImm = getImmOp(MIOperandNo + 1);

    if (ShiftImm)
      return nullptr;
    return ConstantInt::get(ResTy, Imm);
  }

  case AArch64::OpTypes::arith_extended_reg32_i64:
  case AArch64::OpTypes::arith_extended_reg32_i32:
  case AArch64::OpTypes::arith_extended_reg32to64_i64: {
    Type *ResTy = ResEVT.getTypeForEVT(Ctx);

    Value *R = getReg(getRegOp(MIOperandNo));
    const unsigned ExtImm = getImmOp(MIOperandNo + 1);

    const auto ShiftType = AArch64_AM::getArithExtendType(ExtImm);
    const auto ShiftImm = AArch64_AM::getArithShiftValue(ExtImm);

    if (ShiftType != AArch64_AM::UXTB)
      return nullptr;

    R = Builder->CreateZExt(
      Builder->CreateTruncOrBitCast(R, Builder->getInt8Ty()), R->getType());

    if (ShiftImm) {
      R = Builder->CreateShl(R, ConstantInt::get(R->getType(), ShiftImm));
    }

    R = Builder->CreateZExtOrBitCast(R, ResTy);
    return R;
  }

  case AArch64::OpTypes::logical_shifted_reg32:
  case AArch64::OpTypes::logical_shifted_reg64:
  case AArch64::OpTypes::arith_shifted_reg32:
  case AArch64::OpTypes::arith_shifted_reg64: {
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

  case AArch64::OpTypes::uimm12s1:
  case AArch64::OpTypes::uimm12s2:
  case AArch64::OpTypes::uimm12s4:
  case AArch64::OpTypes::uimm12s8:
  case AArch64::OpTypes::uimm12s16: {
    unsigned Scale;
    switch (OperandType) {
    case AArch64::OpTypes::uimm12s1: Scale = 1; break;
    case AArch64::OpTypes::uimm12s2: Scale = 2; break;
    case AArch64::OpTypes::uimm12s4: Scale = 4; break;
    case AArch64::OpTypes::uimm12s8: Scale = 8; break;
    case AArch64::OpTypes::uimm12s16: Scale = 16; break;
    }
    return Builder->getInt64(getImmOp(MIOperandNo) * Scale);
  }
  case AArch64::OpTypes::simm9:
    return Builder->getInt64(getImmOp(MIOperandNo));
  case AArch64::OpTypes::logical_imm32:
    return Builder->getInt32(
        AArch64_AM::decodeLogicalImmediate(getImmOp(MIOperandNo), 32));
  case AArch64::OpTypes::logical_imm64:
    return Builder->getInt64(
        AArch64_AM::decodeLogicalImmediate(getImmOp(MIOperandNo), 64));
  case AArch64::OpTypes::ro_Wextend8:
  case AArch64::OpTypes::ro_Wextend16:
  case AArch64::OpTypes::ro_Wextend32:
  case AArch64::OpTypes::ro_Wextend64:
  case AArch64::OpTypes::ro_Wextend128:
  case AArch64::OpTypes::ro_Xextend8:
  case AArch64::OpTypes::ro_Xextend16:
  case AArch64::OpTypes::ro_Xextend32:
  case AArch64::OpTypes::ro_Xextend64:
  case AArch64::OpTypes::ro_Xextend128: {
    const unsigned Signed = getImmOp(MIOperandNo);
    const unsigned DoShift = getImmOp(MIOperandNo + 1);
    return Builder->getInt64(Signed + (DoShift << 1));
  }
  default:
    return nullptr;
  }
}

bool AArch64InstrSema::translateImplicit(unsigned RegNo) {
  return false;
}
