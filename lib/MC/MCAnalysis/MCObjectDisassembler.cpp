//===- lib/MC/MCObjectDisassembler.cpp ------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/Format.h"

#include "llvm/MC/MCObjectDisassembler.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/MC/MCAnalysis/MCObjectSymbolizer.h"
#include "llvm/MC/MCDisassembler.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/Object/MachO.h"
#include "llvm/Object/ObjectFile.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MachO.h"
#include "llvm/Support/MemoryObject.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/StringRefMemoryObject.h"
#include "llvm/Support/raw_ostream.h"
#include <map>

using namespace llvm;
using namespace object;

#define DEBUG_TYPE "mccfg"

MCObjectDisassembler::MCObjectDisassembler(const ObjectFile &Obj,
                                           const MCDisassembler &Dis,
                                           const MCInstrAnalysis &MIA)
    : Obj(Obj), Dis(Dis), MIA(MIA), MOS(nullptr) {}

uint64_t MCObjectDisassembler::getEntrypoint() {
  for (const SymbolRef &Symbol : Obj.symbols()) {
    StringRef Name;
    Symbol.getName(Name);
    if (Name == "main" || Name == "_main") {
      uint64_t Entrypoint;
      Symbol.getAddress(Entrypoint);
      return getEffectiveLoadAddr(Entrypoint);
    }
  }
  return 0;
}

ArrayRef<uint64_t> MCObjectDisassembler::getStaticInitFunctions() {
  return None;
}

ArrayRef<uint64_t> MCObjectDisassembler::getStaticExitFunctions() {
  return None;
}

static bool SectionRegionComparator(const std::unique_ptr<MemoryObject> &L,
                                    const std::unique_ptr<MemoryObject> &R) {
  return L->getBase() < R->getBase();
}

static bool SectionRegionAddrComparator(const std::unique_ptr<MemoryObject> &L,
                                        uint64_t Addr) {
  return L->getBase() + L->getExtent() <= Addr;
}

MemoryObject *MCObjectDisassembler::getRegionFor(uint64_t Addr) {
  auto Region = std::lower_bound(SectionRegions.begin(), SectionRegions.end(),
                                 Addr, SectionRegionAddrComparator);
  if (Region != SectionRegions.end())
    if ((*Region)->getBase() <= Addr)
      return Region->get();
  return FallbackRegion.get();
}

uint64_t MCObjectDisassembler::getEffectiveLoadAddr(uint64_t Addr) {
  return Addr;
}

uint64_t MCObjectDisassembler::getOriginalLoadAddr(uint64_t Addr) {
  return Addr;
}

MCModule *MCObjectDisassembler::buildEmptyModule() {
  MCModule *Module = new MCModule;
  Module->Entrypoint = getEntrypoint();
  return Module;
}

MCModule *MCObjectDisassembler::buildModule() {
  MCModule *Module = buildEmptyModule();

  if (SectionRegions.empty()) {
    for (const SectionRef &Section : Obj.sections()) {
      bool isText = Section.isText();
      uint64_t StartAddr = Section.getAddress();
      uint64_t SecSize = Section.getSize();

      // FIXME
      if (StartAddr == UnknownAddressOrSize || SecSize == UnknownAddressOrSize)
        continue;
      StartAddr = getEffectiveLoadAddr(StartAddr);
      if (!isText)
        continue;

      StringRef Contents;
      if (Section.getContents(Contents))
        continue;
      SectionRegions.push_back(std::unique_ptr<MemoryObject>(
          new StringRefMemoryObject(Contents, StartAddr)));
    }
    std::sort(SectionRegions.begin(), SectionRegions.end(),
              SectionRegionComparator);
  }

  buildCFG(Module);
  return Module;
}

namespace {
  struct BBInfo;
  typedef SmallPtrSet<BBInfo*, 2> BBInfoSetTy;

  struct BBInfo {
    uint64_t BeginAddr;
    uint64_t SizeInBytes;
    MCBasicBlock *BB;
    std::vector<MCDecodedInst> Insts;
    MCObjectDisassembler::AddressSetTy SuccAddrs;

    BBInfo() : BeginAddr(0), SizeInBytes(0), BB(nullptr) {}
  };
}

static void RemoveDupsFromAddressVector(MCObjectDisassembler::AddressSetTy &V) {
  std::sort(V.begin(), V.end());
  V.erase(std::unique(V.begin(), V.end()), V.end());
}

void MCObjectDisassembler::buildCFG(MCModule *Module) {
  AddressSetTy CallTargets;
  AddressSetTy TailCallTargets;

  for (const SymbolRef &Symbol : Obj.symbols()) {
    SymbolRef::Type SymType;
    uint64_t SymAddr;
    std::error_code ec;
    if (Symbol.getType(SymType))
      continue;
    if (SymType == SymbolRef::ST_Function) {
      if (Symbol.getAddress(SymAddr))
        continue;
      SymAddr = getEffectiveLoadAddr(SymAddr);
      if (!getRegionFor(SymAddr))
        continue;
      createFunction(Module, SymAddr, CallTargets, TailCallTargets);
    }
  }

  RemoveDupsFromAddressVector(CallTargets);
  RemoveDupsFromAddressVector(TailCallTargets);

  AddressSetTy NewCallTargets;

  while (!NewCallTargets.empty()) {
    // First, create functions for all the previously found targets
    for (uint64_t CallTarget : CallTargets) {
      CallTarget = getEffectiveLoadAddr(CallTarget);
      createFunction(Module, CallTarget, NewCallTargets, TailCallTargets);
    }
    // Next, forget about those targets, since we just handled them.
    CallTargets.clear();
    RemoveDupsFromAddressVector(NewCallTargets);
    CallTargets = NewCallTargets;
  }
}

namespace {
  class AddrPrettyStackTraceEntry : public PrettyStackTraceEntry {
  public:
    uint64_t StartAddr;
    const char *Kind;
    AddrPrettyStackTraceEntry(uint64_t StartAddr, const char *Kind)
      : PrettyStackTraceEntry(), StartAddr(StartAddr), Kind(Kind) {}

    void print(raw_ostream &OS) const override {
      OS << "MC CFG: Disassembling " << Kind << " at address "
         << utohexstr(StartAddr) << "\n";
    }
  };
} // end anonymous namespace

// Basic idea of the disassembly + discovery:
//
// start with the wanted address, insert it in the worklist
// while worklist not empty, take next address in the worklist:
// - check if atom exists there
//   - if middle of atom:
//     - split basic blocks referencing the atom
//     - look for an already encountered BBInfo (using a map<atom, bbinfo>)
//       - if there is, split it (new one, fallthrough, move succs, etc..)
//   - if start of atom: nothing else to do
//   - if no atom: create new atom and new bbinfo
// - look at the last instruction in the atom, add succs to worklist
// for all elements in the worklist:
// - create basic block, update preds/succs, etc..
//
void MCObjectDisassembler::disassembleFunctionAt(
    MCModule *Module, MCFunction *MCFN, uint64_t BBBeginAddr,
    AddressSetTy &CallTargets, AddressSetTy &TailCallTargets) {
  std::map<uint64_t, BBInfo> BBInfos;

  typedef SmallSetVector<uint64_t, 16> AddrWorklistTy;

  AddrWorklistTy Worklist;

  DEBUG(dbgs() << "Starting CFG at " << utohexstr(BBBeginAddr) << "\n");

  Worklist.insert(BBBeginAddr);
  for (size_t wi = 0; wi < Worklist.size(); ++wi) {
    const uint64_t BeginAddr = Worklist[wi];

    bool FailedDisassembly = false;
    AddrPrettyStackTraceEntry X(BeginAddr, "Basic Block");

    DEBUG(dbgs() << "Looking for block at " << utohexstr(BeginAddr) << "\n");

    // Look for a BB at BeginAddr.
    auto BeforeIt = std::upper_bound(
        BBInfos.begin(), BBInfos.end(), BeginAddr,
        [](uint64_t Addr, const std::pair<uint64_t, BBInfo> &BBI) {
          return Addr < BBI.second.BeginAddr+BBI.second.SizeInBytes;
        });

    assert((BeforeIt == BBInfos.end() || BeforeIt->first != BeginAddr) &&
           "Visited same basic block twice!");

    // Found a BB containing BeginAddr, we have to split it.
    if (BeforeIt != BBInfos.end() && BeforeIt->first < BeginAddr) {

      BBInfo &BeforeBB = BeforeIt->second;
      DEBUG(dbgs() << "Found block at " << utohexstr(BeforeBB.BeginAddr)
                   << ", needs splitting at " << utohexstr(BeginAddr) << "\n");

      assert(BeginAddr < BeforeBB.BeginAddr + BeforeBB.SizeInBytes &&
             "Address isn't inside block?");

      BBInfo &NewBB = BBInfos[BeginAddr];
      NewBB.BeginAddr = BeginAddr;

      auto SplitInst = BeforeBB.Insts.end();
      for (auto I = BeforeBB.Insts.begin(), E = BeforeBB.Insts.end(); I != E;
           ++I) {
        if (BeginAddr == I->Address) {
          SplitInst = I;
          break;
        }
      }

      assert(SplitInst != BeforeBB.Insts.end() &&
             "Split point does not fall on an instruction boundary!");

      // FIXME: use a list instead for free splicing?

      // Splice the remaining instructions to the new block.
      // While SplitInst is still valid, decrease the size to match.
      const uint64_t SplitOffset = SplitInst->Address - BeforeBB.BeginAddr;
      NewBB.SizeInBytes = BeforeBB.SizeInBytes - SplitOffset;
      BeforeBB.SizeInBytes = SplitOffset;

      // Now do the actual splicing out of BeforeBB.
      NewBB.Insts.insert(NewBB.Insts.begin(), SplitInst, BeforeBB.Insts.end());
      BeforeBB.Insts.erase(SplitInst, BeforeBB.Insts.end());

      // Move the successors to the new block.
      std::swap(NewBB.SuccAddrs, BeforeBB.SuccAddrs);

      BeforeBB.SuccAddrs.push_back(BeginAddr);
    } else {
      // If we didn't find a BB, then we have to disassemble to create one!
      MemoryObject *Region = getRegionFor(BeginAddr);
      if (!Region)
        report_fatal_error(("No suitable region for disassembly at " +
                            utostr(BeginAddr)).c_str());
      const uint64_t EndRegion = Region->getBase() + Region->getExtent();

      uint64_t EndAddr = EndRegion;

      // We want to stop before the next BB and have a fallthrough to it.
      if (BeforeIt != BBInfos.end())
        EndAddr = std::min(EndAddr, BeforeIt->first);

      BBInfo &BBI = BBInfos[BeginAddr];
      BBI.BeginAddr = BeginAddr;

      auto &BBInsts = BBI.Insts;
      assert(BBInsts.empty() && "Basic Block already exists!");

      DEBUG(dbgs() << "No existing block found, starting disassembly from "
                   << utohexstr(BeginAddr) << " to "
                   << utohexstr(EndAddr) << "\n");

      auto AddInst = [&](MCInst &I, uint64_t Addr, uint64_t Size) {
        const uint64_t NextAddr = BBI.BeginAddr + BBI.SizeInBytes;
        assert(NextAddr == Addr);
        BBI.Insts.emplace_back(I, NextAddr, Size);
        BBI.SizeInBytes += Size;
      };

      uint64_t InstSize;

      for (uint64_t Addr = BeginAddr; Addr < EndAddr; Addr += InstSize) {
        MCInst Inst;
        if (Dis.getInstruction(Inst, InstSize, *Region, Addr, nulls(),
                               nulls())) {
          AddInst(Inst, Addr, InstSize);
        } else {
          DEBUG(dbgs() << "Failed disassembly at " << utohexstr(Addr) << "!\n");
          FailedDisassembly = true;
          break;
        }

        uint64_t BranchTarget;
        if (MIA.evaluateBranch(Inst, Addr, InstSize, BranchTarget)) {
          DEBUG(dbgs() << "Found branch to " << utohexstr(BranchTarget)
                       << "!\n");
          if (MIA.isCall(Inst)) {
            DEBUG(dbgs() << "Found call!\n");
            CallTargets.push_back(BranchTarget);
          }
        }

        if (MIA.isTerminator(Inst)) {
          DEBUG(dbgs() << "Found terminator!\n");
          // Now we have a complete basic block, add successors.

          // Add the fallthrough block, and mark it for visiting.
          if (MIA.isConditionalBranch(Inst)) {
            BBI.SuccAddrs.push_back(Addr + InstSize);
            Worklist.insert(Addr + InstSize);
          }

          // If the terminator is a branch, add the target block.
          if (MIA.isBranch(Inst)) {
            uint64_t BranchTarget;
            if (MIA.evaluateBranch(Inst, Addr, InstSize, BranchTarget)) {
              StringRef ExtFnName;
              if (MOS &&
                  !(ExtFnName = MOS->findExternalFunctionAt(
                        getOriginalLoadAddr(BranchTarget))).empty()) {
                TailCallTargets.push_back(BranchTarget);
                CallTargets.push_back(BranchTarget);
              } else {
                BBI.SuccAddrs.push_back(BranchTarget);
                Worklist.insert(BranchTarget);
              }
            }
          }
          break;
        }
      }
    }
  }

  // First, create all blocks.
  for (size_t wi = 0, we = Worklist.size(); wi != we; ++wi) {
    const uint64_t BeginAddr = Worklist[wi];
    BBInfo *BBI = &BBInfos[BeginAddr];
    MCBasicBlock *&MCBB = BBI->BB;

    MCBB = &MCFN->createBlock(BeginAddr);

    std::swap(MCBB->Insts, BBI->Insts);
    MCBB->InstCount = MCBB->Insts.size();
    MCBB->SizeInBytes = BBI->SizeInBytes;
  }

  // Next, add all predecessors/successors.
  for (size_t wi = 0, we = Worklist.size(); wi != we; ++wi) {
    const uint64_t BeginAddr = Worklist[wi];
    BBInfo *BBI = &BBInfos[BeginAddr];
    MCBasicBlock *&MCBB = BBI->BB;
    RemoveDupsFromAddressVector(BBI->SuccAddrs);
    for (uint64_t Address : BBI->SuccAddrs) {
      MCBasicBlock *Succ = BBInfos[Address].BB;
      assert(Succ && "Couldn't find block successor?!");
      // FIXME: Sort the succs/preds at the end?
      MCBB->Successors.push_back(Succ);
      Succ->Predecessors.push_back(MCBB);
    }
  }
}

MCFunction *
MCObjectDisassembler::createFunction(MCModule *Module, uint64_t BeginAddr,
                                     AddressSetTy &CallTargets,
                                     AddressSetTy &TailCallTargets) {
  AddrPrettyStackTraceEntry X(BeginAddr, "Function");

  // First, check if this is an external function.
  StringRef ExtFnName;
  if (MOS)
    ExtFnName = MOS->findExternalFunctionAt(getOriginalLoadAddr(BeginAddr));
  if (!ExtFnName.empty())
    return Module->createFunction(ExtFnName, BeginAddr);

  // If it's not, look for an existing function.
  if (MCFunction *Fn = Module->findFunctionAt(BeginAddr))
    return Fn;

  // Finally, just create a new one.
  MCFunction *MCFN =
      Module->createFunction(("fn_" + utohexstr(BeginAddr)).c_str(), BeginAddr);
  disassembleFunctionAt(Module, MCFN, BeginAddr, CallTargets, TailCallTargets);
  return MCFN;
}

// MachO MCObjectDisassembler implementation.

MCMachOObjectDisassembler::MCMachOObjectDisassembler(
    const MachOObjectFile &MOOF, const MCDisassembler &Dis,
    const MCInstrAnalysis &MIA, uint64_t VMAddrSlide,
    uint64_t HeaderLoadAddress)
    : MCObjectDisassembler(MOOF, Dis, MIA), MOOF(MOOF),
      VMAddrSlide(VMAddrSlide), HeaderLoadAddress(HeaderLoadAddress) {

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
}

// FIXME: Only do the translations for addresses actually inside the object.
uint64_t MCMachOObjectDisassembler::getEffectiveLoadAddr(uint64_t Addr) {
  return Addr + VMAddrSlide;
}

uint64_t
MCMachOObjectDisassembler::getOriginalLoadAddr(uint64_t EffectiveAddr) {
  return EffectiveAddr - VMAddrSlide;
}

uint64_t MCMachOObjectDisassembler::getEntrypoint() {
  uint64_t EntryFileOffset = 0;

  // Look for LC_MAIN.
  {
    uint32_t LoadCommandCount = MOOF.getHeader().ncmds;
    MachOObjectFile::LoadCommandInfo Load = MOOF.getFirstLoadCommandInfo();
    for (unsigned I = 0;; ++I) {
      if (Load.C.cmd == MachO::LC_MAIN) {
        EntryFileOffset =
            ((const MachO::entry_point_command *)Load.Ptr)->entryoff;
        break;
      }

      if (I == LoadCommandCount - 1)
        break;
      else
        Load = MOOF.getNextLoadCommandInfo(Load);
    }
  }

  // If we didn't find anything, default to the common implementation.
  // FIXME: Maybe we could also look at LC_UNIXTHREAD and friends?
  if (EntryFileOffset)
    return MCObjectDisassembler::getEntrypoint();

  return EntryFileOffset + HeaderLoadAddress;
}

ArrayRef<uint64_t> MCMachOObjectDisassembler::getStaticInitFunctions() {
  // FIXME: We only handle 64bit mach-o
  assert(MOOF.is64Bit());

  size_t EntrySize = 8;
  size_t EntryCount = ModInitContents.size() / EntrySize;
  return makeArrayRef(
      reinterpret_cast<const uint64_t *>(ModInitContents.data()), EntryCount);
}

ArrayRef<uint64_t> MCMachOObjectDisassembler::getStaticExitFunctions() {
  // FIXME: We only handle 64bit mach-o
  assert(MOOF.is64Bit());

  size_t EntrySize = 8;
  size_t EntryCount = ModExitContents.size() / EntrySize;
  return makeArrayRef(
      reinterpret_cast<const uint64_t *>(ModExitContents.data()), EntryCount);
}
