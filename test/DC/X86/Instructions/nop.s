# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## NOOP
# CHECK-LABEL: call void @llvm.dc.startinst
nop

## NOOPL
# CHECK-LABEL: call void @llvm.dc.startinst
nopl	2(%r11,%rbx,2)

## NOOPW
# CHECK-LABEL: call void @llvm.dc.startinst
nopw	2(%r11,%rbx,2)

retq
