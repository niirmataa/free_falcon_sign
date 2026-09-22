# REVIEW independent checker 2/3 -- ring/congruence on a FRESH instance.
# Run: sage sage_checks/review_ring_independent.sage
# Fresh LCG seed (different from author's 20260922): builds one synthetic key
# with det=q exactly, one random (a,b,c), verifies in exact ZZ/QQ arithmetic:
# det identity, h relations, ring identity (*), congruence v1+h*v2=c mod (q,Phi),
# target row identities. Independent of author's fixtures (MT vs LCG noted).

# preparser/toolchain preflight (POLICY 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1 / 3) is QQ
assert 2 ^ 10 == 1024

import json
from sage.all import PolynomialRing, ZZ, QQ, GF

N = 1536
Q = 18433
RZ = PolynomialRing(ZZ, 'x')
x = RZ.gen()
PHI = x ** N - x ** (N // 2) + 1
RF = PolynomialRing(GF(Q), 'z')
z = RF.gen()
PHIF = z ** N - z ** (N // 2) + 1

def red(p):
    return RZ(p) % PHI

def mulR(a, b):
    return red(RZ(a) * RZ(b))

def toF(p):
    return RF(p) % PHIF

class LCG:
    def __init__(self, seed):
        self.s = seed % (2 ** 64)
    def next(self):
        self.s = (6364136223846793005 * self.s + 1442695040888963407) % (2 ** 64)
        return self.s >> 11
    def randint(self, lo, hi):
        return lo + self.next() % (hi - lo + 1)

rng = LCG(987654321)
jj = [rng.randint(-1, 1) for _ in range(N)]
if all(v == 0 for v in jj):
    jj[1] = 1
j = RZ(sum([ZZ(jj[i]) * x ** i for i in range(N)]))
Xj = red(x * j)
f = red(1 + Xj)
g = Xj
Fp = red((Q - 1) - Xj)
G = red(Q - Xj)

checks = {}
checks["C1_det_identity"] = bool(red(f * G - g * Fp) == RZ(Q))
finv = RF(f).inverse_mod(PHIF)
h = (toF(g) * finv) % PHIF
checks["C5_hf_eq_g"] = bool(h * toF(f) % PHIF == toF(g))
checks["C5_hF_eq_G"] = bool(h * toF(Fp) % PHIF == toF(G))

Y = [ZZ(rng.randint(-(2 ** 30), 2 ** 30)) for _ in range(N)]
sA = [ZZ(1 if rng.randint(0, 1) else -1) for _ in range(N)]
sB = [ZZ(1 if rng.randint(0, 1) else -1) for _ in range(N)]
a = red(sum([sA[i] * Y[i] * x ** i for i in range(N)]))
b = red(sum([sB[i] * Y[i] * x ** i for i in range(N)]))
c = RZ(sum([ZZ(rng.randint(0, Q - 1)) * x ** i for i in range(N)]))
v1 = red(c - (mulR(a, g) + mulR(b, G)))
v2 = red(mulR(a, f) + mulR(b, Fp))
checks["A_integrality"] = bool(v1.parent() == RZ and v2.parent() == RZ)
hlist = h.list()
hZ = RZ([ZZ(hlist[i]) if i < len(hlist) else ZZ(0) for i in range(N)])
left = red(v1 + mulR(hZ, v2) - c)
right = red(mulR(a, red(hZ * f - g)) + mulR(b, red(hZ * Fp - G)))
checks["C4_ring_identity"] = bool(left == right)
checks["C3_congruence"] = bool((toF(v1) + h * toF(v2) - toF(c)) % PHIF == RF(0))
e1 = red(-mulR(mulR(c, Fp), g) + mulR(mulR(c, f), G))
e2 = red(-mulR(mulR(c, Fp), f) + mulR(mulR(c, f), Fp))
checks["C2_target_row0"] = bool(e1 == red(Q * c))
checks["C2_target_row1"] = bool(e2 == RZ(0))

assert all(checks.values()), checks
out = {"checker": "review_ring_independent.sage", "fresh_lcg_seed": int(987654321),
       "checks": {k: bool(v) for k, v in checks.items()}, "all_pass": True}
with open("/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001/sage_checks/review_ring_independent.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)
print(json.dumps(out, indent=1, sort_keys=True))
print("REVIEW_RING_INDEPENDENT_PASS")
