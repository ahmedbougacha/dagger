# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## CDQ
cltd
## CDQE
cltq
## CQO
cqto
## CWD
cwtd
## CWDE
cwtl
retq
