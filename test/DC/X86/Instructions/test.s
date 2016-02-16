# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## TEST16i16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AX_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"AX")
# CHECK-NEXT: [[V1:%.+]] = and i16 [[AX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i16 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i16 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i16 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i16 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i16 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i16 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i16 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i16 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i16 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i16 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i16 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i16 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i16 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[V1]], i16 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i16, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[V1]], i16 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i16, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i16 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testw	$2, %ax

## TEST16mi
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
# CHECK-NEXT: [[V6:%.+]] = and i16 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp ugt i16 [[V6]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp uge i16 [[V6]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp ult i16 [[V6]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp ule i16 [[V6]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp slt i16 [[V6]], 0
# CHECK-NEXT: [[V12:%.+]] = icmp sle i16 [[V6]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp sgt i16 [[V6]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp sge i16 [[V6]], 0
# CHECK-NEXT: [[V15:%.+]] = icmp eq i16 [[V6]], 0
# CHECK-NEXT: [[V16:%.+]] = icmp ne i16 [[V6]], 0
# CHECK-NEXT: [[V17:%.+]] = sub i16 [[V6]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp eq i16 [[V17]], 0
# CHECK-NEXT: [[V19:%.+]] = icmp slt i16 [[V17]], 0
# CHECK-NEXT: [[V20:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[V6]], i16 0)
# CHECK-NEXT: [[V21:%.+]] = extractvalue { i16, i1 } [[V20]], 1
# CHECK-NEXT: [[V22:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[V6]], i16 0)
# CHECK-NEXT: [[V23:%.+]] = extractvalue { i16, i1 } [[V22]], 1
# CHECK-NEXT: [[V24:%.+]] = trunc i16 [[V17]] to i8
# CHECK-NEXT: [[V25:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V24]])
# CHECK-NEXT: [[V26:%.+]] = trunc i8 [[V25]] to i1
# CHECK-NEXT: [[V27:%.+]] = icmp eq i1 [[V26]], false
# CHECK-NEXT: [[V28:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V29:%.+]] = zext i1 [[V23]] to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 0
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V27]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 2
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 4
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 6
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: [[V41:%.+]] = zext i1 [[V19]] to i32
# CHECK-NEXT: [[V42:%.+]] = shl i32 [[V41]], 7
# CHECK-NEXT: [[V43:%.+]] = or i32 [[V42]], [[V40]]
# CHECK-NEXT: [[V44:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V45:%.+]] = shl i32 [[V44]], 11
# CHECK-NEXT: [[V46:%.+]] = or i32 [[V45]], [[V43]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V46]], metadata !"EFLAGS")
testw	$2, 2(%r11,%rbx,2)

## TEST16ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V1:%.+]] = and i16 [[R8W_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i16 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i16 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i16 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i16 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i16 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i16 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i16 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i16 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i16 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i16 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i16 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i16 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i16 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[V1]], i16 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i16, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[V1]], i16 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i16, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i16 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testw	$2, %r8w

## TEST16rm
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
# CHECK-NEXT: [[V6:%.+]] = and i16 [[R8W_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = icmp ugt i16 [[V6]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp uge i16 [[V6]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp ult i16 [[V6]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp ule i16 [[V6]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp slt i16 [[V6]], 0
# CHECK-NEXT: [[V12:%.+]] = icmp sle i16 [[V6]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp sgt i16 [[V6]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp sge i16 [[V6]], 0
# CHECK-NEXT: [[V15:%.+]] = icmp eq i16 [[V6]], 0
# CHECK-NEXT: [[V16:%.+]] = icmp ne i16 [[V6]], 0
# CHECK-NEXT: [[V17:%.+]] = sub i16 [[V6]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp eq i16 [[V17]], 0
# CHECK-NEXT: [[V19:%.+]] = icmp slt i16 [[V17]], 0
# CHECK-NEXT: [[V20:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[V6]], i16 0)
# CHECK-NEXT: [[V21:%.+]] = extractvalue { i16, i1 } [[V20]], 1
# CHECK-NEXT: [[V22:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[V6]], i16 0)
# CHECK-NEXT: [[V23:%.+]] = extractvalue { i16, i1 } [[V22]], 1
# CHECK-NEXT: [[V24:%.+]] = trunc i16 [[V17]] to i8
# CHECK-NEXT: [[V25:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V24]])
# CHECK-NEXT: [[V26:%.+]] = trunc i8 [[V25]] to i1
# CHECK-NEXT: [[V27:%.+]] = icmp eq i1 [[V26]], false
# CHECK-NEXT: [[V28:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V29:%.+]] = zext i1 [[V23]] to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 0
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V27]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 2
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 4
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 6
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: [[V41:%.+]] = zext i1 [[V19]] to i32
# CHECK-NEXT: [[V42:%.+]] = shl i32 [[V41]], 7
# CHECK-NEXT: [[V43:%.+]] = or i32 [[V42]], [[V40]]
# CHECK-NEXT: [[V44:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V45:%.+]] = shl i32 [[V44]], 11
# CHECK-NEXT: [[V46:%.+]] = or i32 [[V45]], [[V43]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V46]], metadata !"EFLAGS")
testw	2(%rbx,%r14,2), %r8w

## TEST16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R9W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R9W")
# CHECK-NEXT: [[V1:%.+]] = and i16 [[R8W_0]], [[R9W_0]]
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i16 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i16 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i16 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i16 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i16 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i16 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i16 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i16 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i16 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i16 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i16 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i16 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i16 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i16, i1 } @llvm.ssub.with.overflow.i16(i16 [[V1]], i16 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i16, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i16, i1 } @llvm.usub.with.overflow.i16(i16 [[V1]], i16 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i16, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i16 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testw	%r9w, %r8w

## TEST32i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EAX_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EAX")
# CHECK-NEXT: [[V1:%.+]] = and i32 [[EAX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i32 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i32 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i32 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i32 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i32 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i32 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i32 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i32 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i32 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i32 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i32 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i32 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i32 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[V1]], i32 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i32, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[V1]], i32 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i32, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i32 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testl	$2, %eax

## TEST32mi
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
# CHECK-NEXT: [[V6:%.+]] = and i32 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp ugt i32 [[V6]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp uge i32 [[V6]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp ult i32 [[V6]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp ule i32 [[V6]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp slt i32 [[V6]], 0
# CHECK-NEXT: [[V12:%.+]] = icmp sle i32 [[V6]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp sgt i32 [[V6]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp sge i32 [[V6]], 0
# CHECK-NEXT: [[V15:%.+]] = icmp eq i32 [[V6]], 0
# CHECK-NEXT: [[V16:%.+]] = icmp ne i32 [[V6]], 0
# CHECK-NEXT: [[V17:%.+]] = sub i32 [[V6]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp eq i32 [[V17]], 0
# CHECK-NEXT: [[V19:%.+]] = icmp slt i32 [[V17]], 0
# CHECK-NEXT: [[V20:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[V6]], i32 0)
# CHECK-NEXT: [[V21:%.+]] = extractvalue { i32, i1 } [[V20]], 1
# CHECK-NEXT: [[V22:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[V6]], i32 0)
# CHECK-NEXT: [[V23:%.+]] = extractvalue { i32, i1 } [[V22]], 1
# CHECK-NEXT: [[V24:%.+]] = trunc i32 [[V17]] to i8
# CHECK-NEXT: [[V25:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V24]])
# CHECK-NEXT: [[V26:%.+]] = trunc i8 [[V25]] to i1
# CHECK-NEXT: [[V27:%.+]] = icmp eq i1 [[V26]], false
# CHECK-NEXT: [[V28:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V29:%.+]] = zext i1 [[V23]] to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 0
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V27]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 2
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 4
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 6
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: [[V41:%.+]] = zext i1 [[V19]] to i32
# CHECK-NEXT: [[V42:%.+]] = shl i32 [[V41]], 7
# CHECK-NEXT: [[V43:%.+]] = or i32 [[V42]], [[V40]]
# CHECK-NEXT: [[V44:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V45:%.+]] = shl i32 [[V44]], 11
# CHECK-NEXT: [[V46:%.+]] = or i32 [[V45]], [[V43]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V46]], metadata !"EFLAGS")
testl	$2, 2(%r11,%rbx,2)

## TEST32ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V1:%.+]] = and i32 [[R8D_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i32 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i32 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i32 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i32 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i32 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i32 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i32 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i32 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i32 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i32 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i32 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i32 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i32 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[V1]], i32 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i32, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[V1]], i32 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i32, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i32 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testl	$2, %r8d

## TEST32rm
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
# CHECK-NEXT: [[V6:%.+]] = and i32 [[R8D_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = icmp ugt i32 [[V6]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp uge i32 [[V6]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp ult i32 [[V6]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp ule i32 [[V6]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp slt i32 [[V6]], 0
# CHECK-NEXT: [[V12:%.+]] = icmp sle i32 [[V6]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp sgt i32 [[V6]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp sge i32 [[V6]], 0
# CHECK-NEXT: [[V15:%.+]] = icmp eq i32 [[V6]], 0
# CHECK-NEXT: [[V16:%.+]] = icmp ne i32 [[V6]], 0
# CHECK-NEXT: [[V17:%.+]] = sub i32 [[V6]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp eq i32 [[V17]], 0
# CHECK-NEXT: [[V19:%.+]] = icmp slt i32 [[V17]], 0
# CHECK-NEXT: [[V20:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[V6]], i32 0)
# CHECK-NEXT: [[V21:%.+]] = extractvalue { i32, i1 } [[V20]], 1
# CHECK-NEXT: [[V22:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[V6]], i32 0)
# CHECK-NEXT: [[V23:%.+]] = extractvalue { i32, i1 } [[V22]], 1
# CHECK-NEXT: [[V24:%.+]] = trunc i32 [[V17]] to i8
# CHECK-NEXT: [[V25:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V24]])
# CHECK-NEXT: [[V26:%.+]] = trunc i8 [[V25]] to i1
# CHECK-NEXT: [[V27:%.+]] = icmp eq i1 [[V26]], false
# CHECK-NEXT: [[V28:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V29:%.+]] = zext i1 [[V23]] to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 0
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V27]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 2
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 4
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 6
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: [[V41:%.+]] = zext i1 [[V19]] to i32
# CHECK-NEXT: [[V42:%.+]] = shl i32 [[V41]], 7
# CHECK-NEXT: [[V43:%.+]] = or i32 [[V42]], [[V40]]
# CHECK-NEXT: [[V44:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V45:%.+]] = shl i32 [[V44]], 11
# CHECK-NEXT: [[V46:%.+]] = or i32 [[V45]], [[V43]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V46]], metadata !"EFLAGS")
testl	2(%rbx,%r14,2), %r8d

## TEST32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R9D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R9D")
# CHECK-NEXT: [[V1:%.+]] = and i32 [[R8D_0]], [[R9D_0]]
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i32 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i32 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i32 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i32 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i32 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i32 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i32 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i32 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i32 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i32 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i32 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i32 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i32 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 [[V1]], i32 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i32, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i32, i1 } @llvm.usub.with.overflow.i32(i32 [[V1]], i32 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i32, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i32 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testl	%r9d, %r8d

## TEST64i32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RAX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RAX")
# CHECK-NEXT: [[V1:%.+]] = and i64 [[RAX_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i64 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i64 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i64 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i64 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i64 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i64 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i64 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i64 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i64 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i64 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i64 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i64 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i64 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[V1]], i64 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i64, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[V1]], i64 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i64, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i64 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testq	$2, %rax

## TEST64mi32
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
# CHECK-NEXT: [[V6:%.+]] = and i64 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp ugt i64 [[V6]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp uge i64 [[V6]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp ult i64 [[V6]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp ule i64 [[V6]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp slt i64 [[V6]], 0
# CHECK-NEXT: [[V12:%.+]] = icmp sle i64 [[V6]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp sgt i64 [[V6]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp sge i64 [[V6]], 0
# CHECK-NEXT: [[V15:%.+]] = icmp eq i64 [[V6]], 0
# CHECK-NEXT: [[V16:%.+]] = icmp ne i64 [[V6]], 0
# CHECK-NEXT: [[V17:%.+]] = sub i64 [[V6]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp eq i64 [[V17]], 0
# CHECK-NEXT: [[V19:%.+]] = icmp slt i64 [[V17]], 0
# CHECK-NEXT: [[V20:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[V6]], i64 0)
# CHECK-NEXT: [[V21:%.+]] = extractvalue { i64, i1 } [[V20]], 1
# CHECK-NEXT: [[V22:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[V6]], i64 0)
# CHECK-NEXT: [[V23:%.+]] = extractvalue { i64, i1 } [[V22]], 1
# CHECK-NEXT: [[V24:%.+]] = trunc i64 [[V17]] to i8
# CHECK-NEXT: [[V25:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V24]])
# CHECK-NEXT: [[V26:%.+]] = trunc i8 [[V25]] to i1
# CHECK-NEXT: [[V27:%.+]] = icmp eq i1 [[V26]], false
# CHECK-NEXT: [[V28:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V29:%.+]] = zext i1 [[V23]] to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 0
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V27]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 2
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 4
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 6
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: [[V41:%.+]] = zext i1 [[V19]] to i32
# CHECK-NEXT: [[V42:%.+]] = shl i32 [[V41]], 7
# CHECK-NEXT: [[V43:%.+]] = or i32 [[V42]], [[V40]]
# CHECK-NEXT: [[V44:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V45:%.+]] = shl i32 [[V44]], 11
# CHECK-NEXT: [[V46:%.+]] = or i32 [[V45]], [[V43]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V46]], metadata !"EFLAGS")
testq	$2, 2(%r11,%rbx,2)

## TEST64ri32
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V1:%.+]] = and i64 [[R11_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i64 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i64 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i64 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i64 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i64 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i64 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i64 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i64 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i64 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i64 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i64 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i64 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i64 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[V1]], i64 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i64, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[V1]], i64 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i64, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i64 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testq	$2, %r11

## TEST64rm
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
# CHECK-NEXT: [[V6:%.+]] = and i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = icmp ugt i64 [[V6]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp uge i64 [[V6]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp ult i64 [[V6]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp ule i64 [[V6]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp slt i64 [[V6]], 0
# CHECK-NEXT: [[V12:%.+]] = icmp sle i64 [[V6]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp sgt i64 [[V6]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp sge i64 [[V6]], 0
# CHECK-NEXT: [[V15:%.+]] = icmp eq i64 [[V6]], 0
# CHECK-NEXT: [[V16:%.+]] = icmp ne i64 [[V6]], 0
# CHECK-NEXT: [[V17:%.+]] = sub i64 [[V6]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp eq i64 [[V17]], 0
# CHECK-NEXT: [[V19:%.+]] = icmp slt i64 [[V17]], 0
# CHECK-NEXT: [[V20:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[V6]], i64 0)
# CHECK-NEXT: [[V21:%.+]] = extractvalue { i64, i1 } [[V20]], 1
# CHECK-NEXT: [[V22:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[V6]], i64 0)
# CHECK-NEXT: [[V23:%.+]] = extractvalue { i64, i1 } [[V22]], 1
# CHECK-NEXT: [[V24:%.+]] = trunc i64 [[V17]] to i8
# CHECK-NEXT: [[V25:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V24]])
# CHECK-NEXT: [[V26:%.+]] = trunc i8 [[V25]] to i1
# CHECK-NEXT: [[V27:%.+]] = icmp eq i1 [[V26]], false
# CHECK-NEXT: [[V28:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V29:%.+]] = zext i1 [[V23]] to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 0
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V27]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 2
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 4
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 6
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: [[V41:%.+]] = zext i1 [[V19]] to i32
# CHECK-NEXT: [[V42:%.+]] = shl i32 [[V41]], 7
# CHECK-NEXT: [[V43:%.+]] = or i32 [[V42]], [[V40]]
# CHECK-NEXT: [[V44:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V45:%.+]] = shl i32 [[V44]], 11
# CHECK-NEXT: [[V46:%.+]] = or i32 [[V45]], [[V43]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V46]], metadata !"EFLAGS")
testq	2(%rbx,%r14,2), %r11

## TEST64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = and i64 [[R11_0]], [[RBX_0]]
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i64 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i64 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i64 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i64 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i64 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i64 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i64 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i64 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i64 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i64 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i64 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i64 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i64 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 [[V1]], i64 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i64, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i64, i1 } @llvm.usub.with.overflow.i64(i64 [[V1]], i64 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i64, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = trunc i64 [[V12]] to i8
# CHECK-NEXT: [[V20:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V19]])
# CHECK-NEXT: [[V21:%.+]] = trunc i8 [[V20]] to i1
# CHECK-NEXT: [[V22:%.+]] = icmp eq i1 [[V21]], false
# CHECK-NEXT: [[V23:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V24:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V25:%.+]] = shl i32 [[V24]], 0
# CHECK-NEXT: [[V26:%.+]] = or i32 [[V25]], [[V23]]
# CHECK-NEXT: [[V27:%.+]] = zext i1 [[V22]] to i32
# CHECK-NEXT: [[V28:%.+]] = shl i32 [[V27]], 2
# CHECK-NEXT: [[V29:%.+]] = or i32 [[V28]], [[V26]]
# CHECK-NEXT: [[V30:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V31:%.+]] = shl i32 [[V30]], 4
# CHECK-NEXT: [[V32:%.+]] = or i32 [[V31]], [[V29]]
# CHECK-NEXT: [[V33:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V34:%.+]] = shl i32 [[V33]], 6
# CHECK-NEXT: [[V35:%.+]] = or i32 [[V34]], [[V32]]
# CHECK-NEXT: [[V36:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V37:%.+]] = shl i32 [[V36]], 7
# CHECK-NEXT: [[V38:%.+]] = or i32 [[V37]], [[V35]]
# CHECK-NEXT: [[V39:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V40:%.+]] = shl i32 [[V39]], 11
# CHECK-NEXT: [[V41:%.+]] = or i32 [[V40]], [[V38]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V41]], metadata !"EFLAGS")
testq	%rbx, %r11

## TEST8i8
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 2
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[AL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"AL")
# CHECK-NEXT: [[V1:%.+]] = and i8 [[AL_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i8 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i8 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i8 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i8 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i8 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i8 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i8 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i8 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i8 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i8 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i8 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i8 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i8 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[V1]], i8 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i8, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[V1]], i8 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i8, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V12]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
testb	$2, %al

## TEST8mi
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
# CHECK-NEXT: [[V6:%.+]] = and i8 [[V5]], 2
# CHECK-NEXT: [[V7:%.+]] = icmp ugt i8 [[V6]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp uge i8 [[V6]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp ult i8 [[V6]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp ule i8 [[V6]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp slt i8 [[V6]], 0
# CHECK-NEXT: [[V12:%.+]] = icmp sle i8 [[V6]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp sgt i8 [[V6]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp sge i8 [[V6]], 0
# CHECK-NEXT: [[V15:%.+]] = icmp eq i8 [[V6]], 0
# CHECK-NEXT: [[V16:%.+]] = icmp ne i8 [[V6]], 0
# CHECK-NEXT: [[V17:%.+]] = sub i8 [[V6]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp eq i8 [[V17]], 0
# CHECK-NEXT: [[V19:%.+]] = icmp slt i8 [[V17]], 0
# CHECK-NEXT: [[V20:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[V6]], i8 0)
# CHECK-NEXT: [[V21:%.+]] = extractvalue { i8, i1 } [[V20]], 1
# CHECK-NEXT: [[V22:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[V6]], i8 0)
# CHECK-NEXT: [[V23:%.+]] = extractvalue { i8, i1 } [[V22]], 1
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V17]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V23]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V19]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
testb	$2, 2(%r11,%rbx,2)

## TEST8ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[V1:%.+]] = and i8 [[BPL_0]], 2
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i8 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i8 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i8 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i8 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i8 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i8 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i8 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i8 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i8 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i8 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i8 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i8 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i8 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[V1]], i8 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i8, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[V1]], i8 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i8, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V12]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
testb	$2, %bpl

## TEST8rm
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
# CHECK-NEXT: [[V6:%.+]] = and i8 [[BPL_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = icmp ugt i8 [[V6]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp uge i8 [[V6]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp ult i8 [[V6]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp ule i8 [[V6]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp slt i8 [[V6]], 0
# CHECK-NEXT: [[V12:%.+]] = icmp sle i8 [[V6]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp sgt i8 [[V6]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp sge i8 [[V6]], 0
# CHECK-NEXT: [[V15:%.+]] = icmp eq i8 [[V6]], 0
# CHECK-NEXT: [[V16:%.+]] = icmp ne i8 [[V6]], 0
# CHECK-NEXT: [[V17:%.+]] = sub i8 [[V6]], 0
# CHECK-NEXT: [[V18:%.+]] = icmp eq i8 [[V17]], 0
# CHECK-NEXT: [[V19:%.+]] = icmp slt i8 [[V17]], 0
# CHECK-NEXT: [[V20:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[V6]], i8 0)
# CHECK-NEXT: [[V21:%.+]] = extractvalue { i8, i1 } [[V20]], 1
# CHECK-NEXT: [[V22:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[V6]], i8 0)
# CHECK-NEXT: [[V23:%.+]] = extractvalue { i8, i1 } [[V22]], 1
# CHECK-NEXT: [[V24:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V17]])
# CHECK-NEXT: [[V25:%.+]] = trunc i8 [[V24]] to i1
# CHECK-NEXT: [[V26:%.+]] = icmp eq i1 [[V25]], false
# CHECK-NEXT: [[V27:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V28:%.+]] = zext i1 [[V23]] to i32
# CHECK-NEXT: [[V29:%.+]] = shl i32 [[V28]], 0
# CHECK-NEXT: [[V30:%.+]] = or i32 [[V29]], [[V27]]
# CHECK-NEXT: [[V31:%.+]] = zext i1 [[V26]] to i32
# CHECK-NEXT: [[V32:%.+]] = shl i32 [[V31]], 2
# CHECK-NEXT: [[V33:%.+]] = or i32 [[V32]], [[V30]]
# CHECK-NEXT: [[V34:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V35:%.+]] = shl i32 [[V34]], 4
# CHECK-NEXT: [[V36:%.+]] = or i32 [[V35]], [[V33]]
# CHECK-NEXT: [[V37:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V38:%.+]] = shl i32 [[V37]], 6
# CHECK-NEXT: [[V39:%.+]] = or i32 [[V38]], [[V36]]
# CHECK-NEXT: [[V40:%.+]] = zext i1 [[V19]] to i32
# CHECK-NEXT: [[V41:%.+]] = shl i32 [[V40]], 7
# CHECK-NEXT: [[V42:%.+]] = or i32 [[V41]], [[V39]]
# CHECK-NEXT: [[V43:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V44:%.+]] = shl i32 [[V43]], 11
# CHECK-NEXT: [[V45:%.+]] = or i32 [[V44]], [[V42]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V45]], metadata !"EFLAGS")
testb	2(%rbx,%r14,2), %bpl

## TEST8rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 3
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[SPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"SPL")
# CHECK-NEXT: [[V1:%.+]] = and i8 [[BPL_0]], [[SPL_0]]
# CHECK-NEXT: [[V2:%.+]] = icmp ugt i8 [[V1]], 0
# CHECK-NEXT: [[V3:%.+]] = icmp uge i8 [[V1]], 0
# CHECK-NEXT: [[V4:%.+]] = icmp ult i8 [[V1]], 0
# CHECK-NEXT: [[V5:%.+]] = icmp ule i8 [[V1]], 0
# CHECK-NEXT: [[V6:%.+]] = icmp slt i8 [[V1]], 0
# CHECK-NEXT: [[V7:%.+]] = icmp sle i8 [[V1]], 0
# CHECK-NEXT: [[V8:%.+]] = icmp sgt i8 [[V1]], 0
# CHECK-NEXT: [[V9:%.+]] = icmp sge i8 [[V1]], 0
# CHECK-NEXT: [[V10:%.+]] = icmp eq i8 [[V1]], 0
# CHECK-NEXT: [[V11:%.+]] = icmp ne i8 [[V1]], 0
# CHECK-NEXT: [[V12:%.+]] = sub i8 [[V1]], 0
# CHECK-NEXT: [[V13:%.+]] = icmp eq i8 [[V12]], 0
# CHECK-NEXT: [[V14:%.+]] = icmp slt i8 [[V12]], 0
# CHECK-NEXT: [[V15:%.+]] = call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[V1]], i8 0)
# CHECK-NEXT: [[V16:%.+]] = extractvalue { i8, i1 } [[V15]], 1
# CHECK-NEXT: [[V17:%.+]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[V1]], i8 0)
# CHECK-NEXT: [[V18:%.+]] = extractvalue { i8, i1 } [[V17]], 1
# CHECK-NEXT: [[V19:%.+]] = call i8 @llvm.ctpop.i8(i8 [[V12]])
# CHECK-NEXT: [[V20:%.+]] = trunc i8 [[V19]] to i1
# CHECK-NEXT: [[V21:%.+]] = icmp eq i1 [[V20]], false
# CHECK-NEXT: [[V22:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"CtlSysEFLAGS")
# CHECK-NEXT: [[V23:%.+]] = zext i1 [[V18]] to i32
# CHECK-NEXT: [[V24:%.+]] = shl i32 [[V23]], 0
# CHECK-NEXT: [[V25:%.+]] = or i32 [[V24]], [[V22]]
# CHECK-NEXT: [[V26:%.+]] = zext i1 [[V21]] to i32
# CHECK-NEXT: [[V27:%.+]] = shl i32 [[V26]], 2
# CHECK-NEXT: [[V28:%.+]] = or i32 [[V27]], [[V25]]
# CHECK-NEXT: [[V29:%.+]] = zext i1 false to i32
# CHECK-NEXT: [[V30:%.+]] = shl i32 [[V29]], 4
# CHECK-NEXT: [[V31:%.+]] = or i32 [[V30]], [[V28]]
# CHECK-NEXT: [[V32:%.+]] = zext i1 [[V13]] to i32
# CHECK-NEXT: [[V33:%.+]] = shl i32 [[V32]], 6
# CHECK-NEXT: [[V34:%.+]] = or i32 [[V33]], [[V31]]
# CHECK-NEXT: [[V35:%.+]] = zext i1 [[V14]] to i32
# CHECK-NEXT: [[V36:%.+]] = shl i32 [[V35]], 7
# CHECK-NEXT: [[V37:%.+]] = or i32 [[V36]], [[V34]]
# CHECK-NEXT: [[V38:%.+]] = zext i1 [[V16]] to i32
# CHECK-NEXT: [[V39:%.+]] = shl i32 [[V38]], 11
# CHECK-NEXT: [[V40:%.+]] = or i32 [[V39]], [[V37]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V40]], metadata !"EFLAGS")
testb	%spl, %bpl

retq
