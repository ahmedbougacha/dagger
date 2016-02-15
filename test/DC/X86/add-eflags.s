#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

add_ri:
add rdi, 2
ret

# CHECK-LABEL: bb_0:
# CHECK-DAG: [[RDI0:%RDI_[0-9]+]] = load i64, i64* %RDI
# CHECK-DAG: [[RDI1:%RDI_[0-9]+]] = add i64 [[RDI0]], [[OP2:2]]
# CHECK-DAG: [[EFLAGS0:%EFLAGS_[0-9]+]] = load i32, i32* %EFLAGS

# CHECK:     [[ZF0:%ZF_[0-9]+]] = icmp eq i64 [[RDI1]], 0
# CHECK:     [[SF0:%SF_[0-9]+]] = icmp slt i64 [[RDI1]], 0

# CHECK:     [[SADD:%[0-9]+]] = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 [[RDI0]], i64 [[OP2]])
# CHECK:     [[OF0:%OF_[0-9]+]] = extractvalue { i64, i1 } [[SADD]], 1
# CHECK:     [[UADD:%[0-9]+]] = call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 [[RDI0]], i64 [[OP2]])
# CHECK:     [[CF0:%CF_[0-9]+]] = extractvalue { i64, i1 } [[UADD]], 1

# CHECK:     [[BYTE:%[0-9]+]] = trunc i64 [[RDI1]] to i8
# CHECK:     [[CTPOP:%[0-9]+]] = call i8 @llvm.ctpop.i8(i8 [[BYTE]])
# CHECK:     [[POP_PARITY:%[0-9]+]] = trunc i8 [[CTPOP]] to i1
# CHECK:     [[PF0:%PF_[0-9]+]] = icmp eq i1 [[POP_PARITY]], false

## Now insert each status flag in EFLAGS.
# CHECK:     [[CtlSysEFLAGS0:%CtlSysEFLAGS_[0-9]+]] = load i32, i32* %CtlSysEFLAGS

## -2262 is a mask for all status flags we're about to compute:
## -2262 =  1011100101010
##           |   || | | |
## 11: OF ---+   || | | |
##  7: SF -------+| | | |
##  6: ZF --------+ | | |
##  4: AF ----------+ | |
##  2: PF ------------+ |
##  0: CF --------------+

# CHECK:     [[CFEXT:%[0-9]+]] = zext i1 [[CF0]] to i32
# CHECK:     [[CFSHL:%[0-9]+]] = shl i32 [[CFEXT]], 0
# CHECK:     [[WITHCF:%[0-9]+]] = or i32 [[CFSHL]], [[CtlSysEFLAGS0]]

# CHECK:     [[PFEXT:%[0-9]+]] = zext i1 [[PF0]] to i32
# CHECK:     [[PFSHL:%[0-9]+]] = shl i32 [[PFEXT]], 2
# CHECK:     [[WITHPF:%[0-9]+]] = or i32 [[PFSHL]], [[WITHCF]]

## AF is cleared, use the constant false.
# CHECK:     [[AFEXT:%[0-9]+]] = zext i1 false to i32
# CHECK:     [[AFSHL:%[0-9]+]] = shl i32 [[AFEXT]], 4
# CHECK:     [[WITHAF:%[0-9]+]] = or i32 [[AFSHL]], [[WITHPF]]

# CHECK:     [[ZFEXT:%[0-9]+]] = zext i1 [[ZF0]] to i32
# CHECK:     [[ZFSHL:%[0-9]+]] = shl i32 [[ZFEXT]], 6
# CHECK:     [[WITHZF:%[0-9]+]] = or i32 [[ZFSHL]], [[WITHAF]]

# CHECK:     [[SFEXT:%[0-9]+]] = zext i1 [[SF0]] to i32
# CHECK:     [[SFSHL:%[0-9]+]] = shl i32 [[SFEXT]], 7
# CHECK:     [[WITHSF:%[0-9]+]] = or i32 [[SFSHL]], [[WITHZF]]

# CHECK:     [[OFEXT:%[0-9]+]] = zext i1 [[OF0]] to i32
# CHECK:     [[OFSHL:%[0-9]+]] = shl i32 [[OFEXT]], 11
# CHECK:     [[EFLAGS1:%EFLAGS_[0-9]+]] = or i32 [[OFSHL]], [[WITHSF]]

# CHECK-DAG: store i32 [[EFLAGS1]], i32* %EFLAGS
# CHECK-DAG: store i64 [[RDI1]], i64* %RDI
# CHECK: br label %exit_fn_0
