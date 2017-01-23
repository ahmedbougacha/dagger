//===-- lib/DC/DCRegisterSetDesc.cpp - Register Set Description -*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/DC/DCRegisterSetDesc.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>

using namespace llvm;

#define DEBUG_TYPE "dc-regset-desc"

DCRegisterSetDesc::DCRegisterSetDesc(LLVMContext &Ctx,
                                     const MCRegisterInfo &MRI,
                                     const MVT::SimpleValueType *RegClassVTs)
    : Ctx(Ctx), RegSetType(0), NumRegs(MRI.getNumRegs()), NumLargest(0),
      RegSizes(NumRegs), RegTypes(NumRegs), RegLargestSupers(NumRegs),
      RegAliased(NumRegs), RegOffsetsInSet(NumRegs, -1), LargestRegs(),
      RegConstantVals(NumRegs) {

  // First, determine the (spill) size of each register, in bits.
  // FIXME: the best (only) way to know the size of a reg is to find a
  // containing RC.
  // FIXME: This should go in tablegen.
  for (auto RCI = MRI.regclass_begin(), RCE = MRI.regclass_end(); RCI != RCE;
       ++RCI) {
    unsigned SizeInBits = RCI->getSize() * 8;
    Type *RCTy = nullptr;

    EVT RCVT = RegClassVTs[RCI->getID()];
    if (RCVT == MVT::Untyped)
      RCTy = IntegerType::get(Ctx, SizeInBits);
    else
      RCTy = RCVT.getTypeForEVT(Ctx);

    for (auto Reg : *RCI) {
      if (SizeInBits > RegSizes[Reg]) {
        RegSizes[Reg] = SizeInBits;
        RegTypes[Reg] = RCTy;
      }
    }
  }

  // Now we have all the sizes we need, determine the largest super registers.
  // Do that in two steps: first, look at all regunit roots to determine which
  // registers are super-registers of multiple regunit roots.
  //
  // Use that as a tie-breaker: if a register has multiple super-registers with
  // the same size, pick the unique super-register that is a super-register of
  // the least number of regunit roots.
  //
  // In other words, say we have (on AArch64):
  //     W0       W1
  //       \     / | \
  //        W0_W1 X1  W1_W2
  //          |  /   \ |
  //        X0_X1     X1_X2
  //
  // We want to pick X1 as the largest super of W1, because the others all
  // overlap and can't be expressed (short of having one value for the entire
  // register file).
  //
  // FIXME: We should eventually materialize the ignored super-registers from
  // their sub-registers on get, and split them on set.
  std::vector<unsigned> RegNumRootUnits(NumRegs);

  for (unsigned RUI = 0, RUE = MRI.getNumRegUnits(); RUI != RUE; ++RUI) {
    MCRegUnitRootIterator RI(RUI, &MRI);
    unsigned RURoot = *RI;

    // Regunits with multiple roots usually involve aliases; don't worry about
    // those yet.
    ++RI;
    if (RI.isValid())
      llvm_unreachable("Regunits with multiple roots not supported yet");

    for (MCSuperRegIterator SI(RURoot, &MRI, true); SI.isValid(); ++SI)
      ++RegNumRootUnits[*SI];
  }

  DEBUG(dbgs() << "Computing reg largest supers:\n");
  for (unsigned RI = 1, RE = NumRegs; RI != RE; ++RI) {
    DEBUG(dbgs() << " - For " << MRI.getName(RI) << ":\n");
    if (RegSizes[RI] == 0)
      continue;
    unsigned &Largest = RegLargestSupers[RI];
    Largest = RI;

    // Gather all super-registers of RI.
    SmallVector<unsigned, 4> SuperRegs;
    for (MCSuperRegIterator SRI(RI, &MRI); SRI.isValid(); ++SRI) {
      if (RegSizes[*SRI] == 0)
        continue;
      DEBUG(dbgs() << "   Considering: " << MRI.getName(*SRI) << "\n");
      SuperRegs.push_back(*SRI);
    }

    // If there are no super-registers, there's no largest super-register.
    if (SuperRegs.empty())
      continue;

    // Order them by size, then number of roots, then register number.
    std::stable_sort(SuperRegs.begin(), SuperRegs.end(),
                     [&](unsigned LR, unsigned RR) {
                       return RegSizes[LR] == RegSizes[RR]
                                  ? RegNumRootUnits[LR] < RegNumRootUnits[RR]
                                  : RegSizes[LR] < RegSizes[RR];
                     });

    // Pick the largest super: go through the ordered list of super-registers
    // by iterating on groups of same-size super-registers.
    for (int SRI = 0, SRE = SuperRegs.size(); SRI != SRE; ++SRI) {
      unsigned SR = SuperRegs[SRI];
      unsigned SRSize = RegSizes[SR];

      // If this is the last super-register, it's trivially the largest.
      if ((SRI + 1) == SRE) {
        Largest = SR;
        break;
      }

      // If there are multiple super-registers, and one (and only one) has less
      // units, it's a candidate to being the largest super-register.
      unsigned NSR = SuperRegs[SRI + 1];
      if (RegSizes[NSR] == SRSize) {
        // If there are multiple super-registers with the same number of units,
        // we can't look through the aliasing and bail out.
        if (RegNumRootUnits[NSR] == RegNumRootUnits[SR]) {
          RegAliased[SR] = true;
          while ((SRI + 1) != SRE)
            RegAliased[SuperRegs[++SRI]] = true;
          break;
        }
        Largest = SR;
      }

      while ((SRI + 1) != SRE && RegSizes[SuperRegs[SRI + 1]] == SRSize)
        RegAliased[SuperRegs[++SRI]] = true;
    }

    DEBUG(dbgs() << "   Picked largest: " << MRI.getName(Largest) << "\n");
  }

  for (unsigned RI = 1, RE = NumRegs; RI != RE; ++RI) {
    if (RegAliased[RI])
      RegLargestSupers[RI] = 0;
  }

  LargestRegs.resize(RegLargestSupers.size());
  std::copy(RegLargestSupers.begin(), RegLargestSupers.end(),
            LargestRegs.begin());
  std::sort(LargestRegs.begin(), LargestRegs.end());
  LargestRegs.erase(std::unique(LargestRegs.begin(), LargestRegs.end()),
                    LargestRegs.end());
  // Now we have a sorted, uniqued vector of the largest registers to keep,
  // starting with register index 0, which we again don't care about.
  NumLargest = LargestRegs.size();

  for (unsigned I = 1, E = NumLargest; I != E; ++I) {
    assert(RegSizes[LargestRegs[I]] != 0 &&
           "Largest super-register doesn't have a type!");
    RegOffsetsInSet[LargestRegs[I]] = I - 1;
  }

  std::vector<Type *> LargestRegTypes(NumLargest - 1);
  for (unsigned I = 1, E = NumLargest; I != E; ++I)
    LargestRegTypes[I - 1] = RegTypes[LargestRegs[I]];

  RegSetType = StructType::create(LargestRegTypes, "regset");
}

std::pair<size_t, size_t> DCRegisterSetDesc::getRegSizeOffsetInRegSet(
    unsigned RegNo, const DataLayout &DL, const MCRegisterInfo &MRI) const {
  size_t Size, Offset;
  Size = RegSizes[RegNo] / 8;

  const StructLayout *SL = DL.getStructLayout(RegSetType);
  unsigned Largest = RegLargestSupers[RegNo];
  unsigned Idx = RegOffsetsInSet[Largest];
  Offset = SL->getElementOffset(Idx);
  if (Largest != RegNo) {
    unsigned SubRegIdx = MRI.getSubRegIndex(Largest, RegNo);
    assert(SubRegIdx &&
           "Couldn't determine register's offset in super-register.");
    unsigned OffsetInSuper = MRI.getSubRegIdxOffset(SubRegIdx);
    assert(((OffsetInSuper % 8) == 0) && "Register isn't byte aligned!");
    Offset += (OffsetInSuper / 8);
  }
  return std::make_pair(Size, Offset);
}
