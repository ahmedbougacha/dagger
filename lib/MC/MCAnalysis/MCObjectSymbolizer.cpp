//===-- lib/MC/MCObjectSymbolizer.cpp -------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/MC/MCAnalysis/MCObjectSymbolizer.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCRelocationInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Object/ELFObjectFile.h"
#include "llvm/Object/MachO.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>

using namespace llvm;
using namespace object;

//===- MCMachObjectSymbolizer ---------------------------------------------===//

namespace {
class MCMachObjectSymbolizer final : public MCObjectSymbolizer {
  const MachOObjectFile *MOOF;
  // __TEXT;__stubs support.
  uint64_t StubsStart;
  uint64_t StubsCount;
  uint64_t StubSize;
  uint64_t StubsIndSymIndex;

  // MachOObjectFile::getSymbolSize is *super* expensive, because it needs to
  // search through the entire symtab for the next symbol, to determine size.
  // Keep track of all symbols to be able to efficiently provide size.
  std::vector<DataRefImpl> SortedSymbolRefs;

public:
  MCMachObjectSymbolizer(MCContext &Ctx,
                         std::unique_ptr<MCRelocationInfo> RelInfo,
                         const MachOObjectFile *MOOF);

  StringRef findExternalFunctionAt(uint64_t Addr) override;

  void tryAddingPcLoadReferenceComment(raw_ostream &cStream, int64_t Value,
                                       uint64_t Address) override;
  void buildAddrToFunctionSymbolMap() override;
};

struct SymbolRefAddressComparator {
  const MachOObjectFile *MOOF;

  SymbolRefAddressComparator(const MachOObjectFile *MOOF) : MOOF(MOOF) {}

  bool operator()(DataRefImpl &LHS, DataRefImpl &RHS) {
    uint64_t LHSSize, RHSSize;
    MOOF->getSymbolAddress(LHS, LHSSize);
    MOOF->getSymbolAddress(RHS, RHSSize);
    return LHSSize < RHSSize;
  }
};
} // End unnamed namespace

MCMachObjectSymbolizer::MCMachObjectSymbolizer(
    MCContext &Ctx, std::unique_ptr<MCRelocationInfo> RelInfo,
    const MachOObjectFile *MOOF)
  : MCObjectSymbolizer(Ctx, std::move(RelInfo), MOOF), MOOF(MOOF),
    StubsStart(0), StubsCount(0), StubSize(0), StubsIndSymIndex(0) {

  for (const SectionRef &Section : MOOF->sections()) {
    StringRef Name;
    Section.getName(Name);
    if (Name == "__stubs") {
      SectionRef StubsSec = Section;
      if (MOOF->is64Bit()) {
        MachO::section_64 S = MOOF->getSection64(StubsSec.getRawDataRefImpl());
        StubsIndSymIndex = S.reserved1;
        StubSize = S.reserved2;
      } else {
        MachO::section S = MOOF->getSection(StubsSec.getRawDataRefImpl());
        StubsIndSymIndex = S.reserved1;
        StubSize = S.reserved2;
      }
      assert(StubSize && "Mach-O stub entry size can't be zero!");
      StubsStart = StubsSec.getAddress();
      StubsCount = StubsSec.getSize();
      StubsCount /= StubSize;
    }
  }

  for (const SymbolRef &Symbol : MOOF->symbols())
    SortedSymbolRefs.push_back(Symbol.getRawDataRefImpl());

  std::sort(SortedSymbolRefs.begin(), SortedSymbolRefs.end(),
            SymbolRefAddressComparator(MOOF));
}

StringRef MCMachObjectSymbolizer::findExternalFunctionAt(uint64_t Addr) {
  // FIXME: also, this can all be done at the very beginning, by iterating over
  // all stubs and creating the calls to outside functions. Is it worth it
  // though?
  if (!StubSize)
    return StringRef();
  uint64_t StubIdx = (Addr - StubsStart) / StubSize;
  if (StubIdx >= StubsCount)
    return StringRef();

  uint32_t SymtabIdx =
    MOOF->getIndirectSymbolTableEntry(MOOF->getDysymtabLoadCommand(), StubIdx);
  symbol_iterator SI = MOOF->getSymbolByIndex(SymtabIdx);

  StringRef SymName;
  SI->getName(SymName);
  assert(SI != MOOF->symbol_end() && "Stub wasn't found in the symbol table!");
  assert(SymName.front() == '_' && "Mach-O symbol doesn't start with '_'!");
  return SymName.substr(1);
}

void MCMachObjectSymbolizer::
tryAddingPcLoadReferenceComment(raw_ostream &cStream, int64_t Value,
                                uint64_t Address) {
  if (const RelocationRef *R = findRelocationAt(Address)) {
    const MCExpr *RelExpr = RelInfo->createExprForRelocation(*R);
    if (!RelExpr || RelExpr->EvaluateAsAbsolute(Value) == false)
      return;
  }
  uint64_t Addr = Value;
  if (const SectionRef *S = findSectionContaining(Addr)) {
    StringRef Name; S->getName(Name);
    uint64_t SAddr = S->getAddress();
    if (Name == "__cstring") {
      StringRef Contents;
      S->getContents(Contents);
      Contents = Contents.substr(Addr - SAddr);
      cStream << " ## literal pool for: "
              << Contents.substr(0, Contents.find_first_of(0));
    }
  }
}

void MCMachObjectSymbolizer::buildAddrToFunctionSymbolMap() {
  for (size_t SymI = 0; SymI != SortedSymbolRefs.size(); ++SymI) {
  //for (auto SymbolDRI : SortedSymbolRefs) {
    const DataRefImpl &SymbolDRI = SortedSymbolRefs[SymI];
    const SymbolRef Symbol(SymbolDRI, MOOF);
    uint64_t SymAddr;
    Symbol.getAddress(SymAddr);
    uint64_t SymSize;

    if (SymI+1 != SortedSymbolRefs.size()) {
      const DataRefImpl &NextSymbolDRI = SortedSymbolRefs[SymI+1];
      uint64_t SymSize, NextSymSize;
      MOOF->getSymbolAddress(SymbolDRI, SymSize);
      MOOF->getSymbolAddress(NextSymbolDRI, NextSymSize);
      SymSize = NextSymSize - SymSize;
    } else {
      Symbol.getSize(SymSize);
    }

    StringRef SymName;
    Symbol.getName(SymName);
    SymbolRef::Type SymType;
    Symbol.getType(SymType);
    if (SymAddr == UnknownAddressOrSize || SymSize == UnknownAddressOrSize ||
        SymName.empty() || SymType != SymbolRef::ST_Function)
      continue;

    MCSymbol *Sym = Ctx.GetOrCreateSymbol(SymName);
    AddrToFunctionSymbol.push_back(FunctionSymbol(SymAddr, SymSize, Sym));
  }
  std::stable_sort(AddrToFunctionSymbol.begin(), AddrToFunctionSymbol.end());
}


//===- MCObjectSymbolizer -------------------------------------------------===//

MCObjectSymbolizer::MCObjectSymbolizer(
  MCContext &Ctx, std::unique_ptr<MCRelocationInfo> RelInfo,
  const ObjectFile *Obj)
  : MCSymbolizer(Ctx, std::move(RelInfo)), Obj(Obj) {
  buildSectionList();
}

bool MCObjectSymbolizer::
tryAddingSymbolicOperand(MCInst &MI, raw_ostream &cStream,
                         int64_t Value, uint64_t Address, bool IsBranch,
                         uint64_t Offset, uint64_t InstSize) {
  if (IsBranch) {
    StringRef ExtFnName = findExternalFunctionAt((uint64_t)Value);
    if (!ExtFnName.empty()) {
      MCSymbol *Sym = Ctx.GetOrCreateSymbol(ExtFnName);
      const MCExpr *Expr = MCSymbolRefExpr::Create(Sym, Ctx);
      MI.addOperand(MCOperand::CreateExpr(Expr));
      return true;
    }
  }

  if (const RelocationRef *R = findRelocationAt(Address + Offset)) {
    if (const MCExpr *RelExpr = RelInfo->createExprForRelocation(*R)) {
      MI.addOperand(MCOperand::CreateExpr(RelExpr));
      return true;
    }
    // Only try to create a symbol+offset expression if there is no relocation.
    return false;
  }

  // Interpret Value as a branch target.
  if (IsBranch == false)
    return false;

  uint64_t SymbolOffset;
  MCSymbol *Sym = findContainingFunction(Value, SymbolOffset);

  if (!Sym)
    return false;
  const MCExpr *Expr = MCSymbolRefExpr::Create(Sym, Ctx);
  if (SymbolOffset) {
    const MCExpr *Off = MCConstantExpr::Create(SymbolOffset, Ctx);
    Expr = MCBinaryExpr::CreateAdd(Expr, Off, Ctx);
  }
  MI.addOperand(MCOperand::CreateExpr(Expr));
  return true;
}

MCSymbol *MCObjectSymbolizer::
findContainingFunction(uint64_t Addr, uint64_t &Offset)
{
  if (AddrToFunctionSymbol.empty())
    buildAddrToFunctionSymbolMap();

  const FunctionSymbol FS(Addr);
  AddrToFunctionSymbolMap::iterator SB = AddrToFunctionSymbol.begin();
  AddrToFunctionSymbolMap::iterator SI;
  SI = std::upper_bound(SB, AddrToFunctionSymbol.end(), FS);

  if (SI == AddrToFunctionSymbol.begin())
    return 0;

  // Iterate backwards until we find the first symbol in the list that
  // covers Addr. This doesn't work if [SI->Addr, SI->Addr+SI->Size)
  // overlap, but it does work for symbols that have the same address
  // and zero size.
  --SI;
  const uint64_t SymAddr = SI->Addr;
  MCSymbol *Sym = 0;
  Offset = Addr - SymAddr;
  do {
    if (SymAddr == Addr || SymAddr + SI->Size > Addr)
      Sym = SI->Sym;
  } while (SI != SB && (--SI)->Addr == SymAddr);

  return Sym;
}

void MCObjectSymbolizer::buildAddrToFunctionSymbolMap() {
  for (const SymbolRef &Symbol : Obj->symbols()) {
    uint64_t SymAddr;
    Symbol.getAddress(SymAddr);
    uint64_t SymSize;
    Symbol.getSize(SymSize);
    StringRef SymName;
    Symbol.getName(SymName);
    SymbolRef::Type SymType;
    Symbol.getType(SymType);
    if (SymAddr == UnknownAddressOrSize || SymSize == UnknownAddressOrSize ||
        SymName.empty() || SymType != SymbolRef::ST_Function)
      continue;

    MCSymbol *Sym = Ctx.GetOrCreateSymbol(SymName);
    AddrToFunctionSymbol.push_back(FunctionSymbol(SymAddr, SymSize, Sym));
  }
  std::stable_sort(AddrToFunctionSymbol.begin(), AddrToFunctionSymbol.end());
}

void MCObjectSymbolizer::
tryAddingPcLoadReferenceComment(raw_ostream &cStream,
                                int64_t Value, uint64_t Address) {
}

StringRef MCObjectSymbolizer::findExternalFunctionAt(uint64_t Addr) {
  return StringRef();
}

MCObjectSymbolizer *MCObjectSymbolizer::createObjectSymbolizer(
    MCContext &Ctx, std::unique_ptr<MCRelocationInfo> RelInfo,
    const ObjectFile *Obj) {
  if (const MachOObjectFile *MOOF = dyn_cast<MachOObjectFile>(Obj))
    return new MCMachObjectSymbolizer(Ctx, std::move(RelInfo), MOOF);
  return new MCObjectSymbolizer(Ctx, std::move(RelInfo), Obj);
}

// SortedSections implementation.

const SectionRef *
MCObjectSymbolizer::findSectionContaining(uint64_t Addr) const {
  const SectionInfo *SecInfo = findSectionInfoContaining(Addr);
  if (!SecInfo)
    return nullptr;
  return &SecInfo->Section;
}

const MCObjectSymbolizer::SectionInfo *
MCObjectSymbolizer::findSectionInfoContaining(uint64_t Addr) const {
  return const_cast<MCObjectSymbolizer*>(this)->findSectionInfoContaining(Addr);
}

MCObjectSymbolizer::SectionInfo *
MCObjectSymbolizer::findSectionInfoContaining(uint64_t Addr) {
  auto EndIt = SortedSections.end(),
       It = std::lower_bound(SortedSections.begin(), EndIt, Addr);
  if (It == EndIt)
    return nullptr;
  uint64_t SAddr = It->Section.getAddress();
  uint64_t SSize = It->Section.getSize();
  if (Addr >= SAddr + SSize || Addr < SAddr)
    return nullptr;
  return &*It;
}

const RelocationRef *MCObjectSymbolizer::findRelocationAt(uint64_t Addr) const {
  const SectionInfo *SecInfo = findSectionInfoContaining(Addr);
  if (!SecInfo)
    return nullptr;
  auto RI = SecInfo->Relocs.find(Addr);
  if (RI == SecInfo->Relocs.end())
    return nullptr;
  return &RI->second;
}

void MCObjectSymbolizer::buildSectionList() {
  // FIXME: change to insert then sort, rather than .inserting in the middle
  for (const SectionRef &Section : Obj->sections()) {
    if (!Section.isRequiredForExecution())
      continue;
    uint64_t SAddr = Section.getAddress();
    uint64_t SSize = Section.getSize();
    SortedSectionList::iterator It =
        std::lower_bound(SortedSections.begin(), SortedSections.end(), SAddr);
    if (It != SortedSections.end()) {
      uint64_t FoundSAddr = It->Section.getAddress();
      if (FoundSAddr < SAddr + SSize)
        llvm_unreachable("Inserting overlapping sections");
    }
    SortedSections.insert(It, Section);
  }
  for (auto &SecInfo : SortedSections)
    buildRelocationByAddrMap(SecInfo);
}

void MCObjectSymbolizer::buildRelocationByAddrMap(
  MCObjectSymbolizer::SectionInfo &SecInfo) {
  auto &AddrToReloc = SecInfo.Relocs;
  for (const RelocationRef &Reloc : SecInfo.Section.relocations()) {
    uint64_t Address;
    Reloc.getAddress(Address);
    // FIXME: why not keep all of them, if we do a sorted vector instead?
    // At a specific address, only keep the first relocation.
    if (AddrToReloc.find(Address) == AddrToReloc.end())
      AddrToReloc[Address] = Reloc;
  }
}
