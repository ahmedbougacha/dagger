; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; XTNv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
; CHECK-NEXT: [[V3:%.+]] = trunc <2 x i64> [[V2]] to <2 x i32>
; CHECK-NEXT: [[V4:%.+]] = bitcast <2 x i32> [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
xtn	v16.2s, v17.2d

;; XTNv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: [[V3:%.+]] = trunc <4 x i32> [[V2]] to <4 x i16>
; CHECK-NEXT: [[V4:%.+]] = bitcast <4 x i16> [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
xtn	v16.4h, v17.4s

;; XTNv8i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: [[V3:%.+]] = trunc <8 x i16> [[V2]] to <8 x i8>
; CHECK-NEXT: [[V4:%.+]] = bitcast <8 x i8> [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
xtn	v16.8b, v17.8h

ret
