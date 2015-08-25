#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - -O3 | FileCheck %s

f:
pshufd xmm0, xmm1, 1bh
ret


# CHECK-LABEL: @fn_0
# CHECK: %XMM1_0 = trunc i512 %ZMM1_init to i128
# CHECK: [[XMM1:%[0-9]+]] = bitcast i128 %XMM1_0 to <4 x i32>
# CHECK: [[SHUF:%[0-9]+]] = shufflevector <4 x i32> [[XMM1]], <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
# CHECK: %XMM0_0 = bitcast <4 x i32> [[SHUF]] to i128
# CHECK: [[ZSHUF:%[0-9]+]] = zext i128 %XMM0_0 to i512
# CHECK: %ZMM0_init = load i512, i512* %ZMM0_ptr, align 4
# CHECK: [[ZMM0HI:%[0-9]+]] = and i512 %ZMM0_init, -340282366920938463463374607431768211456
# CHECK: %ZMM0_1 = or i512 [[ZSHUF]], [[ZMM0HI]]
# CHECK: store i512 %ZMM0_1, i512* %ZMM0_ptr, align 4
# CHECK: store i512 %ZMM1_init, i512* %ZMM1_ptr, align 4
