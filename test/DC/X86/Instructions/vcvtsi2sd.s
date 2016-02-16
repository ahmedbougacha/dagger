# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VCVTSI2SD64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtsi2sdq	2(%r14,%r15,2), %xmm9, %xmm8

## VCVTSI2SD64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtsi2sdq	%r14, %xmm9, %xmm8

## VCVTSI2SDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtsi2sdl	2(%r14,%r15,2), %xmm9, %xmm8

## VCVTSI2SDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtsi2sdl	%r10d, %xmm9, %xmm8

retq
