"""Residual reconstruction error, source root gain and forward signal/history separation."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,PolynomialRing
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';U=QQ(1)/2**48;eta=QQ(1)/2**900;ep=QQ(1)/2**50;gam=QQ(1)/2**36;tau=QQ(1)/2**800;L=1+QQ(1)/2**40
P=PolynomialRing(QQ,'B');B=P.gen()
def cmerr(M,e,d):return 2*M*d+2*e*(1+d)+6*U*(M+e)*(1+d)+4*eta
def covers(e,slope=gam):
 d=P(tau+slope*B-e);assert all(c>=0 for c in d.list());return str(e)
ew=2*cmerr(B,0,ep);es=2*ew+U*(2*B+2*ew)+2*eta;es+=U*(3*B+es)+2*eta
esq=cmerr(QQ(1),ep,ep);pre=2*cmerr(3*B,es,esq);third=QQ(6004799503160661)/18014398509481984
top=third*pre+3*B*abs(third-QQ(1)/3)+U*third*(3*B+pre)+2*eta
deep=cmerr(2*B,2*U*B+2*eta,ep)+2*eta
merge=2*cmerr(B,0,ep)+U*(2*B+2*cmerr(B,0,ep))+2*eta
mt=2*cmerr(B,2*cmerr(B,0,ep),ep)+2*cmerr(B,2*cmerr(B,0,esq),ep);mt+=U*(2*B+mt)+2*eta;mt+=U*(3*B+mt)+2*eta
polys={k:covers(v) for k,v in [('top_split',top),('deep_split',deep),('deep_merge',merge),('top_merge',mt)]}
# Terminal merge and split use exact coefficient reference (1/2,sqrt3/2), and its inverse.
assert gam>256*U+64*ep and tau>1024*eta
def ceil(x):return ZZ(x.ceil())
def up(x):return QQ(ceil(x*2**50))/2**50
G=1+QQ(1)/2**32
def capadd(a,b):return QQ(ceil(G*(a+b))+1)
def capmul(a,b):return QQ(ceil(G*a*b)+1)
def capmerge(a,b):return QQ(ceil(G*(a+b))+1)
R=[(QQ(552),QQ(367))];E=[(QQ(0),QQ(0))];steps=[]
for k in range(1,9):
 a,b=R[-1];ea,eb=E[-1];right=capmerge(a,b);er=up(ea+eb+gam*(a+b)+tau)
 product=capmul(right,L);epd=up(L*er+gam*right*L+tau)
 left=capadd(right,product);el=up(er+epd+gam*(right+product)+tau)
 R.append((left,right));E.append((el,er));steps.append(dict(level=k,R0=str(left),R1=str(right),E0=str(el),E1=str(er)))
a,b=R[8];ea,eb=E[8];m=capmerge(a,b);em=up(ea+eb+gam*(a+b)+tau)
z2=m;e2=em;p21=capmul(z2,4);ep21=up(4*e2+gam*z2*4+tau);z1=capadd(m,p21);e1=up(em+ep21+gam*(m+p21)+tau)
p10=capmul(z1,2);ep10=up(2*e1+gam*z1*2+tau);p20=capmul(z2,2);ep20=up(2*e2+gam*z2*2+tau)
s=capadd(m,p10);es=up(em+ep10+gam*(m+p10)+tau);z0=capadd(s,p20);e0=up(es+ep20+gam*(s+p20)+tau)
zcap=QQ(ceil(G*(z0+z1+z2))+1);zerr=up(e0+e1+e2+gam*(z0+z1+z2)+tau)
old=json.loads((I/'ORDERED/artifacts/bounds.json').read_text());assert zcap==QQ(old['refined_right']['merged_cap'])
bank=json.loads((W/'BANK_WEIGHTED_BOUNDS.json').read_text());metric=json.loads((W/'artifacts/metric_bounds.json').read_text())
kappa=QQ(metric['products'][1]['metric_to_stable_integer_factor']);gain=QQ(metric['root']['source_root_gain_squared_integer_upper']);terminalE=QQ(bank['right_768_terminal_budget']);Lroot=QQ(2**25)
def rootup(x):return QQ(ZZ(ceil(x)).isqrt()+1)
energy= kappa*terminalE
coefcorrection=rootup(2*gain*energy);freqcorrection=rootup(768*gain*energy)
productcap=freqcorrection+Lroot*zerr
mulround=6*U*productcap+8*eta;t0cap=QQ(4829216911);addround=U*(t0cap+productcap+mulround)+2*eta
M=QQ(ceil(t0cap+productcap+mulround+addround))
initialcoef=QQ(173861259265)/36866
coefcap=QQ(ceil(initialcoef+coefcorrection+2*Lroot*zerr+2*(mulround+addround)))
# Actual signal is mathematical inverse-eval of the source U words. Source splitting
# is checked separately. Signal descendants are coefficient groupings, not rounded FFT.
def hs(h,k):return up((2 if k==1 else 1)*h+gam*(M+h)+tau)
def ha(h,p):return up(h+p+gam*(M+h+p)+tau)
records=[]
def inner(k,h0,h1,path):
 if k==0:
  mu1=ceil(coefcap+h1);mu0=ceil(coefcap+h0+184+gam*(coefcap+h0+184)+tau)
  assert mu1<2147483282 and mu0<2147483282
  records.append(dict(path=path,mu1_cap=int(mu1),mu0_cap=int(mu0),history0=str(h0),history1=str(h1),ZERO_only_after_current_bound=True,
   source_PC='terminal1637-1645 to sampler_large2864',domain='Required left active finite history after actual right completion faultNONE; signal/history invariant',
   dependencies=['root actual-U coefficient/frequency caps','signed source split and add defects','previous NORMAL_RETURN residual caps'],discharge='FORWARD_CURRENT_BOUND_BEFORE_ZERO'))
  return R[0]
 d=hs(h1,k);a,b=inner(k-1,d,d,path+'1');right=capmerge(a,b);p=capmul(right,L)
 d=hs(ha(h0,p),k);a,b=inner(k-1,d,d,path+'0');return capadd(capmerge(a,b),p),right
h=up(gam*M+tau);d=hs(h,9);a,b=inner(8,d,d,'2');c2=capmerge(a,b);p21=capmul(c2,4)
d=hs(ha(h,p21),9);a,b=inner(8,d,d,'1');c1=capadd(capmerge(a,b),p21)
d=hs(ha(ha(h,capmul(c1,2)),capmul(c2,2)),9);a,b=inner(8,d,d,'0')
assert len(records)==768
leftmax=max(max(r['mu1_cap'],r['mu0_cap']) for r in records);globalmax=max(leftmax,old['right_numeric_abs_bound'])
assert M<2**36 and max(QQ(r['history0']) for r in records)<2**31
out=dict(schema='FT1536_LEFT_SOURCE_ENERGY_TRANSFER_V1',status='PASS_NUMERIC_ENERGY_AND_FORWARD_LEFT_ENCLOSURES',gamma=str(gam),tiny_floor=str(tau),error_polynomials=polys,
 reconstruction=dict(binary_steps=steps,cubic_caps=[str(z0),str(z1),str(z2)],cubic_errors=[str(e0),str(e1),str(e2)],right_source_residual_norm_cap=str(zcap),
  actual_to_exact_source_L_reconstruction_norm_error=str(zerr),terminal_pairs_are_actual_source_returned_words=True,not_ideal_sample_integers=True),
 weighted=dict(metric_factor=str(kappa),terminal_budget=str(terminalE),right_reference_Gram_energy_upper=str(energy)),
 root=dict(source_gain_squared=str(gain),coefficient_correction_cap=str(coefcorrection),frequency_correction_cap=str(freqcorrection),
  source_CM_rounding_error=str(mulround),source_add_rounding_error=str(addround),actual_U_frequency_cap=str(M),actual_U_inverse_eval_coefficient_cap=str(coefcap),
  reconstruction_defect_coefficient_allowance=str(2*Lroot*zerr),ideal_root_determinant_not_assumed=True),
 left_forward=dict(signal='Exact coefficient groupings of mathematical inverse-eval of source U; source operations add separately certified errors and actual normal-return corrections',
  per_terminal=records,active_positions=1536,mu_abs_upper=int(leftmax),lower_margin=2147483283-int(leftmax),upper_margin=2147483282-int(leftmax),all_current_bounds_checked_before_ZERO=True),
 full_composition=dict(right_abs_mu=old['right_numeric_abs_bound'],left_abs_mu=int(leftmax),global_abs_mu=int(globalmax),lower_margin=2147483283-int(globalmax),upper_margin=2147483282-int(globalmax)),
 source_prefix_only=True,whole_rejection_or_Sign_termination=False,
 dependencies={p:sha(W/p) for p in ['BANK_WEIGHTED_BOUNDS.json','artifacts/metric_bounds.json']})
(W/'artifacts/energy_transfer.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],metric_factor=str(kappa),right_reconstruction_error=str(zerr),root_U_frequency_cap=str(M),root_U_coefficient_cap=str(coefcap),left_and_global=out['full_composition']),indent=2))
