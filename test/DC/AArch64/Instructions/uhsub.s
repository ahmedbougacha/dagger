; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; UHSUBv16i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uhsub	v16.16b, v17.16b, v18.16b

;; UHSUBv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uhsub	v16.2s, v17.2s, v18.2s

;; UHSUBv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uhsub	v16.4h, v17.4h, v18.4h

;; UHSUBv4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uhsub	v16.4s, v17.4s, v18.4s

;; UHSUBv8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uhsub	v16.8h, v17.8h, v18.8h

;; UHSUBv8i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
uhsub	v16.8b, v17.8b, v18.8b

ret
