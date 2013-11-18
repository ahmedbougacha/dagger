#ifndef TARGET_X86_DC_X86INSTRSEMA_H
#define TARGET_X86_DC_X86INSTRSEMA_H

#include "llvm/DC/DCInstrSema.h"
#include "llvm/Support/Compiler.h"

namespace llvm {
namespace X86DCISD {
  enum {
    FIRST_NUMBER = DCINS::FIRST_TARGET_DC_OPCODE,
    IDIV,
    DIV,
    // Variants for 8bit division (AX div r/m8)
    IDIV8,
    DIV8
  };
} // end namespace X86DCISD

class X86RegisterSema;

class X86InstrSema : public DCInstrSema {
  // FIXME: This goes away once we have something like TargetMachine.
  X86RegisterSema &X86DRS;

public:
  X86InstrSema(DCRegisterSema &DRS);

  void translateTargetOpcode();
  void translateCustomOperand(unsigned OperandType, unsigned MIOperandNo);
  void translateImplicit(unsigned RegNo);

  bool translateTargetInst();

private:
  void translateAddr(unsigned MIOperandNo,
                     MVT::SimpleValueType VT = MVT::iPTRAny);

  void translatePush(Value *Val);
  Value *translatePop(unsigned SizeInBytes);

  void translateDivRem(bool isThreeOperand, bool isSigned);
  void translateHorizontalBinop(Instruction::BinaryOps BinOp);
};

} // end namespace llvm

#endif
