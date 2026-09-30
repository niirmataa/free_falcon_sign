# Finite compiled-C probes of the pinned fragment, not a universal proof.
# Invoke: sage check_stable_top_mutations.sage (standard preparser).
from pathlib import Path
import hashlib
import json
import os
import subprocess

source = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
pins = {'falcon-keygen.c':'0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
        'fpr-emulated.c':'7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f',
        'fpr-emulated.h':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'}
for name,pin in pins.items():
    assert hashlib.sha256((source/name).read_bytes()).hexdigest()==pin
c=(source/'fpr-emulated.c').read_text().splitlines(keepends=True)
h=(source/'fpr-emulated.h').read_text().splitlines(keepends=True)
k=(source/'falcon-keygen.c').read_text().splitlines(keepends=True)
def lines(xs,start,count): return ''.join(xs[start-1:start-1+count])
prefix = '#include <stdint.h>\n#include <stddef.h>\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <inttypes.h>\n'
prefix += lines(h,16,40)+lines(h,77,1)+lines(h,165,10)+lines(h,176,6)
prefix += lines(c,21,34)+lines(c,150,55)+lines(c,448,107)+lines(c,680,95)+lines(c,915,86)+lines(h,86,5)
prefix += '\nstatic uint64_t raw_trace[65536];\nstatic size_t trace_count;\n'
helpers = lines(k,7453,63) # includes bitcasts, positive, and binary through7515
needle = 'ft_stable_positive_keygen(fpr x, uint32_t *bad)\n{\n'
assert helpers.count(needle)==1
helpers = helpers.replace(needle,needle+'\tif (trace_count >= 65536) abort();\n\traw_trace[trace_count ++] = x;\n')
top = lines(k,7516,27)
main = r'''
int main(void) {
    fpr roots[1024], saved[1024], leaves[1536], scratch[1024];
    uint32_t bad = 7;
    size_t i, v;
    int tail_ok = 1;
    if (sizeof(size_t)!=8 || sizeof(int)!=4 || sizeof(long)!=8 || sizeof(fpr)!=8) return 2;
    for (i=0; i<1024; i++) { roots[i]=fpr_of((int64_t)(i%7+1)); scratch[i]=fpr_one; }
    for (v=0; v<256; v++) {
        roots[3*v]=UINT64_C(0x4340000000000000);
        roots[3*v+1]=fpr_of((int64_t)(v%7+1));
        roots[3*v+2]=fpr_of((int64_t)(v%3+1));
    }
    for (i=0; i<1536; i++) leaves[i]=UINT64_C(0x3ff0000000000000)+i;
    memcpy(saved,roots,sizeof roots);
    ft_stable_top_branch_keygen(roots,leaves,scratch,&bad);
    for (i=768; i<1536; i++) if (leaves[i]!=UINT64_C(0x3ff0000000000000)+i) tail_ok=0;
    printf("RESULT %u %zu %d %d\n",bad,trace_count,memcmp(saved,roots,sizeof roots)==0,tail_ok);
    for (i=0; i<1536; i++) printf("%016" PRIx64 "\n",(uint64_t)leaves[i]);
    for (i=0; i<trace_count; i++) printf("%016" PRIx64 "\n",raw_trace[i]);
    return 0;
}
'''
def replace_once(text,a,b):
    assert text.count(a)==1,(a,text.count(a))
    return text.replace(a,b)
swap = replace_once(top,'leaves[v] =','LEAF_FIRST_SLOT =')
swap = replace_once(swap,'leaves[256 + v] =','leaves[v] =')
swap = replace_once(swap,'LEAF_FIRST_SLOT =','leaves[256 + v] =')
variants = {
    'baseline':top,
    'u_step_2':replace_once(top,'u += 3','u += 2'),
    'v_step_2':replace_once(top,'v ++','v += 2'),
    'swapped_store_offsets':swap,
    'omitted_e1_check':replace_once(top,'e1 = ft_stable_positive_keygen(fpr_add(fpr_add(a, b), c), bad);','e1 = fpr_add(fpr_add(a, b), c);'),
    'right_associated_e1':replace_once(top,'fpr_add(fpr_add(a, b), c)','fpr_add(a, fpr_add(b, c))'),
    'abc_add_instead_of_mul':replace_once(top,'abc = ft_stable_positive_keygen(fpr_mul(ab, c), bad);','abc = ft_stable_positive_keygen(fpr_add(ab, c), bad);'),
    'reset_bad_between_branches':replace_once(top,'ft_stable_binary_inplace_keygen(leaves + 0, 256, scratch, bad);','ft_stable_binary_inplace_keygen(leaves + 0, 256, scratch, bad);\n\t*bad = 0;'),
    'wrong_second_binary_address':replace_once(top,'ft_stable_binary_inplace_keygen(leaves + 256, 256, scratch, bad);','ft_stable_binary_inplace_keygen(leaves + 0, 256, scratch, bad);'),
}
binary_checks=ZZ(1)
for depth in range(8): binary_checks=6*2^depth+2*binary_checks
expected_checks=12*256+3*binary_checks
rows=[]
def digest(data): return hashlib.sha256(data).hexdigest()
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    baseline=None
    for name,fragment in variants.items():
        stem=Path(mode+'_'+name)
        cfile=stem.with_suffix('.c'); binary=stem.with_suffix('.bin')
        cfile.write_text(prefix+helpers+fragment+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+[str(cfile),'-o',str(binary)]
        cp=subprocess.run(command,capture_output=True,check=False)
        stem.with_suffix('.compile.stdout').write_bytes(cp.stdout)
        stem.with_suffix('.compile.stderr').write_bytes(cp.stderr)
        assert cp.returncode==0 and not cp.stderr,(mode,name,cp.stderr.decode())
        p=subprocess.run([str(binary.resolve())],capture_output=True,check=False)
        stem.with_suffix('.stdout').write_bytes(p.stdout)
        stem.with_suffix('.stderr').write_bytes(p.stderr)
        assert p.returncode==0 and not p.stderr,(mode,name,p.stderr.decode())
        data=p.stdout.decode().splitlines(); head=data[0].split()
        bad,count,roots_ok,tail_ok=map(ZZ,head[1:])
        assert len(data)==1+1536+count
        leaf_hash=digest(('\n'.join(data[1:1537])+'\n').encode())
        trace_hash=digest(('\n'.join(data[1537:])+'\n').encode())
        signature=(bad,count,leaf_hash,trace_hash)
        if name=='baseline':
            assert bad==7 and count==expected_checks and roots_ok==1 and tail_ok==1
            baseline=signature
        else:
            assert signature!=baseline,(mode,name,'mutant survived')
        rows.append({'mode':mode,'variant':name,'bad':int(bad),'checks':int(count),'roots_intact':bool(roots_ok),
            'outside_leaves_intact':bool(tail_ok),'leaf_sha256':leaf_hash,'trace_sha256':trace_hash,
            'c_source_sha256':digest(cfile.read_bytes()),'stdout_sha256':digest(p.stdout),
            'detected':name!='baseline'})
Path('STABLE_TOP_MUTATIONS.json').write_text(json.dumps({'scope':'finite probes only; pinned C plus trace instrumentation',
    'source_pins':pins,'expected_checks':int(expected_checks),'rows':rows},indent=2)+'\n')
print('COMPILED_MUTATIONS_PASS',len(rows),'executions;',2*(len(variants)-1),'mutants detected; baseline checks=',expected_checks)
