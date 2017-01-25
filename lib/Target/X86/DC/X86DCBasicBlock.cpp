//===-- X86DCBasicBlock.cpp - X86 Targeting of DCBasicBlock -----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "X86DCBasicBlock.h"

using namespace llvm;

X86DCBasicBlock::X86DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB)
    : DCBasicBlock(DCF, MCB), LastPrefix(0) {}
