; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; LD4Fourv16b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.16b, v17.16b, v18.16b, v19.16b }, [x17]

;; LD4Fourv16b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.16b, v18.16b, v19.16b, v20.16b }, [x16], x19

;; LD4Fourv2d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.2d, v17.2d, v18.2d, v19.2d }, [x17]

;; LD4Fourv2d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.2d, v18.2d, v19.2d, v20.2d }, [x16], x19

;; LD4Fourv2s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.2s, v17.2s, v18.2s, v19.2s }, [x17]

;; LD4Fourv2s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.2s, v18.2s, v19.2s, v20.2s }, [x16], x19

;; LD4Fourv4h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.4h, v17.4h, v18.4h, v19.4h }, [x17]

;; LD4Fourv4h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.4h, v18.4h, v19.4h, v20.4h }, [x16], x19

;; LD4Fourv4s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.4s, v17.4s, v18.4s, v19.4s }, [x17]

;; LD4Fourv4s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.4s, v18.4s, v19.4s, v20.4s }, [x16], x19

;; LD4Fourv8b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.8b, v17.8b, v18.8b, v19.8b }, [x17]

;; LD4Fourv8b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.8b, v18.8b, v19.8b, v20.8b }, [x16], x19

;; LD4Fourv8h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.8h, v17.8h, v18.8h, v19.8h }, [x17]

;; LD4Fourv8h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.8h, v18.8h, v19.8h, v20.8h }, [x16], x19

;; LD4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.h, v17.h, v18.h, v19.h }[0], [x19]

;; LD4i16_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.h, v18.h, v19.h, v20.h }[0], [x16], x21

;; LD4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.s, v17.s, v18.s, v19.s }[0], [x19]

;; LD4i32_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.s, v18.s, v19.s, v20.s }[0], [x16], x21

;; LD4i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.d, v17.d, v18.d, v19.d }[0], [x19]

;; LD4i64_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.d, v18.d, v19.d, v20.d }[0], [x16], x21

;; LD4i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v16.b, v17.b, v18.b, v19.b }[0], [x19]

;; LD4i8_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
ld4	{ v17.b, v18.b, v19.b, v20.b }[0], [x16], x21

ret
