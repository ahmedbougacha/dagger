set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  MCAnalysis
  DC
  DebugInfo
  )

add_llvm_tool(llvm-dc
  llvm-dc.cpp
  )
