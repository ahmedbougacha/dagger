; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; TBLv16i8Four
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbl	v16.16b, { v17.16b, v18.16b, v19.16b, v20.16b }, v18.16b

;; TBLv16i8One
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbl	v16.16b, { v17.16b }, v18.16b

;; TBLv16i8Three
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbl	v16.16b, { v17.16b, v18.16b, v19.16b }, v18.16b

;; TBLv16i8Two
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbl	v16.16b, { v17.16b, v18.16b }, v18.16b

;; TBLv8i8Four
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbl	v16.8b, { v17.16b, v18.16b, v19.16b, v20.16b }, v18.8b

;; TBLv8i8One
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbl	v16.8b, { v17.16b }, v18.8b

;; TBLv8i8Three
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbl	v16.8b, { v17.16b, v18.16b, v19.16b }, v18.8b

;; TBLv8i8Two
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
tbl	v16.8b, { v17.16b, v18.16b }, v18.8b

ret
