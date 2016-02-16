# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VCVTSI2SS64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtsi2ssq	2(%r14,%r15,2), %xmm9, %xmm8

## VCVTSI2SS64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtsi2ssq	%r14, %xmm9, %xmm8

## VCVTSI2SSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtsi2ssl	2(%r14,%r15,2), %xmm9, %xmm8

## VCVTSI2SSrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtsi2ssl	%r10d, %xmm9, %xmm8

retq
