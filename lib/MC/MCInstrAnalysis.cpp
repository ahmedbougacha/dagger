//===- MCInstrAnalysis.cpp - InstrDesc target hooks -----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrDesc.h"
#include "llvm/MC/MCInstrInfo.h"
#include <cstdint>

using namespace llvm;

bool MCInstrAnalysis::evaluateBranch(const MCInst &Inst, uint64_t Addr,
                                     uint64_t Size, uint64_t &Target) const {
  if (Inst.getNumOperands() == 0 ||
      Info->get(Inst.getOpcode()).OpInfo[0].OperandType != MCOI::OPERAND_PCREL)
    return false;

  const MCOperand &Op = Inst.getOperand(0);
  if (Op.isImm()) {
    int64_t Imm = Inst.getOperand(0).getImm();
    Target = Addr+Size+Imm;
    return true;
  }

  const MCExpr *Expr = Op.getExpr();
  int64_t Absolute;
  if (!Expr->evaluateAsAbsolute(Absolute))
    return false;

  Target = Absolute;
  return true;
}
