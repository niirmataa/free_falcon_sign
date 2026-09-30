# NUMERICAL LOCATOR ONLY. RDF/scipy values here are NOT certified results.
# Exact integer triangle; continuous radial approximation to locate the
# subsequent interval calculation. This is not the final FT1536 probability.
from pathlib import Path
import json
import numpy as np
from scipy.special import gammaincc
assert parent(1) is ZZ and parent(1/3) is QQ
q=ZZ(18433);sigma=ZZ(768);B=ZZ(2093922385);half=(q-1)//2
scale=float(2*sigma^2)
R=RealBallField(128)
G=float(4*R.pi()*sigma^2/R(3).sqrt())
total=0.0;pair_count=ZZ(0)
row_records=[]
for aa in range(int(half+1),int((3*q)//4)+1):
    lo=-half;hi=q-2*aa-1
    if hi<lo:continue
    b=np.arange(int(lo),int(hi)+1,dtype=np.int64)
    a=np.int64(aa);ac=a-np.int64(q)
    Q=a*a+a*b+b*b
    Qc=ac*ac+ac*b+b*b
    assert np.all(Qc>Q) and np.all(Q>=0) and np.all(Qc<B)
    lower=(float(B)-Qc.astype(np.float64))/scale
    upper=(float(B)-Q.astype(np.float64))/scale
    gap=gammaincc(int(1535),lower)-gammaincc(int(1535),upper)
    row=float(np.sum(np.exp(-Q.astype(np.float64)/scale)*gap))
    total+=row;pair_count+=len(b)
    if aa % 256==0:row_records.append(dict(a=int(aa),row_diagnostic=repr(row)))
p_first=4*768*total/G
norm_tail=float(gammaincc(int(1536),float(B)/scale))
candidate=p_first/(1-norm_tail)
res=dict(schema='FT1536_CENTERING_LOCATOR_NOT_CERTIFIED',
    exact_triangle_pair_count=str(pair_count),unconditional_single_block_union_locator=repr(p_first),
    conditional_norm_locator=repr(candidate),continuous_norm_tail_locator=repr(norm_tail),
    rows=row_records,
    omitted_proofs=['discrete radial law vs gamma with continuity correction',
      'multiple changed blocks inclusion-exclusion','source legal-key flatness and retry binding'],
    certified_digits=int(0),not_final_probability=True)
Path('centering_locator.json').write_text(json.dumps(res,indent=int(2),sort_keys=True)+'\n')
print('LOCATOR_ONLY_NOT_CERTIFIED',json.dumps({k:res[k] for k in ['exact_triangle_pair_count',
  'unconditional_single_block_union_locator','conditional_norm_locator','continuous_norm_tail_locator']}))
