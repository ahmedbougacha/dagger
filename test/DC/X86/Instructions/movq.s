# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## MMX_MOVQ2DQrr
movq2dq	%mm5, %xmm8
## MMX_MOVQ64mr
movq	%mm1, 2(%r11,%rbx,2)
## MMX_MOVQ64rm
movq	2(%rbx,%r14,2), %mm4
## MMX_MOVQ64rr
movq	%mm5, %mm4
## MMX_MOVQ64rr_REV:	movq	%mm5, %mm4
.byte 0x0f; .byte 0x7f; .byte 0xec
## MOV64toPQIrm:	movd	2(%rbx,%r14,2), %xmm8
.byte 0x66; .byte 0x4e; .byte 0x0f; .byte 0x6e; .byte 0x44; .byte 0x73; .byte 0x02
## MOV64toPQIrr
movd	%rbx, %xmm8
## MOVPQI2QImr
movq	%xmm13, 2(%r11,%rbx,2)
## MOVPQI2QIrr:	movq	%xmm9, %xmm8
.byte 0x66; .byte 0x45; .byte 0x0f; .byte 0xd6; .byte 0xc8
## MOVPQIto64rm:	movd	%xmm13, 2(%r11,%rbx,2)
.byte 0x66; .byte 0x4d; .byte 0x0f; .byte 0x7e; .byte 0x6c; .byte 0x5b; .byte 0x02
## MOVPQIto64rr
movd	%xmm9, %r11
## MOVQI2PQIrm
movq	2(%rbx,%r14,2), %xmm8
## MOVZPQILo2PQIrr
movq	%xmm9, %xmm8
retq
