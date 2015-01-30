#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

am_base_offset:
add rdi, [rsi + 12]
ret

# CHECK-LABEL: bb_0:
# CHECK: [[AM:%[0-9]+]] = add i64 {{%RSI_[0-9]+}}, 12
# CHECK: [[PTR:%[0-9]+]] = inttoptr i64 [[AM]] to i64*
# CHECK: [[LOAD:%[0-9]+]] = load i64* [[PTR]]
# CHECK: add i64 {{%RDI_[0-9]+}}, [[LOAD]]
# CHECK: br label %exit_fn_0
