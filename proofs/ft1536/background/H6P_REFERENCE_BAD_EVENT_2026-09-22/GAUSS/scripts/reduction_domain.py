"""Per-bank source envelopes and exact whole-word exponent preimage boundaries."""
import json
from pathlib import Path
from fractions import Fraction as Q
from backend import mul,sub,of
from fp_literal import floor
from dyadic import value,rn
from kernel_model import constants,ber
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';U=Q(1,2**48);eta=Q(1,2**900);T,coefs,C=constants(W);width=json.loads((I/'NORMALIZED/WIDTH_BOUNDS.json').read_text());rows=[]
em=Q(1,2**51);ed=Q(1,2**45);epsd=U+4096*eta
assert 13*Q(1,2**55)+Q(1,2**1021)<em
assert (1+epsd)/(1-epsd)**2-1<ed and 1-(1-epsd)/(1+epsd)**2<ed
for cls in ['stored','paired']:
 for j,K in enumerate([29,59,118,235,365]):
  a=value(coefs[j]);dhi=min(Q(width[cls]['dss_upper']),value(coefs[j-1]) if j else Q(1));dlo=max(Q(width[cls]['dss_lower']),a)
  assert 0<dlo<=dhi<1 and dhi>=a
  def mp(x,y):return (1+U)*x*y+eta
  def ap(x,y):return (1+U)*(x+y)+eta
  gap=(dhi-a)+U*(dhi+a)+eta;tail=ap(mp(2*K,1),mp(1,1));x=ap(mp(K*K,gap),mp(tail,dhi));assert x<273
  gaperr=U*(dhi+a)+eta;firsterr=K*K*gaperr+U*K*K*gap+eta
  tailerr=2*K*em+(2*em+em*em)+U*(2*K+1)+2*eta+U*(mp(2*K,1)+mp(1,1))+eta
  err=firsterr+dhi*tailerr+U*tail*dhi+eta+U*(mp(K*K,gap)+mp(tail,dhi))+eta
  param=dhi/(1-ed)*(ed*(K+1)**2+2*(K+1)*em+em**2)
  assert err<Q(1,2**35) and param<Q(1,2**35)
  rows.append(dict(width_class=cls,bank=j,K=K,a=str(a),dss_lower=str(dlo),dss_upper=str(dhi),upper_exclusive_from_previous_bank=(j>0),gap_cap=str(gap),tail_cap=str(tail),x_cap=str(x),x_cap_ceil=(x.numerator+x.denominator-1)//x.denominator,correction_abs_error=str(err),parameter_quadratic_abs_error=str(param)))
L=0x3fe62e42fefa39ef;INV=0x3ff71547652b82fe;MAX=rn(273);half=rn(Q(1,2));queries=[]
def exponent(w):
 z=mul(w,INV);assert z==rn(value(w)*value(INV));return floor(z)
assert exponent(half)==0 and exponent(MAX)==393
starts=[0]
for e in range(1,394):
 lo,hi=half,MAX+1
 while lo<hi:
  mid=(lo+hi)//2
  if exponent(mid)>=e:hi=mid
  else:lo=mid+1
 assert exponent(lo)==e and exponent(lo-1)==e-1
 starts.append(lo)
starts.append(MAX+1);buckets=[];negative=[];above=[]
for e in range(394):
 lo,hi=starts[e],starts[e+1]-1;ce=mul(of(e),L);assert ce==rn(e*value(L))
 rblo=sub(lo,ce);rbhi=sub(hi,ce)
 if e:
  assert value(ce)/2<=value(lo)<=value(hi)<=2*value(ce)
  assert value(rblo)==value(lo)-value(ce) and value(rbhi)==value(hi)-value(ce)
 else:assert rblo==0 and rbhi==hi
 row=dict(e=e,x_first=f'{lo:016x}',x_last=f'{hi:016x}',source_e_log2=f'{ce:016x}',rB_first=f'{rblo:016x}',rB_last=f'{rbhi:016x}',rB_lower=str(value(rblo)),rB_upper=str(value(rbhi)),normal_mul_RN_and_Sterbenz_source_instance=True)
 buckets.append(row)
 if value(rblo)<0:negative.append(row)
 if value(rbhi)>value(L):above.append(row)
 for w in sorted(set([lo,hi,max(lo,lo+1),max(lo,hi-1)])):
  if w<=hi:queries.append(dict(x=f'{w:016x}',**ber(W,w)))
out=dict(schema='SCALAR_GAUSSIAN_REDUCTION_DOMAIN_V1',game='IID_BUFFER',status='PASS_EXACT_DOMAIN_CERTIFICATE',D_cert='IID/LEFT/NORMALIZED required entries',D_env='NumericCenter raw mu; positive finite sigma with one certified stored/paired value AND dss interval; actual source dss/first-bank; certified subset, not Emitted membership for every envelope point',cert_to_envelope_inclusion='direct substitution of pinned width/center source interfaces',width_classes=rows,x_uniform_cap=273,e_uniform_max=393,center_mean_error=str(em),delta_error=str(em),dss_relative_error_to_true_precision=str(ed),buckets=buckets,negative_remainder_buckets=negative,above_literal_log2_buckets=above,global_rB_lower=str(min(Q(r['rB_lower']) for r in buckets)),global_rB_upper=str(max(Q(r['rB_upper']) for r in buckets)),dependencies={p:sha(I/p) for p in ['IID/SCALAR_KERNEL_CERTIFICATE.json','NORMALIZED/WIDTH_BOUNDS.json','ZERO/ANALYTIC_PROOF.md']},boundary_proof_method='normal multiplication exact-RN/monotone from 25-bit limb+sticky packing; binary preimage brackets; source subtraction exact by Sterbenz. Finite brackets cover whole word intervals, not a grid supremum.')
(W/'REDUCTION_DOMAIN.json').write_text(json.dumps(out,indent=2)+'\n');(W/'artifacts/reduction_boundary_words.json').write_text(json.dumps(queries,separators=(',',':'))+'\n')
print(json.dumps(dict(status=out['status'],bank_x_ceil=[r['x_cap_ceil'] for r in rows],e_max=393,negative_buckets=len(negative),above_log2_buckets=len(above),rB_range=[out['global_rB_lower'],out['global_rB_upper']],first_negative=negative[:1],first_above=above[:1]),indent=2))
