#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - -O3 | FileCheck %s

f:
pshufd xmm0, xmm1, 1bh
ret


# CHECK-LABEL: @fn_0
# CHECK: [[ZMMBC:%[^ ]+]] = bitcast <16 x float> %ZMM1_init to <4 x i128>
# CHECK: %XMM1_0 = extractelement <4 x i128> [[ZMMBC]], i32 0
# CHECK: [[XMM1:%[^ ]+]] = bitcast i128 %XMM1_0 to <4 x i32>
# CHECK: [[SHUF:%[^ ]+]] = shufflevector <4 x i32> [[XMM1]], <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
# CHECK: %XMM0_0 = bitcast <4 x i32> [[SHUF]] to i128
# CHECK: [[ZSHUF:%[^ ]+]] = zext i128 %XMM0_0 to i512
