//===-- include/llvm/DC/Utils/Translator.h -----------------------*- C++ -*-===//
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


#ifndef LLVM_DC_UTILS_TRANSLATOR_H
#define LLVM_DC_UTILS_TRANSLATOR_H

#include <cstdint>

namespace llvm {

class Function;
class DCTranslator;
class MCModule;
class MCObjectDisassembler;
class MCObjectSymbolizer;

Function *translateRecursivelyAt(uint64_t EntryAddr, DCTranslator &DCT,
                                 MCModule &MCM,
                                 MCObjectDisassembler *MCOD = nullptr,
                                 MCObjectSymbolizer *MOS = nullptr);

} // end namespace llvm

#endif
