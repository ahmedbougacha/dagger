set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  MCAnalysis
  MCDisassembler
  DC
  )

add_llvm_tool(llvm-dec
  llvm-dec.cpp
  )
