#include "X86InstrSema.h"
#include "X86RegisterSema.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

DCInstrSema *createX86DCInstrSema(StringRef TT,
                                  DCRegisterSema &DRS,
                                  const MCRegisterInfo &MRI,
                                  const MCInstrInfo &MII) {
  (void)MRI;
  (void)MII;
  return new X86InstrSema(DRS);
}

DCRegisterSema *createX86DCRegisterSema(StringRef TT,
                                        const MCRegisterInfo &MRI,
                                        const MCInstrInfo &MII) {
  return new X86RegisterSema(MRI, MII);
}

// Force static initialization.
extern "C" void LLVMInitializeX86TargetDC() {
  // These are only available for x86_64:
  // Register the DC instruction semantic info.
  TargetRegistry::RegisterDCInstrSema(TheX86_64Target,
                                      createX86DCInstrSema);

  // Register the DC register semantic info.
  TargetRegistry::RegisterDCRegisterSema(TheX86_64Target,
                                         createX86DCRegisterSema);

}
