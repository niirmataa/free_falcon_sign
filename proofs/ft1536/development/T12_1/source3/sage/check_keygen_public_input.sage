"""Exact finite same-f/g conversion and first-value controls, BATCH_039.

Public source is byte-checked against M0; actual Extra/c include headers
are explicitly bound after the owner's live-header decision of2026-10-09.
The FPR header differs from M0. This is not a complete M0 build/replay.
Standard Sage preparser/ZZ. No private KeyGen, seed, or production C edit.
Finite polynomial matches do not replace the missing full source NTT proof.
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
names=['falcon-vrfy.c','internal.h','falcon.h','shake.h','fpr-emulated.h']
expected={name:profile['core']['source_files'][name] for name in names}
pins={name:digest(root/name) for name in names}
for name in names:
    if name!='fpr-emulated.h': assert pins[name]==expected[name],name
assert expected['fpr-emulated.h']=='242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'
assert pins['fpr-emulated.h']=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
header_binding={'owner_decision':'2026-10-09: pin actual Extra/c headers; repeated confirmation; no old pin changes',
    'actual_source_pins':pins,'historical_m0_pins':expected,
    'differences':{name:{'m0':expected[name],'actual':pins[name]} for name in names if expected[name]!=pins[name]},
    'scope':'Exact public vrfy.c/internal.h bytes; explicitly bound live repository include closure. Not a complete historical M0 build or compiler proof.'}
Path('PUBLIC_INPUT_HEADERS.json').write_text(json.dumps(header_binding,indent=2)+'\n')
source = (root/'falcon-vrfy.c').read_text()
def once(text,old,new):
    assert text.count(old)==1,old
    return text.replace(old,new,int(1))
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)

q=ZZ(18433);n=ZZ(1536);hn=ZZ(768);radix=ZZ(2)^16
assert q.is_prime()
first=power_mod(ZZ(25),ZZ(1536),q)
assert (first^2-first+1)%q==0
fixtures=[]
for shift in range(4):
    f=[ZZ((i*11+shift)%3)-1 for i in range(n)]
    g=[ZZ((i*7+shift+1)%3)-1 for i in range(n)]
    fixtures.append((f,g))
for index in [0,767,768,1535]:
    f=[ZZ(0)]*int(n);g=[ZZ(0)]*int(n)
    f[index]=-1;g[(index+17)%int(n)]=1
    fixtures.append((f,g))
assert len(fixtures)==8
def split(a):
    return [(a[i]+first*a[i+hn])%q for i in range(hn)]+[(a[i]+a[i+hn]-first*a[i+hn])%q for i in range(hn)]
converted=[([x%q for x in f],[x%q for x in g]) for f,g in fixtures]
splits=[(split(f),split(g)) for f,g in fixtures]
ring=PolynomialRing(Zmod(q),'X');field=ring.base_ring()
eval_count=ZZ(0)
for (f,g),(sf,sg) in zip(fixtures,splits):
    for a,sa in [(f,sf),(g,sg)]:
        polynomial=ring(a)
        for exponent in [1,5,7,11,1537,1541]:
            x=field(power_mod(ZZ(25),ZZ(2)*ZZ(exponent),q))
            z=x^hn
            assert z in [field(first),1-field(first)]
            remainder=ring(sa[:int(hn)] if z==field(first) else sa[int(hn):])
            assert polynomial(x)==remainder(x)
            eval_count+=1
fixture={'f_g':fixtures,'converted_f_g':converted,'first_f_g':splits,'first_root':first,'exact_split_evaluations':eval_count}
Path('PUBLIC_INPUT_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')

support=r'''
#include <stdio.h>
static size_t active_case,forward_ordinal;
static void dump16(const char *tag,size_t ordinal,const uint16_t *a){
 printf("%s %zu %zu",tag,active_case,ordinal);
 for(size_t i=0;i<1536;i++){printf(" %u",(unsigned)a[i]);}printf("\n");
}
'''
start=source.index('static void\nmq_NTT_ternary(uint16_t *a, unsigned logn)\n{\n')
end=source.index('\n}\n',start)+len('\n}\n')
body=once(source[start:end],'\tt = hn;\n','\tdump16("F",forward_ordinal++,a);\n\tt = hn;\n')
instrumented=source[:start]+support+body+source[end:]
compute=instrumented.index('falcon_compute_public(uint16_t *h,')
compute_end=instrumented.index('\n}\n',compute)+len('\n}\n')
before=instrumented[:compute];part=instrumented[compute:compute_end];after=instrumented[compute_end:]
part=once(part,'\tq = ternary ? Qt : Qb;\n','\tfor(size_t j=0;j<TERNARY_N_MAX;j++)t[j]=60000;\n\tq = ternary ? Qt : Qb;\n')
part=once(part,'\tmq_NTT(h, logn, ternary);\n',
    '\tdump16("C",0,t);dump16("C",1,h);\n\tprintf("T %zu %u %u\\n",active_case,(unsigned)t[1536],(unsigned)t[3071]);\n\tmq_NTT(h, logn, ternary);\n')
instrumented=before+part+after
variants={
    'baseline':instrumented,
    'wrong_same_material':once(instrumented,'h[u] = mq_conv_small(g[u], q);','h[u] = mq_conv_small(f[u], q); (void)g;'),
    'unsigned_input':once(instrumented,'t[u] = mq_conv_small(f[u], q);','t[u] = mq_conv_small((uint16_t)f[u], q);'),
    'wrong_complement':once(instrumented,'a[u + hn] = mq_sub(mq_add(a0, a1, Qt), b, Qt);','a[u + hn] = mq_sub(mq_sub(a0, a1, Qt), b, Qt);'),
    'wrong_scaled_root':once(instrumented,'\tr = gm_square[1];\n','\tr = 1;\n'),
    'swapped_first_halves':once(instrumented,'\tdump16("F",forward_ordinal++,a);',
        '\tfor(size_t j=0;j<hn;j++){uint16_t v=a[j];a[j]=a[j+hn];a[j+hn]=v;}\n\tdump16("F",forward_ordinal++,a);')}
arrays='static const int16_t fixture_f[][1536]={'+','.join('{'+','.join(str(x) for x in f)+'}' for f,g in fixtures)+'};\n'
arrays+='static const int16_t fixture_g[][1536]={'+','.join('{'+','.join(str(x) for x in g)+'}' for f,g in fixtures)+'};\n'
main=r'''
int main(void){
 setvbuf(stdout,NULL,_IONBF,0);
 for(size_t c=0;c<sizeof fixture_f/sizeof fixture_f[0];c++){
  struct{uint16_t lo,h[1536],hi;} out;
  struct{int16_t lo,f[1536],hi;} f;
  struct{int16_t lo,g[1536],hi;} g;
  out.lo=out.hi=60000;f.lo=f.hi=g.lo=g.hi=12345;
  memset(out.h,0xEA,sizeof out.h);memcpy(f.f,fixture_f[c],sizeof f.f);memcpy(g.g,fixture_g[c],sizeof g.g);
  active_case=c;forward_ordinal=0;
  int status=falcon_compute_public(out.h,f.f,g.g,10,1);
  printf("M %zu %d %u %u %d %d %d %d %d %d\n",c,status,(unsigned)out.lo,(unsigned)out.hi,
   f.lo,f.hi,g.lo,g.hi,memcmp(f.f,fixture_f[c],sizeof f.f),memcmp(g.g,fixture_g[c],sizeof g.g));
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
        counts={tag:ZZ(0) for tag in ['C','F','T','M']};differences=[];seen=set()
        for line in ran.stdout.decode().splitlines():
            tag,*payload=line.split();counts[tag]+=1;values=[ZZ(x) for x in payload];case=values[0]
            if tag in ['C','F']:
                ordinal=values[1];actual=values[2:];key=(tag,case,ordinal);assert key not in seen;seen.add(key)
                expected_vector=converted[int(case)][int(ordinal)] if tag=='C' else splits[int(case)][1-int(ordinal)]
                ok=actual==expected_vector and len(actual)==n and all(0<=x<q for x in actual)
            elif tag=='T': ok=values[1:]==[60000,60000]
            elif tag=='M': ok=values[2:]==[60000,60000,12345,12345,12345,12345,0,0]
            else: raise AssertionError(tag)
            if not ok: differences.append({'tag':tag,'case':case})
        assert counts=={'C':16,'F':16,'T':8,'M':8},counts
        assert bool(differences)==(variant!='baseline'),label
        artifacts=[cfile,deps,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'counts':counts,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
assert expected==header_binding['historical_m0_pins']
result={'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,'source_pins':pins,
    'header_binding_sha256':digest('PUBLIC_INPUT_HEADERS.json'),'historical_m0_pins':expected,
    'header_differences':header_binding['differences'],
    'profile_sha256':digest(profile_path),'fixture_sha256':digest('PUBLIC_INPUT_FIXTURE.json'),
    'split_evaluations':eval_count,'scope':'Eight public synthetic SAME f/g pairs,3072 conversions per case,both actual first passes,original inputs/subobject sentinels/3072-cell t-tail; five detected mutations per mode. Exact public M0 vrfy.c/internal.h with explicitly bound live Extra/c include closure; FPR header differs from M0 by owner-approved pinning,not a complete M0 build. Exact finite split polynomial values are diagnostic,not the missing whole first-loop/radix2/triple physical-evaluation proof,public equations,whole KeyGen or independent review.'}
Path('PUBLIC_INPUT_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
