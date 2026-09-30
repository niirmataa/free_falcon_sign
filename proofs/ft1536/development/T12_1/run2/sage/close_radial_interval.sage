# Interval closure for the actual finite-box reference law, then the
# all-successful-key T5 relative-mass/retry route. No RDF value is consumed.
from pathlib import Path
import sys,json,hashlib
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10==1024
assert len(sys.argv)==3
path=Path(sys.argv[1]);external_pin=sys.argv[2]
assert hashlib.sha256(path.read_bytes()).hexdigest()==external_pin
data=json.loads(path.read_text());assert data['mode']=='full'
R=RealBallField(512);C=ComplexBallField(512)
sig=ZZ(768);q=ZZ(18433);B=ZZ(2093922385);k=ZZ(1535);n=ZZ(768)
w=ZZ(data['bin_width']);period=w*2^ZZ(data['exponent']);cut=ZZ(data['cutoff'])
lo=R(QQ(data['lower_endpoint']));hi=R(QQ(data['upper_endpoint']))

def gaussian_box(sigma2):
    a=R(1)/(2*sigma2);tau=C(0,1)*C(a/R.pi())
    ts=C(0).jacobi_theta(tau);tt=C(0).jacobi_theta(3*tau)
    g=(ts[2]*tt[2]+ts[1]*tt[1]).real()
    L=ZZ(65536);beta=3*a/4;r=(-beta*(2*L+1)).exp()
    tail=4*(1+(2*R.pi()*sigma2).sqrt())*(-beta*L^2).exp()/(1-r)
    return g.add_error(tail)

G=gaussian_box(R(sig^2));t=(-R(1)/(2*sig^2)).exp()
shift=1+(2*R.pi()).sqrt()*sig
def coordinate_tail(L):
    beta=R(3)/(8*sig^2);r=(-beta*(2*L+1)).exp()
    return 2*shift/G*(-beta*L^2).exp()/(1-r)

# A2 integer norm n has at most10n representations: at most4n+1 possible
# first coordinates, and at most2 roots of the quadratic in the second.
tail_block=(10/G)*t^(cut+1)*((cut+1)/(1-t)+t/(1-t)^2)
changed_block=2*coordinate_tail(9217)
triangle_weight_total=n*changed_block
missing=triangle_weight_total*k*tail_block
multi=n*(n-1)*changed_block^2
emit_loss=1536*coordinate_tail(32768)

Qmin=floor(QQ(3)*9217^2/4)
Qcentermax=3*9216^2
lower_alias=B-Qmin-1-period+k*(w-1)
upper_alias=B-Qcentermax+period-k*(w-1)
assert 0<lower_alias<2*k*sig^2<upper_alias
def norm_chernoff(threshold):
    variance=QQ(threshold)/(2*k)
    tilt=(1-R(sig^2)/variance)/(2*sig^2)
    return (-tilt*threshold).exp()*(gaussian_box(R(variance))/G)^k
alias=triangle_weight_total*(norm_chernoff(lower_alias)+norm_chernoff(upper_alias))
raw_lower=lo-alias-multi-emit_loss
raw_upper=hi+missing+multi
assert raw_lower>0

# No good-key selection: these constants are supplied by the existing T5
# mandatory-gate theorem for EVERY successful output; binding listed below.
y=QQ(1)/2^65;tau=R((1+6*y/(1-y)^2)^1536-1)
dual_ratio=(1+tau)/(1-tau)
box_escape=6144*dual_ratio*(-R(3)*65536^2/(8*sig^2)).exp()
eps=4*(tau+box_escape)
ratio=QQ(B)/(3072*sig^2)
reject=dual_ratio*(1536*R(ratio).log()+(3072-R(B)/sig^2)/2).exp()/(1-box_escape)
assert eps<QQ(1)/2^38 and reject<QQ(1)/2^24
honest_lower=raw_lower/(1+eps)
honest_upper=raw_upper/((1-eps)*(1-reject))
l=honest_lower.lower().exact_rational();u=honest_upper.upper().exact_rational()
exponent=floor((R(l).log()/R(10).log()).lower())
assert exponent==floor((R(u).log()/R(10).log()).upper())
shared=[]
for digits in range(1,16):
    scale=QQ(10)^(digits-1-exponent)
    a=floor(l*scale+1/2);b=floor(u*scale+1/2)
    if a==b:
        s=str(a)
        shared.append(dict(digits=int(digits),mantissa=str(a),scale=str(digits-1-exponent),
            rounded=s[0]+('.'+s[1:] if len(s)>1 else '')+'e'+str(exponent)))
result=dict(schema='FT1536_CENTERING_INTERVAL_CLOSURE_V1',input_sha256=external_pin,
    raw_lower=str(raw_lower),raw_upper=str(raw_upper),
    corrections={name:str(value) for name,value in [('input_tail',missing),('aliases',alias),
        ('multiple_changes',multi),('signed16_emit',emit_loss),('theta',tau),('norm_reject',reject)]},
    honest_lower_rational=str(l),honest_upper_rational=str(u),
    honest_lower_display=str(honest_lower),honest_upper_display=str(honest_upper),
    common_roundings=shared,
    scope='all successfully emitted keys of the pinned FT1536 KeyGen via T5; finite-box G16 only',
    mathematical_bindings=['A2 exact representation enumeration and normalized Gaussian product',
        'interval DFT cyclic convolution','binning sandwich','alias Chernoff and truncation bounds',
        'four centering triangles; multiple changes and Emit correction',
        'T5 forall successful emitted keys; Poisson shifted coset normalization; cap16'],
    complete_new_kernel_source_binding=False,
    no_key_subset_discarded=True,not_a_claim_about_actual_C_Sign=True)
Path('centering_interval_closure.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('CENTERING_INTERVAL_CLOSURE',json.dumps(result,sort_keys=True),flush=True)
