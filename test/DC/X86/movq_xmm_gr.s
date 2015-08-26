#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - -O3 | FileCheck %s

f:
movq xmm0, rdi
ret


# CHECK-LABEL: @fn_0
# CHECK: %XMM0_0 = trunc i512 %ZMM0_init to i128
# CHECK: [[XMM0:%[0-9]+]] = bitcast i128 %XMM0_0 to <2 x i64>
# CHECK: [[MOVQ:%[0-9]+]] = insertelement <2 x i64> [[XMM0]], i64 %RDI_init, i32 0
# CHECK: %XMM0_1 = bitcast <2 x i64> [[MOVQ]] to i128
# CHECK: [[ZMOVQ:%[0-9]+]] = zext i128 %XMM0_1 to i512
# CHECK: [[ZMM0HI:%[0-9]+]] = and i512 %ZMM0_init, -340282366920938463463374607431768211456
# CHECK: %ZMM0_1 = or i512 [[ZMOVQ]], [[ZMM0HI]]
# CHECK: store i512 %ZMM0_1, i512* %ZMM0_ptr, align 4
