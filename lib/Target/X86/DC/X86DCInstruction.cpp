//===-- X86DCInstruction.cpp - X86 Targeting of DCInstruction ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "X86DCInstruction.h"
#include "InstPrinter/X86ATTInstPrinter.h"
#include "InstPrinter/X86IntelInstPrinter.h"
#include "MCTargetDesc/X86MCTargetDesc.h"
#include "Utils/X86ShuffleDecode.h"
#include "X86ISelLowering.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/DC/DCModule.h"
#include "llvm/DC/RegisterValueUtils.h"
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
#include "X86GenSema.inc"
using namespace llvm;

#define DEBUG_TYPE "x86-dc-sema"

static MVT getSimpleVTForType(Type *Ty) {
  return EVT::getEVT(Ty).getSimpleVT();
}

X86DCInstruction::X86DCInstruction(DCBasicBlock &DCB, const MCDecodedInst &MCI)
    : DCInstruction(DCB, MCI, X86::OpcodeToSemaIdx, X86::InstSemantics,
                    X86::ConstantArray) {}

bool X86DCInstruction::doesSubRegIndexClearSuper(unsigned SubRegIdx) {
  if (SubRegIdx == X86::sub_32bit)
    return true;
  if (SubRegIdx == X86::sub_xmm) {
    auto &MII = getTranslator().getMII();
    const MCInstrDesc &MCID = MII.get(TheMCInst.Inst.getOpcode());
    // VEX-encoded SSE instructions clear [size-1:127].
    // FIXME: This should take into account VEX.vvvv, .LIG, ..
    if (MCID.TSFlags & X86II::VEX)
      return true;
  }
  return false;
}

bool X86DCInstruction::translateTargetInst() {
  unsigned Opcode = TheMCInst.Inst.getOpcode();

  if (getParent().LastPrefix) {
    unsigned Prefix = getParent().LastPrefix;
    // Reset the prefix.
    getParent().LastPrefix = 0;

    if (Prefix == X86::LOCK_PREFIX) {
      unsigned XADDMemOpType = X86::OpTypes::OPERAND_TYPE_INVALID;
      bool isINCDEC = false;
      AtomicRMWInst::BinOp AtomicOpc = AtomicRMWInst::BAD_BINOP;
      Instruction::BinaryOps Opc = Instruction::FAdd; // Invalid initializer
      switch (Opcode) {
      default:
        break;
      case X86::CMPXCHG8rm:
        translateCMPXCHG(X86::OpTypes::i8mem, X86::AL);
        return true;
      case X86::CMPXCHG16rm:
        translateCMPXCHG(X86::OpTypes::i16mem, X86::AX);
        return true;
      case X86::CMPXCHG32rm:
        translateCMPXCHG(X86::OpTypes::i32mem, X86::EAX);
        return true;
      case X86::CMPXCHG64rm:
        translateCMPXCHG(X86::OpTypes::i64mem, X86::RAX);
        return true;

      case X86::XADD8rm:
        XADDMemOpType = X86::OpTypes::i8mem;
        break;
      case X86::XADD16rm:
        XADDMemOpType = X86::OpTypes::i16mem;
        break;
      case X86::XADD32rm:
        XADDMemOpType = X86::OpTypes::i32mem;
        break;
      case X86::XADD64rm:
        XADDMemOpType = X86::OpTypes::i64mem;
        break;

      case X86::INC8m:
      case X86::INC16m:
      case X86::INC32m:
      case X86::INC64m:
        isINCDEC = true; // fallthrough
      case X86::ADD8mr:
      case X86::ADD16mr:
      case X86::ADD32mr:
      case X86::ADD64mr:
      case X86::ADD8mi:
      case X86::ADD16mi:
      case X86::ADD32mi:
      case X86::ADD16mi8:
      case X86::ADD32mi8:
      case X86::ADD64mi8:
      case X86::ADD64mi32:
        AtomicOpc = AtomicRMWInst::Add;
        Opc = Instruction::Add;
        break;
      case X86::DEC8m:
      case X86::DEC16m:
      case X86::DEC32m:
      case X86::DEC64m:
        isINCDEC = true; // fallthrough
      case X86::SUB8mr:
      case X86::SUB16mr:
      case X86::SUB32mr:
      case X86::SUB64mr:
      case X86::SUB8mi:
      case X86::SUB16mi:
      case X86::SUB32mi:
      case X86::SUB16mi8:
      case X86::SUB32mi8:
      case X86::SUB64mi8:
      case X86::SUB64mi32:
        AtomicOpc = AtomicRMWInst::Sub;
        Opc = Instruction::Sub;
        break;
      case X86::OR8mr:
      case X86::OR16mr:
      case X86::OR32mr:
      case X86::OR64mr:
      case X86::OR8mi:
      case X86::OR16mi:
      case X86::OR32mi:
      case X86::OR16mi8:
      case X86::OR32mi8:
      case X86::OR64mi8:
      case X86::OR64mi32:
        AtomicOpc = AtomicRMWInst::Or;
        Opc = Instruction::Or;
        break;
      case X86::XOR8mr:
      case X86::XOR16mr:
      case X86::XOR32mr:
      case X86::XOR64mr:
      case X86::XOR8mi:
      case X86::XOR16mi:
      case X86::XOR32mi:
      case X86::XOR16mi8:
      case X86::XOR32mi8:
      case X86::XOR64mi8:
      case X86::XOR64mi32:
        AtomicOpc = AtomicRMWInst::Xor;
        Opc = Instruction::Xor;
        break;
      case X86::AND8mr:
      case X86::AND16mr:
      case X86::AND32mr:
      case X86::AND64mr:
      case X86::AND8mi:
      case X86::AND16mi:
      case X86::AND32mi:
      case X86::AND16mi8:
      case X86::AND32mi8:
      case X86::AND64mi8:
      case X86::AND64mi32:
        AtomicOpc = AtomicRMWInst::And;
        Opc = Instruction::And;
        break;
      }

      Value *PointerOperand = nullptr, *Operand2 = nullptr, *Result = nullptr;

      // Either to a manual translation for XADD, or reuse the opcodes for
      // normal prefixed instructions.
      if (XADDMemOpType != X86::OpTypes::OPERAND_TYPE_INVALID) {
        AtomicOpc = AtomicRMWInst::Add;
        Opc = Instruction::Add;
        PointerOperand = translateCustomOperand(XADDMemOpType, 0);
        Operand2 = getReg(getRegOp(5));
      } else {
        if (AtomicOpc == AtomicRMWInst::BAD_BINOP)
          llvm_unreachable("Unknown LOCK-prefixed instruction");

        // First, translate the memory operand.
        unsigned NextOpc = Next();
        assert(NextOpc == DCINS::CUSTOM_OP &&
               "Expected X86 memory operand for LOCK-prefixed instruction");
        translateOpcode(NextOpc);
        PointerOperand = getLastDef();

        // Then, ignore the LOAD from that operand
        NextOpc = Next();
        assert(NextOpc == ISD::LOAD &&
               "Expected to load operand for X86 LOCK-prefixed instruction");
        /*VT=*/Next(); /*PointerOp=*/
        Next();

        // Finally, translate the second operand, if there is one.
        if (isINCDEC) {
          Operand2 = ConstantInt::get(
              PointerOperand->getType()->getPointerElementType(), 1);
        } else {
          NextOpc = Next();
          translateOpcode(NextOpc);
          Operand2 = getLastDef();
        }
      }

      // Translate LOCK-prefix into monotonic ordering.
      Value *Old = Builder.CreateAtomicRMW(AtomicOpc, PointerOperand, Operand2,
                                           AtomicOrdering::Monotonic);

      // If this was a XADD instruction, set the register to the old value.
      if (XADDMemOpType != X86::OpTypes::OPERAND_TYPE_INVALID)
        setReg(getRegOp(5), Old);

      // Finally, update EFLAGS.
      // FIXME: add support to X86DRS::updateEFLAGS for atomicrmw.
      Result = Builder.CreateBinOp(Opc, Old, Operand2);
      getParent().updateEFLAGS(Result, /*DontUpdateCF=*/isINCDEC);
      return true;
    } else if (Prefix == X86::REP_PREFIX) {
      unsigned SizeInBits = 0;
      switch (Opcode) {
      default:
        llvm_unreachable("Unknown rep-prefixed instruction");
      case X86::RETQ: {
        // Ignore the prefix in rep;ret.
        return false;
      }
      case X86::MOVSQ:
        SizeInBits = 64;
        break;
      case X86::MOVSL:
        SizeInBits = 32;
        break;
      case X86::MOVSW:
        SizeInBits = 16;
        break;
      case X86::MOVSB:
        SizeInBits = 8;
        break;
      }
      Type *MemTy = Type::getIntNPtrTy(Builder.getContext(), SizeInBits);
      Value *Dst = Builder.CreateIntToPtr(getReg(X86::RDI), MemTy);
      Value *Src = Builder.CreateIntToPtr(getReg(X86::RSI), MemTy);
      Value *Len = getReg(X86::RCX);
      // FIXME: Add support for reverse copying, depending on Direction Flag.
      // We don't support CLD/STD yet anyway, so this isn't a big deal for now.
      Type *MemcpyArgTys[] = {Dst->getType(), Src->getType(), Len->getType()};
      Builder.CreateCall(Intrinsic::getDeclaration(
                             getModule(), Intrinsic::memcpy, MemcpyArgTys),
                         {Dst, Src, Len,
                          /*Align=*/Builder.getInt32(1),
                          /*isVolatile=*/Builder.getInt1(false)});

      return true;
    }
    llvm_unreachable("Unable to translate prefixed instruction");
    return false;
  }

  switch (Opcode) {
  default:
    break;
  case X86::XCHG8rr:
  case X86::XCHG16rr:
  case X86::XCHG32rr:
  case X86::XCHG64rr: {
    unsigned R1 = getRegOp(0);
    unsigned R2 = getRegOp(1);
    Value *V1 = getReg(R1);
    Value *V2 = getReg(R2);
    setReg(R2, V1);
    setReg(R1, V2);
    return true;
  }

  case X86::XCHG16ar:
  case X86::XCHG32ar:
  case X86::XCHG32ar64:
  case X86::XCHG64ar: {
    unsigned R1 = getRegOp(0);
    unsigned R2;
    switch (Opcode) {
    case X86::XCHG16ar:
      R2 = X86::AX;
      break;
    case X86::XCHG32ar64:
    case X86::XCHG32ar:
      R2 = X86::EAX;
      break;
    case X86::XCHG64ar:
      R2 = X86::RAX;
      break;
    }
    Value *V1 = getReg(R1);
    Value *V2 = getReg(R2);
    setReg(R2, V1);
    setReg(R1, V2);
    return true;
  }

  case X86::NOOP:
  case X86::NOOPW:
  case X86::NOOPL:
    return true;

  case X86::HLT:
  case X86::XLAT:
  case X86::CPUID: {
    // FIXME: There's no reason to have a function, this is just a hack to get
    // it working.
    Builder.CreateCall(Intrinsic::getDeclaration(getModule(), Intrinsic::trap));
    Builder.CreateUnreachable();
    return true;
  }
  case X86::XGETBV: {
    // FIXME: XCR[0] support is missing, they're not even in X86RegisterInfo.td
    Builder.CreateCall(Intrinsic::getDeclaration(getModule(), Intrinsic::trap));
    Builder.CreateUnreachable();
    return true;
  }
  case X86::XSAVE: {
    // FIXME: See XGETBV.
    Builder.CreateCall(Intrinsic::getDeclaration(getModule(), Intrinsic::trap));
    Builder.CreateUnreachable();
    return true;
  }
  case X86::XRSTOR: {
    // FIXME: See XGETBV.
    Builder.CreateCall(Intrinsic::getDeclaration(getModule(), Intrinsic::trap));
    Builder.CreateUnreachable();
    return true;
  }

  case X86::REP_PREFIX:
  case X86::LOCK_PREFIX: {
    getParent().LastPrefix = Opcode;
    return true;
  }
  }
  return false;
}

bool X86DCInstruction::translateTargetOpcode(unsigned Opcode) {
  switch (Opcode) {
  default:
    errs() << "Unknown X86 opcode found in semantics: " + utostr(Opcode)
           << "\n";
    return false;
  case X86ISD::CMOV: {
    Value *Op0 = getOperand(0), *Op1 = getOperand(1), *Op2 = getOperand(2),
          *Op3 = getOperand(3);
    assert(Op3 == getReg(X86::EFLAGS) &&
           "Conditional mov predicate register isn't EFLAGS!");
    (void)Op3;
    unsigned CC = cast<ConstantInt>(Op2)->getValue().getZExtValue();
    Value *Pred = getParent().getCC((X86::CondCode)CC);
    addResult(Builder.CreateSelect(Pred, Op1, Op0));
    break;
  }
  case X86ISD::RET_FLAG: {
    // FIXME: Handle ret arg.
    setReg(X86::RIP, translatePop(8));
    Builder.CreateBr(getParentFunction().getExitBlock());
    break;
  }
  case X86ISD::CMP: {
    Value *Op0 = getOperand(0), *Op1 = getOperand(1);
    addResult(getParent().getEFLAGSforCMP(Op0, Op1));
    break;
  }
  case X86ISD::BRCOND: {
    Value *Op0 = getOperand(0), *Op1 = getOperand(1), *Op2 = getOperand(2);
    assert(Op2 == getReg(X86::EFLAGS) &&
           "Conditional branch predicate register isn't EFLAGS!");
    (void)Op2;
    uint64_t Target = cast<ConstantInt>(Op0)->getValue().getZExtValue();
    unsigned CC = cast<ConstantInt>(Op1)->getValue().getZExtValue();
    setReg(X86::RIP, Op0);
    Builder.CreateCondBr(getParent().getCC((X86::CondCode)CC),
                         getParentFunction().getOrCreateBasicBlock(Target),
                         getParentFunction().getOrCreateBasicBlock(
                             TheMCInst.Address + TheMCInst.Size));
    break;
  }
  case X86ISD::CALL: {
    Value *Op0 = getOperand(0);
    translatePush(Builder.getInt64(TheMCInst.Address + TheMCInst.Size));
    insertCall(Op0);
    break;
  }
  case X86ISD::SETCC: {
    Value *Op0 = getOperand(0), *Op1 = getOperand(1);
    assert(Op1 == getReg(X86::EFLAGS) &&
           "SetCC predicate register isn't EFLAGS!");
    (void)Op1;
    unsigned CC = cast<ConstantInt>(Op0)->getValue().getZExtValue();
    Value *Pred = getParent().getCC((X86::CondCode)CC);
    addResult(Builder.CreateZExt(Pred, Builder.getInt8Ty()));
    break;
  }
  case X86ISD::SBB: {
    Value *Op0 = getOperand(0), *Op1 = getOperand(1), *Op2 = getOperand(2);
    assert(Op2 == getReg(X86::EFLAGS) && "SBB borrow register isn't EFLAGS!");
    (void)Op2;
    Value *Borrow = Builder.CreateZExt(getParent().getSF(X86::CF), Op0->getType());
    Value *Res = Builder.CreateSub(Op0, Op1);
    addResult(Builder.CreateSub(Res, Borrow));
    addResult(getReg(X86::EFLAGS));
    break;
  }
  case X86ISD::BT: {
    Value *Base = getOperand(0);
    Value *Op1 = getOperand(1);
    Value *Offset = Builder.CreateZExtOrBitCast(Op1, Base->getType());
    Value *Bit = Builder.CreateTrunc(Builder.CreateShl(Base, Offset),
                                     Builder.getInt1Ty());

    Value *OldEFLAGS = getReg(X86::EFLAGS);
    Type *EFLAGSTy = OldEFLAGS->getType();
    APInt Mask = APInt::getAllOnesValue(EFLAGSTy->getPrimitiveSizeInBits());
    Mask.clearBit(X86::CF);
    OldEFLAGS =
        Builder.CreateAnd(OldEFLAGS, ConstantInt::get(getContext(), Mask));

    Bit = Builder.CreateZExt(Bit, EFLAGSTy);
    Bit = Builder.CreateLShr(Bit, X86::CF);
    addResult(Builder.CreateOr(OldEFLAGS, Bit));
    break;
  }

  case X86ISD::BSF: {
    Value *Src = getOperand(0);
    // If the source is zero, it is undefined behavior as per Intel SDM, but
    // most implementations I'm aware of just leave the destination unchanged.
    assert((TheMCInst.Inst.getOpcode() >= X86::BSF16rm &&
            TheMCInst.Inst.getOpcode() <= X86::BSF64rr) &&
           "Unexpected instruction with X86ISD::BSR node!");
    Value *IsSrcZero = Builder.CreateIsNull(Src);
    Value *PrevDstVal = getReg(TheMCInst.Inst.getOperand(0).getReg());
    Type *ArgTys[] = {PrevDstVal->getType(), Builder.getInt1Ty()};
    Value *Cttz = Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::cttz, ArgTys),
        {Src, /*is_zero_undef:*/ Builder.getInt1(true)});
    addResult(Builder.CreateSelect(IsSrcZero, PrevDstVal, Cttz));

    // We also need to update ZF in EFLAGS.
    Value *OldEFLAGS = getReg(X86::EFLAGS);
    addResult(llvm::insertBitsInValue(Builder.saveIP(), OldEFLAGS, IsSrcZero,
                                      X86::ZF));
    break;
  }
  case X86ISD::BSR: {
    Value *Src = getOperand(0);
    // If the source is zero, it is undefined behavior as per Intel SDM, but
    // most implementations I'm aware of just leave the destination unchanged.
    assert((TheMCInst.Inst.getOpcode() >= X86::BSR16rm &&
            TheMCInst.Inst.getOpcode() <= X86::BSR64rr) &&
           "Unexpected instruction with X86ISD::BSR node!");
    Value *IsSrcZero = Builder.CreateIsNull(Src);
    Value *PrevDstVal = getReg(TheMCInst.Inst.getOperand(0).getReg());
    Type *ArgTys[] = {PrevDstVal->getType(), Builder.getInt1Ty()};
    Value *Ctlz = Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::ctlz, ArgTys),
        {Src, /*is_zero_undef:*/ Builder.getInt1(true)});
    addResult(Builder.CreateSelect(IsSrcZero, PrevDstVal, Ctlz));

    // We also need to update ZF in EFLAGS.
    Value *OldEFLAGS = getReg(X86::EFLAGS);
    addResult(llvm::insertBitsInValue(Builder.saveIP(), OldEFLAGS, IsSrcZero,
                                      X86::ZF));
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

  case X86ISD::FSETCC: {
    enum SSECC { EQ, LT, LE, UNORD, NEQ, NLT, NLE, ORD, LastCC = ORD };
    Value *LHS = getOperand(0), *RHS = getOperand(1);
    Value *CCV = getOperand(2);

    const unsigned CCI = cast<ConstantInt>(CCV)->getZExtValue();
    assert(CCI <= SSECC::LastCC && "Invalid SSE CC!");
    const SSECC CC = (SSECC)CCI;

    CmpInst::Predicate Pred;
    switch (CC) {
    case EQ:
      Pred = CmpInst::FCMP_OEQ;
      break;
    case LT:
      Pred = CmpInst::FCMP_OLT;
      break;
    case LE:
      Pred = CmpInst::FCMP_OLE;
      break;
    case UNORD:
      Pred = CmpInst::FCMP_UNO;
      break;
    case NEQ:
      Pred = CmpInst::FCMP_UNE;
      break;
    case NLT:
      Pred = CmpInst::FCMP_UGE;
      break;
    case NLE:
      Pred = CmpInst::FCMP_UGT;
      break;
    case ORD:
      Pred = CmpInst::FCMP_ORD;
      break;
    }

    assert(getResultTy(0)->isFloatingPointTy());

    Value *Cmp = Builder.CreateFCmp(Pred, LHS, RHS);
    Cmp = Builder.CreateSExt(
        Cmp, Builder.getIntNTy(getResultTy(0)->getPrimitiveSizeInBits()));
    addResult(Builder.CreateBitCast(Cmp, getResultTy(0)));
    break;
  }

  case X86ISD::FMIN:
  case X86ISD::FMAX: {
    // FIXME: Ok this is an interesting one. The short version is: we don't
    // care about sNaN, since it's really missing from LLVM.
    // The result defaults to the second operand, so we do a backwards
    // fcmp+select.
    Value *Src0 = getOperand(0);
    Value *Src1 = getOperand(1);
    CmpInst::Predicate Pred;
    if (Opcode == X86ISD::FMAX)
      Pred = CmpInst::FCMP_ULE;
    else
      Pred = CmpInst::FCMP_UGE;
    addResult(
        Builder.CreateSelect(Builder.CreateFCmp(Pred, Src0, Src1), Src1, Src0));
    break;
  }
  case X86ISD::MOVLHPD:
  case X86ISD::MOVLPS:
  case X86ISD::MOVLPD:
  case X86ISD::MOVSD:
  case X86ISD::MOVSS: {
    Value *Src0 = getOperand(0);
    Value *Src1 = getOperand(1);
    Type *VecTy = getResultTy(0);
    assert(VecTy->isVectorTy() && VecTy == Src0->getType() &&
           VecTy == Src1->getType() &&
           "Operands to MOV/UNPCK shuffle aren't vectors!");
    unsigned NumElt = VecTy->getVectorNumElements();
    SmallVector<Constant *, 16> Mask;
    for (int i = 0, e = NumElt; i != e; ++i)
      Mask.push_back(Builder.getInt32(i));
    switch (Opcode) {
    case X86ISD::MOVLPD: // LPD and SD are equivalent.
    case X86ISD::MOVLPS: // LPS is just SS*2.
    case X86ISD::MOVSD:
    case X86ISD::MOVSS: {
      Mask[0] = Builder.getInt32(NumElt);
      if (Opcode == X86ISD::MOVLPS)
        Mask[1] = Builder.getInt32(NumElt + 1);
      break;
    }
    case X86ISD::MOVLHPD: {
      assert(NumElt == 2);
      Mask[1] = Builder.getInt32(NumElt);
      break;
    }
    }
    addResult(
        Builder.CreateShuffleVector(Src0, Src1, ConstantVector::get(Mask)));
    break;
  }
  case X86ISD::PSHUFB: {
    Value *Src = getOperand(0);
    Value *Mask = getOperand(1);
    const unsigned NumElts = getResultTy(0)->getVectorNumElements();

    // If the high bit (7) of the byte is set, the element is zeroed.
    // Do that on the entire vector first.
    Mask = Builder.CreateSelect(
        Builder.CreateICmpUGE(
            Mask, ConstantVector::getSplat(NumElts, Builder.getInt8(0x80))),
        Constant::getNullValue(Mask->getType()), Mask);

    // Of the remaining bits, only the least significant 4 are used.
    Mask = Builder.CreateAnd(
        Mask, ConstantVector::getSplat(NumElts, Builder.getInt8(0xF)));

    // For AVX vectors with 32 bytes the base of the shuffle is the half of
    // the vector we're inside. Split the whole vector to avoid lane selects.
    if (NumElts == 16) {
      addResult(translatePSHUFB(Src, Mask));
      break;
    }

    assert(NumElts == 32);
    const uint32_t ShufMask[32] = {0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10,
                                   11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
                                   22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
    ArrayRef<uint32_t> LoShuf(&ShufMask[0], 16), HiShuf(&ShufMask[16], 16);
    Value *UndefV = UndefValue::get(Src->getType());
    Value *SrcLo = Builder.CreateShuffleVector(Src, UndefV, LoShuf);
    Value *SrcHi = Builder.CreateShuffleVector(Src, UndefV, HiShuf);
    Value *MaskLo = Builder.CreateShuffleVector(Mask, UndefV, LoShuf);
    Value *MaskHi = Builder.CreateShuffleVector(Mask, UndefV, HiShuf);

    Value *ResLo = translatePSHUFB(SrcLo, MaskLo);
    Value *ResHi = translatePSHUFB(SrcHi, MaskHi);

    addResult(Builder.CreateShuffleVector(ResLo, ResHi, ShufMask));
    break;
  }
  case X86ISD::UNPCKL:
  case X86ISD::UNPCKH:
  case X86ISD::MOVLHPS:
  case X86ISD::MOVHLPS: {
    Value *Src0 = getOperand(0);
    Value *Src1 = getOperand(1);
    SmallVector<int, 8> Mask;
    switch (Opcode) {
    case X86ISD::MOVLHPS:
      DecodeMOVLHPSMask(getResultTy(0)->getVectorNumElements(), Mask);
      break;
    case X86ISD::MOVHLPS:
      DecodeMOVHLPSMask(getResultTy(0)->getVectorNumElements(), Mask);
      break;
    case X86ISD::UNPCKL:
      DecodeUNPCKLMask(getSimpleVTForType(getResultTy(0)), Mask);
      break;
    case X86ISD::UNPCKH:
      DecodeUNPCKHMask(getSimpleVTForType(getResultTy(0)), Mask);
      break;
    };
    translateShuffle(Mask, Src0, Src1);
    break;
  }
  case X86ISD::PSHUFD:
  case X86ISD::PSHUFHW:
  case X86ISD::PSHUFLW: {
    Value *Src = getOperand(0);
    unsigned MaskImm = cast<ConstantInt>(getOperand(1))->getZExtValue();
    SmallVector<int, 8> Mask;
    switch (Opcode) {
    case X86ISD::PSHUFD:
      DecodePSHUFMask(getSimpleVTForType(getResultTy(0)), MaskImm, Mask);
      break;
    case X86ISD::PSHUFHW:
      DecodePSHUFHWMask(getSimpleVTForType(getResultTy(0)), MaskImm, Mask);
      break;
    case X86ISD::PSHUFLW:
      DecodePSHUFLWMask(getSimpleVTForType(getResultTy(0)), MaskImm, Mask);
      break;
    };
    translateShuffle(Mask, Src);
    break;
  }
  case X86ISD::SHUFP:
  case X86ISD::PALIGNR: {
    Value *Src0 = getOperand(0);
    Value *Src1 = getOperand(1);
    unsigned MaskImm = cast<ConstantInt>(getOperand(2))->getZExtValue();
    SmallVector<int, 8> Mask;
    DecodePSHUFMask(getSimpleVTForType(getResultTy(0)), MaskImm, Mask);
    switch (Opcode) {
    case X86ISD::SHUFP:
      DecodeSHUFPMask(getSimpleVTForType(getResultTy(0)), MaskImm, Mask);
      break;
    case X86ISD::PALIGNR:
      DecodePALIGNRMask(getSimpleVTForType(getResultTy(0)), MaskImm, Mask);
      break;
    };
    translateShuffle(Mask, Src0, Src1);
    break;
  }
  case X86ISD::PCMPGT: {
    Value *Src0 = getOperand(0);
    Value *Src1 = getOperand(1);
    Constant *Ones = Constant::getAllOnesValue(getResultTy(0));
    Constant *Zero = Constant::getNullValue(getResultTy(0));
    addResult(
        Builder.CreateSelect(Builder.CreateICmpSGT(Src0, Src1), Ones, Zero));
    break;
  }
  case X86ISD::PCMPEQ: { // FIXME
    Value *Src0 = getOperand(0);
    Value *Src1 = getOperand(1);
    Constant *Ones = Constant::getAllOnesValue(getResultTy(0));
    Constant *Zero = Constant::getNullValue(getResultTy(0));
    addResult(
        Builder.CreateSelect(Builder.CreateICmpEQ(Src0, Src1), Ones, Zero));
    break;
  }

  case X86ISD::ANDNP: {
    Value *LHS = getOperand(0);
    Value *RHS = getOperand(1);
    Type *VecTy = getResultTy(0);
    (void)VecTy;
    assert(VecTy->isVectorTy() && VecTy->isIntOrIntVectorTy() &&
           VecTy == LHS->getType() && VecTy == RHS->getType() &&
           "Operands to ANDNP shuffle aren't vectors!");
    addResult(Builder.CreateAnd(Builder.CreateNot(LHS), RHS));
    break;
  }

  case X86ISD::VSHLI: {
    Value *Src0 = getOperand(0);
    auto *Src1 = cast<ConstantInt>(getOperand(1));
    addResult(Builder.CreateShl(Src0, Src1->getZExtValue()));
    break;
  }
  case X86ISD::VSRAI: {
    Value *Src0 = getOperand(0);
    auto *Src1 = cast<ConstantInt>(getOperand(1));
    addResult(Builder.CreateAShr(Src0, Src1->getZExtValue()));
    break;
  }
  case X86ISD::HSUB:
    translateHorizontalBinop(Instruction::Sub);
    break;
  case X86ISD::HADD:
    translateHorizontalBinop(Instruction::Add);
    break;
  case X86ISD::FHSUB:
    translateHorizontalBinop(Instruction::FSub);
    break;
  case X86ISD::FHADD:
    translateHorizontalBinop(Instruction::FAdd);
    break;

  case X86ISD::CVTSI2P: {
    Value *Src = getOperand(0);
    auto *SrcTy = cast<VectorType>(Src->getType());

    SmallVector<unsigned, 4> SrcMask(getResultTy(0)->getVectorNumElements());
    std::iota(SrcMask.begin(), SrcMask.end(), 0);

    addResult(Builder.CreateSIToFP(
        Builder.CreateShuffleVector(Src, UndefValue::get(SrcTy), SrcMask),
        getResultTy(0)));
    break;
  }
  }

  return true;
}

Value *X86DCInstruction::translateCustomOperand(unsigned OperandType,
                                                unsigned MIOpNo) {
  Value *Res = nullptr;

  switch (OperandType) {
  default:
    errs() << "Unknown X86 operand type found in semantics: "
           << utostr(OperandType) << "\n";
    return nullptr;

  case X86::OpTypes::i8mem:
    Res = translateAddr(MIOpNo, MVT::i8);
    break;
  case X86::OpTypes::i16mem:
    Res = translateAddr(MIOpNo, MVT::i16);
    break;
  case X86::OpTypes::i32mem:
    Res = translateAddr(MIOpNo, MVT::i32);
    break;
  case X86::OpTypes::i64mem:
    Res = translateAddr(MIOpNo, MVT::i64);
    break;
  case X86::OpTypes::f32mem:
    Res = translateAddr(MIOpNo, MVT::f32);
    break;
  case X86::OpTypes::f64mem:
    Res = translateAddr(MIOpNo, MVT::f64);
    break;
  case X86::OpTypes::f80mem:
    Res = translateAddr(MIOpNo, MVT::f80);
    break;

  // Just fallback to an integer for the rest, let the user decide the type.
  case X86::OpTypes::i128mem:
  case X86::OpTypes::i256mem:
  case X86::OpTypes::f128mem:
  case X86::OpTypes::f256mem:
  case X86::OpTypes::lea64mem:
    Res = translateAddr(MIOpNo);
    break;

  case X86::OpTypes::lea64_32mem: {
    Res = Builder.CreateTruncOrBitCast(translateAddr(MIOpNo),
                                       Builder.getInt32Ty());
    break;
  }

  case X86::OpTypes::offset16_8:
    Res = translateMemOffset(MIOpNo, MVT::i8);
    break;
  case X86::OpTypes::offset32_8:
    Res = translateMemOffset(MIOpNo, MVT::i8);
    break;
  case X86::OpTypes::offset64_8:
    Res = translateMemOffset(MIOpNo, MVT::i8);
    break;
  case X86::OpTypes::offset16_16:
    Res = translateMemOffset(MIOpNo, MVT::i16);
    break;
  case X86::OpTypes::offset32_16:
    Res = translateMemOffset(MIOpNo, MVT::i16);
    break;
  case X86::OpTypes::offset64_16:
    Res = translateMemOffset(MIOpNo, MVT::i16);
    break;
  case X86::OpTypes::offset16_32:
    Res = translateMemOffset(MIOpNo, MVT::i32);
    break;
  case X86::OpTypes::offset32_32:
    Res = translateMemOffset(MIOpNo, MVT::i32);
    break;
  case X86::OpTypes::offset64_32:
    Res = translateMemOffset(MIOpNo, MVT::i32);
    break;
  case X86::OpTypes::offset32_64:
    Res = translateMemOffset(MIOpNo, MVT::i64);
    break;
  case X86::OpTypes::offset64_64:
    Res = translateMemOffset(MIOpNo, MVT::i64);
    break;

  case X86::OpTypes::SSECC:
  case X86::OpTypes::u8imm:
  case X86::OpTypes::i1imm:
  case X86::OpTypes::i8imm:
  case X86::OpTypes::i16imm:
  case X86::OpTypes::i16i8imm:
  case X86::OpTypes::i32imm:
  case X86::OpTypes::i32i8imm:
  case X86::OpTypes::i32u8imm:
  case X86::OpTypes::i64i8imm:
  case X86::OpTypes::i64i32imm:
  case X86::OpTypes::i64imm: {
    // FIXME: Is there anything special to do with the sext/zext?
    Res = ConstantInt::get(cast<IntegerType>(getResultTy(0)), getImmOp(MIOpNo));
    // FIXME: factor this out in DCF.
    // lets us maintain DTIT info as well.
    break;
  }

  case X86::OpTypes::i64i32imm_pcrel:
  case X86::OpTypes::brtarget:
  case X86::OpTypes::brtarget8:
  case X86::OpTypes::brtarget16:
  case X86::OpTypes::brtarget32: {
    // FIXME: use MCInstrAnalysis for this kind of thing?
    uint64_t Target = getImmOp(MIOpNo) + TheMCInst.Address + TheMCInst.Size;
    Res = Builder.getInt64(Target);
    break;
  }
  }

  assert(Res);
  return Res;
}

bool X86DCInstruction::translateImplicit(unsigned RegNo) {
  assert(RegNo == X86::EFLAGS);
  // FIXME: We need to understand instructions that define multiple values.
  Value *Def = getLastDef();
  assert(Def && "Nothing was defined in an instruction with implicit EFLAGS?");
  getParent().updateEFLAGS(Def);
  return true;
}

Value *X86DCInstruction::translateAddr(unsigned MIOperandNo,
                                       MVT::SimpleValueType VT) {
  // FIXME: We should switch to TargetRegisterInfo/InstrInfo instead of MC,
  // first because of all things 64 bit mode (ESP/RSP, size of iPTR, ..).
  // We already depend on codegen in lots of places, maybe completely
  // switching to using MachineFunctions and TargetMachine makes sense?

  Value *Base = getReg(getRegOp(MIOperandNo));
  ConstantInt *Scale = Builder.getInt64(getImmOp(MIOperandNo + 1));
  Value *Index = getReg(getRegOp(MIOperandNo + 2));
  ConstantInt *Offset = Builder.getInt64(getImmOp(MIOperandNo + 3));

  Value *Res = 0;
  if (!Offset->isZero())
    Res = Offset;
  if (Index) {
    if (!Scale->isOne())
      Index = Builder.CreateMul(Index, Scale);
    Res = (Res ? Builder.CreateAdd(Index, Res) : Index);
  }
  if (Base)
    Res = (Res ? Builder.CreateAdd(Base, Res) : Base);

  assert(Res);

  if (VT != MVT::iPTRAny) {
    Type *PtrTy = EVT(VT).getTypeForEVT(getContext())->getPointerTo();
    Res = Builder.CreateIntToPtr(Res, PtrTy);
  }

  return Res;
}

Value *X86DCInstruction::translateMemOffset(unsigned MIOperandNo,
                                            MVT::SimpleValueType VT) {
  Value *Offset = Builder.getInt64(getImmOp(MIOperandNo));
  unsigned SegReg = getRegOp(MIOperandNo + 1);

  if (SegReg)
    report_fatal_error("Segments are unsupported!");

  if (VT != MVT::iPTRAny) {
    Type *PtrTy = EVT(VT).getTypeForEVT(getContext())->getPointerTo();
    Offset = Builder.CreateIntToPtr(Offset, PtrTy);
  }

  return Offset;
}

void X86DCInstruction::translatePush(Value *Val) {
  unsigned OpSize = Val->getType()->getPrimitiveSizeInBits() / 8;

  // FIXME: again assumes that we are in 64bit mode.
  Value *OldSP = getReg(X86::RSP);

  Value *OpSizeVal = ConstantInt::get(
      IntegerType::get(getContext(), OldSP->getType()->getIntegerBitWidth()),
      OpSize);
  Value *NewSP = Builder.CreateSub(OldSP, OpSizeVal);
  Value *SPPtr = Builder.CreateIntToPtr(NewSP, Val->getType()->getPointerTo());
  Builder.CreateStore(Val, SPPtr);

  setReg(X86::RSP, NewSP);
}

Value *X86DCInstruction::translatePop(unsigned OpSize) {
  // FIXME: again assumes that we are in 64bit mode.
  Value *OldSP = getReg(X86::RSP);

  Type *OpTy = IntegerType::get(getContext(), OpSize * 8);
  Value *OpSizeVal = ConstantInt::get(
      IntegerType::get(getContext(), OldSP->getType()->getIntegerBitWidth()),
      OpSize);
  Value *NewSP = Builder.CreateAdd(OldSP, OpSizeVal);
  Value *SPPtr = Builder.CreateIntToPtr(OldSP, OpTy->getPointerTo());
  Value *Val = Builder.CreateLoad(SPPtr);

  setReg(X86::RSP, NewSP);
  return Val;
}

void X86DCInstruction::translateHorizontalBinop(Instruction::BinaryOps BinOp) {
  Value *Src0 = getOperand(0), *Src1 = getOperand(1);
  Type *VecTy = getResultTy(0);
  assert(VecTy->isVectorTy());
  assert(VecTy == Src0->getType() && VecTy == Src1->getType());
  unsigned NumElt = VecTy->getVectorNumElements();
  Value *Res = UndefValue::get(VecTy);
  Value *Srcs[2] = {Src0, Src1};
  for (int opi = 0, ope = 2; opi != ope; ++opi) {
    for (int i = 0, e = NumElt / 2; i != e; ++i) {
      Value *EltL =
          Builder.CreateExtractElement(Srcs[opi], Builder.getInt32(i));
      Value *EltR =
          Builder.CreateExtractElement(Srcs[opi], Builder.getInt32(i + 1));
      Value *EltRes = Builder.CreateBinOp(BinOp, EltL, EltR);
      Res = Builder.CreateInsertElement(Res, EltRes,
                                        Builder.getInt32(i + opi * NumElt));
    }
  }
  addResult(Res);
}

void X86DCInstruction::translateDivRem(bool isThreeOperand, bool isSigned) {
  assert(getResultTy(1) == getResultTy(0) &&
         "X86 division result type mismatch!");

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

  Value *Dividend, *Divisor;
  if (isThreeOperand) {
    Value *Op0 = getOperand(0), *Op1 = getOperand(1);
    IntegerType *HalfType = cast<IntegerType>(getResultTy(0));
    unsigned HalfBits = HalfType->getPrimitiveSizeInBits();
    IntegerType *FullType = IntegerType::get(getContext(), HalfBits * 2);
    Value *DivHi = Builder.CreateCast(Instruction::ZExt, Op0, FullType);
    Value *DivLo = Builder.CreateCast(Instruction::ZExt, Op1, FullType);
    Dividend = Builder.CreateOr(
        Builder.CreateShl(DivHi, ConstantInt::get(FullType, HalfBits)), DivLo);
    Divisor = getOperand(2);
  } else {
    Dividend = getOperand(0);
    Divisor = getOperand(1);
  }

  Divisor = Builder.CreateCast(ExtOp, Divisor, Dividend->getType());

  addResult(Builder.CreateTrunc(Builder.CreateBinOp(DivOp, Dividend, Divisor),
                                getResultTy(0)));
  addResult(Builder.CreateTrunc(Builder.CreateBinOp(RemOp, Dividend, Divisor),
                                getResultTy(0)));
}

Value *X86DCInstruction::translatePSHUFB(Value *V, Value *Mask) {
  assert(V->getType() == Mask->getType());
  assert(V->getType()->getVectorNumElements() == 16);
  assert(V->getType()->getVectorElementType() == Builder.getInt8Ty());

  Value *Res = UndefValue::get(V->getType());
  for (int i = 0; i < 16; ++i) {
    // Get the next element from the source.
    Value *Elt = Builder.CreateExtractElement(V, Builder.getInt32(i));
    // Get the corresponding index from the mask.
    Value *Idx = Builder.CreateExtractElement(Mask, Builder.getInt32(i));
    // And put the element at that index in the result.
    Res = Builder.CreateInsertElement(Res, Elt, Idx);
  }
  return Res;
}

void X86DCInstruction::translateShuffle(SmallVectorImpl<int> &Mask, Value *V0,
                                        Value *V1) {
  Type *VecTy = V0->getType();
  Type *EltTy = VecTy->getVectorElementType();
  unsigned NumElts = VecTy->getVectorNumElements();

  SmallVector<Constant *, 8> MaskCV(NumElts);

  bool V1IsZero = false;

  for (size_t i = 0; i < Mask.size(); ++i) {
    if (Mask[i] == SM_SentinelZero) {
      V1IsZero = true;
      MaskCV[i] = Builder.getInt32(NumElts);
    } else if (Mask[i] == SM_SentinelUndef)
      MaskCV[i] = UndefValue::get(EltTy);
    else
      MaskCV[i] = Builder.getInt32(Mask[i]);
  }

  assert((!V1IsZero || !V1) &&
         "Second shuffle input can't be zero and an operand at the same time!");

  if (!V1)
    V1 = UndefValue::get(V0->getType());
  if (V1IsZero)
    V1 = Constant::getNullValue(VecTy);

  addResult(Builder.CreateShuffleVector(V0, V1, ConstantVector::get(MaskCV)));
}

void X86DCInstruction::translateCMPXCHG(unsigned MemOpType, unsigned CmpReg) {
  // First, translate the mem operand.
  Value *PointerOperand = translateCustomOperand(MemOpType, 0);

  // Next, get the A-reg compare value.
  Value *CmpVal = getReg(CmpReg);

  // Finally, get the register operands value.
  Value *Operand2 = getReg(getRegOp(5));

  // Translate LOCK-prefix into monotonic ordering.
  // FIXME: monotonic doesn't make much sense here.
  Value *OldPair = Builder.CreateAtomicCmpXchg(PointerOperand, CmpVal, Operand2,
                                               AtomicOrdering::Monotonic,
                                               AtomicOrdering::Monotonic);

  Value *OldVal = Builder.CreateExtractValue(OldPair, 0);
  Value *Success = Builder.CreateExtractValue(OldPair, 1);

  setReg(CmpReg, Builder.CreateSelect(Success, CmpVal, OldVal));

  // Finally, update EFLAGS.
  // FIXME: add support to X86DRS::updateEFLAGS for cmpxchg.
  Value *Result = Builder.CreateBinOp(Instruction::Sub, CmpVal, OldVal);
  getParent().updateEFLAGS(Result);
}
