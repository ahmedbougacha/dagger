# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPMASKMOVDYmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaskmovd	%ymm14, %ymm13, 2(%r11,%rbx,2)

## VPMASKMOVDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaskmovd	2(%r14,%r15,2), %ymm9, %ymm8

## VPMASKMOVDmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaskmovd	%xmm14, %xmm13, 2(%r11,%rbx,2)

## VPMASKMOVDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaskmovd	2(%r14,%r15,2), %xmm9, %xmm8

## VPMASKMOVQYmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaskmovq	%ymm14, %ymm13, 2(%r11,%rbx,2)

## VPMASKMOVQYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaskmovq	2(%r14,%r15,2), %ymm9, %ymm8

## VPMASKMOVQmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaskmovq	%xmm14, %xmm13, 2(%r11,%rbx,2)

## VPMASKMOVQrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaskmovq	2(%r14,%r15,2), %xmm9, %xmm8

retq
