#!/usr/bin/env sage
# Auxiliary exact finite schedule controls; not premises of the Lean theorems.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
fft=repo/'Extra/c/falcon-fft.c'
digest=hashlib.sha256(fft.read_bytes()).hexdigest()
assert digest=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
text=fft.read_text()
start=text.index('falcon_FFT3(')
body=text[start:]
assert 'for (u = 0; u < hn; u ++)' in body
assert 'a[u] = fpr_add(a0, fpr_mul(a1, fpr_W1R));' in body
assert 'a[u + hn] = fpr_mul(a1, fpr_W1I);' in body
n=ZZ(1536);hn=ZZ(768);base=ZZ(1536);capacity=ZZ(35840)
assert 2*hn==n and n<2^64 and base+n<=capacity
rows=[];written=[]
for u in range(hn):
    r=ZZ(u);q=r+hn
    assert 0<=r<hn<=q<n
    offsets=[8*(base+r),8*(base+q)]
    assert all(12288<=o and o+8<=24576 and o+8<=8*capacity for o in offsets)
    rows.append({'u':int(r),'slots':[int(r),int(q)],'offsets':[int(o) for o in offsets]})
    written.extend([r,q])
assert sorted(written)==list(range(n)) and len(set(written))==n
suffixes=[]
for u0 in [ZZ(0),ZZ(1),ZZ(511),ZZ(767),hn]:
    u=u0;count=ZZ(0)
    while u<hn:
        u+=1;count+=1
    assert u==hn and count==hn-u0 and not u<hn
    suffixes.append({'initial_u':int(u0),'iterations':int(count),'final_u':int(u)})
def valid_schedule(stop):
    slots=[j for u in range(stop) for j in [ZZ(u),ZZ(u)+hn]]
    return len(slots)==n and sorted(slots)==list(range(n)) and len(set(slots))==n
assert valid_schedule(hn)
assert not valid_schedule(hn-1) and not valid_schedule(hn+1)
(Path.cwd()/'FFTFIRST149_CONTROLS.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_SCHEDULE_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'source':{'path':str(fft),'sha256':digest},
 'iterations':rows,'suffix_controls':suffixes,'mutants_rejected':['one_iteration_short','one_iteration_long'],
 'scope':'First-pass source schedule, complete disjoint slot coverage and rt2 byte spans only; no numeric FFT output, probability or whole KeyGen success claim.'},indent=2)+'\n')
