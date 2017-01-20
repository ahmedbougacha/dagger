//===-- AArch64DCTranslator.h - AArch64  DCTranslator -----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_AARCH64DCTRANSLATOR_H
#define LLVM_LIB_TARGET_AARCH64_AARCH64DCTRANSLATOR_H

#include "llvm/DC/DCTranslator.h"
#include "AArch64DCFunction.h"
#include "AArch64RegisterSema.h"

namespace llvm {

class AArch64DCTranslator final : public DCTranslator {
  AArch64RegisterSema DRS;
  AArch64DCFunction DCF;

public:
  AArch64DCTranslator(LLVMContext &Ctx, const DataLayout &DL, unsigned OptLevel,
                      const MCInstrInfo &MII, const MCRegisterInfo &MRI);
  virtual ~AArch64DCTranslator();

  AArch64DCFunction &getDCF() override { return DCF; }
};

} // end llvm namespace

#endif
