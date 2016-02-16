; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

; XFAIL: *

;; URSRAd
ursra	d16, d18, #2
;; URSRAv16i8_shift
ursra	v16.16b, v18.16b, #2
;; URSRAv2i32_shift
ursra	v16.2s, v18.2s, #2
;; URSRAv2i64_shift
ursra	v16.2d, v18.2d, #2
;; URSRAv4i16_shift
ursra	v16.4h, v18.4h, #2
;; URSRAv4i32_shift
ursra	v16.4s, v18.4s, #2
;; URSRAv8i16_shift
ursra	v16.8h, v18.8h, #2
;; URSRAv8i8_shift
ursra	v16.8b, v18.8b, #2
ret
