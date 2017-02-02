#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

.global _main
_main:
mov rdi, 42
call callee
add rax, 10
ret

# CHECK-LABEL: bb_0:
# CHECK: store i64 42, i64* %RDI
# CHECK: [[RDI_save:%[0-9]+]] = load i64, i64* %RDI
# CHECK: store i64 [[RDI_save]], i64* %RDI_ptr
# CHECK: call void @fn_C(%regset* %0)
# CHECK: [[RDI_reload:%[0-9]+]] = load i64, i64* %RDI_ptr
# CHECK: store i64 [[RDI_reload]], i64* %RDI
# CHECK: br label %exit_fn_0

.global callee
