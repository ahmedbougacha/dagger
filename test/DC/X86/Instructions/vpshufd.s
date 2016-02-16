# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPSHUFDYmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to <4 x i64>*
# CHECK-NEXT: [[V5:%.+]] = load <4 x i64>, <4 x i64>* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x i64> [[V5]] to <8 x i32>
# CHECK-NEXT: [[V7:%.+]] = shufflevector <8 x i32> [[V6]], <8 x i32> undef, <8 x i32> <i32 2, i32 0, i32 0, i32 0, i32 6, i32 4, i32 4, i32 4>
# CHECK-NEXT: [[V8:%.+]] = bitcast <8 x i32> [[V7]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V8]], metadata !"YMM8")
vpshufd	$2, 2(%rbx,%r14,2), %ymm8

## VPSHUFDYri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <8 x i32>
# CHECK-NEXT: [[V3:%.+]] = shufflevector <8 x i32> [[V2]], <8 x i32> undef, <8 x i32> <i32 2, i32 0, i32 0, i32 0, i32 6, i32 4, i32 4, i32 4>
# CHECK-NEXT: [[V4:%.+]] = bitcast <8 x i32> [[V3]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V4]], metadata !"YMM8")
vpshufd	$2, %ymm9, %ymm8

## VPSHUFDmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to <2 x i64>*
# CHECK-NEXT: [[V5:%.+]] = load <2 x i64>, <2 x i64>* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = bitcast <2 x i64> [[V5]] to <4 x i32>
# CHECK-NEXT: [[V7:%.+]] = shufflevector <4 x i32> [[V6]], <4 x i32> undef, <4 x i32> <i32 2, i32 0, i32 0, i32 0>
# CHECK-NEXT: [[V8:%.+]] = bitcast <4 x i32> [[V7]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V8]], metadata !"XMM8")
vpshufd	$2, 2(%rbx,%r14,2), %xmm8

## VPSHUFDri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[V3:%.+]] = shufflevector <4 x i32> [[V2]], <4 x i32> undef, <4 x i32> <i32 2, i32 0, i32 0, i32 0>
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x i32> [[V3]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"XMM8")
vpshufd	$2, %xmm9, %xmm8

retq
