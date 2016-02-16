# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## VPINSRQrm
vpinsrq	$2, 2(%r14,%r15,2), %xmm9, %xmm8
## VPINSRQrr
vpinsrq	$2, %r14, %xmm9, %xmm8
retq
