#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
mov rax, rax
ret

# CHECK-LABEL:  @fn_0
# CHECK-LABEL:  entry_fn_0:
# CHECK:          %RAX_ptr = getelementptr inbounds %regset* %0
# CHECK:          %RAX_init = load i64* %RAX_ptr
# CHECK:          %RAX = alloca i64
# CHECK:          store i64 %RAX_init, i64* %RAX
# CHECK-LABEL:  exit_fn_0:
# CHECK:          [[LASTRAX:%[0-9]+]] = load i64* %RAX
# CHECK:          store i64 [[LASTRAX:%[0-9]+]], i64* %RAX_ptr
# CHECK-LABEL:  bb_0:
# CHECK:          %RAX_0 = load i64* %RAX
# CHECK:          store i64 %RAX_0, i64* %RAX
# CHECK: br label %exit_fn_0
