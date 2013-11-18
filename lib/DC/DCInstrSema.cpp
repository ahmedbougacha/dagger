#include "llvm/DC/DCInstrSema.h"
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
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

DCInstrSema::DCInstrSema(const unsigned *OpcodeToSemaIdx,
                         const unsigned *SemanticsArray,
                         const uint64_t *ConstantArray,
                         DCRegisterSema &DRS)
    : OpcodeToSemaIdx(OpcodeToSemaIdx), SemanticsArray(SemanticsArray),
      ConstantArray(ConstantArray), Ctx(0), TheModule(0), DRS(DRS), FuncType(0),
      TheFunction(0), BBByAddr(), ExitBB(0), CallBBs(), TheBB(0),
      BBStartAddr(0), BBEndAddr(0), Builder(), Idx(0), ResEVT(), Opcode(0),
      Vals(), CurrentInst(0) {}

DCInstrSema::~DCInstrSema() {}

Function *DCInstrSema::FinalizeFunction() {
  for (std::vector<BasicBlock *>::iterator CBBI = CallBBs.begin(),
                                           CBBE = CallBBs.end();
       CBBI != CBBE; ++CBBI) {
    BasicBlock *CBB = *CBBI;
    assert(CBB->size() == 2 &&
           "Call basic block has wrong number of instructions!");
    BasicBlock::iterator CallI = CBB->begin();
    DRS.saveAllLocalRegs(CBB, CallI);
    DRS.restoreLocalRegs(CBB, ++CallI);
  }
  DRS.FinalizeFunction(ExitBB);
  CallBBs.clear();
  BBByAddr.clear();
  Function *Fn = TheFunction;
  TheFunction = 0;
  return Fn;
}

void DCInstrSema::FinalizeBasicBlock() {
  if (!TheBB->getTerminator())
    BranchInst::Create(getOrCreateBasicBlock(BBEndAddr + 1), TheBB);
  DRS.FinalizeBasicBlock();
  TheBB = 0;
}

void DCInstrSema::FinalizeModule() {}

Function *DCInstrSema::createMainFunction(Function *EntryFn) {
  Type *MainArgs[] = { Builder->getInt32Ty(),
                       Builder->getInt8PtrTy()->getPointerTo() };
  Function *IRMain = cast<Function>(
      TheModule->getOrInsertFunction(
          "main", FunctionType::get(Builder->getInt32Ty(), MainArgs, false)));

  Builder->SetInsertPoint(BasicBlock::Create(*Ctx, "", IRMain));

  Value *Regset = Builder->CreateAlloca(DRS.getRegSetType());

  // allocate a small local array to serve as a test stack.
  Value *StackPtr =
      Builder->CreateAlloca(ArrayType::get(Builder->getInt8Ty(), 8192));
  Value *StackSize = Builder->getInt32(8192);
  Value *Idx[2] = { Builder->getInt32(0), Builder->getInt32(0) };
  StackPtr = Builder->CreateInBoundsGEP(StackPtr, Idx);

  Function::arg_iterator ArgI = IRMain->getArgumentList().begin();
  Value *ArgC = ArgI++;
  Value *ArgV = ArgI++;

  Builder->CreateCall5(InitFn, Regset, StackPtr, StackSize, ArgC, ArgV);
  Builder->CreateCall(EntryFn, Regset);
  Builder->CreateRet(Builder->CreateCall(FiniFn, Regset));
  return IRMain;
}

void DCInstrSema::createExternalWrapperFunction(uint64_t Addr, StringRef Name) {
  Function *ExtFn =
      cast<Function>(TheModule->getOrInsertFunction(
                         Name, FunctionType::get(Builder->getVoidTy(), false)));

  Function *Fn = getFunction(Addr);
  if (!Fn->isDeclaration())
    return;

  BasicBlock *BB = BasicBlock::Create(*Ctx, "", Fn);
  DRS.insertExternalWrapperAsm(BB, ExtFn);
  ReturnInst::Create(*Ctx, BB);
}

void DCInstrSema::createExternalTailCallBB(uint64_t Addr) {
  SwitchToBasicBlock(Addr, 0);
  insertCallBB(getFunction(Addr));
  Builder->CreateRetVoid();
}

void DCInstrSema::SwitchToModule(Module *M) {
  TheModule = M;
  Ctx = &TheModule->getContext();
  DRS.SwitchToModule(TheModule);
  FuncType = FunctionType::get(Type::getVoidTy(*Ctx),
                               DRS.getRegSetType()->getPointerTo(), false);
  Builder.reset(new IRBuilder(*Ctx));

  // Create the init/fini functions.
  StructType *RegSetType = DRS.getRegSetType();

  Type *InitArgs[] = { RegSetType->getPointerTo(),
                       Builder->getInt8PtrTy(),
                       Builder->getInt32Ty(),
                       Builder->getInt32Ty(),
                       Builder->getInt8PtrTy()->getPointerTo() };
  InitFn = cast<Function>(
      TheModule->getOrInsertFunction(
          "main_init_regset",
          FunctionType::get(Builder->getVoidTy(), InitArgs, false)));

  Type *FiniArgs[] = { RegSetType->getPointerTo() };
  FiniFn = cast<Function>(
      TheModule->getOrInsertFunction(
          "main_fini_regset",
          FunctionType::get(Builder->getInt32Ty(), FiniArgs, false)));

  DRS.insertInitFiniRegsetCode(InitFn, FiniFn);
}

void DCInstrSema::SwitchToFunction(uint64_t Addr) {
  TheFunction = getFunction(Addr);
  TheFunction->setDoesNotAlias(1);
  TheFunction->setDoesNotCapture(1);

  // Create the entry and exit basic blocks.
  TheBB = BasicBlock::Create(*Ctx, "entry_fn_" + utohexstr(Addr), TheFunction);
  ExitBB = BasicBlock::Create(*Ctx, "exit_fn_" + utohexstr(Addr), TheFunction);

  // From now on we insert in the entry basic block.
  Builder->SetInsertPoint(TheBB);
  // Create a br from the entry basic block to the first basic block, at Addr.
  Builder->CreateBr(getOrCreateBasicBlock(Addr));
  // Create a ret void in the exit basic block.
  ReturnInst::Create(*Ctx, ExitBB);

  DRS.SwitchToFunction(TheFunction);
}

void DCInstrSema::removeTrapInstFromEmptyBB(BasicBlock *BB) {
  assert((BB->size() == 2 && isa<UnreachableInst>(++BB->begin())) &&
         "Several BBs at the same address?");
  BB->begin()->eraseFromParent();
  BB->begin()->eraseFromParent();
}

void DCInstrSema::SwitchToBasicBlock(uint64_t StartAddr, uint64_t EndAddr) {
  TheBB = getOrCreateBasicBlock(StartAddr);
  removeTrapInstFromEmptyBB(TheBB);

  Builder->SetInsertPoint(TheBB);
  BBStartAddr = StartAddr;
  BBEndAddr = EndAddr;

  DRS.SwitchToBasicBlock(TheBB);

  // The PC at the start of the basic block is known, just set it.
  unsigned PC = DRS.MRI.getProgramCounter();
  setReg(PC, ConstantInt::get(DRS.getRegType(PC), StartAddr));
}

Function *DCInstrSema::getFunction(uint64_t Addr) {
  std::string Name = "fn_" + utohexstr(Addr);
  TheModule->getOrInsertFunction(Name, FuncType);
  return TheModule->getFunction(Name);
}

BasicBlock *DCInstrSema::getOrCreateBasicBlock(uint64_t Addr) {
  BasicBlock *&BB = BBByAddr[Addr];
  if (!BB) {
    BB = BasicBlock::Create(*Ctx, "bb_" + utohexstr(Addr), TheFunction);
    IRBuilder(BB)
        .CreateCall(Intrinsic::getDeclaration(TheModule, Intrinsic::trap));
    IRBuilder(BB).CreateUnreachable();
  }
  return BB;
}

BasicBlock *DCInstrSema::insertCallBB(Value *Target) {
  BasicBlock *CallBB =
      BasicBlock::Create(*Ctx, TheBB->getName() + "_call", TheFunction);
  Value *RegSetArg = &TheFunction->getArgumentList().front();
  IRBuilder CallBuilder(CallBB);
  CallBuilder.CreateCall(Target, RegSetArg);
  Builder->CreateBr(CallBB);
  assert(Builder->GetInsertPoint() == TheBB->end() &&
         "Call basic blocks can't be inserted at the middle of a basic block!");
  StringRef BBName = TheBB->getName();
  BBName = BBName.substr(0, BBName.find_first_of("_c"));
  TheBB = BasicBlock::Create(
      *Ctx, BBName + "_c" + utohexstr(CurrentInst->Address), TheFunction);
  DRS.FinalizeBasicBlock();
  DRS.SwitchToBasicBlock(TheBB);
  Builder->SetInsertPoint(TheBB);
  CallBuilder.CreateBr(TheBB);
  CallBBs.push_back(CallBB);
  // FIXME: Insert return address checking, to unwind back to the translator if
  // the call returned to an unexpected address.
  return CallBB;
}

Value *DCInstrSema::insertTranslateAt(Value *OrigTarget) {
  FunctionType *CallbackType = FunctionType::get(
      FuncType->getPointerTo(), Builder->getInt8PtrTy(), false);
  Constant *Fn =
      TheModule->getOrInsertFunction("__llvm_dc_translate_at", CallbackType);
  return Builder->CreateCall(
             Fn, Builder->CreateIntToPtr(OrigTarget, Builder->getInt8PtrTy()));
}

void DCInstrSema::insertCall(Value *CallTarget) {
  if (ConstantInt *CI = dyn_cast<ConstantInt>(CallTarget)) {
    uint64_t Target = CI->getValue().getZExtValue();
    CallTarget = getFunction(Target);
  } else {
    CallTarget = insertTranslateAt(CallTarget);
  }
  insertCallBB(CallTarget);
}

void DCInstrSema::translateBinOp(Instruction::BinaryOps Opc) {
  Value *V1 = Vals[Next()];
  Value *V2 = Vals[Next()];
  if (Instruction::isShift(Opc) && V2->getType() != V1->getType())
    V2 = Builder->CreateZExt(V2, V1->getType());
  Vals.push_back(Builder->CreateBinOp(Opc, V1, V2));
}

void DCInstrSema::translateCastOp(Instruction::CastOps Opc) {
  Type *ResType = ResEVT.getTypeForEVT(*Ctx);
  Value *Val = Vals[Next()];
  Vals.push_back(Builder->CreateCast(Opc, Val, ResType));
}

bool
DCInstrSema::translateInst(const MCDecodedInst &DecodedInst) {
  CurrentInst = &DecodedInst;
  DRS.SwitchToInst(DecodedInst);

  Idx = OpcodeToSemaIdx[CurrentInst->Inst.getOpcode()];
  if (translateTargetInst())
    return true;
  if (Idx == 0)
    return false;

  {
    // Increment the PC before anything.
    Value *OldPC = getReg(DRS.MRI.getProgramCounter());
    setReg(DRS.MRI.getProgramCounter(),
           Builder->CreateAdd(
               OldPC, ConstantInt::get(OldPC->getType(), CurrentInst->Size)));
  }

  while ((Opcode = Next()) != DCINS::END_OF_INSTRUCTION) {
    ResEVT = NextVT();
    if (Opcode >= ISD::BUILTIN_OP_END && Opcode < DCINS::DC_OPCODE_START) {
      translateTargetOpcode();
      continue;
    }
    switch(Opcode) {
    case ISD::ADD  : translateBinOp(Instruction::Add ); break;
    case ISD::FADD : translateBinOp(Instruction::FAdd); break;
    case ISD::SUB  : translateBinOp(Instruction::Sub ); break;
    case ISD::FSUB : translateBinOp(Instruction::FSub); break;
    case ISD::MUL  : translateBinOp(Instruction::Mul ); break;
    case ISD::FMUL : translateBinOp(Instruction::FMul); break;
    case ISD::UDIV : translateBinOp(Instruction::UDiv); break;
    case ISD::SDIV : translateBinOp(Instruction::SDiv); break;
    case ISD::FDIV : translateBinOp(Instruction::FDiv); break;
    case ISD::UREM : translateBinOp(Instruction::URem); break;
    case ISD::SREM : translateBinOp(Instruction::SRem); break;
    case ISD::FREM : translateBinOp(Instruction::FRem); break;
    case ISD::SHL  : translateBinOp(Instruction::Shl ); break;
    case ISD::SRL  : translateBinOp(Instruction::LShr); break;
    case ISD::SRA  : translateBinOp(Instruction::AShr); break;
    case ISD::AND  : translateBinOp(Instruction::And ); break;
    case ISD::OR   : translateBinOp(Instruction::Or  ); break;
    case ISD::XOR  : translateBinOp(Instruction::Xor ); break;

    case ISD::TRUNCATE    : translateCastOp(Instruction::Trunc   ); break;
    case ISD::BITCAST     : translateCastOp(Instruction::BitCast ); break;
    case ISD::ZERO_EXTEND : translateCastOp(Instruction::ZExt    ); break;
    case ISD::SIGN_EXTEND : translateCastOp(Instruction::SExt    ); break;
    case ISD::FP_TO_UINT  : translateCastOp(Instruction::FPToUI  ); break;
    case ISD::FP_TO_SINT  : translateCastOp(Instruction::FPToSI  ); break;
    case ISD::UINT_TO_FP  : translateCastOp(Instruction::UIToFP  ); break;
    case ISD::SINT_TO_FP  : translateCastOp(Instruction::SIToFP  ); break;
    case ISD::FP_ROUND    : translateCastOp(Instruction::FPTrunc ); break;
    case ISD::FP_EXTEND   : translateCastOp(Instruction::FPExt   ); break;

    case ISD::FSQRT: {
      unsigned Op1 = Next();
      Value *V = Vals[Op1];
      Vals.push_back(
          Builder->CreateCall(Intrinsic::getDeclaration(
                                  TheModule, Intrinsic::sqrt, V->getType()),
                              V));
      break;
    }

    case ISD::SCALAR_TO_VECTOR: {
      Type *ResType = ResEVT.getTypeForEVT(*Ctx);
      unsigned Op1 = Next();

      Type *ResEltType = ResType->getVectorElementType();
      Value *NullVect = Constant::getNullValue(ResType);
      Value *Val = Vals[Op1];
      if (Val->getType()->isFloatingPointTy())
        Val = Builder->CreateFPCast(Val, ResEltType);
      else
        Val = Builder->CreateZExtOrBitCast(Val, ResEltType);
      Vals.push_back(
          Builder->CreateInsertElement(NullVect, Val, Builder->getInt32(0)));
      break;
    }

    case ISD::SMUL_LOHI: {
      EVT Re2EVT = NextVT();
      IntegerType *LoResType = cast<IntegerType>(ResEVT.getTypeForEVT(*Ctx));
      IntegerType *HiResType = cast<IntegerType>(Re2EVT.getTypeForEVT(*Ctx));
      IntegerType *ResType = IntegerType::get(
          *Ctx, LoResType->getBitWidth() + HiResType->getBitWidth());
      unsigned Op1 = Next(), Op2 = Next();
      Value *Full = Builder->CreateMul(Builder->CreateSExt(Vals[Op1], ResType),
                                       Builder->CreateSExt(Vals[Op2], ResType));
      Vals.push_back(Builder->CreateTrunc(Full, LoResType));
      Vals.push_back(
          Builder->CreateTrunc(
              Builder->CreateLShr(Full, LoResType->getBitWidth()), HiResType));
      break;
    }
    case ISD::UMUL_LOHI: {
      EVT Re2EVT = NextVT();
      IntegerType *LoResType = cast<IntegerType>(ResEVT.getTypeForEVT(*Ctx));
      IntegerType *HiResType = cast<IntegerType>(Re2EVT.getTypeForEVT(*Ctx));
      IntegerType *ResType = IntegerType::get(
          *Ctx, LoResType->getBitWidth() + HiResType->getBitWidth());
      unsigned Op1 = Next(), Op2 = Next();
      Value *Full = Builder->CreateMul(Builder->CreateZExt(Vals[Op1], ResType),
                                       Builder->CreateZExt(Vals[Op2], ResType));
      Vals.push_back(Builder->CreateTrunc(Full, LoResType));
      Vals.push_back(
          Builder->CreateTrunc(
              Builder->CreateLShr(Full, LoResType->getBitWidth()), HiResType));
      break;
    }
    case ISD::LOAD: {
      Type *ResType = ResEVT.getTypeForEVT(*Ctx);
      Value *Ptr = Vals[Next()];
      if (!Ptr->getType()->isPointerTy())
        Ptr = Builder->CreateIntToPtr(Ptr, ResType->getPointerTo());
      assert(Ptr->getType()->getPointerElementType() == ResType &&
             "Mismatch between a LOAD's address operand and return type!");
      Vals.push_back(Builder->CreateLoad(Ptr));
      break;
    }
    case ISD::STORE: {
      Value *Val = Vals[Next()];
      Value *Ptr = Vals[Next()];
      Type *ValPtrTy = Val->getType()->getPointerTo();
      Type *PtrTy = Ptr->getType();
      if (!PtrTy->isPointerTy())
        Ptr = Builder->CreateIntToPtr(Ptr, ValPtrTy);
      else if (PtrTy != ValPtrTy)
        Ptr = Builder->CreateBitCast(Ptr, ValPtrTy);
      Builder->CreateStore(Val, Ptr);
      break;
    }
    case ISD::BRIND: {
      unsigned Op1 = Next();
      setReg(DRS.MRI.getProgramCounter(), Vals[Op1]);
      insertCall(Vals[Op1]);
      Builder->CreateBr(ExitBB);
      break;
    }
    case ISD::BR: {
      unsigned Op1 = Next();
      uint64_t Target = cast<ConstantInt>(Vals[Op1])->getValue().getZExtValue();
      setReg(DRS.MRI.getProgramCounter(), Vals[Op1]);
      Builder->CreateBr(getOrCreateBasicBlock(Target));
      break;
    }
    case DCINS::PUT_RC: {
      unsigned MIOperandNo = Next(), Op1 = Next();
      unsigned RegNo = getRegOp(MIOperandNo);
      Value *Res = Vals[Op1];
      Type *RegType = DRS.getRegType(RegNo);
      if (Res->getType()->isPointerTy())
        Res = Builder->CreatePtrToInt(Res, RegType);
      if (!Res->getType()->isIntegerTy())
        Res = Builder->CreateBitCast(
            Res,
            IntegerType::get(*Ctx, Res->getType()->getPrimitiveSizeInBits()));
      if (Res->getType()->getPrimitiveSizeInBits() <
          RegType->getPrimitiveSizeInBits())
        Res = DRS.insertBitsInValue(getReg(RegNo), Res);
      assert(Res->getType() == RegType);
      setReg(RegNo, Res);
      break;
    }
    case DCINS::PUT_REG: {
      unsigned RegNo = Next(), Res = Next();
      setReg(RegNo, Vals[Res]);
      break;
    }
    case DCINS::GET_RC: {
      unsigned MIOperandNo = Next();
      Type *ResType = ResEVT.getTypeForEVT(*Ctx);
      Value *Reg = getReg(getRegOp(MIOperandNo));
      if (ResType->getPrimitiveSizeInBits() <
          Reg->getType()->getPrimitiveSizeInBits())
        Reg = Builder->CreateTrunc(
            Reg, IntegerType::get(*Ctx, ResType->getPrimitiveSizeInBits()));
      if (!ResType->isIntegerTy())
        Reg = Builder->CreateBitCast(Reg, ResType);
      Vals.push_back(Reg);
      break;
    }
    case DCINS::GET_REG: {
      unsigned RegNo = Next();
      Vals.push_back(getReg(RegNo));
      break;
    }
    case DCINS::CUSTOM_OP: {
      unsigned OperandType = Next(), MIOperandNo = Next();
      translateOperand(OperandType, MIOperandNo);
      break;
    }
    case DCINS::CONSTANT_OP: {
      unsigned MIOperandNo = Next();
      Type *ResType = ResEVT.getTypeForEVT(*Ctx);
      Vals.push_back(
          ConstantInt::get(cast<IntegerType>(ResType), getImmOp(MIOperandNo)));
      break;
    }
    case DCINS::MOV_CONSTANT: {
      uint64_t ValIdx = Next();
      Type *ResType = ResEVT.getTypeForEVT(*Ctx);
      Vals.push_back(ConstantInt::get(ResType, ConstantArray[ValIdx]));
      break;
    }
    case DCINS::IMPLICIT: {
      translateImplicit(Next());
      break;
    }
    default:
      llvm_unreachable(
          ("Unknown opcode found in semantics: " + utostr(Opcode)).c_str());
    }
  }
  Vals.clear();
  return true;
}

void DCInstrSema::translateOperand(unsigned OperandType, unsigned MIOperandNo) {
  // FIXME: We don't have target-independent operand types yet.
  translateCustomOperand(OperandType, MIOperandNo);
}
