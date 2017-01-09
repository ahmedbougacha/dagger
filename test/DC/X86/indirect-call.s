#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

indbr:
call rdi
add rax, 2
ret

# CHECK-LABEL: bb_0:
# CHECK: [[RDI0:%RDI_[0-9]+]] = load i64, i64* %RDI
# CHECK: [[RDIPTR:%[0-9]+]] = inttoptr i64 [[RDI0]] to i8*
# CHECK: [[PTR1:%[0-9]+]] = call i8* @llvm.dc.translate.at(i8* [[RDIPTR]])
# CHECK: [[FPTR:%[0-9]+]] = bitcast i8* [[PTR1]] to void (%regset*)*
# CHECK: store i64 [[RDI0]], i64* %RDI
# CHECK: br label %bb_0_call
# CHECK-LABEL: bb_0_call:
# CHECK-DAG: [[RDISAVE:%[0-9]+]] = load i64, i64* %RDI
# CHECK-DAG: store i64 [[RDISAVE]],  i64* %RDI
# CHECK-DAG: [[RIPSAVE:%[0-9]+]] = load i64, i64* %RIP
# CHECK-DAG: store i64 [[RIPSAVE]],  i64* %RIP
# CHECK: call void [[FPTR]](%regset* %0)
# CHECK: br label %bb_c0
# CHECK-LABEL: bb_c0:
# CHECK: [[RAX0:%RAX_[0-9]+]] = load i64, i64* %RAX
# CHECK: [[RAX1:%RAX_[0-9]+]] = add i64 [[RAX0]], 2
# CHECK: store i64 [[RAX1]], i64* %RAX
# CHECK: br label %exit_fn_0
