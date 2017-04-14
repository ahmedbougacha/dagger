# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPCMOVrmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM15_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM15")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM15_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <2 x i64>
# CHECK-NEXT: [[V5:%.+]] = and <2 x i64> [[V2]], [[V4]]
# CHECK-NEXT: [[XMM15_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM15")
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x float> [[XMM15_1]] to i128
# CHECK-NEXT: [[V7:%.+]] = bitcast i128 [[V6]] to <2 x i64>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V8:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V9:%.+]] = add i64 [[V8]], 2
# CHECK-NEXT: [[V10:%.+]] = add i64 [[R14_0]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to <2 x i64>*
# CHECK-NEXT: [[V12:%.+]] = load <2 x i64>, <2 x i64>* [[V11]], align 1
# CHECK-NEXT: [[V13:%.+]] = xor <2 x i64> [[V7]], <i64 -1, i64 -1>
# CHECK-NEXT: [[V14:%.+]] = and <2 x i64> [[V13]], [[V12]]
# CHECK-NEXT: [[V15:%.+]] = or <2 x i64> [[V5]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = bitcast <2 x i64> [[V15]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V16]], metadata !"XMM8")
vpcmov	%xmm15, 2(%r14,%r15,2), %xmm9, %xmm8

## VPCMOVrmrY
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM15_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM15")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM15_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <4 x i64>
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V3:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V4:%.+]] = bitcast i256 [[V3]] to <4 x i64>
# CHECK-NEXT: [[V5:%.+]] = and <4 x i64> [[V2]], [[V4]]
# CHECK-NEXT: [[YMM15_1:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM15")
# CHECK-NEXT: [[V6:%.+]] = bitcast <8 x float> [[YMM15_1]] to i256
# CHECK-NEXT: [[V7:%.+]] = bitcast i256 [[V6]] to <4 x i64>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V8:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V9:%.+]] = add i64 [[V8]], 2
# CHECK-NEXT: [[V10:%.+]] = add i64 [[R14_0]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to <4 x i64>*
# CHECK-NEXT: [[V12:%.+]] = load <4 x i64>, <4 x i64>* [[V11]], align 1
# CHECK-NEXT: [[V13:%.+]] = xor <4 x i64> [[V7]], <i64 -1, i64 -1, i64 -1, i64 -1>
# CHECK-NEXT: [[V14:%.+]] = and <4 x i64> [[V13]], [[V12]]
# CHECK-NEXT: [[V15:%.+]] = or <4 x i64> [[V5]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = bitcast <4 x i64> [[V15]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V16]], metadata !"YMM8")
vpcmov	%ymm15, 2(%r14,%r15,2), %ymm9, %ymm8

## VPCMOVrrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[R12_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R12")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R12_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R15_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to <2 x i64>*
# CHECK-NEXT: [[V5:%.+]] = load <2 x i64>, <2 x i64>* [[V4]], align 1
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V7:%.+]] = bitcast i128 [[V6]] to <2 x i64>
# CHECK-NEXT: [[V8:%.+]] = and <2 x i64> [[V5]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V3]] to <2 x i64>*
# CHECK-NEXT: [[V10:%.+]] = load <2 x i64>, <2 x i64>* [[V9]], align 1
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V12:%.+]] = bitcast i128 [[V11]] to <2 x i64>
# CHECK-NEXT: [[V13:%.+]] = xor <2 x i64> [[V10]], <i64 -1, i64 -1>
# CHECK-NEXT: [[V14:%.+]] = and <2 x i64> [[V13]], [[V12]]
# CHECK-NEXT: [[V15:%.+]] = or <2 x i64> [[V8]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = bitcast <2 x i64> [[V15]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V16]], metadata !"XMM8")
vpcmov	2(%r15,%r12,2), %xmm10, %xmm9, %xmm8

## VPCMOVrrmY
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[R12_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R12")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R12_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R15_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to <4 x i64>*
# CHECK-NEXT: [[V5:%.+]] = load <4 x i64>, <4 x i64>* [[V4]], align 1
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V6:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V7:%.+]] = bitcast i256 [[V6]] to <4 x i64>
# CHECK-NEXT: [[V8:%.+]] = and <4 x i64> [[V5]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V3]] to <4 x i64>*
# CHECK-NEXT: [[V10:%.+]] = load <4 x i64>, <4 x i64>* [[V9]], align 1
# CHECK-NEXT: [[YMM10_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM10")
# CHECK-NEXT: [[V11:%.+]] = bitcast <8 x float> [[YMM10_0]] to i256
# CHECK-NEXT: [[V12:%.+]] = bitcast i256 [[V11]] to <4 x i64>
# CHECK-NEXT: [[V13:%.+]] = xor <4 x i64> [[V10]], <i64 -1, i64 -1, i64 -1, i64 -1>
# CHECK-NEXT: [[V14:%.+]] = and <4 x i64> [[V13]], [[V12]]
# CHECK-NEXT: [[V15:%.+]] = or <4 x i64> [[V8]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = bitcast <4 x i64> [[V15]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V16]], metadata !"YMM8")
vpcmov	2(%r15,%r12,2), %ymm10, %ymm9, %ymm8

## VPCMOVrrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM11_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM11")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM11_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <2 x i64>
# CHECK-NEXT: [[V5:%.+]] = and <2 x i64> [[V2]], [[V4]]
# CHECK-NEXT: [[XMM11_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM11")
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x float> [[XMM11_1]] to i128
# CHECK-NEXT: [[V7:%.+]] = bitcast i128 [[V6]] to <2 x i64>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V8:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V9:%.+]] = bitcast i128 [[V8]] to <2 x i64>
# CHECK-NEXT: [[V10:%.+]] = xor <2 x i64> [[V7]], <i64 -1, i64 -1>
# CHECK-NEXT: [[V11:%.+]] = and <2 x i64> [[V10]], [[V9]]
# CHECK-NEXT: [[V12:%.+]] = or <2 x i64> [[V5]], [[V11]]
# CHECK-NEXT: [[V13:%.+]] = bitcast <2 x i64> [[V12]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V13]], metadata !"XMM8")
vpcmov	%xmm11, %xmm10, %xmm9, %xmm8

## VPCMOVrrrY
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM11_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM11")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM11_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <4 x i64>
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V3:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V4:%.+]] = bitcast i256 [[V3]] to <4 x i64>
# CHECK-NEXT: [[V5:%.+]] = and <4 x i64> [[V2]], [[V4]]
# CHECK-NEXT: [[YMM11_1:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM11")
# CHECK-NEXT: [[V6:%.+]] = bitcast <8 x float> [[YMM11_1]] to i256
# CHECK-NEXT: [[V7:%.+]] = bitcast i256 [[V6]] to <4 x i64>
# CHECK-NEXT: [[YMM10_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM10")
# CHECK-NEXT: [[V8:%.+]] = bitcast <8 x float> [[YMM10_0]] to i256
# CHECK-NEXT: [[V9:%.+]] = bitcast i256 [[V8]] to <4 x i64>
# CHECK-NEXT: [[V10:%.+]] = xor <4 x i64> [[V7]], <i64 -1, i64 -1, i64 -1, i64 -1>
# CHECK-NEXT: [[V11:%.+]] = and <4 x i64> [[V10]], [[V9]]
# CHECK-NEXT: [[V12:%.+]] = or <4 x i64> [[V5]], [[V11]]
# CHECK-NEXT: [[V13:%.+]] = bitcast <4 x i64> [[V12]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V13]], metadata !"YMM8")
vpcmov	%ymm11, %ymm10, %ymm9, %ymm8

## VPCMOVrrrY_REV:	vpcmov	%ymm11, %ymm10, %ymm9, %ymm8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
.byte 0x8f; .byte 0x48; .byte 0xb4; .byte 0xa2; .byte 0xc3; .byte 0xa0

## VPCMOVrrr_REV:	vpcmov	%xmm11, %xmm10, %xmm9, %xmm8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: call void @llvm.trap()
.byte 0x8f; .byte 0x48; .byte 0xb0; .byte 0xa2; .byte 0xc3; .byte 0xa0

retq
