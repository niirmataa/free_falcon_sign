#!/usr/bin/env sage
# Auxiliary finite source schedule/frame controls; not a kernel premise.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
fft=repo/'Extra/c/falcon-fft.c'
assert sha(fft)=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
text=fft.read_text()
assert 'for (u = 0, v = (size_t)1 << logn; u < hn; u += 3, v += 2)' in text
n=ZZ(1536);hn=ZZ(768);logn=ZZ(10);u=ZZ(0);v=ZZ(1)<<logn;rows=[];written=[]
while u<hn:
    k=ZZ(len(rows));assert u==3*k and v==2*(512+k) and k<256
    assert u+2<hn and 512+k<2048 and v+1<4096
    slots=[u,u+hn,u+1,u+1+hn,u+2,u+2+hn]
    assert all(0<=i<n for i in slots)
    written.extend(slots);rows.append({'k':int(k),'u':int(u),'v':int(v),'slots':[int(i) for i in slots]})
    u+=3;v+=2
assert len(rows)==256 and (u,v)==(768,1536) and not u<hn
assert sorted(written)==list(range(n))
root_count=ZZ(35840);root_bytes=ZZ(286720)
assert root_count*8==root_bytes
assert n+1536<=root_count and 8*1536==12288
for i in range(1536):
    offset=8*(1536+ZZ(i))
    assert 12288<=offset and offset+8<=24576 and offset+8<=root_bytes
(Path.cwd()/'FFTLOOP148_CONTROLS.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_SCHEDULE_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'source':{'path':str(fft),'sha256':sha(fft)},
 'tripling_iterations':rows,'final_u':int(u),'final_v':int(v),
 'first_buffer_byte_span':[int(0),int(12288)],'second_buffer_byte_span':[int(12288),int(24576)],
 'scope':'Exact source-counter/index and disjoint byte-span consistency only; no numeric FFT output or whole KeyGen success claim.'},indent=2)+'\n')
