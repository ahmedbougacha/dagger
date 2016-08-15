# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## XORPSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[V2]] to <2 x i64>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R14_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to <2 x i64>*
# CHECK-NEXT: [[V8:%.+]] = load <2 x i64>, <2 x i64>* [[V7]], align 1
# CHECK-NEXT: [[V9:%.+]] = xor <2 x i64> [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = bitcast <2 x i64> [[V9]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V10]], metadata !"XMM8")
xorps	2(%r14,%r15,2), %xmm8

## XORPSrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[V2]] to <2 x i64>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = bitcast i128 [[V4]] to <4 x float>
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x float> [[V5]] to <2 x i64>
# CHECK-NEXT: [[V7:%.+]] = xor <2 x i64> [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = bitcast <2 x i64> [[V7]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V8]], metadata !"XMM8")
xorps	%xmm10, %xmm8

retq
