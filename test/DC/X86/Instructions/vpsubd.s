# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPSUBDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <8 x i32>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <4 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <4 x i64>, <4 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <4 x i64> [[V7]] to <8 x i32>
# CHECK-NEXT: [[V9:%.+]] = sub <8 x i32> [[V2]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = bitcast <8 x i32> [[V9]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V10]], metadata !"YMM8")
vpsubd	2(%r14,%r15,2), %ymm9, %ymm8

## VPSUBDYrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <8 x i32>
# CHECK-NEXT: [[YMM10_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <8 x float> [[YMM10_0]] to i256
# CHECK-NEXT: [[V4:%.+]] = bitcast i256 [[V3]] to <8 x i32>
# CHECK-NEXT: [[V5:%.+]] = sub <8 x i32> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = bitcast <8 x i32> [[V5]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V6]], metadata !"YMM8")
vpsubd	%ymm10, %ymm9, %ymm8

## VPSUBDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
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
vpsubd	2(%r14,%r15,2), %xmm9, %xmm8

## VPSUBDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x i32>
# CHECK-NEXT: [[V5:%.+]] = sub <4 x i32> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x i32> [[V5]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V6]], metadata !"XMM8")
vpsubd	%xmm10, %xmm9, %xmm8

retq
