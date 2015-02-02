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
#include "llvm/Support/StringRefMemoryObject.h"
#include "llvm/Support/raw_ostream.h"
#include <map>

using namespace llvm;
using namespace object;

#define DEBUG_TYPE "mccfg"

MCObjectDisassembler::MCObjectDisassembler(const ObjectFile &Obj,
                                           const MCDisassembler &Dis,
                                           const MCInstrAnalysis &MIA)
    : Obj(Obj), Dis(Dis), MIA(MIA), MOS(nullptr), LongestCachedRawBytes(0), Uniqued(0), Translated(0) {}

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
    MCBasicBlock *BB;
    BBInfoSetTy Succs;
    BBInfoSetTy Preds;
    MCObjectDisassembler::AddressSetTy SuccAddrs;

    BBInfo() : BB(nullptr) {}

    void addSucc(BBInfo &Succ) {
      Succs.insert(&Succ);
      Succ.Preds.insert(this);
    }
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
      //MCFunction *MCFN = Module->createFunction("");
      //getBBAt(Module, MCFN, SymAddr, CallTargets, TailCallTargets);
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
      //MCFunction *MCFN = Module->createFunction("");
      //getBBAt(Module, MCFN, CallTarget, NewCallTargets, TailCallTargets);
      createFunction(Module, CallTarget, NewCallTargets, TailCallTargets);
    }
    // Next, forget about those targets, since we just handled them.
    CallTargets.clear();
    RemoveDupsFromAddressVector(NewCallTargets);
    CallTargets = NewCallTargets;
  }
}

bool MCObjectDisassembler::findCachedInstruction(MCInst &Inst,
                                                 uint64_t &InstSize,
                                                 MemoryObject &Region,
                                                 uint64_t Addr) {
  if (Region.getBase() + Region.getExtent() < Addr)
    return false;

  // FIXME
  StringRefMemoryObject *SRRegion = static_cast<StringRefMemoryObject*>(&Region);

  StringRef RawBytes = SRRegion->getByteRange(Addr, LongestCachedRawBytes);
  auto CachedIt =
      std::lower_bound(CachedInsts.begin(), CachedInsts.end(),
                       RawBytes);
  if (CachedIt != CachedInsts.end()) {
    if (RawBytes.startswith(CachedIt->RawBytes)) {
    Inst = CachedIt->Inst;
    InstSize = CachedIt->RawBytes.size();
    return true;
  }
  //    errs() << "  Raw bytes:";
  //    for (auto C : RawBytes) {
  //      errs() << " " << format_hex((uint8_t)C, 2);
  //    }
  //    errs() << " ---- ";
  //    for (auto C : CachedIt->RawBytes) {
  //      errs() << " " << format_hex((uint8_t)C, 2);
  //    }
  //    errs() << "\n";
  //  //errs() << " different?\n";
  }
  return false;
}

void MCObjectDisassembler::addTempInstruction(const MCInst &Inst,
                                              StringRef RawBytes) {
  //if (Inst.getOpcode() == 2231) {
  //  errs() << "Transd " ; Inst.dump(); errs() << "\n";
  //    errs() << "  Raw bytes:";
  //    for (auto C : RawBytes) {
  //      errs() << " " << format_hex((uint8_t)C, 2);
  //    }
  //    errs() << "\n";
  //}
  TempInstKeys.push_back(TempInstKey());
  TempInstKeys.back().RawBytes = RawBytes;
  TempInstKeys.back().ValueIdx = TempInstValues.size();

  TempInstValues.push_back(Inst);

  if (TempInstValues.size() > 5000) {
    uniqueTempInstructions();
  }
}

void MCObjectDisassembler::uniqueTempInstructions() {

  DEBUG(dbgs() << " Trying to unique \n");
  DEBUG(dbgs() << " Uniqued " << Uniqued << " and translated " << Translated
               << " \n");

  for (auto CachedInst : CachedInsts) {
    TempInstKeys.push_back(TempInstKey());
    TempInstKeys.back().RawBytes = CachedInst.RawBytes;
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

  StringRef *LastKeyBytes = nullptr;

  for (size_t KI = 0, KE = TempInstKeys.size(); KI != KE; ++KI) {
    TempInstKey& Key = TempInstKeys[KI];
    if (!LastKeyBytes || !LastKeyBytes->equals(Key.RawBytes)) {
      DuplicateKeys.push_back(TempInstKeyCount());
      DuplicateKeys.back().KeyIdx = KI;
    }
    ++DuplicateKeys.back().Count;
    LastKeyBytes = &Key.RawBytes;
  }

  std::sort(DuplicateKeys.begin(), DuplicateKeys.end());

  //for (auto &KeyCount : DuplicateKeys) {
  //  MCInst &I = TempInstValues[TempInstKeys[KeyCount.KeyIdx].ValueIdx];
  //  errs() << " Found " << KeyCount.Count << " instances of ";
  //  I.dump();
  //  errs() << "\n";
  //}

  // FIXME: we should keep track of cachedinst->tempinst mapping when merging,
  // so that we don't need to copy everything again, but only what changed
  CachedInsts.clear();
  CachedInsts.reserve(2000);
  for (size_t DI = 0, DE = DuplicateKeys.size(); DI != DE && DI < 2000; ++DI) {
    TempInstKeyCount& KeyCount = DuplicateKeys[DI];
    TempInstKey& Key = TempInstKeys[KeyCount.KeyIdx];
    MCInst& Value = TempInstValues[Key.ValueIdx];
    CachedInsts.push_back(CachedInstEntry());
    CachedInsts.back().RawBytes = Key.RawBytes;
    CachedInsts.back().Inst = Value;
    LongestCachedRawBytes = std::max(Key.RawBytes.size(), LongestCachedRawBytes);
    //if (Value.getOpcode() == 2231) {
    //  errs() << "Cached " ; CachedInsts.back().Inst.dump();
    //  errs() << "  Raw bytes:";
    //  for (auto C : CachedInsts.back().RawBytes) {
    //    errs() << " " << format_hex((uint8_t)C, 2);
    //  }
    //  errs() << "\n";
    //}
  }

  // FIXME: insert them already sorted?
  std::sort(CachedInsts.begin(), CachedInsts.end());
  DEBUG(dbgs() << " Cached " << CachedInsts.size() <<  " \n");

  TempInstKeys.clear();
  TempInstValues.clear();
  TempInstKeys.reserve(7000);
  TempInstValues.reserve(7000);
}


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
MCBasicBlock *MCObjectDisassembler::getBBAt(MCModule *Module, MCFunction *MCFN,
                                            uint64_t BBBeginAddr,
                                            AddressSetTy &CallTargets,
                                            AddressSetTy &TailCallTargets) {
  typedef std::map<uint64_t, BBInfo> BBInfoByAddrTy;
  typedef SmallSetVector<uint64_t, 16> AddrWorklistTy;
  BBInfoByAddrTy BBInfos;
  AddrWorklistTy Worklist;

  DEBUG(dbgs() << "Starting CFG at " << utohexstr(BBBeginAddr) << "\n");

  Worklist.insert(BBBeginAddr);
  for (size_t wi = 0; wi < Worklist.size(); ++wi) {
    const uint64_t BeginAddr = Worklist[wi];
    BBInfo *BBI = &BBInfos[BeginAddr];
    bool FailedDisassembly = false;

    MCBasicBlock *&MCBB = BBI->BB;
    assert(!MCBB && "Basic Block already exists!");

    DEBUG(dbgs() << "Looking for block at " << utohexstr(BeginAddr) << "\n");

    // Look for a BB at BeginAddr.
    if (MCBasicBlock *ExistingBB = MCFN->findContaining(BeginAddr)) {
      DEBUG(dbgs() << "Found block at " << utohexstr(BeginAddr) << "!\n");

      // The found BB doesn't begin at BeginAddr, we have to split it.
      if (ExistingBB->getStartAddr() != BeginAddr) {
        DEBUG(dbgs() << "Block at " << utohexstr(ExistingBB->getStartAddr())
              << " needs splitting at " << utohexstr(BeginAddr) << "\n");
        MCBasicBlock *NewBB = ExistingBB->split(BeginAddr);

        // Look for an already encountered basic block that needs splitting
        auto SplitBBIt = BBInfos.find(ExistingBB->getStartAddr());
        if (SplitBBIt != BBInfos.end() && SplitBBIt->second.BB) {
          BBI->SuccAddrs = SplitBBIt->second.SuccAddrs;
          SplitBBIt->second.SuccAddrs.clear();
          SplitBBIt->second.SuccAddrs.push_back(BeginAddr);
        }
        MCBB = NewBB;
      }
    } else {
      // If we didn't find a BB, then we have to disassemble to create one!
      MemoryObject *Region = getRegionFor(BeginAddr);
      if (!Region)
        llvm_unreachable(("Couldn't find suitable region for disassembly at " +
                          utostr(BeginAddr)).c_str());

      uint64_t InstSize;
      uint64_t EndAddr = Region->getBase() + Region->getExtent();

      // We want to stop before the next BB and have a fallthrough to it.
      if (MCBasicBlock *NextBB = MCFN->findFirstAfter(BeginAddr))
        EndAddr = std::min(EndAddr, NextBB->getStartAddr());

      DEBUG(dbgs() << "No block, starting disassembly from "
                   << utohexstr(BeginAddr) << " to "
                   << utohexstr(EndAddr) << "\n");

      MCBB = &MCFN->createBlock(BeginAddr);

      for (uint64_t Addr = BeginAddr; Addr < EndAddr; Addr += InstSize) {
        MCInst Inst;
        if (findCachedInstruction(Inst, InstSize, *Region, Addr)) {
          MCBB->addInst(Inst, InstSize);
          ++Uniqued;
        }  else
        if (Dis.getInstruction(Inst, InstSize, *Region, Addr, nulls(),
                               nulls())) {
          ++Translated;
          MCBB->addInst(Inst, InstSize);

          StringRefMemoryObject *SRRegion =
              static_cast<StringRefMemoryObject *>(Region);
          addTempInstruction(Inst, SRRegion->getByteRange(Addr, InstSize));
        } else {
          DEBUG(dbgs() << "Failed disassembly at "
                << utohexstr(Addr) << "!\n");
          // We don't care about splitting mixed atoms either.
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
          break;
        }
      }
    }

    MemoryObject *Region = getRegionFor(MCBB->getStartAddr());
    assert(Region && "Couldn't find region for already disassembled code!");
    uint64_t EndRegion = Region->getBase() + Region->getExtent();

    if (!FailedDisassembly) {
      // Now we have a basic block, add successors.
      // Add the fallthrough block.
      if ((MIA.isConditionalBranch(MCBB->back().Inst) ||
           !MIA.isTerminator(MCBB->back().Inst)) &&
          (MCBB->getStartAddr() + MCBB->getSize() < EndRegion)) {
        BBI->SuccAddrs.push_back(MCBB->getStartAddr() + MCBB->getSize());
        Worklist.insert(MCBB->getStartAddr() + MCBB->getSize());
      }

      // If the terminator is a branch, add the target block.
      if (MIA.isBranch(MCBB->back().Inst)) {
        uint64_t BranchTarget;
        if (MIA.evaluateBranch(MCBB->back().Inst, MCBB->back().Address,
                               MCBB->back().Size, BranchTarget)) {
          StringRef ExtFnName;
          if (MOS)
            ExtFnName =
              MOS->findExternalFunctionAt(getOriginalLoadAddr(BranchTarget));
          if (!ExtFnName.empty()) {
            TailCallTargets.push_back(BranchTarget);
            CallTargets.push_back(BranchTarget);
          } else {
            BBI->SuccAddrs.push_back(BranchTarget);
            Worklist.insert(BranchTarget);
          }
        }
      }
    }
  }

  for (size_t wi = 0, we = Worklist.size(); wi != we; ++wi) {
    const uint64_t BeginAddr = Worklist[wi];
    BBInfo *BBI = &BBInfos[BeginAddr];
    MCBasicBlock *BB = BBI->BB;

    RemoveDupsFromAddressVector(BBI->SuccAddrs);
    for (uint64_t Address : BBI->SuccAddrs) {
      MCBasicBlock *Succ = BBInfos[Address].BB;
      BB->addSuccessor(Succ);
      Succ->addPredecessor(BB);
    }
  }

  assert(BBInfos[Worklist[0]].BB &&
         "No basic block created at requested address?");

  return BBInfos[Worklist[0]].BB;
}

MCFunction *
MCObjectDisassembler::createFunction(MCModule *Module, uint64_t BeginAddr,
                                     AddressSetTy &CallTargets,
                                     AddressSetTy &TailCallTargets) {
  // First, check if this is an external function.
  StringRef ExtFnName;
  if (MOS)
    ExtFnName = MOS->findExternalFunctionAt(getOriginalLoadAddr(BeginAddr));
  if (!ExtFnName.empty())
    return Module->createFunction(ExtFnName);

  // If it's not, look for an existing function.
  if (MCFunction *Fn = Module->findFunctionAt(BeginAddr))
    return Fn;

  // Finally, just create a new one.
  MCFunction *MCFN = Module->createFunction("");
  getBBAt(Module, MCFN, BeginAddr, CallTargets, TailCallTargets);
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
