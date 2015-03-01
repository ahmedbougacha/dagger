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
    if (BB->getStartAddr() <= Addr && BB->getEndAddr() > Addr)
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

MCBasicBlock &MCFunction::createBlock(uint64_t StartAddr) {
  Blocks.push_back(new MCBasicBlock(StartAddr, this));
  return *Blocks.back();
}

// MCBasicBlock

MCBasicBlock::MCBasicBlock(uint64_t StartAddr, MCFunction *Parent)
    : StartAddr(StartAddr), SizeInBytes(0), InstCount(0),
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

void MCBasicBlock::addInst(const MCInst &I, uint64_t InstSize) {
  Insts.push_back(MCDecodedInst(I, NextInstAddress, InstSize));
  NextInstAddress += InstSize;
  SizeInBytes += InstSize;
  ++InstCount;
}
