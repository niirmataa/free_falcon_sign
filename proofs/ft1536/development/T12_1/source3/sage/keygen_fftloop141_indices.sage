#!/usr/bin/env sage
# Finite schedule consistency only; not source execution or probability evidence.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
fft=repo/'Extra/c/falcon-fft.c'
assert sha(fft)=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
text=fft.read_text().split('falcon_FFT3(fpr *a, unsigned logn, unsigned full)\n{',1)[1].split('\n/* see internal.h */',1)[0]
for fragment in ['for (m = 2; t > tmin; m <<= 1)',
 'for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t)',
 'for (v = v1; v < v2; v ++)','v2 = v1 + ht;','t = ht;']:
    assert fragment in text
n=ZZ(1536);hn=ZZ(768);start=ZZ(24);stop=ZZ(384);ht=ZZ(384)
def slots(v,h):return [v,v+hn,v+h,v+h+hn]
prior=[i for v in range(start) for i in slots(ZZ(v),ht)]
remaining=[i for v in range(start,stop) for i in slots(ZZ(v),ht)]
assert len(prior)==96 and len(remaining)==1440
assert set(prior).isdisjoint(set(remaining))
assert sorted(prior+remaining)==list(range(n))
assert stop-start==360 and 8+16+360==384
assert all(0<=i<n and i<2^64 for i in prior+remaining)
passes=[];t=hn;m=ZZ(2)
while t>3:
    assert t%2==0 and m%2==0 and m*t==n
    h=t//2;hm=m//2;visited=[]
    for u in range(hm):
        first=ZZ(u)*t;last=first+h
        assert last+h<=hn
        assert 2*(m+u)+1<2048
        for v in range(first,last):visited.extend(slots(ZZ(v),h))
    assert sorted(visited)==list(range(n))
    passes.append({'t':int(t),'m':int(m),'ht':int(h),'groups':int(hm),'butterflies':int(len(visited)//4)})
    t=h;m*=2
assert len(passes)==8 and t==3 and m==512
(Path.cwd()/'FFTLOOP141_INDICES.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_SCHEDULE_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'source':{'path':str(fft),'sha256':sha(fft)},
 'actual_first_group':{'prefix':int(24),'remaining':int(360),'total':int(384),'word_positions':int(1536)},
 'future_schedule_control_only':passes,
 'scope':'Kernel source result closes only the first group; other passes remain open.'},indent=2)+'\n')
