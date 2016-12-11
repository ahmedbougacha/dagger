# RUN: llvm-mc -triple=aarch64--darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
 mov w0, w1
 ret

# CHECK-LABEL: bb_0:
# CHECK: [[X1_0:%X1_[0-9]+]] = load i64, i64* %X1
# CHECK: [[W1_0:%W1_[0-9]+]] = trunc i64 [[X1_0]] to i32
# CHECK: [[W0_0:%W0_[0-9]+]] = or i32 0, [[W1_0]]
# CHECK: [[X0_0:%X0_[0-9]+]] = load i64, i64* %X0
# CHECK: [[X0_1:%X0_[0-9]+]] = zext i32 [[W0_0]] to i64
# CHECK: store i32 [[W0_0]], i32* %W0
# CHECK: store i64 [[X0_1]], i64* %X0
# CHECK: br label %exit_fn_0
