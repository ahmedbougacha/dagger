# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPHSUBDYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <8 x i32>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <4 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <4 x i64>, <4 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <4 x i64> [[V7]] to <8 x i32>
# CHECK-NEXT: [[V9:%.+]] = extractelement <8 x i32> [[V2]], i32 0
# CHECK-NEXT: [[V10:%.+]] = extractelement <8 x i32> [[V2]], i32 1
# CHECK-NEXT: [[V11:%.+]] = sub i32 [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <8 x i32> undef, i32 [[V11]], i32 0
# CHECK-NEXT: [[V13:%.+]] = extractelement <8 x i32> [[V2]], i32 1
# CHECK-NEXT: [[V14:%.+]] = extractelement <8 x i32> [[V2]], i32 2
# CHECK-NEXT: [[V15:%.+]] = sub i32 [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <8 x i32> [[V12]], i32 [[V15]], i32 1
# CHECK-NEXT: [[V17:%.+]] = extractelement <8 x i32> [[V2]], i32 2
# CHECK-NEXT: [[V18:%.+]] = extractelement <8 x i32> [[V2]], i32 3
# CHECK-NEXT: [[V19:%.+]] = sub i32 [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <8 x i32> [[V16]], i32 [[V19]], i32 2
# CHECK-NEXT: [[V21:%.+]] = extractelement <8 x i32> [[V2]], i32 3
# CHECK-NEXT: [[V22:%.+]] = extractelement <8 x i32> [[V2]], i32 4
# CHECK-NEXT: [[V23:%.+]] = sub i32 [[V21]], [[V22]]
# CHECK-NEXT: [[V24:%.+]] = insertelement <8 x i32> [[V20]], i32 [[V23]], i32 3
# CHECK-NEXT: [[V25:%.+]] = extractelement <8 x i32> [[V8]], i32 0
# CHECK-NEXT: [[V26:%.+]] = extractelement <8 x i32> [[V8]], i32 1
# CHECK-NEXT: [[V27:%.+]] = sub i32 [[V25]], [[V26]]
# CHECK-NEXT: [[V28:%.+]] = insertelement <8 x i32> [[V24]], i32 [[V27]], i32 8
# CHECK-NEXT: [[V29:%.+]] = extractelement <8 x i32> [[V8]], i32 1
# CHECK-NEXT: [[V30:%.+]] = extractelement <8 x i32> [[V8]], i32 2
# CHECK-NEXT: [[V31:%.+]] = sub i32 [[V29]], [[V30]]
# CHECK-NEXT: [[V32:%.+]] = insertelement <8 x i32> [[V28]], i32 [[V31]], i32 9
# CHECK-NEXT: [[V33:%.+]] = extractelement <8 x i32> [[V8]], i32 2
# CHECK-NEXT: [[V34:%.+]] = extractelement <8 x i32> [[V8]], i32 3
# CHECK-NEXT: [[V35:%.+]] = sub i32 [[V33]], [[V34]]
# CHECK-NEXT: [[V36:%.+]] = insertelement <8 x i32> [[V32]], i32 [[V35]], i32 10
# CHECK-NEXT: [[V37:%.+]] = extractelement <8 x i32> [[V8]], i32 3
# CHECK-NEXT: [[V38:%.+]] = extractelement <8 x i32> [[V8]], i32 4
# CHECK-NEXT: [[V39:%.+]] = sub i32 [[V37]], [[V38]]
# CHECK-NEXT: [[V40:%.+]] = insertelement <8 x i32> [[V36]], i32 [[V39]], i32 11
# CHECK-NEXT: [[V41:%.+]] = bitcast <8 x i32> [[V40]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V41]], metadata !"YMM8")
vphsubd	2(%r14,%r15,2), %ymm9, %ymm8

## VPHSUBDYrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <8 x i32>
# CHECK-NEXT: [[YMM10_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <8 x float> [[YMM10_0]] to i256
# CHECK-NEXT: [[V4:%.+]] = bitcast i256 [[V3]] to <8 x i32>
# CHECK-NEXT: [[V5:%.+]] = extractelement <8 x i32> [[V2]], i32 0
# CHECK-NEXT: [[V6:%.+]] = extractelement <8 x i32> [[V2]], i32 1
# CHECK-NEXT: [[V7:%.+]] = sub i32 [[V5]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = insertelement <8 x i32> undef, i32 [[V7]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <8 x i32> [[V2]], i32 1
# CHECK-NEXT: [[V10:%.+]] = extractelement <8 x i32> [[V2]], i32 2
# CHECK-NEXT: [[V11:%.+]] = sub i32 [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <8 x i32> [[V8]], i32 [[V11]], i32 1
# CHECK-NEXT: [[V13:%.+]] = extractelement <8 x i32> [[V2]], i32 2
# CHECK-NEXT: [[V14:%.+]] = extractelement <8 x i32> [[V2]], i32 3
# CHECK-NEXT: [[V15:%.+]] = sub i32 [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <8 x i32> [[V12]], i32 [[V15]], i32 2
# CHECK-NEXT: [[V17:%.+]] = extractelement <8 x i32> [[V2]], i32 3
# CHECK-NEXT: [[V18:%.+]] = extractelement <8 x i32> [[V2]], i32 4
# CHECK-NEXT: [[V19:%.+]] = sub i32 [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <8 x i32> [[V16]], i32 [[V19]], i32 3
# CHECK-NEXT: [[V21:%.+]] = extractelement <8 x i32> [[V4]], i32 0
# CHECK-NEXT: [[V22:%.+]] = extractelement <8 x i32> [[V4]], i32 1
# CHECK-NEXT: [[V23:%.+]] = sub i32 [[V21]], [[V22]]
# CHECK-NEXT: [[V24:%.+]] = insertelement <8 x i32> [[V20]], i32 [[V23]], i32 8
# CHECK-NEXT: [[V25:%.+]] = extractelement <8 x i32> [[V4]], i32 1
# CHECK-NEXT: [[V26:%.+]] = extractelement <8 x i32> [[V4]], i32 2
# CHECK-NEXT: [[V27:%.+]] = sub i32 [[V25]], [[V26]]
# CHECK-NEXT: [[V28:%.+]] = insertelement <8 x i32> [[V24]], i32 [[V27]], i32 9
# CHECK-NEXT: [[V29:%.+]] = extractelement <8 x i32> [[V4]], i32 2
# CHECK-NEXT: [[V30:%.+]] = extractelement <8 x i32> [[V4]], i32 3
# CHECK-NEXT: [[V31:%.+]] = sub i32 [[V29]], [[V30]]
# CHECK-NEXT: [[V32:%.+]] = insertelement <8 x i32> [[V28]], i32 [[V31]], i32 10
# CHECK-NEXT: [[V33:%.+]] = extractelement <8 x i32> [[V4]], i32 3
# CHECK-NEXT: [[V34:%.+]] = extractelement <8 x i32> [[V4]], i32 4
# CHECK-NEXT: [[V35:%.+]] = sub i32 [[V33]], [[V34]]
# CHECK-NEXT: [[V36:%.+]] = insertelement <8 x i32> [[V32]], i32 [[V35]], i32 11
# CHECK-NEXT: [[V37:%.+]] = bitcast <8 x i32> [[V36]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V37]], metadata !"YMM8")
vphsubd	%ymm10, %ymm9, %ymm8

## VPHSUBDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <2 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <2 x i64>, <2 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <2 x i64> [[V7]] to <4 x i32>
# CHECK-NEXT: [[V9:%.+]] = extractelement <4 x i32> [[V2]], i32 0
# CHECK-NEXT: [[V10:%.+]] = extractelement <4 x i32> [[V2]], i32 1
# CHECK-NEXT: [[V11:%.+]] = sub i32 [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <4 x i32> undef, i32 [[V11]], i32 0
# CHECK-NEXT: [[V13:%.+]] = extractelement <4 x i32> [[V2]], i32 1
# CHECK-NEXT: [[V14:%.+]] = extractelement <4 x i32> [[V2]], i32 2
# CHECK-NEXT: [[V15:%.+]] = sub i32 [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <4 x i32> [[V12]], i32 [[V15]], i32 1
# CHECK-NEXT: [[V17:%.+]] = extractelement <4 x i32> [[V8]], i32 0
# CHECK-NEXT: [[V18:%.+]] = extractelement <4 x i32> [[V8]], i32 1
# CHECK-NEXT: [[V19:%.+]] = sub i32 [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <4 x i32> [[V16]], i32 [[V19]], i32 4
# CHECK-NEXT: [[V21:%.+]] = extractelement <4 x i32> [[V8]], i32 1
# CHECK-NEXT: [[V22:%.+]] = extractelement <4 x i32> [[V8]], i32 2
# CHECK-NEXT: [[V23:%.+]] = sub i32 [[V21]], [[V22]]
# CHECK-NEXT: [[V24:%.+]] = insertelement <4 x i32> [[V20]], i32 [[V23]], i32 5
# CHECK-NEXT: [[V25:%.+]] = bitcast <4 x i32> [[V24]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V25]], metadata !"XMM8")
vphsubd	2(%r14,%r15,2), %xmm9, %xmm8

## VPHSUBDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x i32>
# CHECK-NEXT: [[V5:%.+]] = extractelement <4 x i32> [[V2]], i32 0
# CHECK-NEXT: [[V6:%.+]] = extractelement <4 x i32> [[V2]], i32 1
# CHECK-NEXT: [[V7:%.+]] = sub i32 [[V5]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = insertelement <4 x i32> undef, i32 [[V7]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <4 x i32> [[V2]], i32 1
# CHECK-NEXT: [[V10:%.+]] = extractelement <4 x i32> [[V2]], i32 2
# CHECK-NEXT: [[V11:%.+]] = sub i32 [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <4 x i32> [[V8]], i32 [[V11]], i32 1
# CHECK-NEXT: [[V13:%.+]] = extractelement <4 x i32> [[V4]], i32 0
# CHECK-NEXT: [[V14:%.+]] = extractelement <4 x i32> [[V4]], i32 1
# CHECK-NEXT: [[V15:%.+]] = sub i32 [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <4 x i32> [[V12]], i32 [[V15]], i32 4
# CHECK-NEXT: [[V17:%.+]] = extractelement <4 x i32> [[V4]], i32 1
# CHECK-NEXT: [[V18:%.+]] = extractelement <4 x i32> [[V4]], i32 2
# CHECK-NEXT: [[V19:%.+]] = sub i32 [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <4 x i32> [[V16]], i32 [[V19]], i32 5
# CHECK-NEXT: [[V21:%.+]] = bitcast <4 x i32> [[V20]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V21]], metadata !"XMM8")
vphsubd	%xmm10, %xmm9, %xmm8

retq
