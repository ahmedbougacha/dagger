# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MMX_PSUBBirm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
psubb	2(%r14,%r15,2), %mm4

## MMX_PSUBBirr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
psubb	%mm6, %mm4

## MMX_PSUBDirm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
psubd	2(%r14,%r15,2), %mm4

## MMX_PSUBDirr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
psubd	%mm6, %mm4

## MMX_PSUBWirm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
psubw	2(%r14,%r15,2), %mm4

## MMX_PSUBWirr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
psubw	%mm6, %mm4

## PSUBBrm
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
# CHECK-NEXT: [[V9:%.+]] = sub <16 x i8> [[V2]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = bitcast <16 x i8> [[V9]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V10]], metadata !"XMM8")
psubb	2(%r14,%r15,2), %xmm8

## PSUBBrr
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
# CHECK-NEXT: [[V5:%.+]] = sub <16 x i8> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = bitcast <16 x i8> [[V5]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V6]], metadata !"XMM8")
psubb	%xmm10, %xmm8

## PSUBDrm
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
# CHECK-NEXT: [[V9:%.+]] = sub <4 x i32> [[V2]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = bitcast <4 x i32> [[V9]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V10]], metadata !"XMM8")
psubd	2(%r14,%r15,2), %xmm8

## PSUBDrr
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
# CHECK-NEXT: [[V5:%.+]] = sub <4 x i32> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x i32> [[V5]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V6]], metadata !"XMM8")
psubd	%xmm10, %xmm8

## PSUBWrm
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
# CHECK-NEXT: [[V9:%.+]] = sub <8 x i16> [[V2]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = bitcast <8 x i16> [[V9]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V10]], metadata !"XMM8")
psubw	2(%r14,%r15,2), %xmm8

## PSUBWrr
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
# CHECK-NEXT: [[V5:%.+]] = sub <8 x i16> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = bitcast <8 x i16> [[V5]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V6]], metadata !"XMM8")
psubw	%xmm10, %xmm8

retq
