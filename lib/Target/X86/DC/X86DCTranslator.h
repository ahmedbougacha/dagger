//===-- X86DCTranslator.h - X86 Targeting of DCTranslator -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_X86_X86DCTRANSLATOR_H
#define LLVM_LIB_TARGET_X86_X86DCTRANSLATOR_H

#include "llvm/DC/DCTranslator.h"
#include "X86DCFunction.h"
#include "X86RegisterSema.h"

namespace llvm {

class X86DCTranslator final : public DCTranslator {
  X86RegisterSema DRS;
  X86DCFunction DCF;

public:
  X86DCTranslator(LLVMContext &Ctx, const DataLayout &DL, unsigned OptLevel,
                  const MCInstrInfo &MII, const MCRegisterInfo &MRI);

  virtual ~X86DCTranslator();

  X86DCFunction &getDCF() override { return DCF; }
};

} // end llvm namespace

#endif
