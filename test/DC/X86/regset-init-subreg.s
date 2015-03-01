#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s


f:
mov rax, rax
ret

# CHECK-LABEL:  @fn_0
# CHECK-LABEL:  entry_fn_0:
# CHECK:          %RAX_ptr = getelementptr inbounds %regset, %regset* %0
# CHECK:          %RAX_init = load i64, i64* %RAX_ptr
# CHECK-DAG:      %EAX_init = trunc i64 %RAX_init to i32
# CHECK-DAG:      %AX_init = trunc i64 %RAX_init to i16
# CHECK-DAG:      %AL_init = trunc i64 %RAX_init to i8
# CHECK-DAG:      [[AH64:%[0-9]+]] = lshr i64 %RAX_init, 8
# CHECK-DAG:      %AH_init = trunc i64 [[AH64]] to i8
# CHECK: br label %exit_fn_0
