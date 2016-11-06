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

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/MC/MCDisassembler/MCSymbolizer.h"
#include "llvm/Object/ObjectFile.h"
#include <vector>

namespace llvm {

namespace object{
class ELFObjectFileBase;
}

class MCExpr;
class MCInst;
class MCRelocationInfo;
class MCSymbol;
class raw_ostream;

/// \brief An ObjectFile-backed symbolizer.
class MCObjectSymbolizer : public MCSymbolizer {
protected:
  const object::ObjectFile &Obj;

  // Map a load address to the first relocation that applies there. As far as I
  // know, if there are several relocations at the exact same address, they are
  // related and the others can be determined from the first that was found in
  // the relocation table. For instance, on x86-64 mach-o, a SUBTRACTOR
  // relocation (referencing the minuend symbol) is followed by an UNSIGNED
  // relocation (referencing the subtrahend symbol).
  const object::RelocationRef *findRelocationAt(uint64_t Addr) const;
  const object::SectionRef *findSectionContaining(uint64_t Addr) const;

public:
  MCObjectSymbolizer(
      MCContext &Ctx, std::unique_ptr<MCRelocationInfo> RelInfo,
      const object::ObjectFile &Obj,
      std::function<bool(object::SectionRef)> ShouldSkipSection = {});

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

  // FIXME: Why aren't these const? Get rid of the usage-initialized ivars.
  /// \brief Return whether \p Addr is part of this objects load memory.
  virtual bool isInObject(uint64_t Addr);

  /// \brief Look for an external function symbol at \p Addr.
  /// (References through the ELF PLT, Mach-O stubs, and similar).
  /// \returns The function's name, or the empty string if not found.
  virtual StringRef findExternalFunctionAt(uint64_t Addr);

  /// \brief Get the effective address of the entrypoint, or 0 if there is none.
  virtual uint64_t getEntrypoint();

  /// \name Translation between effective and objectfile load address.
  /// @{
  /// \brief Compute the effective load address, from an objectfile virtual
  /// address. This is implemented in a format-specific way, to take into
  /// account things like PIE/ASLR when doing dynamic disassembly.
  /// For example, on Mach-O this would be done by adding the VM addr slide,
  /// on glibc ELF by keeping a map between segment load addresses, filled
  /// using dl_iterate_phdr, etc..
  /// In most static situations and in the default impl., this returns \p Addr.
  virtual uint64_t getEffectiveLoadAddr(uint64_t Addr);

  /// \brief Compute the original load address, as specified in the objectfile.
  /// This is the inverse of getEffectiveLoadAddr.
  virtual uint64_t getOriginalLoadAddr(uint64_t EffectiveAddr);
  /// @}

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
    bool operator<(const SectionInfo &RHS) const {
      return Section.getAddress() < RHS.Section.getAddress();
    }
  };


  // FIXME: Just keep the uint64_t ?
  std::vector<std::pair<object::SymbolRef, uint64_t>> SymbolSizes;
  std::vector<SectionInfo> SortedSections;
  std::vector<FunctionSymbol> AddrToFunctionSymbol;

  void buildAddrToFunctionSymbolMap();
  void
  buildSectionList(std::function<bool(object::SectionRef)> ShouldSkipSection);
  void buildRelocationByAddrMap(SectionInfo &SecInfo);
  MCSymbol *findContainingFunction(uint64_t Addr, uint64_t &Offset);

  const SectionInfo *findSectionInfoContaining(uint64_t Addr) const;
  SectionInfo *findSectionInfoContaining(uint64_t Addr);
};

class MCMachObjectSymbolizer final : public MCObjectSymbolizer {
  const object::MachOObjectFile &MOOF;
  // __TEXT;__stubs support.
  uint64_t StubsStart;
  uint64_t StubsCount;
  uint64_t StubSize;
  uint64_t StubsIndSymIndex;

  uint64_t VMAddrSlide;

  // __DATA;__mod_init_func support.
  llvm::StringRef ModInitContents;
  // __DATA;__mod_exit_func support.
  llvm::StringRef ModExitContents;

public:
  /// \brief Construct a Mach-O specific object symbolizer.
  /// \param VMAddrSlide The virtual address slide applied by dyld.
  MCMachObjectSymbolizer(MCContext &Ctx,
                         std::unique_ptr<MCRelocationInfo> RelInfo,
                         const object::MachOObjectFile &MOOF,
                         uint64_t VMAddrSlide = 0);

  StringRef findExternalFunctionAt(uint64_t Addr) override;

  uint64_t getEntrypoint() override;

  void tryAddingPcLoadReferenceComment(raw_ostream &cStream, int64_t Value,
                                       uint64_t Address) override;

  uint64_t getEffectiveLoadAddr(uint64_t Addr) override;
  uint64_t getOriginalLoadAddr(uint64_t EffectiveAddr) override;

  /// \name Get the addresses of static constructors/destructors in the object.
  /// The caller is expected to know how to interpret the addresses;
  /// On Mach-O, init functions expect 5 arguments.
  /// The addresses are original object file load addresses, not effective.
  /// @{
  ArrayRef<uint64_t> getStaticInitFunctions();
  ArrayRef<uint64_t> getStaticExitFunctions();
  /// @}
};

class MCELFObjectSymbolizer final : public MCObjectSymbolizer {
  const object::ELFObjectFileBase &OF;

public:
  /// \brief Construct a Mach-O specific object symbolizer.
  /// \param VMAddrSlide The virtual address slide applied by dyld.
  MCELFObjectSymbolizer(MCContext &Ctx,
                        std::unique_ptr<MCRelocationInfo> RelInfo,
                        const object::ELFObjectFileBase &OF);

  uint64_t getEntrypoint() override;
};

}

#endif
