//===-- lib/DC/DCInstruction.cpp - Instruction Translation ------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCInstruction.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/DC/DCRegisterSema.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "dc-sema"

static cl::opt<bool> TranslateUnknownToUndef(
    "dc-translate-unknown-to-undef",
    cl::desc("Translate unknown instruction or unknown opcode in an "
             "instruction's semantics with undef+unreachable. If false, "
             "abort."),
    cl::init(false));

static cl::opt<bool> EnableInstAddrSave("enable-dc-pc-save", cl::desc(""),
                                        cl::init(false));

extern "C" uintptr_t __llvm_dc_current_instr = 0;

DCInstruction::DCInstruction(DCBasicBlock &DCB, const MCDecodedInst &MCI,
                             const unsigned *OpcodeToSemaIdx,
                             const unsigned *SemanticsArray,
                             const uint64_t *ConstantArray)
    : DCB(DCB), TheMCInst(MCI), Builder(DCB.getBasicBlock()),
      SemaIdx(OpcodeToSemaIdx[MCI.Inst.getOpcode()]), ResTy(nullptr), Vals(),
      OpcodeToSemaIdx(OpcodeToSemaIdx), SemanticsArray(SemanticsArray),
      ConstantArray(ConstantArray) {

  getDRS().SwitchToInst(TheMCInst);
}

DCInstruction::~DCInstruction() {
}

bool DCInstruction::translate() {
  if (EnableInstAddrSave) {
    ConstantInt *CurIVal =
        Builder.getInt64(reinterpret_cast<uint64_t>(TheMCInst.Address));
    Value *CurIPtr = ConstantExpr::getIntToPtr(
        Builder.getInt64(reinterpret_cast<uint64_t>(&__llvm_dc_current_instr)),
        Builder.getInt64Ty()->getPointerTo());
    Builder.CreateStore(CurIVal, CurIPtr, true);
  }

  bool Success = tryTranslateInst();

  if (!Success && TranslateUnknownToUndef) {
    errs() << "Couldn't translate instruction: \n  ";
    errs() << "  " << getDRS().MII.getName(TheMCInst.Inst.getOpcode()) << ": "
           << TheMCInst.Inst << "\n";
    Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::trap));
    Builder.CreateUnreachable();
    Success = true;
  }

  Builder.ClearInsertionPoint();
  return Success;
}

Type *DCInstruction::NextTy() {
  auto NextVT = (MVT::SimpleValueType)Next();
  switch (NextVT) {
  case MVT::Other:
    return Builder.getVoidTy();
  case MVT::iPTR:
    // FIXME: This assumes 64-bit pointers; we have no way of knowing otherwise.
    assert(Builder.getInt64Ty() ==
               getModule()->getDataLayout().getIntPtrType(getContext()) &&
           "Target DataLayout disagrees on pointer width");
    return Builder.getInt64Ty();
  default:
    return EVT(NextVT).getTypeForEVT(getContext());
  }
}

void DCInstruction::insertCall(Value *CallTarget) {
  if (ConstantInt *CI = dyn_cast<ConstantInt>(CallTarget)) {
    uint64_t Target = CI->getValue().getZExtValue();
    CallTarget =
        getParent().getParent().getParent().getOrCreateFunction(Target);
  } else {
    CallTarget = Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::dc_translate_at),
        {Builder.CreateIntToPtr(CallTarget, Builder.getInt8PtrTy())});
    CallTarget = Builder.CreateBitCast(
        CallTarget,
        getParent().getParent().getParent().getFuncTy()->getPointerTo());
  }
  // Flush all live registers before doing the call.
  // Saving/restoring from the alloca to the regset will be done for all calls,
  // when finalizing the function.
  getDRS().saveAllLiveRegs();

  // Now do the call to the resolved target.
  Value *RegSetArg = &getFunction()->getArgumentList().front();
  auto *CI = Builder.CreateCall(CallTarget, {RegSetArg});
  getParent().getParent().addCallForRegSetSaveRestore(CI);

  // FIXME: Insert return address checking, to unwind back to the translator if
  // the call returned to an unexpected address.
}

void DCInstruction::translateBinOp(Instruction::BinaryOps Opc) {
  Value *V1 = getNextOperand();
  Value *V2 = getNextOperand();
  if (Instruction::isShift(Opc) && V2->getType() != V1->getType())
    V2 = Builder.CreateZExt(V2, V1->getType());
  registerResult(Builder.CreateBinOp(Opc, V1, V2));
}

void DCInstruction::translateCastOp(Instruction::CastOps Opc) {
  Value *Val = getNextOperand();
  registerResult(Builder.CreateCast(Opc, Val, ResTy));
}

bool DCInstruction::tryTranslateInst() {
  unsigned InstOpcode = TheMCInst.Inst.getOpcode();
  if (translateTargetInst(InstOpcode))
    return true;

  SemaIdx = OpcodeToSemaIdx[InstOpcode];
  if (SemaIdx == ~0U)
    return false;

  {
    // Increment the PC before anything.
    Value *OldPC = getReg(getDRS().MRI.getProgramCounter());
    setReg(getDRS().MRI.getProgramCounter(),
           Builder.CreateAdd(
               OldPC, ConstantInt::get(OldPC->getType(), TheMCInst.Size)));
  }

  unsigned Opcode;
  while ((Opcode = Next()) != DCINS::END_OF_INSTRUCTION)
    if (!translateOpcode(Opcode))
      return false;

  return true;
}

bool DCInstruction::translateOpcode(unsigned Opcode) {
  ResTy = NextTy();
  if (Opcode >= ISD::BUILTIN_OP_END && Opcode < DCINS::DC_OPCODE_START)
    return translateTargetOpcode(Opcode);

  switch (Opcode) {
  case ISD::ADD:
    translateBinOp(Instruction::Add);
    break;
  case ISD::FADD:
    translateBinOp(Instruction::FAdd);
    break;
  case ISD::SUB:
    translateBinOp(Instruction::Sub);
    break;
  case ISD::FSUB:
    translateBinOp(Instruction::FSub);
    break;
  case ISD::MUL:
    translateBinOp(Instruction::Mul);
    break;
  case ISD::FMUL:
    translateBinOp(Instruction::FMul);
    break;
  case ISD::UDIV:
    translateBinOp(Instruction::UDiv);
    break;
  case ISD::SDIV:
    translateBinOp(Instruction::SDiv);
    break;
  case ISD::FDIV:
    translateBinOp(Instruction::FDiv);
    break;
  case ISD::UREM:
    translateBinOp(Instruction::URem);
    break;
  case ISD::SREM:
    translateBinOp(Instruction::SRem);
    break;
  case ISD::FREM:
    translateBinOp(Instruction::FRem);
    break;
  case ISD::SHL:
    translateBinOp(Instruction::Shl);
    break;
  case ISD::SRL:
    translateBinOp(Instruction::LShr);
    break;
  case ISD::SRA:
    translateBinOp(Instruction::AShr);
    break;
  case ISD::AND:
    translateBinOp(Instruction::And);
    break;
  case ISD::OR:
    translateBinOp(Instruction::Or);
    break;
  case ISD::XOR:
    translateBinOp(Instruction::Xor);
    break;

  case ISD::TRUNCATE:
    translateCastOp(Instruction::Trunc);
    break;
  case ISD::BITCAST:
    translateCastOp(Instruction::BitCast);
    break;
  case ISD::ZERO_EXTEND:
    translateCastOp(Instruction::ZExt);
    break;
  case ISD::SIGN_EXTEND:
    translateCastOp(Instruction::SExt);
    break;
  case ISD::FP_TO_UINT:
    translateCastOp(Instruction::FPToUI);
    break;
  case ISD::FP_TO_SINT:
    translateCastOp(Instruction::FPToSI);
    break;
  case ISD::UINT_TO_FP:
    translateCastOp(Instruction::UIToFP);
    break;
  case ISD::SINT_TO_FP:
    translateCastOp(Instruction::SIToFP);
    break;
  case ISD::FP_ROUND:
    translateCastOp(Instruction::FPTrunc);
    break;
  case ISD::FP_EXTEND:
    translateCastOp(Instruction::FPExt);
    break;

  case ISD::FSQRT: {
    Value *V = getNextOperand();
    registerResult(Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::sqrt, V->getType()),
        {V}));
    break;
  }

  case ISD::ROTL: {
    Value *LHS = getNextOperand();
    Type *Ty = LHS->getType();
    assert(Ty->isIntegerTy());
    Value *RHS = Builder.CreateZExt(getNextOperand(), Ty);
    // FIXME: RHS needs to be tweaked to avoid undefined results.
    Value *Shl = Builder.CreateShl(LHS, RHS);
    registerResult(Builder.CreateOr(
        Shl,
        Builder.CreateLShr(
            LHS, Builder.CreateSub(
                     ConstantInt::get(Ty, Ty->getScalarSizeInBits()), RHS))));
    break;
  }

  case ISD::INSERT_VECTOR_ELT: {
    Value *Vec = getNextOperand();
    Value *Val = getNextOperand();
    Value *Idx = getNextOperand();
    registerResult(Builder.CreateInsertElement(Vec, Val, Idx));
    break;
  }

  case ISD::EXTRACT_VECTOR_ELT: {
    Value *Val = getNextOperand();
    Value *Idx = getNextOperand();
    registerResult(Builder.CreateExtractElement(Val, Idx));
    break;
  }

  case ISD::SMUL_LOHI: {
    Type *Res2Ty = NextTy();
    IntegerType *LoResType = cast<IntegerType>(ResTy);
    IntegerType *HiResType = cast<IntegerType>(Res2Ty);
    IntegerType *ResType = IntegerType::get(
        getContext(), LoResType->getBitWidth() + HiResType->getBitWidth());
    Value *Op1 = Builder.CreateSExt(getNextOperand(), ResType);
    Value *Op2 = Builder.CreateSExt(getNextOperand(), ResType);
    Value *Full = Builder.CreateMul(Op1, Op2);
    registerResult(Builder.CreateTrunc(Full, LoResType));
    registerResult(Builder.CreateTrunc(
        Builder.CreateLShr(Full, LoResType->getBitWidth()), HiResType));
    break;
  }
  case ISD::UMUL_LOHI: {
    Type *Res2Ty = NextTy();
    IntegerType *LoResType = cast<IntegerType>(ResTy);
    IntegerType *HiResType = cast<IntegerType>(Res2Ty);
    IntegerType *ResType = IntegerType::get(
        getContext(), LoResType->getBitWidth() + HiResType->getBitWidth());
    Value *Op1 = Builder.CreateZExt(getNextOperand(), ResType);
    Value *Op2 = Builder.CreateZExt(getNextOperand(), ResType);
    Value *Full = Builder.CreateMul(Op1, Op2);
    registerResult(Builder.CreateTrunc(Full, LoResType));
    registerResult(Builder.CreateTrunc(
        Builder.CreateLShr(Full, LoResType->getBitWidth()), HiResType));
    break;
  }
  case ISD::LOAD: {
    Type *ResPtrTy = ResTy->getPointerTo();
    Value *Ptr = getNextOperand();
    if (!Ptr->getType()->isPointerTy())
      Ptr = Builder.CreateIntToPtr(Ptr, ResPtrTy);
    else if (Ptr->getType() != ResPtrTy)
      Ptr = Builder.CreateBitCast(Ptr, ResPtrTy);
    registerResult(Builder.CreateAlignedLoad(Ptr, 1));
    break;
  }
  case ISD::STORE: {
    Value *Val = getNextOperand();
    Value *Ptr = getNextOperand();
    Type *ValPtrTy = Val->getType()->getPointerTo();
    Type *PtrTy = Ptr->getType();
    if (!PtrTy->isPointerTy())
      Ptr = Builder.CreateIntToPtr(Ptr, ValPtrTy);
    else if (PtrTy != ValPtrTy)
      Ptr = Builder.CreateBitCast(Ptr, ValPtrTy);
    Builder.CreateAlignedStore(Val, Ptr, 1);
    break;
  }
  case ISD::BRIND: {
    Value *Op1 = getNextOperand();
    setReg(getDRS().MRI.getProgramCounter(), Op1);
    insertCall(Op1);
    Builder.CreateBr(getParent().getParent().getExitBlock());
    break;
  }
  case ISD::BR: {
    Value *Op1 = getNextOperand();
    uint64_t Target = cast<ConstantInt>(Op1)->getValue().getZExtValue();
    setReg(getDRS().MRI.getProgramCounter(), Op1);
    Builder.CreateBr(getParent().getParent().getOrCreateBasicBlock(Target));
    break;
  }
  case ISD::TRAP: {
    Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::trap));
    break;
  }
  case DCINS::PUT_RC: {
    unsigned MIOperandNo = Next();
    unsigned RegNo = getRegOp(MIOperandNo);
    Value *Res = getNextOperand();
    IntegerType *RegType = getDRS().getRegIntType(RegNo);
    if (Res->getType()->isPointerTy())
      Res = Builder.CreatePtrToInt(Res, RegType);
    if (!Res->getType()->isIntegerTy())
      Res = Builder.CreateBitCast(
          Res, IntegerType::get(getContext(),
                                Res->getType()->getPrimitiveSizeInBits()));
    if (Res->getType()->getPrimitiveSizeInBits() < RegType->getBitWidth())
      Res = getDRS().insertBitsInValue(getDRS().getRegAsInt(RegNo), Res);
    assert(Res->getType() == RegType);
    setReg(RegNo, Res);
    break;
  }
  case DCINS::PUT_REG: {
    unsigned RegNo = Next();
    Value *Res = getNextOperand();
    setReg(RegNo, Res);
    break;
  }
  case DCINS::GET_RC: {
    unsigned MIOperandNo = Next();
    Value *Reg = getDRS().getRegAsInt(getRegOp(MIOperandNo));
    if (ResTy->getPrimitiveSizeInBits() <
        Reg->getType()->getPrimitiveSizeInBits())
      Reg = Builder.CreateTrunc(
          Reg, IntegerType::get(getContext(), ResTy->getPrimitiveSizeInBits()));
    if (!ResTy->isIntegerTy())
      Reg = Builder.CreateBitCast(Reg, ResTy);
    registerResult(Reg);
    break;
  }
  case DCINS::GET_REG: {
    unsigned RegNo = Next();
    Value *RegVal = getReg(RegNo);
    registerResult(RegVal);
    break;
  }
  case DCINS::CUSTOM_OP: {
    unsigned OperandType = Next(), MIOperandNo = Next();
    Value *Op = translateCustomOperand(OperandType, MIOperandNo);
    if (!Op)
      return false;
    registerResult(Op);
    break;
  }
  case DCINS::COMPLEX_PATTERN: {
    unsigned Pattern = Next();
    Value *Op = translateComplexPattern(Pattern);
    if (!Op)
      return false;
    registerResult(Op);
    break;
  }
  case DCINS::PREDICATE: {
    unsigned Pred = Next();
    if (!translatePredicate(Pred))
      return false;
    break;
  }
  case DCINS::CONSTANT_OP: {
    unsigned MIOperandNo = Next();
    Value *Cst =
        ConstantInt::get(cast<IntegerType>(ResTy), getImmOp(MIOperandNo));
    registerResult(Cst);
    break;
  }
  case DCINS::MOV_CONSTANT: {
    uint64_t ValIdx = Next();

    const DataLayout &DL = getModule()->getDataLayout();
    Type *CTy = ResTy;
    if (!CTy->isIntegerTy())
      CTy = Builder.getIntNTy(DL.getTypeSizeInBits(CTy));
    Constant *C = ConstantInt::get(CTy, ConstantArray[ValIdx]);
    C = ConstantExpr::getCast(CastInst::getCastOpcode(C, /*SrcIsSigned=*/false,
                                                      ResTy,
                                                      /*DstIsSigned=*/false),
                              C, ResTy);
    registerResult(C);
    break;
  }
  case DCINS::IMPLICIT: {
    translateImplicit(Next());
    break;
  }
  case ISD::BSWAP: {
    Value *Op = getNextOperand();
    Value *IntDecl =
        Intrinsic::getDeclaration(getModule(), Intrinsic::bswap, ResTy);
    registerResult(Builder.CreateCall(IntDecl, Op));
    break;
  }

  case ISD::ATOMIC_FENCE: {
    uint64_t OrdV = cast<ConstantInt>(getNextOperand())->getZExtValue();
    uint64_t ScopeV = cast<ConstantInt>(getNextOperand())->getZExtValue();

    if (OrdV <= (uint64_t)AtomicOrdering::NotAtomic ||
        OrdV > (uint64_t)AtomicOrdering::SequentiallyConsistent)
      llvm_unreachable("Invalid atomic ordering");
    if (ScopeV != (uint64_t)SingleThread && ScopeV != (uint64_t)CrossThread)
      llvm_unreachable("Invalid synchronization scope");
    const AtomicOrdering Ord = (AtomicOrdering)OrdV;
    const SynchronizationScope Scope = (SynchronizationScope)ScopeV;

    Builder.CreateFence(Ord, Scope);
    break;
  }

  default:
    errs() << "Couldn't translate opcode for instruction: \n  ";
    errs() << "  " << getDRS().MII.getName(TheMCInst.Inst.getOpcode()) << ": "
           << TheMCInst.Inst << "\n";
    errs() << "Opcode: " << Opcode << "\n";
    return false;
  }
  return true;
}

Value *DCInstruction::translateComplexPattern(unsigned Pattern) {
  (void)Pattern;
  return nullptr;
}

bool DCInstruction::translateExtLoad(Type *MemTy, bool isSExt) {
  Value *Ptr = getNextOperand();
  Ptr = Builder.CreateBitOrPointerCast(Ptr, MemTy->getPointerTo());
  Value *V = Builder.CreateLoad(MemTy, Ptr);
  registerResult(isSExt ? Builder.CreateSExt(V, ResTy)
                        : Builder.CreateZExt(V, ResTy));
  return true;
}

bool DCInstruction::translatePredicate(unsigned Pred) {
  switch (Pred) {
  case TargetOpcode::Predicate::memop:
  case TargetOpcode::Predicate::loadi16:
  case TargetOpcode::Predicate::loadi32:
  case TargetOpcode::Predicate::alignedload:
  case TargetOpcode::Predicate::alignedload256:
  case TargetOpcode::Predicate::alignedload512:
  // FIXME: Take advantage of the implied alignment.
  case TargetOpcode::Predicate::load: {
    Type *ResPtrTy = ResTy->getPointerTo();
    Value *Ptr = getNextOperand();
    if (!Ptr->getType()->isPointerTy())
      Ptr = Builder.CreateIntToPtr(Ptr, ResPtrTy);
    else if (Ptr->getType() != ResPtrTy)
      Ptr = Builder.CreateBitCast(Ptr, ResPtrTy);
    registerResult(Builder.CreateAlignedLoad(Ptr, 1));
    return true;
  }
  case TargetOpcode::Predicate::alignednontemporalstore:
  case TargetOpcode::Predicate::nontemporalstore:
  case TargetOpcode::Predicate::alignedstore:
  case TargetOpcode::Predicate::alignedstore256:
  case TargetOpcode::Predicate::alignedstore512:
  // FIXME: Take advantage of NT/alignment.
  case TargetOpcode::Predicate::store: {
    Value *Val = getNextOperand();
    Value *Ptr = getNextOperand();
    Type *ValPtrTy = Val->getType()->getPointerTo();
    Type *PtrTy = Ptr->getType();
    if (!PtrTy->isPointerTy())
      Ptr = Builder.CreateIntToPtr(Ptr, ValPtrTy);
    else if (PtrTy != ValPtrTy)
      Ptr = Builder.CreateBitCast(Ptr, ValPtrTy);
    Builder.CreateAlignedStore(Val, Ptr, 1);
    return true;
  }
  case TargetOpcode::Predicate::zextloadi8:
    return translateExtLoad(Builder.getInt8Ty());
  case TargetOpcode::Predicate::zextloadi16:
    return translateExtLoad(Builder.getInt16Ty());
  case TargetOpcode::Predicate::sextloadi8:
    return translateExtLoad(Builder.getInt8Ty(), /*isSExt=*/true);
  case TargetOpcode::Predicate::sextloadi16:
    return translateExtLoad(Builder.getInt16Ty(), /*isSExt=*/true);
  case TargetOpcode::Predicate::sextloadi32:
    return translateExtLoad(Builder.getInt32Ty(), /*isSExt=*/true);

  case TargetOpcode::Predicate::and_su: {
    translateBinOp(Instruction::And);
    return true;
  }
  }
  return false;
}
