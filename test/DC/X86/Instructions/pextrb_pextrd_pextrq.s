# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## PEXTRBmr
pextrb	$2, %xmm13, 2(%r11,%rbx,2)
## PEXTRBrr
pextrb	$2, %xmm9, %r8d
## PEXTRDmr
pextrd	$2, %xmm13, 2(%r11,%rbx,2)
## PEXTRDrr
pextrd	$2, %xmm9, %r8d
## PEXTRQmr
pextrq	$2, %xmm13, 2(%r11,%rbx,2)
## PEXTRQrr
pextrq	$2, %xmm9, %r11
retq
