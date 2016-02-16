; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; SBCSWr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[W17_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W17")
; CHECK-NEXT: [[W18_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"W18")
; CHECK-NEXT: [[NZCV_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"NZCV")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sbcs	w16, w17, w18

;; SBCSXr
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X17_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X17")
; CHECK-NEXT: [[X18_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X18")
; CHECK-NEXT: [[NZCV_0:%.+]] = call i32 @llvm.dc.getreg.i32(metadata !"NZCV")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sbcs	x16, x17, x18

ret
