; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

; XFAIL: *

;; SHRNv2i32_shift
shrn	v16.2s, v17.2d, #2
;; SHRNv4i16_shift
shrn	v16.4h, v17.4s, #2
;; SHRNv8i8_shift
shrn	v16.8b, v17.8h, #2
ret
