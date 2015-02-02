//===-- lib/MC/MCFunction.cpp -----------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include <algorithm>

using namespace llvm;

// MCFunction

MCFunction::MCFunction(StringRef Name, MCModule *Parent)
  : Name(Name), ParentModule(Parent)
{}

MCFunction::~MCFunction() {
  for (auto BB : Blocks)
    delete BB;
}

MCBasicBlock &MCFunction::createBlock(uint64_t StartAddr) {
  MCBasicBlock *MCBB(new MCBasicBlock(StartAddr, this));
  if (Blocks.empty())
    ParentModule->registerFunctionEntryAddress(this, StartAddr);
  Blocks.push_back(MCBB);
  return *Blocks.back();
}

MCBasicBlock *MCFunction::find(uint64_t StartAddr) {
  for (auto BB : *this)
    if (BB->getStartAddr() == StartAddr)
      return BB;
  return nullptr;
}

const MCBasicBlock *MCFunction::find(uint64_t StartAddr) const {
  return const_cast<MCFunction *>(this)->find(StartAddr);
}

MCBasicBlock *MCFunction::findContaining(uint64_t Addr) {
  for (auto BB : *this)
    if (BB->getStartAddr() <= Addr && BB->getStartAddr() + BB->getSize() > Addr)
      return BB;
  return nullptr;
}

const MCBasicBlock *MCFunction::findContaining(uint64_t Addr) const {
  return const_cast<MCFunction *>(this)->findContaining(Addr);
}

MCBasicBlock *MCFunction::findFirstAfter(uint64_t Addr) {
  MCBasicBlock *FirstAfter = nullptr;
  for (auto BB : *this)
    if (BB->getStartAddr() > Addr)
      if (!FirstAfter || FirstAfter->getStartAddr() > BB->getStartAddr())
        FirstAfter = BB;
  return FirstAfter;
}

const MCBasicBlock *MCFunction::findFirstAfter(uint64_t Addr) const {
  return const_cast<MCFunction *>(this)->findFirstAfter(Addr);
}

// MCBasicBlock

MCBasicBlock::MCBasicBlock(uint64_t StartAddr, MCFunction *Parent)
    : StartAddr(StartAddr), Size(0), InstCount(0),
      NextInstAddress(StartAddr), Parent(Parent) {
}

void MCBasicBlock::addSuccessor(const MCBasicBlock *MCBB) {
  if (!isSuccessor(MCBB))
    Successors.push_back(MCBB);
}

bool MCBasicBlock::isSuccessor(const MCBasicBlock *MCBB) const {
  return std::find(Successors.begin(), Successors.end(),
                   MCBB) != Successors.end();
}

void MCBasicBlock::addPredecessor(const MCBasicBlock *MCBB) {
  if (!isPredecessor(MCBB))
    Predecessors.push_back(MCBB);
}

bool MCBasicBlock::isPredecessor(const MCBasicBlock *MCBB) const {
  return std::find(Predecessors.begin(), Predecessors.end(),
                   MCBB) != Predecessors.end();
}

MCBasicBlock *MCBasicBlock::split(uint64_t SplitAddr) {
  MCBasicBlock *NewBB = &Parent->createBlock(SplitAddr);

  InstListTy::iterator I = Insts.begin();
  while (I != Insts.end() && I->Address < SplitAddr) ++I;
  assert(I != Insts.end() && "Split point not found in disassembly!");
  assert(I->Address == SplitAddr &&
         "Split point does not fall on instruction boundary!");
  NewBB->Insts.splice(NewBB->Insts.end(), Insts, I, Insts.end());

  NewBB->addPredecessor(this);
  NewBB->Successors = Successors;
  Successors.clear();
  addSuccessor(NewBB);
  return NewBB;
}

void MCBasicBlock::addInst(const MCInst &I, uint64_t InstSize) {
  Insts.push_back(MCDecodedInst(I, NextInstAddress, InstSize));
  NextInstAddress += InstSize;
  Size += InstSize;
  ++InstCount;
}
