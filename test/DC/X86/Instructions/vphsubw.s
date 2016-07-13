# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VPHSUBWYrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <16 x i16>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <4 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <4 x i64>, <4 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <4 x i64> [[V7]] to <16 x i16>
# CHECK-NEXT: [[V9:%.+]] = extractelement <16 x i16> [[V2]], i32 0
# CHECK-NEXT: [[V10:%.+]] = extractelement <16 x i16> [[V2]], i32 1
# CHECK-NEXT: [[V11:%.+]] = sub i16 [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <16 x i16> undef, i16 [[V11]], i32 0
# CHECK-NEXT: [[V13:%.+]] = extractelement <16 x i16> [[V2]], i32 1
# CHECK-NEXT: [[V14:%.+]] = extractelement <16 x i16> [[V2]], i32 2
# CHECK-NEXT: [[V15:%.+]] = sub i16 [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <16 x i16> [[V12]], i16 [[V15]], i32 1
# CHECK-NEXT: [[V17:%.+]] = extractelement <16 x i16> [[V2]], i32 2
# CHECK-NEXT: [[V18:%.+]] = extractelement <16 x i16> [[V2]], i32 3
# CHECK-NEXT: [[V19:%.+]] = sub i16 [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <16 x i16> [[V16]], i16 [[V19]], i32 2
# CHECK-NEXT: [[V21:%.+]] = extractelement <16 x i16> [[V2]], i32 3
# CHECK-NEXT: [[V22:%.+]] = extractelement <16 x i16> [[V2]], i32 4
# CHECK-NEXT: [[V23:%.+]] = sub i16 [[V21]], [[V22]]
# CHECK-NEXT: [[V24:%.+]] = insertelement <16 x i16> [[V20]], i16 [[V23]], i32 3
# CHECK-NEXT: [[V25:%.+]] = extractelement <16 x i16> [[V2]], i32 4
# CHECK-NEXT: [[V26:%.+]] = extractelement <16 x i16> [[V2]], i32 5
# CHECK-NEXT: [[V27:%.+]] = sub i16 [[V25]], [[V26]]
# CHECK-NEXT: [[V28:%.+]] = insertelement <16 x i16> [[V24]], i16 [[V27]], i32 4
# CHECK-NEXT: [[V29:%.+]] = extractelement <16 x i16> [[V2]], i32 5
# CHECK-NEXT: [[V30:%.+]] = extractelement <16 x i16> [[V2]], i32 6
# CHECK-NEXT: [[V31:%.+]] = sub i16 [[V29]], [[V30]]
# CHECK-NEXT: [[V32:%.+]] = insertelement <16 x i16> [[V28]], i16 [[V31]], i32 5
# CHECK-NEXT: [[V33:%.+]] = extractelement <16 x i16> [[V2]], i32 6
# CHECK-NEXT: [[V34:%.+]] = extractelement <16 x i16> [[V2]], i32 7
# CHECK-NEXT: [[V35:%.+]] = sub i16 [[V33]], [[V34]]
# CHECK-NEXT: [[V36:%.+]] = insertelement <16 x i16> [[V32]], i16 [[V35]], i32 6
# CHECK-NEXT: [[V37:%.+]] = extractelement <16 x i16> [[V2]], i32 7
# CHECK-NEXT: [[V38:%.+]] = extractelement <16 x i16> [[V2]], i32 8
# CHECK-NEXT: [[V39:%.+]] = sub i16 [[V37]], [[V38]]
# CHECK-NEXT: [[V40:%.+]] = insertelement <16 x i16> [[V36]], i16 [[V39]], i32 7
# CHECK-NEXT: [[V41:%.+]] = extractelement <16 x i16> [[V8]], i32 0
# CHECK-NEXT: [[V42:%.+]] = extractelement <16 x i16> [[V8]], i32 1
# CHECK-NEXT: [[V43:%.+]] = sub i16 [[V41]], [[V42]]
# CHECK-NEXT: [[V44:%.+]] = insertelement <16 x i16> [[V40]], i16 [[V43]], i32 16
# CHECK-NEXT: [[V45:%.+]] = extractelement <16 x i16> [[V8]], i32 1
# CHECK-NEXT: [[V46:%.+]] = extractelement <16 x i16> [[V8]], i32 2
# CHECK-NEXT: [[V47:%.+]] = sub i16 [[V45]], [[V46]]
# CHECK-NEXT: [[V48:%.+]] = insertelement <16 x i16> [[V44]], i16 [[V47]], i32 17
# CHECK-NEXT: [[V49:%.+]] = extractelement <16 x i16> [[V8]], i32 2
# CHECK-NEXT: [[V50:%.+]] = extractelement <16 x i16> [[V8]], i32 3
# CHECK-NEXT: [[V51:%.+]] = sub i16 [[V49]], [[V50]]
# CHECK-NEXT: [[V52:%.+]] = insertelement <16 x i16> [[V48]], i16 [[V51]], i32 18
# CHECK-NEXT: [[V53:%.+]] = extractelement <16 x i16> [[V8]], i32 3
# CHECK-NEXT: [[V54:%.+]] = extractelement <16 x i16> [[V8]], i32 4
# CHECK-NEXT: [[V55:%.+]] = sub i16 [[V53]], [[V54]]
# CHECK-NEXT: [[V56:%.+]] = insertelement <16 x i16> [[V52]], i16 [[V55]], i32 19
# CHECK-NEXT: [[V57:%.+]] = extractelement <16 x i16> [[V8]], i32 4
# CHECK-NEXT: [[V58:%.+]] = extractelement <16 x i16> [[V8]], i32 5
# CHECK-NEXT: [[V59:%.+]] = sub i16 [[V57]], [[V58]]
# CHECK-NEXT: [[V60:%.+]] = insertelement <16 x i16> [[V56]], i16 [[V59]], i32 20
# CHECK-NEXT: [[V61:%.+]] = extractelement <16 x i16> [[V8]], i32 5
# CHECK-NEXT: [[V62:%.+]] = extractelement <16 x i16> [[V8]], i32 6
# CHECK-NEXT: [[V63:%.+]] = sub i16 [[V61]], [[V62]]
# CHECK-NEXT: [[V64:%.+]] = insertelement <16 x i16> [[V60]], i16 [[V63]], i32 21
# CHECK-NEXT: [[V65:%.+]] = extractelement <16 x i16> [[V8]], i32 6
# CHECK-NEXT: [[V66:%.+]] = extractelement <16 x i16> [[V8]], i32 7
# CHECK-NEXT: [[V67:%.+]] = sub i16 [[V65]], [[V66]]
# CHECK-NEXT: [[V68:%.+]] = insertelement <16 x i16> [[V64]], i16 [[V67]], i32 22
# CHECK-NEXT: [[V69:%.+]] = extractelement <16 x i16> [[V8]], i32 7
# CHECK-NEXT: [[V70:%.+]] = extractelement <16 x i16> [[V8]], i32 8
# CHECK-NEXT: [[V71:%.+]] = sub i16 [[V69]], [[V70]]
# CHECK-NEXT: [[V72:%.+]] = insertelement <16 x i16> [[V68]], i16 [[V71]], i32 23
# CHECK-NEXT: [[V73:%.+]] = bitcast <16 x i16> [[V72]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V73]], metadata !"YMM8")
vphsubw	2(%r14,%r15,2), %ymm9, %ymm8

## VPHSUBWYrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[YMM9_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <8 x float> [[YMM9_0]] to i256
# CHECK-NEXT: [[V2:%.+]] = bitcast i256 [[V1]] to <16 x i16>
# CHECK-NEXT: [[YMM10_0:%.+]] = call <8 x float> @llvm.dc.getreg.v8f32(metadata !"YMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <8 x float> [[YMM10_0]] to i256
# CHECK-NEXT: [[V4:%.+]] = bitcast i256 [[V3]] to <16 x i16>
# CHECK-NEXT: [[V5:%.+]] = extractelement <16 x i16> [[V2]], i32 0
# CHECK-NEXT: [[V6:%.+]] = extractelement <16 x i16> [[V2]], i32 1
# CHECK-NEXT: [[V7:%.+]] = sub i16 [[V5]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = insertelement <16 x i16> undef, i16 [[V7]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <16 x i16> [[V2]], i32 1
# CHECK-NEXT: [[V10:%.+]] = extractelement <16 x i16> [[V2]], i32 2
# CHECK-NEXT: [[V11:%.+]] = sub i16 [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <16 x i16> [[V8]], i16 [[V11]], i32 1
# CHECK-NEXT: [[V13:%.+]] = extractelement <16 x i16> [[V2]], i32 2
# CHECK-NEXT: [[V14:%.+]] = extractelement <16 x i16> [[V2]], i32 3
# CHECK-NEXT: [[V15:%.+]] = sub i16 [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <16 x i16> [[V12]], i16 [[V15]], i32 2
# CHECK-NEXT: [[V17:%.+]] = extractelement <16 x i16> [[V2]], i32 3
# CHECK-NEXT: [[V18:%.+]] = extractelement <16 x i16> [[V2]], i32 4
# CHECK-NEXT: [[V19:%.+]] = sub i16 [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <16 x i16> [[V16]], i16 [[V19]], i32 3
# CHECK-NEXT: [[V21:%.+]] = extractelement <16 x i16> [[V2]], i32 4
# CHECK-NEXT: [[V22:%.+]] = extractelement <16 x i16> [[V2]], i32 5
# CHECK-NEXT: [[V23:%.+]] = sub i16 [[V21]], [[V22]]
# CHECK-NEXT: [[V24:%.+]] = insertelement <16 x i16> [[V20]], i16 [[V23]], i32 4
# CHECK-NEXT: [[V25:%.+]] = extractelement <16 x i16> [[V2]], i32 5
# CHECK-NEXT: [[V26:%.+]] = extractelement <16 x i16> [[V2]], i32 6
# CHECK-NEXT: [[V27:%.+]] = sub i16 [[V25]], [[V26]]
# CHECK-NEXT: [[V28:%.+]] = insertelement <16 x i16> [[V24]], i16 [[V27]], i32 5
# CHECK-NEXT: [[V29:%.+]] = extractelement <16 x i16> [[V2]], i32 6
# CHECK-NEXT: [[V30:%.+]] = extractelement <16 x i16> [[V2]], i32 7
# CHECK-NEXT: [[V31:%.+]] = sub i16 [[V29]], [[V30]]
# CHECK-NEXT: [[V32:%.+]] = insertelement <16 x i16> [[V28]], i16 [[V31]], i32 6
# CHECK-NEXT: [[V33:%.+]] = extractelement <16 x i16> [[V2]], i32 7
# CHECK-NEXT: [[V34:%.+]] = extractelement <16 x i16> [[V2]], i32 8
# CHECK-NEXT: [[V35:%.+]] = sub i16 [[V33]], [[V34]]
# CHECK-NEXT: [[V36:%.+]] = insertelement <16 x i16> [[V32]], i16 [[V35]], i32 7
# CHECK-NEXT: [[V37:%.+]] = extractelement <16 x i16> [[V4]], i32 0
# CHECK-NEXT: [[V38:%.+]] = extractelement <16 x i16> [[V4]], i32 1
# CHECK-NEXT: [[V39:%.+]] = sub i16 [[V37]], [[V38]]
# CHECK-NEXT: [[V40:%.+]] = insertelement <16 x i16> [[V36]], i16 [[V39]], i32 16
# CHECK-NEXT: [[V41:%.+]] = extractelement <16 x i16> [[V4]], i32 1
# CHECK-NEXT: [[V42:%.+]] = extractelement <16 x i16> [[V4]], i32 2
# CHECK-NEXT: [[V43:%.+]] = sub i16 [[V41]], [[V42]]
# CHECK-NEXT: [[V44:%.+]] = insertelement <16 x i16> [[V40]], i16 [[V43]], i32 17
# CHECK-NEXT: [[V45:%.+]] = extractelement <16 x i16> [[V4]], i32 2
# CHECK-NEXT: [[V46:%.+]] = extractelement <16 x i16> [[V4]], i32 3
# CHECK-NEXT: [[V47:%.+]] = sub i16 [[V45]], [[V46]]
# CHECK-NEXT: [[V48:%.+]] = insertelement <16 x i16> [[V44]], i16 [[V47]], i32 18
# CHECK-NEXT: [[V49:%.+]] = extractelement <16 x i16> [[V4]], i32 3
# CHECK-NEXT: [[V50:%.+]] = extractelement <16 x i16> [[V4]], i32 4
# CHECK-NEXT: [[V51:%.+]] = sub i16 [[V49]], [[V50]]
# CHECK-NEXT: [[V52:%.+]] = insertelement <16 x i16> [[V48]], i16 [[V51]], i32 19
# CHECK-NEXT: [[V53:%.+]] = extractelement <16 x i16> [[V4]], i32 4
# CHECK-NEXT: [[V54:%.+]] = extractelement <16 x i16> [[V4]], i32 5
# CHECK-NEXT: [[V55:%.+]] = sub i16 [[V53]], [[V54]]
# CHECK-NEXT: [[V56:%.+]] = insertelement <16 x i16> [[V52]], i16 [[V55]], i32 20
# CHECK-NEXT: [[V57:%.+]] = extractelement <16 x i16> [[V4]], i32 5
# CHECK-NEXT: [[V58:%.+]] = extractelement <16 x i16> [[V4]], i32 6
# CHECK-NEXT: [[V59:%.+]] = sub i16 [[V57]], [[V58]]
# CHECK-NEXT: [[V60:%.+]] = insertelement <16 x i16> [[V56]], i16 [[V59]], i32 21
# CHECK-NEXT: [[V61:%.+]] = extractelement <16 x i16> [[V4]], i32 6
# CHECK-NEXT: [[V62:%.+]] = extractelement <16 x i16> [[V4]], i32 7
# CHECK-NEXT: [[V63:%.+]] = sub i16 [[V61]], [[V62]]
# CHECK-NEXT: [[V64:%.+]] = insertelement <16 x i16> [[V60]], i16 [[V63]], i32 22
# CHECK-NEXT: [[V65:%.+]] = extractelement <16 x i16> [[V4]], i32 7
# CHECK-NEXT: [[V66:%.+]] = extractelement <16 x i16> [[V4]], i32 8
# CHECK-NEXT: [[V67:%.+]] = sub i16 [[V65]], [[V66]]
# CHECK-NEXT: [[V68:%.+]] = insertelement <16 x i16> [[V64]], i16 [[V67]], i32 23
# CHECK-NEXT: [[V69:%.+]] = bitcast <16 x i16> [[V68]] to i256
# CHECK-NEXT: call void @llvm.dc.setreg.i256(i256 [[V69]], metadata !"YMM8")
vphsubw	%ymm10, %ymm9, %ymm8

## VPHSUBWrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <2 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <2 x i64>, <2 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <2 x i64> [[V7]] to <8 x i16>
# CHECK-NEXT: [[V9:%.+]] = extractelement <8 x i16> [[V2]], i32 0
# CHECK-NEXT: [[V10:%.+]] = extractelement <8 x i16> [[V2]], i32 1
# CHECK-NEXT: [[V11:%.+]] = sub i16 [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <8 x i16> undef, i16 [[V11]], i32 0
# CHECK-NEXT: [[V13:%.+]] = extractelement <8 x i16> [[V2]], i32 1
# CHECK-NEXT: [[V14:%.+]] = extractelement <8 x i16> [[V2]], i32 2
# CHECK-NEXT: [[V15:%.+]] = sub i16 [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <8 x i16> [[V12]], i16 [[V15]], i32 1
# CHECK-NEXT: [[V17:%.+]] = extractelement <8 x i16> [[V2]], i32 2
# CHECK-NEXT: [[V18:%.+]] = extractelement <8 x i16> [[V2]], i32 3
# CHECK-NEXT: [[V19:%.+]] = sub i16 [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <8 x i16> [[V16]], i16 [[V19]], i32 2
# CHECK-NEXT: [[V21:%.+]] = extractelement <8 x i16> [[V2]], i32 3
# CHECK-NEXT: [[V22:%.+]] = extractelement <8 x i16> [[V2]], i32 4
# CHECK-NEXT: [[V23:%.+]] = sub i16 [[V21]], [[V22]]
# CHECK-NEXT: [[V24:%.+]] = insertelement <8 x i16> [[V20]], i16 [[V23]], i32 3
# CHECK-NEXT: [[V25:%.+]] = extractelement <8 x i16> [[V8]], i32 0
# CHECK-NEXT: [[V26:%.+]] = extractelement <8 x i16> [[V8]], i32 1
# CHECK-NEXT: [[V27:%.+]] = sub i16 [[V25]], [[V26]]
# CHECK-NEXT: [[V28:%.+]] = insertelement <8 x i16> [[V24]], i16 [[V27]], i32 8
# CHECK-NEXT: [[V29:%.+]] = extractelement <8 x i16> [[V8]], i32 1
# CHECK-NEXT: [[V30:%.+]] = extractelement <8 x i16> [[V8]], i32 2
# CHECK-NEXT: [[V31:%.+]] = sub i16 [[V29]], [[V30]]
# CHECK-NEXT: [[V32:%.+]] = insertelement <8 x i16> [[V28]], i16 [[V31]], i32 9
# CHECK-NEXT: [[V33:%.+]] = extractelement <8 x i16> [[V8]], i32 2
# CHECK-NEXT: [[V34:%.+]] = extractelement <8 x i16> [[V8]], i32 3
# CHECK-NEXT: [[V35:%.+]] = sub i16 [[V33]], [[V34]]
# CHECK-NEXT: [[V36:%.+]] = insertelement <8 x i16> [[V32]], i16 [[V35]], i32 10
# CHECK-NEXT: [[V37:%.+]] = extractelement <8 x i16> [[V8]], i32 3
# CHECK-NEXT: [[V38:%.+]] = extractelement <8 x i16> [[V8]], i32 4
# CHECK-NEXT: [[V39:%.+]] = sub i16 [[V37]], [[V38]]
# CHECK-NEXT: [[V40:%.+]] = insertelement <8 x i16> [[V36]], i16 [[V39]], i32 11
# CHECK-NEXT: [[V41:%.+]] = bitcast <8 x i16> [[V40]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V41]], metadata !"XMM8")
vphsubw	2(%r14,%r15,2), %xmm9, %xmm8

## VPHSUBWrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <8 x i16>
# CHECK-NEXT: [[V5:%.+]] = extractelement <8 x i16> [[V2]], i32 0
# CHECK-NEXT: [[V6:%.+]] = extractelement <8 x i16> [[V2]], i32 1
# CHECK-NEXT: [[V7:%.+]] = sub i16 [[V5]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = insertelement <8 x i16> undef, i16 [[V7]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <8 x i16> [[V2]], i32 1
# CHECK-NEXT: [[V10:%.+]] = extractelement <8 x i16> [[V2]], i32 2
# CHECK-NEXT: [[V11:%.+]] = sub i16 [[V9]], [[V10]]
# CHECK-NEXT: [[V12:%.+]] = insertelement <8 x i16> [[V8]], i16 [[V11]], i32 1
# CHECK-NEXT: [[V13:%.+]] = extractelement <8 x i16> [[V2]], i32 2
# CHECK-NEXT: [[V14:%.+]] = extractelement <8 x i16> [[V2]], i32 3
# CHECK-NEXT: [[V15:%.+]] = sub i16 [[V13]], [[V14]]
# CHECK-NEXT: [[V16:%.+]] = insertelement <8 x i16> [[V12]], i16 [[V15]], i32 2
# CHECK-NEXT: [[V17:%.+]] = extractelement <8 x i16> [[V2]], i32 3
# CHECK-NEXT: [[V18:%.+]] = extractelement <8 x i16> [[V2]], i32 4
# CHECK-NEXT: [[V19:%.+]] = sub i16 [[V17]], [[V18]]
# CHECK-NEXT: [[V20:%.+]] = insertelement <8 x i16> [[V16]], i16 [[V19]], i32 3
# CHECK-NEXT: [[V21:%.+]] = extractelement <8 x i16> [[V4]], i32 0
# CHECK-NEXT: [[V22:%.+]] = extractelement <8 x i16> [[V4]], i32 1
# CHECK-NEXT: [[V23:%.+]] = sub i16 [[V21]], [[V22]]
# CHECK-NEXT: [[V24:%.+]] = insertelement <8 x i16> [[V20]], i16 [[V23]], i32 8
# CHECK-NEXT: [[V25:%.+]] = extractelement <8 x i16> [[V4]], i32 1
# CHECK-NEXT: [[V26:%.+]] = extractelement <8 x i16> [[V4]], i32 2
# CHECK-NEXT: [[V27:%.+]] = sub i16 [[V25]], [[V26]]
# CHECK-NEXT: [[V28:%.+]] = insertelement <8 x i16> [[V24]], i16 [[V27]], i32 9
# CHECK-NEXT: [[V29:%.+]] = extractelement <8 x i16> [[V4]], i32 2
# CHECK-NEXT: [[V30:%.+]] = extractelement <8 x i16> [[V4]], i32 3
# CHECK-NEXT: [[V31:%.+]] = sub i16 [[V29]], [[V30]]
# CHECK-NEXT: [[V32:%.+]] = insertelement <8 x i16> [[V28]], i16 [[V31]], i32 10
# CHECK-NEXT: [[V33:%.+]] = extractelement <8 x i16> [[V4]], i32 3
# CHECK-NEXT: [[V34:%.+]] = extractelement <8 x i16> [[V4]], i32 4
# CHECK-NEXT: [[V35:%.+]] = sub i16 [[V33]], [[V34]]
# CHECK-NEXT: [[V36:%.+]] = insertelement <8 x i16> [[V32]], i16 [[V35]], i32 11
# CHECK-NEXT: [[V37:%.+]] = bitcast <8 x i16> [[V36]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V37]], metadata !"XMM8")
vphsubw	%xmm10, %xmm9, %xmm8

retq
