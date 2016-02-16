# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## CVTSD2SSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to double*
# CHECK-NEXT: [[V5:%.+]] = load double, double* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = fptrunc double [[V5]] to float
# CHECK-NEXT: [[V7:%.+]] = bitcast float [[V6]] to i32
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V8:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V9:%.+]] = zext i32 [[V7]] to i128
# CHECK-NEXT: [[V10:%.+]] = and i128 [[V8]], -4294967296
# CHECK-NEXT: [[V11:%.+]] = or i128 [[V9]], [[V10]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V11]], metadata !"XMM8")
cvtsd2ss	2(%rbx,%r14,2), %xmm8

## CVTSD2SSrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[V4:%.+]] = fptrunc double [[V3]] to float
# CHECK-NEXT: [[V5:%.+]] = bitcast float [[V4]] to i32
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V7:%.+]] = zext i32 [[V5]] to i128
# CHECK-NEXT: [[V8:%.+]] = and i128 [[V6]], -4294967296
# CHECK-NEXT: [[V9:%.+]] = or i128 [[V7]], [[V8]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V9]], metadata !"XMM8")
cvtsd2ss	%xmm9, %xmm8

retq
