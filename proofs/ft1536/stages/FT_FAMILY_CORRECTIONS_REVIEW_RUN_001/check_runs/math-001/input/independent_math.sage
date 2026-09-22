# Independent S01 mathematics. Run: sage sage_checks/independent_math.sage
# No author checker is imported. Reads only pinned certificates/source as data.
assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024

import json
import os
from pathlib import Path
from sage.env import SAGE_VERSION

W = Path(os.environ['FT_REVIEW_W'])
O = Path(os.environ['FT_REVIEW_OUTPUT'])
S = W / 'inputs/subject'
out = {'sage_version': SAGE_VERSION, 'mode': 'sage lemma.sage with preparser'}

def decq(text):
    text = str(text).strip().lower()
    mant, sep, exponent = text.partition('e')
    exponent = ZZ(exponent) if sep else ZZ(0)
    sign = -1 if mant.startswith('-') else 1
    mant = mant.lstrip('+-')
    left, dot, right = mant.partition('.')
    return sign * QQ(ZZ((left or '0') + right)) / 10^len(right) * 10^exponent

# R5: independent rational recurrence, followed by a 1024-bit MPFI enclosure.
# This uses interval endpoints rather than the author's Arb midpoint/radius route.
N = ZZ(1536)
sigma = ZZ(768)
B = floor((43/40)^2 * 2*N*sigma^2)
x = QQ(B)/(2*sigma^2)
assert B == 2093922385 and x == QQ(2093922385)/1179648
term = QQ(1)
series = QQ(1)
for k in range(1, N):
    term = term*x/k
    series += term
I = RealIntervalField(1024)
tail = (-I(x)).exp()*I(series)
lo = tail.lower().exact_rational()
hi = tail.upper().exact_rational()
assert QQ(1)/2^40 < lo <= hi < QQ(1)/2^28
author = json.loads((S/'results/chi_tail.json').read_text())
stored_lo = decq(author['tail_interval']['lo_decimal_50'])
stored_hi = decq(author['tail_interval']['hi_decimal_50'])
assert stored_lo <= lo <= hi <= stored_hi
assert QQ(1)/2^40 < stored_lo < stored_hi < QQ(1)/2^28

# Assess the precision actually supported by the sealed author's 256-bit code.
A = RealBallField(256)
ex = A(-x).exp()
author_lo = (QQ(ex.mid())-2*QQ(ex.rad()))*series
author_hi = (QQ(ex.mid())+2*QQ(ex.rad()))*series
author_radius = (author_hi-author_lo)/2
claimed_radius = QQ(1)/10^305
assert author_radius > claimed_radius
assert (hi-lo)/2 < claimed_radius
out['R5'] = {
    'x_exact': str(x), 'B': int(B), 'method': 'exact QQ recurrence + MPFI1024 exp/interval endpoints',
    'sum_numerator_bits': int(series.numerator().nbits()),
    'sum_denominator_bits': int(series.denominator().nbits()),
    'tail_interval': str(tail), 'lower_exact': str(lo), 'upper_exact': str(hi),
    'gt_2pow_neg40': bool(lo > 1/2^40), 'lt_2pow_neg28': bool(hi < 1/2^28),
    'author_decimal_enclosure_contains_independent_interval': True,
    'author_stored_decimal_width': str(stored_hi-stored_lo),
    'author_arb256_radius_display': str(I(author_radius)),
    'author_radius_gt_1e_minus305': bool(author_radius > claimed_radius),
    'independent_1024_radius_lt_1e_minus305': bool((hi-lo)/2 < claimed_radius),
    'author_QQ_mid_is_exact_binary': bool(QQ(ex.mid()) == ex.mid().exact_rational()),
    'author_QQ_rad_is_exact_binary': bool(QQ(ex.rad()) == ex.rad().exact_rational()),
    'scope': 'ideal continuous chi-square model; not actual Sign law or security',
}

# R2: free-target control for arbitrary h; repeated events retain equal marginals.
q = ZZ(7)
free_wins = sum(1 for h in range(q) if (0+h*0-0) % q == 0)
rom_wins = sum(1 for h in range(q) for c in range(q) if (0+h*0-c) % q == 0)
assert QQ(free_wins)/q == 1 and QQ(rom_wins)/q^2 == 1/q
atoms = [0,1]
p = QQ(sum(1 for a in atoms if a == 0))/len(atoms)
u = QQ(sum(1 for a in atoms if (a == 0 or a == 0)))/len(atoms)
assert p == u == 1/2 and 1-(1-p)^2 == 3/4
out['R2'] = {'toy_q': int(q), 'free_target': '1', 'ROM_zero_witness': str(1/q),
             'repeated_event_union': str(u), 'independence_formula': str(1-(1-p)^2),
             'repeated_events_have_identical_marginals': True,
             'actual_Rq_zero_target_probability': 'q^(-N), not the one-dimensional toy 1/q'}

# R1: independently execute the actual N3 toy semantics, retaining SeenSign.
# This exhibits the scope limitation of N3, not a real-scheme forgery/attack.
def metric(a,b):
    return a^2+a*b+b^2

def find_toy(c):
    for b in range(97):
        a = (c-5*b) % 97
        if metric(a,b) < 50:
            return ZZ(a),ZZ(b)
    raise AssertionError('no toy witness')

seen_sign = set()
def toy_sign(message):
    seen_sign.add(message)
    return (ZZ(31),)+find_toy(ZZ(31))

message = 'm*'
c,a,b = toy_sign(message)
accepted = (a+5*b-c) % 97 == 0 and metric(a,b) < 50
fresh = message not in seen_sign
first_solver = (ZZ(0),)+find_toy(ZZ(12))
extracted_with_index = (ZZ(1),a,b)
assert accepted and not fresh
assert first_solver != extracted_with_index
out['R1_N3_scope'] = {
    'accepted_witness': [int(a),int(b)], 'Q': int(metric(a,b)),
    'message_in_SeenSign': True, 'EUF_CMA_win': bool(accepted and fresh),
    'separate_solver_first_output': [int(v) for v in first_solver],
    'actual_extraction_output_with_target_index': [int(v) for v in extracted_with_index],
    'standalone_solver_output_is_not_the_composition_output': True,
    'conclusion': 'N3 checks acceptance/witness postconditions, not a fresh forgery or simulation-free MT reduction',
}

# C1-C4: prime/root checks and NEWTON sums, independently of author Ramanujan.
R = PolynomialRing(ZZ,'X')
X = R.gen()
assert ZZ(18433).is_prime(proof=True)
field = GF(18433)
geometry = []
for n,root in [(768,3532),(1536,625),(3072,25)]:
    n = ZZ(n)
    polynomial = R(cyclotomic_polynomial(3*n))
    assert polynomial == X^n-X^(n//2)+1
    coeff = {int(n-k):v for k,v in polynomial.dict().items() if k != n}
    powers = [ZZ(n)]
    for k in range(1,n):
        value = -ZZ(k)*coeff.get(k,ZZ(0))
        for j,cj in coeff.items():
            if 0 < j < k:
                value -= cj*powers[k-j]
        powers.append(value)
    assert all(powers[k] == (n/2 if k == n/2 else 0) for k in range(1,n))
    assert field(root).multiplicative_order() == 3*n
    assert field(root)^n-field(root)^(n//2)+1 == 0
    geometry.append({'N': int(n), 'cyclotomic_identity': True,
                     'newton_trace_support': [0,int(n//2)],
                     'p0': int(powers[0]), 'p_half': int(powers[n//2]),
                     'primitive_root_order': int(3*n)})
G = matrix(QQ,[[1,1/2],[1/2,1]])
assert G.det() == 3/4
assert sorted(G.eigenvalues()) == [1/2,3/2]
out['geometry'] = {'q_prime': True, 'instances': geometry,
                   'A2_gram_det': str(G.det()), 'A2_eigenvalues': ['1/2','3/2'],
                   'full_2N_gram_det': '(3/4)^N', 'volume_scale': '(3/4)^(N/2)'}

# R7: closed forms are an independent consumer of the source-derived recurrences.
layout = json.loads((S/'results/layout.json').read_text())
by_n = {ZZ(row['N']):row for row in layout['rows']}
checks = []
for n,ell in [(768,9),(1536,10),(3072,11)]:
    n,ell = ZZ(n),ZZ(ell)
    tree = (ell+2)*n
    expanded = (ell+6)*n
    scratch = 7*2^(ell-1)
    high_water = 3*n+scratch
    row = by_n[n]
    assert ZZ(row['ffldl_scratch_from_gxx']) == scratch
    assert ZZ(row['scratch_high_water']) == high_water
    checks.append({'N': int(n), 'tree': int(tree), 'expanded': int(expanded),
                   'scratch': int(scratch), 'high_water': int(high_water)})
assert checks[-1]['high_water'] == 16384
out['R7'] = {'rows': checks, 'wrong_15360_rejected': True,
             'scope': 'algebraic/source layout model, not a compiler/C allocator theorem'}

O.mkdir(parents=True,exist_ok=True)
with (O/'independent_math.json').open('w') as f:
    json.dump(out,f,indent=2,sort_keys=True)
    f.write('\n')
print('PASS_INDEPENDENT_MATH_CHECKS_WITH_SCOPE_FINDINGS')
print('R5 interval:',tail)
print('Author Arb256 radius:',I(author_radius))
print('Author N3 fresh EUF-CMA win:',bool(accepted and fresh))
