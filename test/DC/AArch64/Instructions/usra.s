; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

; XFAIL: *

;; USRAd
usra	d16, d18, #2
;; USRAv16i8_shift
usra	v16.16b, v18.16b, #2
;; USRAv2i32_shift
usra	v16.2s, v18.2s, #2
;; USRAv2i64_shift
usra	v16.2d, v18.2d, #2
;; USRAv4i16_shift
usra	v16.4h, v18.4h, #2
;; USRAv4i32_shift
usra	v16.4s, v18.4s, #2
;; USRAv8i16_shift
usra	v16.8h, v18.8h, #2
;; USRAv8i8_shift
usra	v16.8b, v18.8b, #2
ret
