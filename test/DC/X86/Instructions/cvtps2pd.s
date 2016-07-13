# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## CVTPS2PDrm
cvtps2pd	2(%rbx,%r14,2), %xmm8
## CVTPS2PDrr
cvtps2pd	%xmm9, %xmm8
retq
