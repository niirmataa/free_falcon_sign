#!/usr/bin/env sage
# Auxiliary exact controls; the Lean source theorems do not assume these results.
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
 'for (u1 = 0, v1 = 0; u1 < hm; u1 ++, v1 += t)', 't = ht;']:
    assert fragment in text
u1=ZZ(0);v1=ZZ(0);t=ZZ(768);m=ZZ(2);ht=ZZ(384);hm=ZZ(1)
assert u1<hm
u1+=1;v1+=t
assert (u1,v1)==(1,768) and not u1<hm
t=ht;m<<=1
assert (t,m)==(384,4) and t>3
modulus=ZZ(2)^64
values=[ZZ(0),ZZ(1),ZZ(2),ZZ(384),ZZ(768),2^63-1,2^63,modulus-1]
counts=[ZZ(0),ZZ(1),ZZ(31),ZZ(32),ZZ(63)]
rows=[]
for n in values:
    for count in counts:
        product=(n*2^count)%modulus
        shifted=(n<<count)%modulus
        assert product==shifted and 0<=shifted<modulus
        rows.append({'n':int(n),'count':int(count),'word':int(shifted)})
(Path.cwd()/'FFTCONTROL142_CONTROLS.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'source':{'path':str(fft),'sha256':sha(fft)},
 'first_outer_controls':{'group_initial':[int(0),int(0)],'group_final':[int(1),int(768)],'t':int(t),'m':int(m)},
 'uint64_shift_cases':rows,
 'scope':'Control arithmetic and original source fragments only; no FFT word image or probability claim.'},indent=2)+'\n')
