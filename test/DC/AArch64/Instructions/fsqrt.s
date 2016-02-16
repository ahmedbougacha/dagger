; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; FSQRTDr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[V3:%.+]] = call double @llvm.sqrt.f64(double [[V2]])
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
fsqrt	d16, d17

;; FSQRTSr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[V3:%.+]] = call float @llvm.sqrt.f32(float [[V2]])
; CHECK-NEXT: [[V4:%.+]] = bitcast float [[V3]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"S16")
fsqrt	s16, s17

;; FSQRTv2f32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x float>
; CHECK-NEXT: [[V3:%.+]] = call <2 x float> @llvm.sqrt.v2f32(<2 x float> [[V2]])
; CHECK-NEXT: [[V4:%.+]] = bitcast <2 x float> [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
fsqrt	v16.2s, v17.2s

;; FSQRTv2f64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x double>
; CHECK-NEXT: [[V3:%.+]] = call <2 x double> @llvm.sqrt.v2f64(<2 x double> [[V2]])
; CHECK-NEXT: [[V4:%.+]] = bitcast <2 x double> [[V3]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"Q16")
fsqrt	v16.2d, v17.2d

;; FSQRTv4f32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
; CHECK-NEXT: [[V3:%.+]] = call <4 x float> @llvm.sqrt.v4f32(<4 x float> [[V2]])
; CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[V3]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"Q16")
fsqrt	v16.4s, v17.4s

ret
