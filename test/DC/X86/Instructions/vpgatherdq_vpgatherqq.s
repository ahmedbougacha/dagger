# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPGATHERDQYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpgatherdq	%ymm9, 2(%r15,%xmm13,2), %ymm8

## VPGATHERDQrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpgatherdq	%xmm9, 2(%r15,%xmm13,2), %xmm8

## VPGATHERQQYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpgatherqq	%ymm9, 2(%r15,%ymm13,2), %ymm8

## VPGATHERQQrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpgatherqq	%xmm9, 2(%r15,%xmm13,2), %xmm8

retq
