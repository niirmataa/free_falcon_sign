"""Exact public controls for extraction, scaled arithmetic and deepest closure.

Sage ZZ/QQ supply independent expectations. Finite C/UBSan controls are
supplementary evidence, not a universal algorithm or compiler proof.
"""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

root=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
profile=json.loads((root/'PROFILE.json').read_text())
def digest(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
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
def signed_bits(x): return ZZ(x if x>=0 else -x-1).nbits()
def fpbits(value):
    value=QQ(value)
    if value==0: return ZZ(0)
    sign=ZZ(value<0); value=abs(value)
    exponent=ZZ(value.numerator().nbits()-value.denominator().nbits())
    while value<QQ(2)^exponent: exponent-=1
    while value>=QQ(2)^(exponent+1): exponent+=1
    assert -1022<=exponent<=1023
    scaled=value*QQ(2)^(52-exponent); mantissa=scaled.floor()
    if scaled-mantissa>QQ(1)/2 or (scaled-mantissa==QQ(1)/2 and mantissa%2): mantissa+=1
    if mantissa==2^53: mantissa//=2; exponent+=1
    return sign*2^63+(exponent+1023)*2^52+(mantissa-2^52)

expected={}; data=[]
def array(ty,name,rows,width=None):
    if width is None:
        data.append('static const '+ty+' '+name+'[]={'+','.join(str(z) for z in rows)+'};\n')
    else:
        data.append('static const '+ty+' '+name+'[]['+str(width)+']={'+','.join(
            '{'+','.join(str(z) for z in list(row)+[0]*(width-len(row)))+'}' for row in rows)+'};\n')
words=sorted(set([ZZ(0),B-1]+[z for k in range(31) for z in [2^k-1,2^k,2^k+1] if z<B]))
array('uint32_t','words',words)
for i,x in enumerate(words): expected[('W',i)]=[x.nbits()]
big=[(0,ZZ(0),0)]
for n in [1,2,4]:
    for x in sorted(set([-B^n//2,-B^n//2+1,-2^30,-1,0,1,2^30-1,B^n//2-1])):
        for sc in sorted(set([0,1,30,31,32,max(0,abs(x).nbits()-62)])):
            if abs(x)<2^(sc+63): big.append((n,x,sc))
array('uint32_t','big_words',[limbs(x,n) for n,x,sc in big],4)
array('unsigned','big_meta',[(n,sc) for n,x,sc in big],2)
for i,(n,x,sc) in enumerate(big): expected[('B',i)]=[signed_bits(x),x//2^sc]

scaled=[]
for sc in [0,1,30,31,32,61]:
    for k in [-3,0,5]:
        for ylen in [0,2]: scaled.append((2^90-2^39+17,-2^41+3,ylen,k,sc))
array('uint32_t','scaled_x',[limbs(x,4) for x,y,n,k,s in scaled],4)
array('uint32_t','scaled_y',[limbs(y,n) for x,y,n,k,s in scaled],2)
array('int32_t','scaled_meta',[(n,k,s) for x,y,n,k,s in scaled],3)
for i,(x,y,n,k,s) in enumerate(scaled):
    actual_y=y if n else ZZ(0)
    expected[('A',i)]=limbs(x+k*actual_y*2^s,4)+limbs(x-actual_y*2^s,4)

fp=[]
for coeff in [[0,1,-1,2^80+2^27+1],[2^60-1,-2^60,2^53+1,-(2^53+3)]]:
    for scale in [0,37,80]: fp.append((coeff,scale))
array('uint32_t','fp_words',[sum((limbs(z,4)+[123456] for z in coeff),[]) for coeff,scale in fp],20)
array('unsigned','fp_scale',[scale for coeff,scale in fp])
for i,(coeff,scale) in enumerate(fp):
    bl=max(signed_bits(z) for z in coeff); off=max(0,bl-63)
    expected[('P',i)]=[bl]+[fpbits(QQ(z//2^off)*QQ(2)^(off-scale)) for z in coeff]+[0]

R=PolynomialRing(ZZ,'X'); X=R.gen()
def phi(n,ter): return X^n-X^(n//2)+1 if ter else X^n+1
poly=[]
for logn,full,ter in [(2,0,0),(2,1,1),(3,0,1)]:
    n=(1+2*full)*2^(logn-full)
    for sc in [0,31,34]:
        F=[(-1)^j*(2^40+13*j+1) for j in range(n)]
        f=[(-1)^(j+1)*(7*j+3) for j in range(n)]
        k=[(j%5)-2 for j in range(n)]
        result=(R(F)-2^sc*R(f)*R(k))%phi(n,ter)
        poly.append((logn,full,ter,sc,n,F,f,k,[result[j] for j in range(n)]))
array('uint32_t','poly_F',[sum((limbs(z,4)+[999] for z in row[5]),[]) for row in poly],40)
array('uint32_t','poly_f',[sum((limbs(z,2)+[888] for z in row[6]),[]) for row in poly],24)
array('int32_t','poly_k',[row[7] for row in poly],8)
array('unsigned','poly_meta',[row[:5] for row in poly],5)
for i,row in enumerate(poly): expected[('S',i)]=sum((limbs(z,4) for z in row[8]),[])+[0]

def table(name):
    text=re.search(r'static const size_t '+name+r'\[\] = \{([^}]+)\}',source).group(1)
    return [ZZ(t) for t in re.findall(r'\d+',text)]
small=[table('MAX_BL_SMALL2'),table('MAX_BL_SMALL3')]
prime_tables=[]
for name in ['PRIMES2','PRIMES3']:
    text=re.search(r'static const small_prime '+name+r'\[\] = \{(.*?)\n\};',source,re.S).group(1)
    prime_tables.append([ZZ(z) for z in re.findall(r'\{\s*(\d+)',text)])
def norms(coeff,logn,ter,depth):
    n=(1+2*ter)*2^(logn-ter); p=R(coeff)
    for d in range(depth):
        if ter and d==0:
            a,b,c=[R([p[3*j+r] for j in range(n//3)]) for r in range(3)]
            n//=3; p=(a^3+X*b^3+X^2*c^3-3*X*a*b*c)%phi(n,1)
        elif ter and n==2:
            p=R(p[0]^2+p[0]*p[1]+p[1]^2); n=ZZ(1)
        else:
            a,b=[R([p[2*j+r] for j in range(n//2)]) for r in range(2)]
            n//=2; p=(a^2-X*b^2)%phi(n,ter)
    return n,p
make=[]
for ter in [0,1]:
    for depth in [0,1,2,3]:
        for transformed in ([1] if depth==0 else [0,1]):
            f=[1,1,0,-1]; g=[-1,0,1,0,1]
            n,fn=norms(f,3,ter,depth); _,gn=norms(g,3,ter,depth)
            length=small[ter][depth]
            make.append((3,ter,depth,transformed,n,length,f,g))
            expected[('M',len(make)-1)]=[fn[j]%prime_tables[ter][u] for j in range(n) for u in range(length)]+[
                gn[j]%prime_tables[ter][u] for j in range(n) for u in range(length)]+[0]
array('unsigned','make_meta',[row[:6] for row in make],6)
array('int16_t','make_f',[row[6] for row in make],16)
array('int16_t','make_g',[row[7] for row in make],16)
deep=[]
for logn,ter in [(3,0),(3,1),(10,1)]:
    for f,g in [([1],[1]),([-1],[1]),([0],[1]),([1,1,0,-1],[-1,0,1,0,1])]:
        if logn==10 and len(f)>1: continue
        _,fn=norms(f,logn,ter,logn); _,gn=norms(g,logn,ter,logn)
        a=fn[0]; b=gn[0]
        success=ZZ(a%2==1 and b%2==1 and gcd(a,b)==1)
        deep.append((logn,ter,small[ter][logn],f,g,a,b,success))
array('unsigned','deep_meta',[row[:3] for row in deep],3)
array('int16_t','deep_f',[row[3] for row in deep],16)
array('int16_t','deep_g',[row[4] for row in deep],16)
fixture={'words':words,'big':big,'scaled':scaled,'fp':fp,'poly':poly,'make':make,'deep':deep}
Path('PUBLIC_FIXTURE.json').write_text(json.dumps(plain(fixture),indent=2)+'\n')

main=r'''
#include <stdio.h>
#include <inttypes.h>
#define COUNT(a) (sizeof(a)/sizeof((a)[0]))
int main(void) {
  setvbuf(stdout,NULL,_IONBF,0);
  for(size_t i=0;i<COUNT(words);i++) printf("W %zu %u\n",i,bitlength(words[i]));
  for(size_t i=0;i<COUNT(big_words);i++) printf("B %zu %u %" PRId64 "\n",i,zint_signed_bit_length(big_words[i],big_meta[i][0]),zint_get_top(big_words[i],big_meta[i][0],big_meta[i][1]));
  for(size_t i=0;i<COUNT(scaled_x);i++) {
    uint32_t a[4],b[4]; memcpy(a,scaled_x[i],sizeof a); memcpy(b,a,sizeof b);
    unsigned sc=(unsigned)scaled_meta[i][2];
    zint_add_scaled_mul_small(a,4,scaled_y[i],(size_t)scaled_meta[i][0],scaled_meta[i][1],sc/31,sc%31);
    zint_sub_scaled(b,4,scaled_y[i],(size_t)scaled_meta[i][0],sc/31,sc%31);
    printf("A %zu",i); for(size_t j=0;j<4;j++) printf(" %" PRIu32,a[j]);
    for(size_t j=0;j<4;j++) { printf(" %" PRIu32,b[j]); } printf("\n");
  }
  for(size_t i=0;i<COUNT(fp_words);i++) {
    uint32_t f[20]; fpr d[4]; memcpy(f,fp_words[i],sizeof f);
    uint32_t bl=poly_max_bitlength(f,4,5,2,0); poly_big_to_fp(d,f,4,5,2,0,bl,fp_scale[i]);
    printf("P %zu %" PRIu32,i,bl); for(size_t j=0;j<4;j++) printf(" %" PRIu64,(uint64_t)d[j]);
    printf(" %d\n",memcmp(f,fp_words[i],sizeof f)!=0);
  }
  for(size_t i=0;i<COUNT(poly_meta);i++) {
    uint32_t F[128],f[24]; int32_t k[8]; memset(F,0,sizeof F);
    memcpy(F,poly_F[i],sizeof poly_F[i]); memcpy(f,poly_f[i],sizeof f); memcpy(k,poly_k[i],sizeof k);
    F[127]=1234567;
    poly_sub_scaled(F,4,5,f,2,3,k,poly_meta[i][3],poly_meta[i][0],poly_meta[i][1],poly_meta[i][2]);
    printf("S %zu",i); for(size_t j=0;j<poly_meta[i][4];j++) for(size_t u=0;u<4;u++) printf(" %" PRIu32,F[j*5+u]);
    int changed=F[127]!=1234567 || memcmp(f,poly_f[i],sizeof f)!=0 || memcmp(k,poly_k[i],sizeof k)!=0;
    for(size_t j=0;j<poly_meta[i][4];j++) changed|=F[j*5+4]!=999;
    printf(" %d\n",changed);
  }
  for(size_t i=0;i<COUNT(make_meta);i++) {
    uint32_t data[65538]; int16_t f[16],g[16]; memcpy(f,make_f[i],sizeof f);memcpy(g,make_g[i],sizeof g);memset(data,0,sizeof data);
    data[0]=data[65537]=1234567; uint32_t *a=data+1;
    unsigned logn=make_meta[i][0],ter=make_meta[i][1],depth=make_meta[i][2]; size_t n=make_meta[i][4],len=make_meta[i][5];
    make_fg(a,f,g,logn,ter,depth,(int)make_meta[i][3]);
    if(make_meta[i][3] && n>1) for(size_t u=0;u<len;u++) {
      uint32_t gm[16],igm[16]; const small_prime *primes=ter?PRIMES3:PRIMES2;
      uint32_t p=primes[u].p,pi=modp_ninv31(p);
      if(ter) { modp_mkgm3(gm,igm,logn-depth,depth==0,primes[u].g,p,pi);modp_iNTT3_ext(a+u,len,igm,logn-depth,depth==0,p,pi);modp_iNTT3_ext(a+n*len+u,len,igm,logn-depth,depth==0,p,pi); }
      else {modp_mkgm2(gm,igm,logn-depth,primes[u].g,p,pi);modp_iNTT2_ext(a+u,len,igm,logn-depth,p,pi);modp_iNTT2_ext(a+n*len+u,len,igm,logn-depth,p,pi);}
    }
    printf("M %zu",i);for(size_t j=0;j<2*n*len;j++) printf(" %" PRIu32,a[j]);
    printf(" %d\n",data[0]!=1234567 || data[65537]!=1234567 || memcmp(f,make_f[i],sizeof f)!=0 || memcmp(g,make_g[i],sizeof g)!=0);
  }
  for(size_t i=0;i<COUNT(deep_meta);i++) {
    uint32_t data[65538]; int16_t f[1536]={0},g[1536]={0},sf[1536],sg[1536];
    memcpy(f,deep_f[i],sizeof deep_f[i]);memcpy(g,deep_g[i],sizeof deep_g[i]);memcpy(sf,f,sizeof f);memcpy(sg,g,sizeof g);memset(data,0,sizeof data);
    data[0]=data[65537]=1234567; falcon_keygen fk;memset(&fk,0,sizeof fk);
    fk.logn=deep_meta[i][0];fk.ternary=deep_meta[i][1];fk.tmp=data+1;
    int ret=solve_NTRU_deepest(&fk,f,g);size_t len=deep_meta[i][2];
    printf("D %zu %d %d",i,ret,data[0]!=1234567 || data[65537]!=1234567 || memcmp(f,sf,sizeof f)!=0 || memcmp(g,sg,sizeof g)!=0);
    for(size_t j=0;j<2*len;j++) {printf(" %" PRIu32,fk.tmp[j]);} printf("\n");
  }
  return 0;
}
'''
variants={'baseline':source,
    'vv_zero':once(source,region(4206,4237),once(region(4206,4237),'0, 31,  4','1, 31,  4')),
    'signed_scale':once(source,'(uint32_t)(xlen - 1) * 31 + bitlength','(uint32_t)(xlen - 1) * 30 + bitlength'),
    'top_bitcast':once(source,region(4269,4320),once(region(4269,4320),'return *(int64_t *)&z;','return *(int64_t *)&z ^ 1;')),
    'fp_scale':once(source,'(int)(off - scale));','(int)(off - scale + 1));'),
    'poly_sign':once(source,region(4519,4588),region(4519,4588).replace('kf = -k[u];','kf = k[u];')),
    'make_g':once(source,region(5681,5732),once(region(5681,5732),'modp_set(g[u], p0)','modp_set(g[u] + 1, p0)')),
    'deepest_return':once(source,region(5741,5792),once(region(5741,5792),'return 1;','return 0;'))}
records=[]
for mode,flags in [('ubsan',['-O1','-fsanitize=undefined','-fno-sanitize-recover=all']),('normal',['-O2'])]:
    for variant,body in variants.items():
        label=mode+'_'+variant; cfile=Path(label+'.c'); binary=Path(label+'.bin')
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
        seen=set();differences=[];counts={}
        for line in ran.stdout.decode().splitlines():
            tag,raw,*payload=line.split(); i=int(raw); values=[ZZ(v) for v in payload]
            assert (tag,i) not in seen;seen.add((tag,i));counts[tag]=counts.get(tag,int(0))+int(1)
            if tag=='D':
                logn,ter,n,f,g,a,b,success=deep[i]
                actualF=sum(values[2+j]*B^j for j in range(n));actualG=sum(values[2+n+j]*B^j for j in range(n))
                ok=values[:2]==[success,0] and (not success or a*actualG-b*actualF==(18433 if ter else 12289))
            else: ok=values==expected[(tag,i)]
            if not ok: differences.append(line[:int(160)])
        assert len(seen)==len(expected)+len(deep),(label,counts)
        assert bool(differences)==(variant!='baseline'),(label,differences[:3])
        artifacts=[cfile,Path(label+'.compile.stdout'),Path(label+'.compile.stderr'),Path(label+'.stdout'),Path(label+'.stderr'),Path(label+'.run.json')]
        records.append({'mode':mode,'variant':variant,'counts':counts,'differences':differences,'command':command,
            'artifacts':{str(p):digest(p) for p in artifacts}})
Path('ZINT_CHECK.json').write_text(json.dumps({'status':'PASS_FINITE_SOURCE_CONTROLS','variants':records,
    'fixture_sha256':digest('PUBLIC_FIXTURE.json'),'profile_sha256':digest(root/'PROFILE.json'),
    'source_pins':profile['core']['source_files'],
    'scope':'Exact extraction, scaled bigint/polynomial arithmetic, FPEMU conversion, both make_fg families and deepest calls; finite controls only. No whole root/intermediate, universal arithmetic, compiler, termination or probability theorem.'},indent=2)+'\n')
