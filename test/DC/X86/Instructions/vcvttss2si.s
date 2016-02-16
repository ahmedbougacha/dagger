# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VCVTTSS2SI64Zrm:	vcvttss2si	2(%rbx,%r14,2), %r11
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 11
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to float*
# CHECK-NEXT: [[V5:%.+]] = load float, float* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = fptosi float [[V5]] to i64
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"R11")
.byte 0x62; .byte 0x31; .byte 0xfe; .byte 0x08; .byte 0x2c; .byte 0x9c; .byte 0x73; .byte 0x02; .byte 0x00; .byte 0x00; .byte 0x00

## VCVTTSS2SI64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to float*
# CHECK-NEXT: [[V5:%.+]] = load float, float* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = fptosi float [[V5]] to i64
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"R11")
vcvttss2si	2(%rbx,%r14,2), %r11

## VCVTTSS2SI64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = bitcast i32 [[V2]] to float
# CHECK-NEXT: [[V4:%.+]] = fptosi float [[V3]] to i64
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"R11")
vcvttss2si	%xmm9, %r11

## VCVTTSS2SIZrm:	vcvttss2si	2(%rbx,%r14,2), %r8d
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 11
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to float*
# CHECK-NEXT: [[V5:%.+]] = load float, float* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = fptosi float [[V5]] to i32
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"R8D")
.byte 0x62; .byte 0x31; .byte 0x7e; .byte 0x08; .byte 0x2c; .byte 0x84; .byte 0x73; .byte 0x02; .byte 0x00; .byte 0x00; .byte 0x00

## VCVTTSS2SIrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to float*
# CHECK-NEXT: [[V5:%.+]] = load float, float* [[V4]], align 1
# CHECK-NEXT: [[V6:%.+]] = fptosi float [[V5]] to i32
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V6]], metadata !"R8D")
vcvttss2si	2(%rbx,%r14,2), %r8d

## VCVTTSS2SIrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i32
# CHECK-NEXT: [[V3:%.+]] = bitcast i32 [[V2]] to float
# CHECK-NEXT: [[V4:%.+]] = fptosi float [[V3]] to i32
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"R8D")
vcvttss2si	%xmm9, %r8d

retq
