# Exact minimizers for selected ACTUAL FT1536 cosets and scalar h=0 or1.
# This is not a probability evaluation; it examines exact coefficient support.
from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ
q=ZZ(18433);M=ZZ(65535);B=ZZ(2093922385)
def Q(a,b):return a*a+a*b+b*b
def ctr(x):return (x+q//2)%q-q//2
def lifts(c,bound):
    return [ZZ(c+k*q) for k in range(ceil(QQ(-bound-c)/q),(bound-c)//q+1)]
def h0_min(c,d):
    cand=[(Q(x,y),(x,y),(0,0)) for x in lifts(c,M) for y in lifts(d,M)]
    minimum=min(x[0] for x in cand)
    return minimum,[x for x in cand if x[0]==minimum]
def h1_min(c,d):
    cand=[]
    for u in lifts(c,2*M):
        for v in lifts(d,2*M):
            # Q(a,b)+Q(u-a,v-b)=Q(u,v)/2+2Q(a-u/2,b-v/2).
            # For half-integer center the A2 nearest points lie in these
            # four rounding cells. This structural claim needs its Lean proof.
            for a in [u//2,(u+1)//2]:
                for b in [v//2,(v+1)//2]:
                    if all(-M<=x<=M for x in [a,b,u-a,v-b]):
                        cand.append((Q(a,b)+Q(u-a,v-b),(a,b),(u-a,v-b)))
    minimum=min(x[0] for x in cand)
    return minimum,list(set(x for x in cand if x[0]==minimum))
result=[]
for h,fn in [(0,h0_min),(1,h1_min)]:
    mn,ws=fn(9217,9217)
    norms=sorted(set(Q(ctr(w[1][0]),ctr(w[1][1]))+Q(*w[2]) for w in ws))
    result.append(dict(h=int(h),block_minimum=str(mn),witnesses=[
        dict(z1=[str(y) for y in w[1]],z2=[str(y) for y in w[2]]) for w in ws],
        nine_block_norm=str(9*mn),nine_block_centered_norms=[str(9*x) for x in norms],
        norm_accepts=bool(9*mn<B),all_nine_block_minima_rejected=bool(all(9*x>=B for x in norms)),
        proof_scope='exact finite candidates; completeness of h1 rounding set still a formal obligation'))
assert result[0]['norm_accepts'] and result[0]['all_nine_block_minima_rejected']
assert result[1]['norm_accepts'] and not result[1]['all_nine_block_minima_rejected']
Path('ft1536_exact_minima.json').write_text(json.dumps(dict(schema='FT1536_EXACT_COSET_MINIMA_RESEARCH_V1',
    q=int(q),M=int(M),B=str(B),active_blocks=int(9),zero_blocks=int(759),results=result,
    warning='No FT1536 probability value or extremizing key is inferred.'),indent=int(2))+'\n')
print('EXACT_FT1536_MINIMA_CONTROLS_PASS')
print(json.dumps(result,sort_keys=True))
