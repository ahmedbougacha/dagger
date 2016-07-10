# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## POPF16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
popfw

## POPF64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 1
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RSP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V1:%.+]] = add i64 [[RSP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V1]], metadata !"RSP")
# CHECK-NEXT: [[RSP_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V2:%.+]] = sub i64 [[RSP_1]], 4
# CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i32*
# CHECK-NEXT: [[V4:%.+]] = load i32, i32* [[V3]], align 1
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"EFLAGS")
popfq

retq
