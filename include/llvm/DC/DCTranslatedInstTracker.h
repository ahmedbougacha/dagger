#ifndef DAGGER_DC_DCTRANSLATEDINSTTRACKER_H
#define DAGGER_DC_DCTRANSLATEDINSTTRACKER_H

#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/ValueHandle.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/MC/MCAtom.h"

namespace llvm {

class DCTranslatedInst {
public:
  struct ValueInfo {
    enum OperandKind {
      UnknownKind,
      RegUseKind,
      RegDefKind,
      ImpUseKind,
      ImpDefKind,
      ImmOpKind,
      CustomOpKind
    };

    // FIXME: more elegant way to keep track of DecodedInst?
    const MCDecodedInst *DecodedInst;
    WeakVH VH;
    union {
      uint32_t RegNo;
      uint32_t MIOperandNo;
    };
    uint16_t OpKind;
    uint16_t CustomOpType;

    ValueInfo() : DecodedInst(0), VH(), RegNo(0), OpKind(0), CustomOpType(0) {}
    ValueInfo(const MCDecodedInst *DecodedInst, Value *V,
              OperandKind OpKind, unsigned RegOrOperandNo,
              unsigned CustomOpType = 0)
        : DecodedInst(DecodedInst), VH(V),
          RegNo(RegOrOperandNo), OpKind(OpKind), CustomOpType(CustomOpType) {}
  };

  void addImpUse(unsigned RegNo, Value *V) {
    ImpUseVals.push_back(
      ValueInfo(DecodedInst, V, ValueInfo::ImpUseKind, RegNo));
  }
  void addImpDef(unsigned RegNo, Value *V) {
    ImpDefVals.push_back(
      ValueInfo(DecodedInst, V, ValueInfo::ImpDefKind, RegNo));
  }
  void addRegOpUse(unsigned MIOperandNo, Value *V) {
    OperandUseVals.push_back(
      ValueInfo(DecodedInst, V, ValueInfo::RegUseKind, MIOperandNo));
  }
  void addRegOpDef(unsigned MIOperandNo, Value *V) {
    OperandDefVals.push_back(
      ValueInfo(DecodedInst, V, ValueInfo::RegDefKind, MIOperandNo));
  }
  void addOpUse(unsigned MIOperandNo, unsigned CustomOpType, Value *V) {
    OperandUseVals.push_back(
        ValueInfo(DecodedInst, V, ValueInfo::CustomOpKind,
                  MIOperandNo, CustomOpType));
  }
  void addImmOpUse(unsigned MIOperandNo, Value *V) {
    OperandUseVals.push_back(
      ValueInfo(DecodedInst, V, ValueInfo::ImmOpKind, MIOperandNo));
  }

  SmallVector<ValueInfo, 4> OperandUseVals;
  SmallVector<ValueInfo, 2> OperandDefVals;
  SmallVector<ValueInfo, 1> ImpUseVals;
  SmallVector<ValueInfo, 1> ImpDefVals;

  const MCDecodedInst *DecodedInst;
  DCTranslatedInst(const MCDecodedInst &MCDI) : DecodedInst(&MCDI) {}
};

class DCTranslatedInstTracker {
  typedef ValueMap<
      const Value *, SmallVector<DCTranslatedInst::ValueInfo, 2> > AddrByInstMapTy;
  AddrByInstMapTy AddrByInst;

  typedef std::vector<DCTranslatedInst> TranslatedInstListTy;
  // All translated instruction info, sorted by decoded inst address.
  TranslatedInstListTy TranslatedInsts;

public:
  void trackInst(const DCTranslatedInst &TI);

  void getInstsForValue(const Value &V,
    const SmallVectorImpl<DCTranslatedInst::ValueInfo> *&TrackedInsts) const;
};

} // end namespace llvm

#endif
