#include "X86InstrSema.h"
#include "X86RegisterSema.h"
#include "InstPrinter/X86ATTInstPrinter.h"
#include "InstPrinter/X86IntelInstPrinter.h"
#include "MCTargetDesc/X86MCTargetDesc.h"
#include "X86ISelLowering.h"

#include "llvm/ADT/APInt.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/TypeBuilder.h"

#include "X86GenSema.inc"

using namespace llvm;

X86InstrSema::X86InstrSema(DCRegisterSema &DRS)
    : DCInstrSema(X86::OpcodeToSemaIdx, X86::InstSemantics, X86::ConstantArray,
                  DRS),
      X86DRS((X86RegisterSema &)DRS) {}

bool X86InstrSema::translateTargetInst() {
  unsigned Opcode = CurrentInst->Inst.getOpcode();
  if (Opcode == X86::NOOP ||
      Opcode == X86::NOOPW ||
      Opcode == X86::NOOPL)
    return true;
  return false;
}

void X86InstrSema::translateTargetOpcode() {
  switch(Opcode) {
  default:
    llvm_unreachable(
        ("Unknown X86 opcode found in semantics: " + utostr(Opcode)).c_str());
  case X86ISD::CMOV: {
    unsigned Op1 = Next(), Op2 = Next(), Op3 = Next(), Op4 = Next();
    assert(Vals[Op4] == getReg(X86::EFLAGS) &&
           "Conditional mov predicate register isn't EFLAGS!");
    (void)Op4;
    unsigned CC = cast<ConstantInt>(Vals[Op3])->getValue().getZExtValue();
    Value *Pred = X86DRS.testCondCode(CC);
    Vals.push_back(Builder->CreateSelect(Pred, Vals[Op2], Vals[Op1]));
    break;
  }
  case X86ISD::RET_FLAG: {
    // FIXME: Handle ret arg.
    /* unsigned Op1 = */ Next();
    setReg(X86::RIP, translatePop(8));
    Builder->CreateBr(ExitBB);
    break;
  }
  case X86ISD::CMP: {
    unsigned Op1 = Next(), Op2 = Next();
    Vals.push_back(X86DRS.getEFLAGSforCMP(Vals[Op1], Vals[Op2]));
    break;
  }
  case X86ISD::BRCOND: {
    unsigned Op1 = Next(), Op2 = Next(), Op3 = Next();
    assert(Vals[Op3] == getReg(X86::EFLAGS) &&
           "Conditional branch predicate register isn't EFLAGS!");
    (void)Op3;
    uint64_t Target = cast<ConstantInt>(Vals[Op1])->getValue().getZExtValue();
    unsigned CC = cast<ConstantInt>(Vals[Op2])->getValue().getZExtValue();
    setReg(X86::RIP, Vals[Op1]);
    Builder->CreateCondBr(X86DRS.testCondCode(CC),
                          getOrCreateBasicBlock(Target),
                          getOrCreateBasicBlock(BBEndAddr + 1));
    break;
  }
  case X86ISD::CALL: {
    unsigned Op1 = Next();
    translatePush(Builder->getInt64(CurrentInst->Address + CurrentInst->Size));
    insertCall(Vals[Op1]);
    break;
  }
  case X86ISD::SETCC: {
    unsigned Op1 = Next(), Op2 = Next();
    assert(Vals[Op2] == getReg(X86::EFLAGS) &&
           "SetCC predicate register isn't EFLAGS!");
    (void)Op2;
    unsigned CC = cast<ConstantInt>(Vals[Op1])->getValue().getZExtValue();
    Value *Pred = X86DRS.testCondCode(CC);
    Vals.push_back(Builder->CreateZExt(Pred, Builder->getInt8Ty()));
    break;
  }
  case X86ISD::SBB: {
    (void)NextVT();
    unsigned Op1 = Next(), Op2 = Next(), Op3 = Next();
    assert(Vals[Op3] == getReg(X86::EFLAGS) &&
           "SBB borrow register isn't EFLAGS!");
    (void)Op3;
    Value *Borrow =
        Builder->CreateZExt(X86DRS.testCondCode(X86::CF), Vals[Op1]->getType());
    Value *Res = Builder->CreateSub(Vals[Op1], Vals[Op2]);
    Vals.push_back(Builder->CreateSub(Res, Borrow));
    Vals.push_back(getReg(X86::EFLAGS));
    break;
  }
  case X86ISD::BT: {
    unsigned Op1 = Next(), Op2 = Next();
    Value *Base = Vals[Op1];
    Value *Offset = Builder->CreateZExtOrBitCast(Vals[Op2], Base->getType());
    Value *Bit = Builder->CreateTrunc(Builder->CreateShl(Base, Offset),
                                      Builder->getInt1Ty());

    Value *OldEFLAGS = getReg(X86::EFLAGS);
    Type *EFLAGSTy = OldEFLAGS->getType();
    APInt Mask = APInt::getAllOnesValue(EFLAGSTy->getPrimitiveSizeInBits());
    Mask.clearBit(X86::CF);
    OldEFLAGS = Builder->CreateAnd(OldEFLAGS, ConstantInt::get(*Ctx, Mask));

    Bit = Builder->CreateZExt(Bit, EFLAGSTy);
    Bit = Builder->CreateLShr(Bit, X86::CF);
    Vals.push_back(Builder->CreateOr(OldEFLAGS, Bit));
    break;
  }

  case X86DCISD::DIV8:
    translateDivRem(/* isThreeOperand= */ false, /* isSigned= */ false);
    break;
  case X86DCISD::IDIV8:
    translateDivRem(/* isThreeOperand= */ false, /* isSigned= */ true);
    break;
  case X86DCISD::DIV:
    translateDivRem(/* isThreeOperand= */ true, /* isSigned= */ false);
    break;
  case X86DCISD::IDIV:
    translateDivRem(/* isThreeOperand= */ true, /* isSigned= */ true);
    break;

  case X86ISD::FMIN:
  case X86ISD::FMAX: {
    // FIXME: Ok this is an interesting one. The short version is: we don't
    // care about sNaN, since it's really missing from LLVM.
    // The result defaults to the second operand, so we do a backwards
    // fcmp+select.
    Value *Src1 = Vals[Next()];
    Value *Src2 = Vals[Next()];
    CmpInst::Predicate Pred;
    if (Opcode == X86ISD::FMAX)
      Pred = CmpInst::FCMP_ULE;
    else
      Pred = CmpInst::FCMP_UGE;
    Vals.push_back(Builder->CreateSelect(Builder->CreateFCmp(Pred, Src1, Src2),
                                         Src2, Src1));
    break;
  }
  case X86ISD::MOVLHPS:
  case X86ISD::MOVLHPD:
  case X86ISD::MOVHLPS:
  case X86ISD::MOVLPS:
  case X86ISD::MOVLPD:
  case X86ISD::MOVSD:
  case X86ISD::MOVSS:
  case X86ISD::UNPCKH:
  case X86ISD::UNPCKL: {
    Value *Src1 = Vals[Next()];
    Value *Src2 = Vals[Next()];
    Type *VecTy = ResEVT.getTypeForEVT(*Ctx);
    assert(VecTy->isVectorTy() && VecTy == Src1->getType() &&
           VecTy == Src2->getType() &&
           "Operands to MOV/UNPCK shuffle aren't vectors!");
    unsigned NumElt = VecTy->getVectorNumElements();
    SmallVector<Constant *, 16> Mask;
    for (int i = 0, e = NumElt; i != e; ++i)
      Mask.push_back(Builder->getInt32(i));
    switch (Opcode) {
    case X86ISD::MOVLPD: // LPD and SD are equivalent.
    case X86ISD::MOVLPS: // LPS is just SS*2.
    case X86ISD::MOVSD:
    case X86ISD::MOVSS: {
      Mask[0] = Builder->getInt32(NumElt);
      if (Opcode == X86ISD::MOVLPS)
        Mask[1] = Builder->getInt32(NumElt + 1);
      break;
    }
    case X86ISD::MOVLHPS: {
      assert(NumElt == 4);
      Mask[2] = Builder->getInt32(NumElt);
      Mask[3] = Builder->getInt32(NumElt + 1);
      break;
    }
    case X86ISD::MOVHLPS: {
      assert(NumElt == 4);
      Mask[0] = Builder->getInt32(NumElt + 2);
      Mask[1] = Builder->getInt32(NumElt + 3);
      break;
    }
    case X86ISD::MOVLHPD: {
      assert(NumElt == 2);
      Mask[1] = Builder->getInt32(NumElt);
      break;
    }
    case X86ISD::UNPCKH:
    case X86ISD::UNPCKL: {
      int offset = (Opcode == X86ISD::UNPCKH ? NumElt / 2 : 0);
      for (int i = 0, e = NumElt / 2; i != e; ++i) {
        Mask[i] = Builder->getInt32(offset + i);
        Mask[i + 1] = Builder->getInt32(offset + i + NumElt);
      }
      break;
    }
    }
    Vals.push_back(
        Builder->CreateShuffleVector(Src1, Src2, ConstantVector::get(Mask)));
    break;
  }
  case X86ISD::PSHUFD: {
    Value *Src = Vals[Next()];
    uint64_t Order = cast<ConstantInt>(Vals[Next()])->getValue().getZExtValue();
    Type *VecTy = ResEVT.getTypeForEVT(*Ctx);
    assert(VecTy->isVectorTy() && VecTy == Src->getType());
    unsigned NumElt = VecTy->getVectorNumElements();
    SmallVector<Constant *, 8> Mask;
    unsigned i;
    for (i = 0; i != 4; ++i)
      Mask.push_back(Builder->getInt32((Order >> (i * 2)) & 3));
    // If Src is bigger than v4, this is a VPSHUFD, so clear the upper bits.
    for (; i != NumElt; ++i)
      Mask.push_back(Builder->getInt32(NumElt + i));
    Vals.push_back(Builder->CreateShuffleVector(Src,
                                                Constant::getNullValue(VecTy),
                                                ConstantVector::get(Mask)));
    break;
  }
  case X86ISD::HSUB:  translateHorizontalBinop(Instruction::Sub);  break;
  case X86ISD::HADD:  translateHorizontalBinop(Instruction::Add);  break;
  case X86ISD::FHSUB: translateHorizontalBinop(Instruction::FSub); break;
  case X86ISD::FHADD: translateHorizontalBinop(Instruction::FAdd); break;
  }
}

void X86InstrSema::translateCustomOperand(unsigned OperandType,
                                          unsigned MIOpNo) {
  switch(OperandType) {
  default:
    llvm_unreachable(("Unknown X86 operand type found in semantics: " +
                     utostr(OperandType)).c_str());

  case X86::OpTypes::i8mem : translateAddr(MIOpNo, MVT::i8); break;
  case X86::OpTypes::i16mem: translateAddr(MIOpNo, MVT::i16); break;
  case X86::OpTypes::i32mem: translateAddr(MIOpNo, MVT::i32); break;
  case X86::OpTypes::i64mem: translateAddr(MIOpNo, MVT::i64); break;
  case X86::OpTypes::f32mem: translateAddr(MIOpNo, MVT::f32); break;
  case X86::OpTypes::f64mem: translateAddr(MIOpNo, MVT::f64); break;
  case X86::OpTypes::f80mem: translateAddr(MIOpNo, MVT::f80); break;

  // Just fallback to an integer for the rest, let the user decide the type.
  case X86::OpTypes::i128mem :
  case X86::OpTypes::i256mem :
  case X86::OpTypes::f128mem :
  case X86::OpTypes::f256mem :
  case X86::OpTypes::lea64mem: translateAddr(MIOpNo); break;

  case X86::OpTypes::lea64_32mem: {
    translateAddr(MIOpNo);
    Value *&Ptr = Vals.back();
    Ptr = Builder->CreateTruncOrBitCast(Ptr, Builder->getInt32Ty());
    break;
  }

  case X86::OpTypes::i64i32imm_pcrel:
  case X86::OpTypes::brtarget:
  case X86::OpTypes::brtarget8: {
    // FIXME: use MCInstrAnalysis for this kind of thing?
    uint64_t Target = getImmOp(MIOpNo) +
      CurrentInst->Address + CurrentInst->Size;
    Vals.push_back(Builder->getInt64(Target));
    break;
  }
  }
}

void X86InstrSema::translateImplicit(unsigned RegNo) {
  assert(RegNo == X86::EFLAGS);
  // FIXME: We need to understand instructions that define multiple values.
  Value *Def = 0;

  // Look for the last definition
  for (int i = Vals.size() - 1; i >= 0; --i) {
    if (Vals[i] != 0) {
      Def = Vals[i];
      break;
    }
  }
  assert(Def && "Nothing was defined in an instruction with implicit EFLAGS?");
  X86DRS.updateEFLAGS(Def);
}

void X86InstrSema::translateAddr(unsigned MIOperandNo,
                                 MVT::SimpleValueType VT) {
  // FIXME: We should switch to TargetRegisterInfo/InstrInfo instead of MC,
  // first because of all things 64 bit mode (ESP/RSP, size of iPTR, ..).
  // We already depend on codegen in lots of places, maybe completely
  // switching to using MachineFunctions and TargetMachine makes sense?

  Value *Base = getReg(getRegOp(MIOperandNo));
  ConstantInt *Scale = Builder->getInt64(getImmOp(MIOperandNo + 1));
  Value *Index = getReg(getRegOp(MIOperandNo + 2));
  ConstantInt *Offset = Builder->getInt64(getImmOp(MIOperandNo + 3));

  Value *Res = 0;
  if (!Offset->isZero())
    Res = Offset;
  if (Index) {
    if (!Scale->isOne())
      Index = Builder->CreateMul(Index, Scale);
    Res = (Res ? Builder->CreateAdd(Index, Res) : Index);
  }
  if (Base)
    Res = (Res ? Builder->CreateAdd(Base, Res) : Base);

  if (VT != MVT::iPTRAny) {
    Type *PtrTy = EVT(VT).getTypeForEVT(*Ctx)->getPointerTo();
    Res = Builder->CreateIntToPtr(Res, PtrTy);
  }

  Vals.push_back(Res);
}

void X86InstrSema::translatePush(Value *Val) {
  unsigned OpSize = Val->getType()->getPrimitiveSizeInBits() / 8;

  // FIXME: again assumes that we are in 64bit mode.
  Value *OldSP = getReg(X86::RSP);

  Value *OpSizeVal = ConstantInt::get(
      IntegerType::get(*Ctx, OldSP->getType()->getIntegerBitWidth()), OpSize);
  Value *NewSP = Builder->CreateSub(OldSP, OpSizeVal);
  Value *SPPtr = Builder->CreateIntToPtr(NewSP, Val->getType()->getPointerTo());
  Builder->CreateStore(Val, SPPtr);

  setReg(X86::RSP, NewSP);
}

Value *X86InstrSema::translatePop(unsigned OpSize) {
  // FIXME: again assumes that we are in 64bit mode.
  Value *OldSP = getReg(X86::RSP);

  Type *OpTy = IntegerType::get(*Ctx, OpSize * 8);
  Value *OpSizeVal = ConstantInt::get(
      IntegerType::get(*Ctx, OldSP->getType()->getIntegerBitWidth()), OpSize);
  Value *NewSP = Builder->CreateAdd(OldSP, OpSizeVal);
  Value *SPPtr = Builder->CreateIntToPtr(OldSP, OpTy->getPointerTo());
  Value *Val = Builder->CreateLoad(SPPtr);

  setReg(X86::RSP, NewSP);
  return Val;
}

void X86InstrSema::translateHorizontalBinop(Instruction::BinaryOps BinOp) {
  Value *Src1 = Vals[Next()];
  Value *Src2 = Vals[Next()];
  Type *VecTy = ResEVT.getTypeForEVT(*Ctx);
  assert(VecTy->isVectorTy());
  assert(VecTy == Src1->getType() && VecTy == Src2->getType());
  unsigned NumElt = VecTy->getVectorNumElements();
  Value *Res = UndefValue::get(VecTy);
  Value *Srcs[2] = { Src1, Src2 };
  for (int opi = 0, ope = 2; opi != ope; ++opi) {
    for (int i = 0, e = NumElt / 2; i != e; ++i) {
      Value *EltRes = Builder->CreateBinOp(
          BinOp, Builder->CreateExtractElement(Srcs[opi], Builder->getInt32(i)),
          Builder->CreateExtractElement(Srcs[opi], Builder->getInt32(i + 1)));
      Res = Builder->CreateInsertElement(Res, EltRes,
                                         Builder->getInt32(i + opi * NumElt));
    }
  }
  Vals.push_back(Res);
}

void X86InstrSema::translateDivRem(bool isThreeOperand, bool isSigned) {
  EVT Re2EVT = NextVT();
  assert(Re2EVT == ResEVT && "X86 division result type mismatch!");
  (void)Re2EVT;
  Type *ResType = ResEVT.getTypeForEVT(*Ctx);

  Instruction::CastOps ExtOp;
  Instruction::BinaryOps DivOp, RemOp;
  if (isSigned) {
    ExtOp = Instruction::SExt;
    DivOp = Instruction::SDiv;
    RemOp = Instruction::SRem;
  } else {
    ExtOp = Instruction::ZExt;
    DivOp = Instruction::UDiv;
    RemOp = Instruction::URem;
  }

  Value *Divisor;
  if (isThreeOperand) {
    unsigned Op1 = Next(), Op2 = Next();
    IntegerType *HalfType = cast<IntegerType>(ResType);
    unsigned HalfBits = HalfType->getPrimitiveSizeInBits();
    IntegerType *FullType = IntegerType::get(*Ctx, HalfBits * 2);
    Value *DivHi = Builder->CreateCast(ExtOp, Vals[Op1], FullType);
    Value *DivLo = Builder->CreateCast(ExtOp, Vals[Op2], FullType);
    Divisor = Builder->CreateOr(
        Builder->CreateShl(DivHi, ConstantInt::get(FullType, HalfBits)), DivLo);
  } else {
    Divisor = Vals[Next()];
  }

  Value *Dividend = Vals[Next()];
  Dividend = Builder->CreateCast(ExtOp, Dividend, Divisor->getType());

  Vals.push_back(Builder->CreateTrunc(
                     Builder->CreateBinOp(DivOp, Divisor, Dividend), ResType));
  Vals.push_back(Builder->CreateTrunc(
                     Builder->CreateBinOp(RemOp, Divisor, Dividend), ResType));
}
