"""BATCH_041 finite entry/radix/physical-order controls; Sage preparser/ZZ.

Only public synthetic f/g. Live Extra/c bytes and include closure are pinned
under the recorded039 header decision. No complete M0 build is claimed.
Finite full evaluations supplement, and do not replace, the open universal
source composition from the original f/g to all1536 physical values.
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
    'owner_decision':'Inherited039 actual Extra/c header pinning decision,2026-10-09; same bytes rechecked.',
    'scope':'Local public arithmetic diagnostic, not a complete historical M0 build.'}
Path('PUBLIC_FIRST_HEADERS.json').write_text(json.dumps(headers,indent=2)+'\n')
source = (root/'falcon-vrfy.c').read_text()
def once(text, before, after):
    assert text.count(before)==1,before
    return text.replace(before,after,int(1))
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)

q=ZZ(18433);n=ZZ(1536);radix=ZZ(2)^16;base=power_mod(ZZ(25),2,q)
assert q.is_prime()
def rev(x,bits):
    value=ZZ(0)
    for j in range(bits): value=2*value+((x>>j)&1)
    return value
def exponent(i):
    i=max(ZZ(1),ZZ(i));k=ZZ(i.nbits()-1);j=i-2^k;u=rev(j,k)
    return (1 if k==9 else 3*2^(8-k))*(3*u+1+u%2)
roots=[power_mod(base,exponent(i),q) for i in range(1024)]
points=[power_mod(base,exponent(512+i//3)+1536*(i%3),q) for i in range(n)]
assert len(set(points))==n
pairs=[]
for shift in [0,1]:
    pairs.append(([ZZ((i*11+shift)%3)-1 for i in range(n)], [ZZ((i*7+shift+1)%3)-1 for i in range(n)]))
for lo,hi in [(0,1535),(767,768)]:
    f=[ZZ(0)]*int(n);g=[ZZ(0)]*int(n);f[lo]=-1;g[hi]=1;pairs.append((f,g))
vectors=[a for pair in pairs for a in pair]
assert len(vectors)==8
def stages(vector):
    a=[x%q for x in vector];result={('C',ZZ(0)):list(a)};h=n//2;z=roots[1]
    for i in range(h):
        x=a[i];y=a[i+h];a[i]=(x+y*z)%q;a[i+h]=(x+y-y*z)%q
    result[('F',h)]=list(a);t=h;m=ZZ(2)
    while t>3:
        d=t//2
        for row in range(m):
            start=row*t;z=roots[m+row]
            for k in range(d):
                i=start+k;x=a[i];y=a[i+d];a[i]=(x+y*z)%q;a[i+d]=(x-y*z)%q
        result[('R',m)]=list(a);t=d;m=2*m
    w=roots[1]^2%q
    for j in range(512):
        u=3*j;x=roots[512+j];A=a[u];B=a[u+1];C=a[u+2]
        a[u]=(A+B*x+C*x^2)%q
        a[u+1]=(A+B*x*w+C*x^2*w^2)%q
        a[u+2]=(A+B*x*w^2+C*x^2*w)%q
    result[('T',ZZ(0))]=list(a)
    assert len(result)==11
    return result
references=[stages(a) for a in vectors]
polynomials=PolynomialRing(Zmod(q),'X')
evaluations=ZZ(0)
for vector,expected in zip(vectors,references):
    polynomial=polynomials(vector)
    actual=[ZZ(polynomial(polynomials.base_ring()(x))) for x in points]
    assert expected[('T',ZZ(0))]==actual
    evaluations+=n
fixture={'f_g':pairs,'points':points,'snapshots':[{phase+'_'+str(step):a for (phase,step),a in r.items()} for r in references],
    'original_polynomial_evaluations':evaluations}
Path('PUBLIC_FIRST_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')

support=r'''
#include <stdio.h>
static size_t active_case;
static void dump_first(const char *tag,size_t step,const uint16_t *a){
 printf("%s %zu %zu",tag,active_case,step);
 for(size_t i=0;i<1536;i++){printf(" %u",(unsigned)a[i]);}printf("\n");
}
'''
start=source.index('static void\nmq_NTT_ternary(uint16_t *a, unsigned logn)\n{\n')
end=source.index('\n}\n',start)+len('\n}\n')
body=source[start:end]
body=once(body,'\tr = gm_square[1];\n','\tr = gm_square[1];\n\tprintf("D %zu %zu %zu %u %d %d\\n",active_case,n,hn,r,gm_square==gm,gm_cubic==gm);\n')
body=once(body,'\tt = hn;\n','\tdump_first("F",u,a);\n\tt = hn;\n')
body=once(body,'\t\tt = ht;\n','\t\tdump_first("R",m,a);\n\t\tt = ht;\n')
body=once(body,'\t}\n}\n','\t}\n\tdump_first("T",0,a);\n}\n')
instrumented=source[:start]+support+body+source[end:]
variants={
    'baseline':instrumented,
    'radix_wrong_sign':once(instrumented,'a[v + ht] = mq_sub(a0, a1, Qt);','a[v + ht] = mq_add(a0, a1, Qt);'),
    'radix_wrong_scale':once(instrumented,'s = gm_square[m + u1];','s = 1;'),
    'triple_wrong_c_order':once(once(instrumented,'a[u + 1] = mq_add(fA, mq_add(fB1, fC2, Qt), Qt);',
        'a[u + 1] = mq_add(fA, mq_add(fB1, fC1, Qt), Qt);'),
        'a[u + 2] = mq_add(fA, mq_add(fB2, fC1, Qt), Qt);','a[u + 2] = mq_add(fA, mq_add(fB2, fC2, Qt), Qt);'),
    'triple_wrong_root':once(instrumented,'x = gm_cubic[v];','x = gm_cubic[512 + ((v - 512 + 1) % 512)];'),
    'first_wrong_counter':source[:start]+support+once(body,'for (u = 0; u < hn; u ++)','for (u = 1; u < hn; u ++)')+source[end:]}
arrays='static const int16_t fixtures[][1536]={'+','.join('{'+','.join(str(x) for x in v)+'}' for v in vectors)+'};\n'
main=r'''
int main(void){
 setvbuf(stdout,NULL,_IONBF,0);
 for(size_t c=0;c<sizeof fixtures/sizeof fixtures[0];c++){
  struct{uint16_t lo,a[1536],hi;} object;object.lo=object.hi=60000;active_case=c;
  for(size_t i=0;i<1536;i++)object.a[i]=mq_conv_small(fixtures[c][i],Qt);
  dump_first("C",0,object.a);mq_NTT(object.a,10,1);
  printf("M %zu %u %u\n",c,(unsigned)object.lo,(unsigned)object.hi);
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
        seen=set();differences=[];counts={tag:ZZ(0) for tag in ['C','F','R','T','D','M']}
        for line in ran.stdout.decode().splitlines():
            tag,*payload=line.split();values=[ZZ(x) for x in payload];case=values[0];counts[tag]+=1
            if tag in ['C','F','R','T']:
                step=values[1];actual=values[2:];key=(tag,case,step);assert key not in seen;seen.add(key)
                expected_vector=references[int(case)][(tag,step)]
                ok=actual==expected_vector and len(actual)==n and all(0<=x<q for x in actual)
            elif tag=='D': ok=values[1:]==[1536,768,radix*roots[1]%q,1,1]
            elif tag=='M': ok=values[1:]==[60000,60000]
            else: raise AssertionError(tag)
            if not ok: differences.append({'tag':tag,'case':case})
        assert counts=={'C':8,'F':8,'R':64,'T':8,'D':8,'M':8} and len(seen)==88,counts
        assert bool(differences)==(variant!='baseline'),label
        target='F' if variant=='first_wrong_counter' else 'R' if variant.startswith('radix') else 'T'
        if variant!='baseline': assert any(d['tag']==target for d in differences),(label,target)
        artifacts=[cfile,deps,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'counts':counts,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
assert historical==headers['historical_m0_pins']
result={'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,'source_pins':pins,
    'header_binding_sha256':digest('PUBLIC_FIRST_HEADERS.json'),'profile_sha256':digest(profile_path),
    'fixture_sha256':digest('PUBLIC_FIRST_FIXTURE.json'),'original_polynomial_evaluations':evaluations,
    'scope':'Four public synthetic f/g pairs, original signed conversion, actual generator/aliases/n/hn/r, whole first pass, all eight radix stages and physical triples. Five mutations per normal/UBSan mode. Exact finite original evaluations at all1536 points are diagnostic; universal outer-loop/triple/source evaluation, inverse and public equations remain open.'}
Path('PUBLIC_FIRST_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
