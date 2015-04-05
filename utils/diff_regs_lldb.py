#!/usr/bin/python

import lldb
import os
import sys

def get_reglist(regset):
    reglist = []
    for regs in regset:
        if 'general purpose registers' in regs.name.lower():
            GPRs = regs
            continue
        if 'floating point registers' in regs.name.lower():
            FPRs = regs
            continue

    for reg in GPRs:
        n = str(reg.name)
        s = str(reg.value)[2:]
        # We really don't care about rflags
        if n == "rflags":
            n = "eflags"
            s = s[8:]
            # Mask out AF, which we don't really generate
            s = format('%.8x') % (reg.unsigned & 0xFFFFFFEF)
        elif n == "rip":
            continue
        elif reg.size != 8:
            continue
        reglist.append((n, s))

    for reg in FPRs:
        n = str(reg.name)
        s = ""
        # Flip, to match endianness of GPRs.
        for u in reg.data.uint8s:
            s = (format('%.2x') % u) + s
        if n.startswith("xmm"):
            continue
        if n.startswith("ymm"):
            n = "z" + n[1:]
            s = ('0'*64) + s
        reglist.append((n, s))
    return reglist

def print_reglist(reglist):
    for r,v in reglist:
        print r, "=", v

def print_regs_diff(sym, regset1, regset2):
    print "Different Registers for '%s':" % sym.name
    for (r1,v1),(r2,v2) in zip(regset1, regset2):
        if v1 != v2:
            print r1.upper(), '=', v2

def create_breakpoint(fn):
    return target.BreakpointCreateByName(fn, target.GetExecutable().GetFilename())

# Set the path to the executable to debug
if len(sys.argv) == 1:
    exe = "./a.out"
else:
    exe = ' '.join(sys.argv[1:])

# Create a new debugger instance
debugger = lldb.SBDebugger.Create()

# When we step or continue, don't return from the function until the process
# stops. Otherwise we would have to handle the process events ourselves which, while doable is
# a little tricky.  We do this by setting the async mode to false.
debugger.SetAsync(False)

target = debugger.CreateTargetWithFileAndArch(exe, lldb.LLDB_ARCH_DEFAULT)

if not target:
    print "Unable to create target:", exe
    sys.exit(1)

module = None
for m in target.module_iter():
    if not m.GetFileSpec().dirname.startswith("/usr/"):
        module = m

for seg in module.section_iter():
    if seg.GetName() == "__TEXT":
        for sec in seg:
            if sec.GetName() == "__text":
                for sym in module.symbol_in_section_iter(sec):
                    if sym.GetName().startswith("test_"):
                        create_breakpoint(sym.GetName())
                break
        break

# Launch the process. Since we specified synchronous mode, we won't return
# from this function until we hit the breakpoint at main
process = target.LaunchSimple (None, None, os.getcwd())

global saved_regset
saved_regset = None

# FIXME: better track breakpoints?

# Make sure the launch went ok
while process.GetState() == lldb.eStateStopped:
    # Print some simple process info
    thread = process.GetThreadAtIndex(0)
    frame = thread.GetFrameAtIndex(0)
    regset = frame.GetRegisters()
    saved_reglist = get_reglist(regset)
    symbol = frame.GetSymbol();
    thread.StepOut()

    if process.GetState() == lldb.eStateStopped:
        thread = process.GetThreadAtIndex(0)
        frame = thread.GetFrameAtIndex(0)
        regset = frame.GetRegisters()
        new_reglist = get_reglist(regset)
        print_regs_diff(symbol, saved_reglist, new_reglist)
    process.Continue()
