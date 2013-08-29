#ifndef LLVM_DYNCORE_H
#define LLVM_DYNCORE_H

extern "C" void LLVMLinkInDYNCore();

#include <cstdlib>

namespace {
  struct ForceDYNCoreLinking {
    ForceDYNCoreLinking() {
      // We must reference DYNCore in such a way that compilers will not
      // delete it all as dead code, even with whole program optimization,
      // yet is effectively a NO-OP. As the compiler isn't smart enough
      // to know that getenv() never returns -1, this will do the job.
      if (std::getenv("bar") != (char*) -1)
        return;

      LLVMLinkInDYNCore();
    }
  } ForceDYNCoreLinking;
}

#endif
