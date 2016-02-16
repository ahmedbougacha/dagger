# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## VSHUFPDYrmi
vshufpd	$2, 2(%r14,%r15,2), %ymm9, %ymm8
## VSHUFPDYrri
vshufpd	$2, %ymm10, %ymm9, %ymm8
## VSHUFPDrmi
vshufpd	$2, 2(%r14,%r15,2), %xmm9, %xmm8
## VSHUFPDrri
vshufpd	$2, %xmm10, %xmm9, %xmm8
retq
