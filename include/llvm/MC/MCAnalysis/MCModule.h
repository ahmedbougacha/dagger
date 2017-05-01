//===-- MCModule.h - MCModule class -----------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declaration of the MCModule class, which is used to
// represent a complete, disassembled object file or executable.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MC_MCANALYSIS_MCMODULE_H
#define LLVM_MC_MCANALYSIS_MCMODULE_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/iterator_range.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/DataTypes.h"
#include <memory>
#include <vector>

namespace llvm {

class MCBasicBlock;
class MCFunction;
class MCObjectDisassembler;

/// \brief A completely disassembled object file or executable.
/// An MCModule is created using MCObjectDisassembler::buildModule.
class MCModule {
  /// \name Function tracking
  /// @{
  typedef std::vector<std::unique_ptr<MCFunction>> FunctionListTy;
  FunctionListTy Functions;
  DenseMap<uint64_t, MCFunction *> FunctionsByAddr;
  /// @}

  MCModule           (const MCModule &) = delete;
  MCModule& operator=(const MCModule &) = delete;

  // MCObjectDisassembler creates MCModules.
  friend class MCObjectDisassembler;

public:
  MCModule();
  ~MCModule();

  /// \brief Create a new MCFunction.
  MCFunction *createFunction(StringRef Name, uint64_t StartAddr);

  MCFunction *findFunctionAt(uint64_t StartAddr);

  /// \name Access to the owned function list.
  /// @{
  size_t func_size() const { return Functions.size(); }
  // FIXME: Iterating on unique_ptrs is a pain, could it be hidden?
  typedef FunctionListTy::const_iterator const_func_iterator;
  typedef FunctionListTy::      iterator       func_iterator;
  const_func_iterator func_begin() const { return Functions.begin(); }
        func_iterator func_begin()       { return Functions.begin(); }
  const_func_iterator func_end()   const { return Functions.end(); }
        func_iterator func_end()         { return Functions.end(); }
  typedef iterator_range<func_iterator> func_iterator_range;
  typedef iterator_range<const_func_iterator> const_func_iterator_range;
  func_iterator_range funcs() {
    return func_iterator_range(func_begin(), func_end());
  }
  const_func_iterator_range funcs() const {
    return const_func_iterator_range(func_begin(), func_end());
  }
  /// @}
};

}

#endif
