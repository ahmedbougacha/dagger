include_directories( ${CMAKE_CURRENT_BINARY_DIR}/.. ${CMAKE_CURRENT_SOURCE_DIR}/.. )

add_llvm_library(LLVMX86DC
  X86DCInfo.cpp
  X86DCFunction.cpp
  X86RegisterSema.cpp
  )

add_dependencies(LLVMX86DC X86CommonTableGen)
