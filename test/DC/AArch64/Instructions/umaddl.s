; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; UMADDLrrr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X19_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X19")
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[V1:%.+]] = zext i32 [[W17_0]] to i64
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[V2:%.+]] = zext i32 [[W18_0]] to i64
; CHECK-NEXT: [[V3:%.+]] = mul i64 [[V1]], [[V2]]
; CHECK-NEXT: [[V4:%.+]] = add i64 [[X19_0]], [[V3]]
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V4]], metadata !"X16")
umaddl	x16, w17, w18, x19

ret
