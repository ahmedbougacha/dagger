# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MMX_MOVD64from64rm:	movd	%mm1, 2(%r11,%rbx,2)
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x49; .byte 0x0f; .byte 0x7e; .byte 0x4c; .byte 0x5b; .byte 0x02

## MMX_MOVD64from64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[MM5_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"MM5")
# CHECK-NEXT: [[V1:%.+]] = bitcast i64 [[MM5_0]] to x86_mmx
# CHECK-NEXT: [[V2:%.+]] = bitcast x86_mmx [[V1]] to i64
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V2]], metadata !"R11")
movd	%mm5, %r11

## MMX_MOVD64grr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[MM5_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"MM5")
# CHECK-NEXT: [[V1:%.+]] = bitcast i64 [[MM5_0]] to x86_mmx
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
movd	%mm5, %r8d

## MMX_MOVD64mr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
movd	%mm1, 2(%r11,%rbx,2)

## MMX_MOVD64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V1:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V2:%.+]] = add i64 [[V1]], 2
# CHECK-NEXT: [[V3:%.+]] = add i64 [[RBX_0]], [[V2]]
# CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
# CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
movd	2(%rbx,%r14,2), %mm4

## MMX_MOVD64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[R9D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R9D")
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
movd	%r9d, %mm4

## MMX_MOVD64to64rm:	movd	2(%rbx,%r14,2), %mm4
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
.byte 0x4a; .byte 0x0f; .byte 0x6e; .byte 0x64; .byte 0x73; .byte 0x02

## MMX_MOVD64to64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 4
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V1:%.+]] = bitcast i64 [[RBX_0]] to x86_mmx
# CHECK-NEXT: [[V2:%.+]] = bitcast x86_mmx [[V1]] to i64
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V2]], metadata !"MM4")
movd	%rbx, %mm4

## MMX_MOVDQ2Qrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
# CHECK-NEXT: [[V3:%.+]] = extractelement <2 x i64> [[V2]], i64 0
# CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to x86_mmx
# CHECK-NEXT: [[V5:%.+]] = bitcast x86_mmx [[V4]] to i64
# CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V5]], metadata !"MM4")
movdq2q	%xmm9, %mm4

## MOVDI2PDIrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[R14_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R14")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[R14_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[RBX_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to i32*
# CHECK-NEXT: [[V7:%.+]] = load i32, i32* [[V6]], align 1
# CHECK-NEXT: [[V8:%.+]] = insertelement <4 x i32> [[V2]], i32 [[V7]], i32 0
# CHECK-NEXT: [[V9:%.+]] = bitcast <4 x i32> [[V8]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V9]], metadata !"XMM8")
movd	2(%rbx,%r14,2), %xmm8

## MOVDI2PDIrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[R9D_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"R9D")
# CHECK-NEXT: [[V3:%.+]] = insertelement <4 x i32> [[V2]], i32 [[R9D_0]], i32 0
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x i32> [[V3]] to i128
# CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"XMM8")
movd	%r9d, %xmm8

## MOVPDI2DImr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM13_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM13")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM13_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[V3:%.+]] = extractelement <4 x i32> [[V2]], i64 0
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V4:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[V4]], 2
# CHECK-NEXT: [[V6:%.+]] = add i64 [[R11_0]], [[V5]]
# CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i32*
# CHECK-NEXT: store i32 [[V3]], i32* [[V7]], align 1
movd	%xmm13, 2(%r11,%rbx,2)

## MOVPDI2DIrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM9_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM9")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM9_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
# CHECK-NEXT: [[V3:%.+]] = extractelement <4 x i32> [[V2]], i64 0
# CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"R8D")
movd	%xmm9, %r8d

retq
