# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## SETAEm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = xor i1 [[V1]], true
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i8*
# CHECK-NEXT: store i8 [[V3]], i8* [[V7]], align 1
setae	2(%r11,%rbx,2)

## SETAEr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = xor i1 [[V1]], true
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V3]], metadata !"BPL")
setae	%bpl

## SETAm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V4]], true
# CHECK-NEXT: [[V6:%.+]] = zext i1 [[V5]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V7:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V8:%.+]] = add i64 [[V7]], 2
# CHECK-NEXT: [[V9:%.+]] = add i64 [[R11_0]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = inttoptr i64 [[V9]] to i8*
# CHECK-NEXT: store i8 [[V6]], i8* [[V10]], align 1
seta	2(%r11,%rbx,2)

## SETAr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V4]], true
# CHECK-NEXT: [[V6:%.+]] = zext i1 [[V5]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V6]], metadata !"BPL")
seta	%bpl

## SETBEm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = zext i1 [[V4]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V6:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V7:%.+]] = add i64 [[V6]], 2
# CHECK-NEXT: [[V8:%.+]] = add i64 [[R11_0]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V8]] to i8*
# CHECK-NEXT: store i8 [[V5]], i8* [[V9]], align 1
setbe	2(%r11,%rbx,2)

## SETBEr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V2:%.+]] = lshr i32 [[EFLAGS_2]], 6
# CHECK-NEXT: [[V3:%.+]] = trunc i32 [[V2]] to i1
# CHECK-NEXT: [[V4:%.+]] = or i1 [[V1]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = zext i1 [[V4]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V5]], metadata !"BPL")
setbe	%bpl

## SETBm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R11_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to i8*
# CHECK-NEXT: store i8 [[V2]], i8* [[V6]], align 1
setb	2(%r11,%rbx,2)

## SETBr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = trunc i32 [[EFLAGS_1]] to i1
# CHECK-NEXT: [[V2:%.+]] = zext i1 [[V1]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V2]], metadata !"BPL")
setb	%bpl

## SETEm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i8*
# CHECK-NEXT: store i8 [[V3]], i8* [[V7]], align 1
sete	2(%r11,%rbx,2)

## SETEr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V3]], metadata !"BPL")
sete	%bpl

## SETGEm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = xor i1 [[V5]], true
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V8:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V9:%.+]] = add i64 [[V8]], 2
# CHECK-NEXT: [[V10:%.+]] = add i64 [[R11_0]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to i8*
# CHECK-NEXT: store i8 [[V7]], i8* [[V11]], align 1
setge	2(%r11,%rbx,2)

## SETGEr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = xor i1 [[V5]], true
# CHECK-NEXT: [[V7:%.+]] = zext i1 [[V6]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V7]], metadata !"BPL")
setge	%bpl

## SETGm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
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
# CHECK-NEXT: [[V10:%.+]] = zext i1 [[V9]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V11:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V12:%.+]] = add i64 [[V11]], 2
# CHECK-NEXT: [[V13:%.+]] = add i64 [[R11_0]], [[V12]]
# CHECK-NEXT: [[V14:%.+]] = inttoptr i64 [[V13]] to i8*
# CHECK-NEXT: store i8 [[V10]], i8* [[V14]], align 1
setg	2(%r11,%rbx,2)

## SETGr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
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
# CHECK-NEXT: [[V10:%.+]] = zext i1 [[V9]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V10]], metadata !"BPL")
setg	%bpl

## SETLEm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
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
# CHECK-NEXT: [[V9:%.+]] = zext i1 [[V8]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V10:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V11:%.+]] = add i64 [[V10]], 2
# CHECK-NEXT: [[V12:%.+]] = add i64 [[R11_0]], [[V11]]
# CHECK-NEXT: [[V13:%.+]] = inttoptr i64 [[V12]] to i8*
# CHECK-NEXT: store i8 [[V9]], i8* [[V13]], align 1
setle	2(%r11,%rbx,2)

## SETLEr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
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
# CHECK-NEXT: [[V9:%.+]] = zext i1 [[V8]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V9]], metadata !"BPL")
setle	%bpl

## SETLm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = zext i1 [[V5]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V7:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V8:%.+]] = add i64 [[V7]], 2
# CHECK-NEXT: [[V9:%.+]] = add i64 [[R11_0]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = inttoptr i64 [[V9]] to i8*
# CHECK-NEXT: store i8 [[V6]], i8* [[V10]], align 1
setl	2(%r11,%rbx,2)

## SETLr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[EFLAGS_2:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V3:%.+]] = lshr i32 [[EFLAGS_2]], 11
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i1
# CHECK-NEXT: [[V5:%.+]] = xor i1 [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = zext i1 [[V5]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V6]], metadata !"BPL")
setl	%bpl

## SETNEm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V3]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V5:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = add i64 [[R11_0]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = inttoptr i64 [[V7]] to i8*
# CHECK-NEXT: store i8 [[V4]], i8* [[V8]], align 1
setne	2(%r11,%rbx,2)

## SETNEr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 6
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V3]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V4]], metadata !"BPL")
setne	%bpl

## SETNOm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V3]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V5:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = add i64 [[R11_0]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = inttoptr i64 [[V7]] to i8*
# CHECK-NEXT: store i8 [[V4]], i8* [[V8]], align 1
setno	2(%r11,%rbx,2)

## SETNOr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V3]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V4]], metadata !"BPL")
setno	%bpl

## SETNPm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V3]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V5:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = add i64 [[R11_0]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = inttoptr i64 [[V7]] to i8*
# CHECK-NEXT: store i8 [[V4]], i8* [[V8]], align 1
setnp	2(%r11,%rbx,2)

## SETNPr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V3]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V4]], metadata !"BPL")
setnp	%bpl

## SETNSm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V3]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V5:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = add i64 [[R11_0]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = inttoptr i64 [[V7]] to i8*
# CHECK-NEXT: store i8 [[V4]], i8* [[V8]], align 1
setns	2(%r11,%rbx,2)

## SETNSr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = xor i1 [[V2]], true
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V3]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V4]], metadata !"BPL")
setns	%bpl

## SETOm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i8*
# CHECK-NEXT: store i8 [[V3]], i8* [[V7]], align 1
seto	2(%r11,%rbx,2)

## SETOr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 11
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V3]], metadata !"BPL")
seto	%bpl

## SETPm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i8*
# CHECK-NEXT: store i8 [[V3]], i8* [[V7]], align 1
setp	2(%r11,%rbx,2)

## SETPr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 2
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V3]], metadata !"BPL")
setp	%bpl

## SETSm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i8*
# CHECK-NEXT: store i8 [[V3]], i8* [[V7]], align 1
sets	2(%r11,%rbx,2)

## SETSr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[EFLAGS_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V1:%.+]] = lshr i32 [[EFLAGS_1]], 7
# CHECK-NEXT: [[V2:%.+]] = trunc i32 [[V1]] to i1
# CHECK-NEXT: [[V3:%.+]] = zext i1 [[V2]] to i8
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[V3]], metadata !"BPL")
sets	%bpl

retq
