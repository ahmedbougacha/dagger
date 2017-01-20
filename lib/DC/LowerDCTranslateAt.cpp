//===-- lib/DC/LowerDCTranslateAt.cpp - Lower dc.translate.at ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/LowerDCTranslateAt.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

/// Lower calls to the @llvm.dc.translate.at intrinsic to calls to an arbitrary
/// callback function, with the same signature, responsible for providing a
/// translating IR function pointer from a raw (non-translated) indirect call
/// target pointer.
static bool lowerDCTranslateAt(Module &M, Value *DynTranslateAtCallback) {
  bool Changed = false;

  if (!DynTranslateAtCallback)
    return false;

  auto *TranslateAtInt =
      Intrinsic::getDeclaration(&M, Intrinsic::dc_translate_at);

  if (DynTranslateAtCallback->getType() != TranslateAtInt->getType())
    report_fatal_error("Invalid translate.at callback type");

  for (auto &U : TranslateAtInt->uses()) {
    auto *CI = dyn_cast<CallInst>(U.getUser());

    // If the intrinsic isn't used by a call, ignore it.
    if (!CI)
      continue;

    // If the intrinsic isn't the call target, ignore it.
    if (CI->getCalledValue() != TranslateAtInt)
      continue;

    CI->setCalledFunction(DynTranslateAtCallback);
    Changed = true;
  }

  return Changed;
}

namespace llvm {
void initializeLowerDCTranslateAtPass(PassRegistry &);
}

namespace {
/// \brief Legacy pass for lowering dc.translate.at intrinsics out of the IR.
class LowerDCTranslateAt : public ModulePass {
  Value *DynTranslateAtCallback;
public:
  static char ID;

  LowerDCTranslateAt(Value *DynTranslateAtCallback = nullptr)
      : ModulePass(ID), DynTranslateAtCallback(DynTranslateAtCallback) {
    initializeLowerDCTranslateAtPass(*PassRegistry::getPassRegistry());
  }

  bool runOnModule(Module &M) override {
    return lowerDCTranslateAt(M, DynTranslateAtCallback);
  }
};
}

char LowerDCTranslateAt::ID = 0;
INITIALIZE_PASS(LowerDCTranslateAt, "lower-dc-translateat",
                "Lower 'dc.translate.at' Intrinsics", false, false)

Pass *llvm::createLowerDCTranslateAtPass(Value *DynTranslateAtCallback) {
  return new LowerDCTranslateAt(DynTranslateAtCallback);
}
