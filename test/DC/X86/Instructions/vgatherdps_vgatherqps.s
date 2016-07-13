# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VGATHERDPSYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vgatherdps	%ymm9, 2(%r15,%ymm13,2), %ymm8

## VGATHERDPSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vgatherdps	%xmm9, 2(%r15,%xmm13,2), %xmm8

## VGATHERQPSYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vgatherqps	%xmm9, 2(%r15,%ymm13,2), %xmm8

## VGATHERQPSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vgatherqps	%xmm9, 2(%r15,%xmm13,2), %xmm8

retq
