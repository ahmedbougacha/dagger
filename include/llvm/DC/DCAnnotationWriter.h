//===-- llvm/DC/DCAnnotationWriter.h - DC IR Annotation ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the DCAnnotationWriter class, which is an implementation
// of an IR AssemblyAnnotationWriter, that uses DC translation information
// (represented by a DCTranslatedInstTracker) to annotate LLVM IR assembly
// output with a textual description of the origin of some of the instructions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_DC_DCANNOTATIONWRITER_H
#define LLVM_DC_DCANNOTATIONWRITER_H

#include "llvm/DC/DCTranslatedInstTracker.h"
#include "llvm/IR/AssemblyAnnotationWriter.h"

namespace llvm {
class MCInstPrinter;
class MCModule;
class MCRegisterInfo;
class MCSubtargetInfo;

class DCAnnotationWriter : public AssemblyAnnotationWriter {
  const DCTranslatedInstTracker &DTIT;
  const MCRegisterInfo &MRI;
  MCInstPrinter &IP;
  const MCSubtargetInfo &STI;

public:
  DCAnnotationWriter(const DCTranslatedInstTracker &DTIT,
                     const MCRegisterInfo &MRI, MCInstPrinter &IP,
                     const MCSubtargetInfo &STI);

  // Only for instructions, we don't care about global values
  void printInfoComment(const Value &, formatted_raw_ostream &) override;
  void emitInstructionAnnot(const Instruction *,
                            formatted_raw_ostream &) override;
};

} // end namespace llvm

#endif
