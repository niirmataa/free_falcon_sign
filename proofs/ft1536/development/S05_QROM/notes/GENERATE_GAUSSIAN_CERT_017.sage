# sage GENERATE_GAUSSIAN_CERT_017.sage TABLES OUTDIR
# Exact dyadic recurrence certificates; every inequality still requires Lean replay.
from pathlib import Path
import json,sys,hashlib,time
src=Path(sys.argv[1]);out=Path(sys.argv[2]);out.mkdir(parents=True,exist_ok=True)
assert not (out/'CERTIFICATE.json').exists()
start=time.monotonic();t=json.loads(src.read_text());W=[ZZ(x) for x in t['weights']];V=[ZZ(x) for x in t['acceptance_thresholds']]
assert len(W)==30721 and len(V)==61441 and min(W)>0
c=ZZ(2359296);degree=ZZ(47);D=factorial(degree)*c^degree;scale=ZZ(2)^384;gap=ZZ(2)^400;delta=ZZ(2)^108
coeff=[ZZ(factorial(degree)//factorial(k))*c^(degree-k) for k in range(degree+1)]
assert QQ(1)/32^48*49/(factorial(48)*48)<QQ(1)/2^400
lo=[scale];hi=[scale]
for k in range(30720):
 a=ZZ(2*k+1);N=ZZ(0)
 for v in reversed(coeff):N=N*a+v
 nextlo=(lo[-1]*D*gap)//(N*gap+D)
 nexthi=(hi[-1]*D+N-1)//N
 assert nextlo*(N*gap+D)<=lo[-1]*D*gap
 assert hi[-1]*D<=nexthi*N
 lo.append(nextlo);hi.append(nexthi)
# Complete checks against BOTH sides of the actual CDF and every threshold.
checks=ZZ(0)
for i,w in enumerate(W):
 k=abs(i-15360)
 assert w*2^236 <= (delta+1)*lo[k],('W upper',i)
 assert (delta-1)*hi[k] <= w*2^236,('W lower',i)
 checks+=2
for i,v in enumerate(V):
 k=abs(i-30720)
 assert v*2^128<=lo[k],('V upper',i)
 checks+=1
 if k<=15360:
  assert (delta-1)*hi[k]<=v*2^236,('V central lower',i)
  checks+=1
assert sum(W)<=2723*2^256
# Independent rigorous diagnostic at branch/precision boundaries, not the induction proof.
RB=RealBallField(768)
for k in [0,1,255,256,15359,15360,15361,20460,25000,30719,30720]:
 exact=(-RB(k)^2/RB(c)).exp()
 assert RB(lo[k])/scale<=exact and exact<=RB(hi[k])/scale
res={'status':'ALL_EXACT_ROW_AND_LITERAL_CHECKS_PASS_NOT_YET_KERNEL','input_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),
 'denominator':str(D),'scale_bits':384,'step_remainder_bits':400,'relative_slack_bits':108,'degree':int(degree),
 'coefficients':[str(x) for x in coeff],'lower':[str(x) for x in lo],'upper':[str(x) for x in hi],
 'steps':30720,'literal_comparisons':int(checks),'cdf_total':str(sum(W)),
 'table_total_upper':'2723*2^256','diagnostic_indices':[0,1,255,256,15359,15360,15361,20460,25000,30719,30720]}
(out/'CERTIFICATE.json').write_text(json.dumps(res,indent=2,default=int)+'\n')
(out/'GENERATION_COST.json').write_text(json.dumps({'elapsed_seconds':time.monotonic()-start})+'\n')
print('PASS:',len(lo),'dyadic states;',checks,'literal inequalities; certificate requires kernel verification',flush=True)
