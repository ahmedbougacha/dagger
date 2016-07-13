# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MUL16m
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AX_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"AX")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = zext i16 [[AX_0]] to i32
# CHECK-NEXT: [[V7:%.+]] = zext i16 [[V5]] to i32
# CHECK-NEXT: [[V8:%.+]] = mul i32 [[V6]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = trunc i32 [[V8]] to i16
# CHECK-NEXT: [[V10:%.+]] = lshr i32 [[V8]], 16
# CHECK-NEXT: [[V11:%.+]] = trunc i32 [[V10]] to i16
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V9]], metadata !"AX")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V11]], metadata !"DX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
mulw	2(%r11,%rbx,2)

## MUL16r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AX_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"AX")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = zext i16 [[AX_0]] to i32
# CHECK-NEXT: [[V2:%.+]] = zext i16 [[R8W_0]] to i32
# CHECK-NEXT: [[V3:%.+]] = mul i32 [[V1]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = trunc i32 [[V3]] to i16
# CHECK-NEXT: [[V5:%.+]] = lshr i32 [[V3]], 16
# CHECK-NEXT: [[V6:%.+]] = trunc i32 [[V5]] to i16
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"AX")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V6]], metadata !"DX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
mulw	%r8w

## MUL32m
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EAX_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EAX")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = zext i32 [[EAX_0]] to i64
# CHECK-NEXT: [[V7:%.+]] = zext i32 [[V5]] to i64
# CHECK-NEXT: [[V8:%.+]] = mul i64 [[V6]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = trunc i64 [[V8]] to i32
# CHECK-NEXT: [[V10:%.+]] = lshr i64 [[V8]], 32
# CHECK-NEXT: [[V11:%.+]] = trunc i64 [[V10]] to i32
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"EAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V11]], metadata !"EDX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
mull	2(%r11,%rbx,2)

## MUL32r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EAX_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EAX")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = zext i32 [[EAX_0]] to i64
# CHECK-NEXT: [[V2:%.+]] = zext i32 [[R8D_0]] to i64
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[V1]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = trunc i64 [[V3]] to i32
# CHECK-NEXT: [[V5:%.+]] = lshr i64 [[V3]], 32
# CHECK-NEXT: [[V6:%.+]] = trunc i64 [[V5]] to i32
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"EAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"EDX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
mull	%r8d

## MUL64m
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RAX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RAX")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = zext i64 [[RAX_0]] to i128
# CHECK-NEXT: [[V7:%.+]] = zext i64 [[V5]] to i128
# CHECK-NEXT: [[V8:%.+]] = mul i128 [[V6]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = trunc i128 [[V8]] to i64
# CHECK-NEXT: [[V10:%.+]] = lshr i128 [[V8]], 64
# CHECK-NEXT: [[V11:%.+]] = trunc i128 [[V10]] to i64
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"RAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V11]], metadata !"RDX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
mulq	2(%r11,%rbx,2)

## MUL64r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RAX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RAX")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = zext i64 [[RAX_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = zext i64 [[R11_0]] to i128
# CHECK-NEXT: [[V3:%.+]] = mul i128 [[V1]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = trunc i128 [[V3]] to i64
# CHECK-NEXT: [[V5:%.+]] = lshr i128 [[V3]], 64
# CHECK-NEXT: [[V6:%.+]] = trunc i128 [[V5]] to i64
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"RAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"RDX")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
mulq	%r11

## MUL8m
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
mulb	2(%r11,%rbx,2)

## MUL8r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
mulb	%bpl

## MULSSrm
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
# CHECK-NEXT: [[V9:%.+]] = fmul float [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = bitcast float [[V9]] to i32
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V12:%.+]] = zext i32 [[V10]] to i128
# CHECK-NEXT: [[V13:%.+]] = and i128 [[V11]], -4294967296
# CHECK-NEXT: [[V14:%.+]] = or i128 [[V12]], [[V13]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V14]], metadata !"XMM8")
mulss	2(%r14,%r15,2), %xmm8

## MULSSrr
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
# CHECK-NEXT: [[V7:%.+]] = fmul float [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = bitcast float [[V7]] to i32
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V9:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V10:%.+]] = zext i32 [[V8]] to i128
# CHECK-NEXT: [[V11:%.+]] = and i128 [[V9]], -4294967296
# CHECK-NEXT: [[V12:%.+]] = or i128 [[V10]], [[V11]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V12]], metadata !"XMM8")
mulss	%xmm10, %xmm8

retq
