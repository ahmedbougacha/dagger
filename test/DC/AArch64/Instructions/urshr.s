; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

; XFAIL: *

;; URSHRd
urshr	d16, d17, #2
;; URSHRv16i8_shift
urshr	v16.16b, v17.16b, #2
;; URSHRv2i32_shift
urshr	v16.2s, v17.2s, #2
;; URSHRv2i64_shift
urshr	v16.2d, v17.2d, #2
;; URSHRv4i16_shift
urshr	v16.4h, v17.4h, #2
;; URSHRv4i32_shift
urshr	v16.4s, v17.4s, #2
;; URSHRv8i16_shift
urshr	v16.8h, v17.8h, #2
;; URSHRv8i8_shift
urshr	v16.8b, v17.8b, #2
ret
