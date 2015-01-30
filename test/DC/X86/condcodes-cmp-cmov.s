#RUN: llvm-mc -x86-asm-syntax=intel -triple=x86_64-unknown-darwin < %s -filetype=obj -o - | llvm-dec - | FileCheck %s

cmov_condcodes:
cmp rdi, 42
# CHECK-LABEL: bb_0:
# CHECK-DAG: [[RAX0:%RAX_[0-9]+]] = load i64* %RAX
# CHECK-DAG: [[RDI0:%RDI_[0-9]+]] = load i64* %RDI
# CHECK-DAG: [[CMPSUB:%[0-9]+]] = sub i64 [[RDI0]], [[OP2:42]]
# CHECK-DAG: [[CC_A:%CC_A_[0-9]+]]   = icmp ugt i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_AE:%CC_AE_[0-9]+]] = icmp uge i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_B:%CC_B_[0-9]+]]   = icmp ult i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_BE:%CC_BE_[0-9]+]] = icmp ule i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_L:%CC_L_[0-9]+]]   = icmp slt i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_LE:%CC_LE_[0-9]+]] = icmp sle i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_G:%CC_G_[0-9]+]]   = icmp sgt i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_GE:%CC_GE_[0-9]+]] = icmp sge i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_E:%CC_E_[0-9]+]]   = icmp eq  i64 [[RDI0]], [[OP2]]
# CHECK-DAG: [[CC_NE:%CC_NE_[0-9]+]] = icmp ne  i64 [[RDI0]], [[OP2]]
## CC_O is the same as OF.
# CHECK-DAG: [[CC_O:%OF_[0-9]+]]      = extractvalue { i64, i1 } {{%[0-9]+}}, 1
# CHECK-DAG: [[CC_NO:%CC_NO_[0-9]+]]  = xor i1 [[CC_O]], true
## CC_S is the same as SF.
# CHECK-DAG: [[CC_S:%SF_[0-9]+]]      = icmp slt i64 [[CMPSUB]], 0
# CHECK-DAG: [[CC_NS:%CC_NS_[0-9]+]]  = xor i1 [[CC_S]], true
## CC_P is the same as PF.
# CHECK-DAG: [[CC_P:%PF_[0-9]+]]
# CHECK-DAG: [[CC_NP:%CC_NP_[0-9]+]]  = xor i1 [[CC_P]], true

cmovo   rax, rdi
# CHECK-DAG: [[RAX1:%RAX_[0-9]+]] = select i1 [[CC_O]], i64 [[RDI0]], i64 [[RAX0]]

cmovno  rax, rdi
# CHECK-DAG: [[RAX2:%RAX_[0-9]+]] = select i1 [[CC_NO]], i64 [[RDI0]], i64 [[RAX1]]

cmovb   rax, rdi
# CHECK-DAG: [[RAX3:%RAX_[0-9]+]] = select i1 [[CC_B]], i64 [[RDI0]], i64 [[RAX2]]

cmovae  rax, rdi
# CHECK-DAG: [[RAX4:%RAX_[0-9]+]] = select i1 [[CC_AE]], i64 [[RDI0]], i64 [[RAX3]]

cmove   rax, rdi
# CHECK-DAG: [[RAX5:%RAX_[0-9]+]] = select i1 [[CC_E]], i64 [[RDI0]], i64 [[RAX4]]

cmovne  rax, rdi
# CHECK-DAG: [[RAX6:%RAX_[0-9]+]] = select i1 [[CC_NE]], i64 [[RDI0]], i64 [[RAX5]]

cmovna  rax, rdi
# CHECK-DAG: [[RAX7:%RAX_[0-9]+]] = select i1 [[CC_BE]], i64 [[RDI0]], i64 [[RAX6]]

cmova   rax, rdi
# CHECK-DAG: [[RAX8:%RAX_[0-9]+]] = select i1 [[CC_A]], i64 [[RDI0]], i64 [[RAX7]]

cmovs   rax, rdi
# CHECK-DAG: [[RAX9:%RAX_[0-9]+]] = select i1 [[CC_S]], i64 [[RDI0]], i64 [[RAX8]]

cmovns  rax, rdi
# CHECK-DAG: [[RAX10:%RAX_[0-9]+]] = select i1 [[CC_NS]], i64 [[RDI0]], i64 [[RAX9]]

cmovp   rax, rdi
# CHECK-DAG: [[RAX11:%RAX_[0-9]+]] = select i1 [[CC_P]], i64 [[RDI0]], i64 [[RAX10]]

cmovnp  rax, rdi
# CHECK-DAG: [[RAX12:%RAX_[0-9]+]] = select i1 [[CC_NP]], i64 [[RDI0]], i64 [[RAX11]]

cmovl   rax, rdi
# CHECK-DAG: [[RAX13:%RAX_[0-9]+]] = select i1 [[CC_L]], i64 [[RDI0]], i64 [[RAX12]]

cmovge  rax, rdi
# CHECK-DAG: [[RAX14:%RAX_[0-9]+]] = select i1 [[CC_GE]], i64 [[RDI0]], i64 [[RAX13]]

cmovle  rax, rdi
# CHECK-DAG: [[RAX15:%RAX_[0-9]+]] = select i1 [[CC_LE]], i64 [[RDI0]], i64 [[RAX14]]

cmovg   rax, rdi
# CHECK-DAG: [[RAX16:%RAX_[0-9]+]] = select i1 [[CC_G]], i64 [[RDI0]], i64 [[RAX15]]

ret
# CHECK: store i64 [[RAX16]], i64* %RAX
# CHECK: br label %exit_fn_0
