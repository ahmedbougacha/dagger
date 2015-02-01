#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec -O1 - | FileCheck %s

f:
push rax
ret

# CHECK-LABEL:  bb_0:
# CHECK-DAG:      [[SPSUB:%[0-9]+]] = sub i64 %RSP_init, 8
# CHECK-DAG:      [[SPTR:%[0-9]+]] = inttoptr i64 [[SPSUB]] to i64*
# CHECK-DAG:      store i64 %RAX_init, i64* [[SPTR]]
# CHECK-DAG:      %RSP_1 = sub i64 %RSP_init, 8
# CHECK: br label %exit_fn_0
