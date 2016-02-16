; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; UQSHLb
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	b16, b17, #0

;; UQSHLd
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	d16, d17, #0

;; UQSHLh
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	h16, h17, #0

;; UQSHLs
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	s16, s17, #0

;; UQSHLv16i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.16b, v17.16b, v18.16b

;; UQSHLv16i8_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.16b, v17.16b, #0

;; UQSHLv1i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	h16, h17, h18

;; UQSHLv1i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	s16, s17, s18

;; UQSHLv1i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	d16, d17, d18

;; UQSHLv1i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	b16, b17, b18

;; UQSHLv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.2s, v17.2s, v18.2s

;; UQSHLv2i32_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.2s, v17.2s, #0

;; UQSHLv2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.2d, v17.2d, v18.2d

;; UQSHLv2i64_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.2d, v17.2d, #0

;; UQSHLv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.4h, v17.4h, v18.4h

;; UQSHLv4i16_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <4 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.4h, v17.4h, #0

;; UQSHLv4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.4s, v17.4s, v18.4s

;; UQSHLv4i32_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.4s, v17.4s, #0

;; UQSHLv8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.8h, v17.8h, v18.8h

;; UQSHLv8i16_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.8h, v17.8h, #0

;; UQSHLv8i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.8b, v17.8b, v18.8b

;; UQSHLv8i8_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <8 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uqshl	v16.8b, v17.8b, #0

ret
