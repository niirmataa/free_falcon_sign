#!/usr/bin/env sage
# Exact finite certificate candidate; kernel checks, not this computation,
# must connect every array to the actual source-derived sampler words.
from pathlib import Path
import hashlib,json
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def pin(p): return {'path':str(p),'sha256':sha(p)}
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
record=json.loads(manifest.read_text())
path=Path(record['selected'])/'DECODED.json'
assert sha(path)==next(row['sha256'] for row in record['artifacts'] if row['path']==str(path))
before=[pin(manifest),pin(path)]
coefficients=[ZZ(x) for x in json.loads(path.read_text())['f']]
assert len(coefficients)==1536 and all(x in [-1,0,1] for x in coefficients)
q=ZZ(18433); field=GF(q); ring=PolynomialRing(field,'X'); X=ring.gen()
f=ring(coefficients); phi=X^1536-X^768+1
assert q.is_prime() and f.degree()<1536
r=field(25)^2
assert r.multiplicative_order()==4608

def reverse(k,j):
    out=ZZ(0)
    for _ in range(k): out=2*out+j%2; j=j//2
    return out

def exponent(i):
    v=max(ZZ(1),ZZ(i)); k=ZZ(v.nbits()-1)
    u=reverse(k,v-2^k)
    return (1 if k==9 else 3*2^(8-k))*(3*u+1+u%2)

roots=[r^exponent(i) for i in range(1024)]
assert roots[0]==roots[1]==r^768
arrays={'input':[field(x) for x in coefficients]}
a=arrays['input']; z=roots[1]
a=[a[i]+a[i+768]*z for i in range(768)]+[a[i]+a[i+768]-a[i+768]*z for i in range(768)]
arrays['first']=a
for k in range(8):
    m=ZZ(2^(k+1)); h=ZZ(768//2^k//2)
    assert m*2*h==1536 and h>0
    b=[]
    for i in range(1536):
        j=i//(2*h); offset=i%(2*h); base=j*2*h
        x=a[base+offset%h]; y=a[base+h+offset%h]*roots[m+j]
        b.append(x+y if offset<h else x-y)
    a=b; arrays['stage'+str(k+1)]=a
w=z^2; out=[]
for i in range(1536):
    j=i//3; k=i%3; x=roots[512+j]
    a0,a1,a2=a[3*j:3*j+3]
    if k==0: y=a0+(a1*x+a2*x^2)
    elif k==1: y=a0+(a1*x*w+a2*x^2*w^2)
    else: y=a0+(a1*x*w^2+a2*x^2*w)
    out.append(y)
arrays['output']=out
points=[roots[512+i//3]*w^(i%3) for i in range(1536)]
assert len(set(points))==1536
assert all(phi(point)==0 for point in points)
# Independent direct polynomial evaluation checks every physical output.
assert out==[f(point) for point in points]
assert all(value!=0 for value in out)
assert f.gcd(phi)==1
payload={'modulus':int(q),'roots':[int(x) for x in roots],
    'arrays':{name:[int(x) for x in a] for name,a in arrays.items()}}
data=Path.cwd()/'EVALUATION170_DATA.json'
data.write_text(json.dumps(payload,indent=2)+'\n')
assert [pin(manifest),pin(path)]==before
(Path.cwd()/'EVALUATION170_CONTROL.json').write_text(json.dumps({
 'status':'PASS_EXACT_FINITE_AUXILIARY_CONTROL_ONLY; KERNEL_BINDING_PENDING',
 'assertion_tested':'The selected native f has nonzero evaluations at all1536 physical roots; first/eight radix/triple array computation agrees with direct polynomial evaluation and gcd(f,phi)=1.',
 'domains':['ZZ','GF(18433)','GF(18433)[X]'],'sage_version':SAGE_VERSION,
 'inputs_before':before,'inputs_after':before,'output':pin(data),
 'coefficient_count':int(1536),'physical_points':int(1536),'radix_stages':int(8),'zero_evaluations':int(0),
 'non_claims':['No source execution premise is discharged by Sage.','No seed mass, acceptance probability or coding probability is inferred.','Kernel array/input/transition/nonzero checks remain mandatory.']},indent=2)+'\n')
