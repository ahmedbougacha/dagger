# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## ADD16i16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AX_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"AX")
# CHECK-NEXT: [[V1:%.+]] = add i16 [[AX_0]], 22136
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"AX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addw	$305419896, %ax

## ADD16mi
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
# CHECK-NEXT: [[V6:%.+]] = add i16 [[V5]], 22136
# CHECK-NEXT: store i16 [[V6]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addw	$305419896, 2(%r11,%rbx,2)

## ADD16mi8
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
# CHECK-NEXT: [[V6:%.+]] = add i16 [[V5]], 2
# CHECK-NEXT: store i16 [[V6]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addw	$2, 2(%r11,%rbx,2)

## ADD16mr
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
# CHECK-NEXT: [[V6:%.+]] = add i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: store i16 [[V6]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addw	%r15w, 2(%r11,%rbx,2)

## ADD16ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = add i16 [[R8W_0]], 22136
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addw	$305419896, %r8w

## ADD16ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = add i16 [[R8W_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addw	$2, %r8w

## ADD16rm
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
# CHECK-NEXT: [[V6:%.+]] = add i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V6]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addw	2(%r14,%r15,2), %r8w

## ADD16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[V1:%.+]] = add i16 [[R8W_0]], [[R10W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addw	%r10w, %r8w

## ADD16rr_REV:	addw	%r10w, %r8w
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[V1:%.+]] = add i16 [[R8W_0]], [[R10W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
.byte 0x66; .byte 0x45; .byte 0x03; .byte 0xc2

## ADD32i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EAX_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EAX")
# CHECK-NEXT: [[V1:%.+]] = add i32 [[EAX_0]], 305419896
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"EAX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addl	$305419896, %eax

## ADD32mi
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
# CHECK-NEXT: [[V6:%.+]] = add i32 [[V5]], 305419896
# CHECK-NEXT: store i32 [[V6]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addl	$305419896, 2(%r11,%rbx,2)

## ADD32mi8
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
# CHECK-NEXT: [[V6:%.+]] = add i32 [[V5]], 2
# CHECK-NEXT: store i32 [[V6]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addl	$2, 2(%r11,%rbx,2)

## ADD32mr
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
# CHECK-NEXT: [[V6:%.+]] = add i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: store i32 [[V6]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addl	%r15d, 2(%r11,%rbx,2)

## ADD32ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = add i32 [[R8D_0]], 305419896
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addl	$305419896, %r8d

## ADD32ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = add i32 [[R8D_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addl	$2, %r8d

## ADD32rm
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
# CHECK-NEXT: [[V6:%.+]] = add i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addl	2(%r14,%r15,2), %r8d

## ADD32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[V1:%.+]] = add i32 [[R8D_0]], [[R10D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addl	%r10d, %r8d

## ADD32rr_REV:	addl	%r10d, %r8d
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[V1:%.+]] = add i32 [[R8D_0]], [[R10D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
.byte 0x45; .byte 0x03; .byte 0xc2

## ADD64i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RAX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RAX")
# CHECK-NEXT: [[V1:%.+]] = add i64 [[RAX_0]], 305419896
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"RAX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addq	$305419896, %rax

## ADD64mi32
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
# CHECK-NEXT: [[V6:%.+]] = add i64 [[V5]], 305419896
# CHECK-NEXT: store i64 [[V6]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addq	$305419896, 2(%r11,%rbx,2)

## ADD64mi8
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
# CHECK-NEXT: [[V6:%.+]] = add i64 [[V5]], 2
# CHECK-NEXT: store i64 [[V6]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addq	$2, 2(%r11,%rbx,2)

## ADD64mr
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
# CHECK-NEXT: [[V6:%.+]] = add i64 [[V5]], [[R13_0]]
# CHECK-NEXT: store i64 [[V6]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addq	%r13, 2(%r11,%rbx,2)

## ADD64ri32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = add i64 [[R11_0]], 305419896
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addq	$305419896, %r11

## ADD64ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = add i64 [[R11_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addq	$2, %r11

## ADD64rm
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
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R11_0]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addq	2(%r14,%r15,2), %r11

## ADD64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = add i64 [[R11_0]], [[R14_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addq	%r14, %r11

## ADD64rr_REV:	addq	%r14, %r11
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = add i64 [[R11_0]], [[R14_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
.byte 0x4d; .byte 0x03; .byte 0xde

## ADD8i8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"AL")
# CHECK-NEXT: [[V1:%.+]] = add i8 [[AL_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V1]], metadata !"AL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addb	$2, %al

## ADD8mi
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
# CHECK-NEXT: [[V6:%.+]] = add i8 [[V5]], 2
# CHECK-NEXT: store i8 [[V6]], i8* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addb	$2, 2(%r11,%rbx,2)

## ADD8mr
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
# CHECK-NEXT: [[V6:%.+]] = add i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: store i8 [[V6]], i8* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addb	%r11b, 2(%r11,%rbx,2)

## ADD8ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[V1:%.+]] = add i8 [[BPL_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V1]], metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addb	$2, %bpl

## ADD8rm
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
# CHECK-NEXT: [[V6:%.+]] = add i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V6]], metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addb	2(%r14,%r15,2), %bpl

## ADD8rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[R8B_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"R8B")
# CHECK-NEXT: [[V1:%.+]] = add i8 [[BPL_0]], [[R8B_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V1]], metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
addb	%r8b, %bpl

## ADD8rr_REV:	addb	%r8b, %bpl
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[R8B_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"R8B")
# CHECK-NEXT: [[V1:%.+]] = add i8 [[BPL_0]], [[R8B_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V1]], metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
.byte 0x41; .byte 0x02; .byte 0xe8

## ADDSSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = bitcast i32 [[V2]] to float
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R14_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to float*
# CHECK-NEXT: [[V8:%.+]] = load float, float* [[V7]], align 1
# CHECK-NEXT: [[V9:%.+]] = fadd float [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = bitcast float [[V9]] to i32
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V12:%.+]] = zext i32 [[V10]] to i128
# CHECK-NEXT: [[V13:%.+]] = and i128 [[V11]], -4294967296
# CHECK-NEXT: [[V14:%.+]] = or i128 [[V12]], [[V13]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V14]], metadata !"XMM8")
addss	2(%r14,%r15,2), %xmm8

## ADDSSrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = bitcast i32 [[V2]] to float
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i32
# CHECK-NEXT: [[V6:%.+]] = bitcast i32 [[V5]] to float
# CHECK-NEXT: [[V7:%.+]] = fadd float [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = bitcast float [[V7]] to i32
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V9:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V10:%.+]] = zext i32 [[V8]] to i128
# CHECK-NEXT: [[V11:%.+]] = and i128 [[V9]], -4294967296
# CHECK-NEXT: [[V12:%.+]] = or i128 [[V10]], [[V11]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V12]], metadata !"XMM8")
addss	%xmm10, %xmm8

retq
