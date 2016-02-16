; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; TBXv16i8Four
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbx	v16.16b, { v18.16b, v19.16b, v20.16b, v21.16b }, v19.16b

;; TBXv16i8One
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbx	v16.16b, { v18.16b }, v19.16b

;; TBXv16i8Three
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbx	v16.16b, { v18.16b, v19.16b, v20.16b }, v19.16b

;; TBXv16i8Two
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbx	v16.16b, { v18.16b, v19.16b }, v19.16b

;; TBXv8i8Four
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbx	v16.8b, { v18.16b, v19.16b, v20.16b, v21.16b }, v19.8b

;; TBXv8i8One
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbx	v16.8b, { v18.16b }, v19.8b

;; TBXv8i8Three
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbx	v16.8b, { v18.16b, v19.16b, v20.16b }, v19.8b

;; TBXv8i8Two
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbx	v16.8b, { v18.16b, v19.16b }, v19.8b

ret
