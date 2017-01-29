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

namespace llvm {

class AArch64DCTranslator final : public DCTranslator {
public:
  AArch64DCTranslator(LLVMContext &Ctx, const DataLayout &DL, unsigned OptLevel,
                      const MCInstrInfo &MII, const MCRegisterInfo &MRI);
  virtual ~AArch64DCTranslator();

protected:
  std::unique_ptr<DCModule> createDCModule(Module &M) override;

  std::unique_ptr<DCFunction> createDCFunction(DCModule &DCM,
                                               const MCFunction &MCF) override;

  std::unique_ptr<DCBasicBlock>
  createDCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB) override;

  std::unique_ptr<DCInstruction>
  createDCInstruction(DCBasicBlock &DCB, const MCDecodedInst &MCI) override;
};

} // end llvm namespace

#endif
