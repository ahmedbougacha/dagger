# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## UCOMISDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[RBX_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to double*
# CHECK-NEXT: [[V8:%.+]] = load double, double* [[V7]], align 1
# CHECK-NEXT: [[V9:%.+]] = fcmp ueq double [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = fcmp uno double [[V3]], [[V8]]
# CHECK-NEXT: [[V11:%.+]] = fcmp ult double [[V3]], [[V8]]
# CHECK-NEXT: [[V12:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V13:%.+]] = zext i1 [[V11]] to i32
# CHECK-NEXT: [[V14:%.+]] = shl i32 [[V13]], 0
# CHECK-NEXT: [[V15:%.+]] = or i32 [[V14]], [[V12]]
# CHECK-NEXT: [[V16:%.+]] = zext i1 [[V10]] to i32
# CHECK-NEXT: [[V17:%.+]] = shl i32 [[V16]], 2
# CHECK-NEXT: [[V18:%.+]] = or i32 [[V17]], [[V15]]
# CHECK-NEXT: [[V19:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V20:%.+]] = shl i32 [[V19]], 4
# CHECK-NEXT: [[V21:%.+]] = or i32 [[V20]], [[V18]]
# CHECK-NEXT: [[V22:%.+]] = zext i1 [[V9]] to i32
# CHECK-NEXT: [[V23:%.+]] = shl i32 [[V22]], 6
# CHECK-NEXT: [[V24:%.+]] = or i32 [[V23]], [[V21]]
# CHECK-NEXT: [[V25:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V26:%.+]] = shl i32 [[V25]], 7
# CHECK-NEXT: [[V27:%.+]] = or i32 [[V26]], [[V24]]
# CHECK-NEXT: [[V28:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 11
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V30]], metadata !"EFLAGS")
ucomisd	2(%rbx,%r14,2), %xmm8

## UCOMISDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i64
# CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to double
# CHECK-NEXT: [[V7:%.+]] = fcmp ueq double [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = fcmp uno double [[V3]], [[V6]]
# CHECK-NEXT: [[V9:%.+]] = fcmp ult double [[V3]], [[V6]]
# CHECK-NEXT: [[V10:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V11:%.+]] = zext i1 [[V9]] to i32
# CHECK-NEXT: [[V12:%.+]] = shl i32 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = or i32 [[V12]], [[V10]]
# CHECK-NEXT: [[V14:%.+]] = zext i1 [[V8]] to i32
# CHECK-NEXT: [[V15:%.+]] = shl i32 [[V14]], 2
# CHECK-NEXT: [[V16:%.+]] = or i32 [[V15]], [[V13]]
# CHECK-NEXT: [[V17:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V18:%.+]] = shl i32 [[V17]], 4
# CHECK-NEXT: [[V19:%.+]] = or i32 [[V18]], [[V16]]
# CHECK-NEXT: [[V20:%.+]] = zext i1 [[V7]] to i32
# CHECK-NEXT: [[V21:%.+]] = shl i32 [[V20]], 6
# CHECK-NEXT: [[V22:%.+]] = or i32 [[V21]], [[V19]]
# CHECK-NEXT: [[V23:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 7
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 11
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V28]], metadata !"EFLAGS")
ucomisd	%xmm9, %xmm8

retq
