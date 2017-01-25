//===-- lib/DC/DCBasicBlock.cpp - Basic Block Translation -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCBasicBlock.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "dc-sema"

DCBasicBlock::DCBasicBlock(DCFunction &DCF, const MCBasicBlock &MCB)
    : DCF(DCF), TheBB(*DCF.getOrCreateBasicBlock(MCB.getStartAddr())),
      TheMCBB(MCB) {
  // FIXME: we need to keep the unreachable+trap when the basic block is 0-inst.
  assert(
      (TheBB.size() == 2 && isa<UnreachableInst>(std::next(TheBB.begin()))) &&
      "Several BBs at the same address?");
  TheBB.begin()->eraseFromParent();
  TheBB.begin()->eraseFromParent();

  getDRS().SwitchToBasicBlock(getBasicBlock());

  // The PC at the start of the basic block is known, just set it.
  const unsigned PC = getDRS().MRI.getProgramCounter();
  getDRS().setReg(
      PC, ConstantInt::get(getDRS().getRegType(PC), TheMCBB.getStartAddr()));
}

DCBasicBlock::~DCBasicBlock() {
  if (!TheBB.getTerminator())
    BranchInst::Create(DCF.getOrCreateBasicBlock(TheMCBB.getEndAddr()),
                       getBasicBlock());
  getDRS().FinalizeBasicBlock();
}
