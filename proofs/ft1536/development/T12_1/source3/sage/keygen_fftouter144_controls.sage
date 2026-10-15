#!/usr/bin/env sage
# Auxiliary finite controls; source execution is proved independently in Lean.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
fft=repo/'Extra/c/falcon-fft.c'
assert sha(fft)=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
text=fft.read_text()
assert '#define MKN(logn, full)   ((size_t)(1 + ((full) << 1)) << ((logn) - (full)))' in text
for fragment in ['ht = t >> 1;','hm = m >> 1;', 't = ht;', 'for (m = 2; t > tmin; m <<= 1)']:
    assert fragment in text
logn=ZZ(10);full=ZZ(1);n=(1+(full<<1))<<(logn-full);hn=n//2
assert n==1536 and hn==768 and (ZZ(1)<<logn)==1024
rows=[];t=ZZ(384);m=ZZ(4)
while t>3:
    ht=t>>1;hm=m>>1
    assert ht==t//2 and hm==m//2 and t==ht+ht
    assert hm*t<=hn and m+hm<=1024 and t*m==n
    assert 0<=t<2^64 and 0<=m<2^64
    rows.append({'t':int(t),'m':int(m),'ht':int(ht),'hm':int(hm),'group_final_v1':int(hm*t)})
    t=ht;m<<=1
assert len(rows)==7 and (t,m)==(3,512)
modulus=ZZ(2)^64;cases=[]
for value in [ZZ(0),ZZ(1),ZZ(2),ZZ(3),ZZ(384),ZZ(768),2^63-1,2^63,modulus-1]:
    assert (value>>1)==value//2
    assert ((value<<1)%modulus)==(value*2)%modulus
    cases.append({'input':int(value),'half':int(value>>1),'double_word':int((value*2)%modulus)})
(Path.cwd()/'FFTOUTER144_CONTROLS.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'source':{'path':str(fft),'sha256':sha(fft)},
 'actual_profile':{'logn':int(logn),'full':int(full),'n':int(n),'hn':int(hn),'tripling_initial_v':int(1<<logn)},
 'remaining_passes':rows,'final':{'t':int(t),'m':int(m)},'uint64_boundaries':cases,
 'scope':'Exact scalar/schedule checks only; no tripling execution or numeric FFT output claim.'},indent=2)+'\n')
