# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MOVBE16mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R15W_0:%.+]] = call i16 @llvm.dc.getreg.i16(metadata !"R15W")
# CHECK-NEXT: [[V1:%.+]] = call i16 @llvm.bswap.i16(i16 [[R15W_0]])
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V2:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[V2]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[R11_0]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to i16*
# CHECK-NEXT: store i16 [[V1]], i16* [[V5]], align 1
movbew	%r15w, 2(%r11,%rbx,2)

## MOVBE16rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 8
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i16*
# CHECK-NEXT: [[V5:%.+]] = load i16, i16* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = call i16 @llvm.bswap.i16(i16 [[V5]])
# CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V6]], metadata !"R8W")
movbew	2(%rbx,%r14,2), %r8w

## MOVBE32mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R15D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R15D")
# CHECK-NEXT: [[V1:%.+]] = call i32 @llvm.bswap.i32(i32 [[R15D_0]])
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V2:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[V2]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[R11_0]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to i32*
# CHECK-NEXT: store i32 [[V1]], i32* [[V5]], align 1
movbel	%r15d, 2(%r11,%rbx,2)

## MOVBE32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = call i32 @llvm.bswap.i32(i32 [[V5]])
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"R8D")
movbel	2(%rbx,%r14,2), %r8d

## MOVBE64mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R13_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R13")
# CHECK-NEXT: [[V1:%.+]] = call i64 @llvm.bswap.i64(i64 [[R13_0]])
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V2:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[V2]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[R11_0]], [[V3]]
# CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to i64*
# CHECK-NEXT: store i64 [[V1]], i64* [[V5]], align 1
movbeq	%r13, 2(%r11,%rbx,2)

## MOVBE64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
# CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = call i64 @llvm.bswap.i64(i64 [[V5]])
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"R11")
movbeq	2(%rbx,%r14,2), %r11

retq
