; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

; XFAIL: *

;; SRSHRd
srshr	d16, d17, #2
;; SRSHRv16i8_shift
srshr	v16.16b, v17.16b, #2
;; SRSHRv2i32_shift
srshr	v16.2s, v17.2s, #2
;; SRSHRv2i64_shift
srshr	v16.2d, v17.2d, #2
;; SRSHRv4i16_shift
srshr	v16.4h, v17.4h, #2
;; SRSHRv4i32_shift
srshr	v16.4s, v17.4s, #2
;; SRSHRv8i16_shift
srshr	v16.8h, v17.8h, #2
;; SRSHRv8i8_shift
srshr	v16.8b, v17.8b, #2
ret
