add_llvm_library(LLVMDC
  DCAnnotationWriter.cpp
  DCInstrSema.cpp
  DCRegisterSema.cpp
  DCTranslatedInstTracker.cpp
  DCTranslator.cpp
  )

add_dependencies(LLVMDC intrinsics_gen)
