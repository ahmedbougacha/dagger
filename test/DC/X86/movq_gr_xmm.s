#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - -O3 | FileCheck %s

f:
movq rdi, xmm0
ret


# CHECK-LABEL: @fn_0
# CHECK: [[ZMMBC:%[^ ]+]] = bitcast <16 x float> %ZMM0_init to <4 x i128>
# CHECK: %XMM0_0 = extractelement <4 x i128> [[ZMMBC]], i32 0
# CHECK: [[XMM0:%[0-9]+]] = bitcast i128 %XMM0_0 to <2 x i64>
# CHECK: %RDI_0 = extractelement <2 x i64> [[XMM0]], i64 0
# CHECK: store i64 %RDI_0, i64* %RDI_ptr, align 4
