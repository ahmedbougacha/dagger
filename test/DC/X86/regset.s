#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

f:
ret

# CHECK: %regset = type { {{i[0-9]+[, i[0-9]+]*}} }
