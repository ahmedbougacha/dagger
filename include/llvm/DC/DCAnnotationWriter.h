#ifndef DCANNOTATIONWRITER_H
#define DCANNOTATIONWRITER_H

#include "llvm/DC/DCTranslatedInstTracker.h"
#include "llvm/IR/AssemblyAnnotationWriter.h"

namespace llvm {
class MCInstPrinter;
class MCModule;
class MCRegisterInfo;

class DCAnnotationWriter : public AssemblyAnnotationWriter {
  const DCTranslatedInstTracker &DTIT;
  const MCRegisterInfo &MRI;
  MCInstPrinter &IP;

public:
  DCAnnotationWriter(const DCTranslatedInstTracker &DTIT,
                     const MCRegisterInfo &MRI, MCInstPrinter &IP);

  // Only for instructions, we don't care about global values
  void printInfoComment(const Value &, formatted_raw_ostream &) override;
  void emitInstructionAnnot(const Instruction *,
                            formatted_raw_ostream &) override;
};

} // end namespace llvm

#endif
