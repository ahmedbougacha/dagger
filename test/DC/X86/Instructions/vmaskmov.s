# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VMASKMOVDQU
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovdqu	%xmm9, %xmm8

## VMASKMOVDQU64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovdqu	%xmm9, %xmm8

## VMASKMOVPDYmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovpd	%ymm14, %ymm13, 2(%r11,%rbx,2)

## VMASKMOVPDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovpd	2(%r14,%r15,2), %ymm9, %ymm8

## VMASKMOVPDmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovpd	%xmm14, %xmm13, 2(%r11,%rbx,2)

## VMASKMOVPDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovpd	2(%r14,%r15,2), %xmm9, %xmm8

## VMASKMOVPSYmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovps	%ymm14, %ymm13, 2(%r11,%rbx,2)

## VMASKMOVPSYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovps	2(%r14,%r15,2), %ymm9, %ymm8

## VMASKMOVPSmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovps	%xmm14, %xmm13, 2(%r11,%rbx,2)

## VMASKMOVPSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vmaskmovps	2(%r14,%r15,2), %xmm9, %xmm8

retq
