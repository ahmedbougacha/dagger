; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s --check-prefix=X64

define void @add(i256* %p, i256* %q) nounwind {
; X32-LABEL: add:
; X32:       # BB#0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    pushl %ebx
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $16, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl 8(%ecx), %edi
; X32-NEXT:    movl (%ecx), %esi
; X32-NEXT:    movl 4(%ecx), %ebx
; X32-NEXT:    movl 28(%eax), %edx
; X32-NEXT:    movl %edx, {{[0-9]+}}(%esp) # 4-byte Spill
; X32-NEXT:    movl 24(%eax), %edx
; X32-NEXT:    addl (%eax), %esi
; X32-NEXT:    movl %esi, {{[0-9]+}}(%esp) # 4-byte Spill
; X32-NEXT:    adcl 4(%eax), %ebx
; X32-NEXT:    movl %ebx, (%esp) # 4-byte Spill
; X32-NEXT:    adcl 8(%eax), %edi
; X32-NEXT:    movl %edi, {{[0-9]+}}(%esp) # 4-byte Spill
; X32-NEXT:    movl 20(%eax), %ebx
; X32-NEXT:    movl 12(%eax), %esi
; X32-NEXT:    movl 16(%eax), %edi
; X32-NEXT:    adcl 12(%ecx), %esi
; X32-NEXT:    adcl 16(%ecx), %edi
; X32-NEXT:    adcl 20(%ecx), %ebx
; X32-NEXT:    adcl 24(%ecx), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax # 4-byte Reload
; X32-NEXT:    adcl 28(%ecx), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ebp # 4-byte Reload
; X32-NEXT:    movl %ebp, 8(%ecx)
; X32-NEXT:    movl (%esp), %ebp # 4-byte Reload
; X32-NEXT:    movl %ebp, 4(%ecx)
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ebp # 4-byte Reload
; X32-NEXT:    movl %ebp, (%ecx)
; X32-NEXT:    movl %esi, 12(%ecx)
; X32-NEXT:    movl %edi, 16(%ecx)
; X32-NEXT:    movl %ebx, 20(%ecx)
; X32-NEXT:    movl %edx, 24(%ecx)
; X32-NEXT:    movl %eax, 28(%ecx)
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    popl %ebx
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: add:
; X64:       # BB#0:
; X64-NEXT:    movq 16(%rdi), %rax
; X64-NEXT:    movq (%rdi), %r8
; X64-NEXT:    movq 8(%rdi), %rdx
; X64-NEXT:    movq 24(%rsi), %rcx
; X64-NEXT:    addq (%rsi), %r8
; X64-NEXT:    adcq 8(%rsi), %rdx
; X64-NEXT:    adcq 16(%rsi), %rax
; X64-NEXT:    adcq 24(%rdi), %rcx
; X64-NEXT:    movq %rax, 16(%rdi)
; X64-NEXT:    movq %rdx, 8(%rdi)
; X64-NEXT:    movq %r8, (%rdi)
; X64-NEXT:    movq %rcx, 24(%rdi)
; X64-NEXT:    retq
  %a = load i256, i256* %p
  %b = load i256, i256* %q
  %c = add i256 %a, %b
  store i256 %c, i256* %p
  ret void
}
define void @sub(i256* %p, i256* %q) nounwind {
; X32-LABEL: sub:
; X32:       # BB#0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    pushl %ebx
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $12, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl 16(%ecx), %eax
; X32-NEXT:    movl 12(%ecx), %edx
; X32-NEXT:    movl 8(%ecx), %edi
; X32-NEXT:    movl (%ecx), %esi
; X32-NEXT:    movl 4(%ecx), %ebp
; X32-NEXT:    subl (%ebx), %esi
; X32-NEXT:    movl %esi, {{[0-9]+}}(%esp) # 4-byte Spill
; X32-NEXT:    sbbl 4(%ebx), %ebp
; X32-NEXT:    sbbl 8(%ebx), %edi
; X32-NEXT:    sbbl 12(%ebx), %edx
; X32-NEXT:    movl %edx, {{[0-9]+}}(%esp) # 4-byte Spill
; X32-NEXT:    sbbl 16(%ebx), %eax
; X32-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X32-NEXT:    movl 20(%ecx), %esi
; X32-NEXT:    sbbl 20(%ebx), %esi
; X32-NEXT:    movl 24(%ecx), %edx
; X32-NEXT:    sbbl 24(%ebx), %edx
; X32-NEXT:    movl 28(%ecx), %eax
; X32-NEXT:    sbbl 28(%ebx), %eax
; X32-NEXT:    movl %edi, 8(%ecx)
; X32-NEXT:    movl %ebp, 4(%ecx)
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi # 4-byte Reload
; X32-NEXT:    movl %edi, (%ecx)
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi # 4-byte Reload
; X32-NEXT:    movl %edi, 12(%ecx)
; X32-NEXT:    movl (%esp), %edi # 4-byte Reload
; X32-NEXT:    movl %edi, 16(%ecx)
; X32-NEXT:    movl %esi, 20(%ecx)
; X32-NEXT:    movl %edx, 24(%ecx)
; X32-NEXT:    movl %eax, 28(%ecx)
; X32-NEXT:    addl $12, %esp
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    popl %ebx
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: sub:
; X64:       # BB#0:
; X64-NEXT:    movq 24(%rdi), %r8
; X64-NEXT:    movq 16(%rdi), %rcx
; X64-NEXT:    movq (%rdi), %rdx
; X64-NEXT:    movq 8(%rdi), %rax
; X64-NEXT:    subq (%rsi), %rdx
; X64-NEXT:    sbbq 8(%rsi), %rax
; X64-NEXT:    sbbq 16(%rsi), %rcx
; X64-NEXT:    sbbq 24(%rsi), %r8
; X64-NEXT:    movq %rcx, 16(%rdi)
; X64-NEXT:    movq %rax, 8(%rdi)
; X64-NEXT:    movq %rdx, (%rdi)
; X64-NEXT:    movq %r8, 24(%rdi)
; X64-NEXT:    retq
  %a = load i256, i256* %p
  %b = load i256, i256* %q
  %c = sub i256 %a, %b
  store i256 %c, i256* %p
  ret void
}
