# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## XCHG16ar
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[AX_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"AX")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[R8W_0]], metadata !"AX")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[AX_0]], metadata !"R8W")
xchgw	%r8w, %ax

## XCHG16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R14_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
xchgw	%r8w, 2(%r14,%r15,2)

## XCHG16rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[R8W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: [[R8W_1:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R8W")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[R8W_0]], metadata !"R8W")
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[R8W_1]], metadata !"R8W")
xchgw	%r8w, %r10w

## XCHG32ar
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[EAX_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[R8D_0]], metadata !"EAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EAX_0]], metadata !"R8D")
xchgl	%r8d, %eax

## XCHG32ar64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[EAX_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[R8D_0]], metadata !"EAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[EAX_0]], metadata !"R8D")
xchgl	%r8d, %eax

## XCHG32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R14_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
xchgl	%r8d, 2(%r14,%r15,2)

## XCHG32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[R8D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: [[R8D_1:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R8D")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[R8D_0]], metadata !"R8D")
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[R8D_1]], metadata !"R8D")
xchgl	%r8d, %r10d

## XCHG64ar
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RAX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[R11_0]], metadata !"RAX")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[RAX_0]], metadata !"R11")
xchgq	%r11, %rax

## XCHG64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R14_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
xchgq	%r11, 2(%r14,%r15,2)

## XCHG64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[R11_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[R11_0]], metadata !"R11")
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[R11_1]], metadata !"R11")
xchgq	%r11, %r14

## XCHG8rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R15_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[R14_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i8*
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
xchgb	%bpl, 2(%r14,%r15,2)

## XCHG8rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[BPL_0:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: [[BPL_1:%.+]] = call i8 @llvm.dc.getreg.i8(metadata !"BPL")
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[BPL_0]], metadata !"BPL")
# CHECK-NEXT: call void @llvm.dc.setreg.i8(i8 [[BPL_1]], metadata !"BPL")
xchgb	%bpl, %r8b

retq
