# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VMPSADBWYrmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmpsadbw	$2, 2(%r14,%r15,2), %ymm9, %ymm8

## VMPSADBWYrri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmpsadbw	$2, %ymm10, %ymm9, %ymm8

## VMPSADBWrmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmpsadbw	$2, 2(%r14,%r15,2), %xmm9, %xmm8

## VMPSADBWrri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmpsadbw	$2, %xmm10, %xmm9, %xmm8

retq
