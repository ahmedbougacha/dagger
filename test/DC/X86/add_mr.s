#RUN: llvm-mc -x86-asm-syntax=intel < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

# CHECK-LABEL: bb_0:
# CHECK-DAG: [[RDI0:%RDI_[0-9]+]] = load i64* %RDI
# CHECK-DAG: [[PTR:%[0-9]+]] = inttoptr i64 12345 to i64*
# CHECK-DAG: [[LOAD:%[0-9]+]] = load i64* [[PTR]]
# CHECK-DAG: [[RES:%[0-9]+]] = add i64 [[LOAD]], [[RDI0]]
# CHECK-DAG: store i64 [[RES]], i64* [[PTR]]
# CHECK: br label %exit_fn_0
add_mr:
add [12345], rdi
ret
