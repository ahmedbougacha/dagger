# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VSQRTPSYm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to <8 x float>*
# CHECK-NEXT: [[V5:%.+]] = load <8 x float>, <8 x float>* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = call <8 x float> @llvm.sqrt.v8f32(<8 x float> [[V5]])
# CHECK-NEXT: [[V7:%.+]] = bitcast <8 x float> [[V6]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V7]], metadata !"YMM8")
vsqrtps	2(%rbx,%r14,2), %ymm8

## VSQRTPSYr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <8 x float>
# CHECK-NEXT: [[V3:%.+]] = call <8 x float> @llvm.sqrt.v8f32(<8 x float> [[V2]])
# CHECK-NEXT: [[V4:%.+]] = bitcast <8 x float> [[V3]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V4]], metadata !"YMM8")
vsqrtps	%ymm9, %ymm8

## VSQRTPSm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to <4 x float>*
# CHECK-NEXT: [[V5:%.+]] = load <4 x float>, <4 x float>* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = call <4 x float> @llvm.sqrt.v4f32(<4 x float> [[V5]])
# CHECK-NEXT: [[V7:%.+]] = bitcast <4 x float> [[V6]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"XMM8")
vsqrtps	2(%rbx,%r14,2), %xmm8

## VSQRTPSr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[V3:%.+]] = call <4 x float> @llvm.sqrt.v4f32(<4 x float> [[V2]])
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[V3]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"XMM8")
vsqrtps	%xmm9, %xmm8

retq
