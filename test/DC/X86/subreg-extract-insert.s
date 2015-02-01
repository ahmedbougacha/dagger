#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
mov rax, rax
mov ebx, eax
ret

# CHECK-LABEL:  define void @fn_0
# CHECK-LABEL:  exit_fn_0:
# CHECK-DAG:      [[LASTRAX:%[0-9]+]] = load i64* %RAX
# CHECK-DAG:      store i64 [[LASTRAX:%[0-9]+]], i64* %RAX_ptr
# CHECK-DAG:      [[LASTRBX:%[0-9]+]] = load i64* %RBX
# CHECK-DAG:      store i64 [[LASTRBX:%[0-9]+]], i64* %RBX_ptr
# CHECK-LABEL:  bb_0:
# CHECK:          %RAX_0 = load i64* %RAX
# CHECK:          %EAX_0 = trunc i64 %RAX_0 to i32
# Unused load, inserted when first creating the value for %EBX_0 to init %EBX:
# see FIXME in DCRegisterSema.
# CHECK:          %RBX_0 = load i64* %RBX
# CHECK-DAG:      %RBX_1 = zext i32 [[EBXVAL:%EAX_0]] to i64
# CHECK-DAG:      %BX_0 = trunc i32 [[EBXVAL]] to i16
# CHECK-DAG:      [[BH32:%[0-9]+]] = lshr i32 [[EBXVAL]], 8
# CHECK-DAG:      %BH_0 = trunc i32 [[BH32]] to i8
# CHECK-DAG:      %BL_0 = trunc i32 [[EBXVAL]] to i8
# CHECK-DAG:      store i64 %RAX_0, i64* %RAX
# CHECK-DAG:      store i64 %RBX_1, i64* %RBX
# CHECK-DAG:      store i32 [[EBXVAL]], i32* %EBX
# CHECK-DAG:      store i16 %BX_0, i16* %BX
# CHECK-DAG:      store i8 %BL_0, i8* %BL
# CHECK-DAG:      store i8 %BH_0, i8* %BH
# CHECK: br label %exit_fn_0
