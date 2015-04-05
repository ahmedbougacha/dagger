===================================================================
The Semantics Emitter TableGen Backend
===================================================================

This tablegen backend is responsible for emitting a description of the
instruction-level semantics of the target instruction set.

This takes semantics expressed as patterns, and generates a table used to
drive IR generation.

The patterns come from a few sources:
- The Pattern field in the Instruction class.
- Instances of a class named "Semantics", containing 2 fields, the
  Instruction and the Pattern to be used for that instruction. These
  override the Instruction.Pattern field.

This backend generates a main table, an unsigned[], containing a sequence
of "operations". An operation looks like this:

.. code-block:: c++

  <opcode>  <result type(s)> <operand(s)>
  ISD::ADD,        MVT::i32,        0, 1,

The opcode is either an ISD opcode (including target-specific ones), or one
of a few other opcodes, mostly for register manipulation; these are in
the "DCINS" namespace.

Each operation defines one or several results, the types of which are the
next values in the array, as defined by the MVT::SimpleValueType enum.

Another table provides the offset, in the semantics table, of the first
operation for an MC instruction opcode:

.. code-block:: c++

  const unsigned OpcodeToSemaIdx[] = {
    ...
    965,      // ADD32rm
    987,      // ADD32rr
    ...
  };

  const unsigned InstSemantics[] = {
    ...
    // ADD32rm
    DCINS::GET_RC, MVT::i32, 1,
    DCINS::CUSTOM_OP, MVT::iPTR, X86::OpTypes::i32mem, 2,
    ISD::LOAD, MVT::i32, 1,
    ISD::ADD, MVT::i32, 0, 2,
    DCINS::PUT_RC, MVT::isVoid, 0, 3,
    DCINS::IMPLICIT, MVT::isVoid, X86::EFLAGS,
    DCINS::END_OF_INSTRUCTION,
    // ADD32rr
    DCINS::GET_RC, MVT::i32, 1,
    DCINS::GET_RC, MVT::i32, 2,
    ISD::ADD, MVT::i32, 0, 1,
    DCINS::PUT_RC, MVT::isVoid, 0, 2,
    DCINS::IMPLICIT, MVT::isVoid, X86::EFLAGS,
    DCINS::END_OF_INSTRUCTION,
    ...
  };

The values defined in an instruction (until the final
DCINS::END_OF_INSTRUCTION marker) are kept track of using their index.
Operands usually reference the values in the array. For some of the DCINS
opcodes, the operands are interpreted in a special way:

.. code-block:: c++

    // ADD32rr
    DCINS::GET_RC, MVT::i32, 1, // %0 = i32 <get reg from MC operand #1>
    DCINS::GET_RC, MVT::i32, 2, // %1 = i32 <get reg from MC operand #2>
    ISD::ADD, MVT::i32, 0, 1,   // %2 = add i32 %0, %1
    DCINS::PUT_RC, MVT::isVoid, 0, 2, // <put %2 in reg from MC operand #0>
    DCINS::IMPLICIT, MVT::isVoid, X86::EFLAGS, // <imp-def EFLAGS>
    DCINS::END_OF_INSTRUCTION,

Something else to consider is the SDNodeEquiv class: it enables targets to
define an equivalence between a target-specific and a target-independent
SDNode, where the only difference is trailing implicitly defined registers.
This happens a lot, for instance on X86, where 'X86add_flag' is equivalent
to 'add', but it generates a 2nd result, EFLAGS.
