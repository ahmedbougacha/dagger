add_llvm_library(LLVMDC
  DCFunction.cpp
  DCRegisterSema.cpp
  DCRegisterSetDesc.cpp
  DCTranslator.cpp
  DCTranslatorUtils.cpp
  )

add_dependencies(LLVMDC intrinsics_gen)
