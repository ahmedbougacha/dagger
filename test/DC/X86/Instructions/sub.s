# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## SUB16i16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AX_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"AX")
# CHECK-NEXT: [[V1:%.+]] = sub i16 [[AX_0]], 22136
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"AX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subw	$305419896, %ax

## SUB16mi
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
# CHECK-NEXT: [[V6:%.+]] = sub i16 [[V5]], 22136
# CHECK-NEXT: store i16 [[V6]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subw	$305419896, 2(%r11,%rbx,2)

## SUB16mi8
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
# CHECK-NEXT: [[V6:%.+]] = sub i16 [[V5]], 2
# CHECK-NEXT: store i16 [[V6]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subw	$2, 2(%r11,%rbx,2)

## SUB16mr
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
# CHECK-NEXT: [[V6:%.+]] = sub i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: store i16 [[V6]], i16* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subw	%r15w, 2(%r11,%rbx,2)

## SUB16ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = sub i16 [[R8W_0]], 22136
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subw	$305419896, %r8w

## SUB16ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = sub i16 [[R8W_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subw	$2, %r8w

## SUB16rm
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
# CHECK-NEXT: [[V6:%.+]] = sub i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V6]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subw	2(%r14,%r15,2), %r8w

## SUB16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[V1:%.+]] = sub i16 [[R8W_0]], [[R10W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subw	%r10w, %r8w

## SUB16rr_REV:	subw	%r10w, %r8w
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[V1:%.+]] = sub i16 [[R8W_0]], [[R10W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V1]], metadata !"R8W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
.byte 0x66; .byte 0x45; .byte 0x2b; .byte 0xc2

## SUB32i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EAX_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EAX")
# CHECK-NEXT: [[V1:%.+]] = sub i32 [[EAX_0]], 305419896
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"EAX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subl	$305419896, %eax

## SUB32mi
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
# CHECK-NEXT: [[V6:%.+]] = sub i32 [[V5]], 305419896
# CHECK-NEXT: store i32 [[V6]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subl	$305419896, 2(%r11,%rbx,2)

## SUB32mi8
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
# CHECK-NEXT: [[V6:%.+]] = sub i32 [[V5]], 2
# CHECK-NEXT: store i32 [[V6]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subl	$2, 2(%r11,%rbx,2)

## SUB32mr
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
# CHECK-NEXT: [[V6:%.+]] = sub i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: store i32 [[V6]], i32* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subl	%r15d, 2(%r11,%rbx,2)

## SUB32ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = sub i32 [[R8D_0]], 305419896
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subl	$305419896, %r8d

## SUB32ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = sub i32 [[R8D_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subl	$2, %r8d

## SUB32rm
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
# CHECK-NEXT: [[V6:%.+]] = sub i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subl	2(%r14,%r15,2), %r8d

## SUB32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[V1:%.+]] = sub i32 [[R8D_0]], [[R10D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subl	%r10d, %r8d

## SUB32rr_REV:	subl	%r10d, %r8d
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[V1:%.+]] = sub i32 [[R8D_0]], [[R10D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V1]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
.byte 0x45; .byte 0x2b; .byte 0xc2

## SUB64i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RAX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RAX")
# CHECK-NEXT: [[V1:%.+]] = sub i64 [[RAX_0]], 305419896
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"RAX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subq	$305419896, %rax

## SUB64mi32
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
# CHECK-NEXT: [[V6:%.+]] = sub i64 [[V5]], 305419896
# CHECK-NEXT: store i64 [[V6]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subq	$305419896, 2(%r11,%rbx,2)

## SUB64mi8
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
# CHECK-NEXT: [[V6:%.+]] = sub i64 [[V5]], 2
# CHECK-NEXT: store i64 [[V6]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subq	$2, 2(%r11,%rbx,2)

## SUB64mr
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
# CHECK-NEXT: [[V6:%.+]] = sub i64 [[V5]], [[R13_0]]
# CHECK-NEXT: store i64 [[V6]], i64* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subq	%r13, 2(%r11,%rbx,2)

## SUB64ri32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = sub i64 [[R11_0]], 305419896
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subq	$305419896, %r11

## SUB64ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = sub i64 [[R11_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subq	$2, %r11

## SUB64rm
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
# CHECK-NEXT: [[V6:%.+]] = sub i64 [[R11_0]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subq	2(%r14,%r15,2), %r11

## SUB64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = sub i64 [[R11_0]], [[R14_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subq	%r14, %r11

## SUB64rr_REV:	subq	%r14, %r11
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = sub i64 [[R11_0]], [[R14_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
.byte 0x4d; .byte 0x2b; .byte 0xde

## SUB8i8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"AL")
# CHECK-NEXT: [[V1:%.+]] = sub i8 [[AL_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V1]], metadata !"AL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subb	$2, %al

## SUB8mi
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
# CHECK-NEXT: [[V6:%.+]] = sub i8 [[V5]], 2
# CHECK-NEXT: store i8 [[V6]], i8* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subb	$2, 2(%r11,%rbx,2)

## SUB8mr
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
# CHECK-NEXT: [[V6:%.+]] = sub i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: store i8 [[V6]], i8* [[V4]], align 1
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subb	%r11b, 2(%r11,%rbx,2)

## SUB8ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[V1:%.+]] = sub i8 [[BPL_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V1]], metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subb	$2, %bpl

## SUB8rm
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
# CHECK-NEXT: [[V6:%.+]] = sub i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V6]], metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subb	2(%r14,%r15,2), %bpl

## SUB8rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[R8B_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"R8B")
# CHECK-NEXT: [[V1:%.+]] = sub i8 [[BPL_0]], [[R8B_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V1]], metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
subb	%r8b, %bpl

## SUB8rr_REV:	subb	%r8b, %bpl
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[R8B_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"R8B")
# CHECK-NEXT: [[V1:%.+]] = sub i8 [[BPL_0]], [[R8B_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V1]], metadata !"BPL")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
.byte 0x41; .byte 0x2a; .byte 0xe8

## SUBSDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R14_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to double*
# CHECK-NEXT: [[V8:%.+]] = load double, double* [[V7]], align 1
# CHECK-NEXT: [[V9:%.+]] = fsub double [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = bitcast double [[V9]] to i64
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V12:%.+]] = zext i64 [[V10]] to i128
# CHECK-NEXT: [[V13:%.+]] = and i128 [[V11]], -18446744073709551616
# CHECK-NEXT: [[V14:%.+]] = or i128 [[V12]], [[V13]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V14]], metadata !"XMM8")
subsd	2(%r14,%r15,2), %xmm8

## SUBSDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i64
# CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to double
# CHECK-NEXT: [[V7:%.+]] = fsub double [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = bitcast double [[V7]] to i64
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V9:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V10:%.+]] = zext i64 [[V8]] to i128
# CHECK-NEXT: [[V11:%.+]] = and i128 [[V9]], -18446744073709551616
# CHECK-NEXT: [[V12:%.+]] = or i128 [[V10]], [[V11]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V12]], metadata !"XMM8")
subsd	%xmm10, %xmm8

retq
