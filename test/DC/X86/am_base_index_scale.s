#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

am_index_scale:
add rdi, [rcx * 8]
ret

# CHECK-LABEL: bb_0:
# CHECK: [[SCALED:%[0-9]+]] = mul i64 {{%RCX_[0-9]+}}, 8
# CHECK: [[PTR:%[0-9]+]] = inttoptr i64 [[SCALED]] to i64*
# CHECK: [[LOAD:%[0-9]+]] = load i64* [[PTR]]
# CHECK: add i64 {{%RDI_[0-9]+}}, [[LOAD]]
# CHECK: br label %exit_fn_0
