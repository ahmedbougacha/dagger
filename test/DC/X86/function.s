#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
ret

# CHECK-LABEL:  define void @fn_0(%regset* noalias nocapture)
# CHECK-LABEL:  entry_fn_0:
# CHECK:          br label %bb_0
# CHECK-LABEL:  exit_fn_0:
# CHECK:          ret void
# CHECK-LABEL:  bb_0:
# CHECK:          br label %exit_fn_0
