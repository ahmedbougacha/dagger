#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - -annot | FileCheck %s

mul:
imul QWORD PTR [rsp + 8]
ret

# CHECK-LABEL: bb_0:
# CHECK: [[RAX0:%RAX_[0-9]+]] = load i64* %RAX                  ; imp-use RAX    @0: imulq 8(%rsp)
# CHECK: [[RSP0:%RSP_[0-9]+]] = load i64* %RSP
# CHECK: [[RSPADD:%[0-9]+]]   = add i64 [[RSP0]], 8
# CHECK:                      = inttoptr i64 [[RSPADD]] to i64* ; op-use 8(%rsp) @0: imulq 8(%rsp)
# CHECK: [[MUL:%[0-9]+]]      = mul i128
# CHECK: [[RAX1:%RAX_[0-9]+]] = trunc i128 [[MUL]] to i64       ; imp-def RAX    @0: imulq 8(%rsp)
# CHECK: [[RDX1:%RDX_[0-9]+]] = trunc i128 %{{[0-9]+}} to i64   ; imp-def RDX    @0: imulq 8(%rsp)
# CHECK: br label %exit_fn_0
