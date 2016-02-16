; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; SQDMLSLi16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl	s16, h18, h19

;; SQDMLSLi32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl	d16, s18, s19

;; SQDMLSLv1i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl	s16, h18, v11.h[0]

;; SQDMLSLv1i64_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl	d16, s18, v19.s[0]

;; SQDMLSLv2i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl	v16.2d, v18.2s, v19.s[0]

;; SQDMLSLv2i32_v2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl	v16.2d, v18.2s, v19.2s

;; SQDMLSLv4i16_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl	v16.4s, v18.4h, v11.h[0]

;; SQDMLSLv4i16_v4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl	v16.4s, v18.4h, v19.4h

ret
