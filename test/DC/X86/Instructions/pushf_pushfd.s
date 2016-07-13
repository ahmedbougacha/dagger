# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## PUSHF16
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pushfw

## PUSHF64
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 1
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[EFLAGS_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"EFLAGS")
# CHECK-NEXT: [[RSP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V1:%.+]] = sub i64 [[RSP_0]], 4
# CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i32*
# CHECK-NEXT: store i32 [[EFLAGS_0]], i32* [[V2]], align 1
# CHECK-NEXT: [[RSP_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RSP")
# CHECK-NEXT: [[V3:%.+]] = sub i64 [[RSP_1]], 4
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"RSP")
pushfq

retq
