//===-- X86RegisterSema.cpp - X86 DC Register Semantics ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "X86RegisterSema.h"
#include "X86.h"
#include "X86InstrInfo.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/DC/DCRegisterSetDesc.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/Support/raw_ostream.h"

#define GET_REGISTER_SEMA
#include "X86GenSema.inc"
using namespace llvm;

#define DEBUG_TYPE "x86-dc-regsema"

X86RegisterSema::X86RegisterSema(LLVMContext &Ctx, const MCRegisterInfo &MRI,
                                 const MCInstrInfo &MII, const DataLayout &DL,
                                 const DCRegisterSetDesc &RegSetDesc)
    : DCRegisterSema(Ctx, MRI, MII, DL, RegSetDesc), LastEFLAGSChangingDef(0),
      LastEFLAGSDef(0), LastEFLAGSDefWasPartialINCDEC(false),
      SFVals(X86::MAX_FLAGS + 1), SFAssignments(X86::MAX_FLAGS + 1),
      CCVals(X86::COND_INVALID), CCAssignments(X86::COND_INVALID) {}

bool X86RegisterSema::doesSubRegIndexClearSuper(unsigned SubRegIdx) const {
  if (SubRegIdx == X86::sub_32bit)
    return true;
  if (SubRegIdx == X86::sub_xmm) {
    const MCInstrDesc &MCID = MII.get(CurrentInst->Inst.getOpcode());
    // VEX-encoded SSE instructions clear [size-1:127].
    // FIXME: This should take into account VEX.vvvv, .LIG, ..
    if (MCID.TSFlags & X86II::VEX)
      return true;
  }
  return false;
}

void X86RegisterSema::clearCCSF() {
  for (size_t i = 0, e = SFVals.size(); i != e; ++i)
    SFVals[i] = 0;
  for (size_t i = 0, e = CCVals.size(); i != e; ++i)
    CCVals[i] = 0;
  LastEFLAGSChangingDef = 0;
  LastEFLAGSDef = 0;
}

void X86RegisterSema::onRegisterGet(unsigned RegNo) {
  if (RegNo != X86::EFLAGS)
    return;

  if (!LastEFLAGSChangingDef)
    return;

  Value *EFLAGSDef =
      computeEFLAGSForDef(LastEFLAGSChangingDef, LastEFLAGSDefWasPartialINCDEC);
  setRegValWithName(RegNo, EFLAGSDef);
  LastEFLAGSDef = EFLAGSDef;
  LastEFLAGSChangingDef = 0;
  LastEFLAGSDefWasPartialINCDEC = false;
}

void X86RegisterSema::onRegisterSet(unsigned RegNo, Value *RV) {
  if (RegNo != X86::EFLAGS)
    return;
  if (RV == RegVals[X86::EFLAGS])
    return;
  if (RV != LastEFLAGSDef) {
    clearCCSF();
    LastEFLAGSDef = RV;
  }
}

void X86RegisterSema::FinalizeBasicBlock() {
  DCRegisterSema::FinalizeBasicBlock();
  clearCCSF();
}

void X86RegisterSema::FinalizeFunction(BasicBlock *ExitBB) {
  DCRegisterSema::FinalizeFunction(ExitBB);
  for (size_t i = 0, e = CCAssignments.size(); i != e; ++i)
    CCAssignments[i] = 0;
  for (size_t i = 0, e = SFAssignments.size(); i != e; ++i)
    SFAssignments[i] = 0;
}

static StringRef getSFName(X86::StatusFlag SF) {
  switch (SF) {
  case X86::SF:
    return "SF";
  case X86::CF:
    return "CF";
  case X86::PF:
    return "PF";
  case X86::AF:
    return "AF";
  case X86::ZF:
    return "ZF";
  case X86::OF:
    return "OF";
  }
  llvm_unreachable("Unknown status flag.");
}

static StringRef getCCName(X86::CondCode CC) {
  switch (CC) {
  case X86::COND_NO:
    return "CC_NO";
  case X86::COND_O:
    return "CC_O";
  case X86::COND_AE:
    return "CC_AE";
  case X86::COND_B:
    return "CC_B";
  case X86::COND_NE:
    return "CC_NE";
  case X86::COND_E:
    return "CC_E";
  case X86::COND_NS:
    return "CC_NS";
  case X86::COND_S:
    return "CC_S";
  case X86::COND_NP:
    return "CC_NP";
  case X86::COND_P:
    return "CC_P";
  case X86::COND_A:
    return "CC_A";
  case X86::COND_BE:
    return "CC_BE";
  case X86::COND_GE:
    return "CC_GE";
  case X86::COND_L:
    return "CC_L";
  case X86::COND_G:
    return "CC_G";
  case X86::COND_LE:
    return "CC_LE";
  default:
    return "";
  }
}

Value *X86RegisterSema::getCC(X86::CondCode CC) {
  Value *CCV = CCVals[CC];
  if (CCV)
    return CCV;

  bool Inv = false; // Flag must be 0
  bool XOF = false; // Needs XOR OF
  bool OZF = false; // Needs OR ZF
  X86::StatusFlag SF;
  switch (CC) {
  case X86::COND_NO:
    Inv = true;
  case X86::COND_O:
    SF = X86::OF;
    break;
  case X86::COND_AE:
    Inv = true;
  case X86::COND_B:
    SF = X86::CF;
    break;
  case X86::COND_NE:
    Inv = true;
  case X86::COND_E:
    SF = X86::ZF;
    break;
  case X86::COND_NS:
    Inv = true;
  case X86::COND_S:
    SF = X86::SF;
    break;
  case X86::COND_NP:
    Inv = true;
  case X86::COND_P:
    SF = X86::PF;
    break;
  case X86::COND_A:
    Inv = true;
  case X86::COND_BE:
    SF = X86::CF;
    OZF = true;
    break;
  case X86::COND_GE:
    Inv = true;
  case X86::COND_L:
    SF = X86::SF;
    XOF = true;
    break;
  case X86::COND_G:
    Inv = true;
  case X86::COND_LE:
    SF = X86::SF;
    XOF = true;
    OZF = true;
    break;
  case X86::COND_NE_OR_P:
  case X86::COND_E_AND_NP:
  case X86::COND_INVALID:
    llvm_unreachable("X86 condcode doesn't have a StatusFlag equivalent");
  };

  CCV = getSF(SF);
  if (XOF)
    CCV = Builder->CreateXor(CCV, getSF(X86::OF));
  if (OZF)
    CCV = Builder->CreateOr(CCV, getSF(X86::ZF));
  if (Inv)
    CCV = Builder->CreateNot(CCV);
  setCC(CC, CCV);
  return CCV;
}

void X86RegisterSema::setCC(X86::CondCode CC, Value *CCV) {
  CCVals[CC] = CCV;
  if (!CCV->hasName())
    CCV->setName(
        (Twine(getCCName(CC)) + "_" + utostr(CCAssignments[CC]++)).str());
}

Value *X86RegisterSema::getEFLAGSforCMP(Value *LHS, Value *RHS) {
  clearCCSF();
  assert(LHS->getType() == RHS->getType());
  if (RHS->getType()->isIntegerTy()) {
    // FIXME: the ultimate goal is to make this transparent, depending on the
    // operation that updated the flags.
    setCC(X86::COND_A, Builder->CreateICmpUGT(LHS, RHS));
    setCC(X86::COND_AE, Builder->CreateICmpUGE(LHS, RHS));
    setCC(X86::COND_B, Builder->CreateICmpULT(LHS, RHS));
    setCC(X86::COND_BE, Builder->CreateICmpULE(LHS, RHS));
    setCC(X86::COND_L, Builder->CreateICmpSLT(LHS, RHS));
    setCC(X86::COND_LE, Builder->CreateICmpSLE(LHS, RHS));
    setCC(X86::COND_G, Builder->CreateICmpSGT(LHS, RHS));
    setCC(X86::COND_GE, Builder->CreateICmpSGE(LHS, RHS));
    setCC(X86::COND_E, Builder->CreateICmpEQ(LHS, RHS));
    setCC(X86::COND_NE, Builder->CreateICmpNE(LHS, RHS));
    // Per the intel manual, CMP is equivalent to SUB.
    return computeEFLAGSForDef(Builder->CreateSub(LHS, RHS));
  } else {
    setSF(X86::OF, Builder->getFalse());
    setSF(X86::SF, Builder->getFalse());
    setSF(X86::AF, Builder->getFalse());
    setSF(X86::ZF, Builder->CreateFCmpUEQ(LHS, RHS));
    setSF(X86::PF, Builder->CreateFCmpUNO(LHS, RHS));
    setSF(X86::CF, Builder->CreateFCmpULT(LHS, RHS));
    return createEFLAGSFromSFs();
  }
}

void X86RegisterSema::updateEFLAGS(Value *Def, bool IsINCDEC) {
  // FIXME: we only really need the alloca here.
  LastEFLAGSChangingDef = 0;
  getReg(X86::EFLAGS);
  LastEFLAGSChangingDef = Def;
  LastEFLAGSDef = 0;
  LastEFLAGSDefWasPartialINCDEC = IsINCDEC;
}

Value *X86RegisterSema::computeEFLAGSForDef(Value *Def, bool DontUpdateCF) {
  // FIXME: This describes the general semantics of EFLAGS update, but this
  // needs to handle the differences between instructions.
  // This would be done by keeping more information on the instruction with
  // LastEFLAGSChangingDef.
  // For now we only do DontUpdateCF, for INC/DEC instructions.

  setSF(X86::ZF, Builder->CreateIsNull(Def));

  setSF(X86::SF,
        Builder->CreateICmpSLT(Def, ConstantInt::getNullValue(Def->getType())));

  // FIXME: We need to generate AF as well.
  setSF(X86::AF, Builder->getFalse());

  // FIXME: CF/OF need a smarter trick.
  Intrinsic::ID OverflowIntrinsic = Intrinsic::not_intrinsic,
                CarryIntrinsic = Intrinsic::not_intrinsic;

  BinaryOperator *BinOp = dyn_cast<BinaryOperator>(Def);
  if (BinOp && BinOp->getOpcode() == BinaryOperator::Add) {
    OverflowIntrinsic = Intrinsic::sadd_with_overflow;
    CarryIntrinsic = Intrinsic::uadd_with_overflow;
  } else if (BinOp && BinOp->getOpcode() == BinaryOperator::Sub) {
    OverflowIntrinsic = Intrinsic::ssub_with_overflow;
    CarryIntrinsic = Intrinsic::usub_with_overflow;
  }

  if (BinOp && OverflowIntrinsic && CarryIntrinsic) {
    Value *Args[] = {BinOp->getOperand(0), BinOp->getOperand(1)};
    setSF(X86::OF, Builder->CreateExtractValue(
                       Builder->CreateCall(
                           Intrinsic::getDeclaration(
                               TheModule, OverflowIntrinsic, BinOp->getType()),
                           Args),
                       1));
    if (!DontUpdateCF)
      setSF(X86::CF, Builder->CreateExtractValue(
                         Builder->CreateCall(
                             Intrinsic::getDeclaration(
                                 TheModule, CarryIntrinsic, BinOp->getType()),
                             Args),
                         1));
  } else {
    if (!DontUpdateCF)
      setSF(X86::CF, Builder->getFalse());
    setSF(X86::OF, Builder->getFalse());
  }

  Type *I8Ty = Builder->getInt8Ty();
  setSF(X86::PF, Builder->CreateIsNull(Builder->CreateTrunc(
                     Builder->CreateCall(Intrinsic::getDeclaration(
                                             TheModule, Intrinsic::ctpop, I8Ty),
                                         {Builder->CreateTrunc(Def, I8Ty)}),
                     Builder->getInt1Ty())));
  return createEFLAGSFromSFs();
}

Value *X86RegisterSema::createEFLAGSFromSFs() {
  // Now recreate EFLAGS from the individual components.
  const X86::StatusFlag Flags[6] = {X86::CF, X86::PF, X86::AF,
                                    X86::ZF, X86::SF, X86::OF};
  uint32_t Mask = 0;
  for (unsigned i = 0, e = 6; i != e; ++i)
    Mask |= 1 << Flags[i];
  Value *Res = getReg(X86::CtlSysEFLAGS);
  for (unsigned i = 0, e = 6; i != e; ++i) {
    Res = Builder->CreateOr(
        Builder->CreateShl(
            Builder->CreateZExt(SFVals[Flags[i]], Res->getType()), Flags[i]),
        Res);
  }
  return Res;
}

void X86RegisterSema::setSF(X86::StatusFlag SF, Value *Val) {
  // No need to recreate EFLAGS, because this is only called from updateEFLAGS.
  SFVals[SF] = Val;
  if (!Val->hasName())
    Val->setName(
        (Twine(getSFName(SF)) + "_" + utostr(SFAssignments[SF]++)).str());
}

Value *X86RegisterSema::getSF(X86::StatusFlag SF) {
  Value *SV = SFVals[SF];
  if (SV == 0) {
    SV = extractBitsFromValue(SF, 1, getReg(X86::EFLAGS));
    setSF(SF, SV);
  }
  return SV;
}
