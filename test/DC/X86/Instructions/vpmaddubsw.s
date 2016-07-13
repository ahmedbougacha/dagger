# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPMADDUBSWrm128
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaddubsw	2(%r14,%r15,2), %xmm9, %xmm8

## VPMADDUBSWrm256
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaddubsw	2(%r14,%r15,2), %ymm9, %ymm8

## VPMADDUBSWrr128
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaddubsw	%xmm10, %xmm9, %xmm8

## VPMADDUBSWrr256
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmaddubsw	%ymm10, %ymm9, %ymm8

retq
