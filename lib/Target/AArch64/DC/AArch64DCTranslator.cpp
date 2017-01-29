//===-- AArch64DCTranslator.cpp - AArch64  DCTranslator ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AArch64DCTranslator.h"
#include "AArch64DCBasicBlock.h"
#include "AArch64DCFunction.h"
#include "AArch64DCInstruction.h"
#include "AArch64DCModule.h"

#define GET_REGISTER_SEMA
#include "AArch64GenSema.inc"

using namespace llvm;

static DCRegisterSetDesc buildAArch64RegSetDesc(LLVMContext &Ctx,
                                                const MCRegisterInfo &MRI) {
  DCRegisterSetDesc RegSetDesc(Ctx, MRI, AArch64::RegClassVTs);

  RegSetDesc.RegConstantVals[AArch64::XZR] =
      Constant::getNullValue(IntegerType::get(Ctx, 64));
  RegSetDesc.RegConstantVals[AArch64::WZR] =
      Constant::getNullValue(IntegerType::get(Ctx, 32));
  return RegSetDesc;
}

AArch64DCTranslator::AArch64DCTranslator(LLVMContext &Ctx, const DataLayout &DL,
                                         unsigned OptLevel,
                                         const MCInstrInfo &MII,
                                         const MCRegisterInfo &MRI)
    : DCTranslator(Ctx, DL, OptLevel, MII, MRI,
                   buildAArch64RegSetDesc(Ctx, MRI)),
      DRS(Ctx, MRI, MII, DL, getRegSetDesc()) {
  initializeTranslationModule();
}

AArch64DCTranslator::~AArch64DCTranslator() {}

std::unique_ptr<DCFunction>
AArch64DCTranslator::createDCFunction(DCModule &DCM, const MCFunction &MCF) {
  return make_unique<AArch64DCFunction>(DCM, MCF);
}

std::unique_ptr<DCModule> AArch64DCTranslator::createDCModule(Module &M) {
  return make_unique<AArch64DCModule>(*this, M);
}

std::unique_ptr<DCBasicBlock>
AArch64DCTranslator::createDCBasicBlock(DCFunction &DCF,
                                        const MCBasicBlock &MCB) {
  return make_unique<AArch64DCBasicBlock>(DCF, MCB);
}

std::unique_ptr<DCInstruction>
AArch64DCTranslator::createDCInstruction(DCBasicBlock &DCB,
                                         const MCDecodedInst &MCI) {
  return make_unique<AArch64DCInstruction>(DCB, MCI);
}
