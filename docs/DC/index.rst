======================================
The LLVM Target-Independent Decompiler
======================================

.. contents::
   :local:

.. toctree::
   :hidden:

   SemanticsEmitterTableGen

.. warning::
  This is a work in progress.

Introduction
============

The LLVM Target-Independent DeCompiler framework, "DC", is a set of tools and
libraries, which provide a way to translate Machine Code (as provided by
.. FIXME: add some link to MC (codegenerator?), and to LangRef for IR.
the MC layer) to LLVM's Intermediate Representation.
.. FIXME: another link
It builds upon the Target-independent Code Generator interfaces to 




Translation Classes
===================

The ``DCInstrSema`` class
-------------------------

The ``DCInstrSema`` class
