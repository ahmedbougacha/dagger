; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; MLSv16i8
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
; CHECK-NEXT: [[V7:%.+]] = mul <16 x i8> [[V4]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = sub <16 x i8> [[V2]], [[V7]]
; CHECK-NEXT: [[V9:%.+]] = bitcast <16 x i8> [[V8]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V9]], metadata !"Q16")
mls	v16.16b, v18.16b, v19.16b

;; MLSv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x i32>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <2 x i32>
; CHECK-NEXT: [[D19_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D19")
; CHECK-NEXT: [[V5:%.+]] = bitcast double [[D19_0]] to i64
; CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to <2 x i32>
; CHECK-NEXT: [[V7:%.+]] = mul <2 x i32> [[V4]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = sub <2 x i32> [[V2]], [[V7]]
; CHECK-NEXT: [[V9:%.+]] = bitcast <2 x i32> [[V8]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"D16")
mls	v16.2s, v18.2s, v19.2s

;; MLSv2i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <2 x i32>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <2 x i32>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V5:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V6:%.+]] = bitcast i128 [[V5]] to <4 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
mls	v16.2s, v18.2s, v19.s[0]

;; MLSv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <4 x i16>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <4 x i16>
; CHECK-NEXT: [[D19_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D19")
; CHECK-NEXT: [[V5:%.+]] = bitcast double [[D19_0]] to i64
; CHECK-NEXT: [[V6:%.+]] = bitcast i64 [[V5]] to <4 x i16>
; CHECK-NEXT: [[V7:%.+]] = mul <4 x i16> [[V4]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = sub <4 x i16> [[V2]], [[V7]]
; CHECK-NEXT: [[V9:%.+]] = bitcast <4 x i16> [[V8]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"D16")
mls	v16.4h, v18.4h, v19.4h

;; MLSv4i16_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to <4 x i16>
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V4:%.+]] = bitcast i64 [[V3]] to <4 x i16>
; CHECK-NEXT: [[Q11_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q11")
; CHECK-NEXT: [[V5:%.+]] = bitcast <16 x i8> [[Q11_0]] to i128
; CHECK-NEXT: [[V6:%.+]] = bitcast i128 [[V5]] to <8 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
mls	v16.4h, v18.4h, v11.h[0]

;; MLSv4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x i32>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V5:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V6:%.+]] = bitcast i128 [[V5]] to <4 x i32>
; CHECK-NEXT: [[V7:%.+]] = mul <4 x i32> [[V4]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = sub <4 x i32> [[V2]], [[V7]]
; CHECK-NEXT: [[V9:%.+]] = bitcast <4 x i32> [[V8]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V9]], metadata !"Q16")
mls	v16.4s, v18.4s, v19.4s

;; MLSv4i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <4 x i32>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <4 x i32>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V5:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V6:%.+]] = bitcast i128 [[V5]] to <4 x i32>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
mls	v16.4s, v18.4s, v19.s[0]

;; MLSv8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <8 x i16>
; CHECK-NEXT: [[Q19_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q19")
; CHECK-NEXT: [[V5:%.+]] = bitcast <16 x i8> [[Q19_0]] to i128
; CHECK-NEXT: [[V6:%.+]] = bitcast i128 [[V5]] to <8 x i16>
; CHECK-NEXT: [[V7:%.+]] = mul <8 x i16> [[V4]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = sub <8 x i16> [[V2]], [[V7]]
; CHECK-NEXT: [[V9:%.+]] = bitcast <8 x i16> [[V8]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V9]], metadata !"Q16")
mls	v16.8h, v18.8h, v19.8h

;; MLSv8i16_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to <8 x i16>
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V3:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V4:%.+]] = bitcast i128 [[V3]] to <8 x i16>
; CHECK-NEXT: [[Q11_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q11")
; CHECK-NEXT: [[V5:%.+]] = bitcast <16 x i8> [[Q11_0]] to i128
; CHECK-NEXT: [[V6:%.+]] = bitcast i128 [[V5]] to <8 x i16>
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
mls	v16.8h, v18.8h, v11.h[0]

;; MLSv8i8
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
; CHECK-NEXT: [[V7:%.+]] = mul <8 x i8> [[V4]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = sub <8 x i8> [[V2]], [[V7]]
; CHECK-NEXT: [[V9:%.+]] = bitcast <8 x i8> [[V8]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"D16")
mls	v16.8b, v18.8b, v19.8b

ret
