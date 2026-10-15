#!/usr/bin/env sage
# Auxiliary exact controls for the original tripling body; never a proof premise.
import hashlib,json,re,subprocess,shutil
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
word_model=root/'sage/keygen_fftadd146_controls.sage'
assert sha(word_model)=='0f23412707d330365b96ff9021d707a8d1307c0073b3d0764dfb176eb1144961'
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
m=json.loads(manifest.read_text())
for row in m['source_inputs']:assert sha(row['path'])==row['sha256']
# Exact ZZ definitions below are reused verbatim from pinned146/145/140.
M64=2^64;M32=2^32;MASK64=M64-1;MASK32=M32-1
u64=lambda x:ZZ(x)%M64
u32=lambda x:ZZ(x)%M32
s32=lambda x:u32(x) if u32(x)<2^31 else u32(x)-M32
def pack(s,e,m):
    e=s32(e)+1076;assert -2^31<=e<2^31
    t=u32(e)>>31;m=ZZ(m)&u64(t-1)
    t=m>>54;e=s32(e)&(-t)
    out=u64((u64(s)<<63 | (m>>2))+(u32(e)<<52))
    return u64(out+((ZZ(0xc8)>>(m&7))&1))
def mul(x,y):
    xu=(x&(2^52-1))|2^52;yu=(y&(2^52-1))|2^52
    x0=u32(xu)&0x1ffffff;x1=u32(xu>>25);y0=u32(yu)&0x1ffffff;y1=u32(yu>>25)
    w=u64(x0*y0);z0=u32(w)&0x1ffffff;z1=u32(w>>25)
    w=u64(x0*y1);z1=u32(z1+(u32(w)&0x1ffffff));z2=u32(w>>25)
    w=u64(x1*y0);z1=u32(z1+(u32(w)&0x1ffffff));z2=u32(z2+u32(w>>25))
    zu=u64(x1*y1);z2=u32(z2+(z1>>25));z1=z1&0x1ffffff;zu=u64(zu+z2)
    zu=zu | (u32((z0|z1)+0x1ffffff)>>25)
    zv=(zu>>1)|(zu&1);w=zu>>55;zu=zu^^((zu^^zv)&u64(-w))
    ex=(x>>52)&0x7ff;ey=(y>>52)&0x7ff;e=ex+ey-2100+w;s=(x^^y)>>63
    d=((ex+0x7ff)&(ey+0x7ff))>>11;zu=zu&u64(-d)
    return pack(s,e,zu)
def add(x,y):
    absolute=2^63-1;za=u64((x&absolute)-(y&absolute))
    cs=u32(za>>63)|(u32(1-u32(u64(-za)>>63))&u32(x>>63))
    mask=(x^^y)&u64(-cs);x=x^^mask;y=y^^mask
    ex=x>>52;sx=ex>>11;ex=ex&0x7ff
    m=u64(u32((ex+0x7ff)>>11)<<52);xu=u64(((x&(2^52-1))|m)<<3);ex-=1078
    ey=y>>52;sy=ey>>11;ey=ey&0x7ff
    m=u64(u32((ey+0x7ff)>>11)<<52);yu=u64(((y&(2^52-1))|m)<<3);ey-=1078
    cc=ex-ey;yu=yu&u64(-(u32(cc-60)>>31));cc=cc&63
    m=u64((1<<cc)-1);yu=yu|u64((yu&m)+m);yu=yu>>cc
    xu=u64(xu+yu-(u64(yu<<1)&u64(-(sx^^sy))))
    ex-=63
    for rs,ms,es in [(32,32,5),(48,16,4),(56,8,3),(60,4,2),(62,2,1)]:
        nt=u32(xu>>rs);nt=(nt|u32(-nt))>>31
        xu=xu^^((xu^^u64(xu<<ms))&u64(nt-1));ex+=nt<<es
    nt=u32(xu>>63);xu=xu^^((xu^^u64(xu<<1))&u64(nt-1));ex+=nt
    xu=xu|u32((u32(xu)&0x1ff)+0x1ff);xu=xu>>9;ex+=9
    return pack(sx,ex,xu)
def neg(x):return x^^(2^63)
def half(x):
    x=u64(x-2^52);t=(((u32(x>>52)&0x7ff)+1)>>11)
    return x&u64(t-1)
def double(x):return u64(x+((((u32(x>>52)&0x7ff)+0x7ff)>>11)<<52))




fft=repo/'Extra/c/falcon-fft.c';header_path=repo/'Extra/c/fpr-emulated.h'
assert sha(fft)=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
assert sha(header_path)=='6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f'
header_text=header_path.read_text()
def constant(name):
    found=re.search(r'static const fpr '+name+r' = 0x([0-9a-fA-F]+)ULL;',header_text);assert found
    return ZZ(found.group(1),16)
w2=(constant('fpr_W2R'),constant('fpr_W2I'));w4=(constant('fpr_W4R'),constant('fpr_W4I'))
cubic=header_text.split('static const fpr fpr_gm3_cubic[] = {',1)[1].split('};',1)[0]
pairs=[(ZZ(a,16),ZZ(b,16)) for a,b in re.findall(r'FPC\(0x([0-9a-fA-F]+)ULL,\s*0x([0-9a-fA-F]+)ULL\)',cubic)]
assert len(pairs)==2048
def cmul(a,b):return (add(mul(a[0],b[0]),neg(mul(a[1],b[1]))),add(mul(a[0],b[1]),mul(a[1],b[0])))
def csqr(a):return (add(mul(a[0],a[0]),neg(mul(a[1],a[1]))),double(mul(a[0],a[1])))
def cadd(a,b):return (add(a[0],b[0]),add(a[1],b[1]))
edges=[ZZ(0),ZZ(1),2^63,2^64-1,ZZ(0x3ff0000000000000),ZZ(0xbff0000000000000),ZZ(0x0010000000000000),ZZ(0x7ff0000000000000)]
positions=[ZZ(0),ZZ(1),ZZ(2),ZZ(3),ZZ(252),ZZ(253),ZZ(254),ZZ(255)]
inputs=[]
for k,value in zip(positions,edges):inputs.append((k,[value,neg(value),ZZ(0x3fe0000000000000),ZZ(0x3ff0000000000000),neg(value),value]))
state=ZZ(0x14720261015)
for j in range(32):
    row=[]
    for z in range(6):
        state=(state*6364136223846793005+1442695040888963407)%M64;row.append(state)
    inputs.append(((ZZ(37)*ZZ(j)+11)%256,row))
cases=[]
for k,row in inputs:
    a=(row[0],row[1]);b=(row[2],row[3]);c=(row[4],row[5]);q=pairs[512+k]
    b0=cmul(b,q);b1=cmul(b0,w2);b2=cmul(b0,w4);q2=csqr(q)
    c0=cmul(c,q2);c1=cmul(c0,w2);c2=cmul(c0,w4)
    out=[cadd(a,cadd(b0,c0)),cadd(a,cadd(b1,c2)),cadd(a,cadd(b2,c1))]
    cases.append({'k':int(k),'input':[int(v) for v in row],'twiddle':[int(v) for v in q],
      'expected':[int(v) for pair in out for v in pair]})
function=fft.read_text().split('falcon_FFT3(fpr *a, unsigned logn, unsigned full)\n{',1)[1].split('\n/* see internal.h */',1)[0]
marker='for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2) {'
body=function.split(marker,1)[1].split('\n\t\t}',1)[0]
probe=Path.cwd()/'CONTROL147.c'
probe.write_text("""#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include "falcon-fft.c"
_Static_assert(sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8 && sizeof(fpr)==8, "LP64/fpr64 required");
int main(void) {
  size_t k; uint64_t ar,ai,br,bi,cr,ci;
  while(scanf("%zu %" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64,&k,&ar,&ai,&br,&bi,&cr,&ci)==7) {
    if(k>=256) return 4;
    fpr a[1536],saved[1536],fAr=55,xr=66;
    size_t u=3*k,v=1024+2*k,hn=768,z,oldU=u,oldV=v;
    for(z=0;z<1536;z++) a[z]=saved[z]=UINT64_C(0x1234000000000000)+z;
    a[u]=ar;a[u+hn]=ai;a[u+1]=br;a[u+1+hn]=bi;a[u+2]=cr;a[u+2+hn]=ci;
    {
"""+body+"""
    }
    if(u!=oldU || v!=oldV || fAr!=55 || xr!=66) return 2;
    for(z=0;z<1536;z++) if(z!=u && z!=u+1 && z!=u+2 && z!=u+hn && z!=u+1+hn && z!=u+2+hn && a[z]!=saved[z]) return 3;
    printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64,a[u],a[u+hn],a[u+1],a[u+1+hn],a[u+2],a[u+2+hn]);
    putchar(10);
  }
  return 0;
}
""")
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL147'
argv=[cc,*m['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-I',str(repo/'Extra/c'),str(probe),str(repo/'Extra/c/fpr-emulated.c'),'-o',str(binary)]
r=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(r.stdout);(Path.cwd()/'CC.stderr').write_bytes(r.stderr)
assert r.returncode==0 and r.stdout==r.stderr==b''
raw=''.join(str(row['k'])+' '+' '.join(format(v,'016x') for v in row['input'])+'\n' for row in cases)
(Path.cwd()/'INPUT147.txt').write_text(raw)
r=subprocess.run([str(binary)],input=raw.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(r.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(r.stderr)
assert r.returncode==0 and r.stderr==b''
lines=r.stdout.decode().splitlines();assert len(lines)==len(cases)==40
for row,line in zip(cases,lines):assert [ZZ(v,16) for v in line.split()]==[ZZ(v) for v in row['expected']]
(Path.cwd()/'FFTINPUTS147_CONTROLS.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_C_BODY_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'cases':cases,'sources':m['source_inputs'],
 'word_model':{'path':str(word_model),'sha256':sha(word_model)},'body_sha256':hashlib.sha256(body.encode()).hexdigest(),
 'compiler':{'argv':argv,'stdout':sha(Path.cwd()/'CC.stdout'),'stderr':sha(Path.cwd()/'CC.stderr')},
 'probe':{'path':str(probe),'sha256':sha(probe)},'binary_sha256':sha(binary),
 'scope':'40 exact raw-word whole-body cases across selected valid positions, actual cubic words/constants and control/local/buffer frames; no256-loop or probability claim.'},indent=2)+'\n')
