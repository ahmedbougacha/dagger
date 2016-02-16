; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; BITv16i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <16 x i8>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V5:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V6:%.+]] = bitcast i128 [[V5]] to <16 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
bit	v16.16b, v18.16b, v19.16b

;; BITv8i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <8 x i8>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <8 x i8>
; CHECK-NEXT: [[D19_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D19")
; CHECK-NEXT: [[V5:%.+]] = bitcast double [[D19_0]] to i64
; CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to <8 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
bit	v16.8b, v18.8b, v19.8b

ret
