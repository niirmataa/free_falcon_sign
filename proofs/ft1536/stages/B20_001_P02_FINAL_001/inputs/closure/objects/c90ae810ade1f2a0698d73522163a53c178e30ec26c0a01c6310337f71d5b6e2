"""Exact source witnesses with explicit envelope/standalone-leaf membership."""
import json
from pathlib import Path
from fractions import Fraction as Q
from backend import of,div,sqrt
from dyadic import value,rn
from kernel_model import entry,iteration,constants,expword
from replaylib import sha
W=Path.cwd();T,coefs,C=constants(W);dom=json.loads((W/'REDUCTION_DOMAIN.json').read_text());raw=of(331776);sigma=div(of(768),sqrt(raw));assert sigma==rn(Q(4,3))
width=json.loads((W/'inputs/bootstrap/NORMALIZED/WIDTH_BOUNDS.json').read_text());assert Q(width['gate']['D_min'])<=value(raw)<=Q(width['gate']['D_max'])
found=[]
for row in dom['above_literal_log2_buckets']:
 target=int(row['x_last'],16)
 for k in range(1,30):
  def at(mu):return iteration(W,entry(W,mu,sigma),T[0][k],0)
  lo,hi=0,rn(1)-1
  if not at(lo)['x']<=target<=at(hi)['x']:continue
  while lo<hi:
   mid=(lo+hi)//2
   if at(mid)['x']>=target:hi=mid
   else:lo=mid+1
  point=at(lo)
  if point['x']==target:
   assert point['k']==k and value(point['ber']['rB'])>value(0x3fe62e42fefa39ef)
   found.append(dict(classification='SCALAR_DERIVED_D_ENV_AND_NORMALIZER_DERIVED_STANDALONE_GATE_ADMISSIBLE_LEAF',mu=f'{lo:016x}',sigma=f'{sigma:016x}',leaf_D=f'{raw:016x}',leaf_value='331776=576^2',native_leaf_expression='div_C(of_C(768),sqrt_C(D)), source sign987-990',k=k,b=0,U128=str(T[0][k]),x=f'{target:016x}',rB=f"{point['ber']['rB']:016x}",exponent=point['ber']['e'],refuted_premise='all scalar-derived source rB <= literal binary64(log2)',required_Emitted_membership_proved=False,point=point));break
 if len(found)>=3:break
assert found
neg=[]
for power in [40,50,63,64,100,1022,1074]:
 word=rn(-Q(1,2**power));y,trace=expword(W,word);neg.append(dict(classification='EXTENDED_EXPM_INPUT_ONLY_NOT_CERTIFIED_SCALAR_REMAINDER',rB=f'{word:016x}',rB_value=str(value(word)),expm=str(y),threshold=str(y>>8),trace=trace,required_or_scalar_membership=False))
out=dict(status='PASS_EXACT_CLASSIFIED_WITNESSES',game='IID_BUFFER',overrun_scalar_witnesses=found,negative_expm_extended=neg,required_domain_counterexample=False,refuted_nominal_interval_premise_on_local_domain=True,source_changed=False)
(W/'artifacts/witnesses.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],scalar_overrun=len(found),first={k:v for k,v in found[0].items() if k!='point'},negative_extended=len(neg)),indent=2))
