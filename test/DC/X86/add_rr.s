#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

# CHECK-LABEL: bb_0:
# CHECK-DAG: [[RDI0:%RDI_[0-9]+]] = load i64* %RDI
# CHECK-DAG: [[RSI0:%RSI_[0-9]+]] = load i64* %RSI
# CHECK:     [[RDI1:%RDI_[0-9]+]] = add i64 [[RDI0]], [[RSI0]]
# CHECK:     store i64 [[RDI1]], i64* %RDI
# CHECK: br label %exit_fn_0
add_rr:
add rdi, rsi
ret
