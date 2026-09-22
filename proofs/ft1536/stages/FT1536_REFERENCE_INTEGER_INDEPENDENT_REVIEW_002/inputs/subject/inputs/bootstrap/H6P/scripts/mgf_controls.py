"""Rigorous local adaptive Gaussian examples, not independent innovation assumptions."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField
from backend import of,sub,add,half,mul
from dyadic import rn,value
from fractions import Fraction as F
from kernel_model import constants,entry,iteration
W=Path.cwd();RB=RealBallField(384);banks=constants(W)[0];cert=json.loads((W/'CONDITIONAL_MGF.json').read_text());fac=RB(QQ(cert['local_MGF_factor']))
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
def kernel(mu,sigma):
 en=entry(W,mu,sigma);T=banks[en['bank']];count=[a-b for a,b in zip([2**128]+T,T+[0])];S=[]
 for k,n in enumerate(count):
  if n:
   for b in [0,1]:
    a=iteration(W,en,T[k],b)
    if a['ber']['e']<64:S.append(a['output'])
 m=qv(mu);v=qv(sigma)**2;weights={y:(-RB(QQ((y-m)**2)/(2*v))).exp() for y in S};Z=sum(weights.values());return {y:w/Z for y,w in weights.items()},m,v
sigma=rn(F(4,3));paired=mul(sigma,0x3ff279a74590331c);mu1=rn(F(1,4));t0=rn(F(3,16));p1,m1,v1=kernel(mu1,paired);nodes=[];joint=[]
for y1,p in p1.items():
 r1=sub(mu1,of(y1));mu0=add(t0,half(r1));p0,m0,v0=kernel(mu0,sigma);meanXi=sum(RB(m0-y0)*pp for y0,pp in p0.items());nodes.append(dict(y1=y1,mu0=f'{mu0:016x}',center=str(m0),innovation_conditional_mean=str(meanXi),nonzero_mean_certified=meanXi.lower()>0 or meanXi.upper()<0))
 for y0,pp in p0.items():joint.append((y1,y0,p*pp,m1-y1,m0-y0))
assert abs(sum(p for y1,y0,p,x1,x0 in joint)-1)<RB(QQ(1)/2**300)
E1=sum(p*y1 for y1,y0,p,x1,x0 in joint);E0=sum(p*y0 for y1,y0,p,x1,x0 in joint);cov=sum(p*y1*y0 for y1,y0,p,x1,x0 in joint)-E1*E0
rows=[]
for theta in [QQ(-2),QQ(-1),-QQ(1)/4,QQ(1)/4,QQ(1),QQ(2)]:
 mg=sum(p*(RB(theta)*(RB(x0)-RB(x1)/2)).exp() for y1,y0,p,x1,x0 in joint);bound=fac**2*(RB(theta*theta*(qv(sigma)**2+qv(paired)**2/4)/2)).exp();assert mg<=bound
 marginal0=sum(p*(RB(theta)*RB(x0)).exp() for y1,y0,p,x1,x0 in joint);marginal1=sum(p*(-RB(theta)*RB(x1)/2).exp() for y1,y0,p,x1,x0 in joint);gap=abs(mg-marginal0*marginal1)
 rows.append(dict(theta=str(theta),actual_joint_MGF=str(mg),proved_conditional_bound=str(bound),product_of_marginal_MGFs=str(marginal0*marginal1),gap=str(gap),independence_false_certified=gap.lower()>0))
assert any(x['nonzero_mean_certified'] for x in nodes) and any(r['independence_false_certified'] for r in rows)
# Full untruncated normalizer ratio: shifted mean need not remain NumericCenter.
v=qv(sigma)**2;mu=QQ(1)/2;theta=mu/v;terms=lambda m:[(-RB((QQ(y)-m)**2/(2*v))).exp() for y in range(-128,129)]
tail=2*(-RB(QQ(128)**2/(2*v))).exp()/(1-(-RB(QQ(257)/(2*v))).exp());Z0=sum(terms(0)).add_error(QQ(tail.upper()));Zm=sum(terms(mu)).add_error(QQ(tail.upper()));ratio=Z0/Zm;assert ratio>1 and ratio<fac
# Generic support-conditioning countermodel uses a declared toy support {0,1}.
toyfull=sum(terms(0)).add_error(QQ(tail.upper()));w0=RB(1);w1=(-RB(1/(2*v))).exp();t=QQ(-1)/16;toycond=(w0+w1*(-RB(t)).exp())/(w0+w1);toyfullmg=(RB(t*t*v/2)).exp()*sum(terms(-t*v)).add_error(QQ(tail.upper()))/toyfull;assert toycond>toyfullmg
# Exact rational two-point event transfer reaches the Cauchy-Schwarz bound.
q=QQ(1)/5;p=QQ(1)/4;Delta=(p-q)**2/(q*(1-q));assert Delta==QQ(1)/64 and (p-q)**2==Delta*q*(1-q)
out=dict(status='PASS_ADAPTIVE_MGF_AND_EVENT_TRANSFER_CONTROLS',game='IID_BUFFER',reference='Q_S',scope='local source terminal centers/supports, not emitted entry membership; toy support countermodel separately labelled',first_mu=f'{mu1:016x}',stored_sigma=f'{sigma:016x}',paired_sigma=f'{paired:016x}',joint_atoms=len(joint),conditional_nodes=nodes,MGF_checks=rows,output_covariance=str(cov),normalizer_ratio_witness=dict(mean='1/2',shifted_mean='0',variance=str(v),ratio=str(ratio),strictly_above_one=True),truncation_factor_countermodel=dict(scope='EXTENDED_TOY_SUPPORT_{0,1}',conditional_MGF=str(toycond),full_MGF=str(toyfullmg),conditional_exceeds_full=True),exact_event_transfer=dict(Q_bad=str(q),P_bad=str(p),forward_chi2=str(Delta),tight=True),independent_marginals_assumed=False,exact_mean_zero_assumed=False)
(W/'artifacts/mgf_controls.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],joint_atoms=len(joint),nonzero_conditional_mean=True,independence_countermodel=True,normalizer_ratio=str(ratio),toy_conditioning_factor_needed=True),indent=2))
