; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; FNMADDDrrr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to double
; CHECK-NEXT: [[D19_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D19")
; CHECK-NEXT: [[V5:%.+]] = bitcast double [[D19_0]] to i64
; CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to double
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fnmadd	d16, d17, d18, d19

;; FNMADDSrrr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[S18_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S18")
; CHECK-NEXT: [[V3:%.+]] = bitcast float [[S18_0]] to i32
; CHECK-NEXT: [[V4:%.+]] = bitcast i32 [[V3]] to float
; CHECK-NEXT: [[S19_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S19")
; CHECK-NEXT: [[V5:%.+]] = bitcast float [[S19_0]] to i32
; CHECK-NEXT: [[V6:%.+]] = bitcast i32 [[V5]] to float
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fnmadd	s16, s17, s18, s19

ret
