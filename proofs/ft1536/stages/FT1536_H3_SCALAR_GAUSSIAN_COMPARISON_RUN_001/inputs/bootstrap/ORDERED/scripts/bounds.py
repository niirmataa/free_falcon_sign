"""Exact transfer bounds and documented failed full-root routes; not a numerical search for keys."""
import json,re
from fractions import Fraction as F
from math import isqrt
from pathlib import Path
from replaylib import sha
from dyadic import value
W=Path.cwd();I=W/'inputs/bootstrap';eps=F(1,2**32);G=1+eps
def ceil(x):return -(-x.numerator//x.denominator)
def add(a,b):return ceil(G*(a+b))+1
def mul(a,b):return ceil(G*a*b)+1
def split(a,k):return ceil(G*(2 if k==1 else 1)*a)+1
def merge(a,b):return ceil(G*(a+b))+1
# Absolute eta floors are covered by the explicit +1. Applies to <2^80 operands.
# No ZERO result is used until the recursively computed current mu bound passes.
def binary(k,a,b,L,records,tag):
 if k==0:
  mu1=b;mu0=add(a,184);maxmu=max(mu1,mu0)
  records.append(dict(path=tag,level=0,mu1=mu1,mu0=mu0,maxmu=maxmu))
  return 552,367,maxmu
 d=split(b,k);r0,r1,mr=binary(k-1,d,d,L,records,tag+'1');z1=merge(r0,r1)
 prod=mul(z1,L);updated=add(a,prod);d=split(updated,k)
 l0,l1,ml=binary(k-1,d,d,L,records,tag+'0');z0=add(merge(l0,l1),prod)
 return z0,z1,max(mr,ml)
def cubic(M,L):
 rs=[];n=9;d=split(M,n);r0,r1,m2=binary(8,d,d,L,rs,'2');z2=merge(r0,r1)
 p21=mul(z2,4);d=split(add(M,p21),n);r0,r1,m1=binary(8,d,d,L,rs,'1');z1=add(merge(r0,r1),p21)
 p10=mul(z1,2);p20=mul(z2,2);d=split(add(add(M,p10),p20),n);r0,r1,m0=binary(8,d,d,L,rs,'0');z0=add(add(merge(r0,r1),p10),p20)
 return dict(input=M,binary_L=str(L),return_caps=[z0,z1,z2],merged_cap=ceil(G*sum([z0,z1,z2]))+1,mu_cap=max(m0,m1,m2),terminal_blocks=rs)
target=json.loads((I/'TARGETS/INITIAL_TARGET_CERTIFICATE.json').read_text());t0=4829216911;t1=2359169;M=ceil(G*t1)+1
coarse=cubic(M,F(2));refined=cubic(M,1+F(1,2**40));assert len(refined['terminal_blocks'])==768
safe=2147483281
assert refined['mu_cap']<safe and coarse['mu_cap']<safe
# Actual L=c/h (componentwise div); TOWER H positive implies |c|<h.
# Its error bound <=2U gives |L_source|<1+2U<1+2^-40, not a new key premise.
rootL=2**25;root_update=add(t0,mul(refined['merged_cap'],rootL));nextM=ceil(G*root_update)+1
full_independent=cubic(nextM,1+F(1,2**40));assert full_independent['mu_cap']>safe
# Even exact initial-target coefficient l2 transport alone does not bound the L-weighted residual.
coeff=F(86930620416,18433)+F(1,2);assert coeff<5000000
# Source selected bank supports (each count is the number of positive u128 thresholds).
text=(W/'source/ft1536-adaptive-cdf-tables.h').read_text();body=text.split('ft_adaptive_cdf[',1)[1]
pairs=[tuple(map(int,p)) for p in re.findall(r'\{\s*(\d+)u,\s*(\d+)u\s*\}',body)];assert len(pairs)==2560
supports=[sum(hi!=0 or lo!=0 for hi,lo in pairs[512*i:512*(i+1)]) for i in range(5)];assert supports==[29,59,118,235,365]
norm=json.loads((I/'NORMALIZED/WIDTH_BOUNDS.json').read_text());Dmin=F(norm['gate']['D_min']);Dmax=F(norm['gate']['D_max'])
# Proposed weighted route with precise OPEN source Gram/triangular defect premise.
# For bank j>0, failure of previous ge gives S^2 > v_prev up to the pinned source dss error.
# Thus R_j^2*D <= (K_j+1+E)^2 *768^2/v_prev times inflation; bank0 uses Dmax.
R=[F(k+1)+F(1,2**20) for k in supports];vprev=[None,5,20,80,320];weighted=[]
for j in range(5):
 B=R[j]**2*Dmax if j==0 else R[j]**2*768**2/F(vprev[j])*(1+F(1,2**30))
 weighted.append(dict(bank=j,support=supports[j],conditional_stored_R2D_upper=str(B),premise='Bank-specific lower variance from source dss/previous coefficient; must be coupled to raw factor metric'))
weightedmax=max(F(r['conditional_stored_R2D_upper']) for r in weighted)
beta=ceil(weightedmax);jcap=2*(F(3144192)+F(1,16384))**2;root_gain2=jcap/(18433**2)
candidate_energy=2*1536*beta # safe overestimate of two scalar errors/A2 and dimensional scale
candidate_mu2=root_gain2*candidate_energy
candidate_mu=isqrt(ceil(candidate_mu2))+1
out=dict(status='PARTIAL_RIGHT_BRANCH_BOUND_WITH_OPEN_ROOT_LEFT_TRANSFER',gamma=str(eps),zero_residual= '366+1/1048576',terminal_caps=dict(normal_residual=367,half=184,returned_r0=552),
 coarse_right=coarse,refined_right=refined,binary_L_refinement=dict(bound='1+2^-40',proof='TOWER positive actual H=[[h,conj(c)],[c,h]], |c|<h; component div error norm<=2U'),
 right_active_calls=1536,right_numeric_abs_bound=refined['mu_cap'],right_NumericCenter_lower_margin=2147483283-refined['mu_cap'],right_NumericCenter_upper_margin=2147483282-refined['mu_cap'],
 full_root_loose_route=dict(root_L=33554432,root_updated_target_cap=root_update,full_mu_majorant=full_independent['mu_cap'],closed=False,classification='loose-bound failure, not C or emitted counterexample'),
 strongest_initial_coefficient_abs_bound=str(coeff),weighted_candidate=dict(bank_records=weighted,conditional_max_R2D=beta,root_gain_squared=str(root_gain2),conditional_energy_budget=candidate_energy,
  conditional_root_correction_cap=candidate_mu,conditional_numeric_margin=2147483282-candidate_mu-5000000,
  ideal_scale_diagnostic_only=True,source_energy_comparison_proved=False,source_root_gain_perturbation_bound_proved=False,raw_L_equal_stable_L_assumed=False,
  missing_type='Uniform source ordered-residual energy/frame defect bound relative to the actual raw factorization and source stable D weights, including Split1/Merge1 and repeated rounded cancellation; plus transport to every left-subtree center'),
 scalar_support=supports,finite_prefix_not_termination=True,global_mu_numeric_proved=False)
(W/'artifacts/bounds.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['coarse_right','refined_right']},indent=2))
