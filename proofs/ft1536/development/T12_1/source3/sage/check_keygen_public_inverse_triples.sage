"""BATCH_044 finite controls for the actual generated inverse/triple seam.

Exact Sage preparser/ZZ/Zmod, public synthetic vectors and inherited public
quotients. The remaining inverse executes but its final output is NOT used
as a correctness proof or as a public equation. No private key material.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

old = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])
repo = next(p for p in old.parents if (p/'Extra/c/falcon-vrfy.c').exists())
root = repo/'Extra/c'
component = repo/'proofs/ft1536/development/T12_1/source3'
profile_path = old/'inputs/source/PROFILE.json'
profile = json.loads(profile_path.read_text())
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
def once(text,before,after):
    assert text.count(before)==1,before
    return text.replace(before,after,int(1))
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
Path('PUBLIC_INVERSE_HEADERS.json').write_text(json.dumps(headers,indent=2)+'\n')
inherited_path = component/'.build/jobs/keygen_public_suffix_checks_043_001/PUBLIC_SUFFIX_FIXTURE.json'
assert digest(inherited_path)=='93a70e0d703883a7a4e4212afe3d4a03745ba4142ca26dd22a98997cd202c9f8'
inherited = json.loads(inherited_path.read_text())
q=ZZ(18433);n=ZZ(1536);R=Zmod(q);base=R(25)^2;radix=R(2)^16
def rev(x,bits):
    value=ZZ(0)
    for j in range(bits): value=2*value+((x>>j)&1)
    return value
def exponent(i):
    k=ZZ(i.nbits()-1);j=i-2^k;u=rev(j,k)
    return (1 if k==9 else 3*2^(8-k))*(3*u+1+u%2)
first=base^768;unity=first^2;inverse_unity=unity^-1
assert unity^3==1 and unity!=1
assert inverse_unity==first^-2
table=[ZZ(radix/(2*first-1))]+[ZZ(radix*base^-exponent(ZZ(i))) for i in range(1,1024)]
vectors=[[ZZ(0)]*int(n),[ZZ(1)]*int(n),[ZZ((i*101+17)%q) for i in range(n)]]
vectors += [[ZZ(x) for x in row['quotients']] for row in inherited['references'] if row['stop']==n]
assert len(vectors)==10
references=[]
for a in vectors:
    expected=[]
    for j in range(512):
        A,B,C=[R(a[3*j+k]) for k in range(3)];x=base^-exponent(ZZ(512+j));w=inverse_unity
        expected.extend([ZZ(A+B+C),ZZ(x*(A+B*w+C*w^2)),ZZ(x^2*(A+B*w^2+C*w))])
    references.append(expected)
fixture={'vectors':vectors,'table':table,'seed':ZZ(radix*inverse_unity),'references':references,
    'inherited_fixture_sha256':digest(inherited_path)}
Path('PUBLIC_INVERSE_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')
source=(root/'falcon-vrfy.c').read_text()
start=source.index('static void\nmq_iNTT_ternary(uint16_t *a, unsigned logn)')
end=source.index('\n}\n',start)+len('\n}\n')
body=source[start:end]
support=r'''
#include <stdio.h>
static size_t active_case;
static void dump_inverse(const char *tag,const uint16_t *a,size_t n){
 printf("%s %zu",tag,active_case);
 for(size_t i=0;i<n;i++)printf(" %u",(unsigned)a[i]);
 printf("\n");
}
'''
body=once(body,'\tw = mq_montymul(igm_square[1], igm_square[1], Qt, Q0It);\n',
    '\tw = mq_montymul(igm_square[1], igm_square[1], Qt, Q0It);\n\tdump_inverse("I",igm,1024);printf("W %zu %u\\n",active_case,(unsigned)w);\n')
body=once(body,'\n\t/*\n\t * Intermediate steps for degree halving.',
    '\n\tdump_inverse("A",a,1536);\n\t/*\n\t * Intermediate steps for degree halving.')
swapped=once(body,'mq_add(f0, mq_add(f11, f22, Qt), Qt), Qt, Q0It);','mq_add(f0, mq_add(f12, f21, Qt), Qt), Qt, Q0It);')
swapped=once(swapped,'a[u + 2] = mq_montymul(x2,\n\t\t\tmq_add(f0, mq_add(f12, f21, Qt), Qt), Qt, Q0It);',
    'a[u + 2] = mq_montymul(x2,\n\t\t\tmq_add(f0, mq_add(f11, f22, Qt), Qt), Qt, Q0It);')
variant_bodies={
    'baseline':body,
    'wrong_inverse_alias':once(body,'\t\tigm_cubic = igm;','\t\tigm_cubic = gm;'),
    'wrong_unity_seed':once(body,'mq_montymul(igm_square[1], igm_square[1], Qt, Q0It);','mq_montymul(igm_square[1], Rt, Qt, Q0It);'),
    'wrong_triple_order':swapped,
    'wrong_twiddle_scale':once(body,'\t\tx = igm_cubic[v];','\t\tx = mq_montymul(igm_cubic[v], R2t, Qt, Q0It);'),
    'skipped_first_triple':once(body,'\tfor (u = 0, v = (size_t)1 << (logn - 1); u < n; u += 3, v ++) {','\tfor (u = 3, v = (size_t)1 << (logn - 1); u < n; u += 3, v ++) {')}
variants={name:source[:start]+support+modified+source[end:] for name,modified in variant_bodies.items()}
arrays='static const uint16_t vectors[][1536]={'+','.join('{'+','.join(str(x) for x in a)+'}' for a in vectors)+'};\n'
main=r'''
int main(void){
 setvbuf(stdout,NULL,_IONBF,0);
 for(size_t c=0;c<sizeof vectors/sizeof vectors[0];c++){
  struct{uint16_t lo,a[1536],hi;} object;object.lo=object.hi=60000;active_case=c;
  for(size_t i=0;i<1536;i++)object.a[i]=vectors[c][i];
  mq_iNTT_ternary(object.a,10);
  printf("B %zu %u %u\n",c,(unsigned)object.lo,(unsigned)object.hi);
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
        seen=set();differences=[]
        for line in ran.stdout.decode().splitlines():
            tag,*payload=line.split();a=[ZZ(x) for x in payload];case=a[0];key=(tag,case)
            assert key not in seen;seen.add(key)
            if tag=='I': ok=a[1:]==table
            elif tag=='W': ok=a[1:]==[ZZ(radix*inverse_unity)]
            elif tag=='A': ok=a[1:]==references[int(case)] and all(0<=x<q for x in a[1:])
            elif tag=='B': ok=a[1:]==[60000,60000]
            else: raise AssertionError(tag)
            if not ok: differences.append({'tag':tag,'case':case})
        assert seen=={(tag,ZZ(c)) for c in range(len(vectors)) for tag in ['I','W','A','B']}
        if variant=='baseline': assert not differences,(label,differences)
        else: assert any(d['tag']=='A' for d in differences),(label,differences)
        artifacts=[cfile,deps,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
result={'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,'source_pins':pins,
    'header_binding_sha256':digest('PUBLIC_INVERSE_HEADERS.json'),'profile_sha256':digest(profile_path),
    'fixture_sha256':digest('PUBLIC_INVERSE_FIXTURE.json'),'vectors':len(vectors),'runs':12,
    'triples_per_mode':len(vectors)*512,'cells_per_mode':len(vectors)*1536,
    'inherited_fixture':{'path':str(inherited_path),'sha256':digest(inherited_path)},
    'scope':'Actual generated inverse table (including exceptional index0), scaled seed, all512 source triples per public input, canonical triple seam and boundary canaries; five mutations per normal/UBSan mode. Remaining inverse runs, but final output, normalization, round-trip and both public equations are NOT checked/promoted.'}
Path('PUBLIC_INVERSE_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
