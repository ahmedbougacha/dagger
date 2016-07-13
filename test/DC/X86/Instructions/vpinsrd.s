# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## VPINSRDrm
vpinsrd	$2, 2(%r14,%r15,2), %xmm9, %xmm8
## VPINSRDrr
vpinsrd	$2, %r10d, %xmm9, %xmm8
retq
