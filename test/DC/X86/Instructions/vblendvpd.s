# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VBLENDVPDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
vblendvpd	%ymm15, 2(%r14,%r15,2), %ymm9, %ymm8

## VBLENDVPDYrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
vblendvpd	%ymm11, %ymm10, %ymm9, %ymm8

## VBLENDVPDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
vblendvpd	%xmm15, 2(%r14,%r15,2), %xmm9, %xmm8

## VBLENDVPDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
vblendvpd	%xmm11, %xmm10, %xmm9, %xmm8

retq
