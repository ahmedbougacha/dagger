# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VMINPSYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <8 x float>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <8 x float>*
# CHECK-NEXT: [[V7:%.+]] = load <8 x float>, <8 x float>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = fcmp uge <8 x float> [[V2]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = select <8 x i1> [[V8]], <8 x float> [[V7]], <8 x float> [[V2]]
# CHECK-NEXT: [[V10:%.+]] = bitcast <8 x float> [[V9]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V10]], metadata !"YMM8")
vminps	2(%r14,%r15,2), %ymm9, %ymm8

## VMINPSYrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <8 x float>
# CHECK-NEXT: [[YMM10_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <8 x float> [[YMM10_0]] to i256
# CHECK-NEXT: [[V4:%.+]] = bitcast i256 [[V3]] to <8 x float>
# CHECK-NEXT: [[V5:%.+]] = fcmp uge <8 x float> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = select <8 x i1> [[V5]], <8 x float> [[V4]], <8 x float> [[V2]]
# CHECK-NEXT: [[V7:%.+]] = bitcast <8 x float> [[V6]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V7]], metadata !"YMM8")
vminps	%ymm10, %ymm9, %ymm8

## VMINPSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <4 x float>*
# CHECK-NEXT: [[V7:%.+]] = load <4 x float>, <4 x float>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = fcmp uge <4 x float> [[V2]], [[V7]]
# CHECK-NEXT: [[V9:%.+]] = select <4 x i1> [[V8]], <4 x float> [[V7]], <4 x float> [[V2]]
# CHECK-NEXT: [[V10:%.+]] = bitcast <4 x float> [[V9]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V10]], metadata !"XMM8")
vminps	2(%r14,%r15,2), %xmm9, %xmm8

## VMINPSrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x float>
# CHECK-NEXT: [[V5:%.+]] = fcmp uge <4 x float> [[V2]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = select <4 x i1> [[V5]], <4 x float> [[V4]], <4 x float> [[V2]]
# CHECK-NEXT: [[V7:%.+]] = bitcast <4 x float> [[V6]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"XMM8")
vminps	%xmm10, %xmm9, %xmm8

retq
