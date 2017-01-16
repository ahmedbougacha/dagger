add_llvm_library(LLVMDC
  DCAnnotationWriter.cpp
  DCFunction.cpp
  DCRegisterSema.cpp
  DCTranslatedInstTracker.cpp
  DCTranslator.cpp
  DCTranslatorUtils.cpp
  )

add_dependencies(LLVMDC intrinsics_gen)
