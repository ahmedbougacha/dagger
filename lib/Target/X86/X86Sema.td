include "llvm/DC/Semantics.td"

def SDTX86DCDiv : SDTypeProfile<2, 3, [
  SDTCisSameAs<0, 1>, SDTCisSameAs<0, 2>,
  SDTCisSameAs<0, 3>, SDTCisSameAs<0, 4>,
  SDTCisInt<0>
]>;

def SDTX86DCDiv8 : SDTypeProfile<2, 2, [
  SDTCisSameAs<0, 1>, SDTCisSameAs<0, 3>,
  SDTCisVT<0, i8>, SDTCisVT<2, i16>
]>;

def X86dc_idiv : SDNode<"X86DCISD::IDIV", SDTX86DCDiv>;
def X86dc_div : SDNode<"X86DCISD::DIV", SDTX86DCDiv>;
def X86dc_idiv8 : SDNode<"X86DCISD::IDIV8", SDTX86DCDiv8>;
def X86dc_div8 : SDNode<"X86DCISD::DIV8", SDTX86DCDiv8>;

def : SDNodeEquiv<X86add_flag, add>;
def : SDNodeEquiv<X86sub_flag, sub>;
def : SDNodeEquiv<X86and_flag, and>;
def : SDNodeEquiv<X86xor_flag, xor>;
def : SDNodeEquiv<X86or_flag, or>;

def : SDNodeEquiv<X86smul_flag, mul>;
def : SDNodeEquiv<X86umul_flag, mul>;

// We can reuse the patterns for all jumps/calls.
def : SameSemantics<JO_1,  JO_4>;
def : SameSemantics<JNO_1, JNO_4>;
def : SameSemantics<JB_1,  JB_4>;
def : SameSemantics<JAE_1, JAE_4>;
def : SameSemantics<JE_1,  JE_4>;
def : SameSemantics<JNE_1, JNE_4>;
def : SameSemantics<JBE_1, JBE_4>;
def : SameSemantics<JA_1,  JA_4>;
def : SameSemantics<JS_1,  JS_4>;
def : SameSemantics<JNS_1, JNS_4>;
def : SameSemantics<JP_1,  JP_4>;
def : SameSemantics<JNP_1, JNP_4>;
def : SameSemantics<JL_1,  JL_4>;
def : SameSemantics<JGE_1, JGE_4>;
def : SameSemantics<JLE_1, JLE_4>;
def : SameSemantics<JG_1,  JG_4>;

def : SameSemantics<JMP_1, JMP_4>;

def : Semantics<CALL64pcrel32, [(X86call imm:$dst)]>;

// Instructions that imp-def EFLAGS.
class Sema_F<Instruction inst, dag pattern>
  : Semantics<inst, [pattern, (implicit EFLAGS)]>;
// Variant of Sema_F taking a string instead of an instruction.
class Sema_F_Str<string inst, dag pattern>
  : Sema_F<!cast<Instruction>(inst), pattern>;

// Single-Operand MUL/IMUL.
multiclass Sema_Mul1Op<string inst, SDNode op> {
  def : Sema_F_Str<inst#16r, (set  AX,  DX, (op  AX, GR16:$src))>;
  def : Sema_F_Str<inst#16m, (set  AX,  DX, (op  AX, (load addr:$src)))>;
  def : Sema_F_Str<inst#32r, (set EAX, EDX, (op EAX, GR32:$src))>;
  def : Sema_F_Str<inst#32m, (set EAX, EDX, (op EAX, (load addr:$src)))>;
  def : Sema_F_Str<inst#64r, (set RAX, RDX, (op RAX, GR64:$src))>;
  def : Sema_F_Str<inst#64m, (set RAX, RDX, (op RAX, (load addr:$src)))>;
}
defm : Sema_Mul1Op<"MUL", umullohi>;
defm : Sema_Mul1Op<"IMUL", smullohi>;

// Single-Operand DIV/IDIV.
multiclass Sema_Div<string inst, SDNode Div8Op, SDNode DivOp> {
  def : Sema_F_Str<inst#8r,  (set  AL,  AH, (Div8Op AX,      GR8:$src))>;
  def : Sema_F_Str<inst#8m,  (set  AL,  AH, (Div8Op AX,      (load addr:$src)))>;
  def : Sema_F_Str<inst#16r, (set  AX,  DX, (DivOp  DX,  AX, GR16:$src))>;
  def : Sema_F_Str<inst#16m, (set  AX,  DX, (DivOp  DX,  AX, (load addr:$src)))>;
  def : Sema_F_Str<inst#32r, (set EAX, EDX, (DivOp EDX, EAX, GR32:$src))>;
  def : Sema_F_Str<inst#32m, (set EAX, EDX, (DivOp EDX, EAX, (load addr:$src)))>;
  def : Sema_F_Str<inst#64r, (set RAX, RDX, (DivOp RDX, RAX, GR64:$src))>;
  def : Sema_F_Str<inst#64m, (set RAX, RDX, (DivOp RDX, RAX, (load addr:$src)))>;
}

defm : Sema_Div<"IDIV", X86dc_idiv8, X86dc_idiv>;
defm : Sema_Div<"DIV", X86dc_div8, X86dc_div>;

// These should go away when we can do proper equivalence between inc->add
multiclass Sema_IncDec<string inst, SDNode op> {
  def : Sema_F_Str<inst#8r, (set GR8:$dst, (op GR8:$src1, 1))>;
  def : Sema_F_Str<inst#16r, (set GR16:$dst, (op GR16:$src1, 1))>;
  def : Sema_F_Str<inst#32r, (set GR32:$dst, (op GR32:$src1, 1))>;
  def : Sema_F_Str<inst#64r, (set GR64:$dst, (op GR64:$src1, 1))>;
  def : Sema_F_Str<inst#64_32r, (set GR32:$dst, (op GR32:$src1, 1))>;
  def : Sema_F_Str<inst#64_16r, (set GR16:$dst, (op GR16:$src1, 1))>;
}
defm : Sema_IncDec<"DEC", sub>;
defm : Sema_IncDec<"INC", add>;

multiclass Sema_BinOpAI<string inst, SDNode op> {
  def : Sema_F_Str<inst#8i8,   (set AL,  (op AL,  i8 :$src))>;
  def : Sema_F_Str<inst#16i16, (set AX,  (op AX,  i16:$src))>;
  def : Sema_F_Str<inst#32i32, (set EAX, (op EAX, i32:$src))>;
  def : Sema_F_Str<inst#64i32, (set RAX, (op RAX, i64:$src))>;
}

defm : Sema_BinOpAI<"ADD", add>;
defm : Sema_BinOpAI<"SUB", sub>;
defm : Sema_BinOpAI<"AND", and>;
defm : Sema_BinOpAI<"XOR", xor>;
defm : Sema_BinOpAI<"OR", or>;

def : Sema_F<CMP8i8,   (set EFLAGS, (X86cmp AL,  i8 :$src))>;
def : Sema_F<CMP16i16, (set EFLAGS, (X86cmp AX,  i16:$src))>;
def : Sema_F<CMP32i32, (set EFLAGS, (X86cmp EAX, i32:$src))>;
def : Sema_F<CMP64i32, (set EFLAGS, (X86cmp RAX, i64:$src))>;

def : Sema_F<TEST8i8,   (set EFLAGS, (X86testpat AL,  i8 :$src))>;
def : Sema_F<TEST16i16, (set EFLAGS, (X86testpat AX,  i16:$src))>;
def : Sema_F<TEST32i32, (set EFLAGS, (X86testpat EAX, i32:$src))>;
def : Sema_F<TEST64i32, (set EFLAGS, (X86testpat RAX, i64:$src))>;

def : Semantics<PUSH64r, [(store GR64:$reg, (sub RSP, 8)),
                          (set RSP, (sub RSP, 8))]>;
def : Semantics<PUSH64i32, [(store i64:$imm, (sub RSP, 8)),
                          (set RSP, (sub RSP, 8))]>;
def : Semantics<POP64r, [(set RSP, (add RSP, 8)),
                         (set GR64:$reg, (load (sub RSP, 8)))]>;
def : Semantics<POP64rmm, [(set RSP, (add RSP, 8)),
                           (store addr:$dst, (load (sub RSP, 8)))]>;

def : Semantics<MOV8rr,  [(set  GR8:$dst,  GR8:$src)]>;
def : Semantics<MOV16rr, [(set GR16:$dst, GR16:$src)]>;
def : Semantics<MOV32rr, [(set GR32:$dst, GR32:$src)]>;
def : Semantics<MOV64rr, [(set GR64:$dst, GR64:$src)]>;

class Sema_MOVX_m<Instruction inst, SDNode op, RegisterClass destRC, ValueType VT>
  : Semantics<inst, [(set destRC:$dst, (op (VT (load addr:$src))))]>;

def : Sema_MOVX_m<MOVZX16rm8,    zext, GR16, i8>;
def : Sema_MOVX_m<MOVZX32rm8,    zext, GR32, i8>;
def : Sema_MOVX_m<MOVZX32rm16,   zext, GR32, i16>;
def : Sema_MOVX_m<MOVZX64rm8_Q,  zext, GR64, i8>;
def : Sema_MOVX_m<MOVZX64rm16_Q, zext, GR64, i16>;
def : Sema_MOVX_m<MOVSX16rm8,    sext, GR16, i8>;
def : Sema_MOVX_m<MOVSX32rm8,    sext, GR32, i8>;
def : Sema_MOVX_m<MOVSX32rm16,   sext, GR32, i16>;
def : Sema_MOVX_m<MOVSX64rm8,    sext, GR64, i8>;
def : Sema_MOVX_m<MOVSX64rm16,   sext, GR64, i16>;
def : Sema_MOVX_m<MOVSX64rm32,   sext, GR64, i32>;

// FIXME: We could use custom SD opcodes for this kind of thing.
def : Semantics<CBW,  [(set AX,  (sext AL))]>;
def : Semantics<CWDE, [(set EAX, (sext AX))]>;
def : Semantics<CWD,  [(set DX,  (sra (shl AX, (i16 15)), (i16 15)))]>;
def : Semantics<CDQ,  [(set EDX, (sra (shl EAX, (i32 31)), (i32 31)))]>;
def : Semantics<CDQE, [(set RAX, (sext EAX))]>;
def : Semantics<CQO,  [(set RDX, (sra (shl RAX, (i64 63)), (i64 63)))]>;

def : Semantics<MOVUPSrr, [(set (v4f32 VR128:$dst), (v4f32 VR128:$src))]>;
def : Semantics<MOVAPSrr, [(set (v4f32 VR128:$dst), (v4f32 VR128:$src))]>;
def : Semantics<MOVAPDrr, [(set (v4f32 VR128:$dst), (v4f32 VR128:$src))]>;
def : Semantics<MOVUPDrr, [(set (v2f64 VR128:$dst), (v2f64 VR128:$src))]>;

def : Semantics<MOVDQArr, [(set (v2i64 VR128:$dst), (v2i64 VR128:$src))]>;
def : Semantics<MOVDQUrr, [(set (v2i64 VR128:$dst), (v2i64 VR128:$src))]>;

// We don't care about alignment here.
multiclass Sema_MOVDQ<string align, RegisterClass RC, ValueType VT,
                      string prefix = "", string suffix = ""> {
  def : Semantics<!cast<Instruction>(prefix#MOVDQ#align#suffix#rm),
                  [(set RC:$dst, (VT (load addr:$src)))]>;
  def : Semantics<!cast<Instruction>(prefix#MOVDQ#align#suffix#mr),
                  [(store (VT RC:$src), addr:$dst)]>;
}
defm : Sema_MOVDQ<"A", VR128, v2i64>;
defm : Sema_MOVDQ<"U", VR128, v2i64>;
defm : Sema_MOVDQ<"A", VR128, v2i64, "V">;
defm : Sema_MOVDQ<"U", VR128, v2i64, "V">;
defm : Sema_MOVDQ<"A", VR256, v4i64, "V", "Y">;
defm : Sema_MOVDQ<"U", VR256, v4i64, "V", "Y">;
