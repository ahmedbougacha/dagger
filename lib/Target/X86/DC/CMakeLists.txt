include_directories( ${CMAKE_CURRENT_BINARY_DIR}/.. ${CMAKE_CURRENT_SOURCE_DIR}/.. )

add_llvm_library(LLVMX86DC
  X86DCBasicBlock.cpp
  X86DCFunction.cpp
  X86DCInfo.cpp
  X86DCInstruction.cpp
  X86DCModule.cpp
  X86DCTranslator.cpp
  )

add_dependencies(LLVMX86DC X86CommonTableGen)
