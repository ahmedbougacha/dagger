#ifndef DCTRANSLATOR_H
#define DCTRANSLATOR_H

#include "llvm/DC/DCAnnotationWriter.h"
#include "llvm/DC/DCTranslatedInstTracker.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/MC/MCObjectDisassembler.h"
#include "llvm/PassManager.h"
#include <vector>

namespace llvm {
class MCFunction;
class MCInstPrinter;
class MCModule;
}

namespace llvm {

class DCInstrSema;
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
  Module TheModule;
  MCObjectDisassembler *MCOD;
  MCModule &MCM;
  FunctionPassManager FPM;

  DCTranslatedInstTracker DTIT;

  std::unique_ptr<DCAnnotationWriter> AnnotWriter;

  DCInstrSema &DIS;

  TransOpt::Level OptLevel;

public:
  DCTranslator(LLVMContext &Ctx, TransOpt::Level OptLevel, DCInstrSema &DIS,
               DCRegisterSema &DRS, MCInstPrinter &IP, MCModule &MCM,
               MCObjectDisassembler *MCOD = 0, bool EnableIRAnnotation = false);
  ~DCTranslator();

  Module *getModule() { return &TheModule; }

  Function *getFunctionAt(uint64_t Addr);
  Function *getInitRegSetFunction();
  Function *getFiniRegSetFunction();

  uint64_t getEntrypoint() const { return MCM.getEntrypoint(); }

  Function *getMainFunction();

  void print(raw_ostream &OS);

private:
  void
  translateFunction(MCFunction *MCFN,
                    const MCObjectDisassembler::AddressSetTy &TailCallTargets);
};

} // end namespace llvm

#endif
