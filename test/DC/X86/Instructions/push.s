# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## PUSH16i8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushw	$2

## PUSH16r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushw	%r8w

## PUSH16rmm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushw	2(%r11,%rbx,2)

## PUSH16rmr:	pushw	%r8w
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x66; .byte 0x41; .byte 0xff; .byte 0xf0

## PUSH64i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RSP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V1:%.+]] = sub i64 [[RSP_0]], 8
# CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i64*
# CHECK-NEXT: store i64 305419896, i64* [[V2]], align 1
# CHECK-NEXT: [[RSP_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V3:%.+]] = sub i64 [[RSP_1]], 8
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"RSP")
pushq	$305419896

## PUSH64i8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushq	$2

## PUSH64r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RSP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V1:%.+]] = sub i64 [[RSP_0]], 8
# CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i64*
# CHECK-NEXT: store i64 [[R11_0]], i64* [[V2]], align 1
# CHECK-NEXT: [[RSP_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V3:%.+]] = sub i64 [[RSP_1]], 8
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"RSP")
pushq	%r11

## PUSH64rmm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushq	2(%r11,%rbx,2)

## PUSH64rmr:	pushq	%r11
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x41; .byte 0xff; .byte 0xf3

## PUSHFS16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushw	%fs

## PUSHFS64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushq	%fs

## PUSHGS16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushw	%gs

## PUSHGS64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushq	%gs

## PUSHi16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushw	$305419896

retq
