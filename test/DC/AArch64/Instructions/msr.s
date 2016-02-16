; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; MSR
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
msr	S0_0_C0_C0_0, x17

ret
