; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; BLR
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg{{.*}} !"PC")
; CHECK-NEXT: [[X16_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"X16")
; CHECK-NEXT: [[X16_1:%.+]] = inttoptr i64 [[X16_0]] to i8*
; CHECK-NEXT: [[X16_2:%.+]] = call i8* @llvm.dc.translate.at(i8* [[X16_1]])
; CHECK-NEXT: [[X16_3:%.+]] = bitcast i8* [[X16_2]] to void (%regset*)*
; CHECK-NEXT: call void [[X16_3]](%regset* {{.+}})
blr	x16

ret
