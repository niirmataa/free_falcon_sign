"""Exact finite controls for the public forward range midpoint (BATCH_038).

Standard Sage preparser, ZZ arithmetic. Instrumented copies of the pinned
M0 source preserve the original baseline arithmetic; no production C edits.
All forward pass snapshots, watched stores/table reads and surrounding
subobject sentinels are checked. Finite evaluation matches are diagnostic,
not the still-missing universal original-f/g evaluation theorem.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile = json.loads((root/'PROFILE.json').read_text())
def digest(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
for name,pin in profile['core']['source_files'].items():
    assert digest(root/name)==pin,name
source = (root/'falcon-vrfy.c').read_text()
def once(text,old,new):
    assert text.count(old)==1,old
    return text.replace(old,new,int(1))
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)

q=ZZ(18433);R=ZZ(2)^16;n=ZZ(1536);base=power_mod(ZZ(25),2,q)
assert q.is_prime() and R%q==10237 and R^2%q==4564
def rev(x,bits):
    z=ZZ(0)
    for j in range(bits): z=2*z+((x>>j)&1)
    return z
def exponent(i):
    i=max(ZZ(1),ZZ(i));k=ZZ(i.nbits()-1);j=i-2^k;u=rev(j,k)
    return (1 if k==9 else 3*2^(8-k))*(3*u+1+u%2)
roots=[power_mod(base,exponent(i),q) for i in range(1024)]
gm=[(R*z)%q for z in roots]+[ZZ(60000)]*int(1024)
igm=[(R*inverse_mod(2*roots[0]-1,q))%q]+[(R*inverse_mod(z,q))%q for z in roots[1:]]+[ZZ(60000)]*int(1024)
points=[power_mod(base,exponent(512+i//3)+1536*(i%3),q) for i in range(n)]
assert len(set(points))==n
fixtures=[[ZZ(0)]*int(n),[q-1]*int(n)]
for index in [0,767,768,1535]:
    v=[ZZ(0)]*int(n);v[index]=1;fixtures.append(v)
for offset in [0,1]: fixtures.append([(ZZ((i*11+offset)%3)-1)%q for i in range(n)])
for label in ['FT1536 BATCH_038 public forward/A','FT1536 BATCH_038 public forward/B']:
    tape=hashlib.shake_256(label.encode()).digest(int(2*n))
    fixtures.append([ZZ(int.from_bytes(tape[int(2*i):int(2*i+2)],'little'))%q for i in range(n)])
assert len(fixtures)==10 and all(0<=x<q for a in fixtures for x in a)

def stages(vector):
    a=list(vector);r=roots[1];hn=n//2;result={}
    for u in range(hn):
        a0=a[int(u)];a1=a[int(u+hn)];b=(a1*r)%q
        a[int(u)]=(a0+b)%q;a[int(u+hn)]=(a0+a1-b)%q
    result[('first',ZZ(0))]=list(a);t=hn;m=ZZ(2)
    while t>3:
        ht=t//2
        for u1 in range(m):
            s=roots[int(m+u1)];v1=u1*t;v2=v1+ht
            for v in range(v1,v2):
                a0=a[int(v)];a1=(a[int(v+ht)]*s)%q
                a[int(v)]=(a0+a1)%q;a[int(v+ht)]=(a0-a1)%q
        result[('double',m)]=list(a);t=ht;m=2*m
    w=(roots[1]^2)%q
    for j in range(n//3):
        u=3*j;x=roots[int(512+j)];x2=(x^2)%q
        A=a[int(u)];B=a[int(u+1)];C=a[int(u+2)]
        B0=(B*x)%q;B1=(B0*w)%q;B2=(B1*w)%q
        C0=(C*x2)%q;C1=(C0*w)%q;C2=(C1*w)%q
        a[int(u)]=(A+B0+C0)%q;a[int(u+1)]=(A+B1+C2)%q;a[int(u+2)]=(A+B2+C1)%q
    result[('triple',ZZ(0))]=list(a)
    assert len(result)==10 and all(0<=x<q for v in result.values() for x in v)
    return result
references=[stages(a) for a in fixtures]
ring=PolynomialRing(Zmod(q),'X')
for a,expected in zip(fixtures,references):
    polynomial=ring(a)
    assert expected[('triple',ZZ(0))]==[ZZ(polynomial(ring.base_ring()(point))) for point in points]
fixture={'vectors':fixtures,'points':points,'gm':gm,'igm':igm,
         'pass_snapshots':[{phase+'_'+str(step):values for (phase,step),values in r.items()} for r in references]}
Path('PUBLIC_FORWARD_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')

support=r'''
#include <stdio.h>
static size_t active_case, watched_stores, bad_store_range, bad_store_index;
static size_t table_reads, bad_table_range, bad_table_index;
static uint16_t watched_table(const uint16_t *p, size_t i) {
 table_reads++;bad_table_index+=(i>=1024);bad_table_range+=(p[i]>=Qt);return p[i];
}
static void watched_store(size_t i,uint16_t value) {
 watched_stores++;bad_store_range+=(value>=Qt);bad_store_index+=(i>=1536);
}
static void dump_forward(const char *phase,size_t step,const uint16_t *a) {
 printf("D %zu %s %zu",active_case,phase,step);
 for(size_t i=0;i<1536;i++){printf(" %u",(unsigned)a[i]);}printf("\n");
}
'''
header='static void\nmq_NTT_ternary(uint16_t *a, unsigned logn)\n{\n'
start=source.index(header);end=source.index('\n}\n',start)+len('\n}\n')
body=source[start:end]
body=once(body,'\tn = (size_t)3 << (logn - 1);\n',
    '\tfor(size_t i=0;i<2048;i++)gm[i]=igm[i]=60000;\n\tn = (size_t)3 << (logn - 1);\n')
body=once(body,'\tr = gm_square[1];\n',
    '\tprintf("G %zu",active_case);for(size_t i=0;i<2048;i++)printf(" %u",(unsigned)gm[i]);for(size_t i=0;i<2048;i++)printf(" %u",(unsigned)igm[i]);printf("\\n");\n\tr = gm_square[1];\n')
body=body.replace('gm_square[1]','watched_table(gm_square,1)')
body=once(body,'gm_square[m + u1]','watched_table(gm_square,m + u1)')
body=once(body,'gm_cubic[v]','watched_table(gm_cubic,v)')
stores=[('u','mq_add(a0, b, Qt)'),('u + hn','mq_sub(mq_add(a0, a1, Qt), b, Qt)'),
        ('v','mq_add(a0, a1, Qt)'),('v + ht','mq_sub(a0, a1, Qt)'),
        ('u + 0','mq_add(fA, mq_add(fB0, fC0, Qt), Qt)'),
        ('u + 1','mq_add(fA, mq_add(fB1, fC2, Qt), Qt)'),
        ('u + 2','mq_add(fA, mq_add(fB2, fC1, Qt), Qt)')]
for index,value in stores:
    old='a['+index+'] = '+value+';'
    body=once(body,old,old+' watched_store('+index+',a['+index+']);')
body=once(body,'\tt = hn;\n','\tdump_forward("first",0,a);\n\tt = hn;\n')
body=once(body,'\t\tt = ht;\n','\t\tdump_forward("double",m,a);\n\t\tt = ht;\n')
body=once(body,'\t}\n}\n','\t}\n\tdump_forward("triple",0,a);\n}\n')
instrumented=source[:start]+support+body+source[end:]
variants={
    'baseline':instrumented,
    'noncanonical_triple':once(instrumented,'a[u + 0] = mq_add(fA, mq_add(fB0, fC0, Qt), Qt);','a[u + 0] = Qt;'),
    'wrong_first_pass':once(instrumented,'mq_sub(mq_add(a0, a1, Qt), b, Qt); watched_store','mq_sub(mq_sub(a0, a1, Qt), b, Qt); watched_store'),
    'wrong_table_index':once(instrumented,'watched_table(gm_cubic,v)','watched_table(gm_cubic,v + 1)'),
    'triples_swapped':once(once(instrumented,'a[u + 1] = mq_add(fA, mq_add(fB1, fC2, Qt), Qt);',
        'a[u + 1] = mq_add(fA, mq_add(fB2, fC1, Qt), Qt);'),
        'a[u + 2] = mq_add(fA, mq_add(fB2, fC1, Qt), Qt);','a[u + 2] = mq_add(fA, mq_add(fB1, fC2, Qt), Qt);'),
    'missing_dynamic_generation':source[:start]+support+once(body,'\t\tmq_mkgm3(gm, igm, logn);\n','\t\t;\n')+source[end:]}
arrays='static const uint16_t fixture_a[][1536]={'+','.join('{'+','.join(str(x) for x in v)+'}' for v in fixtures)+'};\n'
main=r'''
int main(void) {
 setvbuf(stdout,NULL,_IONBF,0);
 for(size_t c=0;c<sizeof fixture_a/sizeof fixture_a[0];c++) {
  struct {uint16_t lo,a[1536],hi;} object;
  object.lo=object.hi=60000;memcpy(object.a,fixture_a[c],sizeof object.a);
  active_case=c;watched_stores=bad_store_range=bad_store_index=0;
  table_reads=bad_table_range=bad_table_index=0;
  mq_NTT(object.a,10,1);
  printf("M %zu %zu %zu %zu %zu %zu %zu %u %u\n",c,watched_stores,bad_store_range,bad_store_index,
      table_reads,bad_table_range,bad_table_index,(unsigned)object.lo,(unsigned)object.hi);
 }
 return 0;
}
'''
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,modified in variants.items():
        label=mode+'_'+variant;cfile=Path(label+'.c');binary=Path(label+'.bin')
        cfile.write_text(modified+arrays+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
            '-I',str(root),str(cfile),'-Wl,--gc-sections','-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
        Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
        assert ran.returncode==0 and not ran.stderr,label
        counts={tag:ZZ(0) for tag in ['G','D','M']};differences=[];seen=set();metrics=[]
        for line in ran.stdout.decode().splitlines():
            tag,*payload=line.split();counts[tag]+=1;ok=True
            if tag=='D':
                case=ZZ(payload[0]);phase=payload[1];step=ZZ(payload[2]);values=[ZZ(x) for x in payload[3:]]
                key=(case,phase,step);assert key not in seen;seen.add(key)
                ok=len(values)==n and all(0<=x<q for x in values) and values==references[int(case)][(phase,step)]
            elif tag=='G':
                case=ZZ(payload[0]);values=[ZZ(x) for x in payload[1:]]
                ok=values==gm+igm
            elif tag=='M':
                values=[ZZ(x) for x in payload];case,watched,bad_range,bad_index,reads,bad_tr,bad_ti,lo,hi=values
                ok=watched==15360 and reads==1025 and bad_range==bad_index==bad_tr==bad_ti==0 and lo==hi==60000
                metrics.append(values)
            else: raise AssertionError(tag)
            if not ok: differences.append({'tag':tag,'ordinal':counts[tag]-1})
        assert counts=={'G':10,'D':100,'M':10} and len(seen)==100,counts
        if variant=='baseline': assert not differences,(label,differences[:10])
        else: assert differences,label
        artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'counts':counts,'metrics':metrics,
            'detected_differences':len(differences),'first_differences':differences[:20],'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
result={'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
    'fixture_sha256':digest('PUBLIC_FORWARD_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),
    'source_pins':profile['core']['source_files'],
    'scope':'Ten public synthetic inputs, ten exact forward pass snapshots each, 15360 watched stores and 1025 watched table reads per case, subobject sentinels, dynamic table images/holes, five detected mutations in normal/UBSan modes. ZZ stage/evaluation matches are diagnostic, NOT universal original-f/g evaluation refinement, full public/KeyGen, keys, inverse, probability or review.'}
Path('PUBLIC_FORWARD_CHECK.json').write_text(json.dumps(plain(result),indent=2)+'\n')
