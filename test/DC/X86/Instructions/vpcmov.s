# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPCMOVrmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpcmov	%xmm15, 2(%r14,%r15,2), %xmm9, %xmm8

## VPCMOVrmrY
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpcmov	%ymm15, 2(%r14,%r15,2), %ymm9, %ymm8

## VPCMOVrrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpcmov	2(%r15,%r12,2), %xmm10, %xmm9, %xmm8

## VPCMOVrrmY
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpcmov	2(%r15,%r12,2), %ymm10, %ymm9, %ymm8

## VPCMOVrrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpcmov	%xmm11, %xmm10, %xmm9, %xmm8

## VPCMOVrrrY
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpcmov	%ymm11, %ymm10, %ymm9, %ymm8

## VPCMOVrrrY_REV:	vpcmov	%ymm11, %ymm10, %ymm9, %ymm8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x8f; .byte 0x48; .byte 0xb4; .byte 0xa2; .byte 0xc3; .byte 0xa0

## VPCMOVrrr_REV:	vpcmov	%xmm11, %xmm10, %xmm9, %xmm8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x8f; .byte 0x48; .byte 0xb0; .byte 0xa2; .byte 0xc3; .byte 0xa0

retq
