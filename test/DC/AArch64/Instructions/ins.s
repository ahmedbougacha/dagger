; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; INSvi16gpr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: [[W19_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W19")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ins	v16.h[0], w19

;; INSvi16lane
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <8 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ins	v16.h[0], v19.h[0]

;; INSvi32gpr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: [[W19_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W19")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ins	v16.s[0], w19

;; INSvi32lane
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ins	v16.s[0], v19.s[0]

;; INSvi64gpr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
; CHECK-NEXT: [[X19_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X19")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ins	v16.d[0], x19

;; INSvi64lane
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <2 x i64>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <2 x i64>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ins	v16.d[0], v19.d[0]

;; INSvi8gpr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
; CHECK-NEXT: [[W19_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W19")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ins	v16.b[0], w19

;; INSvi8lane
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <16 x i8>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <16 x i8>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ins	v16.b[0], v19.b[0]

ret
