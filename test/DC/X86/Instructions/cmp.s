# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## CMP16i16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AX_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"AX")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i16 [[AX_0]], 22136
# CHECK-NEXT: [[V2:%.+]] = icmp uge i16 [[AX_0]], 22136
# CHECK-NEXT: [[V3:%.+]] = icmp ult i16 [[AX_0]], 22136
# CHECK-NEXT: [[V4:%.+]] = icmp ule i16 [[AX_0]], 22136
# CHECK-NEXT: [[V5:%.+]] = icmp slt i16 [[AX_0]], 22136
# CHECK-NEXT: [[V6:%.+]] = icmp sle i16 [[AX_0]], 22136
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i16 [[AX_0]], 22136
# CHECK-NEXT: [[V8:%.+]] = icmp sge i16 [[AX_0]], 22136
# CHECK-NEXT: [[V9:%.+]] = icmp eq i16 [[AX_0]], 22136
# CHECK-NEXT: [[V10:%.+]] = icmp ne i16 [[AX_0]], 22136
# CHECK-NEXT: [[V11:%.+]] = sub i16 [[AX_0]], 22136
# CHECK-NEXT: [[V12:%.+]] = icmp eq i16 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i16 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[AX_0]], i16 22136)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i16, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[AX_0]], i16 22136)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i16, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i16 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpw	$305419896, %ax

## CMP16mi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i16 [[V5]], 22136
# CHECK-NEXT: [[V7:%.+]] = icmp uge i16 [[V5]], 22136
# CHECK-NEXT: [[V8:%.+]] = icmp ult i16 [[V5]], 22136
# CHECK-NEXT: [[V9:%.+]] = icmp ule i16 [[V5]], 22136
# CHECK-NEXT: [[V10:%.+]] = icmp slt i16 [[V5]], 22136
# CHECK-NEXT: [[V11:%.+]] = icmp sle i16 [[V5]], 22136
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i16 [[V5]], 22136
# CHECK-NEXT: [[V13:%.+]] = icmp sge i16 [[V5]], 22136
# CHECK-NEXT: [[V14:%.+]] = icmp eq i16 [[V5]], 22136
# CHECK-NEXT: [[V15:%.+]] = icmp ne i16 [[V5]], 22136
# CHECK-NEXT: [[V16:%.+]] = sub i16 [[V5]], 22136
# CHECK-NEXT: [[V17:%.+]] = icmp eq i16 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i16 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[V5]], i16 22136)
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i16, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[V5]], i16 22136)
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i16, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i16 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpw	$305419896, 2(%r11,%rbx,2)

## CMP16mi8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i16 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp uge i16 [[V5]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp ult i16 [[V5]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp ule i16 [[V5]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp slt i16 [[V5]], 2
# CHECK-NEXT: [[V11:%.+]] = icmp sle i16 [[V5]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i16 [[V5]], 2
# CHECK-NEXT: [[V13:%.+]] = icmp sge i16 [[V5]], 2
# CHECK-NEXT: [[V14:%.+]] = icmp eq i16 [[V5]], 2
# CHECK-NEXT: [[V15:%.+]] = icmp ne i16 [[V5]], 2
# CHECK-NEXT: [[V16:%.+]] = sub i16 [[V5]], 2
# CHECK-NEXT: [[V17:%.+]] = icmp eq i16 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i16 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[V5]], i16 2)
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i16, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[V5]], i16 2)
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i16, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i16 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpw	$2, 2(%r11,%rbx,2)

## CMP16mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[R15W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R15W")
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V7:%.+]] = icmp uge i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V8:%.+]] = icmp ult i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V9:%.+]] = icmp ule i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V10:%.+]] = icmp slt i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V11:%.+]] = icmp sle i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V13:%.+]] = icmp sge i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V14:%.+]] = icmp eq i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V15:%.+]] = icmp ne i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V16:%.+]] = sub i16 [[V5]], [[R15W_0]]
# CHECK-NEXT: [[V17:%.+]] = icmp eq i16 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i16 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[V5]], i16 [[R15W_0]])
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i16, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[V5]], i16 [[R15W_0]])
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i16, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i16 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpw	%r15w, 2(%r11,%rbx,2)

## CMP16ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V2:%.+]] = icmp uge i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V3:%.+]] = icmp ult i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V4:%.+]] = icmp ule i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V5:%.+]] = icmp slt i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V6:%.+]] = icmp sle i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V8:%.+]] = icmp sge i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V9:%.+]] = icmp eq i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V10:%.+]] = icmp ne i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V11:%.+]] = sub i16 [[R8W_0]], 22136
# CHECK-NEXT: [[V12:%.+]] = icmp eq i16 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i16 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[R8W_0]], i16 22136)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i16, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[R8W_0]], i16 22136)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i16, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i16 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpw	$305419896, %r8w

## CMP16ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i16 [[R8W_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp uge i16 [[R8W_0]], 2
# CHECK-NEXT: [[V3:%.+]] = icmp ult i16 [[R8W_0]], 2
# CHECK-NEXT: [[V4:%.+]] = icmp ule i16 [[R8W_0]], 2
# CHECK-NEXT: [[V5:%.+]] = icmp slt i16 [[R8W_0]], 2
# CHECK-NEXT: [[V6:%.+]] = icmp sle i16 [[R8W_0]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i16 [[R8W_0]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp sge i16 [[R8W_0]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp eq i16 [[R8W_0]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp ne i16 [[R8W_0]], 2
# CHECK-NEXT: [[V11:%.+]] = sub i16 [[R8W_0]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp eq i16 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i16 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[R8W_0]], i16 2)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i16, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[R8W_0]], i16 2)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i16, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i16 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpw	$2, %r8w

## CMP16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = icmp uge i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V8:%.+]] = icmp ult i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V9:%.+]] = icmp ule i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V10:%.+]] = icmp slt i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V11:%.+]] = icmp sle i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V13:%.+]] = icmp sge i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V14:%.+]] = icmp eq i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V15:%.+]] = icmp ne i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V16:%.+]] = sub i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V17:%.+]] = icmp eq i16 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i16 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[R8W_0]], i16 [[V5]])
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i16, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[R8W_0]], i16 [[V5]])
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i16, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i16 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpw	2(%rbx,%r14,2), %r8w

## CMP16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R9W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R9W")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V2:%.+]] = icmp uge i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V3:%.+]] = icmp ult i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V4:%.+]] = icmp ule i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V5:%.+]] = icmp slt i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V6:%.+]] = icmp sle i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V8:%.+]] = icmp sge i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V9:%.+]] = icmp eq i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V10:%.+]] = icmp ne i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V11:%.+]] = sub i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V12:%.+]] = icmp eq i16 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i16 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[R8W_0]], i16 [[R9W_0]])
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i16, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[R8W_0]], i16 [[R9W_0]])
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i16, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i16 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpw	%r9w, %r8w

## CMP16rr_REV:	cmpw	%r9w, %r8w
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x66; .byte 0x45; .byte 0x3b; .byte 0xc1

## CMP32i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EAX_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EAX")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V2:%.+]] = icmp uge i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V3:%.+]] = icmp ult i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V4:%.+]] = icmp ule i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V5:%.+]] = icmp slt i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V6:%.+]] = icmp sle i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V8:%.+]] = icmp sge i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V9:%.+]] = icmp eq i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V10:%.+]] = icmp ne i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V11:%.+]] = sub i32 [[EAX_0]], 305419896
# CHECK-NEXT: [[V12:%.+]] = icmp eq i32 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i32 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[EAX_0]], i32 305419896)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i32, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[EAX_0]], i32 305419896)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i32, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i32 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpl	$305419896, %eax

## CMP32mi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 9
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i32 [[V5]], 305419896
# CHECK-NEXT: [[V7:%.+]] = icmp uge i32 [[V5]], 305419896
# CHECK-NEXT: [[V8:%.+]] = icmp ult i32 [[V5]], 305419896
# CHECK-NEXT: [[V9:%.+]] = icmp ule i32 [[V5]], 305419896
# CHECK-NEXT: [[V10:%.+]] = icmp slt i32 [[V5]], 305419896
# CHECK-NEXT: [[V11:%.+]] = icmp sle i32 [[V5]], 305419896
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i32 [[V5]], 305419896
# CHECK-NEXT: [[V13:%.+]] = icmp sge i32 [[V5]], 305419896
# CHECK-NEXT: [[V14:%.+]] = icmp eq i32 [[V5]], 305419896
# CHECK-NEXT: [[V15:%.+]] = icmp ne i32 [[V5]], 305419896
# CHECK-NEXT: [[V16:%.+]] = sub i32 [[V5]], 305419896
# CHECK-NEXT: [[V17:%.+]] = icmp eq i32 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i32 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[V5]], i32 305419896)
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i32, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[V5]], i32 305419896)
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i32, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i32 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpl	$305419896, 2(%r11,%rbx,2)

## CMP32mi8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i32 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp uge i32 [[V5]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp ult i32 [[V5]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp ule i32 [[V5]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp slt i32 [[V5]], 2
# CHECK-NEXT: [[V11:%.+]] = icmp sle i32 [[V5]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i32 [[V5]], 2
# CHECK-NEXT: [[V13:%.+]] = icmp sge i32 [[V5]], 2
# CHECK-NEXT: [[V14:%.+]] = icmp eq i32 [[V5]], 2
# CHECK-NEXT: [[V15:%.+]] = icmp ne i32 [[V5]], 2
# CHECK-NEXT: [[V16:%.+]] = sub i32 [[V5]], 2
# CHECK-NEXT: [[V17:%.+]] = icmp eq i32 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i32 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[V5]], i32 2)
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i32, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[V5]], i32 2)
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i32, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i32 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpl	$2, 2(%r11,%rbx,2)

## CMP32mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[R15D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R15D")
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V7:%.+]] = icmp uge i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V8:%.+]] = icmp ult i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V9:%.+]] = icmp ule i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V10:%.+]] = icmp slt i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V11:%.+]] = icmp sle i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V13:%.+]] = icmp sge i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V14:%.+]] = icmp eq i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V15:%.+]] = icmp ne i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V16:%.+]] = sub i32 [[V5]], [[R15D_0]]
# CHECK-NEXT: [[V17:%.+]] = icmp eq i32 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i32 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[V5]], i32 [[R15D_0]])
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i32, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[V5]], i32 [[R15D_0]])
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i32, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i32 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpl	%r15d, 2(%r11,%rbx,2)

## CMP32ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V2:%.+]] = icmp uge i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V3:%.+]] = icmp ult i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V4:%.+]] = icmp ule i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V5:%.+]] = icmp slt i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V6:%.+]] = icmp sle i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V8:%.+]] = icmp sge i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V9:%.+]] = icmp eq i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V10:%.+]] = icmp ne i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V11:%.+]] = sub i32 [[R8D_0]], 305419896
# CHECK-NEXT: [[V12:%.+]] = icmp eq i32 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i32 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[R8D_0]], i32 305419896)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i32, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[R8D_0]], i32 305419896)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i32, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i32 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpl	$305419896, %r8d

## CMP32ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i32 [[R8D_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp uge i32 [[R8D_0]], 2
# CHECK-NEXT: [[V3:%.+]] = icmp ult i32 [[R8D_0]], 2
# CHECK-NEXT: [[V4:%.+]] = icmp ule i32 [[R8D_0]], 2
# CHECK-NEXT: [[V5:%.+]] = icmp slt i32 [[R8D_0]], 2
# CHECK-NEXT: [[V6:%.+]] = icmp sle i32 [[R8D_0]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i32 [[R8D_0]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp sge i32 [[R8D_0]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp eq i32 [[R8D_0]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp ne i32 [[R8D_0]], 2
# CHECK-NEXT: [[V11:%.+]] = sub i32 [[R8D_0]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp eq i32 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i32 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[R8D_0]], i32 2)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i32, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[R8D_0]], i32 2)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i32, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i32 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpl	$2, %r8d

## CMP32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = icmp uge i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V8:%.+]] = icmp ult i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V9:%.+]] = icmp ule i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V10:%.+]] = icmp slt i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V11:%.+]] = icmp sle i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V13:%.+]] = icmp sge i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V14:%.+]] = icmp eq i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V15:%.+]] = icmp ne i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V16:%.+]] = sub i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V17:%.+]] = icmp eq i32 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i32 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[R8D_0]], i32 [[V5]])
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i32, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[R8D_0]], i32 [[V5]])
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i32, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i32 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpl	2(%rbx,%r14,2), %r8d

## CMP32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R9D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R9D")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V2:%.+]] = icmp uge i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V3:%.+]] = icmp ult i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V4:%.+]] = icmp ule i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V5:%.+]] = icmp slt i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V6:%.+]] = icmp sle i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V8:%.+]] = icmp sge i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V9:%.+]] = icmp eq i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V10:%.+]] = icmp ne i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V11:%.+]] = sub i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V12:%.+]] = icmp eq i32 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i32 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[R8D_0]], i32 [[R9D_0]])
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i32, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[R8D_0]], i32 [[R9D_0]])
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i32, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i32 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpl	%r9d, %r8d

## CMP32rr_REV:	cmpl	%r9d, %r8d
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x45; .byte 0x3b; .byte 0xc1

## CMP64i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RAX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RAX")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V2:%.+]] = icmp uge i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V3:%.+]] = icmp ult i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V4:%.+]] = icmp ule i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V5:%.+]] = icmp slt i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V6:%.+]] = icmp sle i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V8:%.+]] = icmp sge i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V9:%.+]] = icmp eq i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V10:%.+]] = icmp ne i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V11:%.+]] = sub i64 [[RAX_0]], 305419896
# CHECK-NEXT: [[V12:%.+]] = icmp eq i64 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i64 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[RAX_0]], i64 305419896)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i64, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[RAX_0]], i64 305419896)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i64, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i64 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpq	$305419896, %rax

## CMP64mi32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 9
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i64 [[V5]], 305419896
# CHECK-NEXT: [[V7:%.+]] = icmp uge i64 [[V5]], 305419896
# CHECK-NEXT: [[V8:%.+]] = icmp ult i64 [[V5]], 305419896
# CHECK-NEXT: [[V9:%.+]] = icmp ule i64 [[V5]], 305419896
# CHECK-NEXT: [[V10:%.+]] = icmp slt i64 [[V5]], 305419896
# CHECK-NEXT: [[V11:%.+]] = icmp sle i64 [[V5]], 305419896
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i64 [[V5]], 305419896
# CHECK-NEXT: [[V13:%.+]] = icmp sge i64 [[V5]], 305419896
# CHECK-NEXT: [[V14:%.+]] = icmp eq i64 [[V5]], 305419896
# CHECK-NEXT: [[V15:%.+]] = icmp ne i64 [[V5]], 305419896
# CHECK-NEXT: [[V16:%.+]] = sub i64 [[V5]], 305419896
# CHECK-NEXT: [[V17:%.+]] = icmp eq i64 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i64 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[V5]], i64 305419896)
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i64, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[V5]], i64 305419896)
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i64, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i64 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpq	$305419896, 2(%r11,%rbx,2)

## CMP64mi8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i64 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp uge i64 [[V5]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp ult i64 [[V5]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp ule i64 [[V5]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp slt i64 [[V5]], 2
# CHECK-NEXT: [[V11:%.+]] = icmp sle i64 [[V5]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i64 [[V5]], 2
# CHECK-NEXT: [[V13:%.+]] = icmp sge i64 [[V5]], 2
# CHECK-NEXT: [[V14:%.+]] = icmp eq i64 [[V5]], 2
# CHECK-NEXT: [[V15:%.+]] = icmp ne i64 [[V5]], 2
# CHECK-NEXT: [[V16:%.+]] = sub i64 [[V5]], 2
# CHECK-NEXT: [[V17:%.+]] = icmp eq i64 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i64 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[V5]], i64 2)
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i64, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[V5]], i64 2)
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i64, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i64 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpq	$2, 2(%r11,%rbx,2)

## CMP64mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[R13_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R13")
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V7:%.+]] = icmp uge i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V8:%.+]] = icmp ult i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V9:%.+]] = icmp ule i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V10:%.+]] = icmp slt i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V11:%.+]] = icmp sle i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V13:%.+]] = icmp sge i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V14:%.+]] = icmp eq i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V15:%.+]] = icmp ne i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V16:%.+]] = sub i64 [[V5]], [[R13_0]]
# CHECK-NEXT: [[V17:%.+]] = icmp eq i64 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i64 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[V5]], i64 [[R13_0]])
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i64, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[V5]], i64 [[R13_0]])
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i64, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i64 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpq	%r13, 2(%r11,%rbx,2)

## CMP64ri32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V2:%.+]] = icmp uge i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V3:%.+]] = icmp ult i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V4:%.+]] = icmp ule i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V5:%.+]] = icmp slt i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V6:%.+]] = icmp sle i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V8:%.+]] = icmp sge i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V9:%.+]] = icmp eq i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V10:%.+]] = icmp ne i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V11:%.+]] = sub i64 [[R11_0]], 305419896
# CHECK-NEXT: [[V12:%.+]] = icmp eq i64 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i64 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[R11_0]], i64 305419896)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i64, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[R11_0]], i64 305419896)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i64, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i64 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpq	$305419896, %r11

## CMP64ri8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i64 [[R11_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp uge i64 [[R11_0]], 2
# CHECK-NEXT: [[V3:%.+]] = icmp ult i64 [[R11_0]], 2
# CHECK-NEXT: [[V4:%.+]] = icmp ule i64 [[R11_0]], 2
# CHECK-NEXT: [[V5:%.+]] = icmp slt i64 [[R11_0]], 2
# CHECK-NEXT: [[V6:%.+]] = icmp sle i64 [[R11_0]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i64 [[R11_0]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp sge i64 [[R11_0]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp eq i64 [[R11_0]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp ne i64 [[R11_0]], 2
# CHECK-NEXT: [[V11:%.+]] = sub i64 [[R11_0]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp eq i64 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i64 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[R11_0]], i64 2)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i64, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[R11_0]], i64 2)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i64, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i64 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpq	$2, %r11

## CMP64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = icmp uge i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V8:%.+]] = icmp ult i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V9:%.+]] = icmp ule i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V10:%.+]] = icmp slt i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V11:%.+]] = icmp sle i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V13:%.+]] = icmp sge i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V14:%.+]] = icmp eq i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V15:%.+]] = icmp ne i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V16:%.+]] = sub i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V17:%.+]] = icmp eq i64 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i64 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[R11_0]], i64 [[V5]])
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i64, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[R11_0]], i64 [[V5]])
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i64, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = trunc i64 [[V16]] to i8
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V23]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
cmpq	2(%rbx,%r14,2), %r11

## CMP64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V2:%.+]] = icmp uge i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V3:%.+]] = icmp ult i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V4:%.+]] = icmp ule i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V5:%.+]] = icmp slt i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V6:%.+]] = icmp sle i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V8:%.+]] = icmp sge i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V9:%.+]] = icmp eq i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V10:%.+]] = icmp ne i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V11:%.+]] = sub i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V12:%.+]] = icmp eq i64 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i64 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[R11_0]], i64 [[RBX_0]])
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i64, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[R11_0]], i64 [[RBX_0]])
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i64, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = trunc i64 [[V11]] to i8
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V18]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
cmpq	%rbx, %r11

## CMP64rr_REV:	cmpq	%rbx, %r11
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x4c; .byte 0x3b; .byte 0xdb

## CMP8i8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"AL")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i8 [[AL_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp uge i8 [[AL_0]], 2
# CHECK-NEXT: [[V3:%.+]] = icmp ult i8 [[AL_0]], 2
# CHECK-NEXT: [[V4:%.+]] = icmp ule i8 [[AL_0]], 2
# CHECK-NEXT: [[V5:%.+]] = icmp slt i8 [[AL_0]], 2
# CHECK-NEXT: [[V6:%.+]] = icmp sle i8 [[AL_0]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i8 [[AL_0]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp sge i8 [[AL_0]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp eq i8 [[AL_0]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp ne i8 [[AL_0]], 2
# CHECK-NEXT: [[V11:%.+]] = sub i8 [[AL_0]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp eq i8 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i8 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[AL_0]], i8 2)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i8, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[AL_0]], i8 2)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i8, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V11]])
# CHECK-NEXT: [[V19:%.+]] = trunc i8 [[V18]] to i1
# CHECK-NEXT: [[V20:%.+]] = icmp eq i1 [[V19]], false
# CHECK-NEXT: [[V21:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V22:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V23:%.+]] = shl i32 [[V22]], 0
# CHECK-NEXT: [[V24:%.+]] = or i32 [[V23]], [[V21]]
# CHECK-NEXT: [[V25:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V26:%.+]] = shl i32 [[V25]], 2
# CHECK-NEXT: [[V27:%.+]] = or i32 [[V26]], [[V24]]
# CHECK-NEXT: [[V28:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 4
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 6
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 7
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 11
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V39]], metadata !"EFLAGS")
cmpb	$2, %al

## CMP8mi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i8*
# CHECK-NEXT: [[V5:%.+]] = load i8, i8* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i8 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp uge i8 [[V5]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp ult i8 [[V5]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp ule i8 [[V5]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp slt i8 [[V5]], 2
# CHECK-NEXT: [[V11:%.+]] = icmp sle i8 [[V5]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i8 [[V5]], 2
# CHECK-NEXT: [[V13:%.+]] = icmp sge i8 [[V5]], 2
# CHECK-NEXT: [[V14:%.+]] = icmp eq i8 [[V5]], 2
# CHECK-NEXT: [[V15:%.+]] = icmp ne i8 [[V5]], 2
# CHECK-NEXT: [[V16:%.+]] = sub i8 [[V5]], 2
# CHECK-NEXT: [[V17:%.+]] = icmp eq i8 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i8 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[V5]], i8 2)
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i8, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[V5]], i8 2)
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i8, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V16]])
# CHECK-NEXT: [[V24:%.+]] = trunc i8 [[V23]] to i1
# CHECK-NEXT: [[V25:%.+]] = icmp eq i1 [[V24]], false
# CHECK-NEXT: [[V26:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 0
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 [[V25]] to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 2
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 4
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 6
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 7
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: [[V42:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V43:%.+]] = shl i32 [[V42]], 11
# CHECK-NEXT: [[V44:%.+]] = or i32 [[V43]], [[V41]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V44]], metadata !"EFLAGS")
cmpb	$2, 2(%r11,%rbx,2)

## CMP8mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R11_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i8*
# CHECK-NEXT: [[V5:%.+]] = load i8, i8* [[V4]], align 1
# CHECK-NEXT: [[R11B_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"R11B")
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V7:%.+]] = icmp uge i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V8:%.+]] = icmp ult i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V9:%.+]] = icmp ule i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V10:%.+]] = icmp slt i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V11:%.+]] = icmp sle i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V13:%.+]] = icmp sge i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V14:%.+]] = icmp eq i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V15:%.+]] = icmp ne i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V16:%.+]] = sub i8 [[V5]], [[R11B_0]]
# CHECK-NEXT: [[V17:%.+]] = icmp eq i8 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i8 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[V5]], i8 [[R11B_0]])
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i8, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[V5]], i8 [[R11B_0]])
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i8, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V16]])
# CHECK-NEXT: [[V24:%.+]] = trunc i8 [[V23]] to i1
# CHECK-NEXT: [[V25:%.+]] = icmp eq i1 [[V24]], false
# CHECK-NEXT: [[V26:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 0
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 [[V25]] to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 2
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 4
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 6
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 7
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: [[V42:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V43:%.+]] = shl i32 [[V42]], 11
# CHECK-NEXT: [[V44:%.+]] = or i32 [[V43]], [[V41]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V44]], metadata !"EFLAGS")
cmpb	%r11b, 2(%r11,%rbx,2)

## CMP8ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i8 [[BPL_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp uge i8 [[BPL_0]], 2
# CHECK-NEXT: [[V3:%.+]] = icmp ult i8 [[BPL_0]], 2
# CHECK-NEXT: [[V4:%.+]] = icmp ule i8 [[BPL_0]], 2
# CHECK-NEXT: [[V5:%.+]] = icmp slt i8 [[BPL_0]], 2
# CHECK-NEXT: [[V6:%.+]] = icmp sle i8 [[BPL_0]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i8 [[BPL_0]], 2
# CHECK-NEXT: [[V8:%.+]] = icmp sge i8 [[BPL_0]], 2
# CHECK-NEXT: [[V9:%.+]] = icmp eq i8 [[BPL_0]], 2
# CHECK-NEXT: [[V10:%.+]] = icmp ne i8 [[BPL_0]], 2
# CHECK-NEXT: [[V11:%.+]] = sub i8 [[BPL_0]], 2
# CHECK-NEXT: [[V12:%.+]] = icmp eq i8 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i8 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[BPL_0]], i8 2)
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i8, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BPL_0]], i8 2)
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i8, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V11]])
# CHECK-NEXT: [[V19:%.+]] = trunc i8 [[V18]] to i1
# CHECK-NEXT: [[V20:%.+]] = icmp eq i1 [[V19]], false
# CHECK-NEXT: [[V21:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V22:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V23:%.+]] = shl i32 [[V22]], 0
# CHECK-NEXT: [[V24:%.+]] = or i32 [[V23]], [[V21]]
# CHECK-NEXT: [[V25:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V26:%.+]] = shl i32 [[V25]], 2
# CHECK-NEXT: [[V27:%.+]] = or i32 [[V26]], [[V24]]
# CHECK-NEXT: [[V28:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 4
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 6
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 7
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 11
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V39]], metadata !"EFLAGS")
cmpb	$2, %bpl

## CMP8rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i8*
# CHECK-NEXT: [[V5:%.+]] = load i8, i8* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp ugt i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = icmp uge i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V8:%.+]] = icmp ult i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V9:%.+]] = icmp ule i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V10:%.+]] = icmp slt i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V11:%.+]] = icmp sle i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V12:%.+]] = icmp sgt i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V13:%.+]] = icmp sge i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V14:%.+]] = icmp eq i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V15:%.+]] = icmp ne i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V16:%.+]] = sub i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V17:%.+]] = icmp eq i8 [[V16]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp slt i8 [[V16]], 0
# CHECK-NEXT: [[V19:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[BPL_0]], i8 [[V5]])
# CHECK-NEXT: [[V20:%.+]] = extractvalue { i8, i1 } [[V19]], 1
# CHECK-NEXT: [[V21:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BPL_0]], i8 [[V5]])
# CHECK-NEXT: [[V22:%.+]] = extractvalue { i8, i1 } [[V21]], 1
# CHECK-NEXT: [[V23:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V16]])
# CHECK-NEXT: [[V24:%.+]] = trunc i8 [[V23]] to i1
# CHECK-NEXT: [[V25:%.+]] = icmp eq i1 [[V24]], false
# CHECK-NEXT: [[V26:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 0
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 [[V25]] to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 2
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 4
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 6
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 7
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: [[V42:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V43:%.+]] = shl i32 [[V42]], 11
# CHECK-NEXT: [[V44:%.+]] = or i32 [[V43]], [[V41]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V44]], metadata !"EFLAGS")
cmpb	2(%rbx,%r14,2), %bpl

## CMP8rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[SPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"SPL")
# CHECK-NEXT: [[V1:%.+]] = icmp ugt i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V2:%.+]] = icmp uge i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V3:%.+]] = icmp ult i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V4:%.+]] = icmp ule i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V5:%.+]] = icmp slt i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V6:%.+]] = icmp sle i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V7:%.+]] = icmp sgt i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V8:%.+]] = icmp sge i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V9:%.+]] = icmp eq i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V10:%.+]] = icmp ne i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V11:%.+]] = sub i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V12:%.+]] = icmp eq i8 [[V11]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp slt i8 [[V11]], 0
# CHECK-NEXT: [[V14:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[BPL_0]], i8 [[SPL_0]])
# CHECK-NEXT: [[V15:%.+]] = extractvalue { i8, i1 } [[V14]], 1
# CHECK-NEXT: [[V16:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BPL_0]], i8 [[SPL_0]])
# CHECK-NEXT: [[V17:%.+]] = extractvalue { i8, i1 } [[V16]], 1
# CHECK-NEXT: [[V18:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V11]])
# CHECK-NEXT: [[V19:%.+]] = trunc i8 [[V18]] to i1
# CHECK-NEXT: [[V20:%.+]] = icmp eq i1 [[V19]], false
# CHECK-NEXT: [[V21:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V22:%.+]] = zext i1 [[V17]] to i32
# CHECK-NEXT: [[V23:%.+]] = shl i32 [[V22]], 0
# CHECK-NEXT: [[V24:%.+]] = or i32 [[V23]], [[V21]]
# CHECK-NEXT: [[V25:%.+]] = zext i1 [[V20]] to i32
# CHECK-NEXT: [[V26:%.+]] = shl i32 [[V25]], 2
# CHECK-NEXT: [[V27:%.+]] = or i32 [[V26]], [[V24]]
# CHECK-NEXT: [[V28:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 4
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V12]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 6
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 7
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V15]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 11
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V39]], metadata !"EFLAGS")
cmpb	%spl, %bpl

## CMP8rr_REV:	cmpb	%spl, %bpl
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x40; .byte 0x3a; .byte 0xec

## CMPPDrmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
cmplepd	2(%r14,%r15,2), %xmm8

## CMPPDrmi_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
cmppd	$2, 2(%r14,%r15,2), %xmm8

## CMPPDrri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
cmplepd	%xmm10, %xmm8

## CMPPDrri_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
cmppd	$2, %xmm10, %xmm8

## CMPPSrmi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
cmpleps	2(%r14,%r15,2), %xmm8

## CMPPSrmi_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
cmpps	$2, 2(%r14,%r15,2), %xmm8

## CMPPSrri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
cmpleps	%xmm10, %xmm8

## CMPPSrri_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
cmpps	$2, %xmm10, %xmm8

## CMPSDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
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
# CHECK-NEXT: [[V9:%.+]] = fcmp ole double [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = sext i1 [[V9]] to i64
# CHECK-NEXT: [[V11:%.+]] = bitcast i64 [[V10]] to double
# CHECK-NEXT: [[V12:%.+]] = bitcast double [[V11]] to i64
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V13:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V14:%.+]] = zext i64 [[V12]] to i128
# CHECK-NEXT: [[V15:%.+]] = and i128 [[V13]], -18446744073709551616
# CHECK-NEXT: [[V16:%.+]] = or i128 [[V14]], [[V15]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V16]], metadata !"XMM8")
cmplesd	2(%r14,%r15,2), %xmm8

## CMPSDrm_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
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
# CHECK-NEXT: [[V9:%.+]] = fcmp ole double [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = sext i1 [[V9]] to i64
# CHECK-NEXT: [[V11:%.+]] = bitcast i64 [[V10]] to double
# CHECK-NEXT: [[V12:%.+]] = bitcast double [[V11]] to i64
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V13:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V14:%.+]] = zext i64 [[V12]] to i128
# CHECK-NEXT: [[V15:%.+]] = and i128 [[V13]], -18446744073709551616
# CHECK-NEXT: [[V16:%.+]] = or i128 [[V14]], [[V15]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V16]], metadata !"XMM8")
cmpsd	$2, 2(%r14,%r15,2), %xmm8

## CMPSDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i64
# CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to double
# CHECK-NEXT: [[V7:%.+]] = fcmp ole double [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = sext i1 [[V7]] to i64
# CHECK-NEXT: [[V9:%.+]] = bitcast i64 [[V8]] to double
# CHECK-NEXT: [[V10:%.+]] = bitcast double [[V9]] to i64
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V12:%.+]] = zext i64 [[V10]] to i128
# CHECK-NEXT: [[V13:%.+]] = and i128 [[V11]], -18446744073709551616
# CHECK-NEXT: [[V14:%.+]] = or i128 [[V12]], [[V13]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V14]], metadata !"XMM8")
cmplesd	%xmm10, %xmm8

## CMPSDrr_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i64
# CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to double
# CHECK-NEXT: [[V7:%.+]] = fcmp ole double [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = sext i1 [[V7]] to i64
# CHECK-NEXT: [[V9:%.+]] = bitcast i64 [[V8]] to double
# CHECK-NEXT: [[V10:%.+]] = bitcast double [[V9]] to i64
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V12:%.+]] = zext i64 [[V10]] to i128
# CHECK-NEXT: [[V13:%.+]] = and i128 [[V11]], -18446744073709551616
# CHECK-NEXT: [[V14:%.+]] = or i128 [[V12]], [[V13]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V14]], metadata !"XMM8")
cmpsd	$2, %xmm10, %xmm8

## CMPSSrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = bitcast i32 [[V2]] to float
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R14_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to float*
# CHECK-NEXT: [[V8:%.+]] = load float, float* [[V7]], align 1
# CHECK-NEXT: [[V9:%.+]] = fcmp ole float [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = sext i1 [[V9]] to i32
# CHECK-NEXT: [[V11:%.+]] = bitcast i32 [[V10]] to float
# CHECK-NEXT: [[V12:%.+]] = bitcast float [[V11]] to i32
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V13:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V14:%.+]] = zext i32 [[V12]] to i128
# CHECK-NEXT: [[V15:%.+]] = and i128 [[V13]], -4294967296
# CHECK-NEXT: [[V16:%.+]] = or i128 [[V14]], [[V15]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V16]], metadata !"XMM8")
cmpless	2(%r14,%r15,2), %xmm8

## CMPSSrm_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = bitcast i32 [[V2]] to float
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R14_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to float*
# CHECK-NEXT: [[V8:%.+]] = load float, float* [[V7]], align 1
# CHECK-NEXT: [[V9:%.+]] = fcmp ole float [[V3]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = sext i1 [[V9]] to i32
# CHECK-NEXT: [[V11:%.+]] = bitcast i32 [[V10]] to float
# CHECK-NEXT: [[V12:%.+]] = bitcast float [[V11]] to i32
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V13:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V14:%.+]] = zext i32 [[V12]] to i128
# CHECK-NEXT: [[V15:%.+]] = and i128 [[V13]], -4294967296
# CHECK-NEXT: [[V16:%.+]] = or i128 [[V14]], [[V15]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V16]], metadata !"XMM8")
cmpss	$2, 2(%r14,%r15,2), %xmm8

## CMPSSrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = bitcast i32 [[V2]] to float
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i32
# CHECK-NEXT: [[V6:%.+]] = bitcast i32 [[V5]] to float
# CHECK-NEXT: [[V7:%.+]] = fcmp ole float [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = sext i1 [[V7]] to i32
# CHECK-NEXT: [[V9:%.+]] = bitcast i32 [[V8]] to float
# CHECK-NEXT: [[V10:%.+]] = bitcast float [[V9]] to i32
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V12:%.+]] = zext i32 [[V10]] to i128
# CHECK-NEXT: [[V13:%.+]] = and i128 [[V11]], -4294967296
# CHECK-NEXT: [[V14:%.+]] = or i128 [[V12]], [[V13]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V14]], metadata !"XMM8")
cmpless	%xmm10, %xmm8

## CMPSSrr_alt
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = bitcast i32 [[V2]] to float
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i32
# CHECK-NEXT: [[V6:%.+]] = bitcast i32 [[V5]] to float
# CHECK-NEXT: [[V7:%.+]] = fcmp ole float [[V3]], [[V6]]
# CHECK-NEXT: [[V8:%.+]] = sext i1 [[V7]] to i32
# CHECK-NEXT: [[V9:%.+]] = bitcast i32 [[V8]] to float
# CHECK-NEXT: [[V10:%.+]] = bitcast float [[V9]] to i32
# CHECK-NEXT: [[XMM8_1:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V11:%.+]] = bitcast <4 x float> [[XMM8_1]] to i128
# CHECK-NEXT: [[V12:%.+]] = zext i32 [[V10]] to i128
# CHECK-NEXT: [[V13:%.+]] = and i128 [[V11]], -4294967296
# CHECK-NEXT: [[V14:%.+]] = or i128 [[V12]], [[V13]]
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V14]], metadata !"XMM8")
cmpss	$2, %xmm10, %xmm8

retq
