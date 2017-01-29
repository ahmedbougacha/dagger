#include "X86DCTranslator.h"
#include "MCTargetDesc/X86MCTargetDesc.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

static DCTranslator *createX86DCTranslator(const Triple &TT, LLVMContext &Ctx,
                                           const DataLayout &DL,
                                           unsigned OptLevel,
                                           const MCInstrInfo &MII,
                                           const MCRegisterInfo &MRI) {
  (void)TT;
  return new X86DCTranslator(Ctx, DL, OptLevel, MII, MRI);
}

// Force static initialization.
extern "C" void LLVMInitializeX86TargetDC() {
  // This is only available for x86_64:
  // Register the DC instruction semantic info.
  TargetRegistry::RegisterDCTranslator(getTheX86_64Target(),
                                       createX86DCTranslator);
}
