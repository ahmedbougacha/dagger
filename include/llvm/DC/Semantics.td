// Declare that pattern represents the semantics of inst.
class Semantics<Instruction inst, list<dag> pattern> {
  list<dag> Pattern = pattern;
  Instruction Inst = inst;
}

// Declare an equivalence between 2 SDNodes, where the target specific one
// can produce less results: this is useful for cases like X86op_flag, where
// we can't always use the target-specific version (that defines the EFLAGS
// register) when the result is stored to memory, so some patterns have the
// target-specific version, while others have the target-independent version.
// Since we have to support the target-independent version no matter what,
// just replace all instances of the target-specific with it.
class SDNodeEquiv<SDNode targetSpecific, SDNode targetIndependent> {
  SDNode TargetSpecific = targetSpecific;
  SDNode TargetIndependent = targetIndependent;
}

// Re-use the semantics of semainst for inst.
// FIXME: Use the actual semantics instead of just the pattern.
class SameSemantics<Instruction inst, Instruction semainst>
  : Semantics<inst, semainst.Pattern>;
