; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; BLR
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"LR")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 [[X16_0]] to i8*
; CHECK-NEXT: [[V2:%.+]] = call i8* @llvm.dc.translate.at(i8* [[V1]])
; CHECK-NEXT: [[V3:%.+]] = bitcast i8* [[V2]] to void (%regset*)*
; CHECK-NEXT: call void [[V3]](%regset* %0)
blr	x16

ret
