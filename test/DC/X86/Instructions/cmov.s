# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## CMOVA16rm
cmovaw	2(%r14,%r15,2), %r8w
## CMOVA16rr
cmovaw	%r10w, %r8w
## CMOVA32rm
cmoval	2(%r14,%r15,2), %r8d
## CMOVA32rr
cmoval	%r10d, %r8d
## CMOVA64rm
cmovaq	2(%r14,%r15,2), %r11
## CMOVA64rr
cmovaq	%r14, %r11
## CMOVAE16rm
cmovaew	2(%r14,%r15,2), %r8w
## CMOVAE16rr
cmovaew	%r10w, %r8w
## CMOVAE32rm
cmovael	2(%r14,%r15,2), %r8d
## CMOVAE32rr
cmovael	%r10d, %r8d
## CMOVAE64rm
cmovaeq	2(%r14,%r15,2), %r11
## CMOVAE64rr
cmovaeq	%r14, %r11
## CMOVB16rm
cmovbw	2(%r14,%r15,2), %r8w
## CMOVB16rr
cmovbw	%r10w, %r8w
## CMOVB32rm
cmovbl	2(%r14,%r15,2), %r8d
## CMOVB32rr
cmovbl	%r10d, %r8d
## CMOVB64rm
cmovbq	2(%r14,%r15,2), %r11
## CMOVB64rr
cmovbq	%r14, %r11
## CMOVBE16rm
cmovbew	2(%r14,%r15,2), %r8w
## CMOVBE16rr
cmovbew	%r10w, %r8w
## CMOVBE32rm
cmovbel	2(%r14,%r15,2), %r8d
## CMOVBE32rr
cmovbel	%r10d, %r8d
## CMOVBE64rm
cmovbeq	2(%r14,%r15,2), %r11
## CMOVBE64rr
cmovbeq	%r14, %r11
## CMOVE16rm
cmovew	2(%r14,%r15,2), %r8w
## CMOVE16rr
cmovew	%r10w, %r8w
## CMOVE32rm
cmovel	2(%r14,%r15,2), %r8d
## CMOVE32rr
cmovel	%r10d, %r8d
## CMOVE64rm
cmoveq	2(%r14,%r15,2), %r11
## CMOVE64rr
cmoveq	%r14, %r11
## CMOVG16rm
cmovgw	2(%r14,%r15,2), %r8w
## CMOVG16rr
cmovgw	%r10w, %r8w
## CMOVG32rm
cmovgl	2(%r14,%r15,2), %r8d
## CMOVG32rr
cmovgl	%r10d, %r8d
## CMOVG64rm
cmovgq	2(%r14,%r15,2), %r11
## CMOVG64rr
cmovgq	%r14, %r11
## CMOVGE16rm
cmovgew	2(%r14,%r15,2), %r8w
## CMOVGE16rr
cmovgew	%r10w, %r8w
## CMOVGE32rm
cmovgel	2(%r14,%r15,2), %r8d
## CMOVGE32rr
cmovgel	%r10d, %r8d
## CMOVGE64rm
cmovgeq	2(%r14,%r15,2), %r11
## CMOVGE64rr
cmovgeq	%r14, %r11
## CMOVL16rm
cmovlw	2(%r14,%r15,2), %r8w
## CMOVL16rr
cmovlw	%r10w, %r8w
## CMOVL32rm
cmovll	2(%r14,%r15,2), %r8d
## CMOVL32rr
cmovll	%r10d, %r8d
## CMOVL64rm
cmovlq	2(%r14,%r15,2), %r11
## CMOVL64rr
cmovlq	%r14, %r11
## CMOVLE16rm
cmovlew	2(%r14,%r15,2), %r8w
## CMOVLE16rr
cmovlew	%r10w, %r8w
## CMOVLE32rm
cmovlel	2(%r14,%r15,2), %r8d
## CMOVLE32rr
cmovlel	%r10d, %r8d
## CMOVLE64rm
cmovleq	2(%r14,%r15,2), %r11
## CMOVLE64rr
cmovleq	%r14, %r11
## CMOVNE16rm
cmovnew	2(%r14,%r15,2), %r8w
## CMOVNE16rr
cmovnew	%r10w, %r8w
## CMOVNE32rm
cmovnel	2(%r14,%r15,2), %r8d
## CMOVNE32rr
cmovnel	%r10d, %r8d
## CMOVNE64rm
cmovneq	2(%r14,%r15,2), %r11
## CMOVNE64rr
cmovneq	%r14, %r11
## CMOVNO16rm
cmovnow	2(%r14,%r15,2), %r8w
## CMOVNO16rr
cmovnow	%r10w, %r8w
## CMOVNO32rm
cmovnol	2(%r14,%r15,2), %r8d
## CMOVNO32rr
cmovnol	%r10d, %r8d
## CMOVNO64rm
cmovnoq	2(%r14,%r15,2), %r11
## CMOVNO64rr
cmovnoq	%r14, %r11
## CMOVNP16rm
cmovnpw	2(%r14,%r15,2), %r8w
## CMOVNP16rr
cmovnpw	%r10w, %r8w
## CMOVNP32rm
cmovnpl	2(%r14,%r15,2), %r8d
## CMOVNP32rr
cmovnpl	%r10d, %r8d
## CMOVNP64rm
cmovnpq	2(%r14,%r15,2), %r11
## CMOVNP64rr
cmovnpq	%r14, %r11
## CMOVNS16rm
cmovnsw	2(%r14,%r15,2), %r8w
## CMOVNS16rr
cmovnsw	%r10w, %r8w
## CMOVNS32rm
cmovnsl	2(%r14,%r15,2), %r8d
## CMOVNS32rr
cmovnsl	%r10d, %r8d
## CMOVNS64rm
cmovnsq	2(%r14,%r15,2), %r11
## CMOVNS64rr
cmovnsq	%r14, %r11
## CMOVO16rm
cmovow	2(%r14,%r15,2), %r8w
## CMOVO16rr
cmovow	%r10w, %r8w
## CMOVO32rm
cmovol	2(%r14,%r15,2), %r8d
## CMOVO32rr
cmovol	%r10d, %r8d
## CMOVO64rm
cmovoq	2(%r14,%r15,2), %r11
## CMOVO64rr
cmovoq	%r14, %r11
## CMOVP16rm
cmovpw	2(%r14,%r15,2), %r8w
## CMOVP16rr
cmovpw	%r10w, %r8w
## CMOVP32rm
cmovpl	2(%r14,%r15,2), %r8d
## CMOVP32rr
cmovpl	%r10d, %r8d
## CMOVP64rm
cmovpq	2(%r14,%r15,2), %r11
## CMOVP64rr
cmovpq	%r14, %r11
## CMOVS16rm
cmovsw	2(%r14,%r15,2), %r8w
## CMOVS16rr
cmovsw	%r10w, %r8w
## CMOVS32rm
cmovsl	2(%r14,%r15,2), %r8d
## CMOVS32rr
cmovsl	%r10d, %r8d
## CMOVS64rm
cmovsq	2(%r14,%r15,2), %r11
## CMOVS64rr
cmovsq	%r14, %r11
retq
