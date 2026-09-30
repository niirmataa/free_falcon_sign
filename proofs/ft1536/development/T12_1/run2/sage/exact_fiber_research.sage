# Exact finite analogue only. It is not an FT1536 numerical experiment.
# Goal: expose the actual integer counting problem and key dependence.
from pathlib import Path
import json
from sage.version import version as sage_version
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10==1024
q=ZZ(7);M=ZZ(4);B=ZZ(16);cap=ZZ(16)
R=PolynomialRing(ZZ,'T');T=R.gen()
def Q(x):return x[0]^2+x[0]*x[1]+x[1]^2
def center(x):return (x+q//2)%q-q//2
def mul(h,s):
    # X^2=X-1
    return ((h[0]*s[0]-h[1]*s[1])%q,
            (h[0]*s[1]+h[1]*s[0]+h[1]*s[1])%q)
vectors=[(ZZ(a),ZZ(b)) for a in range(-M,M+1) for b in range(-M,M+1)]
points=[(a,b,Q(a)+Q(b),Q((center(a[0]),center(a[1])))+Q(b)) for a in vectors for b in vectors]
keys=[(ZZ(a),ZZ(b)) for a in range(q) for b in range(q)]
evaluations=[QQ(1/2),QQ(1)]
results=[];exact_polynomials={}
for h in keys:
    fibers={c:[{}, {}, {}] for c in keys}
    for a,b,norm,verify_norm in points:
        hb=mul(h,b);c=((a[0]+hb[0])%q,(a[1]+hb[1])%q)
        Z,S,F=fibers[c]
        Z[norm]=Z.get(norm,ZZ(0))+1
        if norm<B:
            S[norm]=S.get(norm,ZZ(0))+1
            if verify_norm>=B:
                F[norm]=F.get(norm,ZZ(0))+1
    polys={c:tuple(R(d) for d in vals) for c,vals in fibers.items()}
    vals=[]
    for t in evaluations:
        total=QQ(0)
        for c,(Z,S,F) in polys.items():
            z,s,f=Z(t),S(t),F(t)
            assert z>0 and 0<=f<=s<=z
            a=s/z
            exact=(f/z)*sum((1-a)^i for i in range(cap))
            expanded=sum((-1)^j*binomial(cap,j+1)*f*s^j/z^(j+1) for j in range(cap))
            assert exact==expanded
            total+=exact/q^2
        vals.append(dict(t=str(t),delta=str(total)))
    results.append(dict(h=[int(x) for x in h],values=vals))
    if h in [(0,0),(1,0),(2,0),(3,0)]:
        exact_polynomials[str(tuple(h))]={str(tuple(c)):[str(p) for p in ps] for c,ps in polys.items()}
    print('EXACT_KEY_DONE',h,flush=True)
maxima=[]
for index,t in enumerate(evaluations):
    values=[QQ(r['values'][index]['delta']) for r in results]
    mx=max(values);mn=min(values)
    assert mx>mn
    maxima.append(dict(t=str(t),max_delta=str(mx),min_delta=str(mn),
        max_rounded_15_places=str(floor(mx*10^15+1/2)),
        min_rounded_15_places=str(floor(mn*10^15+1/2)),
        maximizing_keys=[r['h'] for r,v in zip(results,values) if v==mx]))
result=dict(schema='RUN002_EXACT_FIBER_ANALOGUE_V1',scope='diagnostic exact small analogue; NOT FT1536',
    q=int(q),dimension=int(2),box_radius=int(M),norm_bound=int(B),cap=int(cap),
    ring='ZZ[X]/(X^2-X+1)',weights='T^Q, exact QQ evaluations T=1/2 and1',
    keys=results,maxima=maxima,selected_fiber_polynomials=exact_polynomials,
    findings=['Exact law is a rational function of T with integer-count coefficient polynomials.',
        'In the finite analogue delta genuinely depends on h; no FT1536 extremizer follows from these tests.',
        'No FT1536 estimate, key-law substitution, or extrapolation is made.'])
Path('exact_fiber_research.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('EXACT_FIBER_RESEARCH_PASS',flush=True)
