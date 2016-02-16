; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; SSUBLv2i32_v2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x i32>
; CHECK-NEXT: [[V3:%.+]] = sext <2 x i32> [[V2]] to <2 x i64>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V5:%.+]] = bitcast i64 [[V4]] to <2 x i32>
; CHECK-NEXT: [[V6:%.+]] = sext <2 x i32> [[V5]] to <2 x i64>
; CHECK-NEXT: [[V7:%.+]] = sub <2 x i64> [[V3]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = bitcast <2 x i64> [[V7]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V8]], metadata !"Q16")
ssubl	v16.2d, v17.2s, v18.2s

;; SSUBLv4i16_v4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <4 x i16>
; CHECK-NEXT: [[V3:%.+]] = sext <4 x i16> [[V2]] to <4 x i32>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V5:%.+]] = bitcast i64 [[V4]] to <4 x i16>
; CHECK-NEXT: [[V6:%.+]] = sext <4 x i16> [[V5]] to <4 x i32>
; CHECK-NEXT: [[V7:%.+]] = sub <4 x i32> [[V3]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = bitcast <4 x i32> [[V7]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V8]], metadata !"Q16")
ssubl	v16.4s, v17.4h, v18.4h

;; SSUBLv8i8_v8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <8 x i8>
; CHECK-NEXT: [[V3:%.+]] = sext <8 x i8> [[V2]] to <8 x i16>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V5:%.+]] = bitcast i64 [[V4]] to <8 x i8>
; CHECK-NEXT: [[V6:%.+]] = sext <8 x i8> [[V5]] to <8 x i16>
; CHECK-NEXT: [[V7:%.+]] = sub <8 x i16> [[V3]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = bitcast <8 x i16> [[V7]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V8]], metadata !"Q16")
ssubl	v16.8h, v17.8b, v18.8b

ret
