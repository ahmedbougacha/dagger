#!/usr/bin/env python

import argparse
import itertools
import re
import subprocess

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--llvm-obj', help='The build dir to use')
    parser.add_argument('tests', nargs='+')
    args = parser.parse_args()

    mc_cmd = args.llvm_obj + '/bin/llvm-mc -triple x86_64--darwin -filetype=obj -o - '
    dec_cmd = args.llvm_obj + '/bin/llvm-dec - ' + \
            '-dc-translate-unknown-to-undef -enable-dc-reg-mock-intrin'

    valuse_re = re.compile(r'(%[-a-zA-Z$._0-9]+)')
    valdef_re = re.compile(r'%([-a-zA-Z$._0-9]+) = ')
    getreg_re = re.compile(r'call .* @llvm\.dc\.getreg\..*\(metadata !"([A-Z0-9]+)"\)')
    setrip_re = re.compile(r'call void @llvm\.dc\.setreg\..*, metadata !"RIP"\)')

    for test in args.tests:
        with open(test) as f:
            raw_test_lines = [l.rstrip() for l in f]

        test_lines = raw_test_lines

        print '# RUN: llvm-mc -triple x86_64--darwin -filetype=obj -o - %s' \
                ' | llvm-dec - -dc-translate-unknown-to-undef' \
                ' -enable-dc-reg-mock-intrin | FileCheck %s\n'
        # run llvm-dec and get the output
        try:
            with open(test) as f:
                out = subprocess.check_output(mc_cmd + test + ' | ' + dec_cmd,
                                              shell=True, stdin=f)
        except subprocess.CalledProcessError:
            print '# XFAIL: *\n'
            print "\n".join(raw_test_lines)
            continue

        out_lines = [l.strip() for l in out.split('\n')]

        # group the output by instruction
        def addrkey(l):
            startinstcall = 'call void @llvm.dc.startinst(i64 '
            if l.startswith(startinstcall):
                addrkey.cur_addr = int(l[len(startinstcall):-1])
            return addrkey.cur_addr
        addrkey.cur_addr = -1
        inst_blocks = [list(g)[1:] for k,g in itertools.groupby(out_lines, addrkey)]

        # ignore non-inst groups: the first doesn't correspond to an instruction,
        # and the last is "retq", which works as our end-of-inst marker.
        inst_blocks = inst_blocks[1:-1]

        # now look for value names, replace them in the strings
        new_inst_blocks = []
        for i in inst_blocks:
            val_to_pat_id = {}
            unnamed_pat_id = 0
            named_pat_ids = {}
            new_inst_blocks.append([])
            for l in i:
                pat_id = None
                md = valdef_re.match(l)
                if not md:
                    ms = setrip_re.match(l)
                    if not ms:
                        inst = l
                    else:
                        inst = 'call void @llvm.dc.setreg{{.*}} !"RIP")'
                else:
                    inst = l[len(md.group()):]

                    # come up with a good name for the pattern
                    mr = getreg_re.match(inst)
                    if mr:
                        reg_name = mr.group(1)
                        if reg_name not in named_pat_ids:
                            named_pat_ids[reg_name] = 0
                        pat_id = reg_name + "_" + str(named_pat_ids[reg_name])
                        named_pat_ids[reg_name] += 1
                    else:
                        pat_id = "V" + str(unnamed_pat_id)
                        unnamed_pat_id += 1
                    val_to_pat_id[md.group(1)] = pat_id

                # look for value uses in the remaining string and replace them
                if pat_id:
                    new_inst = "[[" + pat_id + ":%.+]] = "
                else:
                    new_inst = ""
                for u in valuse_re.split(inst):
                    if u.startswith('%'):
                        new_inst += "[[" + val_to_pat_id[u[1:]] + "]]"
                    else:
                        new_inst += u
                new_inst_blocks[-1].append(new_inst)

        # finally, print the new file with the check lines
        ni = iter(new_inst_blocks)

        for l in test_lines:
            if not l or l.startswith('# CHECK'):
                continue
            if l.startswith('#'):
                print l
                continue
            if l != 'retq':
                new_inst = ni.next()
                print '# CHECK-LABEL: call void @llvm.dc.startinst'
                for c in new_inst:
                    print '# CHECK-NEXT: ' + c
            print l
            if l != 'retq':
                print


if __name__ == '__main__':
  main()
