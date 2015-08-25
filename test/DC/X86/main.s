#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
ret

# CHECK-LABEL: define i32 @main(i32, i8**) {
# CHECK-NEXT:   %3 = alloca %regset, align 64
# CHECK-NEXT:   %4 = alloca [{{.*}} x i8], align 64
# CHECK-NEXT:   %5 = getelementptr inbounds [{{.*}} x i8], [{{.*}} x i8]* %4, i32 0, i32 0
# CHECK-NEXT:   call void @main_init_regset(%regset* %3, i8* %5, i32 {{.*}}, i32 %0, i8** %1)
# CHECK-NEXT:   call void @fn_0(%regset* %3)
# CHECK-NEXT:   %6 = call i32 @main_fini_regset(%regset* %3)
# CHECK-NEXT:   ret i32 %6
# CHECK-NEXT: }
