# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## VFNMSUBSDr132m
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vfnmsub132sd	2(%r15,%r12,2), %xmm10, %xmm8

## VFNMSUBSDr132r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vfnmsub132sd	%xmm11, %xmm10, %xmm8

## VFNMSUBSDr213m
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 7
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i64
# CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to double
# CHECK-NEXT: [[R15_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R15")
# CHECK-NEXT: [[R12_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R12")
# CHECK-NEXT: [[V7:%.+]] = mul i64 [[R12_0]], 2
# CHECK-NEXT: [[V8:%.+]] = add i64 [[V7]], 2
# CHECK-NEXT: [[V9:%.+]] = add i64 [[R15_0]], [[V8]]
# CHECK-NEXT: [[V10:%.+]] = inttoptr i64 [[V9]] to double*
# CHECK-NEXT: [[V11:%.+]] = load double, double* [[V10]], align 1
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vfnmsub213sd	2(%r15,%r12,2), %xmm10, %xmm8

## VFNMSUBSDr213r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 5
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM10_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM10")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM10_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = trunc i128 [[V1]] to i64
# CHECK-NEXT: [[V3:%.+]] = bitcast i64 [[V2]] to double
# CHECK-NEXT: [[XMM8_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM8")
# CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[XMM8_0]] to i128
# CHECK-NEXT: [[V5:%.+]] = trunc i128 [[V4]] to i64
# CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to double
# CHECK-NEXT: [[XMM11_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM11")
# CHECK-NEXT: [[V7:%.+]] = bitcast <4 x float> [[XMM11_0]] to i128
# CHECK-NEXT: [[V8:%.+]] = trunc i128 [[V7]] to i64
# CHECK-NEXT: [[V9:%.+]] = bitcast i64 [[V8]] to double
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vfnmsub213sd	%xmm11, %xmm10, %xmm8

## VFNMSUBSDr231m
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vfnmsub231sd	2(%r15,%r12,2), %xmm10, %xmm8

## VFNMSUBSDr231r
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
vfnmsub231sd	%xmm11, %xmm10, %xmm8

retq
