#include "AArch64DCTranslator.h"
#include "MCTargetDesc/AArch64MCTargetDesc.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

static DCTranslator *
createAArch64DCTranslator(const Triple &TT, LLVMContext &Ctx,
                          const DataLayout &DL, unsigned OptLevel,
                          const MCInstrInfo &MII, const MCRegisterInfo &MRI) {
  (void)TT;
  return new AArch64DCTranslator(Ctx, DL, OptLevel, MII, MRI);
}

// Force static initialization.
extern "C" void LLVMInitializeAArch64TargetDC() {
  // This is only available for LE AArch64:
  // Register the DC instruction semantic info.
  TargetRegistry::RegisterDCTranslator(getTheAArch64leTarget(),
                                       createAArch64DCTranslator);
}
