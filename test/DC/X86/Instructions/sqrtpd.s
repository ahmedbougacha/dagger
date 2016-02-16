# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## SQRTPDm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to <2 x double>*
# CHECK-NEXT: [[V5:%.+]] = load <2 x double>, <2 x double>* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = call <2 x double> @llvm.sqrt.v2f64(<2 x double> [[V5]])
# CHECK-NEXT: [[V7:%.+]] = bitcast <2 x double> [[V6]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"XMM8")
sqrtpd	2(%rbx,%r14,2), %xmm8

## SQRTPDr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x double>
# CHECK-NEXT: [[V3:%.+]] = call <2 x double> @llvm.sqrt.v2f64(<2 x double> [[V2]])
# CHECK-NEXT: [[V4:%.+]] = bitcast <2 x double> [[V3]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"XMM8")
sqrtpd	%xmm9, %xmm8

retq
