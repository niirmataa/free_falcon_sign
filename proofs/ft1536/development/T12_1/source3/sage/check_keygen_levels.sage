"""Exact public controls for B1.05 search dependencies and early frames.

ZZ/GF(2) give independent bigint, ternary norm and resultant expectations.
These finite C/UBSan controls supplement the source-bound kernel proofs.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess

root=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile=json.loads((root/'PROFILE.json').read_text())
def digest(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()
for name,pin in profile['core']['source_files'].items():
    assert digest(root/name)==pin,name
source=(root/'falcon-keygen.c').read_text()
lines=source.splitlines(keepends=True)
def region(a,b):
    return ''.join(lines[int(a-1):int(b)])
def once(text,old,new):
    assert text.count(old)==int(1),old
    return text.replace(old,new,int(1))

B=ZZ(2)^31; p=ZZ(2147355649)
lengths=[0,1,2,5,17]
limbs=[]; zexpected=[]
for length in lengths:
    a=[(B-1-193*j)%B for j in range(length)]
    b=[(1234567+9876543*j)%B for j in range(length)]
    if length==1: b=[B-1]
    A=sum(a[j]*B^j for j in range(length)); C=sum(b[j]*B^j for j in range(length))
    def words(v,n): return [int((ZZ(v)//B^j)%B) for j in range(n)]
    limbs.append({'len':int(length),'a':[int(z) for z in a],'b':[int(z) for z in b]})
    rows=[]
    rows.append([int((A+C)//B^length)]+words(A+C,length))
    rows.append([int(A<C)]+words(A-C,length))
    rows.append([int((A*31337)//B^length)]+words(A*31337,length))
    rows.append([int(A%2)]+words(A//2,length))
    rows.append([int(A%p)])
    rows.append([int(-1 if A<C else 1 if A>C else 0)])
    rows.append(words(A+C*31337,length+1))
    zexpected.append(rows)

R=PolynomialRing(ZZ,'X'); X=R.gen(); phi=X^512-X^256+1
S=PolynomialRing(GF(2),'Y'); Y=S.gen(); phi2=Y^1536+Y^768+1
cases=[]
for k in range(5):
    f=[ZZ(0)]*1536; g=[ZZ(0)]*1536
    if k:
        for j in range(24):
            f[int((j*61+k*7)%1536)]=ZZ((j+k)%3)-1
            g[int((j*47+k*19)%1536)]=ZZ((2*j+k)%3)-1
    if k==1: f=[ZZ(1)]+[ZZ(0)]*1535
    if k==2: g=[ZZ(-1)]+[ZZ(0)]*1535
    def norm(v):
        parts=[sum(v[3*j+r]*X^j for j in range(512)) for r in range(3)]
        a,b,c=parts
        h=(a^3+X*b^3+X^2*c^3-3*X*a*b*c)%phi
        return [int(h[j]%p) for j in range(512)]
    def mod2(v):
        poly=S([int(z%2) for z in v])
        return int(poly.gcd(phi2)==1)
    cases.append({'f':[int(z) for z in f],'g':[int(z) for z in g],
        'norm_f':norm(f),'norm_g':norm(g),'res_f':mod2(f),'res_g':mod2(g)})
Path('PUBLIC_FIXTURE.json').write_text(json.dumps({'limbs':limbs,'cases':cases},indent=2)+'\n')
data='static const size_t lengths[5]={0,1,2,5,17};\n'
for name in ['a','b']:
    data+='static const uint32_t limb_'+name+'[5][17]={\n'+',\n'.join(
        '{'+','.join(str(z) for z in item[name]+[0]*(17-item['len']))+'}' for item in limbs)+'\n};\n'
for name in ['f','g']:
    data+='static const int16_t input_'+name+'[5][1536]={\n'+',\n'.join(
        '{'+','.join(str(z) for z in item[name])+'}' for item in cases)+'\n};\n'
norm_body=region(7969,7990)
norm_function='''
static int raw_norm_fragment(const int16_t *f,const int16_t *g,fpr bound,fpr *result) {
  fpr rt1[1536],rt2[1536],norm=0;
  unsigned logn=10; size_t n=1536,u;
  int accepted=0;
  do {
'''+norm_body+'''
    accepted=1;
  } while (0);
  *result=norm;
  return accepted;
}
'''
main=r'''
#include <stdio.h>
#include <inttypes.h>
#include <stddef.h>
int main(void) {
  printf("L %zu %zu %zu %zu\n",sizeof(small_prime),offsetof(small_prime,p),offsetof(small_prime,g),offsetof(small_prime,s));
  for(unsigned k=0;k<5;k++) {
    size_t n=lengths[k]; uint32_t a[18],b[18];
    for(unsigned op=0;op<7;op++) {
      memset(a,0,sizeof a); memset(b,0,sizeof b);
      memcpy(a,limb_a[k],n*4); memcpy(b,limb_b[k],n*4);
      int64_t ret=0;
      switch(op) {
        case 0: ret=zint_add(a,b,n); break;
        case 1: ret=zint_sub(a,b,n); break;
        case 2: ret=zint_mul_small(a,n,31337); break;
        case 3: ret=zint_rshift1(a,n); break;
        case 4: ret=zint_mod_small_unsigned(a,n,PRIMES3[0].p,modp_ninv31(PRIMES3[0].p),modp_R2(PRIMES3[0].p,modp_ninv31(PRIMES3[0].p))); break;
        case 5: ret=zint_ucmp(a,b,n); break;
        case 6: zint_add_mul_small(a,b,n,31337); break;
      }
      printf("Z %u %u",k,op);
      if(op!=6) printf(" %" PRId64,ret);
      if(op<4 || op==6) for(size_t j=0;j<n+(op==6);j++) printf(" %" PRIu32,a[j]);
      printf("\n");
    }
  }
  for(unsigned full=0;full<2;full++) for(unsigned logn=1+full;logn<11;logn++) for(size_t stride=1;stride<=3;stride+=2) {
    uint32_t a[4608],saved[4608],gm[1536],igm[1536];
    size_t n=MKN(logn,full); uint32_t p=PRIMES3[0].p,pi=modp_ninv31(p);
    for(size_t j=0;j<4608;j++) a[j]=UINT32_C(0xAB31E27D);
    for(size_t j=0;j<n;j++) a[j*stride]=(uint32_t)((j*1234567+91)%p);
    memcpy(saved,a,sizeof a); modp_mkgm3(gm,igm,logn,full,PRIMES3[0].g,p,pi);
    modp_NTT3_ext(a,stride,gm,logn,full,p,pi); modp_iNTT3_ext(a,stride,igm,logn,full,p,pi);
    printf("N %u %u %zu %d\n",full,logn,stride,memcmp(a,saved,sizeof a)!=0);
  }
  for(unsigned k=0;k<5;k++) {
    int16_t f[1536],g[1536]; uint32_t storage[20002];
    memcpy(f,input_f[k],sizeof f); memcpy(g,input_g[k],sizeof g);
    unsigned rf=mod2_res_ternary(f,10),rg=mod2_res_ternary(g,10);
    printf("R %u %u %u %d\n",k,rf,rg,memcmp(f,input_f[k],sizeof f)!=0 || memcmp(g,input_g[k],sizeof g)!=0);
    for(int transformed=0;transformed<2;transformed++) {
      memset(storage,0,sizeof storage); storage[0]=storage[20001]=UINT32_C(0xBCD2E391);
      uint32_t *a=storage+1,p=PRIMES3[0].p,pi=modp_ninv31(p);
      for(size_t j=0;j<1536;j++) {a[j]=modp_set(input_f[k][j],p);a[1536+j]=modp_set(input_g[k][j],p);}
      make_fg_ternary_top(a,10,transformed);
      if(transformed) {
        uint32_t gm[512],igm[512];modp_mkgm3(gm,igm,9,0,PRIMES3[0].g,p,pi);
        modp_iNTT3(a,igm,9,0,p,pi);modp_iNTT3(a+512,igm,9,0,p,pi);
      }
      printf("T %u %d %d",k,transformed,storage[0]!=UINT32_C(0xBCD2E391) || storage[20001]!=UINT32_C(0xBCD2E391));
      for(size_t j=0;j<1024;j++) { printf(" %" PRIu32,a[j]); }
      printf("\n");
    }
    for(unsigned b=0;b<3;b++) {
      memcpy(f,input_f[k],sizeof f);memcpy(g,input_g[k],sizeof g);
      fpr bound=fpr_of(b==0?0:b==1?1:1000000000),norm;
      int accepted=raw_norm_fragment(f,g,bound,&norm);
      printf("Q %u %u %d %" PRIu64 " %" PRIu64 " %d\n",k,b,accepted,(uint64_t)norm,(uint64_t)bound,
        memcmp(f,input_f[k],sizeof f)!=0 || memcmp(g,input_g[k],sizeof g)!=0);
    }
  }
  return 0;
}
'''
variants={
    'baseline':(source,norm_function),
    'inverse_scale':(once(source,'ni = modp_div(R, (uint32_t)n, p, p0i, R);','ni = R;'),norm_function),
    'top_g_alias':(once(source,'gd = fd + tn;','gd = fd + tn + 1;'),norm_function),
    'mul_carry':(once(source,region(3366,3381),once(region(3366,3381),'z >> 31','z >> 30')),norm_function),
    'sub_mask':(once(source,region(3345,3360),once(region(3345,3360),'0x7FFFFFFF','0x3FFFFFFF')),norm_function),
    'resultant_writes_f':(once(source,region(541,772),once(region(541,772),'return b[0] != 0;','((int16_t *)f)[0] = 7;\n\treturn b[0] != 0;')),norm_function),
    'norm_writes_g':(source,once(norm_function,'norm = fpr_double(norm);','norm = fpr_double(norm);\n\t((int16_t *)g)[0] = 7;')),
}
records=[]
for mode,flags in [('normal',['-O2']),('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all'])]:
    for variant,(body,norm) in variants.items():
        label=mode+'_'+variant; cfile=Path(label+'.c'); binary=Path(label+'.bin')
        cfile.write_text(body+norm+data+main)
        command=['gcc','-std=c99','-Wall','-Wextra','-Werror','-ffunction-sections','-fdata-sections']+profile['core']['Makefile_flags']+flags+[
            '-I',str(root),str(cfile),str(root/'falcon-fft.c'),str(root/'fpr-emulated.c'),'-Wl,--gc-sections','-o',str(binary)]
        compiled=subprocess.run(command,capture_output=True)
        Path(label+'.compile.stdout').write_bytes(compiled.stdout);Path(label+'.compile.stderr').write_bytes(compiled.stderr)
        assert compiled.returncode==0 and not compiled.stdout and not compiled.stderr,label
        ran=subprocess.run([str(binary.resolve())],capture_output=True)
        Path(label+'.stdout').write_bytes(ran.stdout);Path(label+'.stderr').write_bytes(ran.stderr)
        assert ran.returncode==0 and not ran.stderr,label
        rows=ran.stdout.decode().splitlines(); differences=[]; counts={}
        for row in rows:
            kind,*raw=row.split(); z=[ZZ(s) for s in raw]; counts[kind]=counts.get(kind,int(0))+int(1)
            if kind=='L': ok=z==[12,0,4,8]
            elif kind=='Z': ok=z[2:]==zexpected[int(z[0])][int(z[1])]
            elif kind=='N': ok=z[3]==0
            elif kind=='R': ok=z[1:]==[cases[int(z[0])]['res_f'],cases[int(z[0])]['res_g'],0]
            elif kind=='T': ok=z[2:]==[0]+cases[int(z[0])]['norm_f']+cases[int(z[0])]['norm_g']
            elif kind=='Q':
                k,b,accepted,x,y,changed=z
                sx=x if x<2^63 else x-2^64;sy=y if y<2^63 else y-2^64
                cc0=ZZ(sx<sy);cc1=ZZ(sx>sy)
                expected=cc0.__xor__((cc0.__xor__(cc1)) & ((x & y)>>63))
                ok=changed==0 and accepted==expected
            else: raise AssertionError(kind)
            if not ok: differences.append(row[:int(160)])
        assert counts=={'L':1,'Z':35,'N':38,'R':5,'T':10,'Q':15},counts
        assert bool(differences)==(variant!='baseline'),(label,differences[:3])
        files=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr')]
        records.append({'mode':mode,'variant':variant,'differences':differences,'counts':counts,'command':command,
            'artifacts':{str(f):digest(f) for f in files}})
Path('LEVELS_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS',
    'variants':records,'fixture_sha256':digest('PUBLIC_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),
    'source_pins':profile['core']['source_files'],'scope':'Seven bigint leaves, forward/inverse38 dimension/stride cases, five public GF2 resultants, ten exact ZZ ternary-top norms and fifteen raw-norm frame/gate cases per run. No full deepest/intermediate/root execution or probability theorem.'},indent=2)+'\n')
