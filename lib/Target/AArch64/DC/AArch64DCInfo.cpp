#include "AArch64DCFunction.h"
#include "AArch64RegisterSema.h"
#include "MCTargetDesc/AArch64MCTargetDesc.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

DCFunction *createAArch64DCFunction(StringRef TT, DCRegisterSema &DRS,
                                    const MCRegisterInfo &MRI,
                                    const MCInstrInfo &MII) {
  (void)MRI;
  (void)MII;
  return new AArch64DCFunction(DRS);
}

DCRegisterSema *createAArch64DCRegisterSema(StringRef TT, LLVMContext &Ctx,
                                            const MCRegisterInfo &MRI,
                                            const MCInstrInfo &MII,
                                            const DataLayout &DL) {
  return new AArch64RegisterSema(Ctx, MRI, MII, DL);
}

// Force static initialization.
extern "C" void LLVMInitializeAArch64TargetDC() {
  // These are only available for LE AArch64:
  // Register the DC instruction semantic info.
  TargetRegistry::RegisterDCFunction(getTheAArch64leTarget(),
                                     createAArch64DCFunction);

  // Register the DC register semantic info.
  TargetRegistry::RegisterDCRegisterSema(getTheAArch64leTarget(),
                                         createAArch64DCRegisterSema);
}
