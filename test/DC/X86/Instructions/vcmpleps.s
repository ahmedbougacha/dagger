# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VCMPPSYrmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmpleps	2(%r14,%r15,2), %ymm9, %ymm8

## VCMPPSYrmi_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmpps	$2, 2(%r14,%r15,2), %ymm9, %ymm8

## VCMPPSYrri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmpleps	%ymm10, %ymm9, %ymm8

## VCMPPSYrri_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmpps	$2, %ymm10, %ymm9, %ymm8

## VCMPPSrmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmpleps	2(%r14,%r15,2), %xmm9, %xmm8

## VCMPPSrmi_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmpps	$2, 2(%r14,%r15,2), %xmm9, %xmm8

## VCMPPSrri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmpleps	%xmm10, %xmm9, %xmm8

## VCMPPSrri_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmpps	$2, %xmm10, %xmm9, %xmm8

retq
