//===-- lib/DC/DCModule.cpp - Module Translation ----------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCModule.h"
#include "llvm/DC/DCRegisterSema.h"
#include "llvm/DC/DCTranslator.h"
#include "llvm/IR/Constants.h"

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
  DCT.getDRS().insertExternalWrapperAsm(BB, ExtFn);
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
