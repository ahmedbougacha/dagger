; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; FCVTNv4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fcvtn2	v16.4s, v18.2d

;; FCVTNv8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
fcvtn2	v16.8h, v18.4s

ret
