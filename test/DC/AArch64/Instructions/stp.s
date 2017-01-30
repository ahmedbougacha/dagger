; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; STPDi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[D16_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D16")
; CHECK-NEXT: [[D16_1:%.+]] = bitcast double [[D16_0]] to i64
; CHECK-NEXT: [[D16_2:%.+]] = bitcast i64 [[D16_1]] to double
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X18_0]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = inttoptr i64 [[OFFSET_0]] to double*
; CHECK-NEXT: store double [[D16_2]], double* [[OFFSET_1]], align 1
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[D17_1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[D17_2:%.+]] = bitcast i64 [[D17_1]] to double
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_2:%.+]] = add i64 [[X18_1]], [[INDEX_1]]
; CHECK-NEXT: [[OFFSET_3:%.+]] = add i64 8, [[OFFSET_2]]
; CHECK-NEXT: [[OFFSET_4:%.+]] = inttoptr i64 [[OFFSET_3]] to double*
; CHECK-NEXT: store double [[D17_2]], double* [[OFFSET_4]], align 1
stp		d16, d17, [x18, #16]

;; STPDpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[D17_1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[D17_2:%.+]] = bitcast i64 [[D17_1]] to double
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_1:%.+]] = inttoptr i64 [[X16_0]] to double*
; CHECK-NEXT: store double [[D17_2]], double* [[X16_1]], align 1
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[D18_1:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[D18_2:%.+]] = bitcast i64 [[D18_1]] to double
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_3:%.+]] = add i64 8, [[X16_2]]
; CHECK-NEXT: [[X16_4:%.+]] = inttoptr i64 [[X16_3]] to double*
; CHECK-NEXT: store double [[D18_2]], double* [[X16_4]], align 1
; CHECK-NEXT: [[X16_5:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X16_5]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = add i64 8, [[OFFSET_0]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[OFFSET_1]], metadata !"X16")
stp	d17, d18, [x16], #16

;; STPDpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[D17_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D17")
; CHECK-NEXT: [[D17_1:%.+]] = bitcast double [[D17_0]] to i64
; CHECK-NEXT: [[D17_2:%.+]] = bitcast i64 [[D17_1]] to double
; CHECK-NEXT: [[DST_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_1:%.+]] = add i64 [[DST_0]], [[INDEX_0]]
; CHECK-NEXT: [[DST_2:%.+]] = inttoptr i64 [[DST_1]] to double*
; CHECK-NEXT: store double [[D17_2]], double* [[DST_2]], align 1
; CHECK-NEXT: [[D18_0:%.+]] = call double @llvm.dc.getreg.f64(metadata !"D18")
; CHECK-NEXT: [[D18_1:%.+]] = bitcast double [[D18_0]] to i64
; CHECK-NEXT: [[D18_2:%.+]] = bitcast i64 [[D18_1]] to double
; CHECK-NEXT: [[DST_3:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_4:%.+]] = add i64 [[DST_3]], [[INDEX_1]]
; CHECK-NEXT: [[DST_5:%.+]] = add i64 8, [[DST_4]]
; CHECK-NEXT: [[DST_6:%.+]] = inttoptr i64 [[DST_5]] to double*
; CHECK-NEXT: store double [[D18_2]], double* [[DST_6]], align 1
; CHECK-NEXT: [[WBACK_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_2:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[WBACK_1:%.+]] = add i64 [[WBACK_0]], [[INDEX_2]]
; CHECK-NEXT: [[WBACK_2:%.+]] = add i64 8, [[WBACK_1]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[WBACK_2]], metadata !"X16")
stp	d17, d18, [x16, #16]!

;; STPQi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[Q16_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q16")
; CHECK-NEXT: [[Q16_1:%.+]] = bitcast <16 x i8> [[Q16_0]] to i128
; CHECK-NEXT: [[Q16_2:%.+]] = bitcast i128 [[Q16_1]] to fp128
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X18_0]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = inttoptr i64 [[OFFSET_0]] to fp128*
; CHECK-NEXT: store fp128 [[Q16_2]], fp128* [[OFFSET_1]], align 1
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[Q17_1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[Q17_2:%.+]] = bitcast i128 [[Q17_1]] to fp128
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_2:%.+]] = add i64 [[X18_1]], [[INDEX_1]]
; CHECK-NEXT: [[OFFSET_3:%.+]] = add i64 16, [[OFFSET_2]]
; CHECK-NEXT: [[OFFSET_4:%.+]] = inttoptr i64 [[OFFSET_3]] to fp128*
; CHECK-NEXT: store fp128 [[Q17_2]], fp128* [[OFFSET_4]], align 1
stp		q16, q17, [x18, #32]

;; STPQpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[Q17_1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[Q17_2:%.+]] = bitcast i128 [[Q17_1]] to fp128
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_1:%.+]] = inttoptr i64 [[X16_0]] to fp128*
; CHECK-NEXT: store fp128 [[Q17_2]], fp128* [[X16_1]], align 1
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[Q18_1:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[Q18_2:%.+]] = bitcast i128 [[Q18_1]] to fp128
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_3:%.+]] = add i64 16, [[X16_2]]
; CHECK-NEXT: [[X16_4:%.+]] = inttoptr i64 [[X16_3]] to fp128*
; CHECK-NEXT: store fp128 [[Q18_2]], fp128* [[X16_4]], align 1
; CHECK-NEXT: [[X16_5:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X16_5]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = add i64 16, [[OFFSET_0]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[OFFSET_1]], metadata !"X16")
stp	q17, q18, [x16], #32

;; STPQpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[Q17_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q17")
; CHECK-NEXT: [[Q17_1:%.+]] = bitcast <16 x i8> [[Q17_0]] to i128
; CHECK-NEXT: [[Q17_2:%.+]] = bitcast i128 [[Q17_1]] to fp128
; CHECK-NEXT: [[DST_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_1:%.+]] = add i64 [[DST_0]], [[INDEX_0]]
; CHECK-NEXT: [[DST_2:%.+]] = inttoptr i64 [[DST_1]] to fp128*
; CHECK-NEXT: store fp128 [[Q17_2]], fp128* [[DST_2]], align 1
; CHECK-NEXT: [[Q18_0:%.+]] = call <16 x i8> @llvm.dc.getreg.v16i8(metadata !"Q18")
; CHECK-NEXT: [[Q18_1:%.+]] = bitcast <16 x i8> [[Q18_0]] to i128
; CHECK-NEXT: [[Q18_2:%.+]] = bitcast i128 [[Q18_1]] to fp128
; CHECK-NEXT: [[DST_3:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_4:%.+]] = add i64 [[DST_3]], [[INDEX_1]]
; CHECK-NEXT: [[DST_5:%.+]] = add i64 16, [[DST_4]]
; CHECK-NEXT: [[DST_6:%.+]] = inttoptr i64 [[DST_5]] to fp128*
; CHECK-NEXT: store fp128 [[Q18_2]], fp128* [[DST_6]], align 1
; CHECK-NEXT: [[WBACK_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_2:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[WBACK_1:%.+]] = add i64 [[WBACK_0]], [[INDEX_2]]
; CHECK-NEXT: [[WBACK_2:%.+]] = add i64 16, [[WBACK_1]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[WBACK_2]], metadata !"X16")
stp	q17, q18, [x16, #32]!

;; STPSi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[S16_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S16")
; CHECK-NEXT: [[S16_1:%.+]] = bitcast float [[S16_0]] to i32
; CHECK-NEXT: [[S16_2:%.+]] = bitcast i32 [[S16_1]] to float
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X18_0]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = inttoptr i64 [[OFFSET_0]] to float*
; CHECK-NEXT: store float [[S16_2]], float* [[OFFSET_1]], align 1
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[S17_1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[S17_2:%.+]] = bitcast i32 [[S17_1]] to float
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_2:%.+]] = add i64 [[X18_1]], [[INDEX_1]]
; CHECK-NEXT: [[OFFSET_3:%.+]] = add i64 4, [[OFFSET_2]]
; CHECK-NEXT: [[OFFSET_4:%.+]] = inttoptr i64 [[OFFSET_3]] to float*
; CHECK-NEXT: store float [[S17_2]], float* [[OFFSET_4]], align 1
stp		s16, s17, [x18, #16]

;; STPSpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[S17_1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[S17_2:%.+]] = bitcast i32 [[S17_1]] to float
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_1:%.+]] = inttoptr i64 [[X16_0]] to float*
; CHECK-NEXT: store float [[S17_2]], float* [[X16_1]], align 1
; CHECK-NEXT: [[S18_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S18")
; CHECK-NEXT: [[S18_1:%.+]] = bitcast float [[S18_0]] to i32
; CHECK-NEXT: [[S18_2:%.+]] = bitcast i32 [[S18_1]] to float
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_3:%.+]] = add i64 4, [[X16_2]]
; CHECK-NEXT: [[X16_4:%.+]] = inttoptr i64 [[X16_3]] to float*
; CHECK-NEXT: store float [[S18_2]], float* [[X16_4]], align 1
; CHECK-NEXT: [[X16_5:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X16_5]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = add i64 4, [[OFFSET_0]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[OFFSET_1]], metadata !"X16")
stp	s17, s18, [x16], #16

;; STPSpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[S17_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S17")
; CHECK-NEXT: [[S17_1:%.+]] = bitcast float [[S17_0]] to i32
; CHECK-NEXT: [[S17_2:%.+]] = bitcast i32 [[S17_1]] to float
; CHECK-NEXT: [[DST_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_1:%.+]] = add i64 [[DST_0]], [[INDEX_0]]
; CHECK-NEXT: [[DST_2:%.+]] = inttoptr i64 [[DST_1]] to float*
; CHECK-NEXT: store float [[S17_2]], float* [[DST_2]], align 1
; CHECK-NEXT: [[S18_0:%.+]] = call float @llvm.dc.getreg.f32(metadata !"S18")
; CHECK-NEXT: [[S18_1:%.+]] = bitcast float [[S18_0]] to i32
; CHECK-NEXT: [[S18_2:%.+]] = bitcast i32 [[S18_1]] to float
; CHECK-NEXT: [[DST_3:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_4:%.+]] = add i64 [[DST_3]], [[INDEX_1]]
; CHECK-NEXT: [[DST_5:%.+]] = add i64 4, [[DST_4]]
; CHECK-NEXT: [[DST_6:%.+]] = inttoptr i64 [[DST_5]] to float*
; CHECK-NEXT: store float [[S18_2]], float* [[DST_6]], align 1
; CHECK-NEXT: [[WBACK_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_2:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[WBACK_1:%.+]] = add i64 [[WBACK_0]], [[INDEX_2]]
; CHECK-NEXT: [[WBACK_2:%.+]] = add i64 4, [[WBACK_1]]
stp	s17, s18, [x16, #16]!

;; STPWi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[W16_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W16")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X18_0]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = inttoptr i64 [[OFFSET_0]] to i32*
; CHECK-NEXT: store i32 [[W16_0]], i32* [[OFFSET_1]], align 1
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_2:%.+]] = add i64 [[X18_1]], [[INDEX_1]]
; CHECK-NEXT: [[OFFSET_3:%.+]] = add i64 4, [[OFFSET_2]]
; CHECK-NEXT: [[OFFSET_4:%.+]] = inttoptr i64 [[OFFSET_3]] to i32*
; CHECK-NEXT: store i32 [[W17_0]], i32* [[OFFSET_4]], align 1
stp		w16, w17, [x18, #16]

;; STPWpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_1:%.+]] = inttoptr i64 [[X16_0]] to i32*
; CHECK-NEXT: store i32 [[W17_0]], i32* [[X16_1]], align 1
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_3:%.+]] = add i64 4, [[X16_2]]
; CHECK-NEXT: [[X16_4:%.+]] = inttoptr i64 [[X16_3]] to i32*
; CHECK-NEXT: store i32 [[W18_0]], i32* [[X16_4]], align 1
; CHECK-NEXT: [[X16_5:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X16_5]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = add i64 4, [[OFFSET_0]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[OFFSET_1]], metadata !"X16")
stp	w17, w18, [x16], #16

;; STPWpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[DST_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_1:%.+]] = add i64 [[DST_0]], [[INDEX_0]]
; CHECK-NEXT: [[DST_2:%.+]] = inttoptr i64 [[DST_1]] to i32*
; CHECK-NEXT: store i32 [[W17_0]], i32* [[DST_2]], align 1
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[DST_3:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_4:%.+]] = add i64 [[DST_3]], [[INDEX_1]]
; CHECK-NEXT: [[DST_5:%.+]] = add i64 4, [[DST_4]]
; CHECK-NEXT: [[DST_6:%.+]] = inttoptr i64 [[DST_5]] to i32*
; CHECK-NEXT: store i32 [[W18_0]], i32* [[DST_6]], align 1
; CHECK-NEXT: [[WBACK_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_2:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[WBACK_1:%.+]] = add i64 [[WBACK_0]], [[INDEX_2]]
; CHECK-NEXT: [[WBACK_2:%.+]] = add i64 4, [[WBACK_1]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[WBACK_2]], metadata !"X16")
stp	w17, w18, [x16, #16]!

;; STPXi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X18_0]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = inttoptr i64 [[OFFSET_0]] to i64*
; CHECK-NEXT: store i64 [[X16_0]], i64* [[OFFSET_1]], align 1
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_2:%.+]] = add i64 [[X18_1]], [[INDEX_1]]
; CHECK-NEXT: [[OFFSET_3:%.+]] = add i64 8, [[OFFSET_2]]
; CHECK-NEXT: [[OFFSET_4:%.+]] = inttoptr i64 [[OFFSET_3]] to i64*
; CHECK-NEXT: store i64 [[X17_0]], i64* [[OFFSET_4]], align 1
stp		x16, x17, [x18, #16]

;; STPXpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_1:%.+]] = inttoptr i64 [[X16_0]] to i64*
; CHECK-NEXT: store i64 [[X17_0]], i64* [[X16_1]], align 1
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_3:%.+]] = add i64 8, [[X16_2]]
; CHECK-NEXT: [[X16_4:%.+]] = inttoptr i64 [[X16_3]] to i64*
; CHECK-NEXT: store i64 [[X18_0]], i64* [[X16_4]], align 1
; CHECK-NEXT: [[X16_5:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[OFFSET_0:%.+]] = add i64 [[X16_5]], [[INDEX_0]]
; CHECK-NEXT: [[OFFSET_1:%.+]] = add i64 8, [[OFFSET_0]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[OFFSET_1]], metadata !"X16")
stp	x17, x18, [x16], #16

;; STPXpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[DST_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_0:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_1:%.+]] = add i64 [[DST_0]], [[INDEX_0]]
; CHECK-NEXT: [[DST_2:%.+]] = inttoptr i64 [[DST_1]] to i64*
; CHECK-NEXT: store i64 [[X17_0]], i64* [[DST_2]], align 1
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[DST_3:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_1:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[DST_4:%.+]] = add i64 [[DST_3]], [[INDEX_1]]
; CHECK-NEXT: [[DST_5:%.+]] = add i64 8, [[DST_4]]
; CHECK-NEXT: [[DST_6:%.+]] = inttoptr i64 [[DST_5]] to i64*
; CHECK-NEXT: store i64 [[X18_0]], i64* [[DST_6]], align 1
; CHECK-NEXT: [[WBACK_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[INDEX_2:%.+]] = sext i32 {{.+}} to i64
; CHECK-NEXT: [[WBACK_1:%.+]] = add i64 [[WBACK_0]], [[INDEX_2]]
; CHECK-NEXT: [[WBACK_2:%.+]] = add i64 8, [[WBACK_1]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[WBACK_2]], metadata !"X16")
stp	x17, x18, [x16, #16]!

ret
