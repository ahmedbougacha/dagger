# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPMACSSDQHrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmacssdqh	%xmm15, 2(%r14,%r15,2), %xmm9, %xmm8

## VPMACSSDQHrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vpmacssdqh	%xmm11, %xmm10, %xmm9, %xmm8

retq
