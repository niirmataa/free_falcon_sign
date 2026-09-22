"""All 12 port cases against direct complex-ball sums with modular phase lookup."""
import importlib.util
import json
from pathlib import Path
import random
import struct
from sage.all import ComplexBallField, RealBallField, PolynomialRing

work = Path.cwd()
spec = importlib.util.spec_from_file_location('author_fft', work/'scripts/check_fft3_error.py')
author = importlib.util.module_from_spec(spec); spec.loader.exec_module(author)
C = ComplexBallField(256); R = RealBallField(256)
square = author.load_fpr_table('fpr_gm3_square'); cubic = author.load_fpr_table('fpr_gm3_cubic')
def f(word): return struct.unpack('<d', struct.pack('<Q', word))[0]
w1r = f(0x3FE0000000000000); w1i = f(0x3FEBB67AE8584CAA)
w2 = complex(-w1r, w1i); w4 = complex(-w1r, -w1i)
rng = random.Random(20260921); rows = []; wrapping = None
expected = json.loads((work/'results/fft3_error.json').read_text())
for N, ell in ((768, 9), (1536, 10), (3072, 11)):
    fixtures = {'ternary': [rng.randint(-1, 1) for _ in range(N)],
                'gaussian': [rng.gauss(0, 3) for _ in range(N)],
                'all_ones': [1.0]*N, 'alternating': [1.0 if i%2 == 0 else -1.0 for i in range(N)]}
    roots = author.slot_roots(ell, N); m = 3*N
    assert len(set(roots)) == N//2
    # Directly enclose each phase, instead of propagating rectangular balls
    # through thousands of Horner multiplications by the same uncertain root.
    unity = [C(0, 2*R.pi()*r/m).exp() for r in range(m)]
    for name, fixture in fixtures.items():
        inputs = list(map(float, fixture))
        got = author.fft3_full(inputs, ell, square, cubic, w1r, w1i, w2, w4)
        coefficients = [(i, C(x)) for i, x in enumerate(inputs) if x != 0]
        exact_l1 = sum(abs(R(x)) for x in inputs)
        bound = 8*ell*(R(2)**(-53))*exact_l1; mids = []
        for slot, (value, r) in enumerate(zip(got, roots)):
            if name in ('all_ones', 'alternating'):
                # Exact geometric-series identity; N is even and denominators
                # are nonzero for these primitive 3N-th roots.
                denominator = 1-unity[r] if name == 'all_ones' else 1+unity[r]
                reference = (1-unity[(r*N)%m])/denominator
            else:
                reference = sum((coefficient*unity[(r*i)%m] for i, coefficient in coefficients), C(0))
            error = abs(C(value.real, value.imag)-reference)
            assert error < bound, (N, name, slot, str(error), str(bound))
            mids.append(float(error.mid()))
            if N == 768 and name == 'ternary' and slot == 1:
                polynomial = PolynomialRing(C, 'X')([C(x) for x in inputs])
                horner = polynomial(unity[r])
                horner_error = abs(C(value.real, value.imag)-horner)
                wrapping = dict(N=N, case=name, slot=slot, direct_error=str(error),
                    horner_error_enclosure=str(horner_error), bound=str(bound),
                    direct_bound_certified=True, horner_bound_certified=bool(horner_error<bound),
                    classification='MAINTAINER_ORACLE_RECTANGULAR_INTERVAL_WRAPPING_NOT_AUTHOR_FAILURE')
        maximum = max(mids); old = expected['N'+str(N)][name]['max_error']
        assert abs(maximum-old) <= max(abs(old)*1e-12, 1e-28), (N, name, maximum, old)
        rows.append(dict(N=N, case=name, slots=N//2, all_slot_ball_bounds_pass=True,
            max_error_midpoint=maximum, author_max_error=old, author_result_matches=True,
            reference='ComplexBallField(256), direct modular-phase sum or exact geometric-series identity'))
print(json.dumps(dict(status='PASS_ALL_12_PORT_CONTROLS_INDEPENDENT_BALL_ORACLE', cases=rows,
    maintainer_failed_route=wrapping, fully_source_bound_FPEMU=False, universal_error_theorem_proved=False), indent=2))
