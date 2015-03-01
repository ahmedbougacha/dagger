#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

am_base_index_scale_offset:
add rdi, [rsi + rcx * 8 + 12]
ret

# CHECK-LABEL: bb_0:
# CHECK: [[SCALED:%[0-9]+]] = mul i64 {{%RCX_[0-9]+}}, 8
# CHECK: [[OFFSET:%[0-9]+]] = add i64 [[SCALED]], 12
# CHECK: [[AM:%[0-9]+]] = add i64 {{%RSI_[0-9]+}}, [[OFFSET]]
# CHECK: [[PTR:%[0-9]+]] = inttoptr i64 [[AM]] to i64*
# CHECK: [[LOAD:%[0-9]+]] = load i64, i64* [[PTR]]
# CHECK: add i64 {{%RDI_[0-9]+}}, [[LOAD]]
# CHECK: br label %exit_fn_0
