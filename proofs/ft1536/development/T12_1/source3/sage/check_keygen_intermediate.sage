"""Exact public controls for NTT subtraction, intermediate and static tables.

All polynomial expectations use Sage ZZ. C/UBSan runs are finite controls,
including diagnostic root calls; they are not the full solver proof.
"""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

root=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile=json.loads((root/'PROFILE.json').read_text())
def digest(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
for name,pin in profile['core']['source_files'].items(): assert digest(root/name)==pin,name
source=(root/'falcon-keygen.c').read_text()
lines=source.splitlines(keepends=True)
def region(a,b): return ''.join(lines[int(a-1):int(b)])
def once(text,old,new):
    assert text.count(old)==1,old
    return text.replace(old,new,int(1))
def plain(x):
    if isinstance(x,dict): return {str(k):plain(v) for k,v in x.items()}
    if isinstance(x,(list,tuple)): return [plain(v) for v in x]
    if isinstance(x,(str,bool)) or x is None: return x
    return int(x)
B=ZZ(2)^31
def limbs(x,n): return [(ZZ(x)%B^n//B^j)%B for j in range(n)]
def decode(words):
    value=sum(ZZ(w)*B^j for j,w in enumerate(words))
    return value-B^len(words) if words[-1]>=B//2 else value
R=PolynomialRing(ZZ,'X'); X=R.gen()
def phi(n,ter): return X^n-X^(n//2)+1 if ter else X^n+1
def size_table(name):
    text=re.search(r'static const size_t '+name+r'\[\] = \{([^}]+)\}',source).group(1)
    return [ZZ(v) for v in re.findall(r'\d+',text)]
small=[size_table('MAX_BL_SMALL2'),size_table('MAX_BL_SMALL3')]
sizes=[small[0],size_table('MAX_BL_LARGE2'),small[1],size_table('MAX_BL_LARGE3')]
primes=[]
for name in ['PRIMES2','PRIMES3']:
    text=re.search(r'static const small_prime '+name+r'\[\] = \{(.*?)\n\};',source,re.S).group(1)
    primes.append([[ZZ(z) for z in row] for row in re.findall(r'\{\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\}',text)])
assert [len(t) for t in primes]==[522,1101]
assert all(table[-1]==[0,0,0] for table in primes)
expected={}; data=[]
def array(ty,name,rows,width):
    data.append('static const '+ty+' '+name+'[]['+str(width)+']={'+','.join(
        '{'+','.join(str(z) for z in list(row)+[0]*(width-len(row)))+'}' for row in rows)+'};\n')
poly=[]
for logn,full,ter in [(2,0,0),(3,0,0),(2,1,1),(3,0,1),(4,1,1)]:
    n=(1+2*full)*2^(logn-full)
    for sc in [0,31,34]:
        F=[(-1)^j*(2^40+13*j+1) for j in range(n)]
        f=[(-1)^(j+1)*(7*j+3) for j in range(n)]
        k=[(j%5)-2 for j in range(n)]
        result=(R(F)-2^sc*R(f)*R(k))%phi(n,ter)
        poly.append((logn,full,ter,sc,n,F,f,k))
        expected[('N',len(poly)-1)]=sum((limbs(result[j],4) for j in range(n)),[])+[0]
array('unsigned','poly_meta',[row[:5] for row in poly],5)
array('uint32_t','poly_F',[sum((limbs(z,4)+[999] for z in row[5]),[]) for row in poly],120)
array('uint32_t','poly_f',[sum((limbs(z,2)+[888] for z in row[6]),[]) for row in poly],72)
array('int32_t','poly_k',[row[7] for row in poly],24)
cases=[(3,0,1,1),(3,0,3,5),(3,1,1,1),(3,1,-1,1),(3,1,3,5),(10,1,1,1)]
roots=[(3,0,5,7),(3,1,5,7),(10,1,5,7),(10,1,1,1)]
array('int','cases',cases,4);array('int','roots',roots,4)
for t,rows in enumerate(primes):
    for i,row in enumerate(rows): expected[('T',t*2000+i)]=row
for t,rows in enumerate(sizes): expected[('Z',t)]=rows
fixture={'poly':poly,'intermediate':cases,'root_diagnostic':roots,'prime_rows':primes,'size_words':sizes}
Path('PUBLIC_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')
main=r'''
#include <stdio.h>
#include <inttypes.h>
#define COUNT(a) (sizeof(a)/sizeof((a)[0]))
static int changed(const falcon_keygen *fk,const falcon_keygen *old,const uint32_t *data,const int16_t *f,const int16_t *g,const int16_t *sf,const int16_t *sg) {
  return memcmp(fk,old,sizeof *fk)!=0 || data[0]!=1234567 || data[65537]!=1234567 || memcmp(f,sf,3072)!=0 || memcmp(g,sg,3072)!=0;
}
int main(void) {
  setvbuf(stdout,NULL,_IONBF,0);
  for(size_t i=0;i<COUNT(poly_meta);i++) {
    uint32_t F[122],f[72],tmp[65536]; int32_t k[24];
    memcpy(F,poly_F[i],sizeof poly_F[i]); memcpy(f,poly_f[i],sizeof f);memcpy(k,poly_k[i],sizeof k);memset(tmp,0,sizeof tmp);
    F[121]=1234567;
    poly_sub_scaled_ntt(F,4,5,f,2,3,k,poly_meta[i][3],poly_meta[i][0],poly_meta[i][1],(int)poly_meta[i][2],tmp);
    printf("N %zu",i);for(size_t j=0;j<poly_meta[i][4];j++) for(size_t u=0;u<4;u++) printf(" %" PRIu32,F[j*5+u]);
    int bad=F[121]!=1234567 || memcmp(f,poly_f[i],sizeof f)!=0 || memcmp(k,poly_k[i],sizeof k)!=0;
    for(size_t j=0;j<poly_meta[i][4];j++) bad|=F[j*5+4]!=999;
    printf(" %d\n",bad);
  }
  for(size_t i=0;i<COUNT(cases);i++) {
    uint32_t data[65538]={0};int16_t f[1536]={0},g[1536]={0},sf[1536],sg[1536];falcon_keygen fk,old;
    memset(&fk,0,sizeof fk);fk.logn=(unsigned)cases[i][0];fk.ternary=(unsigned)cases[i][1];fk.tmp=data+2;
    f[0]=(int16_t)cases[i][2];g[0]=(int16_t)cases[i][3];memcpy(sf,f,sizeof f);memcpy(sg,g,sizeof g);memcpy(&old,&fk,sizeof fk);
    data[0]=data[65537]=1234567;
    int good=solve_NTRU_deepest(&fk,f,g);
    printf("D %zu %d %d\n",i,good,changed(&fk,&old,data,f,g,sf,sg));
    for(unsigned depth=fk.logn;good && depth-- > 0;) {
      good=solve_NTRU_intermediate(&fk,f,g,depth);
      size_t n=depth==0?MKN(fk.logn,fk.ternary):((size_t)1<<(fk.logn-depth));
      size_t len=(fk.ternary?MAX_BL_SMALL3:MAX_BL_SMALL2)[depth];
      printf("I %zu %u %d %d %zu %zu",i,depth,good,changed(&fk,&old,data,f,g,sf,sg),n,len);
      for(size_t j=0;j<2*n*len;j++) {printf(" %" PRIu32,fk.tmp[j]);} printf("\n");
    }
  }
  for(size_t i=0;i<COUNT(roots);i++) {
    uint32_t data[65538]={0};int16_t f[1536]={0},g[1536]={0},F[1536]={0},G[1536]={0},sf[1536],sg[1536];falcon_keygen fk,old;
    memset(&fk,0,sizeof fk);fk.logn=(unsigned)roots[i][0];fk.ternary=(unsigned)roots[i][1];fk.tmp=data+2;
    f[0]=(int16_t)roots[i][2];g[0]=(int16_t)roots[i][3];memcpy(sf,f,sizeof f);memcpy(sg,g,sizeof g);memcpy(&old,&fk,sizeof fk);
    data[0]=data[65537]=1234567;
    int good=solve_NTRU(&fk,F,G,f,g);size_t n=MKN(fk.logn,fk.ternary);
    printf("R %zu %d %d %zu",i,good,changed(&fk,&old,data,f,g,sf,sg),n);
    for(size_t j=0;j<n;j++) {printf(" %d",(int)F[j]);} for(size_t j=0;j<n;j++) {printf(" %d",(int)G[j]);} printf("\n");
  }
  const small_prime *tables[2]={PRIMES2,PRIMES3};size_t lengths[2]={COUNT(PRIMES2),COUNT(PRIMES3)};
  for(size_t t=0;t<2;t++) for(size_t i=0;i<lengths[t];i++) printf("T %zu %" PRIu32 " %" PRIu32 " %" PRIu32 "\n",t*2000+i,tables[t][i].p,tables[t][i].g,tables[t][i].s);
  const size_t *st[4]={MAX_BL_SMALL2,MAX_BL_LARGE2,MAX_BL_SMALL3,MAX_BL_LARGE3};size_t sl[4]={COUNT(MAX_BL_SMALL2),COUNT(MAX_BL_LARGE2),COUNT(MAX_BL_SMALL3),COUNT(MAX_BL_LARGE3)};
  for(size_t t=0;t<4;t++) {printf("Z %zu",t);for(size_t j=0;j<sl[t];j++) printf(" %zu",st[t][j]);printf("\n");}
  return 0;
}
'''
variants={'baseline':source,
  'ntt_signed_k':once(source,region(4595,4675),once(region(4595,4675),'modp_set(k[v], p)','modp_set(-k[v], p)')),
  'intermediate_return':once(source,region(5801,6390),once(region(5801,6390),'return 1;','return 0;')),
  'intermediate_word':once(source,region(5801,6390),once(region(5801,6390),'return 1;','fk->tmp[0] ^= 1; return 1;')),
  'last_prime_word':once(source,lines[2468],once(lines[2468],'634606382','634606383'))}
records=[]
for mode,flags in [('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all']),('normal',['-O2'])]:
  for variant,body in variants.items():
    label=mode+'_'+variant;cfile=Path(label+'.c');binary=Path(label+'.bin')
    cfile.write_text(body+''.join(data)+main)
    command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
      '-I',str(root),str(cfile),str(root/'falcon-fft.c'),str(root/'fpr-emulated.c'),'-Wl,--gc-sections','-o',str(binary)]
    compiled=subprocess.run(command,capture_output=True)
    Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
    assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
    ran=subprocess.run([str(binary.resolve())],capture_output=True)
    Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
    Path(label+'.run.json').write_text(json.dumps({'returncode':ran.returncode})+'\n')
    assert ran.returncode==0 and not ran.stderr,label
    seen=set();differences=[];counts={};depths={i:[] for i in range(len(cases))}
    for line in ran.stdout.decode().splitlines():
      tag,raw,*payload=line.split();i=int(raw);v=[ZZ(z) for z in payload]
      key=(tag,i,int(v[0])) if tag=='I' else (tag,i)
      assert key not in seen;seen.add(key);counts[tag]=counts.get(tag,int(0))+int(1)
      if tag=='D': ok=v==[1,0]
      elif tag=='I':
        depth,success,bad,n,length=v[:5];words=v[5:];logn,ter,f,g=cases[i]
        assert len(words)==2*n*length
        depths[i].append(depth)
        original=(1+2*ter)*2^(logn-ter)
        F=R([decode(words[int(j*length):int((j+1)*length)]) for j in range(n)])
        G=R([decode(words[int((n+j)*length):int((n+j+1)*length)]) for j in range(n)])
        equation=(f^(original//n)*G-g^(original//n)*F)%phi(n,ter)
        ok=success==1 and bad==0 and n==(original if depth==0 else 2^(logn-depth)) and length==small[ter][depth] and equation==(18433 if ter else 12289)
      elif tag=='R':
        success,bad,n=v[:3];logn,ter,f,g=roots[i];F=R(v[3:int(3+n)]);G=R(v[int(3+n):])
        ok=bad==0 and success==(i!=3) and (not success or ((f*G-g*F)%phi(n,ter)==(18433 if ter else 12289) and max(abs(z) for z in v[3:])<=2047))
      else: ok=v==expected[(tag,i)]
      if not ok: differences.append(line[:int(160)])
    for i,(logn,ter,f,g) in enumerate(cases):
      if depths[i]!=list(range(logn-1,-1,-1)): differences.append('incomplete intermediate depth trace '+str(i))
    assert bool(differences)==(variant!='baseline'),(label,differences[:3])
    artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
    records.append({'mode':mode,'variant':variant,'counts':counts,'differences':differences,'command':command,
      'artifacts':{str(p):digest(p) for p in artifacts}})
Path('INTERMEDIATE_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
  'fixture_sha256':digest('PUBLIC_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),'source_pins':profile['core']['source_files'],
  'scope':'Exact scaled polynomial subtraction; complete synthetic deepest/intermediate depth traces and diagnostic root calls; input/context frames and all static prime/size rows. Finite controls, not universal search/solver/termination/probability or compiler correctness.'},indent=2)+'\n')
