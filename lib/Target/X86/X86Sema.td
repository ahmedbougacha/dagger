include "llvm/DC/Semantics.td"

// Sema-specific EFLAGS register, containing only the Control and System bits
// of EFLAGS (i.e., with the status bits assumed to be 0).
def CtlSysEFLAGS : X86Reg<"ctl_sys_flags", 0>;
def CtlSysCCR : RegisterClass<"X86", [i32], 32, (add CtlSysEFLAGS)> {
  let CopyCost = -1;  // Don't allow copying of status registers.
  let isAllocatable = 0;
}

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
def : SameSemantics<JO_4,  JO_1>;
def : SameSemantics<JNO_4, JNO_1>;
def : SameSemantics<JB_4,  JB_1>;
def : SameSemantics<JAE_4, JAE_1>;
def : SameSemantics<JE_4,  JE_1>;
def : SameSemantics<JNE_4, JNE_1>;
def : SameSemantics<JBE_4, JBE_1>;
def : SameSemantics<JA_4,  JA_1>;
def : SameSemantics<JS_4,  JS_1>;
def : SameSemantics<JNS_4, JNS_1>;
def : SameSemantics<JP_4,  JP_1>;
def : SameSemantics<JNP_4, JNP_1>;
def : SameSemantics<JL_4,  JL_1>;
def : SameSemantics<JGE_4, JGE_1>;
def : SameSemantics<JLE_4, JLE_1>;
def : SameSemantics<JG_4,  JG_1>;

def : SameSemantics<JMP_4, JMP_1>;

def : Semantics<CALL64pcrel32, [(X86call imm:$dst)]>;

def : Semantics<RETL, [(X86retflag 0)]>;
def : Semantics<RETQ, [(X86retflag 0)]>;

// Reverse encodings for arithmetic operations.
// We decode operands in reverse, so we can simply reuse semantics.
multiclass Sema_BinOpRR_Rev<string inst> {
  def : SameSemantics<!cast<I>(inst#8rr_REV),  !cast<I>(inst#8rr)>;
  def : SameSemantics<!cast<I>(inst#16rr_REV), !cast<I>(inst#16rr)>;
  def : SameSemantics<!cast<I>(inst#32rr_REV), !cast<I>(inst#32rr)>;
  def : SameSemantics<!cast<I>(inst#64rr_REV), !cast<I>(inst#64rr)>;
}

defm : Sema_BinOpRR_Rev<"AND">;
defm : Sema_BinOpRR_Rev<"OR">;
defm : Sema_BinOpRR_Rev<"XOR">;
defm : Sema_BinOpRR_Rev<"ADD">;
defm : Sema_BinOpRR_Rev<"SUB">;

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

// FIXME: we don't need these anymore?
// These should go away when we can do proper equivalence between inc->add
multiclass Sema_IncDec<string inst, SDNode op> {
  def : Sema_F_Str<inst#8r, (set GR8:$dst, (op GR8:$src1, 1))>;
  def : Sema_F_Str<inst#16r, (set GR16:$dst, (op GR16:$src1, 1))>;
  def : Sema_F_Str<inst#32r, (set GR32:$dst, (op GR32:$src1, 1))>;
  def : Sema_F_Str<inst#64r, (set GR64:$dst, (op GR64:$src1, 1))>;
  def : Sema_F_Str<inst#32r_alt, (set GR32:$dst, (op GR32:$src1, 1))>;
  def : Sema_F_Str<inst#16r_alt, (set GR16:$dst, (op GR16:$src1, 1))>;
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

def : Semantics<CMP8i8,   [(set EFLAGS, (X86cmp AL,  i8 :$src))]>;
def : Semantics<CMP16i16, [(set EFLAGS, (X86cmp AX,  i16:$src))]>;
def : Semantics<CMP32i32, [(set EFLAGS, (X86cmp EAX, i32:$src))]>;
def : Semantics<CMP64i32, [(set EFLAGS, (X86cmp RAX, i64:$src))]>;

def : Semantics<TEST8i8,   [(set EFLAGS, (X86testpat AL,  i8 :$src))]>;
def : Semantics<TEST16i16, [(set EFLAGS, (X86testpat AX,  i16:$src))]>;
def : Semantics<TEST32i32, [(set EFLAGS, (X86testpat EAX, i32:$src))]>;
def : Semantics<TEST64i32, [(set EFLAGS, (X86testpat RAX, i64:$src))]>;

def : Semantics<PUSH64r, [(store GR64:$reg, (sub RSP, 8)),
                          (set RSP, (sub RSP, 8))]>;
def : Semantics<PUSH64i32, [(store i64:$imm, (sub RSP, 8)),
                          (set RSP, (sub RSP, 8))]>;
def : Semantics<POP64r, [(set RSP, (add RSP, 8)),
                         (set GR64:$reg, (load (sub RSP, 8)))]>;
def : Semantics<POP64rmm, [(set RSP, (add RSP, 8)),
                           (store addr:$dst, (load (sub RSP, 8)))]>;

def : Semantics<PUSHF64, [(store EFLAGS, (sub RSP, 4)),
                          (set RSP, (sub RSP, 4))]>;
def : Semantics<POPF64, [(set RSP, (add RSP, 4)),
                         (set EFLAGS, (load (sub RSP, 4)))]>;

def : Semantics<MOV8rr,  [(set  GR8:$dst,  GR8:$src)]>;
def : Semantics<MOV16rr, [(set GR16:$dst, GR16:$src)]>;
def : Semantics<MOV32rr, [(set GR32:$dst, GR32:$src)]>;
def : Semantics<MOV64rr, [(set GR64:$dst, GR64:$src)]>;

def : Semantics<MOV32o64a, [(store EAX, offset64_32:$dst)]>;

class Sema_MOVX_m<Instruction inst, SDNode op, RegisterClass destRC, ValueType VT>
  : Semantics<inst, [(set destRC:$dst, (op (VT (load addr:$src))))]>;

def : Sema_MOVX_m<MOVZX16rm8,    zext, GR16, i8>;
def : Sema_MOVX_m<MOVZX32rm8,    zext, GR32, i8>;
def : Sema_MOVX_m<MOVZX32rm16,   zext, GR32, i16>;
def : Sema_MOVX_m<MOVZX64rm8,    zext, GR64, i8>;
def : Sema_MOVX_m<MOVZX64rm16,   zext, GR64, i16>;
def : Sema_MOVX_m<MOVSX16rm8,    sext, GR16, i8>;
def : Sema_MOVX_m<MOVSX32rm8,    sext, GR32, i8>;
def : Sema_MOVX_m<MOVSX32rm16,   sext, GR32, i16>;
def : Sema_MOVX_m<MOVSX64rm8,    sext, GR64, i8>;
def : Sema_MOVX_m<MOVSX64rm16,   sext, GR64, i16>;
def : Sema_MOVX_m<MOVSX64rm32,   sext, GR64, i32>;

def : Semantics<SHL8r1,   [(set GR8:$dst,   (shl GR8 :$src1, (i8 1)))]>;
def : Semantics<SHL16r1,  [(set GR16:$dst,  (shl GR16:$src1, (i16 1)))]>;
def : Semantics<SHL32r1,  [(set GR32:$dst,  (shl GR32:$src1, (i32 1)))]>;
def : Semantics<SHL64r1,  [(set GR64:$dst,  (shl GR64:$src1, (i64 1)))]>;

// FIXME: We could use custom SD opcodes for this kind of thing.
def : Semantics<CBW,  [(set AX,  (sext AL))]>;
def : Semantics<CWDE, [(set EAX, (sext AX))]>;
def : Semantics<CWD,  [(set DX,  (sra AX, (i16 15))), (set AX, AX)]>;
def : Semantics<CDQ,  [(set EDX, (sra EAX, (i32 31))), (set EAX, EAX)]>;
def : Semantics<CDQE, [(set RAX, (sext EAX))]>;
def : Semantics<CQO,  [(set RDX, (sra RAX, (i64 63))), (set RAX, RAX)]>;

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

def : Semantics<MOV64toPQIrr,
        [(set VR128:$dst, (insertelt (v2i64 VR128:$dst), GR64:$src, (i32 0)))]>;

def : Semantics<MOVDI2PDIrr,
        [(set VR128:$dst, (insertelt (v4i32 VR128:$dst), GR32:$src, (i32 0)))]>;
def : Semantics<MOVDI2PDIrm,
        [(set VR128:$dst, (insertelt (v4i32 VR128:$dst), (loadi32 addr:$src), (i32 0)))]>;
def : Semantics<MOVQI2PQIrm,
        [(set VR128:$dst, (insertelt (v2i64 VR128:$dst), (loadi64 addr:$src), (i32 0)))]>;

def : Semantics<CVTSS2SDrm, [(set FR64:$dst, (fextend (loadf32 addr:$src)))]>;

def : Semantics<MOVSDrr,
                        [(set VR128:$dst,
                          (insertelt (v2f64 VR128:$src1), FR64:$src2, (i32 0)))]>;

def : Semantics<MFENCE, [(atomic_fence /*Ordering=seq_cst*/7,
                                       /*SynchScope=cross_thread*/1)]>;
