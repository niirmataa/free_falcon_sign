#!/usr/bin/env sage
# Auxiliary finite controls; the parametric source theorem is independent.
import hashlib,json,re,sys,subprocess,shutil
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
assert len(sys.argv)==3
label,digest=sys.argv[1:]
assert re.fullmatch(r'keygen_butterfly140_[0-9]{3}',label)
assert re.fullmatch(r'[0-9a-f]{64}',digest)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
candidate=root/'.build/jobs'/label/'BUTTERFLY140_CONTROL_CANDIDATE.json';assert sha(candidate)==digest
rows=json.loads(candidate.read_text())['cases'];assert len(rows)==40
word_model=root/'sage/keygen_fastfpr137_control.sage'
assert sha(word_model)=='a90b036ca826dc9dfd72380dedc62a8ab0f3972d8fa6260b81bd0cc86a40853f'
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
m=json.loads(manifest.read_text())
for row in m['source_inputs']:assert sha(row['path'])==row['sha256']
# Word operations below are reused verbatim from the pinned137 Sage control.
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

for row in rows:
    ar,ai,br,bi,sr,si=[ZZ(x) for x in row['input']]
    assert all(0<=x<2^64 for x in [ar,ai,br,bi,sr,si])
    re=add(mul(br,sr),neg(mul(bi,si)))
    im=add(mul(br,si),mul(bi,sr))
    expected=[add(ar,re),add(ai,im),add(ar,neg(re)),add(ai,neg(im))]
    assert [ZZ(x) for x in row['output']]==expected
fft=repo/'Extra/c/falcon-fft.c'
assert sha(fft)=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
function=fft.read_text().split('falcon_FFT3(fpr *a, unsigned logn, unsigned full)\n{',1)[1].split('\n/* see internal.h */',1)[0]
body=function.split('for (v = v1; v < v2; v ++) {',1)[1].split('\n\t\t\t}',1)[0]
probe=Path.cwd()/'CONTROL140.c'
probe.write_text('#include <stdio.h>\n#include <stdint.h>\n#include <inttypes.h>\n#include "falcon-fft.c"\n'
'_Static_assert(sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 required");\n'
'int main(void) { uint64_t ar,ai,br,bi,sr,si;\n'
'while(scanf("%" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64 " %" SCNx64,&ar,&ai,&br,&bi,&sr,&si)==6) {\n'
'fpr a[1536],saved[1536]; size_t i,v=0,hn=768,ht=384;\n'
'for(i=0;i<1536;i++) { a[i]=saved[i]=UINT64_C(0x1234000000000000)+(uint64_t)i; }\n'
'a[0]=ar; a[768]=ai; a[384]=br; a[1152]=bi;\n'
'{'+body+'\n}\n'
'for(i=0;i<1536;i++) { if(i!=0 && i!=768 && i!=384 && i!=1152 && a[i]!=saved[i]) { return 2; } }\n'
'printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\\n",a[0],a[768],a[384],a[1152]);\n'
'} return 0; }\n')
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL140'
argv=[cc,*m['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-I',str(repo/'Extra/c'),str(probe),str(repo/'Extra/c/fpr-emulated.c'),'-o',str(binary)]
r=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(r.stdout);(Path.cwd()/'CC.stderr').write_bytes(r.stderr)
assert r.returncode==0 and r.stdout==r.stderr==b''
inputs=''.join(' '.join(format(int(ZZ(x)),'016x') for x in row['input'])+'\n' for row in rows)
(Path.cwd()/'CONTROL140_INPUT.txt').write_text(inputs)
r=subprocess.run([str(binary)],input=inputs.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(r.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(r.stderr)
assert r.returncode==0 and r.stderr==b''
lines=r.stdout.decode().splitlines();assert len(lines)==40
for row,line in zip(rows,lines):assert [ZZ(x,16) for x in line.split()]==[ZZ(x) for x in row['output']]
(Path.cwd()/'BUTTERFLY140_CONTROL.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'cases':int(40),'native_frame_checked':True,
 'candidate':{'path':str(candidate),'sha256':digest},'word_model':{'path':str(word_model),'sha256':sha(word_model)},
 'source_manifest':{'path':str(manifest),'sha256':sha(manifest)},'pinned_fft':{'path':str(fft),'sha256':sha(fft)},
 'probe':{'path':str(probe),'sha256':sha(probe)},'binary':{'path':str(binary),'sha256':sha(binary)},
 'compile_argv':argv,'native_output':{'path':str(Path.cwd()/'NATIVE.stdout'),'sha256':sha(Path.cwd()/'NATIVE.stdout')}},indent=2)+'\n')
