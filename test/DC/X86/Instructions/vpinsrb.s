# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## VPINSRBrm
vpinsrb	$2, 2(%r14,%r15,2), %xmm9, %xmm8
## VPINSRBrr
vpinsrb	$2, %r10d, %xmm9, %xmm8
retq
