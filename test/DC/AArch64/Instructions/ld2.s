; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; LD2Twov16b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.16b, v17.16b }, [x17]

;; LD2Twov16b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.16b, v18.16b }, [x16], x19

;; LD2Twov2d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.2d, v17.2d }, [x17]

;; LD2Twov2d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.2d, v18.2d }, [x16], x19

;; LD2Twov2s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.2s, v17.2s }, [x17]

;; LD2Twov2s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.2s, v18.2s }, [x16], x19

;; LD2Twov4h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.4h, v17.4h }, [x17]

;; LD2Twov4h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.4h, v18.4h }, [x16], x19

;; LD2Twov4s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.4s, v17.4s }, [x17]

;; LD2Twov4s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.4s, v18.4s }, [x16], x19

;; LD2Twov8b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.8b, v17.8b }, [x17]

;; LD2Twov8b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.8b, v18.8b }, [x16], x19

;; LD2Twov8h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.8h, v17.8h }, [x17]

;; LD2Twov8h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.8h, v18.8h }, [x16], x19

;; LD2i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.h, v17.h }[0], [x19]

;; LD2i16_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.h, v18.h }[0], [x16], x21

;; LD2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.s, v17.s }[0], [x19]

;; LD2i32_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.s, v18.s }[0], [x16], x21

;; LD2i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.d, v17.d }[0], [x19]

;; LD2i64_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.d, v18.d }[0], [x16], x21

;; LD2i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v16.b, v17.b }[0], [x19]

;; LD2i8_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld2	{ v17.b, v18.b }[0], [x16], x21

ret
