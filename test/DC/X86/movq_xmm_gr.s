#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - -O3 | FileCheck %s

f:
movq xmm0, rdi
ret


# CHECK-LABEL: @fn_0
# CHECK: [[ZMMBC:%[^ ]+]] = bitcast <16 x float> %ZMM0_init to <4 x i128>
# CHECK: %XMM0_0 = extractelement <4 x i128> [[ZMMBC]], i32 0
# CHECK: [[XMM0:%[0-9]+]] = bitcast i128 %XMM0_0 to <2 x i64>
# CHECK: [[MOVQ:%[0-9]+]] = insertelement <2 x i64> [[XMM0]], i64 %RDI_init, i32 0
# CHECK: %XMM0_1 = bitcast <2 x i64> [[MOVQ]] to i128
# CHECK: [[ZSHUF:%[^ ]+]] = zext i128 %XMM0_1 to i512
