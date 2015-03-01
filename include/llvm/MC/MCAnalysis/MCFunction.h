//===-- MCFunction.h --------------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the data structures to hold a CFG reconstructed from
// machine code.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MC_MCANALYSIS_MCFUNCTION_H
#define LLVM_MC_MCANALYSIS_MCFUNCTION_H

#include "llvm/ADT/StringRef.h"
#include "llvm/MC/MCInst.h"
#include <list>
#include <string>
#include <vector>

namespace llvm {

class MCFunction;
class MCModule;

// FIXME: Both the Address and Size field are actually redundant when taken in
// the context of the basic block, and may better be exposed in an iterator
// instead of stored in the basic block, which would replace this class.
/// \brief An entry in an MCBasicBlock: a disassembled instruction.
class MCDecodedInst {
public:
  MCInst Inst;
  uint64_t Address;
  uint64_t Size;
  MCDecodedInst(const MCInst &Inst, uint64_t Address, uint64_t Size)
    : Inst(Inst), Address(Address), Size(Size) {}
};

/// \brief Basic block containing a sequence of disassembled instructions.
/// Create a basic block using MCFunction::createBlock.
class MCBasicBlock {
  typedef std::vector<MCDecodedInst> InstListTy;
  InstListTy Insts;

  std::string Name;
  uint64_t StartAddr, SizeInBytes;
  uint64_t InstCount;

  /// \brief The address of the next appended instruction, i.e., the
  /// address immediately after the last instruction in the block.
  uint64_t NextInstAddress;

  // MCFunction owns the basic block.
  MCFunction *Parent;

  // MCFunction owns the basic block.
  friend class MCFunction;
  // MCObjectDisassembler fills in the basic block.
  friend class MCObjectDisassembler;

  MCBasicBlock(uint64_t StartAddr, MCFunction *Parent);

  /// \name Predecessors/Successors, to represent the CFG.
  /// @{
  typedef std::vector<const MCBasicBlock *> BasicBlockListTy;
  BasicBlockListTy Successors;
  BasicBlockListTy Predecessors;
  /// @}
public:
  /// Append an instruction.
  void addInst(const MCInst &Inst, uint64_t InstSize);

  /// \brief Get the start address of the block.
  uint64_t getStartAddr() const { return StartAddr; }
  /// \brief Get the address one byte past the end of the block.
  uint64_t getEndAddr() const { return StartAddr + SizeInBytes; }
  /// \brief Get the size of the block.
  uint64_t getSizeInBytes() const { return SizeInBytes; }

  /// \name Instruction list access
  /// @{
  typedef InstListTy::const_iterator const_iterator;
  const_iterator begin() const { return Insts.begin(); }
  const_iterator end()   const { return Insts.end(); }

  const MCDecodedInst &back() const { return Insts.back(); }
  size_t size() const { return InstCount; }
  /// @}

  /// \name Get the owning MCFunction.
  /// @{
  const MCFunction *getParent() const { return Parent; }
        MCFunction *getParent()       { return Parent; }
  /// @}

  /// MC CFG access: Predecessors/Successors.
  /// @{
  typedef BasicBlockListTy::const_iterator succ_const_iterator;
  succ_const_iterator succ_begin() const { return Successors.begin(); }
  succ_const_iterator succ_end()   const { return Successors.end(); }

  typedef BasicBlockListTy::const_iterator pred_const_iterator;
  pred_const_iterator pred_begin() const { return Predecessors.begin(); }
  pred_const_iterator pred_end()   const { return Predecessors.end(); }

  void addSuccessor(const MCBasicBlock *MCBB);
  bool isSuccessor(const MCBasicBlock *MCBB) const;

  void addPredecessor(const MCBasicBlock *MCBB);
  bool isPredecessor(const MCBasicBlock *MCBB) const;
  /// @}
};

/// \brief Represents a function in machine code, containing MCBasicBlocks.
/// MCFunctions are created by MCModule.
class MCFunction {
  MCFunction           (const MCFunction&) = delete;
  MCFunction& operator=(const MCFunction&) = delete;

  std::string Name;
  MCModule *ParentModule;
  typedef std::vector<MCBasicBlock *> BasicBlockListTy;
  BasicBlockListTy Blocks;

  // MCModule owns the function.
  friend class MCModule;
  MCFunction(StringRef Name, MCModule *Parent);

  // MCObjectDisassembler fills in the function.
  friend class MCObjectDisassembler;

public:
  ~MCFunction();

  /// \brief Create an MCBasicBlock backed by Insts and add it to this function.
  /// \param Insts Sequence of straight-line code backing the basic block.
  /// \returns The newly created basic block.
  MCBasicBlock &createBlock(uint64_t StartAddr);

  StringRef getName() const { return Name; }

  /// \name Get the owning MC Module.
  /// @{
  const MCModule *getParent() const { return ParentModule; }
        MCModule *getParent()       { return ParentModule; }
  /// @}

  /// \name Access to the function's basic blocks. No ordering is enforced,
  /// except that the first block is the entry block.
  /// @{
  /// \brief Get the entry point basic block.
  const MCBasicBlock *getEntryBlock() const { return front(); }
        MCBasicBlock *getEntryBlock()       { return front(); }

  bool empty() const { return Blocks.empty(); }
  size_t size() const { return Blocks.size(); }

  typedef BasicBlockListTy::const_iterator const_iterator;
  typedef BasicBlockListTy::      iterator       iterator;
  const_iterator begin() const { return Blocks.begin(); }
        iterator begin()       { return Blocks.begin(); }
  const_iterator   end() const { return Blocks.end(); }
        iterator   end()       { return Blocks.end(); }

  const MCBasicBlock* front() const { return Blocks.front(); }
        MCBasicBlock* front()       { return Blocks.front(); }
  const MCBasicBlock*  back() const { return Blocks.back(); }
        MCBasicBlock*  back()       { return Blocks.back(); }

  /// \brief Find the basic block, if any, that starts at \p StartAddr.
  const MCBasicBlock *find(uint64_t StartAddr) const;
        MCBasicBlock *find(uint64_t StartAddr);

  /// \brief Find the basic block, if any, that contains \p Addr.
  const MCBasicBlock *findContaining(uint64_t Addr) const;
        MCBasicBlock *findContaining(uint64_t Addr);

  /// \brief Find the first basic block, if any, that follows \p Addr.
  const MCBasicBlock *findFirstAfter(uint64_t Addr) const;
        MCBasicBlock *findFirstAfter(uint64_t Addr);
  /// @}
};

}

#endif
