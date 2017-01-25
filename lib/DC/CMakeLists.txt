add_llvm_library(LLVMDC
  DCBasicBlock.cpp
  DCFunction.cpp
  DCInstruction.cpp
  DCModule.cpp
  DCRegisterSema.cpp
  DCRegisterSetDesc.cpp
  DCTranslator.cpp
  DCTranslatorUtils.cpp
  LowerDCTranslateAt.cpp
  )

add_dependencies(LLVMDC intrinsics_gen)
