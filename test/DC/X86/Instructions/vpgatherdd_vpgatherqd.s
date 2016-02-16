# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPGATHERDDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpgatherdd	%ymm9, 2(%r15,%ymm13,2), %ymm8

## VPGATHERDDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpgatherdd	%xmm9, 2(%r15,%xmm13,2), %xmm8

## VPGATHERQDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpgatherqd	%xmm9, 2(%r15,%ymm13,2), %xmm8

## VPGATHERQDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpgatherqd	%xmm9, 2(%r15,%xmm13,2), %xmm8

retq
