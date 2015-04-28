#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

indbr:
jmp rdi

# CHECK-LABEL: bb_0:
# CHECK: [[RDI0:%RDI_[0-9]+]] = load i64, i64* %RDI
# CHECK: [[RDIPTR:%[0-9]+]] = inttoptr i64 [[RDI0]] to i8*
## FIXME: The function should be better defined than this.
# CHECK: [[FUNPTR:%[0-9]+]] = call void (%regset*)* inttoptr (i64 57005 to void (%regset*)* (i8*)*)(i8* [[RDIPTR]])
# CHECK: store i64 [[RDI0]], i64* %RDI
# CHECK: br label %bb_0_call
# CHECK-LABEL: bb_0_call:
# CHECK-DAG: [[RDISAVE:%[0-9]+]] = load i64, i64* %RDI
# CHECK-DAG: store i64 [[RDISAVE]],  i64* %RDI
# CHECK-DAG: [[RIPSAVE:%[0-9]+]] = load i64, i64* %RIP
# CHECK-DAG: store i64 [[RIPSAVE]],  i64* %RIP
# CHECK: call void [[FUNPTR]](%regset* %0)
# CHECK: br label %bb_c0
# CHECK-LABEL: bb_c0:
# CHECK: br label %exit_fn_0
