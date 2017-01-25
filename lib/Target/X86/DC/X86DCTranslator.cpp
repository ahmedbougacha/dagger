//===-- X86DCTranslator.cpp - X86 Targeting of DCTranslator -----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "X86DCTranslator.h"
#include "X86DCBasicBlock.h"
#include "X86DCFunction.h"
#include "X86DCInstruction.h"
#include "X86DCModule.h"

#define GET_REGISTER_SEMA
#include "X86GenSema.inc"

using namespace llvm;

X86DCTranslator::X86DCTranslator(LLVMContext &Ctx, const DataLayout &DL,
                                 unsigned OptLevel, const MCInstrInfo &MII,
                                 const MCRegisterInfo &MRI)
    : DCTranslator(Ctx, DL, OptLevel,
                   DCRegisterSetDesc(Ctx, MRI, X86::RegClassVTs)),
      DRS(Ctx, MRI, MII, DL, getRegSetDesc()) {
  initializeTranslationModule();
}

X86DCTranslator::~X86DCTranslator() {}

std::unique_ptr<DCModule> X86DCTranslator::createDCModule(Module &M) {
  return make_unique<X86DCModule>(*this, M);
}

std::unique_ptr<DCFunction>
X86DCTranslator::createDCFunction(DCModule &DCM, const MCFunction &MCF) {
  return make_unique<X86DCFunction>(DCM, MCF);
}

std::unique_ptr<DCBasicBlock>
X86DCTranslator::createDCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB) {
  return make_unique<X86DCBasicBlock>(DCF, MCB);
}

std::unique_ptr<DCInstruction>
X86DCTranslator::createDCInstruction(DCBasicBlock &DCB,
                                     const MCDecodedInst &MCI) {
  return make_unique<X86DCInstruction>(DCB, MCI);
}
