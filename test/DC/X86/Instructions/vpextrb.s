# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## VPEXTRBmr
vpextrb	$2, %xmm13, 2(%r11,%rbx,2)
## VPEXTRBrr
vpextrb	$2, %xmm9, %r8d
retq
