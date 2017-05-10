//===- lib/MC/MCModule.cpp - MCModule implementation ----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"

using namespace llvm;

MCFunction *MCModule::createFunction(StringRef Name, uint64_t StartAddr) {
  std::unique_ptr<MCFunction> MCF(new MCFunction(Name, StartAddr, this));
  FunctionsByAddr.insert(std::make_pair(StartAddr, MCF.get()));
  Functions.push_back(std::move(MCF));
  return Functions.back().get();
}

MCFunction *MCModule::findFunctionAt(uint64_t StartAddr) {
  auto FnIt = FunctionsByAddr.find(StartAddr);
  if (FnIt == FunctionsByAddr.end())
    return nullptr;
  return FnIt->second;
}

MCModule::MCModule() {}

MCModule::~MCModule() {
}
