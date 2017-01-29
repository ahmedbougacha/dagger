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
#include "llvm/Support/Debug.h"
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
                             const uint16_t *SemanticsArray,
                             const uint64_t *ConstantArray)
    : DCB(DCB), TheMCInst(MCI), Builder(DCB.getBasicBlock()),
      SemaIdx(OpcodeToSemaIdx[MCI.Inst.getOpcode()]), ResTys(), Vals(),
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

void DCInstruction::prepareOperands() {
  for (unsigned OpI = 0; OpI != Ops.size(); ++OpI)
    Ops[OpI] = Vals[Next()];
}

void DCInstruction::dumpOperation(StringRef Opcode,
                                  ArrayRef<Type *> ResultTypes,
                                  ArrayRef<Value *> Operands,
                                  unsigned SemaStartIdx) {
  SemaStartIdx += 2;
  unsigned NumVal = Vals.size();
  dbgs() << "  - ";
  bool PrintComma = false;
  for (auto *Ty : ResultTypes) {
    if (PrintComma)
      dbgs() << ", ";
    dbgs() << '<' << NumVal++ << ">(";
    ++SemaStartIdx;
    if (Ty)
      Ty->print(dbgs(), /*IsForDebug=*/true, /*NoDetails=*/true);
    else
      dbgs() << "<null>";
    dbgs() << ')';
    PrintComma = true;
  }

  if (!ResultTypes.empty())
    dbgs() << " = ";

  dbgs() << Opcode << "(";

  PrintComma = false;
  for (auto *Op : Operands) {
    if (PrintComma)
      dbgs() << ", ";
    dbgs() << '<' << SemanticsArray[SemaStartIdx++] << ">(";
    if (Op)
      Op->printAsOperand(dbgs(), /*PrintType=*/true, getModule());
    else
      dbgs() << "<null>";
    dbgs() << ')';
    PrintComma = true;
  }
  dbgs() << ")\n";
}

void DCInstruction::insertCall(Value *CallTarget) {
  if (ConstantInt *CI = dyn_cast<ConstantInt>(CallTarget)) {
    uint64_t Target = CI->getValue().getZExtValue();
    CallTarget = getParentModule().getOrCreateFunction(Target);
  } else {
    CallTarget = Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::dc_translate_at),
        {Builder.CreateIntToPtr(CallTarget, Builder.getInt8PtrTy())});
    CallTarget = Builder.CreateBitCast(
        CallTarget, getParentModule().getFuncTy()->getPointerTo());
  }
  // Flush all live registers before doing the call.
  // Saving/restoring from the alloca to the regset will be done for all calls,
  // when finalizing the function.
  getDRS().saveAllLiveRegs();

  // Now do the call to the resolved target.
  Value *RegSetArg = &getFunction()->getArgumentList().front();
  auto *CI = Builder.CreateCall(CallTarget, {RegSetArg});
  getParentFunction().addCallForRegSetSaveRestore(CI);

  // FIXME: Insert return address checking, to unwind back to the translator if
  // the call returned to an unexpected address.
}

void DCInstruction::translateBinOp(Instruction::BinaryOps Opc) {
  Value *V0 = getOperand(0);
  Value *V1 = getOperand(1);
  if (Instruction::isShift(Opc) && V1->getType() != V0->getType())
    V1 = Builder.CreateZExt(V1, V0->getType());
  addResult(Builder.CreateBinOp(Opc, V0, V1));
}

void DCInstruction::translateCastOp(Instruction::CastOps Opc) {
  addResult(Builder.CreateCast(Opc, getOperand(0), getResultTy(0)));
}

bool DCInstruction::tryTranslateInst() {
  if (translateTargetInst())
    return true;

  SemaIdx = OpcodeToSemaIdx[TheMCInst.Inst.getOpcode()];
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

bool DCInstruction::translateDCOp(uint16_t Opcode) {
  switch (Opcode) {
  case DCINS::PUT_RC: {
    unsigned MIOperandNo = Next();
    unsigned ResOpIdx = Next();
    unsigned RegNo = getRegOp(MIOperandNo);
    Value *Res = Vals[ResOpIdx];

    DEBUG({
      dbgs() << "  - " << getDRS().MRI.getName(RegNo) << " = PUT_RC <"
             << ResOpIdx << ">(";
      Res->printAsOperand(dbgs());
      dbgs() << ")\n";
    });

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
    unsigned ResOpIdx = Next();
    Value *Res = Vals[ResOpIdx];

    DEBUG({
      dbgs() << "  - " << getDRS().MRI.getName(RegNo) << " = PUT_REG <"
             << ResOpIdx << ">(";
      Res->printAsOperand(dbgs());
      dbgs() << ")\n";
    });

    setReg(RegNo, Res);
    break;
  }
  case DCINS::GET_RC: {
    unsigned MIOperandNo = Next();
    unsigned RegNo = getRegOp(MIOperandNo);

    DEBUG({
      dbgs() << "  - <" << Vals.size() << ">(";
      ResTys[0]->print(dbgs(), /*IsForDebug=*/true, /*NoDetails=*/true);
      dbgs() << ") = GET_RC " << getDRS().MRI.getName(RegNo) << "\n";
    });

    Value *Reg = getDRS().getRegAsInt(RegNo);
    if (getResultTy(0)->getPrimitiveSizeInBits() <
        Reg->getType()->getPrimitiveSizeInBits())
      Reg = Builder.CreateTrunc(
          Reg, IntegerType::get(getContext(),
                                getResultTy(0)->getPrimitiveSizeInBits()));
    if (!getResultTy(0)->isIntegerTy())
      Reg = Builder.CreateBitCast(Reg, getResultTy(0));
    addResult(Reg);
    break;
  }
  case DCINS::GET_REG: {
    unsigned RegNo = Next();

    DEBUG({
      dbgs() << "  - <" << Vals.size() << ">(";
      ResTys[0]->print(dbgs(), /*IsForDebug=*/true, /*NoDetails=*/true);
      dbgs() << ") = GET_REG " << getDRS().MRI.getName(RegNo) << "\n";
    });

    Value *RegVal = getReg(RegNo);
    addResult(RegVal);
    break;
  }
  case DCINS::CUSTOM_OP: {
    unsigned OperandKind = Next(), MIOperandNo = Next();

    DEBUG({
      dbgs() << "  - <" << Vals.size() << ">(";
      ResTys[0]->print(dbgs(), /*IsForDebug=*/true, /*NoDetails=*/true);
      dbgs() << ") = CUSTOM_OP " << getDCCustomOpName(OperandKind) << " "
             << MIOperandNo << "\n";
    });

    Value *Op = translateCustomOperand(OperandKind, MIOperandNo);
    if (!Op)
      return false;
    addResult(Op);
    break;
  }
  case DCINS::COMPLEX_PATTERN: {
    unsigned PatternKind = Next();
    // Fill the operands array, taking care to remove our PatternKind operand.
    Ops.pop_back();
    prepareOperands();

    DEBUG(dumpOperation(
        ("COMPLEX_PATTERN " + getDCComplexPatternName(PatternKind)).str(),
        ResTys, Ops, SemaIdx - Ops.size() - ResTys.size() - 3));

    Value *Op = translateComplexPattern(PatternKind);
    if (!Op)
      return false;
    addResult(Op);
    break;
  }
  case DCINS::PREDICATE: {
    unsigned PredicateKind = Next();
    // Fill the operands array, taking care to remove our PredicateKind operand.
    Ops.pop_back();
    prepareOperands();

    DEBUG(dumpOperation(
        ("PREDICATE " + getDCPredicateName(PredicateKind)).str(),
        ResTys, Ops, SemaIdx - Ops.size() - ResTys.size() - 3));

    if (!translatePredicate(PredicateKind))
      return false;
    break;
  }
  case DCINS::GET_IMMEDIATE: {
    unsigned MIOperandNo = Next();
    Value *Cst = ConstantInt::get(cast<IntegerType>(getResultTy(0)),
                                  getImmOp(MIOperandNo));

    DEBUG({
      dbgs() << "  - <" << Vals.size() << ">(";
      ResTys[0]->print(dbgs(), /*IsForDebug=*/true, /*NoDetails=*/true);
      dbgs() << ") = GET_IMMEDIATE ";
      Cst->printAsOperand(dbgs(), /*PrintType=*/false, getModule());
    });

    addResult(Cst);
    break;
  }
  case DCINS::GET_CONSTANT: {
    uint64_t ValIdx = Next();

    DEBUG(dbgs() << "  - <" << Vals.size() << ">(";
          ResTys[0]->print(dbgs(), /*IsForDebug=*/true, /*NoDetails=*/true);
          dbgs() << ") = GET_CONSTANT " << ValIdx << "\n");

    const DataLayout &DL = getModule()->getDataLayout();
    Type *CTy = getResultTy(0);
    if (!CTy->isIntegerTy())
      CTy = Builder.getIntNTy(DL.getTypeSizeInBits(CTy));
    Constant *C = ConstantInt::get(CTy, ConstantArray[ValIdx]);
    C = ConstantExpr::getCast(CastInst::getCastOpcode(C, /*SrcIsSigned=*/false,
                                                      getResultTy(0),
                                                      /*DstIsSigned=*/false),
                              C, getResultTy(0));
    addResult(C);
    break;
  }
  case DCINS::IMPLICIT: {
    const unsigned RegNo = Next();

    DEBUG(dbgs() << "  - " << getDRS().MRI.getName(RegNo) << " = IMPLICIT\n");

    translateImplicit(RegNo);
    break;
  }
  default:
    llvm_unreachable("Unexpected non-DCINS opcode");
  }
  return true;
}

bool DCInstruction::translateOpcode(unsigned Opcode) {
  // We already ate the opcode; the next element in the semantics array is the
  // "signature", with:
  // - in the high 8 bits: the number of results
  // - in the low 8 bits: the number of Value operands.
  const uint16_t Signature = Next();
  const uint8_t NumResults = Signature >> 8;
  const uint8_t NumOperands = Signature & 0xFF;

  // Prepare our result type array.
  ResTys.clear();
  ResTys.resize(NumResults);

  // Prepare our operand array.
  Ops.clear();
  Ops.resize(NumOperands);

  // Next in the semantics array are the NumResults result types.
  for (unsigned ResI = 0; ResI != NumResults; ++ResI)
    ResTys[ResI] = NextTy();

  // We promised to generate NumResults results.  Make sure we didn't lie.
  const unsigned OldNumVals = Vals.size();
  auto DoAndCheckResults = [&](bool Success) {
    assert((!Success ||
        (Vals.size() == OldNumVals + NumResults)) &&
        "Operation didn't define as many results as declared in its signature");
    return Success;
  };

  // Next are the operands, which are always an index in the table of previously
  // produced results, except for the special DCINS builtin operations, which
  // have operation-specific behavior.  Deal with those first.
  if (Opcode >= DCINS::DC_OPCODE_START && Opcode <= DCINS::END_OF_INSTRUCTION)
    return DoAndCheckResults(translateDCOp(Opcode));

  // Finally, handle the regular (ISD) operations.  The remaining elements in
  // the semantics array entry is the index of each operand in the Vals table.
  prepareOperands();

  DEBUG(dumpOperation(getDCOpcodeName(Opcode), ResTys, Ops,
                      SemaIdx - NumOperands - NumResults - 2));

  // At this point, we prepared the types and operands.  We just need to do
  // the translation, starting with the target-specific nodes.
  if (Opcode >= ISD::BUILTIN_OP_END)
    return DoAndCheckResults(translateTargetOpcode(Opcode));

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
    Value *V = getOperand(0);
    addResult(Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::sqrt, V->getType()),
        {V}));
    break;
  }

  case ISD::ROTL: {
    Value *LHS = getOperand(0);
    Type *Ty = LHS->getType();
    assert(Ty->isIntegerTy());
    Value *RHS = Builder.CreateZExt(getOperand(1), Ty);
    // FIXME: RHS needs to be tweaked to avoid undefined results.
    Value *Shl = Builder.CreateShl(LHS, RHS);
    addResult(Builder.CreateOr(
        Shl,
        Builder.CreateLShr(
            LHS, Builder.CreateSub(
                     ConstantInt::get(Ty, Ty->getScalarSizeInBits()), RHS))));
    break;
  }

  case ISD::INSERT_VECTOR_ELT: {
    Value *Vec = getOperand(0);
    Value *Val = getOperand(1);
    Value *Idx = getOperand(2);
    addResult(Builder.CreateInsertElement(Vec, Val, Idx));
    break;
  }

  case ISD::EXTRACT_VECTOR_ELT: {
    Value *Val = getOperand(0);
    Value *Idx = getOperand(1);
    addResult(Builder.CreateExtractElement(Val, Idx));
    break;
  }

  case ISD::SMUL_LOHI: {
    IntegerType *LoResType = cast<IntegerType>(getResultTy(0));
    IntegerType *HiResType = cast<IntegerType>(getResultTy(1));
    IntegerType *ResType = IntegerType::get(
        getContext(), LoResType->getBitWidth() + HiResType->getBitWidth());
    Value *Op0 = Builder.CreateSExt(getOperand(0), ResType);
    Value *Op2 = Builder.CreateSExt(getOperand(1), ResType);
    Value *Full = Builder.CreateMul(Op0, Op2);
    addResult(Builder.CreateTrunc(Full, LoResType));
    addResult(Builder.CreateTrunc(
        Builder.CreateLShr(Full, LoResType->getBitWidth()), HiResType));
    break;
  }
  case ISD::UMUL_LOHI: {
    IntegerType *LoResType = cast<IntegerType>(getResultTy(0));
    IntegerType *HiResType = cast<IntegerType>(getResultTy(1));
    IntegerType *ResType = IntegerType::get(
        getContext(), LoResType->getBitWidth() + HiResType->getBitWidth());
    Value *Op0 = Builder.CreateZExt(getOperand(0), ResType);
    Value *Op2 = Builder.CreateZExt(getOperand(1), ResType);
    Value *Full = Builder.CreateMul(Op0, Op2);
    addResult(Builder.CreateTrunc(Full, LoResType));
    addResult(Builder.CreateTrunc(
        Builder.CreateLShr(Full, LoResType->getBitWidth()), HiResType));
    break;
  }
  case ISD::LOAD: {
    Type *ResPtrTy = getResultTy(0)->getPointerTo();
    Value *Ptr = getOperand(0);
    if (!Ptr->getType()->isPointerTy())
      Ptr = Builder.CreateIntToPtr(Ptr, ResPtrTy);
    else if (Ptr->getType() != ResPtrTy)
      Ptr = Builder.CreateBitCast(Ptr, ResPtrTy);
    addResult(Builder.CreateAlignedLoad(Ptr, 1));
    break;
  }
  case ISD::STORE: {
    Value *Val = getOperand(0);
    Value *Ptr = getOperand(1);
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
    Value *Op0 = getOperand(0);
    setReg(getDRS().MRI.getProgramCounter(), Op0);
    insertCall(Op0);
    Builder.CreateBr(getParentFunction().getExitBlock());
    break;
  }
  case ISD::BR: {
    Value *Op0 = getOperand(0);
    uint64_t Target = cast<ConstantInt>(Op0)->getValue().getZExtValue();
    setReg(getDRS().MRI.getProgramCounter(), Op0);
    Builder.CreateBr(getParentFunction().getOrCreateBasicBlock(Target));
    break;
  }
  case ISD::TRAP: {
    Builder.CreateCall(
        Intrinsic::getDeclaration(getModule(), Intrinsic::trap));
    break;
  }
  case ISD::BSWAP: {
    Value *Op = getOperand(0);
    Value *IntDecl = Intrinsic::getDeclaration(getModule(), Intrinsic::bswap,
                                               getResultTy(0));
    addResult(Builder.CreateCall(IntDecl, Op));
    break;
  }

  case ISD::ATOMIC_FENCE: {
    uint64_t OrdV = cast<ConstantInt>(getOperand(0))->getZExtValue();
    uint64_t ScopeV = cast<ConstantInt>(getOperand(1))->getZExtValue();

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
    return DoAndCheckResults(false);
  }
  return DoAndCheckResults(true);
}

Value *DCInstruction::translateComplexPattern(unsigned) {
  return nullptr;
}

bool DCInstruction::translateExtLoad(Type *MemTy, bool isSExt) {
  Value *Ptr = getOperand(0);
  Ptr = Builder.CreateBitOrPointerCast(Ptr, MemTy->getPointerTo());
  Value *V = Builder.CreateLoad(MemTy, Ptr);
  addResult(isSExt ? Builder.CreateSExt(V, getResultTy(0))
                   : Builder.CreateZExt(V, getResultTy(0)));
  return true;
}

bool DCInstruction::translatePredicate(unsigned PredicateKind) {
  switch (PredicateKind) {
  case TargetOpcode::Predicate::memop64:
  case TargetOpcode::Predicate::memop:
  case TargetOpcode::Predicate::loadi16:
  case TargetOpcode::Predicate::loadi32:
  case TargetOpcode::Predicate::alignedload:
  case TargetOpcode::Predicate::alignedload256:
  case TargetOpcode::Predicate::alignedload512:
  // FIXME: Take advantage of the implied alignment.
  case TargetOpcode::Predicate::load: {
    Type *ResPtrTy = getResultTy(0)->getPointerTo();
    Value *Ptr = getOperand(0);
    if (!Ptr->getType()->isPointerTy())
      Ptr = Builder.CreateIntToPtr(Ptr, ResPtrTy);
    else if (Ptr->getType() != ResPtrTy)
      Ptr = Builder.CreateBitCast(Ptr, ResPtrTy);
    addResult(Builder.CreateAlignedLoad(Ptr, 1));
    return true;
  }
  case TargetOpcode::Predicate::alignednontemporalstore:
  case TargetOpcode::Predicate::nontemporalstore:
  case TargetOpcode::Predicate::alignedstore:
  case TargetOpcode::Predicate::alignedstore256:
  case TargetOpcode::Predicate::alignedstore512:
  // FIXME: Take advantage of NT/alignment.
  case TargetOpcode::Predicate::store: {
    Value *Val = getOperand(0);
    Value *Ptr = getOperand(1);
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
