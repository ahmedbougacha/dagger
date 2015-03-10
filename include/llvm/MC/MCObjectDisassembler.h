//===-- llvm/MC/MCObjectDisassembler.h --------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declaration of the MCObjectDisassembler class, which
// can be used to construct an MCModule and an MC CFG from an ObjectFile.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MC_MCOBJECTDISASSEMBLER_H
#define LLVM_MC_MCOBJECTDISASSEMBLER_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/DataTypes.h"
#include "llvm/MC/MCInst.h"
#include <vector>

namespace llvm {

namespace object {
  class ObjectFile;
  class MachOObjectFile;
}

class MCBasicBlock;
class MCDisassembler;
class MCFunction;
class MCInstrAnalysis;
class MCInst;
class MCModule;
class MCObjectSymbolizer;

/// \brief Disassemble an ObjectFile to an MCModule and MCFunctions.
/// This class builds on MCDisassembler to create a control flow graph
/// consisting of MCFunctions and MCBasicBlocks.
class MCObjectDisassembler {
public:
  MCObjectDisassembler(const object::ObjectFile &Obj,
                       const MCDisassembler &Dis,
                       const MCInstrAnalysis &MIA);
  virtual ~MCObjectDisassembler() {}

  /// \brief Build an MCModule, representing an MC-level Control Flow Graph.
  /// MCFunctions are created, containing MCBasicBlocks.
  MCModule *buildModule();

  MCModule *buildEmptyModule();

  typedef std::vector<uint64_t> AddressSetTy;
  /// \name Create a new MCFunction.
  MCFunction *createFunction(MCModule *Module, uint64_t BeginAddr,
                             AddressSetTy &CallTargets,
                             AddressSetTy &TailCallTargets);

  /// \brief Set the region on which to fallback if disassembly was requested
  /// somewhere not accessible in the object file.
  /// This is used for dynamic disassembly.
  void setFallbackRegion(uint64_t BeginAddr, ArrayRef<uint8_t> Region) {
    FallbackRegion = { BeginAddr, Region };
  }

  /// \brief Set the symbolizer to use to get information on external functions.
  /// Note that this isn't used to do instruction-level symbolization (that is,
  /// plugged into MCDisassembler), but to symbolize function call targets.
  void setSymbolizer(MCObjectSymbolizer *ObjectSymbolizer) {
    MOS = ObjectSymbolizer;
  }

protected:
  const object::ObjectFile &Obj;
  const MCDisassembler &Dis;
  const MCInstrAnalysis &MIA;
  MCObjectSymbolizer *MOS;

  struct MemoryRegion {
    uint64_t Addr;
    ArrayRef<uint8_t> Bytes;
    MemoryRegion(uint64_t Addr = 0,
                 ArrayRef<uint8_t> Bytes = ArrayRef<uint8_t>())
        : Addr(Addr), Bytes(Bytes) {}
  };

  /// \brief The fallback memory region, outside the object file.
  MemoryRegion FallbackRegion;

  std::vector<MemoryRegion> SectionRegions;

  /// \brief Return a memory region suitable for reading starting at \p Addr.
  /// In most cases, this returns an ArrayRef backed by the
  /// containing section. When no section was found, this returns the
  /// FallbackRegion, if it is suitable.
  /// If it is not, or if there is no fallback region, this an empty region.
  const MemoryRegion &getRegionFor(uint64_t Addr);

private:
  /// \brief Enrich \p Module with a CFG consisting of MCFunctions.
  /// \param Module An MCModule returned by buildModule, with no CFG.
  /// NOTE: Each MCBasicBlock in a MCFunction is backed by a single MCTextAtom.
  /// When the CFG is built, contiguous instructions that were previously in a
  /// single MCTextAtom will be split in multiple basic block atoms.
  void buildCFG(MCModule *Module);

  void disassembleFunctionAt(MCModule *Module, MCFunction *MCFN,
                             uint64_t BeginAddr, AddressSetTy &CallTargets,
                             AddressSetTy &TailCallTargets);
};

}

#endif
