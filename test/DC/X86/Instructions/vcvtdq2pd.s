# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VCVTDQ2PDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtdq2pd	2(%rbx,%r14,2), %ymm8

## VCVTDQ2PDYrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtdq2pd	%xmm9, %ymm8

## VCVTDQ2PDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtdq2pd	2(%rbx,%r14,2), %xmm8

## VCVTDQ2PDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcvtdq2pd	%xmm9, %xmm8

retq
