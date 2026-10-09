"""BATCH_043 finite SAME-material common-seam/test/division controls.

Sage preparser, exact ZZ/Zmod arithmetic, public synthetic vectors only.
Local C/UBSan diagnostics use the approved live Extra/c include closure;
no complete historical M0 build or inverse/equation proof is claimed.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

old = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])
repo = next(p for p in old.parents if (p/'Extra/c/falcon-vrfy.c').exists())
root = repo/'Extra/c'
profile_path = old/'inputs/source/PROFILE.json'
profile = json.loads(profile_path.read_text())
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
names = ['falcon-vrfy.c','internal.h','falcon.h','shake.h','fpr-emulated.h']
historical = {name:profile['core']['source_files'][name] for name in names}
pins = {name:digest(root/name) for name in names}
for name in names:
    if name!='fpr-emulated.h': assert pins[name]==historical[name],name
assert historical['fpr-emulated.h']=='242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'
assert pins['fpr-emulated.h']=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
headers = {'actual_source_pins':pins,'historical_m0_pins':historical,
    'differences':{name:{'m0':historical[name],'actual':pins[name]} for name in names if historical[name]!=pins[name]},
    'owner_decision':'Inherited039 live Extra/c header decision; identical include bytes rechecked.',
    'scope':'Local public arithmetic diagnostic, not a complete historical M0 build.'}
Path('PUBLIC_SUFFIX_HEADERS.json').write_text(json.dumps(headers,indent=2)+'\n')
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
def once(text, before, after):
    assert text.count(before)==1,before
    return text.replace(before,after,int(1))

q=ZZ(18433);n=ZZ(1536);base=power_mod(ZZ(25),2,q)
def rev(x,bits):
    value=ZZ(0)
    for j in range(bits): value=2*value+((x>>j)&1)
    return value
def exponent(i):
    k=ZZ(i.nbits()-1);j=i-2^k;u=rev(j,k)
    return (1 if k==9 else 3*2^(8-k))*(3*u+1+u%2)
points=[power_mod(base,exponent(ZZ(512+i//3))+1536*(i%3),q) for i in range(n)]
assert len(set(points))==n
P=PolynomialRing(Zmod(q),'X')
pairs=[]
for position,sign in [(0,1),(0,-1),(1,1),(767,-1),(768,1),(1535,-1)]:
    f=[ZZ(0)]*int(n);f[position]=ZZ(sign)
    g=[ZZ((i*7+position)%3)-1 for i in range(n)]
    pairs.append((f,g))
pairs.append(([ZZ(0)]*int(n),[ZZ((i*11)%3)-1 for i in range(n)]))
# This deterministic full-ternary vector exercises nontrivial early rejection
# if any evaluation vanishes; its expected outcome is computed, not assumed.
pairs.append(([ZZ((i*11)%3)-1 for i in range(n)],[ZZ((i*7+1)%3)-1 for i in range(n)]))
references=[]
for f,g in pairs:
    F=P(f);G=P(g)
    fv=[ZZ(F(P.base_ring()(r))) for r in points]
    gv=[ZZ(G(P.base_ring()(r))) for r in points]
    zeros=[i for i in range(n) if fv[i]==0]
    stop=zeros[0] if zeros else n
    quotients=[gv[i]*inverse_mod(fv[i],q)%q for i in range(stop)]
    references.append({'f':fv,'g':gv,'stop':stop,'quotients':quotients})
assert all(r['stop']==n for r in references[:6]) and references[6]['stop']==0
fixture={'pairs':pairs,'points':points,'references':references}
Path('PUBLIC_SUFFIX_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')

source=(root/'falcon-vrfy.c').read_text()
start=source.index('int\nfalcon_compute_public(uint16_t *h,\n')
end=source.index('\n}\n',start)+len('\n}\n')
body=source[start:end]
support=r'''
#include <stdio.h>
static size_t active_case, tested_count;
static void dump_suffix(const char *tag,const uint16_t *a){
 printf("%s %zu",tag,active_case);
 for(size_t i=0;i<1536;i++)printf(" %u",(unsigned)a[i]);
 printf("\n");
}
'''
body=once(body,'\tmq_NTT(t, logn, ternary);\n',
    '\tmq_NTT(t, logn, ternary);\n\tdump_suffix("G",h);dump_suffix("F",t);tested_count=0;\n')
body=once(body,'\t\tif (t[u] == 0) {\n','\t\tprintf("T %zu %zu %u\\n",active_case,u,(unsigned)t[u]);tested_count++;\n\t\tif (t[u] == 0) {\n')
body=once(body,'\t\t\t: mq_div_12289(h[u], t[u]);\n',
    '\t\t\t: mq_div_12289(h[u], t[u]);\n\t\tprintf("Q %zu %zu %u\\n",active_case,u,(unsigned)h[u]);\n')
body=once(body,'\tmq_iNTT(h, logn, ternary);\n',
    '\tdump_suffix("D",h);dump_suffix("K",t);\n\tmq_iNTT(h, logn, ternary);\n')
instrumented=source[:start]+support+body+source[end:]
variants={
    'baseline':instrumented,
    'wrong_denominator':once(instrumented,'? mq_div_18433(h[u], t[u])','? mq_div_18433(h[u], h[u])'),
    'wrong_division_scale':once(instrumented,'? mq_div_18433(h[u], t[u])','? mq_montymul(h[u], t[u], Qt, Q0It)'),
    'wrong_start_counter':once(instrumented,'tested_count=0;\n\tfor (u = 0; u < n; u ++)','tested_count=0;\n\tfor (u = 1; u < n; u ++)'),
    'skipped_zero_rejection':once(instrumented,'if (t[u] == 0) {','if (t[u] == 0 && active_case == 9999) {'),
    'corrupt_g_at_common_seam':once(instrumented,'dump_suffix("G",h);dump_suffix("F",t);','h[17]=mq_add(h[17],1,Qt);dump_suffix("G",h);dump_suffix("F",t);')}
arrays='static const int16_t fs[][1536]={'+','.join('{'+','.join(str(x) for x in f)+'}' for f,g in pairs)+'};\n'
arrays+='static const int16_t gs[][1536]={'+','.join('{'+','.join(str(x) for x in g)+'}' for f,g in pairs)+'};\n'
main=r'''
int main(void){
 setvbuf(stdout,NULL,_IONBF,0);
 for(size_t c=0;c<sizeof fs/sizeof fs[0];c++){
  struct{uint16_t lo,h[1536],hi;} object;object.lo=object.hi=60000;active_case=c;
  int result=falcon_compute_public(object.h,fs[c],gs[c],10,1);
  printf("R %zu %d %zu %u %u\n",c,result,tested_count,(unsigned)object.lo,(unsigned)object.hi);
 }
 return 0;
}
'''
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,modified in variants.items():
        label=mode+'_'+variant;cfile=Path(label+'.c');binary=Path(label+'.bin');deps=Path(label+'.d')
        cfile.write_text(modified+arrays+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
            '-I',str(root),str(cfile),'-MMD','-MF',str(deps),'-Wl,--gc-sections','-o',str(binary)]
        built=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(built.stdout);Path(label+'.compile.stderr').write_bytes(built.stderr)
        assert built.returncode==0 and not built.stdout and not built.stderr,label
        dependencies={Path(p).resolve() for p in deps.read_text().split(':',int(1))[1].replace('\\\n',' ').split()}
        assert dependencies=={cfile.resolve()}|{(root/name).resolve() for name in names if name!='falcon-vrfy.c'},dependencies
        for name in names: assert digest(root/name)==pins[name],name
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
        Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
        assert ran.returncode==0 and not ran.stderr,label
        seen=set();differences=[];counts={tag:ZZ(0) for tag in ['G','F','T','Q','D','K','R']}
        for line in ran.stdout.decode().splitlines():
            tag,*payload=line.split();a=[ZZ(x) for x in payload];case=a[0];ref=references[int(case)];counts[tag]+=1
            index=a[1] if tag in ['T','Q'] else ZZ(0);key=(tag,case,index)
            assert key not in seen;seen.add(key)
            if tag in ['G','F','K']:
                expected=ref['g'] if tag=='G' else ref['f']
                ok=a[1:]==expected
            elif tag=='T': ok=index<=ref['stop'] and index<n and a[2]==ref['f'][int(index)]
            elif tag=='Q': ok=index<ref['stop'] and a[2]==ref['quotients'][int(index)]
            elif tag=='D': ok=ref['stop']==n and a[1:]==ref['quotients']
            elif tag=='R':
                stop=ref['stop'];ok=a[1:]==[int(stop==n),min(stop+1,n),60000,60000]
            else: raise AssertionError(tag)
            if not ok: differences.append({'tag':tag,'case':case,'index':index})
        if variant=='baseline':
            assert not differences,(label,differences[:3])
            expected_tests=sum(min(r['stop']+1,n) for r in references)
            expected_quotients=sum(r['stop'] for r in references)
            assert counts['T']==expected_tests and counts['Q']==expected_quotients
            for c,ref in enumerate(references):
                for i in range(min(ref['stop']+1,n)): assert ('T',ZZ(c),ZZ(i)) in seen
                for i in range(ref['stop']): assert ('Q',ZZ(c),ZZ(i)) in seen
        else:
            assert differences,label
            target='R' if variant in ['wrong_start_counter','skipped_zero_rejection'] else 'G' if variant=='corrupt_g_at_common_seam' else 'Q'
            assert any(d['tag']==target for d in differences),(label,target)
        artifacts=[cfile,deps,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'counts':counts,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
result={'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,'source_pins':pins,
    'header_binding_sha256':digest('PUBLIC_SUFFIX_HEADERS.json'),'profile_sha256':digest(profile_path),
    'fixture_sha256':digest('PUBLIC_SUFFIX_FIXTURE.json'),'pairs':int(len(pairs)),
    'successful_pairs':int(sum(r['stop']==n for r in references)),
    'baseline_tests_per_mode':int(sum(min(r['stop']+1,n) for r in references)),
    'baseline_quotients_per_mode':int(sum(r['stop'] for r in references)),
    'scope':'Finite common afterT original evaluations, every chronological test and quotient, t preservation at inverse entry, success/rejection counts, five mutations per normal/UBSan mode. Inverse runs but its output is NOT checked or promoted to a kernel inverse/equation theorem.'}
Path('PUBLIC_SUFFIX_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
