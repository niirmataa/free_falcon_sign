"""Finite public mq/table/transform controls; no KeyGen or private-key generation.

Run through the standard Sage preparser. All reference arithmetic is exact
ZZ or its residue/polynomial rings. These checks do NOT discharge the missing
source table/transform/caller proofs in B1.06.
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

q=ZZ(18433);R=ZZ(2)^16;n=ZZ(1536)
assert q.is_prime() and R%q==10237 and (R^2)%q==4564
assert (q*18431+1)%R==0
generator=ZZ(25);base=power_mod(generator,2,q)
assert power_mod(generator,9216,q)==1
assert power_mod(generator,4608,q)!=1 and power_mod(generator,3072,q)!=1
assert power_mod(base,4608,q)==1
assert power_mod(base,2304,q)!=1 and power_mod(base,1536,q)!=1
def rev(x,bits):
    z=ZZ(0)
    for j in range(bits): z=2*z+((x>>j)&1)
    return z
def exponent(i):
    i=max(ZZ(1),ZZ(i));k=ZZ(i.nbits()-1);j=i-2^k
    u=rev(j,k)
    return (1 if k==9 else 3*2^(8-k))*(3*u+1+u%2)
points=[power_mod(base,exponent(512+i//3)+1536*(i%3),q) for i in range(n)]
assert len(set(points))==n
assert all((power_mod(x,n,q)-power_mod(x,n//2,q)+1)%q==0 for x in points)
tables=[]
for i in range(1024):
    root_i=power_mod(base,exponent(i),q)
    inverse_i=inverse_mod(root_i,q) if i else inverse_mod(2*root_i-1,q)
    tables.append([(R*root_i)%q,(R*inverse_i)%q])

fixtures=[]
for index in [0,1,767,768,1535]:
    v=[ZZ(0)]*int(n);v[index]=1;fixtures.append(v)
for label in ['FT1536 public transform 033/A','FT1536 public transform 033/B']:
    tape=hashlib.shake_256(label.encode()).digest(int(2*n))
    fixtures.append([ZZ(int.from_bytes(tape[int(2*i):int(2*i+2)],'little'))%q for i in range(n)])
public=[]
for f in [([1]+[0]*int(n-1)),([0,1]+[0]*int(n-2)),([0]*int(n)),
          [ZZ((i*11+3)%3)-1 for i in range(n)]]:
    g=[ZZ((i*7+1)%3)-1 for i in range(n)]
    public.append({'f':f,'g':g})
fixture={'transforms':fixtures,'public':public,'points':points,'tables':tables}
Path('PUBLIC_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')
arrays='static const uint16_t fixture_a[][1536]={'+','.join('{'+','.join(str(x) for x in v)+'}' for v in fixtures)+'};\n'
arrays+='static const int16_t fixture_f[][1536]={'+','.join('{'+','.join(str(x) for x in v['f'])+'}' for v in public)+'};\n'
arrays+='static const int16_t fixture_g[][1536]={'+','.join('{'+','.join(str(x) for x in v['g'])+'}' for v in public)+'};\n'
main=r'''
#include <stdio.h>
int main(void) {
 setvbuf(stdout,NULL,_IONBF,0);
 for(uint32_t y=0;y<Qt;y++) {
  uint32_t x=(y*997+17)%Qt;
  printf("S %u %u %u %u %u %u %u\n",x,y,mq_add(x,y,Qt),mq_sub(x,y,Qt),mq_montymul(x,y,Qt,Q0It),mq_rshift1(y,Qt),mq_div_18433(x,y));
 }
 for(int x=-9216;x<=9216;x++)printf("C %d %u\n",x,mq_conv_small(x,Qt));
 uint16_t gm[2048],igm[2048];
 for(size_t i=0;i<2048;i++)gm[i]=igm[i]=60000;
 mq_mkgm3(gm,igm,10);
 for(size_t i=0;i<2048;i++)printf("G %zu %u %u\n",i,(unsigned)gm[i],(unsigned)igm[i]);
 for(size_t c=0;c<sizeof fixture_a/sizeof fixture_a[0];c++) {
  uint16_t a[1538];a[0]=a[1537]=60000;memcpy(a+1,fixture_a[c],sizeof fixture_a[c]);
  mq_NTT(a+1,10,1);
  printf("T %zu %u %u",c,(unsigned)a[0],(unsigned)a[1537]);
  for(size_t i=1;i<=1536;i++){printf(" %u",(unsigned)a[i]);}printf("\n");
  mq_iNTT(a+1,10,1);
  printf("I %zu %u %u",c,(unsigned)a[0],(unsigned)a[1537]);
  for(size_t i=1;i<=1536;i++){printf(" %u",(unsigned)a[i]);}printf("\n");
 }
 for(size_t c=0;c<sizeof fixture_f/sizeof fixture_f[0];c++) {
  int16_t f[1538],g[1538];uint16_t h[1538];
  f[0]=g[0]=f[1537]=g[1537]=12345;h[0]=h[1537]=54321;
  memcpy(f+1,fixture_f[c],sizeof fixture_f[c]);memcpy(g+1,fixture_g[c],sizeof fixture_g[c]);
  int result=falcon_compute_public(h+1,f+1,g+1,10,1);
  int changed=memcmp(f+1,fixture_f[c],sizeof fixture_f[c]) || memcmp(g+1,fixture_g[c],sizeof fixture_g[c]);
  changed |= f[0]!=12345 || g[0]!=12345 || f[1537]!=12345 || g[1537]!=12345 || h[0]!=54321 || h[1537]!=54321;
  printf("P %zu %d %d",c,result,changed);
  if(result==1){for(size_t i=1;i<=1536;i++)printf(" %u",(unsigned)h[i]);}printf("\n");
 }
 return 0;
}
'''
variants={
 'baseline':source,
 'wrong_mask':once(source,'(z * q0i) & 0xFFFF','(z * q0i) & 0xFFFE'),
 'wrong_q0i':once(source,'#define Q0It   18431','#define Q0It   18430'),
 'wrong_division_chain':once(source,'y18 = mq_montymul(y17, y8, Qt, Q0It);','y18 = mq_montymul(y17, y7, Qt, Q0It);'),
 'wrong_root':once(source,'g = mq_montymul(25, R2t, Qt, Q0It);','g = mq_montymul(26, R2t, Qt, Q0It);'),
 'wrong_inverse_scale':once(source,'mq_div_18433(Rt, (uint32_t)n)','mq_div_18433(R2t, (uint32_t)n)'),
 'missing_nonzero_test':once(source,'if (t[u] == 0) {','if (0) {')}
records=[];baseline=None
ring=PolynomialRing(Zmod(q),'X');X=ring.gen();phi=X^n-X^(n//2)+1
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
  counts={tag:ZZ(0) for tag in ['S','C','G','T','I','P']};differences=[];public_results=[]
  for line in ran.stdout.decode().splitlines():
   tag,*payload=line.split();v=[ZZ(x) for x in payload];counts[tag]+=1;ok=True
   if tag=='S':
    x,y,a,s,m,h,d=v
    ok=0<=a<q and a==(x+y)%q and 0<=s<q and s==(x-y)%q
    ok=ok and 0<=m<q and (m*R)%q==(x*y)%q and 0<=h<q and (2*h)%q==y
    ok=ok and 0<=d<q and (d==0 if y==0 else (d*y)%q==x)
   elif tag=='C': x,z=v;ok=0<=z<q and z==x%q
   elif tag=='G': i,g,ig=v;ok=[g,ig]==(tables[int(i)] if i<1024 else [60000,60000])
   elif tag in ['T','I']:
    c,lo,hi,*a=v;ok=lo==hi==60000 and len(a)==n and all(0<=z<q for z in a)
    if tag=='I':ok=ok and a==fixtures[int(c)]
    else:
     polynomial=ring(fixtures[int(c)])
     expected=[ZZ(polynomial(ring.base_ring()(z))) for z in points]
     ok=ok and a==expected
   elif tag=='P':
    c,result,changed,*h=v;f=ring(public[int(c)]['f']);g=ring(public[int(c)]['g'])
    invertible=all(f(ring.base_ring()(z))!=0 for z in points)
    ok=not changed and result==int(invertible)
    if result==1:ok=ok and len(h)==n and all(0<=z<q for z in h) and (ring(h)*f-g)%phi==0
    public_results.append({'case':c,'returned':result,'frame_changed':changed,'invertible':bool(invertible),'equation_if_success':bool(ok)})
   else:raise AssertionError(tag)
   if not ok:differences.append({'tag':tag,'ordinal':counts[tag]-1})
  assert counts=={'S':q,'C':q,'G':2048,'T':len(fixtures),'I':len(fixtures),'P':len(public)},counts
  if variant=='baseline':
   assert not differences,(label,differences[:10])
   assert [r['returned'] for r in public_results[:3]]==[1,1,0]
   if baseline is None:baseline=public_results
   else:assert baseline==public_results
  else:assert differences,label
  artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
  records.append({'mode':mode,'variant':variant,'counts':counts,'public_results':public_results,
   'detected_differences':len(differences),'first_differences':differences[:20],'command':command,
   'artifacts':{str(p):digest(p) for p in artifacts}})
Path('PUBLIC_CHECK.json').write_text(json.dumps(plain({'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
 'fixture_sha256':digest('PUBLIC_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),'source_pins':profile['core']['source_files'],
 'scope':'Exact finite public helper sweeps, M0 dynamic gm/igm words, seven synthetic polynomial transforms/inverses and four public-call material/equation controls, six detected mutations in both normal/UBSan modes. NOT universal source table/transform/caller correctness, accepted KeyGen, emitted keys or probability evidence.'}),indent=2)+'\n')
