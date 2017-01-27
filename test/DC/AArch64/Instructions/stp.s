; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; STPDi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp		d16, d17, [x18]

;; STPDpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	d17, d18, [x16], #0

;; STPDpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	d17, d18, [x16, #0]!

;; STPQi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp		q16, q17, [x18]

;; STPQpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	q17, q18, [x16], #0

;; STPQpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	q17, q18, [x16, #0]!

;; STPSi
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp		s16, s17, [x18]

;; STPSpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	s17, s18, [x16], #0

;; STPSpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	s17, s18, [x16, #0]!

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
stp		w16, w17, [x18, 16]

;; STPWpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	w17, w18, [x16], #0

;; STPWpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	w17, w18, [x16, #0]!

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
stp		x16, x17, [x18, 16]

;; STPXpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	x17, x18, [x16], #0

;; STPXpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
stp	x17, x18, [x16, #0]!

ret
