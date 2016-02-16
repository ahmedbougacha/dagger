; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; UADDLPv16i8_v8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uaddlp	v16.8h, v17.16b

;; UADDLPv2i32_v1i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uaddlp	v16.1d, v17.2s

;; UADDLPv4i16_v2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uaddlp	v16.2s, v17.4h

;; UADDLPv4i32_v2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uaddlp	v16.2d, v17.4s

;; UADDLPv8i16_v4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uaddlp	v16.4s, v17.8h

;; UADDLPv8i8_v4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uaddlp	v16.4h, v17.8b

ret
