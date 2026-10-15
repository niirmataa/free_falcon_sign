#!/usr/bin/env sage
# Auxiliary raw-word C/Sage controls, never a premise of the kernel source proof.
import hashlib,json,subprocess,shutil
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
word_model=root/'sage/keygen_butterfly140_control.sage'
assert sha(word_model)=='6123168189ffc6361c9bb6fce5fa4e5c4145ea339e92aaa13e232e5d93ead5ff'
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
m=json.loads(manifest.read_text())
for row in m['source_inputs']:assert sha(row['path'])==row['sha256']
# Exact ZZ definitions below are reused verbatim from pinned140.
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


edges=[ZZ(0),ZZ(1),2^63,2^64-1,ZZ(0x3ff0000000000000),ZZ(0xbff0000000000000),ZZ(0x0010000000000000),ZZ(0x7ff0000000000000)]
inputs=[]
for value in edges:inputs.append([value,neg(value),ZZ(0x3fe0000000000000),ZZ(0x3ff0000000000000)])
state=ZZ(0x14520261015)
for i in range(32):
    row=[]
    for j in range(4):
        state=(state*6364136223846793005+1442695040888963407)%M64
        row.append(state)
    inputs.append(row)
assert len(inputs)==40
cases=[]
for ar,ai,br,bi in inputs:
    mr=add(mul(ar,br),neg(mul(ai,bi)))
    mi=add(mul(ar,bi),mul(ai,br))
    sr=add(mul(ar,ar),neg(mul(ai,ai)))
    si=double(mul(ar,ai))
    cases.append({'input':[int(v) for v in [ar,ai,br,bi]],'expected':[int(v) for v in [mr,mi,mr,mi,sr,si]]})
probe=Path.cwd()/'CONTROL145.c'
probe.write_text("""#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include "falcon-fft.c"
_Static_assert(sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 required");
int main(void) {
  uint64_t ar,ai,br,bi;
  while(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64,&ar,&ai,&br,&bi)==4) {
    fpr dr=0,di=0,xr=ar,xi=ai,sr=ar,si=ai;
    fpr fpct_a_re=11,fpct_a_im=12,fpct_b_re=13,fpct_b_im=14,fpct_d_re=15,fpct_d_im=16;
    FPC_MUL(dr,di,ar,ai,br,bi);
    FPC_MUL(xr,xi,xr,xi,br,bi);
    FPC_SQR(sr,si,sr,si);
    if(fpct_a_re!=11 || fpct_a_im!=12 || fpct_b_re!=13 || fpct_b_im!=14 || fpct_d_re!=15 || fpct_d_im!=16) return 2;
    printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64,dr,di,xr,xi,sr,si);
    putchar(10);
  }
  return 0;
}
""")
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL145'
argv=[cc,*m['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-I',str(repo/'Extra/c'),str(probe),str(repo/'Extra/c/fpr-emulated.c'),'-o',str(binary)]
r=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(r.stdout);(Path.cwd()/'CC.stderr').write_bytes(r.stderr)
assert r.returncode==0 and r.stdout==r.stderr==b''
raw=''.join(' '.join(format(int(v),'016x') for v in row)+'\n' for row in inputs)
(Path.cwd()/'INPUT145.txt').write_text(raw)
r=subprocess.run([str(binary)],input=raw.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(r.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(r.stderr)
assert r.returncode==0 and r.stderr==b''
lines=r.stdout.decode().splitlines();assert len(lines)==len(cases)
for row,line in zip(cases,lines):assert [ZZ(v,16) for v in line.split()]==[ZZ(v) for v in row['expected']]
(Path.cwd()/'FFTMACRO145_CONTROLS.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_C_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'cases':cases,
 'sources':m['source_inputs'],'word_model':{'path':str(word_model),'sha256':sha(word_model)},
 'compiler':{'argv':argv,'stdout':sha(Path.cwd()/'CC.stdout'),'stderr':sha(Path.cwd()/'CC.stderr')},
 'probe':{'path':str(probe),'sha256':sha(probe)},'binary_sha256':sha(binary),
 'scope':'40 raw-word cases: distinct-output MUL, in-place MUL, in-place SQR and caller temporary-name frame; no tripling-loop or probability claim.'},indent=2)+'\n')
