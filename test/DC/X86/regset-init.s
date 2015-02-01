#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
mov rax, rax
ret

# CHECK-LABEL:  @fn_0
# CHECK-LABEL:  entry_fn_0:
# CHECK:          %RAX_ptr = getelementptr inbounds %regset* %0
# CHECK:          %RAX_init = load i64* %RAX_ptr
# CHECK: br label %exit_fn_0
