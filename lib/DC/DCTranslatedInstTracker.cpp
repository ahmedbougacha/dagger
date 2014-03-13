#include "llvm/DC/DCTranslatedInstTracker.h"

using namespace llvm;

static bool TranslatedInstAddrComp(const DCTranslatedInst &LHS, uint64_t Addr) {
  return LHS.DecodedInst->Address < Addr;
}

void
DCTranslatedInstTracker::trackInst(const DCTranslatedInst &TI) {
  TranslatedInstListTy::iterator I =
      std::lower_bound(TranslatedInsts.begin(), TranslatedInsts.end(),
                       TI.DecodedInst->Address, TranslatedInstAddrComp);
  // NOTE: It is possible that there would be several translated instructions
  // at the same address. This happens for instance when a basic block is
  // shared by different functions.
  TranslatedInsts.insert(I, TI);

  for (int i = 0, e = TI.OperandUseVals.size(); i != e; ++i)
    AddrByInst[TI.OperandUseVals[i].VH].push_back(TI.OperandUseVals[i]);
  for (int i = 0, e = TI.OperandDefVals.size(); i != e; ++i)
    AddrByInst[TI.OperandDefVals[i].VH].push_back(TI.OperandDefVals[i]);
  for (int i = 0, e = TI.ImpDefVals.size(); i != e; ++i)
    AddrByInst[TI.ImpDefVals[i].VH].push_back(TI.ImpDefVals[i]);
  for (int i = 0, e = TI.ImpUseVals.size(); i != e; ++i)
    AddrByInst[TI.ImpUseVals[i].VH].push_back(TI.ImpUseVals[i]);
}
void DCTranslatedInstTracker::getInstsForValue(const Value &V,
  const SmallVectorImpl<DCTranslatedInst::ValueInfo> *&TrackedInsts) const {

  TrackedInsts = 0;
  AddrByInstMapTy::const_iterator I = AddrByInst.find(&V);
  if (I == AddrByInst.end())
    return;

  TrackedInsts = &I->second;
}
