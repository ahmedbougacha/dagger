#RUN: llvm-mc -x86-asm-syntax=intel < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

# CHECK-LABEL: bb_0:
# CHECK-DAG: [[RDI0:%RDI_[0-9]+]] = load i64* %RDI
# CHECK-DAG: [[PTR:%[0-9]+]] = inttoptr i64 12345 to i64*
# CHECK-DAG: [[LOAD:%[0-9]+]] = load i64* [[PTR]]
# CHECK:     [[RDI1:%RDI_[0-9]+]] = add i64 [[RDI0]], [[LOAD]]
# CHECK:     store i64 [[RDI1]], i64* %RDI
# CHECK: br label %exit_fn_0
add_rm:
add rdi, [12345]
ret
