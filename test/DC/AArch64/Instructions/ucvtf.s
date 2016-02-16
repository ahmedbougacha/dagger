; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; UCVTFUWDri
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[V1:%.+]] = uitofp i32 [[W17_0]] to double
; CHECK-NEXT: [[V2:%.+]] = bitcast double [[V1]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V2]], metadata !"D16")
ucvtf	d16, w17

;; UCVTFUWSri
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[V1:%.+]] = uitofp i32 [[W17_0]] to float
; CHECK-NEXT: [[V2:%.+]] = bitcast float [[V1]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V2]], metadata !"S16")
ucvtf	s16, w17

;; UCVTFUXDri
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = uitofp i64 [[X17_0]] to double
; CHECK-NEXT: [[V2:%.+]] = bitcast double [[V1]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V2]], metadata !"D16")
ucvtf	d16, x17

;; UCVTFUXSri
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = uitofp i64 [[X17_0]] to float
; CHECK-NEXT: [[V2:%.+]] = bitcast float [[V1]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V2]], metadata !"S16")
ucvtf	s16, x17

;; UCVTFv1i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ucvtf	s16, s17

;; UCVTFv1i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ucvtf	d16, d17

;; UCVTFv2f32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x i32>
; CHECK-NEXT: [[V3:%.+]] = uitofp <2 x i32> [[V2]] to <2 x float>
; CHECK-NEXT: [[V4:%.+]] = bitcast <2 x float> [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
ucvtf	v16.2s, v17.2s

;; UCVTFv2f64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
; CHECK-NEXT: [[V3:%.+]] = uitofp <2 x i64> [[V2]] to <2 x double>
; CHECK-NEXT: [[V4:%.+]] = bitcast <2 x double> [[V3]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"Q16")
ucvtf	v16.2d, v17.2d

;; UCVTFv4f32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: [[V3:%.+]] = uitofp <4 x i32> [[V2]] to <4 x float>
; CHECK-NEXT: [[V4:%.+]] = bitcast <4 x float> [[V3]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"Q16")
ucvtf	v16.4s, v17.4s

ret
