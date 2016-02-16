; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; FCVTZUUWDr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[V3:%.+]] = fptoui double [[V2]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"W16")
fcvtzu	w16, d17

;; FCVTZUUWSr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[V3:%.+]] = fptoui float [[V2]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"W16")
fcvtzu	w16, s17

;; FCVTZUUXDr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[V3:%.+]] = fptoui double [[V2]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"X16")
fcvtzu	x16, d17

;; FCVTZUUXSr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[V3:%.+]] = fptoui float [[V2]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"X16")
fcvtzu	x16, s17

;; FCVTZUv1i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fcvtzu	s16, s17

;; FCVTZUv1i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fcvtzu	d16, d17

;; FCVTZUv2f32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x float>
; CHECK-NEXT: [[V3:%.+]] = fptoui <2 x float> [[V2]] to <2 x i32>
; CHECK-NEXT: [[V4:%.+]] = bitcast <2 x i32> [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
fcvtzu	v16.2s, v17.2s

;; FCVTZUv2f64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x double>
; CHECK-NEXT: [[V3:%.+]] = fptoui <2 x double> [[V2]] to <2 x i64>
; CHECK-NEXT: [[V4:%.+]] = bitcast <2 x i64> [[V3]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"Q16")
fcvtzu	v16.2d, v17.2d

;; FCVTZUv4f32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x float>
; CHECK-NEXT: [[V3:%.+]] = fptoui <4 x float> [[V2]] to <4 x i32>
; CHECK-NEXT: [[V4:%.+]] = bitcast <4 x i32> [[V3]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"Q16")
fcvtzu	v16.4s, v17.4s

ret
