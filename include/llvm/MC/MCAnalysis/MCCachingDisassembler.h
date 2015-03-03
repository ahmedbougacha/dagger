//===-- llvm/MC/MCAnalysis/MCCachingDisassembler.h --------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_MC_MCANALYSIS_MCDISASSEMBLER_H
#define LLVM_MC_MCANALYSIS_MCDISASSEMBLER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/MC/MCDisassembler.h"
#include "llvm/MC/MCInst.h"
#include <algorithm>
#include <vector>

namespace llvm {

// FIXME: Make sure the same byte sequence at different addresses isn't
// interpreted as a different MCInst.  A simple way could be to use a different
// address when disassembling, and only putting the MCInst in the cache when
// it's independent of the address (i.e., it's the same for both the original
// and the modified address).

/// MCCachingDisassembler - Provide a transparent caching layer around
/// an arbitrary MCDisassembler.
class MCCachingDisassembler : public MCDisassembler {
public:
  MCCachingDisassembler(const MCDisassembler &Disassembler,
                        const MCSubtargetInfo &STI)
      : MCDisassembler(STI, Disassembler.getContext()),
        Impl(Disassembler), TempInstKeys(), TempInstValues(), CachedInsts(),
        LongestCachedRawBytes(0) {}

  virtual ~MCCachingDisassembler();

  DecodeStatus getInstruction(MCInst &Instr, uint64_t &Size,
                              ArrayRef<uint8_t> Bytes, uint64_t Address,
                              raw_ostream &VStream,
                              raw_ostream &CStream) const override;
private:
  const MCDisassembler &Impl;

  struct TempInstKey {
    ArrayRef<uint8_t> Bytes;
    unsigned ValueIdx;
    bool operator<(const TempInstKey &RHS) const {
      return std::lexicographical_compare(Bytes.begin(), Bytes.end(),
                                          RHS.Bytes.begin(), RHS.Bytes.end());
    }
  };

  struct CachedInstEntry {
    ArrayRef<uint8_t> Bytes;
    MCInst Inst;
    // < really is a >, because we want to use lower_bound with LHS being a
    // prefix of RHS.
    bool operator<(const CachedInstEntry &RHS) const {
      return *this < RHS.Bytes;
    }
    bool operator<(const ArrayRef<uint8_t> &RHS) const {
      return std::lexicographical_compare(RHS.begin(), RHS.end(),
                                          Bytes.begin(), Bytes.end());
    }
  };

  // All of our data is marked mutable, because getInstruction is const in
  // MCDisassembler.
  mutable std::vector<TempInstKey> TempInstKeys;
  mutable std::vector<MCInst> TempInstValues;

  mutable std::vector<CachedInstEntry> CachedInsts;
  mutable size_t LongestCachedRawBytes;

  bool findCachedInstruction(MCInst &Inst, uint64_t &InstSize,
                             ArrayRef<uint8_t> Bytes) const;
  void addTempInstruction(const MCInst &Inst, ArrayRef<uint8_t> Bytes) const;
  void uniqueTempInstructions() const;
};

} // namespace llvm

#endif
