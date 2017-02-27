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
  case AArch64::HINT: {
    unsigned Op0 = getImmOp(0);
    switch(Op0) {
      case 0: // NOP
        return true;
    }
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
  switch (Pattern) {
  case AArch64::ComplexPattern::AddrModeWRO_8:
  case AArch64::ComplexPattern::AddrModeWRO_16:
  case AArch64::ComplexPattern::AddrModeWRO_32:
  case AArch64::ComplexPattern::AddrModeWRO_64:
  case AArch64::ComplexPattern::AddrModeXRO_8:
  case AArch64::ComplexPattern::AddrModeXRO_16:
  case AArch64::ComplexPattern::AddrModeXRO_32:
  case AArch64::ComplexPattern::AddrModeXRO_64: {
    Value *Base = getOperand(0);
    Value *Offset = getOperand(1);
    ConstantInt *ro_Wextend = cast<ConstantInt>(getOperand(2));

    const unsigned Signed = ro_Wextend->getZExtValue() & 1;
    const unsigned DoShift = ro_Wextend->getZExtValue() & 2;
    assert(!(ro_Wextend->getZExtValue() & ~3ULL));
    if (DoShift != 0)
      return nullptr;

    if (Signed)
      Offset = Builder.CreateSExt(Offset, Base->getType());
    else
      Offset = Builder.CreateZExt(Offset, Base->getType());

    return Builder.CreateAdd(Base, Offset);
  }
  case AArch64::ComplexPattern::AddrModeIndexed8:
  case AArch64::ComplexPattern::AddrModeIndexed16:
  case AArch64::ComplexPattern::AddrModeIndexed32:
  case AArch64::ComplexPattern::AddrModeIndexed64:
  case AArch64::ComplexPattern::AddrModeIndexed128: {
    Value *Base = getOperand(0), *Idx = getOperand(1);
    return Builder.CreateAdd(Base, Idx);
  }
  }
  return nullptr;
}

Value *AArch64DCInstruction::translateCustomOperand(unsigned OperandType,
                                                    unsigned MIOperandNo) {
  switch (OperandType) {
  case AArch64::OpTypes::addsub_shifted_imm32:
  case AArch64::OpTypes::addsub_shifted_imm64: {
    const uint64_t Imm = getImmOp(MIOperandNo);
    const unsigned ShiftImm = getImmOp(MIOperandNo + 1);

    if (ShiftImm)
      return nullptr;
    return ConstantInt::get(getResultTy(0), Imm);
  }
  case AArch64::OpTypes::am_bl_target:
  case AArch64::OpTypes::am_ldrlit: {
    auto *ResTy = Builder.getInt8PtrTy();

    // target is an offset in number of (4byte) instructions from PC
    // target = PC + (imm * 4)
    // TODO: add check that offset is +-128MB from PC?
    //       aml_ldrlit is identical except +-1MB from PC.
    signed offset = getImmOp(MIOperandNo)*4;
    Value *immTarget = Builder.getInt64(TheMCInst.Address + offset);
    return Builder.CreateIntToPtr(immTarget, ResTy);
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
  case AArch64::OpTypes::movimm64_shift:
  case AArch64::OpTypes::movimm32_shift:
  case AArch64::OpTypes::movimm32_imm: {
    const uint64_t Imm = getImmOp(MIOperandNo);
    return ConstantInt::get(getResultTy(0), Imm);
  }
  case AArch64::OpTypes::simm7s4: {
    return translateScaledImmediate(MIOperandNo, 4, 32);
  }
  case AArch64::OpTypes::simm7s8: {
    return translateScaledImmediate(MIOperandNo, 8, 32);
  }
  case AArch64::OpTypes::simm7s16: {
    return translateScaledImmediate(MIOperandNo, 16, 32);
  }
  case AArch64::OpTypes::simm9: {
    // simm9 is not scaled, so scale arg = 1
    return translateScaledImmediate(MIOperandNo, 1, 64);
  }
  case AArch64::OpTypes::uimm12s1: {
   return translateScaledImmediate(MIOperandNo, 1, 64);
  }
  case AArch64::OpTypes::uimm12s2: {
    return translateScaledImmediate(MIOperandNo, 2, 64);
  }
  case AArch64::OpTypes::uimm12s4: {
    return translateScaledImmediate(MIOperandNo, 4, 64);
  }
  case AArch64::OpTypes::uimm12s8: {
    return translateScaledImmediate(MIOperandNo, 8, 64);
  }
  case AArch64::OpTypes::uimm12s16: {
    return translateScaledImmediate(MIOperandNo, 16, 64);
  }
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
    return Builder.getInt64(Signed + (DoShift << 1));
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
                                                      unsigned Bits) {
  APInt Val = APInt(Bits, getImmOp(MIOperandNo));
  APInt APScale = APInt(Bits, Scale);
  return Builder.getInt(Val * APScale);
}
