//===-- lib/DC/DCModule.cpp - Module Translation ----------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCModule.h"
#include "llvm/DC/DCTranslator.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/MC/MCRegisterInfo.h"
#include <dlfcn.h>

using namespace llvm;

DCModule::DCModule(DCTranslator &DCT, Module &M)
    : DCT(DCT), TheModule(M),
      FuncTy(*FunctionType::get(Type::getVoidTy(getContext()),
                                DCT.getRegSetDesc().RegSetType->getPointerTo(),
                                /*isVarArg=*/false)) {}

DCModule::~DCModule() {}

std::string DCModule::getFunctionName(uint64_t Addr) {
  return "fn_" + utohexstr(Addr);
}

Function *DCModule::getOrCreateFunction(uint64_t Addr) {
  return cast<Function>(
      getModule()->getOrInsertFunction(getFunctionName(Addr), getFuncTy()));
}

Function *DCModule::createExternalWrapperFunction(uint64_t Addr,
                                                  StringRef Name) {
  Function *ExtFn = cast<Function>(getModule()->getOrInsertFunction(
      Name,
      FunctionType::get(Type::getVoidTy(getContext()), /*isVarArg=*/false)));
  return createExternalWrapperFunction(Addr, ExtFn);
}

Function *DCModule::createExternalWrapperFunction(uint64_t Addr) {
  Value *ExtFn = ConstantExpr::getIntToPtr(
      ConstantInt::get(Type::getInt64Ty(getContext()), Addr),
      FunctionType::get(Type::getVoidTy(getContext()), /*isVarArg=*/false)
          ->getPointerTo());

  return createExternalWrapperFunction(Addr, ExtFn);
}

Function *DCModule::createExternalWrapperFunction(uint64_t Addr, Value *ExtFn) {
  Function *Fn = getOrCreateFunction(Addr);
  if (!Fn->isDeclaration())
    return Fn;

  BasicBlock *BB = BasicBlock::Create(getContext(), "", Fn);
  Value *RegSet = &*Fn->getArgumentList().begin();
  insertExternalWrapperAsm(BB, ExtFn, RegSet);
  ReturnInst::Create(getContext(), BB);
  return Fn;
}

Function *DCModule::getOrCreateMainFunction(Function *EntryFn) {
  IRBuilder<> Builder(getContext());

  Type *MainArgs[] = {Builder.getInt32Ty(),
                      Builder.getInt8PtrTy()->getPointerTo()};
  Function *MainFn = cast<Function>(getModule()->getOrInsertFunction(
      "main",
      FunctionType::get(Builder.getInt32Ty(), MainArgs, /*isVarArg=*/false)));

  if (!MainFn->empty())
    return MainFn;

  auto *BB = BasicBlock::Create(getContext(), "", MainFn);
  Builder.SetInsertPoint(BB);

  AllocaInst *Regset = Builder.CreateAlloca(DCT.getRegSetDesc().RegSetType);

  // Allocate a local array to serve as a stack.
  const unsigned kStackSize = 1 << 10;
  AllocaInst *Stack =
      Builder.CreateAlloca(ArrayType::get(Builder.getInt8Ty(), kStackSize));

  // 64byte alignment ought to be enough for anybody.
  // FIXME: this should be the maximum natural alignment of the register types.
  Regset->setAlignment(64);
  Stack->setAlignment(64);

  Value *StackSize = Builder.getInt32(kStackSize);
  Value *Idx[2] = {Builder.getInt32(0), Builder.getInt32(0)};
  Value *StackPtr = Builder.CreateInBoundsGEP(Stack, Idx);

  Function::arg_iterator ArgI = MainFn->getArgumentList().begin();
  Value *ArgC = &*ArgI++;
  Value *ArgV = &*ArgI++;

  Function *InitFn = getOrCreateInitRegSetFunction();
  Function *FiniFn = getOrCreateFiniRegSetFunction();

  Builder.CreateCall(InitFn, {Regset, StackPtr, StackSize, ArgC, ArgV});
  Builder.CreateCall(EntryFn, {Regset});
  Builder.CreateRet(Builder.CreateCall(FiniFn, {Regset}));
  return MainFn;
}

Function *DCModule::getOrCreateInitRegSetFunction() {
  StructType *RegSetType = DCT.getRegSetDesc().RegSetType;
  auto *PI8Ty = Type::getInt8PtrTy(getContext());
  auto *I32Ty = Type::getInt32Ty(getContext());

  Type *InitArgs[] = {RegSetType->getPointerTo(), PI8Ty, I32Ty, I32Ty,
                      PI8Ty->getPointerTo()};
  Function *InitFn = cast<Function>(getModule()->getOrInsertFunction(
      "main_init_regset", FunctionType::get(Type::getVoidTy(getContext()),
                                            InitArgs, /*isVarArg=*/false)));

  if (!InitFn->empty())
    return InitFn;

  Function::arg_iterator ArgI = InitFn->getArgumentList().begin();
  Value *RegSet = &*ArgI++;
  Value *StackPtr = &*ArgI++;
  Value *StackSize = &*ArgI++;
  Value *ArgC = &*ArgI++;
  Value *ArgV = &*ArgI++;

  auto *BB = BasicBlock::Create(getContext(), "", InitFn);
  insertCodeForInitRegSet(BB, RegSet, StackPtr, StackSize, ArgC, ArgV);
  ReturnInst::Create(getContext(), BB);

  return InitFn;
}

Function *DCModule::getOrCreateFiniRegSetFunction() {
  StructType *RegSetType = DCT.getRegSetDesc().RegSetType;
  auto *I32Ty = Type::getInt32Ty(getContext());

  Type *FiniArgs[] = {RegSetType->getPointerTo()};
  Function *FiniFn = cast<Function>(getModule()->getOrInsertFunction(
      "main_fini_regset",
      FunctionType::get(I32Ty, FiniArgs, /*isVarArg=*/false)));

  if (!FiniFn->empty())
    return FiniFn;

  Function::arg_iterator ArgI = FiniFn->getArgumentList().begin();
  Value *RegSet = &*ArgI++;

  auto *BB = BasicBlock::Create(getContext(), "", FiniFn);
  ReturnInst::Create(getContext(), insertCodeForFiniRegSet(BB, RegSet), BB);

  return FiniFn;
}


extern "C" void __llvm_dc_print_reg_diff_fn(void *FPtr) {
  printf("Different Registers for '");
  Dl_info DLI;
  if (dladdr(FPtr, &DLI))
    printf("%s", DLI.dli_sname);
  else
    printf("fn_%p", FPtr);
  printf("':\n");
}

extern "C" void __llvm_dc_print_reg_diff(char *Name, uint8_t *v1, uint8_t *v2,
                                         uint32_t Size) {
  bool Diff = false;

  for (uint32_t i = 0; i < Size; ++i)
    Diff |= (v1[i] != v2[i]);

  if (!Diff)
    return;

  printf("%s = ", Name);
  for (uint32_t i = 0; i < Size; ++i)
    printf("%.2x", v2[Size - i - 1]);
  printf("\n");
}

/// Get a constant expression expressing \p FPtr as a \p FTy value.
template <typename T>
Value *getCallTargetForExtFn(FunctionType *FTy, T FPtr) {
  // FIXME: bitness
  ConstantInt *FnPtrInt = ConstantInt::get(Type::getInt64Ty(FTy->getContext()),
                                           reinterpret_cast<uint64_t>(FPtr));
  return ConstantExpr::getBitCast(
    ConstantExpr::getIntToPtr(FnPtrInt, Type::getInt8PtrTy(FTy->getContext())),
    FTy->getPointerTo());
}


Function *DCModule::getOrCreateRegSetDiffFunction() {
  auto &MRI = getTranslator().getMRI();
  auto &RSD = getTranslator().getRegSetDesc();
  IRBuilder<> Builder(getContext());

  Type *I8PtrTy = Builder.getInt8PtrTy();
  Type *RegSetPtrTy = RSD.RegSetType->getPointerTo();

  Type *RSDiffArgTys[] = {I8PtrTy, RegSetPtrTy, RegSetPtrTy};
  Function *RSDiffFn = cast<Function>(TheModule.getOrInsertFunction(
      "__llvm_dc_print_regset_diff",
      FunctionType::get(Builder.getVoidTy(), RSDiffArgTys,
                        /*isVarArg=*/false)));

  // If we already defined the function, return it.
  if (!RSDiffFn->isDeclaration())
    return RSDiffFn;

  Builder.SetInsertPoint(BasicBlock::Create(getContext(), "", RSDiffFn));

  // Get the argument regset pointers.
  Function::arg_iterator ArgI = RSDiffFn->getArgumentList().begin();
  Value *FnAddr = &*ArgI++;
  Value *RS1 = &*ArgI++;
  Value *RS2 = &*ArgI++;

  // We use a C++ helper function to print the header with the function info:
  //   __llvm_dc_print_reg_diff_fn (defined above).
  Type *PrintFnArgTys[] = {I8PtrTy};
  FunctionType *PrintFnType = FunctionType::get(
      Builder.getVoidTy(), PrintFnArgTys, /*isVarArg=*/false);

  Builder.CreateCall(
      getCallTargetForExtFn(PrintFnType, &__llvm_dc_print_reg_diff_fn), FnAddr);

  // We use a C++ helper function to diff and print each individual register:
  //   __llvm_dc_print_reg_diff (defined above).
  Type *RegDiffArgTys[] = {I8PtrTy, I8PtrTy, I8PtrTy, Builder.getInt32Ty()};
  FunctionType *RegDiffFnType = FunctionType::get(
      Builder.getVoidTy(), RegDiffArgTys, /*isVarArg=*/false);

  Value *RegDiffFnPtr =
      getCallTargetForExtFn(RegDiffFnType, &__llvm_dc_print_reg_diff);

  for (auto Reg : RSD.LargestRegs) {
    if (Reg == 0)
      continue;
    int OffsetInRegSet = RSD.RegOffsetsInSet[Reg];
    assert(OffsetInRegSet != -1 && "Getting a register not in the regset!");
    Value *Idx[] = {Builder.getInt32(0), Builder.getInt32(OffsetInRegSet)};
    Value *Reg1Ptr =
        Builder.CreateBitCast(Builder.CreateInBoundsGEP(RS1, Idx), I8PtrTy);
    Value *Reg2Ptr =
        Builder.CreateBitCast(Builder.CreateInBoundsGEP(RS2, Idx), I8PtrTy);

    Value *RegName = Builder.CreateBitCast(
        Builder.CreateGlobalString(MRI.getName(Reg)), I8PtrTy);

    Builder.CreateCall(RegDiffFnPtr,
                        {RegName, Reg1Ptr, Reg2Ptr,
                         Builder.getInt32(RSD.RegSizes[Reg] / 8)});
  }

  Builder.CreateRetVoid();

  return RSDiffFn;
}
