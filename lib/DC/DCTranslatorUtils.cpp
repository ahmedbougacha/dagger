//===-- llvm/DC/TranslatorUtils.cpp -----------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCTranslatorUtils.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/DC/DCTranslator.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/MC/MCAnalysis/MCObjectDisassembler.h"
#include "llvm/MC/MCAnalysis/MCObjectSymbolizer.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "dctranslator-utils"

Function *llvm::translateRecursivelyAt(uint64_t EntryAddr, DCTranslator &DCT,
                                       MCModule &MCM,
                                       MCObjectDisassembler *MCOD,
                                       MCObjectSymbolizer *MOS) {
  SmallSetVector<uint64_t, 16> WorkList;
  WorkList.insert(EntryAddr);
  for (size_t i = 0; i < WorkList.size(); ++i) {
    uint64_t Addr = WorkList[i];
    Function *F = DCT.getFunction(DCT.getDCFunctionName(Addr));
    if (F && !F->isDeclaration())
      continue;

    DEBUG(dbgs() << "Translating function at " << utohexstr(Addr) << "\n");

    // Look for an external function.
    // If the function isn't even in the main object, just call it by address.
    // FIXME: original/effective?
    if (MOS) {
      if (!MOS->isInObject(MOS->getOriginalLoadAddr(Addr))) {
        DEBUG(dbgs() << "Found external (not in object) function: " << Addr
                     << "\n");
        DCT.createExternalWrapperFunction(Addr);
        continue;
      }

      // If the function is explicitly referenced by the main object, emit a
      // direct call to the function, by name.
      StringRef ExtFnName = MOS->findExternalFunctionAt(Addr);
      if (!ExtFnName.empty()) {
        DEBUG(dbgs() << "Found external function: " << ExtFnName << "\n");
        DCT.createExternalWrapperFunction(Addr, ExtFnName);
        continue;
      }
    }

    // Now look for the function if it was already in the module.
    MCFunction *MCFN = MCM.findFunctionAt(Addr);
    // If it wasn't, we need to disassemble it.
    if (!MCFN) {
      if (!MCOD)
        report_fatal_error(("Unable to translate unknown function at " +
                            utohexstr(Addr) + " without a disassembler!")
                               .c_str());
      MCFN = MCOD->createFunction(&MCM, Addr);
    }
    assert(MCFN && "Wasn't able to translate function!");

    DCT.translateFunction(*MCFN);
    for (uint64_t CallTarget : MCFN->callees())
      WorkList.insert(CallTarget);
  }
  return DCT.getFunction(DCT.getDCFunctionName(EntryAddr));
}
