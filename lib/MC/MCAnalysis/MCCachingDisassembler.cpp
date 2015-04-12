//===- lib/MC/MCAnalysis/MCCachingDisassembler.cpp ------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/MC/MCAnalysis/MCCachingDisassembler.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "mccachingdisasm"

STATISTIC(NumTranslatedInsts, "Number of instructions translated");
STATISTIC(NumUniquedInsts   , "Number of instructions uniqued");

MCCachingDisassembler::~MCCachingDisassembler() {}

MCDisassembler::DecodeStatus MCCachingDisassembler::getInstruction(
    MCInst &Inst, uint64_t &InstSize, ArrayRef<uint8_t> Bytes, uint64_t Addr,
    raw_ostream &vStream, raw_ostream &cStream) const {

  if (findCachedInstruction(Inst, InstSize, Bytes)) {
    ++NumUniquedInsts;
    return Success;
  }

  DecodeStatus S =
      Impl.getInstruction(Inst, InstSize, Bytes, Addr, vStream, cStream);

  if (S == Success) {
    ++NumTranslatedInsts;
    addTempInstruction(Inst, Bytes.slice(InstSize));
  }

  return S;
}

bool MCCachingDisassembler::findCachedInstruction(
    MCInst &Inst, uint64_t &InstSize, ArrayRef<uint8_t> Bytes) const {
  ArrayRef<uint8_t> LongestBytes = Bytes.slice(LongestCachedRawBytes);
  auto CachedIt =
      std::lower_bound(CachedInsts.begin(), CachedInsts.end(), LongestBytes);
  if (CachedIt != CachedInsts.end()) {
    if (std::equal(CachedIt->Bytes.begin(), CachedIt->Bytes.end(),
                   LongestBytes.begin())) {
      Inst = CachedIt->Inst;
      InstSize = CachedIt->Bytes.size();
      return true;
    }
  }
  return false;
}

void MCCachingDisassembler::addTempInstruction(const MCInst &Inst,
                                               ArrayRef<uint8_t> Bytes) const {
  TempInstKeys.push_back(TempInstKey());
  TempInstKeys.back().Bytes = Bytes;
  TempInstKeys.back().ValueIdx = TempInstValues.size();

  TempInstValues.push_back(Inst);

  if (TempInstValues.size() > 5000)
    uniqueTempInstructions();
}

void MCCachingDisassembler::uniqueTempInstructions() const {

  DEBUG(dbgs() << " Trying to unique \n");
  DEBUG(dbgs() << " Uniqued " << NumUniquedInsts << " and translated "
               << NumTranslatedInsts << " \n");

  for (auto CachedInst : CachedInsts) {
    TempInstKeys.push_back(TempInstKey());
    TempInstKeys.back().Bytes = CachedInst.Bytes;
    TempInstKeys.back().ValueIdx = TempInstValues.size();

    TempInstValues.push_back(CachedInst.Inst);
  }

  std::sort(TempInstKeys.begin(), TempInstKeys.end());

  struct TempInstKeyCount {
    unsigned KeyIdx;
    unsigned Count;
    bool operator<(const TempInstKeyCount &RHS) const {
      return RHS.Count < Count;
    }
  };
  std::vector<TempInstKeyCount> DuplicateKeys;

  ArrayRef<uint8_t> *LastKeyBytes = nullptr;

  for (size_t KI = 0, KE = TempInstKeys.size(); KI != KE; ++KI) {
    TempInstKey& Key = TempInstKeys[KI];
    if (!LastKeyBytes || !LastKeyBytes->equals(Key.Bytes)) {
      DuplicateKeys.push_back(TempInstKeyCount());
      DuplicateKeys.back().KeyIdx = KI;
    }
    ++DuplicateKeys.back().Count;
    LastKeyBytes = &Key.Bytes;
  }

  std::sort(DuplicateKeys.begin(), DuplicateKeys.end());

  // FIXME: we should keep track of cachedinst->tempinst mapping when merging,
  // so that we don't need to copy everything again, but only what changed
  CachedInsts.clear();
  CachedInsts.reserve(2000);
  for (size_t DI = 0, DE = DuplicateKeys.size(); DI != DE && DI < 2000; ++DI) {
    TempInstKeyCount& KeyCount = DuplicateKeys[DI];
    TempInstKey& Key = TempInstKeys[KeyCount.KeyIdx];
    MCInst& Value = TempInstValues[Key.ValueIdx];
    CachedInsts.push_back(CachedInstEntry());
    CachedInsts.back().Bytes = Key.Bytes;
    CachedInsts.back().Inst = Value;
    LongestCachedRawBytes = std::max(Key.Bytes.size(), LongestCachedRawBytes);
  }

  // FIXME: insert them already sorted?
  std::sort(CachedInsts.begin(), CachedInsts.end());
  DEBUG(dbgs() << " Cached " << CachedInsts.size() <<  " \n");

  TempInstKeys.clear();
  TempInstValues.clear();
  TempInstKeys.reserve(7000);
  TempInstValues.reserve(7000);
}
