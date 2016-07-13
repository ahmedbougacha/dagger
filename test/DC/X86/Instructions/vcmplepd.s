# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VCMPPDYrmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmplepd	2(%r14,%r15,2), %ymm9, %ymm8

## VCMPPDYrmi_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmppd	$2, 2(%r14,%r15,2), %ymm9, %ymm8

## VCMPPDYrri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmplepd	%ymm10, %ymm9, %ymm8

## VCMPPDYrri_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmppd	$2, %ymm10, %ymm9, %ymm8

## VCMPPDrmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmplepd	2(%r14,%r15,2), %xmm9, %xmm8

## VCMPPDrmi_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmppd	$2, 2(%r14,%r15,2), %xmm9, %xmm8

## VCMPPDrri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmplepd	%xmm10, %xmm9, %xmm8

## VCMPPDrri_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vcmppd	$2, %xmm10, %xmm9, %xmm8

retq
