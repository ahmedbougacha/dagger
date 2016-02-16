; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; UMLALv16i8_v8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
umlal2	v16.8h, v18.16b, v19.16b

;; UMLALv4i32_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
umlal2	v16.2d, v18.4s, v19.s[0]

;; UMLALv4i32_v2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
umlal2	v16.2d, v18.4s, v19.4s

;; UMLALv8i16_indexed
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
umlal2	v16.4s, v18.8h, v11.h[0]

;; UMLALv8i16_v4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
umlal2	v16.4s, v18.8h, v19.8h

ret
