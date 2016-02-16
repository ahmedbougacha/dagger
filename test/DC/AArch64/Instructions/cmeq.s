; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; CMEQv16i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <16 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.16b, v17.16b, v18.16b

;; CMEQv16i8rz
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.16b, v17.16b, #0

;; CMEQv1i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <1 x i64>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <1 x i64>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	d16, d17, d18

;; CMEQv1i64rz
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	d16, d17, #0

;; CMEQv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x i32>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <2 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.2s, v17.2s, v18.2s

;; CMEQv2i32rz
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.2s, v17.2s, #0

;; CMEQv2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <2 x i64>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.2d, v17.2d, v18.2d

;; CMEQv2i64rz
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.2d, v17.2d, #0

;; CMEQv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <4 x i16>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <4 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.4h, v17.4h, v18.4h

;; CMEQv4i16rz
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <4 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.4h, v17.4h, #0

;; CMEQv4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.4s, v17.4s, v18.4s

;; CMEQv4i32rz
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.4s, v17.4s, #0

;; CMEQv8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <8 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.8h, v17.8h, v18.8h

;; CMEQv8i16rz
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.8h, v17.8h, #0

;; CMEQv8i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <8 x i8>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <8 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.8b, v17.8b, v18.8b

;; CMEQv8i8rz
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <8 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
cmeq	v16.8b, v17.8b, #0

ret
