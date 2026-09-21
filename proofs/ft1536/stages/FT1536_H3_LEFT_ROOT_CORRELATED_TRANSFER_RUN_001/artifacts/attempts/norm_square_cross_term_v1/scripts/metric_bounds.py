"""Fresh relative split/factor defects, pivot transport and raw/stable metric comparison."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';U=QQ(1)/2**48;eta=QQ(1)/2**900;g=QQ(1)/2**40
t=json.loads((I/'TOWER/artifacts/numeric_certificate.json').read_text());root=json.loads((I/'ROOT/artifacts/numeric_certificate.json').read_text());d=root['derived']
amax=QQ(d['ahatmax']);jmax=QQ(d['jhatmax']);deterr=QQ(d['det_error']);q=QQ(18433);root_round=QQ(d['schur_round']);gramgamma=8*U
ratio_low=((q-deterr)/q)**2*(1-gramgamma)-root_round*(1+gramgamma)*amax/q**2
ratio_hi=((q+deterr)/q)**2*(1+gramgamma)+root_round*(1+gramgamma)*amax/q**2
relative_schur=256*U*jmax*amax/(q-deterr)**2
gain2=(1+32*U)**2*jmax/((q-deterr)**2*(1-relative_schur))
assert 0<ratio_low<1<ratio_hi and relative_schur<1 and gain2>0
# Direct reconstruction errors, rather than the loose source-to-ideal L21 error.
# Normalize by h, use |b|,|c|<=h, |L10/20|<2, |L21|<4, d1/h<=1+64U.
d1cap=1+64*U;ellerr=2*U
off21=64*U+U*(4+64*U)+eta*128+5*U
normerr=2*U*16+128*eta
tmp_err=(1+U)*normerr*d1cap+U*16*d1cap+eta*128
p20err=12*U+128*eta
q2err=p20err+U*(2+2+p20err)+eta*128
d2err=q2err+tmp_err+U*(4+q2err+16*d1cap+tmp_err)+eta*128+4*U
assert off21<128*U and d2err<512*U
assert 64*U+(4*U+4*U*U)+2*U<128*U
local=[];layers=[]
for b in [0,1]:
 m=QQ(1)/2 if b==0 else QQ(32);M=QQ(2**(23 if b==0 else 31));im=QQ(b);delta=QQ(1)/8192 if b==0 else QQ(1)/16
 rho=3*(im+delta)/m;lam=m-3*(im+delta);hmax=M+delta;ldl=2048*U*hmax/lam
 assert rho<1 and ldl<1
 layers.append(dict(branch=b,stage='cubic',split_relative=str(rho),ldl_relative=str(ldl),lower=str((1-rho)*(1-ldl)),upper=str((1+rho)*(1+ldl))))
 for level in range(8,0,-1):
  rs=[r for r in (t['level8_refined']+t['nodes']) if r['branch']==b and r['level']==level];expected=3*2**(8-level);assert len(rs)==expected
  lo=QQ(1);hi=QQ(1);maxrho=QQ(0);maxldl=QQ(0)
  for r in rs:
   p=r['input'];m=QQ(p['m']);im=QQ(p['I']);delta=QQ(r['delta']);hmax=QQ(r['denominator_upper'])
   rho=2*(im+delta)/m;lam=m-2*(im+delta);ldl=128*U*hmax/lam
   assert 0<=rho<1 and 0<ldl<1 and QQ(r['denominator_lower'])>QQ(1)/16
   a=(1-rho)*(1-ldl);z=(1+rho)*(1+ldl);lo=min(lo,a);hi=max(hi,z);maxrho=max(maxrho,rho);maxldl=max(maxldl,ldl)
   local.append(dict(branch=b,level=level,diagonal=r['diagonal'],path=r['path'],m=str(m),imag=str(im),split_error=str(delta),H_lower=str(lam),h_upper=str(hmax),split_relative=str(rho),factor_relative=str(ldl),lower=str(a),upper=str(z)))
  layers.append(dict(branch=b,stage='binary'+str(level),records=len(rs),split_relative=str(maxrho),ldl_relative=str(maxldl),lower=str(lo),upper=str(hi)))
products=[]
for b in [0,1]:
 lo=QQ(1);hi=QQ(1)
 for r in layers:
  if r['branch']==b:lo*=QQ(r['lower']);hi*=QQ(r['upper'])
 # Source stable primary differs from the exact positive pivots by <=(1±g)^9;
 # reciprocal adds source div factor(1±2U), with literal reverse order.
 stable_lo=(1-g)**9 if b==0 else (1-2*U)/(1+g)**9
 stable_hi=(1+g)**9 if b==0 else (1+2*U)/(1-g)**9
 leafraw_hi=hi*(1 if b==0 else ratio_hi)/stable_lo
 leafraw_lo=lo*(1 if b==0 else ratio_low)/stable_hi
 kappa=leafraw_hi/lo
 products.append(dict(branch=b,metric_raw_lower=str(lo),metric_raw_upper=str(hi),stable_relative_lower=str(stable_lo),stable_relative_upper=str(stable_hi),
  raw_leaf_over_stable_lower=str(leafraw_lo),raw_leaf_over_stable_upper=str(leafraw_hi),metric_to_stable_factor=str(kappa),metric_to_stable_integer_factor=int(ZZ(kappa.ceil()))))
assert len(local)==1530
out=dict(schema='FT1536_RAW_STABLE_METRIC_V1',status='NUMERIC_RELATIVE_FACTORS_VERIFIED',source_pin=sha(I/'CANDIDATE.sha256'),
 reference='Exact coefficient/A2 Gram of real source root spectrum, source-L exact reconstruction congruence with real raw pivots; then replace leaf weights by source stable D under derived pivot ratios',
 local_reconstruction=dict(binary_residual_opnorm='128*U*h',cubic_residual_opnorm='2048*U*h',new_direct_d22_normalized_error=str(d2err),new_cross21_normalized_error=str(off21)),
 root=dict(real_raw_D_over_q2_div_source_A_lower=str(ratio_low),real_raw_D_over_q2_div_source_A_upper=str(ratio_hi),rounded_basis_determinant_error=str(deterr),source_Schur_relative_error=str(relative_schur),
  source_root_gain_squared_upper=str(gain2),source_root_gain_squared_integer_upper=int(ZZ(gain2.ceil())),actual_j_upper=str(jmax)),
 layers=layers,local_records=local,products=products,raw_L_equal_stable_L_assumed=False,rounded_basis_determinant_equal_q_assumed=False,
 proof_dependencies={p:sha(I/p) for p in ['TOWER/artifacts/numeric_certificate.json','NODE3/ANALYTIC_PROOF.md','ROOT/ANALYTIC_PROOF.md','NORMALIZED/NORMALIZATION.md']})
(W/'artifacts/metric_bounds.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],root_gain_squared_integer=out['root']['source_root_gain_squared_integer_upper'],branches=[{k:r[k] for k in ['branch','metric_to_stable_integer_factor']} for r in products],root_D_ratio_float=[float(ratio_low),float(ratio_hi)]),indent=2))
