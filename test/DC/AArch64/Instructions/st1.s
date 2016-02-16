; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; ST1Fourv16b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.16b, v17.16b, v18.16b, v19.16b }, [x17]

;; ST1Fourv16b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.16b, v18.16b, v19.16b, v20.16b }, [x16], x19

;; ST1Fourv1d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.1d, v17.1d, v18.1d, v19.1d }, [x17]

;; ST1Fourv1d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.1d, v18.1d, v19.1d, v20.1d }, [x16], x19

;; ST1Fourv2d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.2d, v17.2d, v18.2d, v19.2d }, [x17]

;; ST1Fourv2d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.2d, v18.2d, v19.2d, v20.2d }, [x16], x19

;; ST1Fourv2s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.2s, v17.2s, v18.2s, v19.2s }, [x17]

;; ST1Fourv2s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.2s, v18.2s, v19.2s, v20.2s }, [x16], x19

;; ST1Fourv4h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.4h, v17.4h, v18.4h, v19.4h }, [x17]

;; ST1Fourv4h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.4h, v18.4h, v19.4h, v20.4h }, [x16], x19

;; ST1Fourv4s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.4s, v17.4s, v18.4s, v19.4s }, [x17]

;; ST1Fourv4s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.4s, v18.4s, v19.4s, v20.4s }, [x16], x19

;; ST1Fourv8b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.8b, v17.8b, v18.8b, v19.8b }, [x17]

;; ST1Fourv8b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.8b, v18.8b, v19.8b, v20.8b }, [x16], x19

;; ST1Fourv8h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.8h, v17.8h, v18.8h, v19.8h }, [x17]

;; ST1Fourv8h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.8h, v18.8h, v19.8h, v20.8h }, [x16], x19

;; ST1Onev16b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.16b }, [x17]

;; ST1Onev16b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.16b }, [x16], x19

;; ST1Onev1d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.1d }, [x17]

;; ST1Onev1d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.1d }, [x16], x19

;; ST1Onev2d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.2d }, [x17]

;; ST1Onev2d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.2d }, [x16], x19

;; ST1Onev2s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.2s }, [x17]

;; ST1Onev2s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.2s }, [x16], x19

;; ST1Onev4h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.4h }, [x17]

;; ST1Onev4h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.4h }, [x16], x19

;; ST1Onev4s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.4s }, [x17]

;; ST1Onev4s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.4s }, [x16], x19

;; ST1Onev8b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.8b }, [x17]

;; ST1Onev8b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.8b }, [x16], x19

;; ST1Onev8h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.8h }, [x17]

;; ST1Onev8h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.8h }, [x16], x19

;; ST1Threev16b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.16b, v17.16b, v18.16b }, [x17]

;; ST1Threev16b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.16b, v18.16b, v19.16b }, [x16], x19

;; ST1Threev1d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.1d, v17.1d, v18.1d }, [x17]

;; ST1Threev1d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.1d, v18.1d, v19.1d }, [x16], x19

;; ST1Threev2d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.2d, v17.2d, v18.2d }, [x17]

;; ST1Threev2d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.2d, v18.2d, v19.2d }, [x16], x19

;; ST1Threev2s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.2s, v17.2s, v18.2s }, [x17]

;; ST1Threev2s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.2s, v18.2s, v19.2s }, [x16], x19

;; ST1Threev4h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.4h, v17.4h, v18.4h }, [x17]

;; ST1Threev4h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.4h, v18.4h, v19.4h }, [x16], x19

;; ST1Threev4s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.4s, v17.4s, v18.4s }, [x17]

;; ST1Threev4s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.4s, v18.4s, v19.4s }, [x16], x19

;; ST1Threev8b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.8b, v17.8b, v18.8b }, [x17]

;; ST1Threev8b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.8b, v18.8b, v19.8b }, [x16], x19

;; ST1Threev8h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.8h, v17.8h, v18.8h }, [x17]

;; ST1Threev8h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.8h, v18.8h, v19.8h }, [x16], x19

;; ST1Twov16b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.16b, v17.16b }, [x17]

;; ST1Twov16b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.16b, v18.16b }, [x16], x19

;; ST1Twov1d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.1d, v17.1d }, [x17]

;; ST1Twov1d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.1d, v18.1d }, [x16], x19

;; ST1Twov2d
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.2d, v17.2d }, [x17]

;; ST1Twov2d_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.2d, v18.2d }, [x16], x19

;; ST1Twov2s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.2s, v17.2s }, [x17]

;; ST1Twov2s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.2s, v18.2s }, [x16], x19

;; ST1Twov4h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.4h, v17.4h }, [x17]

;; ST1Twov4h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.4h, v18.4h }, [x16], x19

;; ST1Twov4s
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.4s, v17.4s }, [x17]

;; ST1Twov4s_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.4s, v18.4s }, [x16], x19

;; ST1Twov8b
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.8b, v17.8b }, [x17]

;; ST1Twov8b_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.8b, v18.8b }, [x16], x19

;; ST1Twov8h
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.8h, v17.8h }, [x17]

;; ST1Twov8h_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.8h, v18.8h }, [x16], x19

;; ST1i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.h }[0], [x18]

;; ST1i16_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.h }[0], [x16], x20

;; ST1i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.s }[0], [x18]

;; ST1i32_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.s }[0], [x16], x20

;; ST1i64
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.d }[0], [x18]

;; ST1i64_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.d }[0], [x16], x20

;; ST1i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v16.b }[0], [x18]

;; ST1i8_POST
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: call void @llvm.trap()
; CHECK-NEXT: unreachable
st1	{ v17.b }[0], [x16], x20

ret
