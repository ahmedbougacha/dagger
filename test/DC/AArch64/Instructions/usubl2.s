; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; USUBLv16i8_v8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
usubl2	v16.8h, v17.16b, v18.16b

;; USUBLv4i32_v2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
usubl2	v16.2d, v17.4s, v18.4s

;; USUBLv8i16_v4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
usubl2	v16.4s, v17.8h, v18.8h

ret
