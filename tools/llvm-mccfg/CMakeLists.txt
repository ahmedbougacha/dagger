set(LLVM_LINK_COMPONENTS
  AllTargetsAsmPrinters
  AllTargetsDescs
  AllTargetsDisassemblers
  AllTargetsInfos
  MC
  MCAnalysis
  MCDisassembler
  Object
  Support
  )

add_llvm_tool(llvm-mccfg
  llvm-mccfg.cpp
  )
