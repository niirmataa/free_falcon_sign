"""BATCH_045 exact finite controls of all actual inverse reverse stages.

Public synthetic inputs (including inherited SAME g/f quotients), live
Extra/c, standard Sage preparser. First-root/final output/equations are NOT
checked or promoted. Finite source controls supplement universal proofs.
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
Path('PUBLIC_REVERSE_HEADERS.json').write_text(json.dumps(headers,indent=2)+'\n')
inherited_path=component/'.build/jobs/keygen_public_inverse_checks_044_002/PUBLIC_INVERSE_FIXTURE.json'
assert digest(inherited_path)=='cd001750bc09939e73a5e49086dc5b96c9b628606dd1a84fa0b631f4ec79fd68'
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
triples=[[ZZ(x) for x in a] for a in inherited['references']]
assert len(vectors)==len(triples)==10
points=[base^exponent(ZZ(512+j))*(base^1536)^k for j in range(512) for k in range(3)]
P=PolynomialRing(R,'X')
references=[];evaluation_checks=ZZ(0);row_checks=ZZ(0)
for case,a in enumerate(triples):
    current=[R(x) for x in a];stages=[];t=ZZ(6);m=ZZ(256)
    while t<n:
        h=t//2
        for j in range(m):
            start=j*t;twiddle=base^-exponent(ZZ(m+j));row_checks+=1
            for k in range(h):
                x=current[start+k];y=current[start+h+k]
                current[start+k]=x+y;current[start+h+k]=(x-y)*twiddle
        stages.append([ZZ(x) for x in current])
        # Each reconstructed block retains ORIGINAL physical point ordering
        # and evaluates to (3*2^stage) times the actual pre-inverse input.
        blocks=[P(current[j*t:(j+1)*t]) for j in range(n//t)]
        factor=R(3*2^len(stages))
        for i in range(n):
            assert blocks[i//t](points[i])==factor*R(vectors[case][i]),(case,len(stages),i)
            evaluation_checks+=1
        t*=2;m//=2
    assert len(stages)==8 and t==1536 and m==1
    references.append(stages)
assert row_checks==5100 and evaluation_checks==122880
fixture={'vectors':vectors,'triples':triples,'references':references,
    'inherited_fixture_sha256':digest(inherited_path),'original_block_evaluations':evaluation_checks,
    'scope':'Unnormalized reverse stages only; final block factor768, not final inverse output.'}
Path('PUBLIC_REVERSE_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')
source=(root/'falcon-vrfy.c').read_text()
start=source.index('static void\nmq_iNTT_ternary(uint16_t *a, unsigned logn)')
end=source.index('\n}\n',start)+len('\n}\n');body=source[start:end]
support=r'''
#include <stdio.h>
static size_t active_case, inverse_stage;
static void dump_reverse(const char *tag,const uint16_t *a,size_t stage){
 printf("%s %zu %zu",tag,active_case,stage);
 for(size_t i=0;i<1536;i++)printf(" %u",(unsigned)a[i]);
 printf("\n");
}
'''
body=once(body,'\n\t/*\n\t * Intermediate steps for degree halving.',
    '\n\tdump_reverse("A",a,0);\n\t/*\n\t * Intermediate steps for degree halving.')
body=once(body,'\t\tt <<= 1;','\t\tdump_reverse("S",a,inverse_stage);printf("D %zu %zu %zu %zu\\n",active_case,inverse_stage,t,m);inverse_stage++;\n\t\tt <<= 1;')
variant_bodies={
    'baseline':body,
    'wrong_inverse_alias':once(body,'\t\tigm_square = igm;','\t\tigm_square = gm;'),
    'wrong_reverse_sign':once(body,'mq_sub(a0, a1, Qt), s, Qt, Q0It);','mq_sub(a1, a0, Qt), s, Qt, Q0It);'),
    'wrong_twiddle_scale':once(body,'s = igm_square[m + u1];','s = mq_montymul(igm_square[m + u1], R2t, Qt, Q0It);'),
    'skipped_first_row':once(body,'for (u1 = 0, v1 = 0; u1 < m; u1 ++, v1 += t)',
        'for (u1 = 1, v1 = t; u1 < m; u1 ++, v1 += t)'),
    'skipped_last_stage':once(body,'t < n; m >>= 1','t < hn; m >>= 1')}
variants={name:source[:start]+support+modified+source[end:] for name,modified in variant_bodies.items()}
arrays='static const uint16_t vectors[][1536]={'+','.join('{'+','.join(str(x) for x in a)+'}' for a in vectors)+'};\n'
main=r'''
int main(void){
 setvbuf(stdout,NULL,_IONBF,0);
 for(size_t c=0;c<sizeof vectors/sizeof vectors[0];c++){
  struct{uint16_t lo,a[1536],hi;} object;object.lo=object.hi=60000;active_case=c;inverse_stage=1;
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
            tag,*payload=line.split();data=[ZZ(x) for x in payload];case,stage=data[:2];key=(tag,case,stage)
            assert key not in seen and 0<=case<len(vectors) and 0<=stage<=8;seen.add(key)
            if tag=='A': ok=stage==0 and data[2:]==triples[int(case)]
            elif tag=='S': ok=1<=stage<=8 and data[2:]==references[int(case)][int(stage-1)] and all(0<=x<q for x in data[2:])
            elif tag=='D': ok=data[2:]==[6*2^(stage-1),256//2^(stage-1)]
            elif tag=='B': ok=stage==0 and data[2:]==[60000,60000]
            else: raise AssertionError(tag)
            if not ok: differences.append({'tag':tag,'case':case,'stage':stage})
        expected={(tag,ZZ(c),ZZ(0)) for c in range(len(vectors)) for tag in ['A','B']}|{
            (tag,ZZ(c),ZZ(k)) for c in range(len(vectors)) for k in range(1,9) for tag in ['S','D']}
        assert seen<=expected
        differences.extend({'tag':tag,'case':c,'stage':k,'missing':True} for tag,c,k in sorted(expected-seen))
        if variant=='baseline': assert not differences,(label,differences)
        else: assert any(d['tag']=='S' for d in differences),(label,differences)
        artifacts=[cfile,deps,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
result={'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,'source_pins':pins,
    'header_binding_sha256':digest('PUBLIC_REVERSE_HEADERS.json'),'profile_sha256':digest(profile_path),
    'fixture_sha256':digest('PUBLIC_REVERSE_FIXTURE.json'),'vectors':len(vectors),'runs':12,
    'rows_per_mode':5100,'butterflies_per_mode':61440,'cells_per_mode':122880,
    'original_block_evaluations':evaluation_checks,'inherited_fixture':{'path':str(inherited_path),'sha256':digest(inherited_path)},
    'scope':'All eight actual reverse stages on ten public inputs including seven SAME public g/f quotients, every canonical stage cell/header and boundary canaries. Sage checks122880 original physical block evaluations with factor768 at the last seam. Five mutations per normal/UBSan mode detected. First-root/normalization/final output/equations NOT checked or promoted; not a full historical M0 build.'}
Path('PUBLIC_REVERSE_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
