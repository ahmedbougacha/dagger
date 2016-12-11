; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; LDRSWl
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldrsw	x16, #0

;; LDRSWpost
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldrsw	x17, [x16], #0

;; LDRSWpre
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ldrsw	x17, [x16, #0]!

;; LDRSWroW
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[V1:%.+]] = zext i32 [[W18_0]] to i64
; CHECK-NEXT: [[V2:%.+]] = add i64 [[X17_0]], [[V1]]
; CHECK-NEXT: [[V3:%.+]] = inttoptr i64 [[V2]] to i32*
; CHECK-NEXT: [[V4:%.+]] = load i32, i32* [[V3]]
; CHECK-NEXT: [[V5:%.+]] = sext i32 [[V4]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V5]], metadata !"X16")
ldrsw	x16, [x17, w18, uxtw]

;; LDRSWroX
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], [[X18_0]]
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i32*
; CHECK-NEXT: [[V3:%.+]] = load i32, i32* [[V2]]
; CHECK-NEXT: [[V4:%.+]] = sext i32 [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"X16")
ldrsw		x16, [x17, x18]

;; LDRSWui
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[V1:%.+]] = add i64 [[X17_0]], 0
; CHECK-NEXT: [[V2:%.+]] = inttoptr i64 [[V1]] to i32*
; CHECK-NEXT: [[V3:%.+]] = load i32, i32* [[V2]]
; CHECK-NEXT: [[V4:%.+]] = sext i32 [[V3]] to i64
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"X16")
ldrsw		x16, [x17]

ret
