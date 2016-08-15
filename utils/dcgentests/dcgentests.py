#!/usr/bin/env python

import argparse
import subprocess

# FIXME: Insert final 'retq'
# FIXME: Provide a stable ordering for opcodes, to avoid spurious changes when
# LLVM instr names change (see FMA change).  For instance: order by encoding?

def parseOutput(l):
    lines = l.split('\n')

    if lines[0].startswith('\t### '):
        name = lines[0][len('\t### '):]
        lines = lines[1:]
    else:
        name = "<?>"

    if lines[-1] != '':
        return None,None,None
    else:
        lines = lines[:-1]

    if lines[-1].strip().startswith('## imm'):
        lines = lines[:-1]

    if lines[0] != '\t.section\t__TEXT,__text,regular,pure_instructions':
        return None,None,None

    asm = lines[1].strip()

    if asm.startswith('#'):
        return None,None,None

    asm,encoding = asm.split('#', 1)
    asm = asm.rstrip()

    assert encoding.startswith('# encoding: [')
    encoding = encoding[len('# encoding: ['):-1]

    return name,asm,encoding


def tryReencodingWithLargerImmediate(mc_cmd, as_cmd, i, imm):
    immarg = ' -list-imm-val=' + str(imm)
    try:
        stdout = subprocess.check_output(mc_cmd + ' -list-start-opc=' + str(i)+\
                                         immarg, shell=True)
    except subprocess.CalledProcessError:
        return None,None
    _,immasm,immencoding = parseOutput(stdout)

    if not immasm:
        return None,None

    stdout = subprocess.check_output("echo '" + immasm + "'|" + as_cmd + immarg,
                                     shell=True)
    _,immreasm,immreencoding = parseOutput(stdout)

    if immencoding != immreencoding:
        return None,None
    return immasm,immencoding

def parseManualList(manual_list):
    trie = {}
    with open(manual_list) as f:
        for l in f:
            l = l.rstrip()
            group = l.replace('/', '_')
            names = l.split('/')
            for name in names:
                subtrie = trie
                for c in name:
                    if c not in subtrie:
                        subtrie[c] = {}
                    subtrie = subtrie[c]
                subtrie["group"] = group
    return trie

def findGroupInTrie(trie, name):
    group = ""
    for c in name:
        if not c in trie:
            return group
        trie = trie[c]
        if "group" in trie:
            group = trie["group"]
    return group

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--llvm-obj', help='The build dir to use')
    parser.add_argument('--manual-list', help='A list of instructions from the ref')
    parser.add_argument('--output-dir', help='The directory where to store the output files')
    args = parser.parse_args()

    mnemonic_trie = parseManualList(args.manual_list)

    mc_cmd = 'echo | ' + args.llvm_obj + '/bin/llvm-mc'
    mc_cmd += ' -x86-asm-syntax=att -show-encoding -output-asm-variant=0'
    mc_cmd += ' -list-insts -list-num-opc=1'

    intel_mc_cmd = 'echo | ' + args.llvm_obj + '/bin/llvm-mc'
    intel_mc_cmd += ' -x86-asm-syntax=intel -show-encoding -output-asm-variant=1'
    intel_mc_cmd += ' -list-insts -list-num-opc=1'

    as_cmd = args.llvm_obj + '/bin/llvm-mc'
    as_cmd += ' -x86-asm-syntax=att -show-encoding -output-asm-variant=0'

    dis_cmd = args.llvm_obj + '/bin/llvm-mc -disassemble'
    dis_cmd += ' -x86-asm-syntax=intel -show-encoding -output-asm-variant=1'

    # FIXME: Get the opcodes from the .inc.
    for i in range(27, 14879):
        # Figure out the MC instruction name.
        realname = subprocess.check_output('grep -m1 "\t= ' + str(i) + '," "' +\
                args.llvm_obj + '/lib/Target/X86/X86GenInstrInfo.inc" | ' + \
                'cut -f1', shell=True).strip()

        print "Trying", str(i), ":", realname

        # Try to generate one asm string for that instruction.
        try:
            with open('/dev/null') as null:
                stdout = subprocess.check_output(mc_cmd + ' -list-start-opc=' +\
                                                 str(i), shell=True, stderr=None)
        except subprocess.CalledProcessError:
            continue

        if not stdout.strip():
            continue

        name,asm,encoding = parseOutput(stdout)

        if not name or not asm or not encoding:
            continue
        assert name == realname

        # Ignore things with relocations, as it's usually branches that we don't
        # have an easy way of automatically testing anyway.
        if 'fixup' in stdout:
            print "Ignoring generated fixup:", asm
            continue

        # Assemble what we just generated to figure out if the encoding maps
        # maps to another instruction.
        p = subprocess.Popen(as_cmd, shell=True, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        (stdout,stderr) = p.communicate(asm)
        if 'error: instruction requires: Not 64-bit mode' in stderr:
            continue
        if 'error: instruction requires: AVX-512' in stderr:
            continue
        if 'only available with AVX512' in stderr:
            continue
        if 'error:' in stderr:
            continue

        _,reasm,reencoding = parseOutput(stdout)

        # If the encoding is different, try to understand why.
        if encoding != reencoding:
            # First, try larger immediates: the one we used might be too small
            # to require the encoding we want.
            # FIXME: pick better immediates?  e.g., for i16
            immasm,immencoding = tryReencodingWithLargerImmediate(mc_cmd, as_cmd,
                                                                  i, 0x12345678)
            if immasm and immencoding:
                # If the immediate worked, use that.
                asm = immasm
                encoding = immencoding
            else:
                # Otherwise, this doesn't have a unique asm string. Use .byte.
                asm = '.byte ' + encoding.replace(',', '; .byte ')


        # Finally, get the Intel mnemonic.
        p = subprocess.Popen(dis_cmd, shell=True, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        (stdout,stderr) = p.communicate(encoding)

        # Also do a final valid encoding check: we might have missed predicates.
        if 'invalid' in stderr:
            continue

        _,intel_asm,_ = parseOutput(stdout)

        # Group the instruction using the SDM pages and the Intel mnemonic.
        mnemonic = ""
        if '<unknown>' not in stdout:
            mnemonic = intel_asm.split()[0]
            mnemonic_group = findGroupInTrie(mnemonic_trie, mnemonic)
            if not mnemonic_group:
                mnemonic_group = mnemonic
            output_file = mnemonic_group + '.s'
        else:
            output_file = 'other.s'

        # Finally, append it to the inferred mnemonic-group .s file.
        with open(args.output_dir + '/' + output_file, 'a') as o:
            o.write('## ' + name)
            if '.byte' in asm:
                o.write(':\t' + reasm)
            o.write('\n' + asm + '\n')

        print "Done", name, ":",  mnemonic

if __name__ == '__main__':
  main()
