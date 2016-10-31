//===-- llvm-mccfg.cpp - Object file analysis utility for llvm -------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This program is a utility that analyzes binary object files to export
// their MC-level Control Flow Graph.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/Triple.h"
#include "llvm/MC/MCAnalysis/MCCachingDisassembler.h"
#include "llvm/MC/MCAnalysis/MCFunction.h"
#include "llvm/MC/MCAnalysis/MCModule.h"
#include "llvm/MC/MCAnalysis/MCModuleYAML.h"
#include "llvm/MC/MCAnalysis/MCObjectDisassembler.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDisassembler/MCDisassembler.h"
#include "llvm/MC/MCDisassembler/MCRelocationInfo.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Object/Archive.h"
#include "llvm/Object/COFF.h"
#include "llvm/Object/MachO.h"
#include "llvm/Object/ObjectFile.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/GraphWriter.h"
#include "llvm/Support/Host.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cctype>
#include <cstring>
#include <system_error>

using namespace llvm;
using namespace object;

static cl::list<std::string>
InputFilenames(cl::Positional, cl::desc("<input object files>"),cl::ZeroOrMore);

static cl::opt<std::string>
TripleName("triple", cl::desc("Target triple to disassemble for, "
                              "see -version for available targets"));

static cl::opt<std::string>
MCPU("mcpu",
     cl::desc("Target a specific cpu type (-mcpu=help for details)"),
     cl::value_desc("cpu-name"),
     cl::init(""));

static cl::opt<std::string>
ArchName("arch", cl::desc("Target arch to disassemble for, "
                          "see -version for available targets"));

static cl::list<std::string>
MAttrs("mattr",
  cl::CommaSeparated,
  cl::desc("Target specific attributes"),
  cl::value_desc("a1,+a2,-a3,..."));

static cl::opt<bool>
EmitDOT("emit-dot", cl::desc("Write the CFG for every function found in the"
                             "object to a graphviz .dot file"));

static cl::opt<bool>
EnableDisassemblyCache("enable-mcod-disass-cache",
    cl::desc("Enable the MC Object disassembly instruction cache"),
    cl::init(false), cl::Hidden);

static StringRef ToolName;

static const Target *getTarget(const ObjectFile *Obj = nullptr) {
  // Figure out the target triple.
  llvm::Triple TheTriple("unknown-unknown-unknown");
  if (TripleName.empty()) {
    if (Obj) {
      TheTriple.setArch(Triple::ArchType(Obj->getArch()));
      // TheTriple defaults to ELF, and COFF doesn't have an environment:
      // the best we can do here is indicate that it is mach-o.
      if (Obj->isMachO())
        TheTriple.setObjectFormat(Triple::MachO);

      if (Obj->isCOFF()) {
        const auto COFFObj = dyn_cast<COFFObjectFile>(Obj);
        if (COFFObj->getArch() == Triple::thumb)
          TheTriple.setTriple("thumbv7-windows");
      }
    }
  } else
    TheTriple.setTriple(Triple::normalize(TripleName));

  // Get the target specific parser.
  std::string Error;
  const Target *TheTarget = TargetRegistry::lookupTarget(ArchName, TheTriple,
                                                         Error);
  if (!TheTarget) {
    errs() << ToolName << ": " << Error;
    return nullptr;
  }

  // Update the triple name and return the found target.
  TripleName = TheTriple.getTriple();
  return TheTarget;
}

struct DOTMCFunction {
  const MCFunction &Fn;
  MCInstPrinter &IP;
  const MCSubtargetInfo &STI;

  DOTMCFunction(const MCFunction &Fn, MCInstPrinter &IP,
                const MCSubtargetInfo &STI)
      : Fn(Fn), IP(IP), STI(STI) {}
};

namespace llvm {

template<>
struct GraphTraits<DOTMCFunction> {
  typedef const MCBasicBlock* NodeRef;
  typedef MCBasicBlock::succ_const_iterator ChildIteratorType;
  static NodeRef getEntryNode(const DOTMCFunction &MCFN) {
    return MCFN.Fn.getEntryBlock();
  }
  //    Return iterators that point to the beginning and ending of the child
  //    node list for the specified node.
  static ChildIteratorType child_begin(const MCBasicBlock *MCBB) {
    return MCBB->succ_begin();
  }
  static ChildIteratorType child_end(const MCBasicBlock *MCBB) {
    return MCBB->succ_end();
  }

  //    nodes_iterator/begin/end - Allow iteration over all nodes in the graph
  typedef MCFunction::const_iterator nodes_iterator;
  static nodes_iterator nodes_begin(const DOTMCFunction &MCFN) {
    return MCFN.Fn.begin();
  }
  static nodes_iterator nodes_end(const DOTMCFunction &MCFN) {
    return MCFN.Fn.end();
  }

  static unsigned size(const DOTMCFunction &MCFN) {
    return MCFN.Fn.size();
  }
};

template <>
struct DOTGraphTraits<DOTMCFunction> : public DefaultDOTGraphTraits {
  DOTGraphTraits(bool simple=false) : DefaultDOTGraphTraits(simple) {}

  std::string getNodeLabel(const MCBasicBlock *BB, const DOTMCFunction &MCFN) {
    std::string OutStr;
    raw_string_ostream Out(OutStr);
    Out << BB->getStartAddr();
    return Out.str();
  }
  std::string getNodeDescription(const MCBasicBlock *BB,
                                 const DOTMCFunction &MCFN) {
    std::string OutStr;
    raw_string_ostream Out(OutStr);
    for (auto DInst : *BB) {
      MCFN.IP.printInst(&DInst.Inst, Out, "", MCFN.STI);
      Out << '\n';
    }
    return Out.str();
  }
};

} // end llvm namespace

// Write a graphviz file for the CFG inside an MCFunction.
// FIXME: Use GraphWriter
static void emitDOTFile(const char *FileName, const MCFunction &f,
                        MCInstPrinter *IP, const MCSubtargetInfo &STI) {
  // Start a new dot file.
  std::error_code EC;


  raw_fd_ostream Out(FileName, EC, sys::fs::F_Text);
  if (EC) {
    errs() << ToolName << ": warning: " << EC.message() << '\n';
    return;
  }
  DOTMCFunction DOTFn(f, *IP, STI);
  WriteGraph(Out, DOTFn);

#if 0
  Out << "digraph \"" << f.getName() << "\" {\n";
  Out << "graph [ rankdir = \"LR\" ];\n";
  for (MCFunction::const_iterator i = f.begin(), e = f.end(); i != e; ++i) {
    // Only print blocks that have predecessors.
    bool hasPreds = (*i)->pred_begin() != (*i)->pred_end();

    if (!hasPreds && i != f.begin())
      continue;

    Out << '"' << (*i)->getInsts()->getBeginAddr() << "\" [ label=\"<a>";
    // Print instructions.
    size_t ii = 0;
    const size_t ie = (*i)->getInsts()->size();
    for (MCTextAtom::const_iterator I = (*i)->getInsts()->begin(),
         E = (*i)->getInsts()->end(); I != E; ++I, ++ii) {
      if (ii != 0) // Not the first line, start a new row.
        Out << '|';
      if (ii + 1 == ie) // Last line, add an end id.
        Out << "<o>";

      // Escape special chars and print the instruction in mnemonic form.
      std::string Str;
      raw_string_ostream OS(Str);
      IP->printInst(&I->Inst, OS, "");
      Out << DOT::EscapeString(OS.str());
    }
    Out << "\" shape=\"record\" ];\n";

    // Add edges.
    for (MCBasicBlock::succ_const_iterator si = (*i)->succ_begin(),
        se = (*i)->succ_end(); si != se; ++si)
      Out << (*i)->getInsts()->getBeginAddr() << ":o -> "
          << (*si)->getInsts()->getBeginAddr() << ":a\n";
  }
  Out << "}\n";
#endif
}

static void DumpObject(const ObjectFile *Obj) {
  outs() << '\n';
  outs() << "# " << Obj->getFileName()
         << ":\tfile format " << Obj->getFileFormatName() << "\n\n";

  const Target *TheTarget = getTarget(Obj);
  // getTarget() will have already issued a diagnostic if necessary, so
  // just bail here if it failed.
  if (!TheTarget)
    return;

  // Package up features to be passed to target/subtarget
  std::string FeaturesStr;
  if (MAttrs.size()) {
    SubtargetFeatures Features;
    for (unsigned i = 0; i != MAttrs.size(); ++i)
      Features.AddFeature(MAttrs[i]);
    FeaturesStr = Features.getString();
  }

  std::unique_ptr<const MCRegisterInfo> MRI(
      TheTarget->createMCRegInfo(TripleName));
  if (!MRI) {
    errs() << "error: no register info for target " << TripleName << "\n";
    return;
  }

  // Set up disassembler.
  std::unique_ptr<const MCAsmInfo> AsmInfo(
      TheTarget->createMCAsmInfo(*MRI, TripleName));
  if (!AsmInfo) {
    errs() << "error: no assembly info for target " << TripleName << "\n";
    return;
  }

  std::unique_ptr<const MCSubtargetInfo> STI(
      TheTarget->createMCSubtargetInfo(TripleName, MCPU, FeaturesStr));
  if (!STI) {
    errs() << "error: no subtarget info for target " << TripleName << "\n";
    return;
  }

  std::unique_ptr<const MCInstrInfo> MII(TheTarget->createMCInstrInfo());
  if (!MII) {
    errs() << "error: no instruction info for target " << TripleName << "\n";
    return;
  }

  std::unique_ptr<const MCObjectFileInfo> MOFI(new MCObjectFileInfo);
  MCContext Ctx(AsmInfo.get(), MRI.get(), MOFI.get());

  std::unique_ptr<MCDisassembler> DisAsm(
    TheTarget->createMCDisassembler(*STI, Ctx));

  if (!DisAsm) {
    errs() << "error: no disassembler for target " << TripleName << "\n";
    return;
  }

  std::unique_ptr<MCDisassembler> DisAsmImpl;
  if (EnableDisassemblyCache) {
    DisAsmImpl = std::move(DisAsm);
    DisAsm.reset(new MCCachingDisassembler(*DisAsmImpl, *STI));
  }

  std::unique_ptr<const MCInstrAnalysis> MIA(
      TheTarget->createMCInstrAnalysis(MII.get()));

  int AsmPrinterVariant = AsmInfo->getAssemblerDialect();
  std::unique_ptr<MCInstPrinter> IP(TheTarget->createMCInstPrinter(
      Triple(TripleName), AsmPrinterVariant, *AsmInfo, *MII, *MRI));
  if (!IP) {
    errs() << "error: no instruction printer for target " << TripleName
      << '\n';
    return;
  }

  // FIXME: Why no MOS?
  std::unique_ptr<MCObjectDisassembler> OD(
      new MCObjectDisassembler(*Obj, *DisAsm, *MIA));
  std::unique_ptr<MCModule> Mod(OD->buildModule());
  if (EmitDOT) {
    for (MCModule::const_func_iterator FI = Mod->func_begin(),
         FE = Mod->func_end();
         FI != FE; ++FI) {
      static int filenum = 0;
      emitDOTFile((Twine((*FI)->getName()) + "_" +
                   utostr(filenum) + ".dot").str().c_str(),
                  **FI, IP.get(), *STI);
      ++filenum;
    }
  }

  StringRef ErrMsg = mcmodule2yaml(outs(), *Mod, *MII, *MRI);
  if (!ErrMsg.empty())
    errs() << "error: " << ErrMsg << '\n';
}

/// @brief Open file and figure out how to dump it.
static void DumpInput(StringRef file) {
  // If file isn't stdin, check that it exists.
  if (file != "-" && !sys::fs::exists(file)) {
    errs() << ToolName << ": '" << file << "': " << "No such file\n";
    return;
  }

  // Attempt to open the binary.
  Expected<OwningBinary<Binary>> BinaryOrErr = createBinary(file);
  if (auto E = BinaryOrErr.takeError()) {
    logAllUnhandledErrors(std::move(E), errs(),
                          (ToolName + ": '" + file + "': ").str());
    return;
  }
  Binary &Binary = *BinaryOrErr.get().getBinary();

  if (ObjectFile *o = dyn_cast<ObjectFile>(&Binary))
    DumpObject(o);
  else
    errs() << ToolName << ": '" << file << "': " << "Unrecognized file type.\n";
}

int main(int argc, char **argv) {
  // Print a stack trace if we signal out.
  sys::PrintStackTraceOnErrorSignal(/*Filename=*/StringRef());
  PrettyStackTraceProgram X(argc, argv);
  llvm_shutdown_obj Y;  // Call llvm_shutdown() on exit.

  // Initialize targets and assembly printers.
  llvm::InitializeAllTargetInfos();
  llvm::InitializeAllTargetMCs();
  llvm::InitializeAllDisassemblers();

  // Register the target printer for --version.
  cl::AddExtraVersionPrinter(TargetRegistry::printRegisteredTargetsForVersion);

  cl::ParseCommandLineOptions(argc, argv, "llvm object file CFG analyzer\n");
  TripleName = Triple::normalize(TripleName);

  ToolName = argv[0];

  // Defaults to a.out if no filenames specified.
  if (InputFilenames.size() == 0)
    InputFilenames.push_back("a.out");

  std::for_each(InputFilenames.begin(), InputFilenames.end(),
                DumpInput);

  return 0;
}
