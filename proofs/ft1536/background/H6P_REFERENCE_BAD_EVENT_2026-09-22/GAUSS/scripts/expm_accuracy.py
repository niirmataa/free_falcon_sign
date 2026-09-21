"""Exact QQ Bernstein + Taylor certificate on the ACTUAL nonnegative rB domain."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,PolynomialRing,RealBallField,binomial,factorial
from kernel_model import constants
from dyadic import value
from replaylib import sha
W=Path.cwd();dom=json.loads((W/'REDUCTION_DOMAIN.json').read_text());assert not dom['negative_remainder_buckets']
RB=RealBallField(384);ring=PolynomialRing(QQ,'t');t=ring.gen();R=QQ(dom['global_rB_upper']);assert R<QQ(7)/10
C=constants(W)[2];P=sum(QQ(C[12-i])/2**63*(-t)**i for i in range(13));T=sum((-t)**i/factorial(i) for i in range(25));D=P-T;n=24
def up(x,bits=256):return QQ((QQ(x)*2**bits).ceil())/2**bits
def powup(x):
 p=QQ(1)
 while p/2>=x:p/=2
 return p
cells=[];maxerr=QQ(0)
for k in range(256):
 lo=R*k/256;hi=R*(k+1)/256;coef=D(lo+(hi-lo)*t).list();coef +=[QQ(0)]*(n+1-len(coef))
 bern=[sum(coef[j]*binomial(i,j)/binomial(n,j) for j in range(i+1)) for i in range(n+1)]
 b=up(max(abs(x) for x in bern));maxerr=max(maxerr,b);cells.append(dict(index=k,lo=str(lo),hi=str(hi),Bernstein_min=str(-up(-min(bern))),Bernstein_max=str(up(max(bern))),abs_bound=str(b)))
taylor=R**25/factorial(25);poly=up(maxerr+taylor);horner=up(sum(R**i for i in range(12))/2**63);theta=QQ(1)/2**63
expm=poly+horner+theta;count=expm+QQ(1)/2**55
ln=RB(2).log();red=[]
for row in dom['buckets']:
 v=value(int(row['source_e_log2'],16));ce=QQ(v.numerator)/v.denominator;err=abs(RB(ce)-row['e']*ln);red.append(up(QQ(err.upper())+QQ(1)/2**1022))
redmax=max(red);beta=up(QQ((RB(count)*(RB(R)+RB(redmax)).exp()+RB(redmax).exp()-1).upper()))
assert beta<QQ(1)/2**40
out=dict(schema='GAUSSIAN_SOURCE_EXPM_ACCURACY_V1',game='IID_BUFFER',status='PASS_WHOLE_ACTUAL_DOMAIN_QQ_BERNSTEIN_TAYLOR',domain=dict(rB_lower='0',rB_upper=str(R),literal_log2_exceeded=True,negative_remainder_on_certified_BerExp_x_domain=False,theta='trunc(mul_C(rB,2^63))/2^63 in[0,rB], power-of-two scaling exact for nonzero normal source remainder',outside_negative_not_covered=True),coefficients=list(map(str,C)),polynomial_definition='P(t)=sum_i=0^12 (-1)^i C[12-i] t^i /2^63',Bernstein_cells=cells,Taylor_degree=24,Taylor_remainder=str(up(taylor)),polynomial_abs_error=str(poly),polynomial_error_power2=str(powup(poly)),Horner_integer_abs_error_scaled=str(horner),theta_quantization=str(theta),expm_scaled_by_2p63_abs_error=str(expm),threshold_floor_scaled_abs_error=str(count),source_reduction_real_log2_error=str(redmax),per_exponent_reduction_errors=list(map(str,red)),Beta_relative_error_noncutoff=str(beta),Beta_relative_error_power2=str(powup(beta)),Beta_scope='source x in[0,273], e<64: |Beta_C(x)/exp(-val(x))-1| <= error; e>=64 is forced zero and treated as tail',Z_strictly_positive=True,Z_upper=str(2**55),saturation_above_2p55_unreachable_for_literal_coefficients=True,source_high_product_reused=True,fully_kernelized=False,dependencies={'REDUCTION_DOMAIN.json':sha(W/'REDUCTION_DOMAIN.json'),'source/fpr-emulated.h':sha(W/'source/fpr-emulated.h')})
out['positive_trunc_refinement_scope']='val(v) in[0,2^63), ex<=1085; count0 endpoint newly discharged, extending IID v<2^62'
(W/'EXPM_ACCURACY.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],rB_max=str(R),poly_power2=out['polynomial_error_power2'],Beta_power2=out['Beta_relative_error_power2'],cells=len(cells),negative_scope=False),indent=2))
