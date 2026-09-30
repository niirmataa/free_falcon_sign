# Public synthetic C-fragment probes. Standard Sage preparser, no KeyGen.
from pathlib import Path
import hashlib, json, os, subprocess
root=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
pins={'falcon-keygen.c':'0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
      'fpr-emulated.c':'7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f',
      'fpr-emulated.h':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'}
for name,pin in pins.items(): assert hashlib.sha256((root/name).read_bytes()).hexdigest()==pin
c=(root/'fpr-emulated.c').read_text().splitlines(keepends=True)
h=(root/'fpr-emulated.h').read_text().splitlines(keepends=True)
k=(root/'falcon-keygen.c').read_text().splitlines(keepends=True)
def lines(xs,start,count): return ''.join(xs[start-1:start-1+count])
def replace(text,a,b):
    assert text.count(a)==1,(a,text.count(a))
    return text.replace(a,b)
headers='#include <stdint.h>\n#include <stddef.h>\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <inttypes.h>\n'
base=headers+lines(h,16,40)+lines(h,77,1)+lines(h,165,10)+lines(h,176,6)
base+=lines(c,21,34)+lines(c,150,55)+lines(c,448,107)+lines(c,680,95)+lines(c,915,86)+lines(h,86,5)
base+='\nstatic uint64_t tr_word[65536]; static unsigned tr_kind[65536]; static size_t tr_len;\n'
base+='static void record(unsigned kind,uint64_t w) { if(tr_len>=65536) abort(); tr_kind[tr_len]=kind; tr_word[tr_len++]=w; }\n'
helpers=lines(k,7453,90)
helpers=replace(helpers,'ft_stable_positive_keygen(fpr x, uint32_t *bad)\n{\n',
    'ft_stable_positive_keygen(fpr x, uint32_t *bad)\n{\n\trecord(0,x);\n')
base+=helpers
macros=lines(k,7444,3)
suffix=lines(k,7757,20)
scan_marker='for (u = 0; u < n; u ++) {'
rev_assignment=lines(k,7762,2).strip()
scan_assignment='leaves[u] = ft_stable_positive_keygen(leaves[u], &bad);'
variants={
    'baseline':(macros,suffix),
    'forward_768_plus_u':(macros,replace(suffix,'leaves[n - 1 - u]','leaves[768 + u]')),
    'reverse_767':(macros,replace(suffix,'u < hn','u < 767')),
    'reverse_769':(macros,replace(suffix,'u < hn','u < 769')),
    'wrong_q_squared':(replace(macros,'339775489','339775490'),suffix),
    'swapped_div_args':(macros,replace(suffix,'fpr_div(q_squared, leaves[u])','fpr_div(leaves[u], q_squared)')),
    'overwrite_first_half':(macros,replace(suffix,'leaves[n - 1 - u]','leaves[u]')),
    'omit_reverse_control':(macros,replace(suffix,rev_assignment,'leaves[n - 1 - u] = fpr_div(q_squared, leaves[u]);')),
    'omit_scan_control':(macros,replace(suffix,scan_assignment,'leaves[u] = leaves[u];')),
    'omit_range_bad_update':(macros,replace(suffix,'bad |= valid ^ 1U;','bad |= 0;')),
    'reset_bad_between_stages':(macros,replace(suffix,scan_marker,'bad = 0;\n\t\t'+scan_marker)),
    'strict_min':(macros,replace(suffix,'- FT1536_LEAF_MIN_BITS) >> 63','- FT1536_LEAF_MIN_BITS - 1) >> 63')),
    'strict_max':(macros,replace(suffix,'- bits) >> 63','- bits - 1) >> 63')),
    'wrong_return':(macros,replace(suffix,'return bad == 0;','return bad != 0;')),
}
def instrument(fragment):
    # Both range expressions are retained; record their exact input bits.
    fragment=replace(fragment,'valid &= (uint32_t)', 'record(1,bits);\n\t\t\tvalid &= (uint32_t)')
    if 'bad |= valid ^ 1U;' in fragment:
        fragment=replace(fragment,'bad |= valid ^ 1U;','record(2,bits); (void)valid;\n\t\t\tbad |= valid ^ 1U;')
    else:
        fragment=replace(fragment,'bad |= 0;','record(2,bits); (void)valid;\n\t\t\tbad |= 0;')
    fragment=replace(fragment,'return bad ', '*bad_io = bad;\n\t\treturn bad ')
    return fragment
def wrapped(fragment):
    full='static int suffix_test(const fpr *g00,fpr *t3,uint32_t *bad_io) {\n'
    full+='size_t n=1536, hn=768, u; fpr *leaves,*scratch,q_squared; uint32_t bad=*bad_io; (void)hn;\n'+instrument(fragment)+'\n}\n'
    scan=fragment[fragment.index(scan_marker):]
    full+='static int scan_test(fpr *leaves,uint32_t *bad_io) { size_t n=1536,u; uint32_t bad=*bad_io;\n'+instrument(scan)+'\n}\n'
    return full
main=r'''
int main(int argc,char **argv) {
    fpr roots[768],saved[768],buf[1808]; uint32_t bad=0;
    size_t i; int ret,tail_ok=1,which;
    if(argc!=2 || sizeof(size_t)!=8 || sizeof(int)!=4 || sizeof(long)!=8 || sizeof(fpr)!=8) return 2;
    which=atoi(argv[1]);
    for(i=0;i<768;i++) {
        if(which==2) roots[i]=0;
        else if(which==5) roots[i]=fpr_one;
        else roots[i]=fpr_of(18433+(which==1 ? (int64_t)((i*13+5)%19)-9 : 0));
    }
    for(i=0;i<1808;i++) buf[i]=0;
    for(i=1792;i<1808;i++) buf[i]=UINT64_C(0x55aa001122330000)+i;
    if(which==3) bad=7;
    memcpy(saved,roots,sizeof roots);
    if(which==4) {
        for(i=0;i<1536;i++) buf[i]=(i&1) ? FT1536_LEAF_MAX_BITS : FT1536_LEAF_MIN_BITS;
        ret=scan_test(buf,&bad);
    } else ret=suffix_test(roots,buf,&bad);
    for(i=1792;i<1808;i++) if(buf[i]!=UINT64_C(0x55aa001122330000)+i) tail_ok=0;
    printf("RESULT %d %u %zu %d %d\n",ret,bad,tr_len,memcmp(saved,roots,sizeof roots)==0,tail_ok);
    for(i=0;i<1808;i++) printf("%016" PRIx64 "\n",(uint64_t)buf[i]);
    for(i=0;i<tr_len;i++) printf("%u %016" PRIx64 "\n",tr_kind[i],tr_word[i]);
    return 0;
}
'''
def sha(b): return hashlib.sha256(b).hexdigest()
rows=[]; detections={}
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    baselines={}
    for name,(defs,fragment) in variants.items():
        stem=Path(mode+'_'+name); cfile=stem.with_suffix('.c'); binary=stem.with_suffix('.bin')
        cfile.write_text(base+defs+wrapped(fragment)+main)
        cmd=['gcc','-std=c99','-Wall','-Wextra','-Werror']+flags+[str(cfile),'-o',str(binary)]
        cp=subprocess.run(cmd,capture_output=True,check=False)
        stem.with_suffix('.compile.stdout').write_bytes(cp.stdout); stem.with_suffix('.compile.stderr').write_bytes(cp.stderr)
        assert cp.returncode==0 and not cp.stderr,(mode,name,cp.stderr.decode())
        caught=[]
        for case in range(6):
            p=subprocess.run([str(binary.resolve()),str(case)],capture_output=True,check=False)
            case_stem=Path(str(stem)+'_case'+str(case))
            case_stem.with_suffix('.stdout').write_bytes(p.stdout); case_stem.with_suffix('.stderr').write_bytes(p.stderr)
            assert p.returncode==0 and not p.stderr,(mode,name,case,p.stderr.decode())
            data=p.stdout.decode().splitlines(); ret,bad,count,roots_ok,tail_ok=map(ZZ,data[0].split()[1:])
            assert len(data)==1+1808+count
            memory=sha(('\n'.join(data[1:1809])+'\n').encode()); trace=sha(('\n'.join(data[1809:])+'\n').encode())
            signature=(ret,bad,count,memory,trace)
            if name=='baseline':
                assert ret==([1,1,0,0,1,0][case]),(case,ret,bad)
                assert roots_ok==1 and tail_ok==1
                assert count==(4608 if case==4 else 27648)
                baselines[case]=signature
            elif signature!=baselines[case]: caught.append(int(case))
            rows.append({'mode':mode,'variant':name,'case':int(case),'return':int(ret),'bad':int(bad),'checks':int(count),
                'roots_intact':bool(roots_ok),'outside_buffer_intact':bool(tail_ok),'memory_sha256':memory,'trace_sha256':trace,
                'source_sha256':sha(cfile.read_bytes()),'stdout_sha256':sha(p.stdout)})
        if name!='baseline':
            assert caught,(mode,name,'mutant survived all public cases')
            detections[mode+'/'+name]=caught
Path('CERTIFICATE_SUFFIX_MUTATIONS.json').write_text(json.dumps({'scope':'public synthetic fragment only; finite diagnostics',
    'source_pins':pins,'cases':['uniform_q_return1','varying_return1','zeros_return0','prior_bad7_return0','scan_inclusive_endpoints_return1','positive_ones_range_return0'],
    'detections':detections,'rows':rows},indent=2)+'\n')
print('CERTIFICATE_MUTATIONS_PASS',len(rows),'executions',len(detections),'mutants detected; return0 and return1 covered')
