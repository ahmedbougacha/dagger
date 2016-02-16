# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MOVHPSmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM13_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM13")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM13_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[V2]] to <2 x double>
# CHECK-NEXT: [[XMM13_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM13")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM13_1]] to i128
# CHECK-NEXT: [[V5:%.+]] = bitcast i128 [[V4]] to <4 x float>
# CHECK-NEXT: [[V6:%.+]] = bitcast <4 x float> [[V5]] to <2 x double>
# CHECK-NEXT: [[V7:%.+]] = shufflevector <2 x double> [[V3]], <2 x double> [[V6]], <2 x i32> <i32 1, i32 3>
# CHECK-NEXT: [[V8:%.+]] = extractelement <2 x double> [[V7]], i64 0
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V9:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V10:%.+]] = add i64 [[V9]], 2
# CHECK-NEXT: [[V11:%.+]] = add i64 [[R11_0]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = inttoptr i64 [[V11]] to double*
# CHECK-NEXT: store double [[V8]], double* [[V12]], align 1
movhps	%xmm13, 2(%r11,%rbx,2)

## MOVHPSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to double*
# CHECK-NEXT: [[V7:%.+]] = load double, double* [[V6]], align 1
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
movhps	2(%r14,%r15,2), %xmm8

retq
