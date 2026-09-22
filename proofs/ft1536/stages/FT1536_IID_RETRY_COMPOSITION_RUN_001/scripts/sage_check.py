"""Independent QQ consumer of the exact p and simultaneous reset budgets."""
import json
from pathlib import Path
from sage.all import QQ,ZZ
W=Path.cwd();C=json.loads((W/'STOPPED_COMPOSITION.json').read_text());R=json.loads((W/'RESOURCE_BOUND.json').read_text());H=json.loads((W/'inputs/bootstrap/H6P/JOINT_TAIL_BOUND.json').read_text())
p=QQ(H['IID_upper']);u=16*p;h=1-(1-p)**16
assert 0<p<=QQ(1)/2**84 and h<=u<=QQ(1)/2**80
assert QQ(C['per_root_p_outward'])==p and QQ(C['uniform_union_bound'])==u and QQ(C['uniform_hazard_bound'])==h
assert QQ(R['expectation_bounds']['additional_refills'])==16*QQ(811000)/4087
assert R['ghost_budget']['total_generated_blocks']==16*(1+(33*49152-8)//4087)==6352
assert R['ghost_budget']['generated_bytes']==6352*4096==26017792
assert 16*QQ(1)/2**1024==QQ(1)/2**1020
pooled=(33*ZZ(786432)-8*16)//4087+16;assert pooled>6352
out=dict(status='PASS_INDEPENDENT_SAGE_QQ_STOPPED_AND_RESET_ARITHMETIC',p=str(p),union=str(u),hazard=str(h),power2='2^-80',resource_tail='2^-1020',simultaneous_blocks=6352,pooled_relaxation_bound=int(pooled),pooled_bound_is_not_a_source_counterexample=True,simultaneous_sufficient_event=R['ghost_budget_sufficient_event'])
(W/'artifacts/sage_qq.json').write_text(json.dumps(out,indent=2)+'\n');print(out['status'])
