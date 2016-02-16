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
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	d16, [x17, w18, uxtw]

;; LDRDroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		d16, [x17, x18]

;; LDRDui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
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
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	h16, [x17, w18, uxtw]

;; LDRHroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		h16, [x17, x18]

;; LDRHui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
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
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
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
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	s16, [x17, w18, uxtw]

;; LDRSroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		s16, [x17, x18]

;; LDRSui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
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
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	w16, [x17, w18, uxtw]

;; LDRWroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		w16, [x17, x18]

;; LDRWui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
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
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr	x16, [x17, w18, uxtw]

;; LDRXroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		x16, [x17, x18]

;; LDRXui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldr		x16, [x17]

ret
