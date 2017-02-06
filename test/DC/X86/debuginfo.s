#RUN: rm -rf %t
#RUN: mkdir %t
#RUN: llvm-mc -triple=x86_64-unknown-darwin < %s -filetype=obj -o - |\
#RUN:   llvm-dec - -debug-info-dir=%t | FileCheck %s

#RUN: cat %t/dct\ module\ #0.s | FileCheck %s --check-prefix=CHECK-SRC

.global _main
_main:
movq $42, %rdi
callq Lcallee
retq

Lcallee:
movq %rdi, %rax
retq

# CHECK-SRC-LABEL: fn_0:
# CHECK-SRC-NEXT:  bb_0:
# CHECK-SRC-NEXT:    movq $42, %rdi
# CHECK-SRC-NEXT:    callq 1
# CHECK-SRC-NEXT:    retq

# CHECK-SRC-LABEL: fn_D:
# CHECK-SRC-NEXT:  bb_D:
# CHECK-SRC-NEXT:    movq %rdi, %rax
# CHECK-SRC-NEXT:    retq

# CHECK: define void @fn_0(%regset* noalias nocapture) !dbg [[FN_0_DBGLOC:![0-9]+]]
# CHECK-LABEL: entry_fn_0:
# CHECK:   [[RIP_ptr:%.*]] = getelementptr inbounds %regset, %regset* %0, i32 0, i32 {{.*}}, !dbg [[LINE_1:![0-9]+]]
# CHECK:   [[RIP_init:%.*]] = load i64, i64* [[RIP_ptr]], !dbg [[LINE_1]]
# CHECK:   %RIP = alloca i64, !dbg [[LINE_1]]
# CHECK:   call void @llvm.dbg.declare(metadata i64* %RIP, metadata [[FN_0_RIP:![0-9]+]], metadata [[DI_EXPR:![0-9]+]]), !dbg [[LINE_1]]
# CHECK:   store i64 [[RIP_init]], i64* %RIP, !dbg [[LINE_1]]

# CHECK-LABEL: exit_fn_0:
# CHECK:   [[RIP_final:%.*]] = load i64, i64* %RIP, !dbg [[LINE_1]]
# CHECK:   store i64 [[RIP_final]], i64* [[RIP_ptr]], !dbg [[LINE_1]]
# CHECK:   ret void, !dbg [[LINE_1]]

# CHECK-LABEL: bb_0:
# CHECK:   [[RIP_1:%.*]] = add i64 0, 7, !dbg [[LINE_3:![0-9]+]]
# CHECK:   {{.*}} = add i64 [[RIP_1]], 5, !dbg [[LINE_4:![0-9]+]]
# CHECK:   store i32 42, i32* %EDI, !dbg [[LINE_2:![0-9]+]]
# CHECK:   call void @fn_D(%regset* %0), !dbg [[LINE_4]]
# CHECK:   [[RIP_3:%.*]] = load i64, i64* %RIP, !dbg [[LINE_4]]
# CHECK:   {{.*}} = add i64 [[RIP_3]], 1, !dbg [[LINE_5:![0-9]+]]
# CHECK:   [[RIP_5:%.*]] = load i64, i64* %11, !dbg [[LINE_5]]
# CHECK:   store i64 [[RIP_5]], i64* %RIP, !dbg [[LINE_5]]
# CHECK:   br label %exit_fn_0, !dbg [[LINE_5]]

# CHECK: define void @fn_D(%regset* noalias nocapture) !dbg [[FN_D_DBGLOC:![0-9]+]]
# CHECK-LABEL: entry_fn_D:
# CHECK:   {{.*}} = getelementptr inbounds %regset, %regset* %0, i32 0, i32 {{.*}}, !dbg [[LINE_6:![0-9]+]]
# CHECK:   call void @llvm.dbg.declare(metadata i64* {{%.*}}, metadata [[FN_D_RIP:![0-9]+]], metadata [[DI_EXPR]]), !dbg [[LINE_6]]

# CHECK-LABEL: exit_fn_D:
# CHECK:   ret void, !dbg [[LINE_6]]

# CHECK-LABEL: bb_D:
# CHECK:   {{.*}} = add i64 13, 3, !dbg [[LINE_8:![0-9]+]]
# CHECK:   [[RDI_0:%.*]] = load i64, i64* %RDI, !dbg [[LINE_7:![0-9]+]]
# CHECK:   {{.*}} = load i64, i64* %7, !dbg [[LINE_9:![0-9]+]]
# CHECK:   store i32 {{.*}}, i32* %EIP, !dbg [[LINE_9]]
# CHECK:   store i64 [[RDI_0]], i64* %RAX, !dbg [[LINE_7]]
# CHECK:   br label %exit_fn_D, !dbg [[LINE_9]]
# CHECK: }


# CHECK: !llvm.dbg.cu = !{[[DICU:![0-9]+]]}
# CHECK: !llvm.module.flags = !{[[DWARFVER:![0-9]+]], [[DBGVER:![0-9]+]]}

# CHECK: [[DICU]] = distinct !DICompileUnit(language: DW_LANG_C, file: [[DIFILE:![0-9]+]], producer: "LLVM-DC5.0.0svn", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: [[EMPTY_LIST:![0-9]+]])
# CHECK: [[DIFILE]] = !DIFile(filename: "{{.*}}/debuginfo.s.tmp/dct module #0.s", directory: "{{.*}}")
# CHECK: [[EMPTY_LIST]] = !{}
# CHECK: [[DWARFVER]] = !{i32 1, !"Dwarf Version", i32 2}
# CHECK: [[DBGVER]] = !{i32 1, !"Debug Info Version", i32 3}

# CHECK: [[FN_0_DBG:![0-9]+]] = distinct !DISubprogram(name: "fn_0", linkageName: "fn_0", scope: [[DIFILE]], file: [[DIFILE]], type: [[FN_TY_DBG:![0-9]+]], isLocal: false, isDefinition: true, scopeLine: 1, isOptimized: false, unit: [[DICU]], variables: [[FN_0_VARS:![0-9]+]])
# CHECK: [[FN_TY_DBG]] = !DISubroutineType(types: [[EMPTY_LIST]])
# CHECK: [[FN_0_VARS]] = !{[[FN_0_RIP:![0-9]+]], [[FN_0_EIP:![0-9]+]], [[FN_0_IP:![0-9]+]], [[FN_0_RDI:![0-9]+]], [[FN_0_EDI:![0-9]+]], [[FN_0_DI:![0-9]+]], [[FN_0_DIL:![0-9]+]], [[FN_0_RSP:![0-9]+]], [[FN_0_ESP:![0-9]+]], [[FN_0_SP:![0-9]+]], [[FN_0_SPL:![0-9]+]]}
# CHECK: [[FN_0_RIP]] = !DILocalVariable(name: "RIP", scope: [[FN_0_SCOPE:![0-9]+]], file: [[DIFILE]], line: 1, type: [[DI_I64:![0-9]+]])
# CHECK: [[FN_0_SCOPE]] = distinct !DILexicalBlock(scope: [[FN_0_DBG]], file: [[DIFILE]], line: 1)
# CHECK: [[DI_I64]] = !DIBasicType(name: "i64", size: 64, encoding: DW_ATE_unsigned)
# CHECK: [[FN_0_EIP]] = !DILocalVariable(name: "EIP", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I32:![0-9]+]])
# CHECK: [[DI_I32]] = !DIBasicType(name: "i32", size: 32, encoding: DW_ATE_unsigned)
# CHECK: [[FN_0_IP]] = !DILocalVariable(name: "IP", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I16:![0-9]+]])
# CHECK: [[DI_I16]] = !DIBasicType(name: "i16", size: 16, encoding: DW_ATE_unsigned)
# CHECK: [[FN_0_RDI]] = !DILocalVariable(name: "RDI", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I64]])
# CHECK: [[FN_0_EDI]] = !DILocalVariable(name: "EDI", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I32]])
# CHECK: [[FN_0_DI]] = !DILocalVariable(name: "DI", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I16]])
# CHECK: [[FN_0_DIL]] = !DILocalVariable(name: "DIL", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I8:![0-9]+]])
# CHECK: [[DI_I8]] = !DIBasicType(name: "i8", size: 8, encoding: DW_ATE_unsigned)
# CHECK: [[FN_0_RSP]] = !DILocalVariable(name: "RSP", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I64]])
# CHECK: [[FN_0_ESP]] = !DILocalVariable(name: "ESP", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I32]])
# CHECK: [[FN_0_SP]] = !DILocalVariable(name: "SP", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I16]])
# CHECK: [[FN_0_SPL]] = !DILocalVariable(name: "SPL", scope: [[FN_0_SCOPE]], file: [[DIFILE]], line: 1, type: [[DI_I8]])

# CHECK-DAG: [[DI_EXPR]] = !DIExpression()

# CHECK-DAG: [[LINE_1]] = !DILocation(line: 1, scope: [[FN_0_SCOPE]])
# CHECK-DAG: [[LINE_2]] = !DILocation(line: 2, scope: [[FN_0_SCOPE]])
# CHECK-DAG: [[LINE_3]] = !DILocation(line: 3, scope: [[FN_0_SCOPE]])
# CHECK-DAG: [[LINE_4]] = !DILocation(line: 4, scope: [[FN_0_SCOPE]])
# CHECK-DAG: [[LINE_5]] = !DILocation(line: 5, scope: [[FN_0_SCOPE]])

# CHECK: [[FN_D_DBG:![0-9]+]] = distinct !DISubprogram(name: "fn_D", linkageName: "fn_D", scope: [[DIFILE]], file: [[DIFILE]], line: 13, type: [[FN_TY_DBG]], isLocal: false, isDefinition: true, scopeLine: 6, isOptimized: false, unit: [[DICU]], variables: [[FN_D_VARS:![0-9]+]])

# CHECK: [[FN_D_VARS]] = !{[[FN_D_RIP:![0-9]+]], [[FN_D_EIP:![0-9]+]], [[FN_D_IP:![0-9]+]], [[FN_D_RDI:![0-9]+]], [[FN_D_RAX:![0-9]+]], [[FN_D_EAX:![0-9]+]], [[FN_D_AX:![0-9]+]], [[FN_D_AL:![0-9]+]], [[FN_D_AH:![0-9]+]], [[FN_D_RSP:![0-9]+]], [[FN_D_ESP:![0-9]+]], [[FN_D_SP:![0-9]+]], [[FN_D_SPL:![0-9]+]]}
# CHECK: [[FN_D_RIP]] = !DILocalVariable(name: "RIP", scope: [[FN_D_SCOPE:![0-9]+]], file: [[DIFILE]], line: 6, type: [[DI_I64]])
# CHECK: [[FN_D_SCOPE]] = distinct !DILexicalBlock(scope: [[FN_D_DBG]], file: [[DIFILE]], line: 6)
# CHECK: [[FN_D_EIP]] = !DILocalVariable(name: "EIP", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I32]])
# CHECK: [[FN_D_IP]] = !DILocalVariable(name: "IP", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I16]])
# CHECK: [[FN_D_RDI]] = !DILocalVariable(name: "RDI", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I64]])
# CHECK: [[FN_D_RAX]] = !DILocalVariable(name: "RAX", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I64]])
# CHECK: [[FN_D_EAX]] = !DILocalVariable(name: "EAX", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I32]])
# CHECK: [[FN_D_AX]] = !DILocalVariable(name: "AX", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I16]])
# CHECK: [[FN_D_AL]] = !DILocalVariable(name: "AL", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I8]])
# CHECK: [[FN_D_AH]] = !DILocalVariable(name: "AH", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I8]])
# CHECK: [[FN_D_RSP]] = !DILocalVariable(name: "RSP", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I64]])
# CHECK: [[FN_D_ESP]] = !DILocalVariable(name: "ESP", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I32]])
# CHECK: [[FN_D_SP]] = !DILocalVariable(name: "SP", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I16]])
# CHECK: [[FN_D_SPL]] = !DILocalVariable(name: "SPL", scope: [[FN_D_SCOPE]], file: [[DIFILE]], line: 6, type: [[DI_I8]])

# CHECK-DAG: [[LINE_6]] = !DILocation(line: 6, scope: [[FN_D_SCOPE]])
# CHECK-DAG: [[LINE_7]] = !DILocation(line: 7, scope: [[FN_D_SCOPE]])
# CHECK-DAG: [[LINE_8]] = !DILocation(line: 8, scope: [[FN_D_SCOPE]])
