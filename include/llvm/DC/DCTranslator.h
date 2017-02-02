//===-- llvm/DC/DCTranslator.h - DC Translation Engine ----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the DCTranslator class, a wrapper around the DC library
// to drive the translation of a Machine Code function (represented as an MC CFG,
// implemented by an MCFunction), to LLVM IR.
//
// It can also provide the execution context necessary for the translated IR,
// such as a wrapper "main" function that sets up a Register Set and a Stack.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_DCTRANSLATOR_H
#define LLVM_DC_DCTRANSLATOR_H

#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/DC/DCRegisterSetDesc.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include <vector>

namespace llvm {
class DCBasicBlock;
class DCFunction;
class DCInstruction;
class DCModule;
class MCBasicBlock;
class MCDecodedInst;
class MCFunction;
class MCInstrInfo;
class MCRegisterInfo;

class DCTranslator {
  LLVMContext &Ctx;
  const DataLayout DL;
  const MCInstrInfo &MII;
  const MCRegisterInfo &MRI;

  const DCRegisterSetDesc RegSetDesc;

  std::vector<std::unique_ptr<Module>> ModuleSet;

  Module *CurrentModule;
  std::unique_ptr<legacy::FunctionPassManager> CurrentFPM;

  unsigned OptLevel;

  std::unique_ptr<DCModule> DCM;

public:
  /// Construct a DCTranslator for a target.
  /// \param Ctx  The LLVMContext to emit the IR with.
  /// \param DL   The DataLayout to use for the produced IR.
  /// \param OptLevel How optimized the output should be (0-3).
  DCTranslator(LLVMContext &Ctx, const DataLayout &DL, unsigned OptLevel,
               const MCInstrInfo &MII, const MCRegisterInfo &MRI,
               const DCRegisterSetDesc RegSetDesc);
  virtual ~DCTranslator();

  const MCInstrInfo &getMII() const { return MII; }
  const MCRegisterInfo &getMRI() const { return MRI; }
  const DCRegisterSetDesc &getRegSetDesc() const { return RegSetDesc; }
  const DataLayout &getDataLayout() const { return DL; }

  DCModule *getDCModule() { return DCM.get(); }

  // Finalize the current translation module for usage. This does a number of
  // things, including running optimizations.
  // The DCTranslator retains ownership of the module, but it will not be used
  // for translation anymore.  A new module will be created to be used for
  // future translation.
  Module *finalizeTranslationModule();

  Function *translateFunction(const MCFunction &MCFN);

  Function *getFunction(StringRef Name);

protected:
  virtual std::unique_ptr<DCModule> createDCModule(Module &M) = 0;

  virtual std::unique_ptr<DCFunction>
  createDCFunction(DCModule &DCM, const MCFunction &MCF) = 0;

  virtual std::unique_ptr<DCBasicBlock>
  createDCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB) = 0;

  virtual std::unique_ptr<DCInstruction>
  createDCInstruction(DCBasicBlock &DCB, const MCDecodedInst &MCI) = 0;

  // Create and setup a new module for translation.
  void initializeTranslationModule();
};

} // end namespace llvm

#endif
