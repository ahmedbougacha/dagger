include_directories( ${CMAKE_CURRENT_BINARY_DIR}/.. ${CMAKE_CURRENT_SOURCE_DIR}/.. )

add_llvm_library(LLVMAArch64DC
  AArch64DCInfo.cpp
  AArch64DCFunction.cpp
  AArch64DCTranslator.cpp
  AArch64RegisterSema.cpp
  )

add_dependencies(LLVMAArch64DC AArch64CommonTableGen)
