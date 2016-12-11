#RUN: llvm-mc -triple=aarch64--darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
 mov x0, xzr
 mov w1, wzr
 ret

# CHECK-LABEL: bb_0:
# CHECK: [[X0_0:%X0_[0-9]+]] = or i64 0, 0
# CHECK: [[W1_0:%W1_[0-9]+]] = or i32 0, 0
