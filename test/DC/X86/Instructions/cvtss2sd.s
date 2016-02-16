# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## CVTSS2SDrm
cvtss2sd	2(%rbx,%r14,2), %xmm8
## CVTSS2SDrr
cvtss2sd	%xmm9, %xmm8
retq
