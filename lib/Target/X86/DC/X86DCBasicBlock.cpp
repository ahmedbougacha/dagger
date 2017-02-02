//===-- X86DCBasicBlock.cpp - X86 Targeting of DCBasicBlock -----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "X86DCBasicBlock.h"
#include "llvm/DC/RegisterValueUtils.h"

using namespace llvm;

X86DCBasicBlock::X86DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB)
    : DCBasicBlock(DCF, MCB), LastEFLAGSChangingDef(0), LastEFLAGSDef(0),
      LastEFLAGSDefWasPartialINCDEC(false), SFVals(X86::MAX_FLAGS + 1),
      SFAssignments(X86::MAX_FLAGS + 1), CCVals(X86::COND_INVALID),
      CCAssignments(X86::COND_INVALID), LastPrefix(0) {}

X86DCBasicBlock::~X86DCBasicBlock() {
  // Flush EFLAGS one last time.
  auto *BB = getBasicBlock();
  if (BB->size() > 1)
    if (auto *TI = dyn_cast<TerminatorInst>(&*std::prev(BB->end(), 2)))
      Builder.SetInsertPoint(TI);
  materializeEFLAGS();
}

void X86DCBasicBlock::clearCCSF() {
  for (size_t i = 0, e = SFVals.size(); i != e; ++i)
    SFVals[i] = 0;
  for (size_t i = 0, e = CCVals.size(); i != e; ++i)
    CCVals[i] = 0;
  LastEFLAGSChangingDef = 0;
  LastEFLAGSDef = 0;
}

void X86DCBasicBlock::materializeEFLAGS() {
  if (!LastEFLAGSChangingDef)
    return;

  Value *EFLAGSDef =
      computeEFLAGSForDef(LastEFLAGSChangingDef, LastEFLAGSDefWasPartialINCDEC);
  setReg(X86::EFLAGS, EFLAGSDef);
  LastEFLAGSDef = EFLAGSDef;
  LastEFLAGSChangingDef = 0;
  LastEFLAGSDefWasPartialINCDEC = false;
}

void X86DCBasicBlock::materializeRegister(unsigned RegNo) {
  if (RegNo == X86::EFLAGS)
    materializeEFLAGS();
}

void X86DCBasicBlock::dematerializeRegister(unsigned RegNo, Value *RV) {
  if (RegNo != X86::EFLAGS)
    return;
  if (RV != LastEFLAGSDef) {
    clearCCSF();
    LastEFLAGSDef = RV;
  }
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

Value *X86DCBasicBlock::getCC(X86::CondCode CC) {
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
    CCV = Builder.CreateXor(CCV, getSF(X86::OF));
  if (OZF)
    CCV = Builder.CreateOr(CCV, getSF(X86::ZF));
  if (Inv)
    CCV = Builder.CreateNot(CCV);
  setCC(CC, CCV);
  return CCV;
}

void X86DCBasicBlock::setCC(X86::CondCode CC, Value *CCV) {
  CCVals[CC] = CCV;
  if (!CCV->hasName())
    CCV->setName(
        (Twine(getCCName(CC)) + "_" + utostr(CCAssignments[CC]++)).str());
}

Value *X86DCBasicBlock::getEFLAGSforCMP(Value *LHS, Value *RHS) {
  clearCCSF();
  assert(LHS->getType() == RHS->getType());
  if (RHS->getType()->isIntegerTy()) {
    // FIXME: the ultimate goal is to make this transparent, depending on the
    // operation that updated the flags.
    setCC(X86::COND_A, Builder.CreateICmpUGT(LHS, RHS));
    setCC(X86::COND_AE, Builder.CreateICmpUGE(LHS, RHS));
    setCC(X86::COND_B, Builder.CreateICmpULT(LHS, RHS));
    setCC(X86::COND_BE, Builder.CreateICmpULE(LHS, RHS));
    setCC(X86::COND_L, Builder.CreateICmpSLT(LHS, RHS));
    setCC(X86::COND_LE, Builder.CreateICmpSLE(LHS, RHS));
    setCC(X86::COND_G, Builder.CreateICmpSGT(LHS, RHS));
    setCC(X86::COND_GE, Builder.CreateICmpSGE(LHS, RHS));
    setCC(X86::COND_E, Builder.CreateICmpEQ(LHS, RHS));
    setCC(X86::COND_NE, Builder.CreateICmpNE(LHS, RHS));
    // Per the intel manual, CMP is equivalent to SUB.
    LastEFLAGSDef = computeEFLAGSForDef(Builder.CreateSub(LHS, RHS));
    return LastEFLAGSDef;
  } else {
    setSF(X86::OF, Builder.getFalse());
    setSF(X86::SF, Builder.getFalse());
    setSF(X86::AF, Builder.getFalse());
    setSF(X86::ZF, Builder.CreateFCmpUEQ(LHS, RHS));
    setSF(X86::PF, Builder.CreateFCmpUNO(LHS, RHS));
    setSF(X86::CF, Builder.CreateFCmpULT(LHS, RHS));
    LastEFLAGSDef = createEFLAGSFromSFs();
    return LastEFLAGSDef;
  }
}

void X86DCBasicBlock::updateEFLAGS(Value *Def, bool IsINCDEC) {
  // FIXME: we only really need the alloca here.
  LastEFLAGSChangingDef = 0;
  getReg(X86::EFLAGS);
  LastEFLAGSChangingDef = Def;
  LastEFLAGSDef = 0;
  LastEFLAGSDefWasPartialINCDEC = IsINCDEC;
}

Value *X86DCBasicBlock::computeEFLAGSForDef(Value *Def, bool DontUpdateCF) {
  // FIXME: This describes the general semantics of EFLAGS update, but this
  // needs to handle the differences between instructions.
  // This would be done by keeping more information on the instruction with
  // LastEFLAGSChangingDef.
  // For now we only do DontUpdateCF, for INC/DEC instructions.

  setSF(X86::ZF, Builder.CreateIsNull(Def));

  setSF(X86::SF,
        Builder.CreateICmpSLT(Def, ConstantInt::getNullValue(Def->getType())));

  // FIXME: We need to generate AF as well.
  setSF(X86::AF, Builder.getFalse());

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
    setSF(X86::OF, Builder.CreateExtractValue(
                       Builder.CreateCall(
                           Intrinsic::getDeclaration(
                               getModule(), OverflowIntrinsic, BinOp->getType()),
                           Args),
                       1));
    if (!DontUpdateCF)
      setSF(X86::CF, Builder.CreateExtractValue(
                         Builder.CreateCall(
                             Intrinsic::getDeclaration(
                                 getModule(), CarryIntrinsic, BinOp->getType()),
                             Args),
                         1));
  } else {
    if (!DontUpdateCF)
      setSF(X86::CF, Builder.getFalse());
    setSF(X86::OF, Builder.getFalse());
  }

  Type *I8Ty = Builder.getInt8Ty();
  setSF(X86::PF, Builder.CreateIsNull(Builder.CreateTrunc(
                     Builder.CreateCall(Intrinsic::getDeclaration(
                                             getModule(), Intrinsic::ctpop, I8Ty),
                                         {Builder.CreateTrunc(Def, I8Ty)}),
                     Builder.getInt1Ty())));
  return createEFLAGSFromSFs();
}

Value *X86DCBasicBlock::createEFLAGSFromSFs() {
  // Now recreate EFLAGS from the individual components.
  const X86::StatusFlag Flags[6] = {X86::CF, X86::PF, X86::AF,
                                    X86::ZF, X86::SF, X86::OF};
  uint32_t Mask = 0;
  for (unsigned i = 0, e = 6; i != e; ++i)
    Mask |= 1 << Flags[i];
  Value *Res = getReg(X86::CtlSysEFLAGS);
  for (unsigned i = 0, e = 6; i != e; ++i) {
    Res = Builder.CreateOr(
        Builder.CreateShl(
            Builder.CreateZExt(SFVals[Flags[i]], Res->getType()), Flags[i]),
        Res);
  }
  return Res;
}

void X86DCBasicBlock::setSF(X86::StatusFlag SF, Value *Val) {
  // No need to recreate EFLAGS, because this is only called from updateEFLAGS.
  SFVals[SF] = Val;
  if (!Val->hasName())
    Val->setName(
        (Twine(getSFName(SF)) + "_" + utostr(SFAssignments[SF]++)).str());
}

Value *X86DCBasicBlock::getSF(X86::StatusFlag SF) {
  Value *SV = SFVals[SF];
  if (SV == 0) {
    SV = llvm::extractBitsFromValue(Builder.saveIP(), SF, 1,
                                    getReg(X86::EFLAGS));
    setSF(SF, SV);
  }
  return SV;
}
