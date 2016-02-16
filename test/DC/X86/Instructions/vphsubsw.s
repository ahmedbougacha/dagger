# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPHSUBSWrm128
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vphsubsw	2(%r14,%r15,2), %xmm9, %xmm8

## VPHSUBSWrm256
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vphsubsw	2(%r14,%r15,2), %ymm9, %ymm8

## VPHSUBSWrr128
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vphsubsw	%xmm10, %xmm9, %xmm8

## VPHSUBSWrr256
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vphsubsw	%ymm10, %ymm9, %ymm8

retq
