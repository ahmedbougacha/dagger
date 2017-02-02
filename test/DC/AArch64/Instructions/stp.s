; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; STPDi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V3:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V4:%.+]] = add i64 [[X18_0]], [[V3]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to double*
; CHECK-NEXT: store double [[V2]], double* [[V5]], align 1
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V6:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V7:%.+]] = bitcast i64 [[V6]] to double
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X18_1]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 8, [[V9]]
; CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to double*
; CHECK-NEXT: store double [[V7]], double* [[V11]], align 1
stp		d16, d17, [x18, #0]

;; STPDpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[X16_0]] to double*
; CHECK-NEXT: store double [[V2]], double* [[V3]], align 1
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V5:%.+]] = bitcast i64 [[V4]] to double
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V6:%.+]] = add i64 8, [[X16_1]]
; CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to double*
; CHECK-NEXT: store double [[V5]], double* [[V7]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_2]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 8, [[V9]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"X16")
stp	d17, d18, [x16], #0

;; STPDpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[V1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = bitcast i64 [[V1]] to double
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V3:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V4:%.+]] = add i64 [[X16_0]], [[V3]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to double*
; CHECK-NEXT: store double [[V2]], double* [[V5]], align 1
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[V6:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[V7:%.+]] = bitcast i64 [[V6]] to double
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_1]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 8, [[V9]]
; CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to double*
; CHECK-NEXT: store double [[V7]], double* [[V11]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V12:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V13:%.+]] = add i64 [[X16_2]], [[V12]]
; CHECK-NEXT: [[V14:%.+]] = add i64 8, [[V13]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V14]], metadata !"X16")
stp	d17, d18, [x16, #0]!

;; STPQi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to fp128
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V3:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V4:%.+]] = add i64 [[X18_0]], [[V3]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to fp128*
; CHECK-NEXT: store fp128 [[V2]], fp128* [[V5]], align 1
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V6:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V7:%.+]] = bitcast i128 [[V6]] to fp128
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X18_1]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 16, [[V9]]
; CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to fp128*
; CHECK-NEXT: store fp128 [[V7]], fp128* [[V11]], align 1
stp		q16, q17, [x18, #0]

;; STPQpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to fp128
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[X16_0]] to fp128*
; CHECK-NEXT: store fp128 [[V2]], fp128* [[V3]], align 1
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V4:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V5:%.+]] = bitcast i128 [[V4]] to fp128
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V6:%.+]] = add i64 16, [[X16_1]]
; CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to fp128*
; CHECK-NEXT: store fp128 [[V5]], fp128* [[V7]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_2]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 16, [[V9]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"X16")
stp	q17, q18, [x16], #0

;; STPQpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[V1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[V2:%.+]] = bitcast i128 [[V1]] to fp128
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V3:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V4:%.+]] = add i64 [[X16_0]], [[V3]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to fp128*
; CHECK-NEXT: store fp128 [[V2]], fp128* [[V5]], align 1
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[V6:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[V7:%.+]] = bitcast i128 [[V6]] to fp128
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_1]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 16, [[V9]]
; CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to fp128*
; CHECK-NEXT: store fp128 [[V7]], fp128* [[V11]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V12:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V13:%.+]] = add i64 [[X16_2]], [[V12]]
; CHECK-NEXT: [[V14:%.+]] = add i64 16, [[V13]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V14]], metadata !"X16")
stp	q17, q18, [x16, #0]!

;; STPSi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S16_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S16")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S16_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V3:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V4:%.+]] = add i64 [[X18_0]], [[V3]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to float*
; CHECK-NEXT: store float [[V2]], float* [[V5]], align 1
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V6:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V7:%.+]] = bitcast i32 [[V6]] to float
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X18_1]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 4, [[V9]]
; CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to float*
; CHECK-NEXT: store float [[V7]], float* [[V11]], align 1
stp		s16, s17, [x18, #0]

;; STPSpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[X16_0]] to float*
; CHECK-NEXT: store float [[V2]], float* [[V3]], align 1
; CHECK-NEXT: [[S18_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S18")
; CHECK-NEXT: [[V4:%.+]] = bitcast float [[S18_0]] to i32
; CHECK-NEXT: [[V5:%.+]] = bitcast i32 [[V4]] to float
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V6:%.+]] = add i64 4, [[X16_1]]
; CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to float*
; CHECK-NEXT: store float [[V5]], float* [[V7]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_2]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 4, [[V9]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"X16")
stp	s17, s18, [x16], #0

;; STPSpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[V1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[V2:%.+]] = bitcast i32 [[V1]] to float
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V3:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V4:%.+]] = add i64 [[X16_0]], [[V3]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to float*
; CHECK-NEXT: store float [[V2]], float* [[V5]], align 1
; CHECK-NEXT: [[S18_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S18")
; CHECK-NEXT: [[V6:%.+]] = bitcast float [[S18_0]] to i32
; CHECK-NEXT: [[V7:%.+]] = bitcast i32 [[V6]] to float
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_1]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 4, [[V9]]
; CHECK-NEXT: [[V11:%.+]] = inttoptr i64 [[V10]] to float*
; CHECK-NEXT: store float [[V7]], float* [[V11]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V12:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V13:%.+]] = add i64 [[X16_2]], [[V12]]
; CHECK-NEXT: [[V14:%.+]] = add i64 4, [[V13]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V14]], metadata !"X16")
stp	s17, s18, [x16, #0]!

;; STPWi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[W16_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W16")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X18_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i32*
; CHECK-NEXT: store i32 [[W16_0]], i32* [[V3]], align 1
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V4:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V5:%.+]] = add i64 [[X18_1]], [[V4]]
; CHECK-NEXT: [[V6:%.+]] = add i64 4, [[V5]]
; CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i32*
; CHECK-NEXT: store i32 [[W17_0]], i32* [[V7]], align 1
stp		w16, w17, [x18, #0]

;; STPWpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 [[X16_0]] to i32*
; CHECK-NEXT: store i32 [[W17_0]], i32* [[V1]], align 1
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V2:%.+]] = add i64 4, [[X16_1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i32*
; CHECK-NEXT: store i32 [[W18_0]], i32* [[V3]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V4:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V5:%.+]] = add i64 [[X16_2]], [[V4]]
; CHECK-NEXT: [[V6:%.+]] = add i64 4, [[V5]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"X16")
stp	w17, w18, [x16], #0

;; STPWpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X16_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i32*
; CHECK-NEXT: store i32 [[W17_0]], i32* [[V3]], align 1
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V4:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V5:%.+]] = add i64 [[X16_1]], [[V4]]
; CHECK-NEXT: [[V6:%.+]] = add i64 4, [[V5]]
; CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i32*
; CHECK-NEXT: store i32 [[W18_0]], i32* [[V7]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_2]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 4, [[V9]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"X16")
stp	w17, w18, [x16, #0]!

;; STPXi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X18_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i64*
; CHECK-NEXT: store i64 [[X16_0]], i64* [[V3]], align 1
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V4:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V5:%.+]] = add i64 [[X18_1]], [[V4]]
; CHECK-NEXT: [[V6:%.+]] = add i64 8, [[V5]]
; CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i64*
; CHECK-NEXT: store i64 [[X17_0]], i64* [[V7]], align 1
stp		x16, x17, [x18, #0]

;; STPXpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 [[X16_0]] to i64*
; CHECK-NEXT: store i64 [[X17_0]], i64* [[V1]], align 1
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V2:%.+]] = add i64 8, [[X16_1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i64*
; CHECK-NEXT: store i64 [[X18_0]], i64* [[V3]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V4:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V5:%.+]] = add i64 [[X16_2]], [[V4]]
; CHECK-NEXT: [[V6:%.+]] = add i64 8, [[V5]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V6]], metadata !"X16")
stp	x17, x18, [x16], #0

;; STPXpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X16_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i64*
; CHECK-NEXT: store i64 [[X17_0]], i64* [[V3]], align 1
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V4:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V5:%.+]] = add i64 [[X16_1]], [[V4]]
; CHECK-NEXT: [[V6:%.+]] = add i64 8, [[V5]]
; CHECK-NEXT: [[V7:%.+]] = inttoptr i64 [[V6]] to i64*
; CHECK-NEXT: store i64 [[X18_0]], i64* [[V7]], align 1
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_2]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 8, [[V9]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"X16")
stp	x17, x18, [x16, #0]!

ret
