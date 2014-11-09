//===-- MCObjectSymbolizer.h ----------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the MCObjectSymbolizer class, an MCSymbolizer that is
// backed by an object::ObjectFile.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MC_MCANALYSIS_MCOBJECTSYMBOLIZER_H
#define LLVM_MC_MCANALYSIS_MCOBJECTSYMBOLIZER_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/MC/MCSymbolizer.h"
#include "llvm/Object/ObjectFile.h"
#include <vector>

namespace llvm {

class MCExpr;
class MCInst;
class MCRelocationInfo;
class MCSymbol;
class raw_ostream;

/// \brief An ObjectFile-backed symbolizer.
class MCObjectSymbolizer : public MCSymbolizer {
protected:
  const object::ObjectFile *Obj;

  // Map a load address to the first relocation that applies there. As far as I
  // know, if there are several relocations at the exact same address, they are
  // related and the others can be determined from the first that was found in
  // the relocation table. For instance, on x86-64 mach-o, a SUBTRACTOR
  // relocation (referencing the minuend symbol) is followed by an UNSIGNED
  // relocation (referencing the subtrahend symbol).
  const object::RelocationRef *findRelocationAt(uint64_t Addr) const;
  const object::SectionRef *findSectionContaining(uint64_t Addr) const;

  MCObjectSymbolizer(MCContext &Ctx, std::unique_ptr<MCRelocationInfo> RelInfo,
                     const object::ObjectFile *Obj);

public:
  /// \name Overridden MCSymbolizer methods:
  /// @{
  bool tryAddingSymbolicOperand(MCInst &MI, raw_ostream &cStream,
                                int64_t Value, uint64_t Address,
                                bool IsBranch, uint64_t Offset,
                                uint64_t InstSize) override;

  void tryAddingPcLoadReferenceComment(raw_ostream &cStream,
                                       int64_t Value,
                                       uint64_t Address) override;
  /// @}

  /// \brief Look for an external function symbol at \p Addr.
  /// (References through the ELF PLT, Mach-O stubs, and similar).
  /// \returns The function's name, or the empty string if not found.
  virtual StringRef findExternalFunctionAt(uint64_t Addr);

  /// \brief Create an object symbolizer for \p Obj.
  static MCObjectSymbolizer *
  createObjectSymbolizer(MCContext &Ctx,
                         std::unique_ptr<MCRelocationInfo> RelInfo,
                         const object::ObjectFile *Obj);

protected:
  struct FunctionSymbol {
    uint64_t Addr;
    uint64_t Size;
    MCSymbol *Sym;
    FunctionSymbol(uint64_t Addr, uint64_t Size = 0, MCSymbol *Sym = 0) :
      Addr(Addr), Size(Size), Sym(Sym) { }
    bool operator<(const FunctionSymbol &RHS) const { return Addr < RHS.Addr; }
  };

  struct SectionInfo {
    SectionInfo(object::SectionRef S) : Section(S) {}
    object::SectionRef Section;
    std::vector<object::RelocationRef> Relocs;
    bool operator<(uint64_t Addr) const {
      return Section.getAddress() + Section.getSize() <= Addr;
    }
  };
  typedef std::vector<SectionInfo> SortedSectionList;
  typedef std::vector<FunctionSymbol> AddrToFunctionSymbolMap;
  SortedSectionList SortedSections;
  AddrToFunctionSymbolMap AddrToFunctionSymbol;

  virtual void buildAddrToFunctionSymbolMap();
  void buildSectionList();
  void buildRelocationByAddrMap(SectionInfo &SecInfo);
  MCSymbol *findContainingFunction(uint64_t Addr, uint64_t &Offset);

  const SectionInfo *findSectionInfoContaining(uint64_t Addr) const;
  SectionInfo *findSectionInfoContaining(uint64_t Addr);
};

}

#endif
