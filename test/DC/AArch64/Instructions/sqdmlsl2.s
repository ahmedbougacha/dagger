; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; SQDMLSLv4i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl2	v16.2d, v18.4s, v19.s[0]

;; SQDMLSLv4i32_v2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl2	v16.2d, v18.4s, v19.4s

;; SQDMLSLv8i16_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl2	v16.4s, v18.8h, v11.h[0]

;; SQDMLSLv8i16_v4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqdmlsl2	v16.4s, v18.8h, v19.8h

ret
