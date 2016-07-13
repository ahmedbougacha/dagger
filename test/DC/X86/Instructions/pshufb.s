# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MMX_PSHUFBrm64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pshufb	2(%r14,%r15,2), %mm4

## MMX_PSHUFBrr64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pshufb	%mm6, %mm4

## PSHUFBrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R14_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <2 x i64>*
# CHECK-NEXT: [[V7:%.+]] = load <2 x i64>, <2 x i64>* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = bitcast <2 x i64> [[V7]] to <16 x i8>
# CHECK-NEXT: [[V9:%.+]] = icmp uge <16 x i8> [[V8]], <i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128>
# CHECK-NEXT: [[V10:%.+]] = select <16 x i1> [[V9]], <16 x i8> zeroinitializer, <16 x i8> [[V8]]
# CHECK-NEXT: [[V11:%.+]] = and <16 x i8> [[V10]], <i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15>
# CHECK-NEXT: [[V12:%.+]] = extractelement <16 x i8> [[V2]], i32 0
# CHECK-NEXT: [[V13:%.+]] = extractelement <16 x i8> [[V11]], i32 0
# CHECK-NEXT: [[V14:%.+]] = insertelement <16 x i8> undef, i8 [[V12]], i8 [[V13]]
# CHECK-NEXT: [[V15:%.+]] = extractelement <16 x i8> [[V2]], i32 1
# CHECK-NEXT: [[V16:%.+]] = extractelement <16 x i8> [[V11]], i32 1
# CHECK-NEXT: [[V17:%.+]] = insertelement <16 x i8> [[V14]], i8 [[V15]], i8 [[V16]]
# CHECK-NEXT: [[V18:%.+]] = extractelement <16 x i8> [[V2]], i32 2
# CHECK-NEXT: [[V19:%.+]] = extractelement <16 x i8> [[V11]], i32 2
# CHECK-NEXT: [[V20:%.+]] = insertelement <16 x i8> [[V17]], i8 [[V18]], i8 [[V19]]
# CHECK-NEXT: [[V21:%.+]] = extractelement <16 x i8> [[V2]], i32 3
# CHECK-NEXT: [[V22:%.+]] = extractelement <16 x i8> [[V11]], i32 3
# CHECK-NEXT: [[V23:%.+]] = insertelement <16 x i8> [[V20]], i8 [[V21]], i8 [[V22]]
# CHECK-NEXT: [[V24:%.+]] = extractelement <16 x i8> [[V2]], i32 4
# CHECK-NEXT: [[V25:%.+]] = extractelement <16 x i8> [[V11]], i32 4
# CHECK-NEXT: [[V26:%.+]] = insertelement <16 x i8> [[V23]], i8 [[V24]], i8 [[V25]]
# CHECK-NEXT: [[V27:%.+]] = extractelement <16 x i8> [[V2]], i32 5
# CHECK-NEXT: [[V28:%.+]] = extractelement <16 x i8> [[V11]], i32 5
# CHECK-NEXT: [[V29:%.+]] = insertelement <16 x i8> [[V26]], i8 [[V27]], i8 [[V28]]
# CHECK-NEXT: [[V30:%.+]] = extractelement <16 x i8> [[V2]], i32 6
# CHECK-NEXT: [[V31:%.+]] = extractelement <16 x i8> [[V11]], i32 6
# CHECK-NEXT: [[V32:%.+]] = insertelement <16 x i8> [[V29]], i8 [[V30]], i8 [[V31]]
# CHECK-NEXT: [[V33:%.+]] = extractelement <16 x i8> [[V2]], i32 7
# CHECK-NEXT: [[V34:%.+]] = extractelement <16 x i8> [[V11]], i32 7
# CHECK-NEXT: [[V35:%.+]] = insertelement <16 x i8> [[V32]], i8 [[V33]], i8 [[V34]]
# CHECK-NEXT: [[V36:%.+]] = extractelement <16 x i8> [[V2]], i32 8
# CHECK-NEXT: [[V37:%.+]] = extractelement <16 x i8> [[V11]], i32 8
# CHECK-NEXT: [[V38:%.+]] = insertelement <16 x i8> [[V35]], i8 [[V36]], i8 [[V37]]
# CHECK-NEXT: [[V39:%.+]] = extractelement <16 x i8> [[V2]], i32 9
# CHECK-NEXT: [[V40:%.+]] = extractelement <16 x i8> [[V11]], i32 9
# CHECK-NEXT: [[V41:%.+]] = insertelement <16 x i8> [[V38]], i8 [[V39]], i8 [[V40]]
# CHECK-NEXT: [[V42:%.+]] = extractelement <16 x i8> [[V2]], i32 10
# CHECK-NEXT: [[V43:%.+]] = extractelement <16 x i8> [[V11]], i32 10
# CHECK-NEXT: [[V44:%.+]] = insertelement <16 x i8> [[V41]], i8 [[V42]], i8 [[V43]]
# CHECK-NEXT: [[V45:%.+]] = extractelement <16 x i8> [[V2]], i32 11
# CHECK-NEXT: [[V46:%.+]] = extractelement <16 x i8> [[V11]], i32 11
# CHECK-NEXT: [[V47:%.+]] = insertelement <16 x i8> [[V44]], i8 [[V45]], i8 [[V46]]
# CHECK-NEXT: [[V48:%.+]] = extractelement <16 x i8> [[V2]], i32 12
# CHECK-NEXT: [[V49:%.+]] = extractelement <16 x i8> [[V11]], i32 12
# CHECK-NEXT: [[V50:%.+]] = insertelement <16 x i8> [[V47]], i8 [[V48]], i8 [[V49]]
# CHECK-NEXT: [[V51:%.+]] = extractelement <16 x i8> [[V2]], i32 13
# CHECK-NEXT: [[V52:%.+]] = extractelement <16 x i8> [[V11]], i32 13
# CHECK-NEXT: [[V53:%.+]] = insertelement <16 x i8> [[V50]], i8 [[V51]], i8 [[V52]]
# CHECK-NEXT: [[V54:%.+]] = extractelement <16 x i8> [[V2]], i32 14
# CHECK-NEXT: [[V55:%.+]] = extractelement <16 x i8> [[V11]], i32 14
# CHECK-NEXT: [[V56:%.+]] = insertelement <16 x i8> [[V53]], i8 [[V54]], i8 [[V55]]
# CHECK-NEXT: [[V57:%.+]] = extractelement <16 x i8> [[V2]], i32 15
# CHECK-NEXT: [[V58:%.+]] = extractelement <16 x i8> [[V11]], i32 15
# CHECK-NEXT: [[V59:%.+]] = insertelement <16 x i8> [[V56]], i8 [[V57]], i8 [[V58]]
# CHECK-NEXT: [[V60:%.+]] = bitcast <16 x i8> [[V59]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V60]], metadata !"XMM8")
pshufb	2(%r14,%r15,2), %xmm8

## PSHUFBrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V3:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <16 x i8>
# CHECK-NEXT: [[V5:%.+]] = icmp uge <16 x i8> [[V4]], <i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128>
# CHECK-NEXT: [[V6:%.+]] = select <16 x i1> [[V5]], <16 x i8> zeroinitializer, <16 x i8> [[V4]]
# CHECK-NEXT: [[V7:%.+]] = and <16 x i8> [[V6]], <i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15>
# CHECK-NEXT: [[V8:%.+]] = extractelement <16 x i8> [[V2]], i32 0
# CHECK-NEXT: [[V9:%.+]] = extractelement <16 x i8> [[V7]], i32 0
# CHECK-NEXT: [[V10:%.+]] = insertelement <16 x i8> undef, i8 [[V8]], i8 [[V9]]
# CHECK-NEXT: [[V11:%.+]] = extractelement <16 x i8> [[V2]], i32 1
# CHECK-NEXT: [[V12:%.+]] = extractelement <16 x i8> [[V7]], i32 1
# CHECK-NEXT: [[V13:%.+]] = insertelement <16 x i8> [[V10]], i8 [[V11]], i8 [[V12]]
# CHECK-NEXT: [[V14:%.+]] = extractelement <16 x i8> [[V2]], i32 2
# CHECK-NEXT: [[V15:%.+]] = extractelement <16 x i8> [[V7]], i32 2
# CHECK-NEXT: [[V16:%.+]] = insertelement <16 x i8> [[V13]], i8 [[V14]], i8 [[V15]]
# CHECK-NEXT: [[V17:%.+]] = extractelement <16 x i8> [[V2]], i32 3
# CHECK-NEXT: [[V18:%.+]] = extractelement <16 x i8> [[V7]], i32 3
# CHECK-NEXT: [[V19:%.+]] = insertelement <16 x i8> [[V16]], i8 [[V17]], i8 [[V18]]
# CHECK-NEXT: [[V20:%.+]] = extractelement <16 x i8> [[V2]], i32 4
# CHECK-NEXT: [[V21:%.+]] = extractelement <16 x i8> [[V7]], i32 4
# CHECK-NEXT: [[V22:%.+]] = insertelement <16 x i8> [[V19]], i8 [[V20]], i8 [[V21]]
# CHECK-NEXT: [[V23:%.+]] = extractelement <16 x i8> [[V2]], i32 5
# CHECK-NEXT: [[V24:%.+]] = extractelement <16 x i8> [[V7]], i32 5
# CHECK-NEXT: [[V25:%.+]] = insertelement <16 x i8> [[V22]], i8 [[V23]], i8 [[V24]]
# CHECK-NEXT: [[V26:%.+]] = extractelement <16 x i8> [[V2]], i32 6
# CHECK-NEXT: [[V27:%.+]] = extractelement <16 x i8> [[V7]], i32 6
# CHECK-NEXT: [[V28:%.+]] = insertelement <16 x i8> [[V25]], i8 [[V26]], i8 [[V27]]
# CHECK-NEXT: [[V29:%.+]] = extractelement <16 x i8> [[V2]], i32 7
# CHECK-NEXT: [[V30:%.+]] = extractelement <16 x i8> [[V7]], i32 7
# CHECK-NEXT: [[V31:%.+]] = insertelement <16 x i8> [[V28]], i8 [[V29]], i8 [[V30]]
# CHECK-NEXT: [[V32:%.+]] = extractelement <16 x i8> [[V2]], i32 8
# CHECK-NEXT: [[V33:%.+]] = extractelement <16 x i8> [[V7]], i32 8
# CHECK-NEXT: [[V34:%.+]] = insertelement <16 x i8> [[V31]], i8 [[V32]], i8 [[V33]]
# CHECK-NEXT: [[V35:%.+]] = extractelement <16 x i8> [[V2]], i32 9
# CHECK-NEXT: [[V36:%.+]] = extractelement <16 x i8> [[V7]], i32 9
# CHECK-NEXT: [[V37:%.+]] = insertelement <16 x i8> [[V34]], i8 [[V35]], i8 [[V36]]
# CHECK-NEXT: [[V38:%.+]] = extractelement <16 x i8> [[V2]], i32 10
# CHECK-NEXT: [[V39:%.+]] = extractelement <16 x i8> [[V7]], i32 10
# CHECK-NEXT: [[V40:%.+]] = insertelement <16 x i8> [[V37]], i8 [[V38]], i8 [[V39]]
# CHECK-NEXT: [[V41:%.+]] = extractelement <16 x i8> [[V2]], i32 11
# CHECK-NEXT: [[V42:%.+]] = extractelement <16 x i8> [[V7]], i32 11
# CHECK-NEXT: [[V43:%.+]] = insertelement <16 x i8> [[V40]], i8 [[V41]], i8 [[V42]]
# CHECK-NEXT: [[V44:%.+]] = extractelement <16 x i8> [[V2]], i32 12
# CHECK-NEXT: [[V45:%.+]] = extractelement <16 x i8> [[V7]], i32 12
# CHECK-NEXT: [[V46:%.+]] = insertelement <16 x i8> [[V43]], i8 [[V44]], i8 [[V45]]
# CHECK-NEXT: [[V47:%.+]] = extractelement <16 x i8> [[V2]], i32 13
# CHECK-NEXT: [[V48:%.+]] = extractelement <16 x i8> [[V7]], i32 13
# CHECK-NEXT: [[V49:%.+]] = insertelement <16 x i8> [[V46]], i8 [[V47]], i8 [[V48]]
# CHECK-NEXT: [[V50:%.+]] = extractelement <16 x i8> [[V2]], i32 14
# CHECK-NEXT: [[V51:%.+]] = extractelement <16 x i8> [[V7]], i32 14
# CHECK-NEXT: [[V52:%.+]] = insertelement <16 x i8> [[V49]], i8 [[V50]], i8 [[V51]]
# CHECK-NEXT: [[V53:%.+]] = extractelement <16 x i8> [[V2]], i32 15
# CHECK-NEXT: [[V54:%.+]] = extractelement <16 x i8> [[V7]], i32 15
# CHECK-NEXT: [[V55:%.+]] = insertelement <16 x i8> [[V52]], i8 [[V53]], i8 [[V54]]
# CHECK-NEXT: [[V56:%.+]] = bitcast <16 x i8> [[V55]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V56]], metadata !"XMM8")
pshufb	%xmm10, %xmm8

retq
