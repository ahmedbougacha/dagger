# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## POP16r
popw	%r8w
## POP16rmm
popw	2(%r11,%rbx,2)
## POP16rmr:	popw	%r8w
.byte 0x66; .byte 0x41; .byte 0x8f; .byte 0xc0
## POP64r
popq	%r11
## POP64rmm
popq	2(%r11,%rbx,2)
## POP64rmr:	popq	%r11
.byte 0x41; .byte 0x8f; .byte 0xc3
## POPFS16
popw	%fs
## POPFS64
popq	%fs
## POPGS16
popw	%gs
## POPGS64
popq	%gs
retq
