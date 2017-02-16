# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## CMOVA16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V7:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V8:%.+]] = trunc i32 [[V7]] to i1
# CHECK-NEXT: [[V9:%.+]] = or i1 [[V6]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V9]], true
# CHECK-NEXT: [[V11:%.+]] = select i1 [[V10]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V11]], metadata !"R8W")
cmovaw	2(%r14,%r15,2), %r8w

## CMOVA16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V4]], true
# CHECK-NEXT: [[V6:%.+]] = select i1 [[V5]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V6]], metadata !"R8W")
cmovaw	%r10w, %r8w

## CMOVA32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V7:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V8:%.+]] = trunc i32 [[V7]] to i1
# CHECK-NEXT: [[V9:%.+]] = or i1 [[V6]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V9]], true
# CHECK-NEXT: [[V11:%.+]] = select i1 [[V10]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V11]], metadata !"R8D")
cmoval	2(%r14,%r15,2), %r8d

## CMOVA32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V4]], true
# CHECK-NEXT: [[V6:%.+]] = select i1 [[V5]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"R8D")
cmoval	%r10d, %r8d

## CMOVA64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V7:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V8:%.+]] = trunc i32 [[V7]] to i1
# CHECK-NEXT: [[V9:%.+]] = or i1 [[V6]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V9]], true
# CHECK-NEXT: [[V11:%.+]] = select i1 [[V10]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V11]], metadata !"R11")
cmovaq	2(%r14,%r15,2), %r11

## CMOVA64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V4]], true
# CHECK-NEXT: [[V6:%.+]] = select i1 [[V5]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"R11")
cmovaq	%r14, %r11

## CMOVAE16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V7:%.+]] = xor i1 [[V6]], true
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V8]], metadata !"R8W")
cmovaew	2(%r14,%r15,2), %r8w

## CMOVAE16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = xor i1 [[V1]], true
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V3]], metadata !"R8W")
cmovaew	%r10w, %r8w

## CMOVAE32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V7:%.+]] = xor i1 [[V6]], true
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V8]], metadata !"R8D")
cmovael	2(%r14,%r15,2), %r8d

## CMOVAE32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = xor i1 [[V1]], true
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"R8D")
cmovael	%r10d, %r8d

## CMOVAE64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V7:%.+]] = xor i1 [[V6]], true
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V8]], metadata !"R11")
cmovaeq	2(%r14,%r15,2), %r11

## CMOVAE64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = xor i1 [[V1]], true
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"R11")
cmovaeq	%r14, %r11

## CMOVB16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V7:%.+]] = select i1 [[V6]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V7]], metadata !"R8W")
cmovbw	2(%r14,%r15,2), %r8w

## CMOVB16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = select i1 [[V1]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V2]], metadata !"R8W")
cmovbw	%r10w, %r8w

## CMOVB32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V7:%.+]] = select i1 [[V6]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V7]], metadata !"R8D")
cmovbl	2(%r14,%r15,2), %r8d

## CMOVB32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = select i1 [[V1]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V2]], metadata !"R8D")
cmovbl	%r10d, %r8d

## CMOVB64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V7:%.+]] = select i1 [[V6]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V7]], metadata !"R11")
cmovbq	2(%r14,%r15,2), %r11

## CMOVB64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = select i1 [[V1]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V2]], metadata !"R11")
cmovbq	%r14, %r11

## CMOVBE16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V7:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V8:%.+]] = trunc i32 [[V7]] to i1
# CHECK-NEXT: [[V9:%.+]] = or i1 [[V6]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = select i1 [[V9]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V10]], metadata !"R8W")
cmovbew	2(%r14,%r15,2), %r8w

## CMOVBE16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = select i1 [[V4]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V5]], metadata !"R8W")
cmovbew	%r10w, %r8w

## CMOVBE32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V7:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V8:%.+]] = trunc i32 [[V7]] to i1
# CHECK-NEXT: [[V9:%.+]] = or i1 [[V6]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = select i1 [[V9]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V10]], metadata !"R8D")
cmovbel	2(%r14,%r15,2), %r8d

## CMOVBE32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = select i1 [[V4]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V5]], metadata !"R8D")
cmovbel	%r10d, %r8d

## CMOVBE64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V7:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V8:%.+]] = trunc i32 [[V7]] to i1
# CHECK-NEXT: [[V9:%.+]] = or i1 [[V6]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = select i1 [[V9]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"R11")
cmovbeq	2(%r14,%r15,2), %r11

## CMOVBE64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = select i1 [[V4]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V5]], metadata !"R11")
cmovbeq	%r14, %r11

## CMOVE16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V8]], metadata !"R8W")
cmovew	2(%r14,%r15,2), %r8w

## CMOVE16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V3]], metadata !"R8W")
cmovew	%r10w, %r8w

## CMOVE32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V8]], metadata !"R8D")
cmovel	2(%r14,%r15,2), %r8d

## CMOVE32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"R8D")
cmovel	%r10d, %r8d

## CMOVE64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V8]], metadata !"R11")
cmoveq	2(%r14,%r15,2), %r11

## CMOVE64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"R11")
cmoveq	%r14, %r11

## CMOVG16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V11:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V12:%.+]] = trunc i32 [[V11]] to i1
# CHECK-NEXT: [[V13:%.+]] = or i1 [[V10]], [[V12]]
# CHECK-NEXT: [[V14:%.+]] = xor i1 [[V13]], true
# CHECK-NEXT: [[V15:%.+]] = select i1 [[V14]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V15]], metadata !"R8W")
cmovgw	2(%r14,%r15,2), %r8w

## CMOVG16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = or i1 [[V5]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = xor i1 [[V8]], true
# CHECK-NEXT: [[V10:%.+]] = select i1 [[V9]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V10]], metadata !"R8W")
cmovgw	%r10w, %r8w

## CMOVG32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V11:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V12:%.+]] = trunc i32 [[V11]] to i1
# CHECK-NEXT: [[V13:%.+]] = or i1 [[V10]], [[V12]]
# CHECK-NEXT: [[V14:%.+]] = xor i1 [[V13]], true
# CHECK-NEXT: [[V15:%.+]] = select i1 [[V14]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V15]], metadata !"R8D")
cmovgl	2(%r14,%r15,2), %r8d

## CMOVG32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = or i1 [[V5]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = xor i1 [[V8]], true
# CHECK-NEXT: [[V10:%.+]] = select i1 [[V9]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V10]], metadata !"R8D")
cmovgl	%r10d, %r8d

## CMOVG64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V11:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V12:%.+]] = trunc i32 [[V11]] to i1
# CHECK-NEXT: [[V13:%.+]] = or i1 [[V10]], [[V12]]
# CHECK-NEXT: [[V14:%.+]] = xor i1 [[V13]], true
# CHECK-NEXT: [[V15:%.+]] = select i1 [[V14]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V15]], metadata !"R11")
cmovgq	2(%r14,%r15,2), %r11

## CMOVG64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = or i1 [[V5]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = xor i1 [[V8]], true
# CHECK-NEXT: [[V10:%.+]] = select i1 [[V9]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"R11")
cmovgq	%r14, %r11

## CMOVGE16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = xor i1 [[V10]], true
# CHECK-NEXT: [[V12:%.+]] = select i1 [[V11]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V12]], metadata !"R8W")
cmovgew	2(%r14,%r15,2), %r8w

## CMOVGE16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = xor i1 [[V5]], true
# CHECK-NEXT: [[V7:%.+]] = select i1 [[V6]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V7]], metadata !"R8W")
cmovgew	%r10w, %r8w

## CMOVGE32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = xor i1 [[V10]], true
# CHECK-NEXT: [[V12:%.+]] = select i1 [[V11]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V12]], metadata !"R8D")
cmovgel	2(%r14,%r15,2), %r8d

## CMOVGE32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = xor i1 [[V5]], true
# CHECK-NEXT: [[V7:%.+]] = select i1 [[V6]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V7]], metadata !"R8D")
cmovgel	%r10d, %r8d

## CMOVGE64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = xor i1 [[V10]], true
# CHECK-NEXT: [[V12:%.+]] = select i1 [[V11]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V12]], metadata !"R11")
cmovgeq	2(%r14,%r15,2), %r11

## CMOVGE64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = xor i1 [[V5]], true
# CHECK-NEXT: [[V7:%.+]] = select i1 [[V6]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V7]], metadata !"R11")
cmovgeq	%r14, %r11

## CMOVL16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = select i1 [[V10]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V11]], metadata !"R8W")
cmovlw	2(%r14,%r15,2), %r8w

## CMOVL16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = select i1 [[V5]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V6]], metadata !"R8W")
cmovlw	%r10w, %r8w

## CMOVL32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = select i1 [[V10]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V11]], metadata !"R8D")
cmovll	2(%r14,%r15,2), %r8d

## CMOVL32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = select i1 [[V5]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"R8D")
cmovll	%r10d, %r8d

## CMOVL64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = select i1 [[V10]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V11]], metadata !"R11")
cmovlq	2(%r14,%r15,2), %r11

## CMOVL64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = select i1 [[V5]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"R11")
cmovlq	%r14, %r11

## CMOVLE16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V11:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V12:%.+]] = trunc i32 [[V11]] to i1
# CHECK-NEXT: [[V13:%.+]] = or i1 [[V10]], [[V12]]
# CHECK-NEXT: [[V14:%.+]] = select i1 [[V13]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V14]], metadata !"R8W")
cmovlew	2(%r14,%r15,2), %r8w

## CMOVLE16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = or i1 [[V5]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V9]], metadata !"R8W")
cmovlew	%r10w, %r8w

## CMOVLE32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V11:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V12:%.+]] = trunc i32 [[V11]] to i1
# CHECK-NEXT: [[V13:%.+]] = or i1 [[V10]], [[V12]]
# CHECK-NEXT: [[V14:%.+]] = select i1 [[V13]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V14]], metadata !"R8D")
cmovlel	2(%r14,%r15,2), %r8d

## CMOVLE32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = or i1 [[V5]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"R8D")
cmovlel	%r10d, %r8d

## CMOVLE64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V8:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i1
# CHECK-NEXT: [[V10:%.+]] = xor i1 [[V7]], [[V9]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V11:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V12:%.+]] = trunc i32 [[V11]] to i1
# CHECK-NEXT: [[V13:%.+]] = or i1 [[V10]], [[V12]]
# CHECK-NEXT: [[V14:%.+]] = select i1 [[V13]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V14]], metadata !"R11")
cmovleq	2(%r14,%r15,2), %r11

## CMOVLE64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[EFLAGS_3:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_3]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = or i1 [[V5]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"R11")
cmovleq	%r14, %r11

## CMOVNE16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V9]], metadata !"R8W")
cmovnew	2(%r14,%r15,2), %r8w

## CMOVNE16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"R8W")
cmovnew	%r10w, %r8w

## CMOVNE32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"R8D")
cmovnel	2(%r14,%r15,2), %r8d

## CMOVNE32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"R8D")
cmovnel	%r10d, %r8d

## CMOVNE64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"R11")
cmovneq	2(%r14,%r15,2), %r11

## CMOVNE64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
cmovneq	%r14, %r11

## CMOVNO16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V9]], metadata !"R8W")
cmovnow	2(%r14,%r15,2), %r8w

## CMOVNO16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"R8W")
cmovnow	%r10w, %r8w

## CMOVNO32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"R8D")
cmovnol	2(%r14,%r15,2), %r8d

## CMOVNO32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"R8D")
cmovnol	%r10d, %r8d

## CMOVNO64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"R11")
cmovnoq	2(%r14,%r15,2), %r11

## CMOVNO64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
cmovnoq	%r14, %r11

## CMOVNP16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V9]], metadata !"R8W")
cmovnpw	2(%r14,%r15,2), %r8w

## CMOVNP16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"R8W")
cmovnpw	%r10w, %r8w

## CMOVNP32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"R8D")
cmovnpl	2(%r14,%r15,2), %r8d

## CMOVNP32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"R8D")
cmovnpl	%r10d, %r8d

## CMOVNP64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"R11")
cmovnpq	2(%r14,%r15,2), %r11

## CMOVNP64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
cmovnpq	%r14, %r11

## CMOVNS16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V9]], metadata !"R8W")
cmovnsw	2(%r14,%r15,2), %r8w

## CMOVNS16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"R8W")
cmovnsw	%r10w, %r8w

## CMOVNS32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"R8D")
cmovnsl	2(%r14,%r15,2), %r8d

## CMOVNS32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"R8D")
cmovnsl	%r10d, %r8d

## CMOVNS64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = xor i1 [[V7]], true
# CHECK-NEXT: [[V9:%.+]] = select i1 [[V8]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"R11")
cmovnsq	2(%r14,%r15,2), %r11

## CMOVNS64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = select i1 [[V3]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
cmovnsq	%r14, %r11

## CMOVO16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V8]], metadata !"R8W")
cmovow	2(%r14,%r15,2), %r8w

## CMOVO16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V3]], metadata !"R8W")
cmovow	%r10w, %r8w

## CMOVO32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V8]], metadata !"R8D")
cmovol	2(%r14,%r15,2), %r8d

## CMOVO32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"R8D")
cmovol	%r10d, %r8d

## CMOVO64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V8]], metadata !"R11")
cmovoq	2(%r14,%r15,2), %r11

## CMOVO64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"R11")
cmovoq	%r14, %r11

## CMOVP16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V8]], metadata !"R8W")
cmovpw	2(%r14,%r15,2), %r8w

## CMOVP16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V3]], metadata !"R8W")
cmovpw	%r10w, %r8w

## CMOVP32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V8]], metadata !"R8D")
cmovpl	2(%r14,%r15,2), %r8d

## CMOVP32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"R8D")
cmovpl	%r10d, %r8d

## CMOVP64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V8]], metadata !"R11")
cmovpq	2(%r14,%r15,2), %r11

## CMOVP64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"R11")
cmovpq	%r14, %r11

## CMOVS16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i16 [[V5]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V8]], metadata !"R8W")
cmovsw	2(%r14,%r15,2), %r8w

## CMOVS16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R10W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R10W")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i16 [[R10W_0]], i16 [[R8W_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V3]], metadata !"R8W")
cmovsw	%r10w, %r8w

## CMOVS32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i32 [[V5]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V8]], metadata !"R8D")
cmovsl	2(%r14,%r15,2), %r8d

## CMOVS32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i32 [[R10D_0]], i32 [[R8D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"R8D")
cmovsl	%r10d, %r8d

## CMOVS64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
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
# CHECK-NEXT: [[V6:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V7:%.+]] = trunc i32 [[V6]] to i1
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], i64 [[V5]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V8]], metadata !"R11")
cmovsq	2(%r14,%r15,2), %r11

## CMOVS64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V2]], i64 [[R14_0]], i64 [[R11_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"R11")
cmovsq	%r14, %r11

retq
