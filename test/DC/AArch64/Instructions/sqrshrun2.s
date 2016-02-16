; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; SQRSHRUNv16i8_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrshrun2	v16.16b, v18.8h, #2

;; SQRSHRUNv4i32_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrshrun2	v16.4s, v18.2d, #2

;; SQRSHRUNv8i16_shift
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
sqrshrun2	v16.8h, v18.4s, #2

ret
