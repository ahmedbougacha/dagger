# RUN: llvm-mc -filetype=obj -o - %s | llvm-dec - -dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin | FileCheck %s

# XFAIL: *

## REPNE_PREFIX
repne
## REP_PREFIX
rep
## XACQUIRE_PREFIX
xacquire
## XRELEASE_PREFIX
xrelease
retq
