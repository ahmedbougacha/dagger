# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## MMX_PEXTRWirri
pextrw	$2, %mm5, %r8d
## PEXTRWmr
pextrw	$2, %xmm13, 2(%r11,%rbx,2)
## PEXTRWri
pextrw	$2, %xmm9, %r8d
## PEXTRWrr_REV:	pextrw	$2, %xmm9, %r8d
.byte 0x66; .byte 0x45; .byte 0x0f; .byte 0x3a; .byte 0x15; .byte 0xc8; .byte 0x02
retq
