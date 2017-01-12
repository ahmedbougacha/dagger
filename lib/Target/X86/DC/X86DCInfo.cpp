#include "X86DCFunction.h"
#include "X86RegisterSema.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

DCFunction *createX86DCFunction(StringRef TT, DCRegisterSema &DRS,
                                const MCRegisterInfo &MRI,
                                const MCInstrInfo &MII) {
  (void)MRI;
  (void)MII;
  return new X86DCFunction(DRS);
}

DCRegisterSema *createX86DCRegisterSema(StringRef TT,
                                        LLVMContext &Ctx,
                                        const MCRegisterInfo &MRI,
                                        const MCInstrInfo &MII,
                                        const DataLayout &DL) {
  return new X86RegisterSema(Ctx, MRI, MII, DL);
}

// Force static initialization.
extern "C" void LLVMInitializeX86TargetDC() {
  // These are only available for x86_64:
  // Register the DC instruction semantic info.
  TargetRegistry::RegisterDCFunction(getTheX86_64Target(), createX86DCFunction);

  // Register the DC register semantic info.
  TargetRegistry::RegisterDCRegisterSema(getTheX86_64Target(),
                                         createX86DCRegisterSema);

}
