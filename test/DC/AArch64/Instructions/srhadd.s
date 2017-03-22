; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; SRHADDv16i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
srhadd	v16.16b, v17.16b, v18.16b

;; SRHADDv2i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
srhadd	v16.2s, v17.2s, v18.2s

;; SRHADDv4i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
srhadd	v16.4h, v17.4h, v18.4h

;; SRHADDv4i32
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
srhadd	v16.4s, v17.4s, v18.4s

;; SRHADDv8i16
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
srhadd	v16.8h, v17.8h, v18.8h

;; SRHADDv8i8
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: call void @llvm.trap()
srhadd	v16.8b, v17.8b, v18.8b

ret
