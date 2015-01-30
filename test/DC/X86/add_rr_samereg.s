#RUN: llvm-mc -x86-asm-syntax=intel < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

# CHECK-LABEL: bb_0:
# CHECK: [[RDI0:%RDI_[0-9]+]] = load i64* %RDI
# CHECK: [[RDI1:%RDI_[0-9]+]] = add i64 [[RDI0]], [[RDI0]]
# CHECK: store i64 [[RDI1]], i64* %RDI
# CHECK: br label %exit_fn_0
add_rr_samereg:
add rdi, rdi
ret
