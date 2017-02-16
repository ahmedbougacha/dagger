# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## SBB16i16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
sbbw	$305419896, %ax

## SBB16mi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i16
# CHECK-NEXT: [[V8:%.+]] = sub i16 [[V5]], 22136
# CHECK-NEXT: [[V9:%.+]] = sub i16 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i16 [[V9]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbw	$305419896, 2(%r11,%rbx,2)

## SBB16mi8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i16
# CHECK-NEXT: [[V8:%.+]] = sub i16 [[V5]], 2
# CHECK-NEXT: [[V9:%.+]] = sub i16 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i16 [[V9]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbw	$2, 2(%r11,%rbx,2)

## SBB16mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[R15W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R15W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i16
# CHECK-NEXT: [[V8:%.+]] = sub i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V9:%.+]] = sub i16 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i16 [[V9]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbw	%r15w, 2(%r11,%rbx,2)

## SBB16ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i16
# CHECK-NEXT: [[V3:%.+]] = sub i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V4:%.+]] = sub i16 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"R8W")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbw	$305419896, %r8w

## SBB16ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i16
# CHECK-NEXT: [[V3:%.+]] = sub i16 [[R8W_0]], 2
# CHECK-NEXT: [[V4:%.+]] = sub i16 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"R8W")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbw	$2, %r8w

## SBB16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R14_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i16
# CHECK-NEXT: [[V8:%.+]] = sub i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V9:%.+]] = sub i16 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V9]], metadata !"R8W")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbw	2(%r14,%r15,2), %r8w

## SBB16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i16
# CHECK-NEXT: [[V3:%.+]] = sub i16 [[R8W_0]], [[R10W_0]]
# CHECK-NEXT: [[V4:%.+]] = sub i16 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"R8W")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbw	%r10w, %r8w

## SBB16rr_REV:	sbbw	%r10w, %r8w
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x66; .byte 0x45; .byte 0x1b; .byte 0xc2

## SBB32i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
sbbl	$305419896, %eax

## SBB32mi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 9
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i32
# CHECK-NEXT: [[V8:%.+]] = sub i32 [[V5]], 305419896
# CHECK-NEXT: [[V9:%.+]] = sub i32 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i32 [[V9]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbl	$305419896, 2(%r11,%rbx,2)

## SBB32mi8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i32
# CHECK-NEXT: [[V8:%.+]] = sub i32 [[V5]], 2
# CHECK-NEXT: [[V9:%.+]] = sub i32 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i32 [[V9]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbl	$2, 2(%r11,%rbx,2)

## SBB32mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[R15D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R15D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i32
# CHECK-NEXT: [[V8:%.+]] = sub i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V9:%.+]] = sub i32 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i32 [[V9]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbl	%r15d, 2(%r11,%rbx,2)

## SBB32ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = sub i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V4:%.+]] = sub i32 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"R8D")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbl	$305419896, %r8d

## SBB32ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = sub i32 [[R8D_0]], 2
# CHECK-NEXT: [[V4:%.+]] = sub i32 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"R8D")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbl	$2, %r8d

## SBB32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R14_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i32
# CHECK-NEXT: [[V8:%.+]] = sub i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V9:%.+]] = sub i32 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"R8D")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbl	2(%r14,%r15,2), %r8d

## SBB32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = sub i32 [[R8D_0]], [[R10D_0]]
# CHECK-NEXT: [[V4:%.+]] = sub i32 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"R8D")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbl	%r10d, %r8d

## SBB32rr_REV:	sbbl	%r10d, %r8d
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x45; .byte 0x1b; .byte 0xc2

## SBB64i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
sbbq	$305419896, %rax

## SBB64mi32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 9
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i64
# CHECK-NEXT: [[V8:%.+]] = sub i64 [[V5]], 305419896
# CHECK-NEXT: [[V9:%.+]] = sub i64 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i64 [[V9]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbq	$305419896, 2(%r11,%rbx,2)

## SBB64mi8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i64
# CHECK-NEXT: [[V8:%.+]] = sub i64 [[V5]], 2
# CHECK-NEXT: [[V9:%.+]] = sub i64 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i64 [[V9]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbq	$2, 2(%r11,%rbx,2)

## SBB64mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[R13_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R13")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i64
# CHECK-NEXT: [[V8:%.+]] = sub i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V9:%.+]] = sub i64 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i64 [[V9]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbq	%r13, 2(%r11,%rbx,2)

## SBB64ri32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = sub i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V4:%.+]] = sub i64 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbq	$305419896, %r11

## SBB64ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = sub i64 [[R11_0]], 2
# CHECK-NEXT: [[V4:%.+]] = sub i64 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbq	$2, %r11

## SBB64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R14_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i64
# CHECK-NEXT: [[V8:%.+]] = sub i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V9:%.+]] = sub i64 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"R11")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbq	2(%r14,%r15,2), %r11

## SBB64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = sub i64 [[R11_0]], [[R14_0]]
# CHECK-NEXT: [[V4:%.+]] = sub i64 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbq	%r14, %r11

## SBB64rr_REV:	sbbq	%r14, %r11
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x4d; .byte 0x1b; .byte 0xde

## SBB8i8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
sbbb	$2, %al

## SBB8mi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i8*
# CHECK-NEXT: [[V5:%.+]] = load i8, i8* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i8
# CHECK-NEXT: [[V8:%.+]] = sub i8 [[V5]], 2
# CHECK-NEXT: [[V9:%.+]] = sub i8 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i8 [[V9]], i8* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbb	$2, 2(%r11,%rbx,2)

## SBB8mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i8*
# CHECK-NEXT: [[V5:%.+]] = load i8, i8* [[V4]], align 1
# CHECK-NEXT: [[R11B_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"R11B")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i8
# CHECK-NEXT: [[V8:%.+]] = sub i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V9:%.+]] = sub i8 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: store i8 [[V9]], i8* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
sbbb	%r11b, 2(%r11,%rbx,2)

## SBB8ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i8
# CHECK-NEXT: [[V3:%.+]] = sub i8 [[BPL_0]], 2
# CHECK-NEXT: [[V4:%.+]] = sub i8 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V4]], metadata !"BPL")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbb	$2, %bpl

## SBB8rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R14_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i8*
# CHECK-NEXT: [[V5:%.+]] = load i8, i8* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i8
# CHECK-NEXT: [[V8:%.+]] = sub i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V9:%.+]] = sub i8 [[V8]], [[V7]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V9]], metadata !"BPL")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbb	2(%r14,%r15,2), %bpl

## SBB8rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[R8B_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"R8B")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i8
# CHECK-NEXT: [[V3:%.+]] = sub i8 [[BPL_0]], [[R8B_0]]
# CHECK-NEXT: [[V4:%.+]] = sub i8 [[V3]], [[V2]]
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V4]], metadata !"BPL")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EFLAGS_2]], metadata !"EFLAGS")
sbbb	%r8b, %bpl

## SBB8rr_REV:	sbbb	%r8b, %bpl
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x41; .byte 0x1a; .byte 0xe8

retq
