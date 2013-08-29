# Here we hack our way into getting this to work.
# In this case we need the static constructor in DYNCode to run after the rest
# of LLVM has initialized. This isn't usually well-defined behavior, but the
# ordering of the first appearance of each object in the linker command line
# determines the ordering of its static constructors.
# Thus, we force all libraries to be linked, before DYNCore is.
get_property(ALL_LIBRARIES_DEP GLOBAL PROPERTY LLVM_LIBS)

# At this point we saved all the other libs, we can proceed with DYNCore.
add_subdirectory(dyncore)

get_target_property(LLVMSupport_SYSTEM_LIBS LLVMSupport LLVM_SYSTEM_LIBS)
foreach(l ${LLVMSupport_SYSTEM_LIBS})
  list(APPEND ALL_LIBRARIES_DEP "-l${l}")
endforeach()

set(LLVM_LINK_COMPONENTS
    ${LLVM_TARGETS_TO_BUILD}
    jit selectiondag native
    DC
    DebugInfo
  )

set(SOURCES
  dyn.cpp
  )

add_llvm_library(DYN SHARED ${SOURCES})
target_link_libraries(DYN PUBLIC
  ${ALL_LIBRARIES_DEP}
  LLVMDYNCore
  )
