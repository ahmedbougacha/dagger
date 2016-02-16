# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## BT16mi8
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
# CHECK-NEXT: [[V6:%.+]] = shl i16 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i16 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V9:%.+]] = zext i1 [[V7]] to i32
# CHECK-NEXT: [[V10:%.+]] = lshr i32 [[V9]], 0
# CHECK-NEXT: [[V11:%.+]] = or i32 [[V8]], [[V10]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V11]], metadata !"EFLAGS")
btw	$2, 2(%r11,%rbx,2)

## BT16mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
btw	%r15w, 2(%r11,%rbx,2)

## BT16ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = shl i16 [[R8W_0]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i16 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V2]] to i32
# CHECK-NEXT: [[V5:%.+]] = lshr i32 [[V4]], 0
# CHECK-NEXT: [[V6:%.+]] = or i32 [[V3]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"EFLAGS")
btw	$2, %r8w

## BT16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R9W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R9W")
# CHECK-NEXT: [[V1:%.+]] = shl i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V2:%.+]] = trunc i16 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V2]] to i32
# CHECK-NEXT: [[V5:%.+]] = lshr i32 [[V4]], 0
# CHECK-NEXT: [[V6:%.+]] = or i32 [[V3]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"EFLAGS")
btw	%r9w, %r8w

## BT32mi8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = shl i32 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V9:%.+]] = zext i1 [[V7]] to i32
# CHECK-NEXT: [[V10:%.+]] = lshr i32 [[V9]], 0
# CHECK-NEXT: [[V11:%.+]] = or i32 [[V8]], [[V10]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V11]], metadata !"EFLAGS")
btl	$2, 2(%r11,%rbx,2)

## BT32mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
btl	%r15d, 2(%r11,%rbx,2)

## BT32ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = shl i32 [[R8D_0]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V2]] to i32
# CHECK-NEXT: [[V5:%.+]] = lshr i32 [[V4]], 0
# CHECK-NEXT: [[V6:%.+]] = or i32 [[V3]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"EFLAGS")
btl	$2, %r8d

## BT32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R9D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R9D")
# CHECK-NEXT: [[V1:%.+]] = shl i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V2]] to i32
# CHECK-NEXT: [[V5:%.+]] = lshr i32 [[V4]], 0
# CHECK-NEXT: [[V6:%.+]] = or i32 [[V3]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"EFLAGS")
btl	%r9d, %r8d

## BT64mi8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = shl i64 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i64 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V9:%.+]] = zext i1 [[V7]] to i32
# CHECK-NEXT: [[V10:%.+]] = lshr i32 [[V9]], 0
# CHECK-NEXT: [[V11:%.+]] = or i32 [[V8]], [[V10]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V11]], metadata !"EFLAGS")
btq	$2, 2(%r11,%rbx,2)

## BT64mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
btq	%r13, 2(%r11,%rbx,2)

## BT64ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = shl i64 [[R11_0]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i64 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V2]] to i32
# CHECK-NEXT: [[V5:%.+]] = lshr i32 [[V4]], 0
# CHECK-NEXT: [[V6:%.+]] = or i32 [[V3]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"EFLAGS")
btq	$2, %r11

## BT64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = shl i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V2:%.+]] = trunc i64 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = and i32 [[EFLAGS_0]], -2
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V2]] to i32
# CHECK-NEXT: [[V5:%.+]] = lshr i32 [[V4]], 0
# CHECK-NEXT: [[V6:%.+]] = or i32 [[V3]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"EFLAGS")
btq	%rbx, %r11

retq
