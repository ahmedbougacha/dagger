//===-- AArch64DCBasicBlock.cpp - AArch64 DCBasicBlock ----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AArch64DCBasicBlock.h"

using namespace llvm;

AArch64DCBasicBlock::AArch64DCBasicBlock(DCFunction &DCF,
                                         const MCBasicBlock &MCB)
    : DCBasicBlock(DCF, MCB) {}
