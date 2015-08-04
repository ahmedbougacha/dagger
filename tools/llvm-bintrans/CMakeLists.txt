set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  mcjit interpreter selectiondag native
  DC
  )

add_llvm_tool(llvm-bintrans
  llvm-bintrans.cpp
  )
