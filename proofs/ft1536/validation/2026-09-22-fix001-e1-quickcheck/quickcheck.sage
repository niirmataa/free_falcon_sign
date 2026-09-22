# Independent bounded quick check; run with: sage quickcheck.sage
# Inputs are read-only snapshots, not a resumed author job.
import json
import os
from pathlib import Path
from sage.env import SAGE_VERSION

assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
w = Path(os.environ['QUICKCHECK_W'])
rows = json.loads((w/'inputs/subfield_normdown_v2.json').read_text())['rows']
tail = json.loads((w/'inputs/chi_tail.json').read_text())

# Independent QQ recurrence and MPFI768, rather than the author's common
# denominator accumulation + Arb256 certificate production.
x = QQ(2093922385)/1179648
term = QQ(1)
total = term
for k in range(1, 1536):
    term *= x/k
    total += term
I = RealIntervalField(768)
t = (-I(x)).exp()*I(total)
def exact_decimal(text):
    whole, fractional = text.split('.')
    return QQ(ZZ(whole+fractional))/10^len(fractional)
lo = exact_decimal(tail['tail_interval']['lo_decimal_100'])
hi = exact_decimal(tail['tail_interval']['hi_decimal_100'])
assert lo <= t.lower().exact_rational() <= t.upper().exact_rational() <= hi
assert 1/2^40 < lo < hi < 1/2^28

# The old QQ(mid/rad) margin did enclose this particular Arb ball; lack of
# an exact-conversion guarantee is not evidence of a failed numeric bound.
A = RealBallField(256)
e = A(-x).exp()
em = e.mid().exact_rational()
er = e.rad().exact_rational()
old_lo = QQ(e.mid()) - 2*QQ(e.rad())
old_hi = QQ(e.mid()) + 2*QQ(e.rad())
assert old_lo <= em-er <= em+er <= old_hi

# Independent MPFI interval classification of EVERY candidate beta in the
# declared search range. Unlike `if lhs.lower()>rhs.upper(): ...`, distinguish
# certified noncrossing from an unresolved overlap. Exact moment formulae
# and the norm-lift model themselves are outside this quick numeric check.
J = RealIntervalField(256)
def crossing(n, variance, cap):
    positive = []
    negative = 0
    for beta in range(100, cap+1):
        b = J(beta)
        gap = (1-J(n)/b)*(b/(2*J.pi()*J(1).exp())).log() \
              + J(18433).log()/2 - (3*b/4).log()/2 - J(variance).log()/2
        if gap.lower() > 0:
            positive.append(beta)
        elif gap.upper() < 0:
            negative += 1
        else:
            raise AssertionError(('UNRESOLVED_INTERVAL', n, variance, beta))
    return (positive[0] if positive else None), negative

full = {}
for n in (768, 1536, 3072):
    full[n] = crossing(n, QQ(2)/3, 2*n)[0]
checks = []
for row in rows:
    n = ZZ(row['N'])
    degree = ZZ(row['subfield_degree_n'])
    dim = ZZ(row['subfield_lattice_dimension'])
    assert degree == n/2 and dim == 2*degree == n
    raw = QQ(row['E_QA2_raw_exact'])
    mean = QQ(row['E_QA2_mean_part_exact'])
    centered = raw-mean
    assert centered >= 0 and centered == QQ(row['E_QA2_centered_var_exact'])
    variance = QQ(row['sigma_sq_subfield_exact'])
    assert variance == raw/degree
    beta, negatives = crossing(degree, variance, dim)
    assert beta == row['beta_subfield_eq23']
    assert full[n] == row['beta_full_dimension']
    if beta is not None:
        assert full[n] < beta <= dim
    checks.append({'N': int(n), 'u': row['u'], 'beta_full': full[n],
                   'beta_sub': beta, 'certified_negative_candidates': negatives,
                   'status': 'FINITE_CROSSING' if beta is not None
                             else 'NO_CROSSING_IN_100_TO_DIM'})
assert len(checks) == 21
out = {
    'result': 'PASS_BOUNDED_NUMERIC_QUICKCHECK', 'mode': 'sage quickcheck.sage',
    'sage_version': SAGE_VERSION,
    'S01_tail': {'independent_interval': str(t), 'author_endpoints_enclose': True,
                'gt_2pow_neg40': True, 'lt_2pow_neg28': True,
                'old_2rad_margin_encloses_this_ball': True,
                'new_certificate_half_width': str(I(2*er*total))},
    'E1_rows': checks, 'E1_finite': sum(r['beta_sub'] is not None for r in checks),
    'E1_no_crossing': sum(r['beta_sub'] is None for r in checks),
    'E1_ambiguous_interval_comparisons': 0,
    'scope': 'Numeric corrections only. E1 consumes supplied exact moments; '
             'does not prove moment formulae, geometry, lift or security. '
             'Not a full S01 fresh replay or final acceptance.'}
(w/'NUMERIC_CHECKS.json').write_text(json.dumps(out, indent=2, default=int)+'\n')
print(json.dumps(out, indent=2, default=int))
