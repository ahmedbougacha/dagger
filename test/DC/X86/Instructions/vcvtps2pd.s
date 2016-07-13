# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## VCVTPS2PDYrm
vcvtps2pd	2(%rbx,%r14,2), %ymm8
## VCVTPS2PDYrr
vcvtps2pd	%xmm9, %ymm8
## VCVTPS2PDrm
vcvtps2pd	2(%rbx,%r14,2), %xmm8
## VCVTPS2PDrr
vcvtps2pd	%xmm9, %xmm8
retq
