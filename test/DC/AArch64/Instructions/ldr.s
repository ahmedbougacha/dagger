; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; LDRBpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	b17, [x16], #0

;; LDRBpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	b17, [x16, #0]!

;; LDRBroW
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	b16, [x17, w18, uxtw]

;; LDRBroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		b16, [x17, x18]

;; LDRBui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		b16, [x17]

;; LDRDl
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	d16, #0

;; LDRDpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	d17, [x16], #0

;; LDRDpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	d17, [x16, #0]!

;; LDRDroW
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[V1:%.+]] = zext i32 [[W18_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X17_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to double*
; CHECK-NEXT: [[V4:%.+]] = load double, double* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast double [[V4]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V5]], metadata !"D16")
ldr	d16, [x17, w18, uxtw]

;; LDRDroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], [[X18_0]]
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to double*
; CHECK-NEXT: [[V3:%.+]] = load double, double* [[V2]], align 1
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
ldr		d16, [x17, x18]

;; LDRDui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], 0
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to double*
; CHECK-NEXT: [[V3:%.+]] = load double, double* [[V2]], align 1
; CHECK-NEXT: [[V4:%.+]] = bitcast double [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"D16")
ldr		d16, [x17]

;; LDRHpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	h17, [x16], #0

;; LDRHpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	h17, [x16, #0]!

;; LDRHroW
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[V1:%.+]] = zext i32 [[W18_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X17_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to half*
; CHECK-NEXT: [[V4:%.+]] = load half, half* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast half [[V4]] to i16
; CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V5]], metadata !"H16")
ldr	h16, [x17, w18, uxtw]

;; LDRHroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], [[X18_0]]
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to half*
; CHECK-NEXT: [[V3:%.+]] = load half, half* [[V2]], align 1
; CHECK-NEXT: [[V4:%.+]] = bitcast half [[V3]] to i16
; CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"H16")
ldr		h16, [x17, x18]

;; LDRHui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], 0
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to half*
; CHECK-NEXT: [[V3:%.+]] = load half, half* [[V2]], align 1
; CHECK-NEXT: [[V4:%.+]] = bitcast half [[V3]] to i16
; CHECK-NEXT: call void @llvm.dc.setreg.i16(i16 [[V4]], metadata !"H16")
ldr		h16, [x17]

;; LDRQl
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	q16, #0

;; LDRQpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	q17, [x16], #0

;; LDRQpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	q17, [x16, #0]!

;; LDRQroW
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	q16, [x17, w18, uxtw]

;; LDRQroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		q16, [x17, x18]

;; LDRQui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], 0
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to fp128*
; CHECK-NEXT: [[V3:%.+]] = load fp128, fp128* [[V2]], align 1
; CHECK-NEXT: [[V4:%.+]] = bitcast fp128 [[V3]] to i128
; CHECK-NEXT: call void @llvm.dc.setreg.i128(i128 [[V4]], metadata !"Q16")
ldr		q16, [x17]

;; LDRSl
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	s16, #0

;; LDRSpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	s17, [x16], #0

;; LDRSpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	s17, [x16, #0]!

;; LDRSroW
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[V1:%.+]] = zext i32 [[W18_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X17_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to float*
; CHECK-NEXT: [[V4:%.+]] = load float, float* [[V3]], align 1
; CHECK-NEXT: [[V5:%.+]] = bitcast float [[V4]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V5]], metadata !"S16")
ldr	s16, [x17, w18, uxtw]

;; LDRSroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], [[X18_0]]
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to float*
; CHECK-NEXT: [[V3:%.+]] = load float, float* [[V2]], align 1
; CHECK-NEXT: [[V4:%.+]] = bitcast float [[V3]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"S16")
ldr		s16, [x17, x18]

;; LDRSui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], 0
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to float*
; CHECK-NEXT: [[V3:%.+]] = load float, float* [[V2]], align 1
; CHECK-NEXT: [[V4:%.+]] = bitcast float [[V3]] to i32
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"S16")
ldr		s16, [x17]

;; LDRWl
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	w16, #0

;; LDRWpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	w17, [x16], #0

;; LDRWpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	w17, [x16, #0]!

;; LDRWroW
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[V1:%.+]] = zext i32 [[W18_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X17_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i32*
; CHECK-NEXT: [[V4:%.+]] = load i32, i32* [[V3]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V4]], metadata !"W16")
ldr	w16, [x17, w18, uxtw]

;; LDRWroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], [[X18_0]]
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i32*
; CHECK-NEXT: [[V3:%.+]] = load i32, i32* [[V2]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"W16")
ldr		w16, [x17, x18]

;; LDRWui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], 0
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i32*
; CHECK-NEXT: [[V3:%.+]] = load i32, i32* [[V2]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i32(i32 [[V3]], metadata !"W16")
ldr		w16, [x17]

;; LDRXl
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	x16, #0

;; LDRXpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	x17, [x16], #0

;; LDRXpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	x17, [x16, #0]!

;; LDRXroW
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[V1:%.+]] = zext i32 [[W18_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X17_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i64*
; CHECK-NEXT: [[V4:%.+]] = load i64, i64* [[V3]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"X16")
ldr	x16, [x17, w18, uxtw]

;; LDRXroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], [[X18_0]]
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i64*
; CHECK-NEXT: [[V3:%.+]] = load i64, i64* [[V2]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"X16")
ldr		x16, [x17, x18]

;; LDRXui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], 0
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i64*
; CHECK-NEXT: [[V3:%.+]] = load i64, i64* [[V2]], align 1
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V3]], metadata !"X16")
ldr		x16, [x17]

ret
