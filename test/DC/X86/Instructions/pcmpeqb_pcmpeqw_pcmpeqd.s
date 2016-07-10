# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MMX_PCMPEQBirm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pcmpeqb	2(%r14,%r15,2), %mm4

## MMX_PCMPEQBirr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pcmpeqb	%mm6, %mm4

## MMX_PCMPEQDirm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pcmpeqd	2(%r14,%r15,2), %mm4

## MMX_PCMPEQDirr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pcmpeqd	%mm6, %mm4

## MMX_PCMPEQWirm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pcmpeqw	2(%r14,%r15,2), %mm4

## MMX_PCMPEQWirr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pcmpeqw	%mm6, %mm4

## PCMPEQBrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <2 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <2 x i64>, <2 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <2 x i64> [[V7]] to <16 x i8>
# CHECK-NEXT: [[V9:%.+]] = icmp eq <16 x i8> [[V2]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = select <16 x i1> [[V9]], <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <16 x i8> zeroinitializer
# CHECK-NEXT: [[V11:%.+]] = bitcast <16 x i8> [[V10]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V11]], metadata !"XMM8")
pcmpeqb	2(%r14,%r15,2), %xmm8

## PCMPEQBrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <16 x i8>
# CHECK-NEXT: [[V5:%.+]] = icmp eq <16 x i8> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = select <16 x i1> [[V5]], <16 x i8> <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, <16 x i8> zeroinitializer
# CHECK-NEXT: [[V7:%.+]] = bitcast <16 x i8> [[V6]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"XMM8")
pcmpeqb	%xmm10, %xmm8

## PCMPEQDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <2 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <2 x i64>, <2 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <2 x i64> [[V7]] to <4 x i32>
# CHECK-NEXT: [[V9:%.+]] = icmp eq <4 x i32> [[V2]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = select <4 x i1> [[V9]], <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> zeroinitializer
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x i32> [[V10]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V11]], metadata !"XMM8")
pcmpeqd	2(%r14,%r15,2), %xmm8

## PCMPEQDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x i32>
# CHECK-NEXT: [[V5:%.+]] = icmp eq <4 x i32> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = select <4 x i1> [[V5]], <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> zeroinitializer
# CHECK-NEXT: [[V7:%.+]] = bitcast <4 x i32> [[V6]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"XMM8")
pcmpeqd	%xmm10, %xmm8

## PCMPEQWrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <2 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <2 x i64>, <2 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <2 x i64> [[V7]] to <8 x i16>
# CHECK-NEXT: [[V9:%.+]] = icmp eq <8 x i16> [[V2]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = select <8 x i1> [[V9]], <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>, <8 x i16> zeroinitializer
# CHECK-NEXT: [[V11:%.+]] = bitcast <8 x i16> [[V10]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V11]], metadata !"XMM8")
pcmpeqw	2(%r14,%r15,2), %xmm8

## PCMPEQWrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <8 x i16>
# CHECK-NEXT: [[V5:%.+]] = icmp eq <8 x i16> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = select <8 x i1> [[V5]], <8 x i16> <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>, <8 x i16> zeroinitializer
# CHECK-NEXT: [[V7:%.+]] = bitcast <8 x i16> [[V6]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"XMM8")
pcmpeqw	%xmm10, %xmm8

retq
