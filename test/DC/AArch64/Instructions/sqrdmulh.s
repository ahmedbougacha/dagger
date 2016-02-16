; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; SQRDMULHv1i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	h16, h17, h18

;; SQRDMULHv1i16_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	h16, h17, v10.h[0]

;; SQRDMULHv1i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	s16, s17, s18

;; SQRDMULHv1i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	s16, s17, v18.s[0]

;; SQRDMULHv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	v16.2s, v17.2s, v18.2s

;; SQRDMULHv2i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	v16.2s, v17.2s, v18.s[0]

;; SQRDMULHv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	v16.4h, v17.4h, v18.4h

;; SQRDMULHv4i16_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	v16.4h, v17.4h, v10.h[0]

;; SQRDMULHv4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	v16.4s, v17.4s, v18.4s

;; SQRDMULHv4i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	v16.4s, v17.4s, v18.s[0]

;; SQRDMULHv8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	v16.8h, v17.8h, v18.8h

;; SQRDMULHv8i16_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrdmulh	v16.8h, v17.8h, v10.h[0]

ret
