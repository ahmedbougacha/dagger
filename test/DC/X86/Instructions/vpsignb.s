# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPSIGNBYrm256
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpsignb	2(%r14,%r15,2), %ymm9, %ymm8

## VPSIGNBYrr256
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpsignb	%ymm10, %ymm9, %ymm8

## VPSIGNBrm128
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpsignb	2(%r14,%r15,2), %xmm9, %xmm8

## VPSIGNBrr128
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpsignb	%xmm10, %xmm9, %xmm8

retq
