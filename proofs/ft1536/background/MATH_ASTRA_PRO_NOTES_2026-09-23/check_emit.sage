# Preliminary exact check of the new cap/Emit proposal, not a kernel review.
# Run from this durable W: sage check_emit.sage
import json
from pathlib import Path
from sage.env import SAGE_VERSION

assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024

A = PolynomialRing(QQ, names=('p', 'b'))
F = A.fraction_field()
p, b = map(F, A.gens())
d = 1-p+p*b
second = (1-b)/p + b^2/d
assert second-1 == (1-p)^2*(1-b)/(p*d)
assert 1/p-second == b*(1-p)/(p*d)

def direct_second(j, k):
    assert sum(j) == 1 and sum(k) == 1
    assert all(x >= 0 for x in j+k)
    if any(a > 0 and c == 0 for a, c in zip(j, k)):
        return None  # genuine support mismatch, not real division by zero
    return sum((a^2/c for a, c in zip(j, k) if c != 0), QQ(0))

checks = []
for prob in (QQ(0), QQ(1)/4, QQ(1)/2, QQ(3)/4, QQ(1)):
    for abort in (QQ(0), QQ(1)/4, QQ(1)/2, QQ(3)/4, QQ(1)):
        law = [abort, (1-abort)/3, 2*(1-abort)/3]
        mix = [1-prob+prob*abort, prob*law[1], prob*law[2]]
        value = direct_second(law, mix)
        if prob == 0:
            assert (value == 1) if abort == 1 else (value is None)
        else:
            denom = 1-prob+prob*abort
            if denom == 0:
                assert prob == 1 and abort == 0 and value == 1
            else:
                exact = (1-abort)/prob + abort^2/denom
                assert value == exact and value <= 1/prob
        checks.append({'pi': str(prob), 'b': str(abort),
                       'second': 'infinity' if value is None else str(value)})

q, threshold = ZZ(18433), ZZ(2093922385)
z1, z2 = (ZZ(9217), ZZ(-5000)), (ZZ(32767), ZZ(18000))
def block(v):
    a, b = v
    return a^2+a*b+b^2
def center(a):
    return (a+q//2) % q - q//2
before = block(z1)+block(z2)
centered = tuple(center(x) for x in z1)
after = block(centered)+block(z2)
assert before == 2051350378 and after == 2143496945
assert before < threshold < after
assert all(-65535 <= x <= 65535 for x in z1+z2)
assert all(-32768 <= x <= 32767 for x in z2)
assert all((a-c) % q == 0 for a, c in zip(z1, centered))

report = {'result': 'PASS_PRELIMINARY_SAGE_CHECK',
          'sage_version': SAGE_VERSION,
          'mode': 'sage check_emit.sage, standard preparser, ZZ/QQ',
          'rational_function_identities': int(2),
          'finite_mixture_checks': len(checks), 'checks': checks,
          'counterexample': {'before': str(before), 'after': str(after),
                            'B': str(threshold), 'centered_z1': [str(x) for x in centered],
                            'in_box': True, 'z2_signed16': True},
          'scope': 'Exact arithmetic and rational-function identities. Positivity of Gaussian mass '
                   'is assessed from the existing model definitions; no probability magnitude '
                   'estimate or new Lean theorem is produced. Not independent acceptance of T12.1.'}
Path('CHECKS.json').write_text(json.dumps(report, indent=2)+'\n')
print(json.dumps(report, indent=2))
