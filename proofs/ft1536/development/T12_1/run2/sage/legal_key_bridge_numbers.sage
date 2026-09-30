# Numeric parameters for the all-successful-key T5 route. These numbers do
# not replace the stated T5/source/theta proofs or the probability bindings.
from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ
R=RealBallField(512)
N=ZZ(1536);d=2*N;q=ZZ(18433);sigma=ZZ(768);B=ZZ(2093922385)
kappa=8*R.pi()^2*sigma^2/(3*q^2)
assert kappa*991 > 65*R(2).log()
y=QQ(1)/2^65
a=6*y/(1-y)^2
tau=(1+a)^1536-1
assert tau<QQ(1)/2^40
tr=R(tau);C=(1+tr)/(1-tr)
ratio=QQ(B)/(d*sigma^2)
chernoff=C*(R(ratio).log()*(d/2)+(d-R(B)/sigma^2)/2).exp()
box_tail=2*d*C*(-R(3)*65536^2/(8*sigma^2)).exp()
reject=chernoff/(1-box_tail)
lower_multiplier=(1-box_tail)/(1+tr)
upper_multiplier=(1+tr)/((1-tr)*(1-box_tail)*(1-reject))
assert reject<QQ(1)/2^24
result=dict(schema='FT1536_LEGAL_KEY_BRIDGE_NUMBERS_RESEARCH_V1',
    scope='uniform relative comparison prefactors, conditional on correctly bound T5 premises',
    kappa_times_991=str(kappa*991),tau_upper=str(tr),tau_log2=str(tr.log()/R(2).log()),
    uniform_norm_rejection_upper=str(reject),uniform_box_escape_log10=str(box_tail.log()/R(10).log()),
    raw_bad_to_sign_lower=str(lower_multiplier),raw_bad_to_sign_upper=str(upper_multiplier),
    relative_width=str(upper_multiplier-lower_multiplier),
    no_additional_key_filter=True,
    premises=['every successful existing KeyGen passes its mandatory leaf gate',
      'exact source-to-leaf floor >991','T5 dual theta bound for this metric and lattice',
      'Poisson pointwise all-center coset mass comparison','norm and coordinate MGF transport',
      'exact cap16 after-Emit relation from RUN_002'],
    full_new_kernel_binding_complete=False)
Path('legal_key_bridge_numbers.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('LEGAL_KEY_BRIDGE_NUMBERS',json.dumps(result,sort_keys=True))
