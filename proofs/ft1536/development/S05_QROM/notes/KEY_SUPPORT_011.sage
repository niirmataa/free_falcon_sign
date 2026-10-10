# sage KEY_SUPPORT_011.sage OUTDIR
# Finite exact controls: source emission conditioning, support and joint J/P.
import json,sys
from pathlib import Path
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'checks.json').exists()
def second(j,p):
 assert len(j)==len(p)
 assert all(p[i]>0 or j[i]==0 for i in range(len(j)))
 return sum(j[i]^2/p[i] for i in range(len(j)) if p[i]>0)
def emitted(weights,emit,pub):
 mass=sum(weights[i] for i in range(len(weights)) if emit[i])
 if mass==0:raise ValueError('positive emission mass required')
 return [sum(weights[i] for i in range(len(weights)) if emit[i] and pub[i]==h)/mass for h in range(3)]
count=0;min_accept=QQ(1)
for weights in [[QQ(1)/4]*4,[QQ(1)/1024,QQ(3)/1024,QQ(1020)/1024,QQ(0)],[QQ(0),QQ(0),QQ(1)/2,QQ(1)/2]]:
 for mask in range(1,16):
  emit=[bool(mask&(1<<i)) for i in range(4)];pub=[0,1,0,2]
  acceptance=sum(weights[i] for i in range(4) if emit[i])
  if acceptance==0:continue
  mu=emitted(weights,emit,pub);assert sum(mu)==1
  min_accept=min(min_accept,acceptance)
  assert all(any(weights[i]>0 and emit[i] and pub[i]==h for i in range(4)) for h in range(3) if mu[h]>0)
  # Full replies: first entry is none, second is a positive reply.
  P=[[QQ(1)/4,QQ(3)/4],[QQ(1),QQ(0)],[QQ(1)/2,QQ(1)/2]]
  J=[[QQ(1)/3,QQ(2)/3],[QQ(1),QQ(0)],[QQ(1)/4,QQ(3)/4]]
  local=[second(J[h],P[h]) for h in range(3)]
  jointJ=[mu[h]*J[h][o] for h in range(3) for o in range(2)]
  jointP=[mu[h]*P[h][o] for h in range(3) for o in range(2)]
  assert second(jointJ,jointP)==sum(mu[h]*local[h] for h in range(3))
  assert second(jointJ,jointP)<=max(local[h] for h in range(3) if mu[h]>0)
  count+=1
try:emitted([QQ(1),QQ(0)],[False,True],[0,1])
except ValueError:zero_rejected=True
else:raise AssertionError('zero emission law was normalized')
# Scoped AC cannot be promoted to all keys. The zero-mass bad key is explicit.
mu=[QQ(1),QQ(0)];P=[[QQ(1),QQ(0)],[QQ(1),QQ(0)]];J=[[QQ(1),QQ(0)],[QQ(0),QQ(1)]]
assert second([mu[h]*x for h in range(2) for x in J[h]],[mu[h]*x for h in range(2) for x in P[h]])==1
assert J[1][1]>0 and P[1][1]==0
# Sampling h twice is a different experiment: the same-key diagonal event
# has probability1 with one draw and1/2 with two independent uniform draws.
assert sum(QQ(1)/2 for _ in range(2))==1
assert sum((QQ(1)/2)^2 for _ in range(2))==QQ(1)/2
(out/'checks.json').write_text(json.dumps({'status':'PASS_EXACT_FINITE_CONTROLS','condition_class':'proof_obligation',
 'condition_ids':['Q-KEY','Q-SAMPLER'],'cases':int(count),'minimum_emission_mass':str(min_accept),
 'zero_emission_rejected':zero_rejected,'scoped_not_all_h_negative_control':True,
 'single_key_not_resampling_control':True,'full_reply_none_retained':True,
 'scope':'Finite controls only; kernel proofs are separate; no actual emission or sampler007 instantiation'},indent=2)+'\n')
print('PASS:',count,'exact emission/support/full-moment cases and three boundary controls')
