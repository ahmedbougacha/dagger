; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; LDPDi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X18_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to double*
; CHECK-NEXT: [[V4:%.+]] = load double, double* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast double [[V4]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V5]], metadata !"D16")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V6:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V7:%.+]] = add i64 [[X18_1]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = add i64 8, [[V7]]
; CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V8]] to double*
; CHECK-NEXT: [[V10:%.+]] = load double, double* [[V9]], align 1
; CHECK-NEXT: [[V11:%.+]] = bitcast double [[V10]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V11]], metadata !"D17")
ldp		d16, d17, [x18]

;; LDPDpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 [[X16_0]] to double*
; CHECK-NEXT: [[V2:%.+]] = load double, double* [[V1]], align 1
; CHECK-NEXT: [[V3:%.+]] = bitcast double [[V2]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"D17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V4:%.+]] = add i64 8, [[X16_1]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to double*
; CHECK-NEXT: [[V6:%.+]] = load double, double* [[V5]], align 1
; CHECK-NEXT: [[V7:%.+]] = bitcast double [[V6]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V7]], metadata !"D18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_2]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 8, [[V9]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"X16")
ldp	d17, d18, [x16], #0

;; LDPDpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X16_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to double*
; CHECK-NEXT: [[V4:%.+]] = load double, double* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast double [[V4]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V5]], metadata !"D17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V6:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V7:%.+]] = add i64 [[X16_1]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = add i64 8, [[V7]]
; CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V8]] to double*
; CHECK-NEXT: [[V10:%.+]] = load double, double* [[V9]], align 1
; CHECK-NEXT: [[V11:%.+]] = bitcast double [[V10]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V11]], metadata !"D18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V12:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V13:%.+]] = add i64 [[X16_2]], [[V12]]
; CHECK-NEXT: [[V14:%.+]] = add i64 8, [[V13]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V14]], metadata !"X16")
ldp	d17, d18, [x16, #0]!

;; LDPQi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X18_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to fp128*
; CHECK-NEXT: [[V4:%.+]] = load fp128, fp128* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast fp128 [[V4]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V5]], metadata !"Q16")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V6:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V7:%.+]] = add i64 [[X18_1]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = add i64 16, [[V7]]
; CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V8]] to fp128*
; CHECK-NEXT: [[V10:%.+]] = load fp128, fp128* [[V9]], align 1
; CHECK-NEXT: [[V11:%.+]] = bitcast fp128 [[V10]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V11]], metadata !"Q17")
ldp		q16, q17, [x18]

;; LDPQpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 [[X16_0]] to fp128*
; CHECK-NEXT: [[V2:%.+]] = load fp128, fp128* [[V1]], align 1
; CHECK-NEXT: [[V3:%.+]] = bitcast fp128 [[V2]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V3]], metadata !"Q17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V4:%.+]] = add i64 16, [[X16_1]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to fp128*
; CHECK-NEXT: [[V6:%.+]] = load fp128, fp128* [[V5]], align 1
; CHECK-NEXT: [[V7:%.+]] = bitcast fp128 [[V6]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V7]], metadata !"Q18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_2]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 16, [[V9]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"X16")
ldp	q17, q18, [x16], #0

;; LDPQpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X16_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to fp128*
; CHECK-NEXT: [[V4:%.+]] = load fp128, fp128* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast fp128 [[V4]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V5]], metadata !"Q17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V6:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V7:%.+]] = add i64 [[X16_1]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = add i64 16, [[V7]]
; CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V8]] to fp128*
; CHECK-NEXT: [[V10:%.+]] = load fp128, fp128* [[V9]], align 1
; CHECK-NEXT: [[V11:%.+]] = bitcast fp128 [[V10]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V11]], metadata !"Q18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V12:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V13:%.+]] = add i64 [[X16_2]], [[V12]]
; CHECK-NEXT: [[V14:%.+]] = add i64 16, [[V13]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V14]], metadata !"X16")
ldp	q17, q18, [x16, #0]!

;; LDPSi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X18_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to float*
; CHECK-NEXT: [[V4:%.+]] = load float, float* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast float [[V4]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V5]], metadata !"S16")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V6:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V7:%.+]] = add i64 [[X18_1]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = add i64 4, [[V7]]
; CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V8]] to float*
; CHECK-NEXT: [[V10:%.+]] = load float, float* [[V9]], align 1
; CHECK-NEXT: [[V11:%.+]] = bitcast float [[V10]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V11]], metadata !"S17")
ldp		s16, s17, [x18]

;; LDPSpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 [[X16_0]] to float*
; CHECK-NEXT: [[V2:%.+]] = load float, float* [[V1]], align 1
; CHECK-NEXT: [[V3:%.+]] = bitcast float [[V2]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"S17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V4:%.+]] = add i64 4, [[X16_1]]
; CHECK-NEXT: [[V5:%.+]] = inttoptr i64 [[V4]] to float*
; CHECK-NEXT: [[V6:%.+]] = load float, float* [[V5]], align 1
; CHECK-NEXT: [[V7:%.+]] = bitcast float [[V6]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V7]], metadata !"S18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V8:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V9:%.+]] = add i64 [[X16_2]], [[V8]]
; CHECK-NEXT: [[V10:%.+]] = add i64 4, [[V9]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V10]], metadata !"X16")
ldp	s17, s18, [x16], #0

;; LDPSpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X16_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to float*
; CHECK-NEXT: [[V4:%.+]] = load float, float* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast float [[V4]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V5]], metadata !"S17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V6:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V7:%.+]] = add i64 [[X16_1]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = add i64 4, [[V7]]
; CHECK-NEXT: [[V9:%.+]] = inttoptr i64 [[V8]] to float*
; CHECK-NEXT: [[V10:%.+]] = load float, float* [[V9]], align 1
; CHECK-NEXT: [[V11:%.+]] = bitcast float [[V10]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V11]], metadata !"S18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V12:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V13:%.+]] = add i64 [[X16_2]], [[V12]]
; CHECK-NEXT: [[V14:%.+]] = add i64 4, [[V13]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V14]], metadata !"X16")
ldp	s17, s18, [x16, #0]!

;; LDPWi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X18_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i32*
; CHECK-NEXT: [[V4:%.+]] = load i32, i32* [[V3]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"W16")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V5:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V6:%.+]] = add i64 [[X18_1]], [[V5]]
; CHECK-NEXT: [[V7:%.+]] = add i64 4, [[V6]]
; CHECK-NEXT: [[V8:%.+]] = inttoptr i64 [[V7]] to i32*
; CHECK-NEXT: [[V9:%.+]] = load i32, i32* [[V8]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"W17")
ldp		w16, w17, [x18]

;; LDPWpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 [[X16_0]] to i32*
; CHECK-NEXT: [[V2:%.+]] = load i32, i32* [[V1]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V2]], metadata !"W17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V3:%.+]] = add i64 4, [[X16_1]]
; CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i32*
; CHECK-NEXT: [[V5:%.+]] = load i32, i32* [[V4]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V5]], metadata !"W18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V6:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V7:%.+]] = add i64 [[X16_2]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = add i64 4, [[V7]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V8]], metadata !"X16")
ldp	w17, w18, [x16], #0

;; LDPWpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X16_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i32*
; CHECK-NEXT: [[V4:%.+]] = load i32, i32* [[V3]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"W17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V5:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V6:%.+]] = add i64 [[X16_1]], [[V5]]
; CHECK-NEXT: [[V7:%.+]] = add i64 4, [[V6]]
; CHECK-NEXT: [[V8:%.+]] = inttoptr i64 [[V7]] to i32*
; CHECK-NEXT: [[V9:%.+]] = load i32, i32* [[V8]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V9]], metadata !"W18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V10:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V11:%.+]] = add i64 [[X16_2]], [[V10]]
; CHECK-NEXT: [[V12:%.+]] = add i64 4, [[V11]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V12]], metadata !"X16")
ldp	w17, w18, [x16, #0]!

;; LDPXi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X18_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i64*
; CHECK-NEXT: [[V4:%.+]] = load i64, i64* [[V3]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"X16")
; CHECK-NEXT: [[X18_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V5:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V6:%.+]] = add i64 [[X18_1]], [[V5]]
; CHECK-NEXT: [[V7:%.+]] = add i64 8, [[V6]]
; CHECK-NEXT: [[V8:%.+]] = inttoptr i64 [[V7]] to i64*
; CHECK-NEXT: [[V9:%.+]] = load i64, i64* [[V8]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"X17")
ldp		x16, x17, [x18]

;; LDPXpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 [[X16_0]] to i64*
; CHECK-NEXT: [[V2:%.+]] = load i64, i64* [[V1]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V2]], metadata !"X17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V3:%.+]] = add i64 8, [[X16_1]]
; CHECK-NEXT: [[V4:%.+]] = inttoptr i64 [[V3]] to i64*
; CHECK-NEXT: [[V5:%.+]] = load i64, i64* [[V4]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V5]], metadata !"X18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V6:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V7:%.+]] = add i64 [[X16_2]], [[V6]]
; CHECK-NEXT: [[V8:%.+]] = add i64 8, [[V7]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V8]], metadata !"X16")
ldp	x17, x18, [x16], #0

;; LDPXpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X16_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i64*
; CHECK-NEXT: [[V4:%.+]] = load i64, i64* [[V3]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"X17")
; CHECK-NEXT: [[X16_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V5:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V6:%.+]] = add i64 [[X16_1]], [[V5]]
; CHECK-NEXT: [[V7:%.+]] = add i64 8, [[V6]]
; CHECK-NEXT: [[V8:%.+]] = inttoptr i64 [[V7]] to i64*
; CHECK-NEXT: [[V9:%.+]] = load i64, i64* [[V8]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V9]], metadata !"X18")
; CHECK-NEXT: [[X16_2:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V10:%.+]] = sext i32 0 to i64
; CHECK-NEXT: [[V11:%.+]] = add i64 [[X16_2]], [[V10]]
; CHECK-NEXT: [[V12:%.+]] = add i64 8, [[V11]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V12]], metadata !"X16")
ldp	x17, x18, [x16, #0]!

ret
