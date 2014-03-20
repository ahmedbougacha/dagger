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
    ValInfo[TI.OperandUseVals[i].VH].push_back(TI.OperandUseVals[i]);
  for (int i = 0, e = TI.OperandDefVals.size(); i != e; ++i)
    ValInfo[TI.OperandDefVals[i].VH].push_back(TI.OperandDefVals[i]);
  for (int i = 0, e = TI.ImpDefVals.size(); i != e; ++i)
    ValInfo[TI.ImpDefVals[i].VH].push_back(TI.ImpDefVals[i]);
  for (int i = 0, e = TI.ImpUseVals.size(); i != e; ++i)
    ValInfo[TI.ImpUseVals[i].VH].push_back(TI.ImpUseVals[i]);
}

void DCTranslatedInstTracker::getInstsForValue(const Value &V,
  const SmallVectorImpl<DCTranslatedInst::ValueInfo> *&TrackedInsts) const {

  TrackedInsts = 0;
  ValInfoMapTy::const_iterator I = ValInfo.find(&V);
  if (I == ValInfo.end())
    return;

  TrackedInsts = &I->second;
}

const DCTranslatedInst *DCTranslatedInstTracker::getTrackedInfo(const MCDecodedInst &MCDI) const {

  TranslatedInstListTy::const_iterator I =
      std::lower_bound(TranslatedInsts.begin(), TranslatedInsts.end(),
                       MCDI.Address, TranslatedInstAddrComp);
  if (I == TranslatedInsts.end() || I->DecodedInst != &MCDI)
    return 0;
  return &*I;
}
