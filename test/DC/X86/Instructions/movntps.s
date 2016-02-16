# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## MOVNTPSmr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: [[RIP_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RIP")
# CHECK-NEXT: [[V0:%.+]] = add i64 [[RIP_0]], 6
# CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"RIP")
# CHECK-NEXT: [[XMM13_0:%.+]] = call <4 x float> @llvm.dc.getreg.v4f32(metadata !"XMM13")
# CHECK-NEXT: [[V1:%.+]] = bitcast <4 x float> [[XMM13_0]] to i128
# CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
# CHECK-NEXT: [[R11_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"R11")
# CHECK-NEXT: [[RBX_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"RBX")
# CHECK-NEXT: [[V3:%.+]] = mul i64 [[RBX_0]], 2
# CHECK-NEXT: [[V4:%.+]] = add i64 [[V3]], 2
# CHECK-NEXT: [[V5:%.+]] = add i64 [[R11_0]], [[V4]]
# CHECK-NEXT: [[V6:%.+]] = inttoptr i64 [[V5]] to <4 x float>*
# CHECK-NEXT: store <4 x float> [[V2]], <4 x float>* [[V6]], align 1
movntps	%xmm13, 2(%r11,%rbx,2)

retq
