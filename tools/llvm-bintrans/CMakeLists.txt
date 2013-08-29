set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  mcjit jit interpreter selectiondag native
  DC
  DebugInfo
  )

add_llvm_tool(llvm-bintrans
  llvm-bintrans.cpp
  )
