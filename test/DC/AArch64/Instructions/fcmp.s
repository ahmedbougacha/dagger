; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; FCMPDri
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fcmp	d16, #0.0

;; FCMPDrr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to double
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fcmp	d16, d17

;; FCMPSri
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S16_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S16")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S16_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fcmp	s16, #0.0

;; FCMPSrr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S16_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S16")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S16_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V3:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V4:%.+]] = bitcast i32 [[V3]] to float
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fcmp	s16, s17

ret
