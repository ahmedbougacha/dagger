# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## HSUBPDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x double>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <2 x double>*
# CHECK-NEXT: [[V7:%.+]] = load <2 x double>, <2 x double>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = extractelement <2 x double> [[V2]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <2 x double> [[V2]], i32 1
# CHECK-NEXT: [[V10:%.+]] = fsub double [[V8]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = insertelement <2 x double> undef, double [[V10]], i32 0
# CHECK-NEXT: [[V12:%.+]] = extractelement <2 x double> [[V7]], i32 0
# CHECK-NEXT: [[V13:%.+]] = extractelement <2 x double> [[V7]], i32 1
# CHECK-NEXT: [[V14:%.+]] = fsub double [[V12]], [[V13]]
# CHECK-NEXT: [[V15:%.+]] = insertelement <2 x double> [[V11]], double [[V14]], i32 2
# CHECK-NEXT: [[V16:%.+]] = bitcast <2 x double> [[V15]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V16]], metadata !"XMM8")
hsubpd	2(%r14,%r15,2), %xmm8

## HSUBPDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x double>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <2 x double>
# CHECK-NEXT: [[V5:%.+]] = extractelement <2 x double> [[V2]], i32 0
# CHECK-NEXT: [[V6:%.+]] = extractelement <2 x double> [[V2]], i32 1
# CHECK-NEXT: [[V7:%.+]] = fsub double [[V5]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = insertelement <2 x double> undef, double [[V7]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <2 x double> [[V4]], i32 0
# CHECK-NEXT: [[V10:%.+]] = extractelement <2 x double> [[V4]], i32 1
# CHECK-NEXT: [[V11:%.+]] = fsub double [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <2 x double> [[V8]], double [[V11]], i32 2
# CHECK-NEXT: [[V13:%.+]] = bitcast <2 x double> [[V12]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V13]], metadata !"XMM8")
hsubpd	%xmm10, %xmm8

retq
