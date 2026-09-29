import json,re
from fractions import Fraction as F
from pathlib import Path
from dyadic import value
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';U=F(1,2**48);eta=F(1,2**900);h=(W/'source/fpr-emulated.h').read_text()
def constant(name):return int(re.search(r'static const fpr '+name+r' = 0x([0-9a-fA-F]+)ULL',h)[1],16)
ln=value(constant('fpr_log2'));inv=value(constant('fpr_inv_ln2'));norm=json.loads((I/'NORMALIZED/WIDTH_BOUNDS.json').read_text())
assert 0<ln<1 and 1<inv<F(3,2)
for n in ['stored','paired']:assert 0<F(norm[n]['dss_lower'])<F(norm[n]['dss_upper'])<1
x1=(1+U)*133225*2+eta;tail=(1+U)*((1+U)*730+eta+(1+U)+eta)+eta
x=(1+U)*(x1+(1+U)*tail+eta)+eta;scaled=(1+U)*x*inv+eta
assert x<2**19 and scaled<2**20
rbound=(1+U)*(x+(1+U)*2**20*ln+eta)+eta;assert rbound<2**21
assert (1+U)*rbound*2**63+eta<2**85<2**100
out=dict(status='PASS_SCALAR_CONDITIONAL_ARITHMETIC_ENVELOPES',premises=['current NumericCenter established independently','source normalized width class','legal typed context and defined byte reads'],
 supports=[29,59,118,235,365],k_squared=133225,two_k=730,r_and_delta=[0,1],gap_upper=2,dss_upper=1,x_upper='2^19',x_exact_bound=str(x),
 BerExp_scaled_upper='2^20',BerExp_s=[0,1048575],BerExp_r_abs_upper='2^21',expm_scaled_input_mul_upper='2^85',safe_s=[0,63],
 finite_each_iteration_arithmetic=True,rejection_termination=False,exp_probability_accuracy=False,current_NumericCenter_derived_by_this_certificate=False,
 sign_zero_argument='positive ordered normal dss/coefficient subtraction yields sign0 gap; ZERO gives sign0 r/delta; positive mul/add keep x sign0, so no -0 BerExp floor case',
 source_pin=sha(I/'CANDIDATE.sha256'),width_bounds_sha256=sha(I/'NORMALIZED/WIDTH_BOUNDS.json'))
(W/'artifacts/scalar_contract.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='x_exact_bound'},indent=2))
