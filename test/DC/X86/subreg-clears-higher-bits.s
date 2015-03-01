#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
 add rax, 1234
 add eax, 42
 ret

# CHECK-LABEL: bb_0:
# CHECK: [[RAX0:%RAX_[0-9]+]] = load i64, i64* %RAX
# CHECK: [[RAX1:%RAX_[0-9]+]] = add i64 [[RAX0]], 1234
# CHECK: [[EAX0:%EAX_[0-9]+]] = trunc i64 [[RAX1]] to i32
# CHECK: [[EAX1:%EAX_[0-9]+]] = add i32 [[EAX0]], 42
# CHECK: [[RAX2:%RAX_[0-9]+]] = zext i32 [[EAX1]] to i64
# CHECK-DAG: store i32 [[EAX1]], i32* %EAX
# CHECK-DAG: store i64 [[RAX2]], i64* %RAX
# CHECK: br label %exit_fn_0
