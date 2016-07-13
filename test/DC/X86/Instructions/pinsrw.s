# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## MMX_PINSRWirmi
pinsrw	$2, 2(%r14,%r15,2), %mm4
## MMX_PINSRWirri
pinsrw	$2, %r10d, %mm4
## PINSRWrmi
pinsrw	$2, 2(%r14,%r15,2), %xmm8
## PINSRWrri
pinsrw	$2, %r10d, %xmm8
retq
