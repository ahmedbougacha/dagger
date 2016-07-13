# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## SBB16i16
sbbw	$305419896, %ax
## SBB16mi
sbbw	$305419896, 2(%r11,%rbx,2)
## SBB16mi8
sbbw	$2, 2(%r11,%rbx,2)
## SBB16mr
sbbw	%r15w, 2(%r11,%rbx,2)
## SBB16ri
sbbw	$305419896, %r8w
## SBB16ri8
sbbw	$2, %r8w
## SBB16rm
sbbw	2(%r14,%r15,2), %r8w
## SBB16rr
sbbw	%r10w, %r8w
## SBB16rr_REV:	sbbw	%r10w, %r8w
.byte 0x66; .byte 0x45; .byte 0x1b; .byte 0xc2
## SBB32i32
sbbl	$305419896, %eax
## SBB32mi
sbbl	$305419896, 2(%r11,%rbx,2)
## SBB32mi8
sbbl	$2, 2(%r11,%rbx,2)
## SBB32mr
sbbl	%r15d, 2(%r11,%rbx,2)
## SBB32ri
sbbl	$305419896, %r8d
## SBB32ri8
sbbl	$2, %r8d
## SBB32rm
sbbl	2(%r14,%r15,2), %r8d
## SBB32rr
sbbl	%r10d, %r8d
## SBB32rr_REV:	sbbl	%r10d, %r8d
.byte 0x45; .byte 0x1b; .byte 0xc2
## SBB64i32
sbbq	$305419896, %rax
## SBB64mi32
sbbq	$305419896, 2(%r11,%rbx,2)
## SBB64mi8
sbbq	$2, 2(%r11,%rbx,2)
## SBB64mr
sbbq	%r13, 2(%r11,%rbx,2)
## SBB64ri32
sbbq	$305419896, %r11
## SBB64ri8
sbbq	$2, %r11
## SBB64rm
sbbq	2(%r14,%r15,2), %r11
## SBB64rr
sbbq	%r14, %r11
## SBB64rr_REV:	sbbq	%r14, %r11
.byte 0x4d; .byte 0x1b; .byte 0xde
## SBB8i8
sbbb	$2, %al
## SBB8mi
sbbb	$2, 2(%r11,%rbx,2)
## SBB8mr
sbbb	%r11b, 2(%r11,%rbx,2)
## SBB8ri
sbbb	$2, %bpl
## SBB8rm
sbbb	2(%r14,%r15,2), %bpl
## SBB8rr
sbbb	%r8b, %bpl
## SBB8rr_REV:	sbbb	%r8b, %bpl
.byte 0x41; .byte 0x1a; .byte 0xe8
retq
