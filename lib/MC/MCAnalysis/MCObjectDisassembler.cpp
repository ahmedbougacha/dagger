//===- lib/MC/MCObjectDisassembler.cpp ------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/MC/MCObjectDisassembler.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/MC/MCAnalysis/MCAtom.h"
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

#define DEBUG_TYPE "mc"

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

static bool SectionRegionComparator(std::unique_ptr<MemoryObject> &L,
                                    std::unique_ptr<MemoryObject> &R) {
  return L->getBase() < R->getBase();
}

static bool SectionRegionAddrComparator(std::unique_ptr<MemoryObject> &L,
                                    uint64_t Addr) {
  return L->getBase() + L->getExtent() <= Addr;
}

MemoryObject *MCObjectDisassembler::getRegionFor(uint64_t Addr) {
  // FIXME: Keep track of object sections.
  auto Region = std::lower_bound(SectionRegions.begin(), SectionRegions.end(),
                                 Addr, SectionRegionAddrComparator);
  if (Region != SectionRegions.end())
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

MCModule *MCObjectDisassembler::buildModule(bool withCFG) {
  MCModule *Module = buildEmptyModule();

  buildSectionAtoms(Module);
  if (SectionRegions.empty()) {
    for (const SectionRef &Section : Obj.sections()) {
    bool isText = Section.isText();
    bool isData = Section.isData();
      uint64_t StartAddr = Section.getAddress();
      uint64_t SecSize = Section.getSize();

      // FIXME
      if (StartAddr == UnknownAddressOrSize || SecSize == UnknownAddressOrSize)
        continue;
      StartAddr = getEffectiveLoadAddr(StartAddr);
    StringRef Name; Section.getName(Name);
      errs() << "found section " << Name << " starting at " << StartAddr << " and size " << SecSize << "\n";
    if (!isText)
      continue;

      StringRef Contents;
      Section.getContents(Contents);
      SectionRegions.push_back(std::unique_ptr<MemoryObject>(new StringRefMemoryObject(Contents, StartAddr)));
    }
    std::sort(SectionRegions.begin(), SectionRegions.end(),
              SectionRegionComparator);
  }

  if (withCFG)
    buildCFG(Module);
  return Module;
}

void MCObjectDisassembler::buildSectionAtoms(MCModule *Module) {
  for (const SectionRef &Section : Obj.sections()) {
    bool isText = Section.isText();
    bool isData = Section.isData();
    if (!isData && !isText)
      continue;

    uint64_t StartAddr = Section.getAddress();
    uint64_t SecSize = Section.getSize();
    if (StartAddr == UnknownAddressOrSize || SecSize == UnknownAddressOrSize)
      continue;
    StartAddr = getEffectiveLoadAddr(StartAddr);

    StringRef Contents;
    Section.getContents(Contents);
    StringRefMemoryObject memoryObject(Contents, StartAddr);

    // We don't care about things like non-file-backed sections yet.
    if (Contents.size() != SecSize || !SecSize)
      continue;
    uint64_t EndAddr = StartAddr + SecSize - 1;

    StringRef SecName;
    Section.getName(SecName);

    if (isText) {
      MCTextAtom *Text = nullptr;
      MCDataAtom *InvalidData = nullptr;

      uint64_t InstSize;
      for (uint64_t Index = 0; Index < SecSize; Index += InstSize) {
        const uint64_t CurAddr = StartAddr + Index;
        MCInst Inst;
        if (Dis.getInstruction(Inst, InstSize, memoryObject, CurAddr, nulls(),
                               nulls())) {
          if (!Text) {
            Text = Module->createTextAtom(CurAddr, CurAddr);
            Text->setName(SecName);
          }
          Text->addInst(Inst, InstSize);
          InvalidData = nullptr;
        } else {
          assert(InstSize && "getInstruction() consumed no bytes");
          if (!InvalidData) {
            Text = nullptr;
            InvalidData = Module->createDataAtom(CurAddr, CurAddr+InstSize - 1);
          }
          for (uint64_t I = 0; I < InstSize; ++I)
            InvalidData->addData(Contents[Index+I]);
        }
      }
    } else {
      MCDataAtom *Data = Module->createDataAtom(StartAddr, EndAddr);
      Data->setName(SecName);
      for (uint64_t Index = 0; Index < SecSize; ++Index)
        Data->addData(Contents[Index]);
    }
  }
}

namespace {
  struct BBInfo;
  typedef SmallPtrSet<BBInfo*, 2> BBInfoSetTy;

  struct BBInfo {
    MCTextAtom *Atom;
    MCBasicBlock *BB;
    BBInfoSetTy Succs;
    BBInfoSetTy Preds;
    MCObjectDisassembler::AddressSetTy SuccAddrs;

    BBInfo() : Atom(nullptr), BB(nullptr) {}

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
  typedef std::map<uint64_t, BBInfo> BBInfoByAddrTy;
  BBInfoByAddrTy BBInfos;
  AddressSetTy Splits;
  AddressSetTy Calls;

  for (const SymbolRef &Symbol : Obj.symbols()) {
    SymbolRef::Type SymType;
    Symbol.getType(SymType);
    if (SymType == SymbolRef::ST_Function) {
      uint64_t SymAddr;
      Symbol.getAddress(SymAddr);
      SymAddr = getEffectiveLoadAddr(SymAddr);
      Calls.push_back(SymAddr);
      Splits.push_back(SymAddr);
    }
  }

  assert(Module->func_begin() == Module->func_end()
         && "Module already has a CFG!");

  // First, determine the basic block boundaries and call targets.
  for (MCAtom *Atom : Module->atoms()) {
    MCTextAtom *TA = dyn_cast<MCTextAtom>(Atom);
    if (!TA) continue;
    Calls.push_back(TA->getBeginAddr());
    BBInfos[TA->getBeginAddr()].Atom = TA;
    for (auto DecodedInst : *TA) {
      if (MIA.isTerminator(DecodedInst.Inst))
        Splits.push_back(DecodedInst.Address + DecodedInst.Size);
      uint64_t Target;
      if (MIA.evaluateBranch(DecodedInst.Inst, DecodedInst.Address,
                             DecodedInst.Size, Target)) {
        if (MIA.isCall(DecodedInst.Inst))
          Calls.push_back(Target);
        Splits.push_back(Target);
      }
    }
  }

  RemoveDupsFromAddressVector(Splits);
  RemoveDupsFromAddressVector(Calls);

  // Split text atoms into basic block atoms.
  for (uint64_t Address : Splits) {
    MCAtom *A = Module->findAtomContaining(Address);
    if (!A)
      continue;
    MCTextAtom *TA = dyn_cast<MCTextAtom>(A);
    // FIXME: when do we get data atoms here?
    if (!TA)
      continue;
    if (TA->getBeginAddr() == Address)
      continue;
    MCTextAtom *NewAtom = TA->split(Address);
    BBInfos[NewAtom->getBeginAddr()].Atom = NewAtom;
    StringRef BBName = TA->getName();
    BBName = BBName.substr(0, BBName.find_last_of(':'));
    NewAtom->setName((BBName + ":" + utohexstr(Address)).str());
  }

  // Compute succs/preds.
  for (MCAtom *Atom : Module->atoms()) {
    MCTextAtom *TA = dyn_cast<MCTextAtom>(Atom);
    if (!TA) continue;
    BBInfo &CurBB = BBInfos[TA->getBeginAddr()];
    const MCDecodedInst &LI = TA->back();
    if (MIA.isBranch(LI.Inst)) {
      uint64_t Target;
      if (MIA.evaluateBranch(LI.Inst, LI.Address, LI.Size, Target))
        CurBB.addSucc(BBInfos[Target]);
      if (MIA.isConditionalBranch(LI.Inst))
        CurBB.addSucc(BBInfos[LI.Address + LI.Size]);
    } else if (!MIA.isTerminator(LI.Inst))
      CurBB.addSucc(BBInfos[LI.Address + LI.Size]);
  }


  // Create functions and basic blocks.
  for (uint64_t Address : Calls) {
    BBInfo &BBI = BBInfos[Address];
    if (!BBI.Atom) continue;

    MCFunction &MCFN = *Module->createFunction(BBI.Atom->getName());

    // Create MCBBs.
    SmallSetVector<BBInfo*, 16> Worklist;
    Worklist.insert(&BBI);
    for (size_t wi = 0; wi < Worklist.size(); ++wi) {
      BBInfo *BBI = Worklist[wi];
      if (!BBI->Atom)
        continue;
      BBI->BB = &MCFN.createBlock(*BBI->Atom);
      // Add all predecessors and successors to the worklist.
      for (auto S : BBI->Succs)
        Worklist.insert(S);
      for (auto P : BBI->Preds)
        Worklist.insert(P);
    }

    // Set preds/succs.
    for (size_t wi = 0; wi < Worklist.size(); ++wi) {
      BBInfo *BBI = Worklist[wi];
      MCBasicBlock *MCBB = BBI->BB;
      if (!MCBB)
        continue;
      for (auto S : BBI->Succs)
        if (S->BB)
          MCBB->addSuccessor(S->BB);
      for (auto P : BBI->Preds)
        if (P->BB)
          MCBB->addPredecessor(P->BB);
    }
  }
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

  Worklist.insert(BBBeginAddr);
  for (size_t wi = 0; wi < Worklist.size(); ++wi) {
    const uint64_t BeginAddr = Worklist[wi];
    BBInfo *BBI = &BBInfos[BeginAddr];

    MCTextAtom *&TA = BBI->Atom;
    assert(!TA && "Discovered basic block already has an associated atom!");

    // Look for an atom at BeginAddr.
    if (MCAtom *A = Module->findAtomContaining(BeginAddr)) {
      // FIXME: We don't care about mixed atoms, see above.
      TA = cast<MCTextAtom>(A);

      // The found atom doesn't begin at BeginAddr, we have to split it.
      if (TA->getBeginAddr() != BeginAddr) {
        // FIXME: Handle overlapping atoms: middle-starting instructions, etc..
        MCTextAtom *NewTA = TA->split(BeginAddr);

        // Look for an already encountered basic block that needs splitting
        auto SplitBBIt = BBInfos.find(TA->getBeginAddr());
        if (SplitBBIt != BBInfos.end() && SplitBBIt->second.Atom) {
          BBI->SuccAddrs = SplitBBIt->second.SuccAddrs;
          SplitBBIt->second.SuccAddrs.clear();
          SplitBBIt->second.SuccAddrs.push_back(BeginAddr);
        }
        TA = NewTA;
      }
      BBI->Atom = TA;
    } else {
      // If we didn't find an atom, then we have to disassemble to create one!

      MemoryObject *Region = getRegionFor(BeginAddr);
      if (!Region)
        llvm_unreachable(("Couldn't find suitable region for disassembly at " +
                          utostr(BeginAddr)).c_str());

      uint64_t InstSize;
      uint64_t EndAddr = Region->getBase() + Region->getExtent();

      // We want to stop before the next atom and have a fallthrough to it.
      if (MCTextAtom *NextAtom =
              cast_or_null<MCTextAtom>(Module->findFirstAtomAfter(BeginAddr)))
        EndAddr = std::min(EndAddr, NextAtom->getBeginAddr());

      for (uint64_t Addr = BeginAddr; Addr < EndAddr; Addr += InstSize) {
        MCInst Inst;
        if (Dis.getInstruction(Inst, InstSize, *Region, Addr, nulls(),
                               nulls())) {
          if (!TA)
            TA = Module->createTextAtom(Addr, Addr);
          TA->addInst(Inst, InstSize);
        } else {
          // We don't care about splitting mixed atoms either.
          llvm_unreachable("Couldn't disassemble instruction in atom.");
        }

        uint64_t BranchTarget;
        if (MIA.evaluateBranch(Inst, Addr, InstSize, BranchTarget)) {
          if (MIA.isCall(Inst))
            CallTargets.push_back(BranchTarget);
        }

        if (MIA.isTerminator(Inst))
          break;
      }
      BBI->Atom = TA;
    }

    assert(TA && "Couldn't disassemble atom, none was created!");
    assert(TA->begin() != TA->end() && "Empty atom!");

    MemoryObject *Region = getRegionFor(TA->getBeginAddr());
    assert(Region && "Couldn't find region for already disassembled code!");
    uint64_t EndRegion = Region->getBase() + Region->getExtent();

    // Now we have a basic block atom, add successors.
    // Add the fallthrough block.
    if ((MIA.isConditionalBranch(TA->back().Inst) ||
         !MIA.isTerminator(TA->back().Inst)) &&
        (TA->getEndAddr() + 1 < EndRegion)) {
      BBI->SuccAddrs.push_back(TA->getEndAddr() + 1);
      Worklist.insert(TA->getEndAddr() + 1);
    }

    // If the terminator is a branch, add the target block.
    if (MIA.isBranch(TA->back().Inst)) {
      uint64_t BranchTarget;
      if (MIA.evaluateBranch(TA->back().Inst, TA->back().Address,
                             TA->back().Size, BranchTarget)) {
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

  for (size_t wi = 0, we = Worklist.size(); wi != we; ++wi) {
    const uint64_t BeginAddr = Worklist[wi];
    BBInfo *BBI = &BBInfos[BeginAddr];

    assert(BBI->Atom && "Found a basic block without an associated atom!");

    // Look for a basic block at BeginAddr.
    BBI->BB = MCFN->find(BeginAddr);
    if (BBI->BB) {
      // FIXME: check that the succs/preds are the same
      continue;
    }
    // If there was none, we have to create one from the atom.
    BBI->BB = &MCFN->createBlock(*BBI->Atom);
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
  for (auto &Fn : Module->funcs()) {
    if (Fn->empty())
      continue;
    // FIXME: MCModule should provide a findFunctionByAddr()
    if (Fn->getEntryBlock()->getInsts()->getBeginAddr() == BeginAddr)
      return Fn.get();
  }

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
