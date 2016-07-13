# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## SHUFPDrmi
shufpd	$2, 2(%r14,%r15,2), %xmm8
## SHUFPDrri
shufpd	$2, %xmm10, %xmm8
retq
