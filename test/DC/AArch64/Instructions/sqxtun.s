; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; SQXTUNv1i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqxtun	h16, s17

;; SQXTUNv1i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqxtun	s16, d17

;; SQXTUNv1i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqxtun	b16, h17

;; SQXTUNv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqxtun	v16.2s, v17.2d

;; SQXTUNv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqxtun	v16.4h, v17.4s

;; SQXTUNv8i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqxtun	v16.8b, v17.8h

ret
