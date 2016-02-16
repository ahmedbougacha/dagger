; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

; XFAIL: *

;; SSHRd
sshr	d16, d17, #2
;; SSHRv16i8_shift
sshr	v16.16b, v17.16b, #2
;; SSHRv2i32_shift
sshr	v16.2s, v17.2s, #2
;; SSHRv2i64_shift
sshr	v16.2d, v17.2d, #2
;; SSHRv4i16_shift
sshr	v16.4h, v17.4h, #2
;; SSHRv4i32_shift
sshr	v16.4s, v17.4s, #2
;; SSHRv8i16_shift
sshr	v16.8h, v17.8h, #2
;; SSHRv8i8_shift
sshr	v16.8b, v17.8b, #2
ret
