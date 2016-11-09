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
#include "llvm/MC/MCDisassembler/MCRelocationInfo.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Object/ELFObjectFile.h"
#include "llvm/Object/MachO.h"
#include "llvm/Object/SymbolSize.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>

using namespace llvm;
using namespace object;

#define DEBUG_TYPE "mcobjectsymbolizer"

//===- Helpers ------------------------------------------------------------===//

static bool RelocRelocOffsetComparator(const object::RelocationRef &LHS,
                                       const object::RelocationRef &RHS) {
  return LHS.getOffset() < RHS.getOffset();
}

static bool RelocU64OffsetComparator(const object::RelocationRef &LHS,
                                     uint64_t RHSOffset) {
  return LHS.getOffset() < RHSOffset;
}

// FIXME: This is icky; consider surfacing errors everywhere.
template<typename T>
static T unwrapOrReportError(Expected<T> TOrErr) {
  if (auto E = TOrErr.takeError())
    handleAllErrors(std::move(E), [](ErrorInfoBase &EI) {
      report_fatal_error(EI.message());
    });
  return *TOrErr;
}

template<typename T>
static T unwrapOrReportError(ErrorOr<T> TOrErr) {
  if (auto E = TOrErr.getError())
    report_fatal_error(E.message());
  return *TOrErr;
}

//===- MCMachObjectSymbolizer ---------------------------------------------===//

MCMachObjectSymbolizer::MCMachObjectSymbolizer(
    MCContext &Ctx, std::unique_ptr<MCRelocationInfo> RelInfo,
    const MachOObjectFile &MOOF, uint64_t VMAddrSlide)
    : MCObjectSymbolizer(Ctx, std::move(RelInfo), MOOF), MOOF(MOOF),
      StubsStart(0), StubsCount(0), StubSize(0), StubsIndSymIndex(0),
      VMAddrSlide(VMAddrSlide) {

  for (const SectionRef &Section : MOOF.sections()) {
    StringRef Name;
    Section.getName(Name);
    if (Name == "__stubs") {
      SectionRef StubsSec = Section;
      if (MOOF.is64Bit()) {
        MachO::section_64 S = MOOF.getSection64(StubsSec.getRawDataRefImpl());
        StubsIndSymIndex = S.reserved1;
        StubSize = S.reserved2;
      } else {
        MachO::section S = MOOF.getSection(StubsSec.getRawDataRefImpl());
        StubsIndSymIndex = S.reserved1;
        StubSize = S.reserved2;
      }
      assert(StubSize && "Mach-O stub entry size can't be zero!");
      StubsStart = StubsSec.getAddress();
      StubsCount = StubsSec.getSize();
      StubsCount /= StubSize;
    }
  }

  // Also look for the init/exit func sections.
  for (const SectionRef &Section : MOOF.sections()) {
    StringRef Name;
    Section.getName(Name);
    // FIXME: We should use the S_ section type instead of the name.
    if (Name == "__mod_init_func") {
      DEBUG(dbgs() << "Found __mod_init_func section!\n");
      Section.getContents(ModInitContents);
    } else if (Name == "__mod_exit_func") {
      DEBUG(dbgs() << "Found __mod_exit_func section!\n");
      Section.getContents(ModExitContents);
    }
  }

  // Finally, look for entrypoints.
  gatherEntrypoints();
}

void MCMachObjectSymbolizer::gatherEntrypoints() {
  uint64_t BaseAddr = 0;
  Optional<uint64_t> EntryFileOffset;

  // Look for LC_MAIN first.
  for (auto LC : MOOF.load_commands()) {
    if (LC.C.cmd == MachO::LC_MAIN)
      EntryFileOffset = MOOF.getEntryPointCommand(LC).entryoff;
    else if (LC.C.cmd == MachO::LC_SEGMENT_64) {
      auto S64LC = MOOF.getSegment64LoadCommand(LC);
      if (S64LC.fileoff == 0 && S64LC.filesize != 0)
        BaseAddr = S64LC.vmaddr;
    } else if (LC.C.cmd == MachO::LC_SEGMENT) {
      auto SLC = MOOF.getSegmentLoadCommand(LC);
      if (SLC.fileoff == 0 && SLC.filesize != 0)
        BaseAddr = SLC.vmaddr;
    }
  }

  // If we did find LC_MAIN, compute the virtual address.
  if (EntryFileOffset)
    MainEntrypoint = BaseAddr + *EntryFileOffset;
}

// FIXME: Only do the translations for addresses actually inside the object.
uint64_t MCMachObjectSymbolizer::getEffectiveLoadAddr(uint64_t Addr) {
  return Addr + VMAddrSlide;
}

uint64_t MCMachObjectSymbolizer::getOriginalLoadAddr(uint64_t EffectiveAddr) {
  return EffectiveAddr - VMAddrSlide;
}

ArrayRef<uint64_t> MCMachObjectSymbolizer::getStaticInitFunctions() {
  // FIXME: We only handle 64bit mach-o
  assert(MOOF.is64Bit());

  size_t EntrySize = 8;
  size_t EntryCount = ModInitContents.size() / EntrySize;
  return makeArrayRef(
      reinterpret_cast<const uint64_t *>(ModInitContents.data()), EntryCount);
}

ArrayRef<uint64_t> MCMachObjectSymbolizer::getStaticExitFunctions() {
  // FIXME: We only handle 64bit mach-o
  assert(MOOF.is64Bit());

  size_t EntrySize = 8;
  size_t EntryCount = ModExitContents.size() / EntrySize;
  return makeArrayRef(
      reinterpret_cast<const uint64_t *>(ModExitContents.data()), EntryCount);
}

StringRef MCMachObjectSymbolizer::findExternalFunctionAt(uint64_t Addr) {
  Addr = getOriginalLoadAddr(Addr);
  // FIXME: also, this can all be done at the very beginning, by iterating over
  // all stubs and creating the calls to outside functions. Is it worth it
  // though?
  if (!StubSize)
    return StringRef();
  uint64_t StubIdx = (Addr - StubsStart) / StubSize;
  if (StubIdx >= StubsCount)
    return StringRef();

  uint32_t SymtabIdx =
      MOOF.getIndirectSymbolTableEntry(MOOF.getDysymtabLoadCommand(), StubIdx);
  symbol_iterator SI = MOOF.getSymbolByIndex(SymtabIdx);

  assert(SI != MOOF.symbol_end() && "Stub wasn't found in the symbol table!");

  const MachO::nlist_64 &SymNList =
      MOOF.getSymbol64TableEntry(SI->getRawDataRefImpl());
  if ((SymNList.n_type & MachO::N_TYPE) != MachO::N_UNDF)
    return StringRef();

  StringRef SymName = unwrapOrReportError(SI->getName());
  assert(SymName.front() == '_' && "Mach-O symbol doesn't start with '_'!");
  return SymName.substr(1);
}

void MCMachObjectSymbolizer::
tryAddingPcLoadReferenceComment(raw_ostream &cStream, int64_t Value,
                                uint64_t Address) {
  if (const RelocationRef *R = findRelocationAt(Address)) {
    const MCExpr *RelExpr =
        unwrapOrReportError(RelInfo->createExprForRelocation(*R));
    if (!RelExpr || RelExpr->evaluateAsAbsolute(Value) == false)
      return;
  }
  uint64_t Addr = Value;
  if (const SectionRef *S = findSectionContaining(Addr)) {
    uint64_t SAddr = S->getAddress();

    StringRef Name;
    if (auto ec = S->getName(Name))
      report_fatal_error(ec.message());

    if (Name == "__cstring") {
      StringRef Contents;
      if (auto ec = S->getContents(Contents))
        report_fatal_error(ec.message());

      Contents = Contents.substr(Addr - SAddr);
      cStream << " ## literal pool for: \"";
      cStream.write_escaped(Contents.substr(0, Contents.find_first_of(0)));
      cStream << "\"";
    }
  }
}

//===- MCELFObjectSymbolizer ---------------------------------------------===//

static bool shouldSkipELFSection(SectionRef S) {
  return !(ELFSectionRef(S).getFlags() & ELF::SHF_ALLOC);
}

MCELFObjectSymbolizer::MCELFObjectSymbolizer(
    MCContext &Ctx, std::unique_ptr<MCRelocationInfo> RelInfo,
    const ELFObjectFileBase &OF)
    : MCObjectSymbolizer(Ctx, std::move(RelInfo), OF, shouldSkipELFSection),
      OF(OF) {

  // Refine the main entrypoint if possible.
  // FIXME: We only handle 64bit LE ELF.
  if (auto *EF = dyn_cast<ELF64LEObjectFile>(&OF))
    MainEntrypoint = EF->getELFFile()->getHeader()->e_entry;
}

//===- MCObjectSymbolizer -------------------------------------------------===//

MCObjectSymbolizer::MCObjectSymbolizer(
    MCContext &Ctx, std::unique_ptr<MCRelocationInfo> RelInfo,
    const ObjectFile &Obj,
    std::function<bool(object::SectionRef)> ShouldSkipSection)
    : MCSymbolizer(Ctx, std::move(RelInfo)), Obj(Obj),
      SymbolSizes(computeSymbolSizes(Obj)) {
  // Gather sections.
  buildSectionList(ShouldSkipSection);

  // Gather entrypoints.
  for (const SymbolRef &Symbol : Obj.symbols()) {
    SymbolRef::Type SymType = unwrapOrReportError(Symbol.getType());
    if (SymType != SymbolRef::ST_Function)
      continue;

    StringRef Name = unwrapOrReportError(Symbol.getName());
    uint64_t Addr = unwrapOrReportError(Symbol.getAddress());

    if (Name == "main" || Name == "_main")
      MainEntrypoint = Addr;
    Entrypoints.push_back(Addr);
  }
}

Optional<uint64_t> MCObjectSymbolizer::getMainEntrypoint() {
  return MainEntrypoint;
}

ArrayRef<uint64_t> MCObjectSymbolizer::getEntrypoints() {
  return Entrypoints;
}

uint64_t MCObjectSymbolizer::getEffectiveLoadAddr(uint64_t Addr) {
  return Addr;
}

uint64_t MCObjectSymbolizer::getOriginalLoadAddr(uint64_t Addr) { return Addr; }

bool MCObjectSymbolizer::
tryAddingSymbolicOperand(MCInst &MI, raw_ostream &cStream,
                         int64_t Value, uint64_t Address, bool IsBranch,
                         uint64_t Offset, uint64_t InstSize) {
  if (IsBranch) {
    StringRef ExtFnName = findExternalFunctionAt((uint64_t)Value);
    if (!ExtFnName.empty()) {
      MCSymbol *Sym = Ctx.getOrCreateSymbol(ExtFnName);
      const MCExpr *Expr = MCSymbolRefExpr::create(Sym, Ctx);
      MI.addOperand(MCOperand::createExpr(Expr));
      return true;
    }
  }

  if (const RelocationRef *R = findRelocationAt(Address + Offset)) {
    if (const MCExpr *RelExpr =
            unwrapOrReportError(RelInfo->createExprForRelocation(*R))) {
      MI.addOperand(MCOperand::createExpr(RelExpr));
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
  const MCExpr *Expr = MCSymbolRefExpr::create(Sym, Ctx);
  if (SymbolOffset) {
    const MCExpr *Off = MCConstantExpr::create(SymbolOffset, Ctx);
    Expr = MCBinaryExpr::createAdd(Expr, Off, Ctx);
  }
  MI.addOperand(MCOperand::createExpr(Expr));
  return true;
}

MCSymbol *MCObjectSymbolizer::
findContainingFunction(uint64_t Addr, uint64_t &Offset)
{
  if (AddrToFunctionSymbol.empty())
    buildAddrToFunctionSymbolMap();

  const FunctionSymbol FS(Addr);
  auto SB = AddrToFunctionSymbol.begin();
  auto SI = std::upper_bound(SB, AddrToFunctionSymbol.end(), FS);

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
  size_t SymI = 0;
  for (const SymbolRef &Symbol : Obj.symbols()) {
    uint64_t SymAddr = unwrapOrReportError(Symbol.getAddress());

    uint64_t SymSize = SymbolSizes[SymI].second;
    assert(SymbolSizes[SymI].first == Symbol);
    ++SymI;

    StringRef SymName = unwrapOrReportError(Symbol.getName());
    SymbolRef::Type SymType = unwrapOrReportError(Symbol.getType());
    if (SymName.empty() || SymType != SymbolRef::ST_Function)
      continue;

    MCSymbol *Sym = Ctx.getOrCreateSymbol(SymName);
    AddrToFunctionSymbol.push_back(FunctionSymbol(SymAddr, SymSize, Sym));
  }
  std::stable_sort(AddrToFunctionSymbol.begin(), AddrToFunctionSymbol.end());
}

void MCObjectSymbolizer::
tryAddingPcLoadReferenceComment(raw_ostream &cStream,
                                int64_t Value, uint64_t Address) {
}

bool MCObjectSymbolizer::isInObject(uint64_t Addr) {
  // FIXME: Finding the section is convenient, but overkill.
  // FIXME: Once this function is made efficient, it should be checked to
  // return early in all the other expensive methods.
  return findSectionContaining(Addr) != nullptr;
}

StringRef MCObjectSymbolizer::findExternalFunctionAt(uint64_t Addr) {
  return StringRef();
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
  // FIXME: Offset vs Addr ?
  auto RI = std::lower_bound(SecInfo->Relocs.begin(), SecInfo->Relocs.end(),
                             Addr, RelocU64OffsetComparator);
  if (RI == SecInfo->Relocs.end())
    return nullptr;
  return &*RI;
}

void MCObjectSymbolizer::buildSectionList(
    std::function<bool(SectionRef)> ShouldSkipSection) {

  for (const SectionRef &Section : Obj.sections()) {
    if (ShouldSkipSection && ShouldSkipSection(Section))
      continue;
    SortedSections.push_back(Section);
  }

  std::sort(SortedSections.begin(), SortedSections.end());

  uint64_t PrevSecEnd = 0;
  for (auto &SecInfo : SortedSections) {
    // First build the relocation map for this section.
    if (Obj.isRelocatableObject())
      buildRelocationByAddrMap(SecInfo);

    // Also, sanity check that we don't have overlapping sections.
    uint64_t SAddr = SecInfo.Section.getAddress();
    uint64_t SSize = SecInfo.Section.getSize();
    if (PrevSecEnd > SAddr)
      llvm_unreachable("Inserting overlapping sections");
    PrevSecEnd = std::max(PrevSecEnd, SAddr + SSize);
  }
}

void MCObjectSymbolizer::buildRelocationByAddrMap(
  MCObjectSymbolizer::SectionInfo &SecInfo) {
  for (const RelocationRef &Reloc : SecInfo.Section.relocations())
    SecInfo.Relocs.push_back(Reloc);
  std::stable_sort(SecInfo.Relocs.begin(), SecInfo.Relocs.end(),
                   RelocRelocOffsetComparator);
}

MCObjectSymbolizer *
llvm::createMCObjectSymbolizer(MCContext &Ctx, const object::ObjectFile &Obj,
                               std::unique_ptr<MCRelocationInfo> &&RelInfo) {
  if (const MachOObjectFile *MOOF = dyn_cast<MachOObjectFile>(&Obj))
    return new MCMachObjectSymbolizer(Ctx, std::move(RelInfo), *MOOF);
  if (const ELFObjectFileBase *OF = dyn_cast<ELFObjectFileBase>(&Obj))
    return new MCELFObjectSymbolizer(Ctx, std::move(RelInfo), *OF);
  return new MCObjectSymbolizer(Ctx, std::move(RelInfo), Obj);
}
