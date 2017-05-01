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

#include "llvm/ADT/ArrayRef.h"
#include <cstdint>

namespace llvm {

class Function;
class DCTranslator;
class MCModule;
class MCObjectDisassembler;
class MCObjectSymbolizer;

void translateRecursivelyAt(ArrayRef<uint64_t> EntryAddrs, DCTranslator &DCT,
                            MCModule &MCM, MCObjectDisassembler *MCOD = nullptr,
                            MCObjectSymbolizer *MOS = nullptr);

} // end namespace llvm

#endif
