# Exact arithmetic and rigorous balls for the newly kernelized M6 margins.
# This does not certify the radial DFT computation or the source KeyGen bridge.
from pathlib import Path
import hashlib, json, sys
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
assert len(sys.argv) == 3
p = Path(sys.argv[1])
pin = sys.argv[2]
assert hashlib.sha256(p.read_bytes()).hexdigest() == pin
saved = json.loads(p.read_text())
R = RealBallField(512)

r = QQ(1)/2^65
block_majorant = 8*r/(1-r)^2
block_budget = QQ(1)/2^61
assert block_majorant <= block_budget
assert 1536*block_budget < 1
product_upper = 1/(1-1536*block_budget)-1
assert product_upper < QQ(1)/2^40
kappa = 8*R.pi()^2*768^2/(3*18433^2)
assert 991*kappa > 65*R(2).log()
scalar_ratio = QQ(1)/2^48
scalar_row_budget = QQ(1)/2^46
scalar_mass_budget = QQ(1)/2^34
max_scalar_coefficient = R(18433)^2/(991*2*R.pi()*768^2)
assert R.pi()/max_scalar_coefficient > 48*R(2).log()
assert 2*scalar_ratio/(1-scalar_ratio) <= scalar_row_budget
assert 3072*scalar_row_budget < scalar_mass_budget
assert 1/(1-3072*scalar_row_budget) <= 1+scalar_mass_budget

theta = QQ(1)/2^40
lower_factor = (1-theta)^2
upper_factor = 1+theta
eps = QQ(1)/2^36
assert (1-eps)*upper_factor <= lower_factor
assert upper_factor <= (1+eps)*lower_factor
assert upper_factor <= QQ(17)/16*lower_factor
reject = (-R(2093922385)/9437184).exp()*(R(17)/16)*(R(8)/7)^1536
assert reject < QQ(1)/2^24

raw_lo = QQ(1266068)/10^30
raw_hi = QQ(1267826)/10^30
assert raw_lo < QQ(saved['honest_lower_rational'])
assert QQ(saved['honest_upper_rational']) < raw_hi
lower = raw_lo/(1+eps)
upper = raw_hi/((1-eps)*(1-QQ(1)/2^24))
assert QQ(1265)/10^27 < lower < upper < QQ(1275)/10^27

result = dict(
    schema='FT1536_M6_KERNEL_MARGINS_V1', input_sha256=pin,
    a2_block_majorant=str(block_majorant), a2_block_budget=str(block_budget),
    a2_product_upper=str(product_upper), product_lt_2_minus_40=True,
    scalar_row_ratio=str(scalar_ratio), scalar_row_budget=str(scalar_row_budget),
    scalar_dimension=int(3072), scalar_mass_budget=str(scalar_mass_budget),
    scalar_upper_factor=str(1/(1-3072*scalar_row_budget)),
    scalar_reciprocal_exponent=str(R.pi()/max_scalar_coefficient),
    kappa_times_991=str(991*kappa), lower_normalizer_factor=str(lower_factor),
    upper_normalizer_factor=str(upper_factor), flatness_budget=str(eps),
    fixed_tilt_rejection_upper=str(reject), rejection_lt_2_minus_24=True,
    raw_lower_rational=str(raw_lo), raw_upper_rational=str(raw_hi),
    conditional_delta_lower_rational=str(lower), conditional_delta_upper_rational=str(upper),
    conditional_delta_lower_display=str(R(lower)), conditional_delta_upper_display=str(R(upper)),
    common_rounding='1.27e-24', significant_digits=int(3),
    all_key_kernel_source_binding_complete=False,
    radial_mass_kernel_certificate_complete=False,
    scope='Exact margins for proved Lean implications; no new unconditional all-KeyGen theorem')
Path('m6_kernel_margins.json').write_text(json.dumps(result, indent=int(2), sort_keys=True)+'\n')
print('M6_KERNEL_MARGINS_PASS; conditional rounding 1.27e-24; source/raw bindings open')
