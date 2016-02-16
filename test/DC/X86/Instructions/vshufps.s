# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## VSHUFPSYrmi
vshufps	$2, 2(%r14,%r15,2), %ymm9, %ymm8
## VSHUFPSYrri
vshufps	$2, %ymm10, %ymm9, %ymm8
## VSHUFPSrmi
vshufps	$2, 2(%r14,%r15,2), %xmm9, %xmm8
## VSHUFPSrri
vshufps	$2, %xmm10, %xmm9, %xmm8
retq
