# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MAXSDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R14_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to double*
# CHECK-NEXT: [[V8:%.+]] = load double, double* [[V7]], align 1
# CHECK-NEXT: [[V9:%.+]] = fcmp ule double [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = select i1 [[V9]], double [[V8]], double [[V3]]
# CHECK-NEXT: [[V11:%.+]] = bitcast double [[V10]] to i64
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V12:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V13:%.+]] = zext i64 [[V11]] to i128
# CHECK-NEXT: [[V14:%.+]] = and i128 [[V12]], -18446744073709551616
# CHECK-NEXT: [[V15:%.+]] = or i128 [[V13]], [[V14]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V15]], metadata !"XMM8")
maxsd	2(%r14,%r15,2), %xmm8

## MAXSDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i64
# CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to double
# CHECK-NEXT: [[V7:%.+]] = fcmp ule double [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V7]], double [[V6]], double [[V3]]
# CHECK-NEXT: [[V9:%.+]] = bitcast double [[V8]] to i64
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V10:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V11:%.+]] = zext i64 [[V9]] to i128
# CHECK-NEXT: [[V12:%.+]] = and i128 [[V10]], -18446744073709551616
# CHECK-NEXT: [[V13:%.+]] = or i128 [[V11]], [[V12]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V13]], metadata !"XMM8")
maxsd	%xmm10, %xmm8

retq
