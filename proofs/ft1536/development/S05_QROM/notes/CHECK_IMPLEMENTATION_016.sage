# sage CHECK_IMPLEMENTATION_016.sage OUT TABLES PAIR_CERT
# Exact finite arithmetic, standard preparser. No all-outcome proof inferred.
from pathlib import Path
import json,sys,time
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'RESULT.json').exists()
tables=json.loads(Path(sys.argv[2]).read_text());old=json.loads(Path(sys.argv[3]).read_text())
start=time.monotonic()
w=[ZZ(x) for x in tables['weights']];threshold=[ZZ(x) for x in tables['acceptance_thresholds']]
assert len(w)==30721 and len(threshold)==61441
assert min(w)>0 and min(threshold)>=0 and max(threshold)<=2^256
N=ZZ(2)^384;T=sum(w);q,r=N.quo_rem(T);cdf=[];counts=[];s=ZZ(0)
for x in w:
 counts.append(q*x+max(ZZ(0),min(x,r-s)));s+=x;cdf.append(s)
assert sum(counts)==N and s==T
P=PolynomialRing(ZZ,'X');counts_poly=P(counts);conv=(counts_poly^2).list()
alpha=QQ(sum(conv[i]*threshold[i] for i in range(len(threshold))))/(N^2*2^256)
assert alpha==QQ(old['alpha_exact']) and alpha>QQ(9)/16
# Exact small counter/control laws: every rejection path belongs to output law.
cases=0
for a in [QQ(0),QQ(1)/4,QQ(1)]:
 for n in [0,1,2,80]:
  geometric=sum((1-a)^i for i in range(n))
  for l in [[QQ(1),QQ(0)],[QQ(1)/3,QQ(2)/3]]:
   for fallback in [[QQ(1),QQ(0)],[QQ(1)/2,QQ(1)/2]]:
    recursive=[geometric*a*l[j]+(1-a)^n*fallback[j] for j in range(2)]
    mixture=[(1-(1-a)^n)*l[j]+(1-a)^n*fallback[j] for j in range(2)]
    assert recursive==mixture and sum(mixture)==1;cases+=1
# Reusing the rejected coin through its complement is not a fresh fallback.
# Accept at b=1 and otherwise output1-b: always1. An independent complement
# 1-f at rejection instead gives3/4. Enumerate the complete two/four outcomes.
shared=sum(QQ(1)/2 for b in [0,1] if (1 if b else 1-b)==1)
fresh=sum(QQ(1)/4 for b in [0,1] for f in [0,1] if (1 if b else 1-f)==1)
assert shared==1 and fresh==QQ(3)/4 and shared!=fresh
# Coarse purely rational envelopes for a later local table/normalizer bridge.
C=(1+QQ(1)/2^72)^1536;zeta=QQ(65)/2^30
assert C<1+QQ(1)/2^61 and C/2^24<zeta<1
assert QQ(1)/2^70<zeta^196*2^4630<QQ(1)/2^69
assert 1+(C-1)/(1-zeta)+zeta^196*2^4630<1+QQ(1)/2^60
res={'status':'EXACT_FINITE_CHECKS_NOT_FULL_KERNEL_TABLE_CERTIFICATE','alpha_exact':str(alpha),
 'alpha_gt_9_16':True,'weights':len(w),'thresholds':len(threshold),'counts_sum':str(N),
 'cdf_total':str(T),'full_fallback_laws':int(cases),'shared_fallback_counterexample':{'rule':'accept1; otherwise complement of shared/fresh bit','shared':str(shared),'fresh':str(fresh)},
 'coarse_numeric_envelope':True,'analytic_table_bounds_kernel':False,'elapsed_seconds':time.monotonic()-start}
(out/'RESULT.json').write_text(json.dumps(res,indent=2)+'\n')
print('PASS: exact table acceptance,',cases,'full fallback laws, shared-fallback counterexample, numeric envelope',flush=True)
