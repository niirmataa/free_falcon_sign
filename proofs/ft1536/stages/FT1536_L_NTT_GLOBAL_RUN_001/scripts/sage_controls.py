"""Independent polynomial evaluation and ordinary-matrix prefix checks."""
from sage.all import GF,PolynomialRing
import hashlib,json
from pathlib import Path
W=Path.cwd();C=W/'checks';q=18433
tables=json.loads((W/'inputs/certificates/tables_C.json').read_text())
gm=[x*5184%q for x in tables['gm']];ig=[x*5184%q for x in tables['igm']]
omega=14648;wi=pow(omega,-1,q);delta=2523
K=GF(q);P=PolynomialRing(K,'X');X=P.gen()
roots=[K(gm[512+b]*pow(omega,j,q)) for b in range(512) for j in range(3)]
assert len(set(roots))==1536
assert all(x**1536-x**768+1==0 for x in roots)
def read_trace(path):
    ans=[]
    for line in path.read_text().splitlines():
        z=line.split();ans.append(((z[0],int(z[1]),int(z[2])),list(map(int,z[3:]))))
    return ans
def prefix(phase,m,n,a):
    out=a[:]
    if phase in ['froot','iroot','fbin','ibin']:
        h=768 if 'root' in phase else 768//m
        for b in range(n):
            u=(b//h)*2*h+b%h;v=u+h;x,y=a[u],a[v]
            if phase=='froot': z=(x+14649*y,x+(1-14649)*y)
            elif phase=='iroot': z=((1-delta)*x+(1+delta)*y,2*delta*(x-y))
            elif phase=='fbin': s=gm[m+b//h];z=(x+s*y,x-s*y)
            else: s=ig[m+b//h];z=(x+y,s*(x-y))
            out[u],out[v]=[t%q for t in z]
    elif phase=='fcube':
        for b in range(n):
            p=P(a[3*b:3*b+3]);alpha=K(gm[512+b])
            out[3*b:3*b+3]=[int(p(alpha*K(omega)**j)) for j in range(3)]
    elif phase=='icube':
        for b in range(n):
            x=ig[512+b];a0,a1,a2=a[3*b:3*b+3]
            out[3*b:3*b+3]=[(a0+a1+a2)%q,x*(a0+wi*a1+wi*wi*a2)%q,x*x*(a0+wi*wi*a1+wi*a2)%q]
    elif phase=='scale':
        for i in range(n):out[i]=a[i]*18421%q
    else:raise AssertionError(phase)
    return out
count=0;final_hashes=[]
for case in range(2):
    raw=list(map(int,(C/f'input{case}.txt').read_text().split()))
    expected=[int(P(raw)(x)) for x in roots]
    rows=read_trace(C/f'c{case}.trace');last=raw;stage=None;before=None
    for (phase,m,n),a in rows:
        assert len(a)==1536 and all(0<=v<q for v in a)
        if phase=='input':assert a==raw
        elif phase=='forward':assert a==expected
        elif phase=='roundtrip':assert a==raw
        else:
            if (phase,m)!=stage:stage=(phase,m);before=last
            assert a==prefix(phase,m,n,before),(case,phase,m,n)
            count+=1
        last=a
    final_hashes.append(hashlib.sha256((' '.join(map(str,expected))+'\n').encode()).hexdigest())
labels=dict(read_trace(C/'labels.trace'))
raw=list(map(int,(C/'input0.txt').read_text().split()))
assert labels['forward',0,1536]!=[int(P(raw)(x)) for x in roots]
result=dict(exact_arithmetic='GF(18433), Sage polynomial evaluation',cases=2,all_1536_forward_coordinates_equal=True,
            roots_distinct_and_roots_of_Phi=True,prefix_matrices_checked=count,matched_label_mutant_rejected=True,
            expected_forward_vector_sha256=final_hashes,note='finite controls; not a proof of FORWARD_GLOBAL or forward_product')
(W/'artifacts/sage_controls.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
