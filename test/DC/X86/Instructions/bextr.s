# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

## BEXTR32rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
bextrl	%r12d, 2(%rbx,%r14,2), %r8d

## BEXTR32rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
bextrl	%r10d, %r9d, %r8d

## BEXTR64rm
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
bextrq	%rbp, 2(%rbx,%r14,2), %r11

## BEXTR64rr
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
bextrq	%r14, %rbx, %r11

## BEXTRI32mi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
bextr	$2, 2(%rbx,%r14,2), %r8d

## BEXTRI32ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
bextr	$2, %r9d, %r8d

## BEXTRI64mi
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
bextr	$2, 2(%rbx,%r14,2), %r11

## BEXTRI64ri
# CHECK-LABEL: call void @llvm.dc.startinst
# CHECK-NEXT: call void @llvm.trap()
# CHECK-NEXT: unreachable
bextr	$2, %rbx, %r11

retq
