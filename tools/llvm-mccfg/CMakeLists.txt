set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  DebugInfo
  MC
  MCAnalysis
  MCDisassembler
  Object
  Support
  )

add_llvm_tool(llvm-mccfg
  llvm-mccfg.cpp
  )
