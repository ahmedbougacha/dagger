//===-- llvm/DC/DCInstruction.h - Instruction Translation -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines DCInstruction, the main interface that can be used to
// translate machine code instructions (represented by an MCDecodedInst) to IR.
//
// DCInstruction provides various methods - some provided by a Target-specific
// subclassing implementation - that translate instruction-level MC constructs
// into a corresponding sequence of IR instructions (possibly creating control
// flow).
//
//===----------------------------------------------------------------------===//


#ifndef LLVM_DC_DCINSTRUCTION_H
#define LLVM_DC_DCINSTRUCTION_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/DC/DCBasicBlock.h"
#include "llvm/DC/DCOpcodes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/NoFolder.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/Support/ErrorHandling.h"

namespace llvm {

class DCInstruction {
protected:
  DCBasicBlock &DCB;
  const MCDecodedInst &TheMCInst;

  IRBuilder<NoFolder> Builder;

  /// Get the type of result \p Idx of the current operation.
  Type *getResultTy(unsigned Idx) { return ResTys[Idx]; }

  /// Get operand \p Idx of the current operation.
  Value *getOperand(unsigned Idx) { return Ops[Idx]; }

  /// Define a result with value \p Res, making it available for use by later
  /// operations in the instruction.
  void addResult(Value *Res) { Vals.push_back(Res); }

  /// Get the last result defined by the last operation.
  Value *getLastDef() { return Vals.back(); }

private:
  /// The current cursor inside the semantics array.
  unsigned SemaIdx;

  /// The list of result types of the current operation.
  SmallVector<Type *, 4> ResTys;

  /// The list of operands for the current operation.
  SmallVector<Value *, 8> Ops;

  /// The list of defined values since the start of the instruction.
  SmallVector<Value *, 16> Vals;

  /// The map between MC inst opcode to semantics array index.
  const unsigned *OpcodeToSemaIdx;

  /// The semantics array.
  const uint16_t *SemanticsArray;

  /// The constants array, referenced by MOV_CONSTANT operations.
  const uint64_t *ConstantArray;

public:
  DCInstruction(DCBasicBlock &DCB, const MCDecodedInst &MCI,
                const unsigned *OpcodeToSemaIdx, const uint16_t *SemanticsArray,
                const uint64_t *ConstantArray);
  virtual ~DCInstruction();

  bool translate();

  LLVMContext &getContext() { return getParent().getContext(); }
  Module *getModule() { return getParent().getModule(); }
  Function *getFunction() { return getParent().getFunction(); }

  DCBasicBlock &getParent() { return DCB; }
  DCFunction &getParentFunction() { return getParent().getParent(); }
  DCModule &getParentModule() { return getParentFunction().getParent(); }
  DCTranslator &getTranslator() { return getParentModule().getTranslator(); }

protected:

  /// MC operand accessors
  /// @{
  /// Get the immediate operand \p Idx of the current instruction (TheMCInst).
  uint64_t getImmOp(unsigned Idx) {
    return TheMCInst.Inst.getOperand(Idx).getImm();
  }

  /// Get the register operand \p Idx of the current instruction (TheMCInst).
  unsigned getRegOp(unsigned Idx) {
    return TheMCInst.Inst.getOperand(Idx).getReg();
  }
  /// @}

  /// Register state accessors
  /// @{
  /// Get the native type of register \p RegNo.
  /// Get the current value of register \p RegNo, i.e., the value assigned to it
  /// last with setReg().
  Value *getReg(unsigned RegNo);

  /// Get the current value of register \p RegNo, bitcast to its integer type.
  Value *getRegAsInt(unsigned RegNo) {
    return Builder.CreateBitCast(getReg(RegNo), getRegIntType(RegNo));
  }

  /// Assign \p Val to register \p RegNo.
  /// This updates the DCBasicBlock "current" Value for \p RegNo.
  /// Assign its sub-/super-registers to the appropriate value.
  void setReg(unsigned RegNo, Value *Val);
  /// @}

  /// Register type accessors
  /// @{
  /// Get the type of register \p RegNo, as defined in the DCRegisterSetDesc.
  /// If the register doesn't have a type, return it's integer type.
  Type *getRegType(unsigned RegNo);

  /// Get the integer type of register \p RegNo (iN, with N the size in bits).
  IntegerType *getRegIntType(unsigned RegNo);
  /// @}

  /// Do we need to keep the value of the bits not covered by Idx, or does
  /// setting the sub-reg through Idx clear the Super-reg?
  virtual bool doesSubRegIndexClearSuper(unsigned Idx) { return false; }

  /// Translation
  /// @{
  /// Create a call instruction to \p CallTarget.
  /// This does the necessary bookkeeping to save/restore the register state
  /// across the call and ensure the consistency of the register set struct.
  /// If \p CallTarget isn't a Function, wrap it with @llvm.dc.translate.at()
  void insertCall(Value *CallTarget);

  bool translateOpcode(unsigned Opcode);

  virtual bool translateTargetOpcode(unsigned Opcode) = 0;
  virtual Value *translateCustomOperand(unsigned OperandKind,
                                        unsigned MIOperandNo) = 0;
  virtual bool translateImplicit(unsigned RegNo) = 0;

  virtual Value *translateComplexPattern(unsigned PatternKind);
  virtual bool translatePredicate(unsigned PredicateKind);

  // Try to do a custom translation of a full instruction.
  // Called before translating an instruction.
  // Return true if the translation shouldn't proceed.
  virtual bool translateTargetInst() { return false; }
  /// @}

  /// Returns a string containing the name of each construct, for dump purposes.
  /// @{
  virtual StringRef getDCOpcodeName(unsigned Opcode) const = 0;
  virtual StringRef getDCCustomOpName(unsigned OperandKind) const = 0;
  virtual StringRef getDCPredicateName(unsigned PredicateKind) const = 0;
  virtual StringRef getDCComplexPatternName(unsigned CPKind) const = 0;
  /// @}

private:
  bool tryTranslateInst();

  /// Translate the special DCINS builtin operations, defined in DCOpcodes.h.
  /// Returns whether translation succeeded (it can fail when builtin
  /// constructs such as custom operands aren't supported by the target).
  bool translateDCOp(uint16_t Opcode);

  void translateBinOp(Instruction::BinaryOps Opc);
  void translateCastOp(Instruction::CastOps Opc);

  bool translateExtLoad(Type *MemTy, bool isSExt = false);

  /// Get the next result type value in the semantics array.
  Type *NextTy();

  /// Fill the Ops array with the proper Values, copied from the Vals array,
  /// indexed with the elements in the semantics array.
  void prepareOperands();

  /// Dump to dbgs(), an operation \p Opcode, producing \p ResultTypes, and
  /// taking \p Operands, defined in SemanticsArray starting at \p SemaStartIdx.
  void dumpOperation(StringRef Opcode, ArrayRef<Type *> ResultTypes,
                     ArrayRef<Value *> Operands,
                     unsigned SemaStartIdx) LLVM_DUMP_METHOD;


protected:
  /// Get the next raw value in the semantics array.
  unsigned Next() { return SemanticsArray[SemaIdx++]; }
};

} // end namespace llvm

#endif
