#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
mov rax, rax
mov ebx, ebx
ret

# CHECK-LABEL:  @fn_0
# CHECK-LABEL:  entry_fn_0:
# CHECK:          %RAX_ptr = getelementptr inbounds %regset* %0
# CHECK:          %RAX_init = load i64* %RAX_ptr
# CHECK:          %RAX = alloca i64
# CHECK:          store i64 %RAX_init, i64* %RAX
# CHECK:          %EAX = alloca i32
# CHECK:          store i32 %EAX_init, i32* %EAX
# CHECK:          %AX = alloca i16
# CHECK:          store i16 %AX_init, i16* %AX
# CHECK:          %AL = alloca i8
# CHECK:          store i8 %AL_init, i8* %AL
# CHECK:          %AH = alloca i8
# CHECK:          store i8 %AH_init, i8* %AH
# CHECK:          %EBX = alloca i32
# CHECK:          store i32 %EBX_init, i32* %EBX
# CHECK-LABEL:  exit_fn_0:
# CHECK-DAG:      [[LASTRAX:%[0-9]+]] = load i64* %RAX
# CHECK-DAG:      store i64 [[LASTRAX:%[0-9]+]], i64* %RAX_ptr
# CHECK-DAG:      [[LASTRBX:%[0-9]+]] = load i64* %RBX
# CHECK-DAG:      store i64 [[LASTRBX:%[0-9]+]], i64* %RBX_ptr
# CHECK-LABEL:  bb_0:
# CHECK-DAG:      %RAX_0 = load i64* %RAX
# CHECK-DAG:      store i64 %RAX_0, i64* %RAX
# CHECK-DAG:      %RBX_0 = load i64* %RBX
# CHECK-DAG:      %EBX_0 = trunc i64 %RBX_0 to i32
# CHECK-DAG:      store i32 %EBX_0, i32* %EBX
# CHECK: br label %exit_fn_0
