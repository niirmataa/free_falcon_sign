#!/usr/bin/env sage
# Exact source-schedule consistency controls; never a kernel or probability premise.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4];source=repo/'Extra/c/falcon-fft.c'
digest=hashlib.sha256(source.read_bytes()).hexdigest()
assert digest=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
logn=ZZ(10);full=ZZ(1);n=(1+(full<<1))<<(logn-full);hn=n>>1;tmin=1+(full<<1)
assert (n,hn,tmin)==(1536,768,3)
first=[(ZZ(u),ZZ(u)+hn) for u in range(hn)]
assert sorted(j for pair in first for j in pair)==list(range(n))
t=hn;m=ZZ(2);passes=[]
while t>tmin:
    ht=t>>1;hm=m>>1;slots=[];butterflies=ZZ(0)
    assert t==2*ht and hm*t<=hn and m+hm<=1024
    for group in range(hm):
        start=ZZ(group)*t
        for v in range(start,start+ht):
            v=ZZ(v);row=[v,v+hn,v+ht,v+ht+hn]
            assert all(0<=j<n for j in row)
            slots.extend(row);butterflies+=1
    assert sorted(slots)==list(range(n)) and butterflies==384
    passes.append({'t':int(t),'m':int(m),'groups':int(hm),'butterflies':int(butterflies)})
    t>>=1;m<<=1
assert len(passes)==8 and (t,m)==(3,512) and not t>tmin
triple=[]
for k in range(256):
    u=3*ZZ(k);v=2*(512+ZZ(k))
    row=[u,u+hn,u+1,u+1+hn,u+2,u+2+hn]
    assert u+2<hn and v+1<4096
    triple.extend(row)
assert sorted(triple)==list(range(n))
for i in range(n):
    for j in range(8):
        left=8*ZZ(i)+ZZ(j);right=8*(n+ZZ(i))+ZZ(j)
        assert 0<=left<12288<=right<24576<=286720
(Path.cwd()/'FFTSECOND150_CONTROLS.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_SCHEDULE_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'source':{'path':str(source),'sha256':digest},
 'n':int(n),'hn':int(hn),'tmin':int(tmin),'first_iterations':len(first),'middle_passes':passes,
 'tripling_iterations':int(256),'final_t':int(t),'final_m':int(m),
 'source_body_iterations':int(hn+sum(ZZ(p['butterflies']) for p in passes)+256),
 'rt1_span':[int(0),int(12288)],'rt2_span':[int(12288),int(24576)],
 'scope':'Complete actual-dimension loop schedule and disjoint byte spans only; no numerical FFT output or KeyGen success claim.'},indent=2)+'\n')
