"""Check all 12 supplied port cases against independent complex-ball polynomial evaluation."""
import importlib.util
import json
from pathlib import Path
import random
import struct
from sage.all import ComplexBallField, RealBallField, PolynomialRing

work = Path.cwd()
spec = importlib.util.spec_from_file_location('author_fft', work/'scripts/check_fft3_error.py')
author = importlib.util.module_from_spec(spec); spec.loader.exec_module(author)
C = ComplexBallField(256); R = RealBallField(256); polys = PolynomialRing(C, 'X')
square = author.load_fpr_table('fpr_gm3_square'); cubic = author.load_fpr_table('fpr_gm3_cubic')
def f(word): return struct.unpack('<d', struct.pack('<Q', word))[0]
w1r = f(0x3FE0000000000000); w1i = f(0x3FEBB67AE8584CAA)
w2 = complex(-w1r, w1i); w4 = complex(-w1r, -w1i)
rng = random.Random(20260921); rows = []
expected = json.loads((work/'results/fft3_error.json').read_text())
for N, ell in ((768, 9), (1536, 10), (3072, 11)):
    fixtures = {'ternary': [rng.randint(-1, 1) for _ in range(N)],
                'gaussian': [rng.gauss(0, 3) for _ in range(N)],
                'all_ones': [1.0]*N, 'alternating': [1.0 if i%2 == 0 else -1.0 for i in range(N)]}
    roots = author.slot_roots(ell, N)
    assert len(set(roots)) == N//2
    points = [C(0, 2*R.pi()*r/(3*N)).exp() for r in roots]
    for name, fixture in fixtures.items():
        inputs = list(map(float, fixture))
        got = author.fft3_full(inputs, ell, square, cubic, w1r, w1i, w2, w4)
        polynomial = polys([C(x) for x in inputs])
        exact_l1 = sum(abs(R(x)) for x in inputs)
        bound = 8*ell*(R(2)**(-53))*exact_l1
        mids = []
        for value, point in zip(got, points):
            error = abs(C(value.real, value.imag)-polynomial(point))
            assert error < bound, (N, name)
            mids.append(float(error.mid()))
        maximum = max(mids); old = expected['N'+str(N)][name]['max_error']
        # Author used 256-bit MPFR sums; independent Arb enclosures are much
        # narrower than one binary64 rounding step at the reported error.
        assert abs(maximum-old) <= max(abs(old)*1e-12, 1e-28), (N, name, maximum, old)
        rows.append(dict(N=N, case=name, slots=N//2, all_slot_ball_bounds_pass=True,
            max_error_midpoint=maximum, author_max_error=old,
            author_result_matches=True, reference='ComplexBallField(256) direct polynomial evaluation'))
print(json.dumps(dict(status='PASS_ALL_12_PORT_CONTROLS_INDEPENDENT_BALL_ORACLE', cases=rows,
    fully_source_bound_FPEMU=False, universal_error_theorem_proved=False), indent=2))
