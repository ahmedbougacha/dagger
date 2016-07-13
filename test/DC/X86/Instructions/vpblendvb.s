# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPBLENDVBYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpblendvb	%ymm15, 2(%r14,%r15,2), %ymm9, %ymm8

## VPBLENDVBYrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpblendvb	%ymm11, %ymm10, %ymm9, %ymm8

## VPBLENDVBrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpblendvb	%xmm15, 2(%r14,%r15,2), %xmm9, %xmm8

## VPBLENDVBrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpblendvb	%xmm11, %xmm10, %xmm9, %xmm8

retq
