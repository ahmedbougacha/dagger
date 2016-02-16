; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; LD2Rv16b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v16.16b, v17.16b }, [x17]

;; LD2Rv16b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v17.16b, v18.16b }, [x16], x19

;; LD2Rv1d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v16.1d, v17.1d }, [x17]

;; LD2Rv1d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v17.1d, v18.1d }, [x16], x19

;; LD2Rv2d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v16.2d, v17.2d }, [x17]

;; LD2Rv2d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v17.2d, v18.2d }, [x16], x19

;; LD2Rv2s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v16.2s, v17.2s }, [x17]

;; LD2Rv2s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v17.2s, v18.2s }, [x16], x19

;; LD2Rv4h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v16.4h, v17.4h }, [x17]

;; LD2Rv4h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v17.4h, v18.4h }, [x16], x19

;; LD2Rv4s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v16.4s, v17.4s }, [x17]

;; LD2Rv4s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v17.4s, v18.4s }, [x16], x19

;; LD2Rv8b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v16.8b, v17.8b }, [x17]

;; LD2Rv8b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v17.8b, v18.8b }, [x16], x19

;; LD2Rv8h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v16.8h, v17.8h }, [x17]

;; LD2Rv8h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2r	{ v17.8h, v18.8h }, [x16], x19

ret
