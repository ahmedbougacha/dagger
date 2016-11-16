# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## CVTDQ2PDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = bitcast i64* [[V4]] to <2 x i64>*
# CHECK-NEXT: [[V6:%.+]] = load <2 x i64>, <2 x i64>* [[V5]], align 1
# CHECK-NEXT: [[V7:%.+]] = bitcast <2 x i64> [[V6]] to <4 x i32>
# CHECK-NEXT: [[V8:%.+]] = shufflevector <4 x i32> [[V7]], <4 x i32> undef, <2 x i32> <i32 0, i32 1>
# CHECK-NEXT: [[V9:%.+]] = sitofp <2 x i32> [[V8]] to <2 x double>
# CHECK-NEXT: [[V10:%.+]] = bitcast <2 x double> [[V9]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V10]], metadata !"XMM8")
cvtdq2pd	2(%rbx,%r14,2), %xmm8

## CVTDQ2PDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[V3:%.+]] = shufflevector <4 x i32> [[V2]], <4 x i32> undef, <2 x i32> <i32 0, i32 1>
# CHECK-NEXT: [[V4:%.+]] = sitofp <2 x i32> [[V3]] to <2 x double>
# CHECK-NEXT: [[V5:%.+]] = bitcast <2 x double> [[V4]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V5]], metadata !"XMM8")
cvtdq2pd	%xmm9, %xmm8

retq
