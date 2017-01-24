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
# CHECK-DAG: [[RDI_reload:%RDI_[0-9]+]] = load i64, i64* %RDI_ptr
# CHECK-DAG: store i64 [[RDI_reload]], i64* %RDI
## Also check that the subregister was extracted.
# CHECK-DAG: [[EDI_trunc:%EDI_[0-9]+]] = trunc i64 [[RDI_reload]] to i32
# CHECK-DAG: store i32 [[EDI_trunc]], i32* %EDI
# CHECK: br label %exit_fn_0

.global callee
