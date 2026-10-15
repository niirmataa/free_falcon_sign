#!/usr/bin/env sage
# Exact finite controls against pinned portable C and independent ZZ word code.
import hashlib,json,re,sys,subprocess,shutil
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
assert len(sys.argv)==3
label,digest=sys.argv[1:]
assert re.fullmatch(r'keygen_fastfpr137_[0-9]{3}',label)
assert re.fullmatch(r'[0-9a-f]{64}',digest)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
candidate=root/'.build/jobs'/label/'FPR137_CONTROLS.json';assert sha(candidate)==digest
rows=json.loads(candidate.read_text())['cases'];assert len(rows)==208
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
source_manifest=json.loads(manifest.read_text())
for row in source_manifest['source_inputs']:assert sha(row['path'])==row['sha256']
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
boundaries=[ZZ(x) for x in [0,1,0x8000000000000000,0x3ff0000000000000,0xbff0000000000000,0x0010000000000000,0x000fffffffffffff,0x7fefffffffffffff,0xffefffffffffffff,0x7ff0000000000000,0x7ff8000000000000,0xffffffffffffffff]]
pairs=[(x,y) for x in boundaries for y in boundaries];seed=ZZ(0x9e3779b97f4a7c15)
for _ in range(64):
    seed=u64(seed*6364136223846793005+1442695040888963407);x=seed
    seed=u64(seed*6364136223846793005+1442695040888963407);pairs.append((x,seed))
fields=['add','mul','sub','neg','sqr','half','double']
for row,(x,y) in zip(rows,pairs):
    assert (ZZ(row['x']),ZZ(row['y']))==(x,y)
    expected=[add(x,y),mul(x,y),add(x,neg(y)),neg(x),mul(x,x),half(x),double(x)]
    assert [ZZ(row[k]) for k in fields]==expected
probe=Path.cwd()/'CONTROL137.c'
probe.write_text('#include <stdio.h>\n#include <stdint.h>\n#include <inttypes.h>\n#include "internal.h"\n'
'_Static_assert(sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 required");\n'
'int main(void) { uint64_t x,y; while (scanf("%" SCNx64 " %" SCNx64, &x,&y)==2) {\n'
'printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\\n",\n'
'fpr_add(x,y),fpr_mul(x,y),fpr_sub(x,y),fpr_neg(x),fpr_sqr(x),fpr_half(x),fpr_double(x)); } return 0; }\n')
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL137'
argv=[cc,*source_manifest['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-I',str(repo/'Extra/c'),str(probe),str(repo/'Extra/c/fpr-emulated.c'),'-o',str(binary)]
compiled=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(compiled.stdout);(Path.cwd()/'CC.stderr').write_bytes(compiled.stderr)
assert compiled.returncode==0 and compiled.stdout==compiled.stderr==b''
inputs=''.join(format(int(x),'016x')+' '+format(int(y),'016x')+'\n' for x,y in pairs)
(Path.cwd()/'CONTROL137_INPUT.txt').write_text(inputs)
native=subprocess.run([str(binary)],input=inputs.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(native.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(native.stderr)
assert native.returncode==0 and native.stderr==b''
lines=native.stdout.decode().splitlines();assert len(lines)==len(rows)
for line,row in zip(lines,rows):assert [ZZ(s,16) for s in line.split()]==[ZZ(row[k]) for k in fields]
version=subprocess.run([cc,'--version'],capture_output=True,check=True).stdout.decode().splitlines()[0]
(Path.cwd()/'FPR137_CONTROL.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_UNIVERSAL_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'cases':int(len(rows)),'operations':fields,
 'candidate':{'path':str(candidate),'sha256':digest},'native_compile_argv':argv,'compiler':version,
 'source_manifest':{'path':str(manifest),'sha256':sha(manifest)},
 'probe':{'path':str(probe),'sha256':sha(probe)},'binary':{'path':str(binary),'sha256':sha(binary)},
 'native_output':{'path':str(Path.cwd()/'NATIVE.stdout'),'sha256':sha(Path.cwd()/'NATIVE.stdout')},
 'scope':'portable pinned FPEMU word semantics including raw boundary patterns; no IEEE-real-error or distribution assertion'},indent=2)+'\n')
