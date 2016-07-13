# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## ANDN32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R9D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R9D")
# CHECK-NEXT: [[V1:%.+]] = xor i32 [[R9D_0]], -1
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V2:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[V2]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[R14_0]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to i32*
# CHECK-NEXT: [[V6:%.+]] = load i32, i32* [[V5]], align 1
# CHECK-NEXT: [[V7:%.+]] = and i32 [[V1]], [[V6]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V7]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
andnl	2(%r14,%r15,2), %r9d, %r8d

## ANDN32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R9D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R9D")
# CHECK-NEXT: [[V1:%.+]] = xor i32 [[R9D_0]], -1
# CHECK-NEXT: [[R10D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R10D")
# CHECK-NEXT: [[V2:%.+]] = and i32 [[V1]], [[R10D_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V2]], metadata !"R8D")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
andnl	%r10d, %r9d, %r8d

## ANDN64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = xor i64 [[RBX_0]], -1
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V2:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[V2]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[R14_0]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to i64*
# CHECK-NEXT: [[V6:%.+]] = load i64, i64* [[V5]], align 1
# CHECK-NEXT: [[V7:%.+]] = and i64 [[V1]], [[V6]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V7]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
andnq	2(%r14,%r15,2), %rbx, %r11

## ANDN64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = xor i64 [[RBX_0]], -1
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V2:%.+]] = and i64 [[V1]], [[R14_0]]
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V2]], metadata !"R11")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
andnq	%r14, %rbx, %r11

retq
