//===- llvm/MC/MCRelocationInfo.h -------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the MCRelocationInfo class, which provides methods to
// create MCExprs from relocations, either found in an object::ObjectFile
// (object::RelocationRef), or provided through the C API.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_MC_MCDISASSEMBLER_MCRELOCATIONINFO_H
#define LLVM_MC_MCDISASSEMBLER_MCRELOCATIONINFO_H

#include "llvm/Support/Compiler.h"
#include "llvm/Support/Error.h"

namespace llvm {

class MCContext;
class MCExpr;

/// \brief Create MCExprs from relocations found in an object file.
class MCRelocationInfo {
protected:
  MCContext &Ctx;

public:
  MCRelocationInfo(MCContext &Ctx);
  MCRelocationInfo(const MCRelocationInfo &) = delete;
  MCRelocationInfo &operator=(const MCRelocationInfo &) = delete;
  virtual ~MCRelocationInfo();

  /// \brief Create an MCExpr for the relocation \p Rel.
  /// \returns If possible, an MCExpr corresponding to Rel, else 0.
  virtual Expected<const MCExpr *>
  createExprForRelocation(object::RelocationRef Rel);

  /// \brief Create an MCExpr for the target-specific \p VariantKind.
  /// The VariantKinds are defined in llvm-c/Disassembler.h.
  /// Used by MCExternalSymbolizer.
  /// \returns If possible, an MCExpr corresponding to VariantKind, else 0.
  virtual Expected<const MCExpr *>
  createExprForCAPIVariantKind(const MCExpr *SubExpr, unsigned VariantKind);
};

} // end namespace llvm

#endif // LLVM_MC_MCDISASSEMBLER_MCRELOCATIONINFO_H
