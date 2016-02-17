Dagger
======

[![Build Status](https://travis-ci.org/daggerproject/dagger.svg?branch=master)](https://travis-ci.org/daggerproject/dagger)

Dagger is a binary translator to LLVM IR, with the goal of being as native as possible to the LLVM infrastructure.

Building
--------

As an LLVM fork, Dagger is built the same way; assuming you have a reasonably recent toolchain and CMake, just do:

     cd dagger
     mkdir build
     cmake ..
     make

More information on the llvm.org [Getting Started](http://llvm.org/docs/GettingStarted.html) and [CMake](http://llvm.org/docs/CMake.html) pages.

Usage
-----

While Dagger is intended to be usable as a library, it does come with tools:

### Static Binary Translation to IR: llvm-dec
llvm-dec takes in an object file and produces IR.

     ./bin/llvm-dec ./a.out

### Dynamic Binary Translation: DYN (OS X-only)
DYN is an OS X-only dylib that is intended to be preloaded so that it can hijack program execution:

     echo "int main() { return 42; }" | clang -x c -
     DYLD_INSERT_LIBRARIES=./lib/libDYN.dylib ./a.out
     echo $?
    > 42

This will "execute" `a.out` by translating all of its code to LLVM IR, JITting that, and finally executing it.

The `DCDYN_OPTIONS` environment variable can be used to pass command-line options. For instance, if you're really brave, you can try:

    DCDYN_OPTIONS="-print-after-all" DYLD_INSERT_LIBRARIES=build/lib/libDYN.dylib ./a.out

which will print tons of LLVM debug output.

### Command-line options

Example
-------

Features
--------

X86 is the only currently supported target.

The Mach-O object file format is the best supported. However, except for DYN, there is always a generic fallback, so YMMV with other formats (e.g., ELF).

Architecture
------------

### MC

### DC

Testing
-------

### MC
In test/MC/Analysis.
Using llvm-mccfg: pass a binary, get a YAML recursive disassembly (basic blocks and all)

### DC
In test/DC/
Using llvm-dc: pass a YAML MC CFG, get IR.
Using llvm-dec: pass an object, get IR.

### DYN
In test/DC/X86/DYN
Using libDYN.dylib itself: run a (dynamically translated) executable, compare the register differences with the native execution results (gathered with an LLDB script).
