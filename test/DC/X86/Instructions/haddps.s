# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## HADDPSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <4 x float>*
# CHECK-NEXT: [[V7:%.+]] = load <4 x float>, <4 x float>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = extractelement <4 x float> [[V2]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <4 x float> [[V2]], i32 1
# CHECK-NEXT: [[V10:%.+]] = fadd float [[V8]], [[V9]]
# CHECK-NEXT: [[V11:%.+]] = insertelement <4 x float> undef, float [[V10]], i32 0
# CHECK-NEXT: [[V12:%.+]] = extractelement <4 x float> [[V2]], i32 1
# CHECK-NEXT: [[V13:%.+]] = extractelement <4 x float> [[V2]], i32 2
# CHECK-NEXT: [[V14:%.+]] = fadd float [[V12]], [[V13]]
# CHECK-NEXT: [[V15:%.+]] = insertelement <4 x float> [[V11]], float [[V14]], i32 1
# CHECK-NEXT: [[V16:%.+]] = extractelement <4 x float> [[V7]], i32 0
# CHECK-NEXT: [[V17:%.+]] = extractelement <4 x float> [[V7]], i32 1
# CHECK-NEXT: [[V18:%.+]] = fadd float [[V16]], [[V17]]
# CHECK-NEXT: [[V19:%.+]] = insertelement <4 x float> [[V15]], float [[V18]], i32 4
# CHECK-NEXT: [[V20:%.+]] = extractelement <4 x float> [[V7]], i32 1
# CHECK-NEXT: [[V21:%.+]] = extractelement <4 x float> [[V7]], i32 2
# CHECK-NEXT: [[V22:%.+]] = fadd float [[V20]], [[V21]]
# CHECK-NEXT: [[V23:%.+]] = insertelement <4 x float> [[V19]], float [[V22]], i32 5
# CHECK-NEXT: [[V24:%.+]] = bitcast <4 x float> [[V23]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V24]], metadata !"XMM8")
haddps	2(%r14,%r15,2), %xmm8

## HADDPSrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x float>
# CHECK-NEXT: [[V5:%.+]] = extractelement <4 x float> [[V2]], i32 0
# CHECK-NEXT: [[V6:%.+]] = extractelement <4 x float> [[V2]], i32 1
# CHECK-NEXT: [[V7:%.+]] = fadd float [[V5]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = insertelement <4 x float> undef, float [[V7]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <4 x float> [[V2]], i32 1
# CHECK-NEXT: [[V10:%.+]] = extractelement <4 x float> [[V2]], i32 2
# CHECK-NEXT: [[V11:%.+]] = fadd float [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <4 x float> [[V8]], float [[V11]], i32 1
# CHECK-NEXT: [[V13:%.+]] = extractelement <4 x float> [[V4]], i32 0
# CHECK-NEXT: [[V14:%.+]] = extractelement <4 x float> [[V4]], i32 1
# CHECK-NEXT: [[V15:%.+]] = fadd float [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <4 x float> [[V12]], float [[V15]], i32 4
# CHECK-NEXT: [[V17:%.+]] = extractelement <4 x float> [[V4]], i32 1
# CHECK-NEXT: [[V18:%.+]] = extractelement <4 x float> [[V4]], i32 2
# CHECK-NEXT: [[V19:%.+]] = fadd float [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <4 x float> [[V16]], float [[V19]], i32 5
# CHECK-NEXT: [[V21:%.+]] = bitcast <4 x float> [[V20]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V21]], metadata !"XMM8")
haddps	%xmm10, %xmm8

retq
