# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## PINSRBrm
pinsrb	$2, 2(%r14,%r15,2), %xmm8
## PINSRBrr
pinsrb	$2, %r10d, %xmm8
## PINSRDrm
pinsrd	$2, 2(%r14,%r15,2), %xmm8
## PINSRDrr
pinsrd	$2, %r10d, %xmm8
## PINSRQrm
pinsrq	$2, 2(%r14,%r15,2), %xmm8
## PINSRQrr
pinsrq	$2, %r14, %xmm8
retq
