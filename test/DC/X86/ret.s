#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
ret

# CHECK-LABEL:  define void @fn_0
# CHECK-LABEL:  exit_fn_0:
# CHECK-DAG:    [[RIP:%[0-9]+]] = load i64* %RIP
# CHECK-DAG:    [[RSP:%[0-9]+]] = load i64* %RSP
# CHECK-DAG:    store i64 [[RIP]], i64* %RIP
# CHECK-DAG:    store i64 [[RSP]], i64* %RSP
# CHECK-LABEL:  bb_0:
# CHECK-DAG:    [[RSP0:%RSP_[0-9]+]] = load i64* %RSP
# CHECK-DAG:    [[RSP1:%RSP_[0-9]+]] = add i64 [[RSP0]], 8
# CHECK-DAG:    [[SPTR:%[0-9]+]] = inttoptr i64 [[RSP0]] to i64*
# CHECK-DAG:    [[RIP1:%RIP_[0-9]+]] = load i64* [[SPTR]]
# CHECK-DAG:    store i64 [[RIP1]], i64* %RIP
# CHECK-DAG:    store i64 [[RSP1]], i64* %RSP
# CHECK: br label %exit_fn_0
