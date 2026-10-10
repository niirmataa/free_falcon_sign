"""BATCH_046 exact finite source controls of first-root and normalization.

Public synthetic inputs, live Extra/c, standard Sage preparser. Every
chronological pair/store and ORIGINAL evaluation is checked independently.
These finite controls supplement, not replace, universal kernel proofs.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

old=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])
repo=next(p for p in old.parents if (p/'Extra/c/falcon-vrfy.c').exists())
root=repo/'Extra/c';component=repo/'proofs/ft1536/development/T12_1/source3'
profile_path=old/'inputs/source/PROFILE.json';profile=json.loads(profile_path.read_text())
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
def once(text,before,after):
    assert text.count(before)==1,before
    return text.replace(before,after,int(1))
names=['falcon-vrfy.c','internal.h','falcon.h','shake.h','fpr-emulated.h']
historical={name:profile['core']['source_files'][name] for name in names}
pins={name:digest(root/name) for name in names}
for name in names:
    if name!='fpr-emulated.h': assert pins[name]==historical[name],name
assert historical['fpr-emulated.h']=='242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'
assert pins['fpr-emulated.h']=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
headers={'actual_source_pins':pins,'historical_m0_pins':historical,
    'differences':{name:{'m0':historical[name],'actual':pins[name]} for name in names if historical[name]!=pins[name]},
    'owner_decision':'Inherited039 live Extra/c header decision; identical include bytes rechecked.',
    'scope':'Local public arithmetic diagnostic, not a complete historical M0 build.'}
Path('PUBLIC_NORMALIZE_HEADERS.json').write_text(json.dumps(headers,indent=2)+'\n')
inherited_path=component/'.build/jobs/keygen_public_reverse_checks_045_001/PUBLIC_REVERSE_FIXTURE.json'
assert digest(inherited_path)=='17557e6f7309ffdc147bd826ce468a96f43340bf64ce39a819770f896df501a4'
inherited=json.loads(inherited_path.read_text())
q=ZZ(18433);n=ZZ(1536);R=Zmod(q);base=R(25)^2;radix=R(2)^16
def rev(x,bits):
    value=ZZ(0)
    for j in range(bits): value=2*value+((x>>j)&1)
    return value
def exponent(i):
    k=ZZ(i.nbits()-1);j=i-2^k;u=rev(j,k)
    return (1 if k==9 else 3*2^(8-k))*(3*u+1+u%2)
vectors=[[ZZ(x) for x in a] for a in inherited['vectors']]
reverse=[[ZZ(x) for x in stages[-1]] for stages in inherited['references']]
assert len(vectors)==len(reverse)==10
first_root=base^768;denominator=2*first_root-1
assert first_root^2-first_root+1==0 and denominator!=0
inverse_root=denominator^-1;inverse_n=R(n)^-1
seed=ZZ(radix*inverse_root);ni=ZZ(radix*inverse_n)
points=[base^exponent(ZZ(512+j))*(base^1536)^k for j in range(512) for k in range(3)]
P=PolynomialRing(R,'X')
rooted=[];normalized=[];products=[];evaluation_checks=ZZ(0)
for case,a in enumerate(reverse):
    current=[R(x) for x in a];bodies=[]
    for k in range(768):
        x=current[k];y=current[k+768];b=inverse_root*(x-y)
        current[k]=x+y-b;current[k+768]=b+b;bodies.append(ZZ(b))
    root_polynomial=P(current)
    for i in range(n):
        assert root_polynomial(points[i])==R(n)*R(vectors[case][i]),(case,i,'root')
        evaluation_checks+=1
    rooted.append([ZZ(x) for x in current]);products.append(bodies)
    final=[x*inverse_n for x in current];final_polynomial=P(final)
    for i in range(n):
        assert final_polynomial(points[i])==R(vectors[case][i]),(case,i,'normalized')
        evaluation_checks+=1
    normalized.append([ZZ(x) for x in final])
assert evaluation_checks==30720
fixture={'vectors':vectors,'reverse':reverse,'rooted':rooted,'products':products,'normalized':normalized,
    'seed':seed,'ni':ni,'original_evaluations':evaluation_checks,'inherited_fixture_sha256':digest(inherited_path),
    'scope':'Unnormalized first-root image factor1536, followed by actual normalization and final ORIGINAL inverse-input evaluations.'}
Path('PUBLIC_NORMALIZE_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')
source=(root/'falcon-vrfy.c').read_text()
start=source.index('static void\nmq_iNTT_ternary(uint16_t *a, unsigned logn)')
end=source.index('\n}\n',start)+len('\n}\n');body=source[start:end]
support=r'''
#include <stdio.h>
static size_t active_case;
static void dump_final(const char *tag,const uint16_t *a){
 printf("%s %zu 0",tag,active_case);
 for(size_t i=0;i<1536;i++)printf(" %u",(unsigned)a[i]);
 printf("\n");
}
'''
body=once(body,'\tr = igm_square[0];','\tdump_final("A",a);\n\tr = igm_square[0];\n\tprintf("R %zu 0 %u\\n",active_case,r);')
body=once(body,'\t\ta[u + hn] = mq_add(b, b, Qt);','\t\ta[u + hn] = mq_add(b, b, Qt);\n\t\tprintf("F %zu %zu %u %u %u\\n",active_case,u,(unsigned)a[u],(unsigned)a[u+hn],b);')
body=once(body,'\tni = logn <= 9 ? INVNQt[logn] : mq_div_18433(Rt, (uint32_t)n);',
    '\tdump_final("P",a);\n\tni = logn <= 9 ? INVNQt[logn] : mq_div_18433(Rt, (uint32_t)n);\n\tprintf("N %zu 0 %u\\n",active_case,ni);')
body=once(body,'\t\ta[u] = mq_montymul(a[u], ni, Qt, Q0It);',
    '\t\ta[u] = mq_montymul(a[u], ni, Qt, Q0It);\n\t\tprintf("S %zu %zu %u\\n",active_case,u,(unsigned)a[u]);')
body=once(body,'\n}\n','\n\tdump_final("H",a);\n}\n')
variant_bodies={
    'baseline':body,
    'wrong_exceptional_seed':once(body,'r = igm_square[0];','r = igm_square[1];'),
    'wrong_root_difference':once(body,'b = mq_montymul(r, mq_sub(a0, a1, Qt), Qt, Q0It);','b = mq_montymul(r, mq_sub(a1, a0, Qt), Qt, Q0It);'),
    'missing_root_factor2':once(body,'a[u + hn] = mq_add(b, b, Qt);','a[u + hn] = b;'),
    'unscaled_ni':once(body,'mq_div_18433(Rt, (uint32_t)n);','mq_div_18433(1, (uint32_t)n);'),
    'skipped_last_normalization':once(body,'for (u = 0; u < n; u ++)','for (u = 0; u + 1 < n; u ++)')}
variants={name:source[:start]+support+modified+source[end:] for name,modified in variant_bodies.items()}
arrays='static const uint16_t vectors[][1536]={'+','.join('{'+','.join(str(x) for x in a)+'}' for a in vectors)+'};\n'
main=r'''
int main(void){
 setvbuf(stdout,NULL,_IONBF,0);
 for(size_t c=0;c<sizeof vectors/sizeof vectors[0];c++){
  struct{uint16_t lo,a[1536],hi;} object;object.lo=object.hi=60000;active_case=c;
  for(size_t i=0;i<1536;i++)object.a[i]=vectors[c][i];
  mq_iNTT_ternary(object.a,10);
  printf("B %zu 0 %u %u\n",c,(unsigned)object.lo,(unsigned)object.hi);
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
            tag,*payload=line.split();data=[ZZ(x) for x in payload];case,index=data[:2];key=(tag,case,index)
            assert key not in seen and 0<=case<len(vectors) and 0<=index<n;seen.add(key)
            if tag=='A': ok=index==0 and data[2:]==reverse[int(case)]
            elif tag=='R': ok=index==0 and data[2:]==[seed]
            elif tag=='F': ok=index<768 and data[2:]==[rooted[int(case)][int(index)],rooted[int(case)][int(index+768)],products[int(case)][int(index)]] and all(0<=x<q for x in data[2:])
            elif tag=='P': ok=index==0 and data[2:]==rooted[int(case)] and all(0<=x<q for x in data[2:])
            elif tag=='N': ok=index==0 and data[2:]==[ni]
            elif tag=='S': ok=data[2:]==[normalized[int(case)][int(index)]] and 0<=data[2]<q
            elif tag=='H': ok=index==0 and data[2:]==normalized[int(case)] and all(0<=x<q for x in data[2:])
            elif tag=='B': ok=index==0 and data[2:]==[60000,60000]
            else: raise AssertionError(tag)
            if not ok: differences.append({'tag':tag,'case':case,'index':index})
        expected={(tag,ZZ(c),ZZ(0)) for c in range(len(vectors)) for tag in ['A','R','P','N','H','B']}|{
            ('F',ZZ(c),ZZ(k)) for c in range(len(vectors)) for k in range(768)}|{
            ('S',ZZ(c),ZZ(k)) for c in range(len(vectors)) for k in range(n)}
        assert seen<=expected
        differences.extend({'tag':tag,'case':c,'index':k,'missing':True} for tag,c,k in sorted(expected-seen))
        if variant=='baseline': assert not differences,(label,differences)
        else: assert any(d['tag']=='H' for d in differences),(label,differences)
        artifacts=[cfile,deps,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
result={'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,'source_pins':pins,
    'header_binding_sha256':digest('PUBLIC_NORMALIZE_HEADERS.json'),'profile_sha256':digest(profile_path),
    'fixture_sha256':digest('PUBLIC_NORMALIZE_FIXTURE.json'),'vectors':len(vectors),'runs':12,
    'butterflies_per_mode':7680,'normalization_stores_per_mode':15360,'original_evaluations':evaluation_checks,
    'inherited_fixture':{'path':str(inherited_path),'sha256':digest(inherited_path)},
    'scope':'All7680 first-root butterflies/15360 normalization stores per baseline normal/UBSan mode on ten public inputs including seven SAME public g/f quotients; canonical chronological cells, exceptional r, live ni, final h and canaries. Sage checks30720 ORIGINAL unnormalized/normalized evaluations. All five mutations per mode detected. Finite diagnostics, no secret/random KeyGen or full historical M0 build; no independent review.'}
Path('PUBLIC_NORMALIZE_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
