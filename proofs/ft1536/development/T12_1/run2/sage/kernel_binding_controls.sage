# Exact controls and input anchors for the new algebra/gate kernel proofs.
# Synthetic words and spectra only; no KeyGen or signing invocation.
from pathlib import Path
import hashlib, json, re, sys
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
assert len(sys.argv) == 3
source = Path(sys.argv[1])
pin = sys.argv[2]
assert hashlib.sha256(source.read_bytes()).hexdigest() == pin
text = source.read_text()
lo = ZZ(re.search(r'#define FT1536_LEAF_MIN_BITS\s+UINT64_C\((0x[0-9A-Fa-f]+)\)', text).group(1))
hi = ZZ(re.search(r'#define FT1536_LEAF_MAX_BITS\s+UINT64_C\((0x[0-9A-Fa-f]+)\)', text).group(1))
assert lo == ZZ(0x4090000053700377) and hi == ZZ(0x4114444d1a037d50)
M = 2^64
def positive(w):
    return (w >> 63) == 0 and ((w >> 52) & 0x7ff) != 0x7ff and ((w << 1) % M) != 0
def gate(w):
    return (1 ^^ (((w-lo) % M) >> 63)) & (1 ^^ (((hi-w) % M) >> 63))
def value(w):
    e = (w >> 52) & 0x7ff
    m = w % 2^52
    assert 0 < e < 0x7ff and w < 2^63
    return QQ(2^52+m)*QQ(2)^(e-1075)
words = sorted(set([0, 1, 2^63, lo-1, lo, lo+1, hi-1, hi, hi+1,
                    ZZ(0x7ff0000000000000), ZZ(0x7ff0000000000001), M-1]))
controls = []
for w in words:
    accepted = positive(w) and gate(w) == 1
    assert accepted == (lo <= w <= hi)
    if accepted:
        assert value(w) >= 1024
    controls.append(dict(word_hex=hex(w), positive=bool(positive(w)), gate=int(gate(w)),
                         accepted=bool(accepted)))
assert value(lo) == QQ(4503601027220343)/4398046511104

P = PolynomialRing(QQ, names=('f','g','F','G','u','v'))
f,g,F,G,u,v = P.gens()
b0 = g*u+G*v
b1 = -f*u-F*v
assert -F*b0-G*b1 == (f*G-g*F)*u
assert f*b0+g*b1 == (f*G-g*F)*v

def binary(n, xs):
    assert len(xs) == 2^n
    if n == 0:
        return xs
    avg = [(xs[j]+xs[j+1])/2 for j in range(0,len(xs),2)]
    harmonic = [2*xs[j]*xs[j+1]/(xs[j]+xs[j+1]) for j in range(0,len(xs),2)]
    return binary(n-1,avg)+binary(n-1,harmonic)
def primary(xs):
    assert len(xs) == 768
    branches = [[],[],[]]
    for j in range(0,768,3):
        a,b,c = xs[j:j+3]
        e1,e2 = a+b+c,a*b+a*c+b*c
        for branch, val in zip(branches,[e1/3,e2/e1,3*a*b*c/e2]):
            branch.append(val)
    return sum([binary(8,branch) for branch in branches],[])
q2 = ZZ(18433)^2
roots = [QQ(2)+QQ(i)/1000 for i in range(768)]
leaves = primary(roots)
assert len(leaves) == 768 and all(x>0 for x in leaves)
assert primary([q2/x for x in roots]) == [q2/x for x in reversed(leaves)]
full = leaves+[q2/x for x in reversed(leaves)]
assert len(full) == 1536 and [q2/x for x in full] == list(reversed(full))

result = dict(schema='FT1536_KERNEL_BINDING_CONTROLS_V1',
    keygen_source_sha256=pin, leaf_min_word=hex(lo), leaf_max_word=hex(hi),
    minimum_value_exact=str(value(lo)), lower_value_bound=str(ZZ(1024)),
    word_boundary_controls=controls, ntru_polynomial_recovery_identities=True,
    synthetic_spectrum_length=int(len(roots)), primary_length=int(len(leaves)), full_length=int(len(full)),
    reciprocal_order_control=True,
    all_inputs_public_and_synthetic=True, actual_keygen_executed=False,
    all_key_probability_bound_proved=False,
    scope='Exact controls and byte anchors; universal algebra/gate results are separate Lean proofs; '
          'source KeyGen execution/FFT and radial mass bindings remain open')
Path('kernel_binding_controls.json').write_text(json.dumps(result, indent=int(2), sort_keys=True)+'\n')
print('KERNEL_BINDING_CONTROLS_PASS; source execution and final probability proof remain open')
