# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## POP16r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
popw	%r8w

## POP16rmm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
popw	2(%r11,%rbx,2)

## POP16rmr:	popw	%r8w
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x66; .byte 0x41; .byte 0x8f; .byte 0xc0

## POP64r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RSP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V1:%.+]] = add i64 [[RSP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"RSP")
# CHECK-NEXT: [[RSP_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V2:%.+]] = sub i64 [[RSP_1]], 8
# CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i64*
# CHECK-NEXT: [[V4:%.+]] = load i64, i64* [[V3]], align 1
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
popq	%r11

## POP64rmm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RSP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V1:%.+]] = add i64 [[RSP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"RSP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V2:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[V2]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[R11_0]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to i64*
# CHECK-NEXT: [[RSP_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V6:%.+]] = sub i64 [[RSP_1]], 8
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i64*
# CHECK-NEXT: [[V8:%.+]] = load i64, i64* [[V7]], align 1
# CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V8]] to i64**
# CHECK-NEXT: store i64* [[V5]], i64** [[V9]], align 1
popq	2(%r11,%rbx,2)

## POP64rmr:	popq	%r11
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x41; .byte 0x8f; .byte 0xc3

## POPFS16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
popw	%fs

## POPFS64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
popq	%fs

## POPGS16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
popw	%gs

## POPGS64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
popq	%gs

retq
