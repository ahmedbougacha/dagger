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

#include "llvm/ADT/StringRef.h"
#include "llvm/MC/MCDisassembler.h"
#include "llvm/MC/MCInst.h"
#include <vector>

namespace llvm {

/// MCCachingDisassembler - Provide a transparent caching layer around
/// an arbitrary MCDisassembler.  Consumes a StringRef memory region and
/// provides an array of assembly instructions.
class MCCachingDisassembler : public MCDisassembler {
public:
  MCCachingDisassembler(const MCDisassembler &Disassembler,
                        const MCSubtargetInfo &STI)
      : MCDisassembler(STI, Disassembler.getContext()),
        Impl(Disassembler), TempInstKeys(), TempInstValues(), CachedInsts(),
        LongestCachedRawBytes(0) {}

  virtual ~MCCachingDisassembler();

  // It is an error to pass a \p region that isn't a StringRefMemoryObject.
  DecodeStatus getInstruction(MCInst &instr, uint64_t &size,
                              const MemoryObject &region, uint64_t address,
                              raw_ostream &vStream,
                              raw_ostream &cStream) const override;
private:
  const MCDisassembler &Impl;

  struct TempInstKey {
    StringRef RawBytes;
    unsigned ValueIdx;
    bool operator<(const TempInstKey &RHS) const { return RawBytes < RHS.RawBytes; }
  };

  struct CachedInstEntry {
    StringRef RawBytes;
    MCInst Inst;
    // < really is a >, because we want to use lower_bound with LHS being a
    // prefix of RHS.
    bool operator<(const CachedInstEntry &RHS) const {
      return RawBytes > RHS.RawBytes;
    }
    bool operator<(const StringRef &RHS) const { return RawBytes > RHS; }
  };

  // All of our data is marked mutable, because getInstruction is const in
  // MCDisassembler.
  mutable std::vector<TempInstKey> TempInstKeys;
  mutable std::vector<MCInst> TempInstValues;

  mutable std::vector<CachedInstEntry> CachedInsts;
  mutable size_t LongestCachedRawBytes;

  bool findCachedInstruction(MCInst &Inst,
                             uint64_t &InstSize,
                             const MemoryObject &Region,
                             uint64_t Addr) const;
  void addTempInstruction(const MCInst &Inst, StringRef RawBytes) const;
  void uniqueTempInstructions() const;
};

} // namespace llvm

#endif
