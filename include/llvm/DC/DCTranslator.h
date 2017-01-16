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
// to drive the translation of a Machine Code program (represented as an MC CFG,
// implemented by an MCModule), to LLVM IR.
//
// It provides the execution context necessary for the translated IR, such as
// a wrapper "main" function that sets up a Register Set and a Stack.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_DCTRANSLATOR_H
#define LLVM_DC_DCTRANSLATOR_H

#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/DC/DCAnnotationWriter.h"
#include "llvm/DC/DCTranslatedInstTracker.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include <vector>

namespace llvm {
class MCFunction;
class MCInstPrinter;
class MCModule;
class MCObjectDisassembler;
class MCObjectSymbolizer;
}

namespace llvm {

class DCFunction;
class DCRegisterSema;

namespace TransOpt {
enum Level {
  None,      // Generate everything as-is
  Less,      // Enable mem2reg
  Default,   //        + dce
  Aggressive //        + instcombine, ..
};
}

class DCTranslator {
  LLVMContext &Ctx;
  const DataLayout DL;

  std::vector<std::unique_ptr<Module>> ModuleSet;

  MCObjectDisassembler *MCOD;
  MCObjectSymbolizer *MOS;
  MCModule &MCM;

  Module *CurrentModule;
  std::unique_ptr<legacy::FunctionPassManager> CurrentFPM;

  const bool EnableIRAnnotation;
  std::unique_ptr<DCTranslatedInstTracker> DTIT;

  DCFunction &DCF;

  TransOpt::Level OptLevel;

public:
  DCTranslator(LLVMContext &Ctx, const DataLayout &DL, TransOpt::Level OptLevel,
               DCFunction &DCF, DCRegisterSema &DRS, MCInstPrinter &IP,
               const MCSubtargetInfo &STI, MCModule &MCM,
               MCObjectDisassembler *MCOD = nullptr,
               MCObjectSymbolizer *MOS = nullptr,
               bool EnableIRAnnotation = false);
  ~DCTranslator();

  // FIXME: These belong in a 'DCModule'.
  Function *getInitRegSetFunction();
  Function *getFiniRegSetFunction();
  Function *createMainFunctionWrapper(Function *Entrypoint);

  Function *createExternalWrapperFunction(uint64_t Addr, Value *ExtFn);
  Function *createExternalWrapperFunction(uint64_t Addr, StringRef Name);
  Function *createExternalWrapperFunction(uint64_t Addr);

  std::string getDCFunctionName(uint64_t Addr) {
    return "fn_" + utohexstr(Addr);
  }

  // Finalize the current translation module for usage. This does a number of
  // things, including running optimizations.
  // The DCTranslator retains ownership of the module, but it will not be used
  // for translation anymore.  A new module will be created to be used for
  // future translation.
  // If EnableIRAnnotation was true and \p OldDTIT is non-null, the translation
  // tracker for the module is returned in \p OldDTIT.
  Module *finalizeTranslationModule(
      std::unique_ptr<DCTranslatedInstTracker> *OldDTIT = nullptr);

  Function *translateRecursivelyAt(uint64_t EntryAddr);

private:
  void translateFunction(const MCFunction &MCFN);

  // Create and setup a new module for translation.
  void initializeTranslationModule();
};

} // end namespace llvm

#endif
