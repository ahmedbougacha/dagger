# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VROUNDSDm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vroundsd	$2, 2(%r14,%r15,2), %xmm9, %xmm8

## VROUNDSDr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vroundsd	$2, %xmm10, %xmm9, %xmm8

retq
