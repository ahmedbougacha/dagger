//===-- llvm/DC/DCRegisterSema.cpp - DC Register Semantics ------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the DCRegisterSema class, which provides register-level
// semantics used to translate Machine Code to LLVM IR.
// Register-level semantics include describing the register set hierarchy
// (super- and sub-registers), semantics of special registers (such as the
// status/flags register).
// DCRegisterSema also computes and builds the Register Set type, an LLVM IR
// struct type which contains all registers for a given target.
//
// It finally provides various functions to generate code dealing with
// registers, such as getting/setting a register with an LLVM value, saving and
// restoring the Register Set across function calls, etc...
//
// Targets need to implement a DCRegisterSema subclass, and complete it with
// their actual semantics.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_DCREGISTERSEMA_H
#define LLVM_DC_DCREGISTERSEMA_H

#include "llvm/CodeGen/MachineValueType.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/NoFolder.h"
#include "llvm/Support/Compiler.h"
#include <vector>

namespace llvm {
class BasicBlock;
class DataLayout;
class Function;
class LLVMContext;
class MCDecodedInst;
class MCInstrInfo;
class MCRegisterInfo;
class Module;
class StructType;
class Value;
}

namespace llvm {

class DCRegisterSema {
private:
  DCRegisterSema(const DCRegisterSema &) = delete;
  void operator=(const DCRegisterSema &) = delete;

public:
  DCRegisterSema(LLVMContext &Ctx, const MCRegisterInfo &MRI,
                 const MCInstrInfo &MII, const DataLayout &DL,
                 const MVT::SimpleValueType *RegClassVTs);
  virtual ~DCRegisterSema();

  const MCRegisterInfo &MRI;
  const MCInstrInfo &MII;

  const DataLayout &DL;
  LLVMContext &Ctx;
  StructType *RegSetType;

private:
  // Reg* vectors contain all MRI.getNumRegs() registers.
  unsigned NumRegs;
  // Largest* vectors contain NumLargest registers.
  unsigned NumLargest;

protected:
  unsigned getNumRegs() const { return NumRegs; }
  unsigned getNumLargest() const { return NumLargest; }

  // The size of each register, in bits.
  std::vector<unsigned> RegSizes;

  // The type of each register (the first type of the last register class
  // containing the register).
  // FIXME: Is there a better heuristic for register class selection?
  std::vector<Type *> RegTypes;

  // The largest super register of each register, 0 if undefined, itself if the
  // register has no super-register.
  std::vector<unsigned> RegLargestSupers;

  // Whether a register partially aliases other registers: this is usually the
  // case for tuples of registers, which alias the other permutations.
  // These registers don't participate in the regset and are materialized lazily
  // from their sub-registers.
  std::vector<bool> RegAliased;

  // The offset of each register in RegSetType, or -1 if not present.
  // Only the largest super registers are present, meaning there are only
  // NumLargest elements not equal to -1.
  std::vector<int> RegOffsetsInSet;

  std::vector<unsigned> LargestRegs;

  // Always valid inside a context.
  std::vector<Constant *> RegConstantVals;

  // Valid only inside a Module.
  Module *TheModule;
  typedef IRBuilder<NoFolder> DCIRBuilder;
  // FIXME: This doesn't need to be a pointer.
  std::unique_ptr<DCIRBuilder> Builder;

  // Valid only inside a Function.
  std::vector<Value *> RegPtrs;
  std::vector<AllocaInst *> RegAllocas;
  std::vector<Value *> RegInits;
  std::vector<unsigned> RegAssignments;

  Function *TheFunction;

  // Valid only inside a BasicBlock.
  std::vector<Value *> RegVals;

  // Valid only inside an instruction.
  const MCDecodedInst *CurrentInst;

  // Methods to be overriden for specific targets.

  // Do we need to keep the value of the bits not covered by Idx, or does
  // setting the sub-reg through Idx clear the Super-reg?
  virtual bool doesSubRegIndexClearSuper(unsigned Idx) const { return false; }

  // Called before getting a register.
  virtual void onRegisterGet(unsigned RegNo) {}

  // Called when a register was just set.
  virtual void onRegisterSet(unsigned RegNo, Value *Val) {}

public:
  StructType *getRegSetType() const { return RegSetType; }
  // Compute the register's offset in bytes from the start of the regset.
  // Also return it's size in bytes.
  std::pair<size_t, size_t> getRegSizeOffsetInRegSet(unsigned RegNo) const;

  // Returns the regset diff function, that prints to stderr:
  //     void @__llvm_dc_print_regset_diff(i8* fn, %regset* v1, %regset* v2)
  Function *getOrCreateRegSetDiffFunction(bool Definition = false);

  virtual void SwitchToModule(Module *TheModule);
  virtual void SwitchToFunction(Function *TheFunction);
  virtual void SwitchToBasicBlock(BasicBlock *TheBB);
  void SwitchToInst(const MCDecodedInst &DecodedInst);

  virtual void FinalizeFunction(BasicBlock *ExitBB);
  virtual void FinalizeBasicBlock();

  void saveAllLocalRegs(BasicBlock *BB, BasicBlock::iterator IP);
  void restoreLocalRegs(BasicBlock *BB, BasicBlock::iterator IP);

  void defineAllSubSuperRegs(unsigned RegNo);
  Value *extractSubRegFromSuper(unsigned Super, unsigned Sub,
                                Value *SuperValue = 0);
  Value *recreateSuperRegFromSub(unsigned Super, unsigned Sub);

  void createLocalValueForReg(unsigned RegNo);
  void setRegValWithName(unsigned RegNo, Value *Val);
  void setRegNoSubSuper(unsigned RegNo, Value *Val);

  Value *getRegNoCallback(unsigned RegNo);

  Value *getReg(unsigned RegNo);
  void setReg(unsigned RegNo, Value *Val);

  Type *getRegType(unsigned RegNo);

  IntegerType *getRegIntType(unsigned RegNo);
  Value *getRegAsInt(unsigned RegNo) {
    return Builder->CreateBitCast(getReg(RegNo), getRegIntType(RegNo));
  }

  // Fill 2 functions, main_{init,fini}_regset, to initialize a regset from
  // a stack pointer and ac/av, and to extract the return value.
  virtual void insertInitRegSetCode(Function *InitFn) = 0;
  virtual void insertFiniRegSetCode(Function *FiniFn) = 0;

  virtual void insertExternalWrapperAsm(BasicBlock *WrapperBB,
                                        Value *ExtFn) = 0;

public:
  // Helper methods.
  // FIXME: These should move out of DCRegisterSema.

  // Extract \p NumBits starting at \p LoBit from \p Val.
  Value *extractBitsFromValue(unsigned LoBit, unsigned NumBits, Value *Val);

  // Insert \p ValToInsert at \p Offset in \p FullVal.
  // Both FullVal and ValToInsert have to be integers.
  // ValToInsert also has to fit: Offset + size of ValToInsert < FullVal.
  // If \p ClearOldValue is true, then this resets FullVal to 0 before
  // inserting.
  Value *insertBitsInValue(Value *FullVal, Value *ValToInsert,
                           unsigned Offset = 0, bool ClearOldValue = false);

  // Get a constant expression expressing \p FPtr as a \p FTy value.
  template <typename T>
  Value *getCallTargetForExtFn(FunctionType *FTy, T FPtr) {
    // FIXME: bitness
    ConstantInt *FnPtrInt = ConstantInt::get(Type::getInt64Ty(Ctx),
                                             reinterpret_cast<uint64_t>(FPtr));
    return ConstantExpr::getBitCast(
        ConstantExpr::getIntToPtr(FnPtrInt, Type::getInt8PtrTy(Ctx)),
        FTy->getPointerTo());
  }
};
}

#endif
