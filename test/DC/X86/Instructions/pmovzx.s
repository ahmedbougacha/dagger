# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## PMOVZXBDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxbd	2(%rbx,%r14,2), %xmm8

## PMOVZXBDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxbd	%xmm9, %xmm8

## PMOVZXBQrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxbq	2(%rbx,%r14,2), %xmm8

## PMOVZXBQrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxbq	%xmm9, %xmm8

## PMOVZXBWrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxbw	2(%rbx,%r14,2), %xmm8

## PMOVZXBWrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxbw	%xmm9, %xmm8

## PMOVZXDQrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxdq	2(%rbx,%r14,2), %xmm8

## PMOVZXDQrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxdq	%xmm9, %xmm8

## PMOVZXWDrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxwd	2(%rbx,%r14,2), %xmm8

## PMOVZXWDrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxwd	%xmm9, %xmm8

## PMOVZXWQrm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxwq	2(%rbx,%r14,2), %xmm8

## PMOVZXWQrr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
pmovzxwq	%xmm9, %xmm8

retq
