# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VBLENDVPDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vblendvpd	%ymm15, 2(%r14,%r15,2), %ymm9, %ymm8

## VBLENDVPDYrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vblendvpd	%ymm11, %ymm10, %ymm9, %ymm8

## VBLENDVPDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vblendvpd	%xmm15, 2(%r14,%r15,2), %xmm9, %xmm8

## VBLENDVPDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vblendvpd	%xmm11, %xmm10, %xmm9, %xmm8

retq
