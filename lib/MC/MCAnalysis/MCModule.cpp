//===- lib/MC/MCModule.cpp - MCModule implementation ----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include <algorithm>

using namespace llvm;

MCFunction *MCModule::createFunction(StringRef Name, uint64_t BeginAddr) {
  std::unique_ptr<MCFunction> MCF(new MCFunction(Name, this));
  FunctionsByAddr.insert(std::make_pair(BeginAddr, MCF.get()));
  Functions.push_back(std::move(MCF));
  return Functions.back().get();
}

MCFunction *MCModule::findFunctionAt(uint64_t BeginAddr) {
  auto FnIt = FunctionsByAddr.find(BeginAddr);
  if (FnIt == FunctionsByAddr.end())
    return nullptr;
  return FnIt->second;
}

MCModule::MCModule() {}

MCModule::~MCModule() {
}
