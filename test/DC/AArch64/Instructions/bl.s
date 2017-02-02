; RUN: llvm-mc -triple aarch64-apple-ios -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

;; BL
; CHECK-LABEL: call void @llvm.dc.startinst
; CHECK-NEXT: [[PC_0:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: [[V0:%.+]] = add i64 [[PC_0]], 4
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[V0]], metadata !"PC")
; CHECK-NEXT: [[PC_1:%.+]] = call i64 @llvm.dc.getreg.i64(metadata !"PC")
; CHECK-NEXT: call void @llvm.dc.setreg.i64(i64 [[PC_1]], metadata !"LR")
; CHECK-NEXT: [[V1:%.+]] = inttoptr i64 {{.*}} to i8*
; CHECK-NEXT: [[V1_2:%.+]] = call i8* @llvm.dc.translate.at(i8* [[V1]])
; CHECK-NEXT: [[V1_3:%.+]] = bitcast i8* [[V1_2]] to void (%regset*)*
; CHECK-NEXT: call void [[V1_3]](%regset* {{.+}})
bl	#0

ret
