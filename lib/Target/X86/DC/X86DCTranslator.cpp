//===-- X86DCTranslator.cpp - X86 Targeting of DCTranslator -----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "X86DCTranslator.h"

#define GET_REGISTER_SEMA
#include "X86GenSema.inc"

using namespace llvm;

X86DCTranslator::X86DCTranslator(LLVMContext &Ctx, const DataLayout &DL,
                                 unsigned OptLevel, const MCInstrInfo &MII,
                                 const MCRegisterInfo &MRI)
    : DCTranslator(Ctx, DL, OptLevel,
                   DCRegisterSetDesc(Ctx, MRI, X86::RegClassVTs)),
      DRS(Ctx, MRI, MII, DL, getRegSetDesc()), DCF(DRS) {
  initializeTranslationModule();
}

X86DCTranslator::~X86DCTranslator() {}
