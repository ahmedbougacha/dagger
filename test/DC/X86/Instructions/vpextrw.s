# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## VPEXTRWmr
vpextrw	$2, %xmm13, 2(%r11,%rbx,2)
## VPEXTRWri
vpextrw	$2, %xmm9, %r8d
## VPEXTRWrr_REV:	vpextrw	$2, %xmm9, %r8d
.byte 0xc4; .byte 0x43; .byte 0x79; .byte 0x15; .byte 0xc8; .byte 0x02
retq
