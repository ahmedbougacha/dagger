# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## BSR16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp eq i16 [[V5]], 0
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V7:%.+]] = call i16 @llvm.ctlz.i16.i1(i16 [[V5]], i1 true)
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V6]], i16 [[R8W_0]], i16 [[V7]]
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V9:%.+]] = zext i1 [[V6]] to i32
# CHECK-NEXT: [[V10:%.+]] = shl i32 [[V9]], 6
# CHECK-NEXT: [[V11:%.+]] = and i32 [[EFLAGS_0]], -65
# CHECK-NEXT: [[V12:%.+]] = or i32 [[V10]], [[V11]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V8]], metadata !"R8W")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V12]], metadata !"EFLAGS")
bsrw	2(%rbx,%r14,2), %r8w

## BSR16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R9W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R9W")
# CHECK-NEXT: [[V1:%.+]] = icmp eq i16 [[R9W_0]], 0
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[V2:%.+]] = call i16 @llvm.ctlz.i16.i1(i16 [[R9W_0]], i1 true)
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V1]], i16 [[R8W_0]], i16 [[V2]]
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V1]] to i32
# CHECK-NEXT: [[V5:%.+]] = shl i32 [[V4]], 6
# CHECK-NEXT: [[V6:%.+]] = and i32 [[EFLAGS_0]], -65
# CHECK-NEXT: [[V7:%.+]] = or i32 [[V5]], [[V6]]
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V3]], metadata !"R8W")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V7]], metadata !"EFLAGS")
bsrw	%r9w, %r8w

## BSR32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp eq i32 [[V5]], 0
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V7:%.+]] = call i32 @llvm.ctlz.i32.i1(i32 [[V5]], i1 true)
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V6]], i32 [[R8D_0]], i32 [[V7]]
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V9:%.+]] = zext i1 [[V6]] to i32
# CHECK-NEXT: [[V10:%.+]] = shl i32 [[V9]], 6
# CHECK-NEXT: [[V11:%.+]] = and i32 [[EFLAGS_0]], -65
# CHECK-NEXT: [[V12:%.+]] = or i32 [[V10]], [[V11]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V8]], metadata !"R8D")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V12]], metadata !"EFLAGS")
bsrl	2(%rbx,%r14,2), %r8d

## BSR32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R9D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R9D")
# CHECK-NEXT: [[V1:%.+]] = icmp eq i32 [[R9D_0]], 0
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[V2:%.+]] = call i32 @llvm.ctlz.i32.i1(i32 [[R9D_0]], i1 true)
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V1]], i32 [[R8D_0]], i32 [[V2]]
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V1]] to i32
# CHECK-NEXT: [[V5:%.+]] = shl i32 [[V4]], 6
# CHECK-NEXT: [[V6:%.+]] = and i32 [[EFLAGS_0]], -65
# CHECK-NEXT: [[V7:%.+]] = or i32 [[V5]], [[V6]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"R8D")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V7]], metadata !"EFLAGS")
bsrl	%r9d, %r8d

## BSR64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = icmp eq i64 [[V5]], 0
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V7:%.+]] = call i64 @llvm.ctlz.i64.i1(i64 [[V5]], i1 true)
# CHECK-NEXT: [[V8:%.+]] = select i1 [[V6]], i64 [[R11_0]], i64 [[V7]]
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V9:%.+]] = zext i1 [[V6]] to i32
# CHECK-NEXT: [[V10:%.+]] = shl i32 [[V9]], 6
# CHECK-NEXT: [[V11:%.+]] = and i32 [[EFLAGS_0]], -65
# CHECK-NEXT: [[V12:%.+]] = or i32 [[V10]], [[V11]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V8]], metadata !"R11")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V12]], metadata !"EFLAGS")
bsrq	2(%rbx,%r14,2), %r11

## BSR64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = icmp eq i64 [[RBX_0]], 0
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[V2:%.+]] = call i64 @llvm.ctlz.i64.i1(i64 [[RBX_0]], i1 true)
# CHECK-NEXT: [[V3:%.+]] = select i1 [[V1]], i64 [[R11_0]], i64 [[V2]]
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[V4:%.+]] = zext i1 [[V1]] to i32
# CHECK-NEXT: [[V5:%.+]] = shl i32 [[V4]], 6
# CHECK-NEXT: [[V6:%.+]] = and i32 [[EFLAGS_0]], -65
# CHECK-NEXT: [[V7:%.+]] = or i32 [[V5]], [[V6]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"R11")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V7]], metadata !"EFLAGS")
bsrq	%rbx, %r11

retq
