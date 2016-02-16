; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; USUBWv2i32_v2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <2 x i32>
; CHECK-NEXT: [[V5:%.+]] = zext <2 x i32> [[V4]] to <2 x i64>
; CHECK-NEXT: [[V6:%.+]] = sub <2 x i64> [[V2]], [[V5]]
; CHECK-NEXT: [[V7:%.+]] = bitcast <2 x i64> [[V6]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"Q16")
usubw	v16.2d, v17.2d, v18.2s

;; USUBWv4i16_v4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <4 x i16>
; CHECK-NEXT: [[V5:%.+]] = zext <4 x i16> [[V4]] to <4 x i32>
; CHECK-NEXT: [[V6:%.+]] = sub <4 x i32> [[V2]], [[V5]]
; CHECK-NEXT: [[V7:%.+]] = bitcast <4 x i32> [[V6]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"Q16")
usubw	v16.4s, v17.4s, v18.4h

;; USUBWv8i8_v8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <8 x i8>
; CHECK-NEXT: [[V5:%.+]] = zext <8 x i8> [[V4]] to <8 x i16>
; CHECK-NEXT: [[V6:%.+]] = sub <8 x i16> [[V2]], [[V5]]
; CHECK-NEXT: [[V7:%.+]] = bitcast <8 x i16> [[V6]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"Q16")
usubw	v16.8h, v17.8h, v18.8b

ret
