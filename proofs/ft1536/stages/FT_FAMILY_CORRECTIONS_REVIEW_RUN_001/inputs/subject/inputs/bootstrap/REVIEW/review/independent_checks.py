"""Independent algebra/finite checks and a conditional ideal-Gaussian diagnostic."""
import json
import math
from pathlib import Path
from sage.all import ZZ, QQ, PolynomialRing, AbelianGroup, RealBallField, matrix, cyclotomic_polynomial

R = PolynomialRing(ZZ, 'X'); X = R.gen(); rows = []
assert ZZ(18433).is_prime(proof=True)
for N, root, oldroot, expected_groups in ((768, 3532, 8, 142), (1536, 625, 27, 164), (3072, 25, 13, 186)):
    phi = R(cyclotomic_polynomial(3*N))
    assert phi == X**N-X**(N//2)+1
    assert pow(root, 3*N, 18433) == 1 and all(pow(root, 3*N//p, 18433) != 1 for p in (2, 3))
    assert (pow(root, N, 18433)-pow(root, N//2, 18433)+1)%18433 == 0
    assert (pow(oldroot, N, 18433)-pow(oldroot, N//2, 18433)+1)%18433 == 3
    # Newton sums from the monic polynomial, independent of the author's
    # mobius/totient implementation of Ramanujan sums.
    coefficients = {j: phi[N-j] for j in range(1, N+1) if phi[N-j]}
    traces = [ZZ(N)]
    for r in range(1, N):
        traces.append(-r*coefficients.get(r, 0)-sum(a*traces[r-j] for j, a in coefficients.items() if j<r))
    assert all(v == (N if r == 0 else N//2 if r == N//2 else 0) for r, v in enumerate(traces))
    k = ZZ(3*N).valuation(2); group = AbelianGroup([2, 2**(k-2), 6]); subgroups = group.subgroups()
    assert len(subgroups) == expected_groups
    assert sum(H.order() == 2 for H in subgroups) == sum(H.order() == N//2 for H in subgroups) == 7
    rows.append(dict(N=N, primitive_root=root, exact_cyclotomic=True, newton_trace_coefficients_verified=N,
                     subgroups=len(subgroups), order2=7, index2=7))
pair = matrix(QQ, [[1, QQ(1)/2], [QQ(1)/2, 1]])
assert pair.det() == QQ(3)/4
F = RealBallField(256); N = 1536; sigma = 768; B = 2093922385
x = QQ(B)/(2*sigma*sigma)
# If Q/sigma^2 is chi-square(2N), its upper tail is this finite Poisson sum.
term = F(1); total = term
for k in range(1, N):
    term *= F(x)/k; total += term
tail = (-F(x)).exp()*total
assert tail > F(2)**(-40)
result = dict(status='PASS_INDEPENDENT_SCOPED_CHECKS', field_checks=rows,
    Gram_pair_det='3/4', pair_space_Gram_det='(3/4)^N', lattice_covolume='q^N*(3/4)^(N/2)',
    normalized_covolume_root='sqrt(q)*(3/4)^(1/4)',
    scratch_FT3072_high_water=3*3072+7168,
    ideal_chi_square_diagnostic=dict(scope='ONLY conditional ideal Q/sigma^2 ~ chi_square(3072), not source Sign law',
        x_exact=str(x), upper_tail_ball=str(tail), certified_greater_than_2_pow_neg40=bool(tail>F(2)**(-40))),
    P2_free_target_counterexample='For every h, adversarially chosen c=0 admits z1=z2=0 and Q=0<B; this is not a ROM forgery',
    reduction_direction='Accepted bytes -> extracted witness; witness hardness supports byte hardness only with matching games/simulation',
    source_security_proved=False)
print(json.dumps(result, indent=2))
