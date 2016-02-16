; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; MOVID
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
movi	d16, #0000000000000000

;; MOVIv16b_ns
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
movi	v16.16b, #0

;; MOVIv2d_ns
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
movi	v16.2d, #0000000000000000

;; MOVIv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
movi	v16.2s, #0

;; MOVIv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
movi	v16.4h, #0

;; MOVIv4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
movi	v16.4s, #0

;; MOVIv8b_ns
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
movi	v16.8b, #0

;; MOVIv8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
movi	v16.8h, #0

ret
