# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VGATHERDPDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vgatherdpd	%ymm9, 2(%r15,%xmm13,2), %ymm8

## VGATHERDPDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vgatherdpd	%xmm9, 2(%r15,%xmm13,2), %xmm8

## VGATHERQPDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vgatherqpd	%ymm9, 2(%r15,%ymm13,2), %ymm8

## VGATHERQPDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vgatherqpd	%xmm9, 2(%r15,%xmm13,2), %xmm8

retq
