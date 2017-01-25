//===-- AArch64DCFunction.cpp - AArch64 Function Translation ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AArch64DCFunction.h"

using namespace llvm;

AArch64DCFunction::AArch64DCFunction(DCModule &DCM, const MCFunction &MCF)
    : DCFunction(DCM, MCF) {}
