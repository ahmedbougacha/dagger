; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; FCVTDHr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[H17_0:%.+]] = call half @llvm.dc.getreg.f16(metadata !"H17")
; CHECK-NEXT: [[V1:%.+]] = bitcast half [[H17_0]] to i16
; CHECK-NEXT: [[V2:%.+]] = bitcast i16 [[V1]] to half
; CHECK-NEXT: [[V3:%.+]] = fpext half [[V2]] to double
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
fcvt	d16, h17

;; FCVTDSr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[V3:%.+]] = fpext float [[V2]] to double
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
fcvt	d16, s17

;; FCVTHDr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[V3:%.+]] = fptrunc double [[V2]] to half
; CHECK-NEXT: [[V4:%.+]] = bitcast half [[V3]] to i16
; CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"H16")
fcvt	h16, d17

;; FCVTHSr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[V3:%.+]] = fptrunc float [[V2]] to half
; CHECK-NEXT: [[V4:%.+]] = bitcast half [[V3]] to i16
; CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"H16")
fcvt	h16, s17

;; FCVTSDr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[V3:%.+]] = fptrunc double [[V2]] to float
; CHECK-NEXT: [[V4:%.+]] = bitcast float [[V3]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"S16")
fcvt	s16, d17

;; FCVTSHr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[H17_0:%.+]] = call half @llvm.dc.getreg.f16(metadata !"H17")
; CHECK-NEXT: [[V1:%.+]] = bitcast half [[H17_0]] to i16
; CHECK-NEXT: [[V2:%.+]] = bitcast i16 [[V1]] to half
; CHECK-NEXT: [[V3:%.+]] = fpext half [[V2]] to float
; CHECK-NEXT: [[V4:%.+]] = bitcast float [[V3]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"S16")
fcvt	s16, h17

ret
