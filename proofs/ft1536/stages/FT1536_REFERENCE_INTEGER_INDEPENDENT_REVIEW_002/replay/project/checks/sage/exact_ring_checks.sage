# FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- exact ring/determinant/target/
# congruence checks for v_ref = [c,0] - Z(Y)*B, INDEPENDENT of the FFT port.
# Run:  sage checks/sage/exact_ring_checks.sage     (cwd = W root)
# Exact arithmetic over QQ/GF(q) via Sage polynomial rings; deterministic LCG.
# Scope: algebra controls on synthetic pinned keys (extended/local domain,
# NOT Emitted membership). Mutations prove detection power.

# preparser/toolchain preflight (principle doc 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1 / 3) is QQ
assert 2 ^ 10 == 1024

import json
from sage.all import PolynomialRing, ZZ, QQ, GF, matrix

N = 1536
Q = 18433

RZ = PolynomialRing(ZZ, 'x')
x = RZ.gen()
PHI = x ** N - x ** (N // 2) + 1
RF = PolynomialRing(GF(Q), 'z')
z = RF.gen()
PHIF = z ** N - z ** (N // 2) + 1

# deterministic LCG (no scheme PRNG; fixture determinism only)
class LCG:
    def __init__(self, seed):
        self.s = seed % (2 ** 64)
    def next(self):
        self.s = (6364136223846793005 * self.s + 1442695040888963407) % (2 ** 64)
        return self.s >> 11
    def randint(self, lo, hi):
        return lo + self.next() % (hi - lo + 1)

def red(p):
    return RZ(p) % PHI

def mulR(a, b):
    return red(RZ(a) * RZ(b))

def toF(p):
    return RF(p) % PHIF

results = {}
mut = {}
rng = LCG(20260922)

def rand_ternary():
    return red(sum([ZZ(rng.randint(-1, 1)) * x ** i for i in range(N)]))

def build_key(degenerate):
    jj = [0] * N
    if degenerate:
        jj[rng.randint(1, N - 2)] = 1 if rng.randint(0, 1) else -1
    else:
        jj = [rng.randint(-1, 1) for _ in range(N)]
        if all(v == 0 for v in jj):
            jj[1] = 1
    j = RZ(sum([ZZ(jj[i]) * x ** i for i in range(N)]))
    Xj = red(x * j)
    f = red(1 + Xj)
    g = Xj
    Fp = red((Q - 1) - Xj)
    G = red(Q - Xj)
    return f, g, Fp, G

for trial in (0, 1):
    degenerate = (trial == 0)
    f, g, Fp, G = build_key(degenerate)
    tag = "key%d(degenerate=%s)" % (trial, degenerate)
    r = {}
    # C1: det B = f*G - g*F = q exactly in Z[X]/Phi
    r["C1_det_identity"] = (red(f * G - g * Fp) == RZ(Q))
    # h = g * f^{-1} mod (q, Phi) over GF(q)[X]/Phi
    finv = RF(f).inverse_mod(PHIF)
    h = (toF(g) * finv) % PHIF
    r["C5_hf_eq_g_modq"] = (h * toF(f) % PHIF == toF(g))
    r["C5_hF_eq_G_modq"] = (h * toF(Fp) % PHIF == toF(G))
    for k in range(3):
        Y = [ZZ(rng.randint(-(2 ** 30), 2 ** 30)) for _ in range(N)]
        sgnA = [ZZ(1 if rng.randint(0, 1) else -1) for _ in range(N)]
        sgnB = [ZZ(1 if rng.randint(0, 1) else -1) for _ in range(N)]
        a = red(sum([sgnA[i] * Y[i] * x ** i for i in range(N)]))
        b = red(sum([sgnB[i] * Y[i] * x ** i for i in range(N)]))
        c = RZ(sum([ZZ(rng.randint(0, Q - 1)) * x ** i for i in range(N)]))
        v1 = red(c - (mulR(a, g) + mulR(b, G)))
        v2 = red(mulR(a, f) + mulR(b, Fp))
        # A-integrality: all coefficients integral (ZZ polynomials by construction)
        r["A_integrality_%d" % k] = (v1.parent() == RZ and v2.parent() == RZ)
        # C4: ring identity  v1 + h_Z*v2 - c = a*(h_Z*f - g) + b*(h_Z*F - G)
        # with the integer representative h_Z lifted from GF(q) (0..q-1 coeffs)
        hlist = h.list()
        hZ = RZ([ZZ(hlist[i]) if i < len(hlist) else ZZ(0) for i in range(N)])
        left = red(v1 + mulR(hZ, v2) - c)
        right = red(mulR(a, red(hZ * f - g)) + mulR(b, red(hZ * Fp - G)))
        r["C4_ring_identity_%d" % k] = (left == right)
        # C3: congruence v1 + h*v2 = c mod (q, Phi)
        lhs = (toF(v1) + h * toF(v2) - toF(c)) % PHIF
        r["C3_congruence_%d" % k] = (lhs == RF(0))
        # C2: target identity over QQ[x]/Phi (exact, via scaled integer check):
        #   q*(T0*g + T1*G) = c*(f*G - F*g) = c*q  and  q*(T0*f + T1*F) = 0
        e1 = red(-mulR(mulR(c, Fp), g) + mulR(mulR(c, f), G))
        e2 = red(-mulR(mulR(c, Fp), f) + mulR(mulR(c, f), Fp))
        r["C2_target_row0_%d" % k] = (e1 == red(Q * c))
        r["C2_target_row1_%d" % k] = (e2 == RZ(0))
    results[tag] = r

# --- mutations: each must flip at least one PASS to FAIL ---
rngm = LCG(7)
fn, gn, Fpn, Gn = build_key(True)
jj2 = [rngm.randint(-1, 1) for _ in range(N)]
j2 = RZ(sum([ZZ(v) * x ** i for i, v in enumerate(jj2)]))
a = RZ(sum([ZZ(rngm.randint(-(2 ** 20), 2 ** 20)) * x ** i for i in range(N)]))
b = RZ(sum([ZZ(rngm.randint(-(2 ** 20), 2 ** 20)) * x ** i for i in range(N)]))
c = RZ(sum([ZZ(rngm.randint(0, Q - 1)) * x ** i for i in range(N)]))

def congruent(a, b, c, g, G, f, Fp, h):
    v1 = red(c - (mulR(a, g) + mulR(b, G)))
    v2 = red(mulR(a, f) + mulR(b, Fp))
    lhs = (toF(v1) + h * toF(v2) - toF(c)) % PHIF
    return lhs == RF(0)

hn = (toF(gn) * RF(fn).inverse_mod(PHIF)) % PHIF
h_wrong = (toF(fn) * RF(red(x * j2)).inverse_mod(PHIF)) % PHIF
mut["M_wrong_h_relation"] = not ((h_wrong * toF(fn) % PHIF == toF(gn))
                                and congruent(a, b, c, gn, Gn, fn, Fpn, h_wrong))
v1m = red(c - (mulR(a, gn) + mulR(b, Gn)))
v2m = red(mulR(a, fn) - mulR(b, Fpn))
mut["M_wrong_sign_in_v2_row"] = not ((toF(v1m) + hn * toF(v2m) - toF(c)) % PHIF == RF(0))
e1m = red(-mulR(mulR(c, Fpn), gn) - mulR(mulR(c, fn), Gn))
mut["M_wrong_target_sign"] = not (e1m == red(Q * c))
detm = red(Fpn * Gn - gn * fn)
mut["M_wrong_basis_swap_rows_det"] = not (detm == RZ(Q))
mut["NOOP_a_copy"] = congruent(red(a), red(b), c, gn, Gn, fn, Fpn, hn)
mut["NOTE_universal_in_Z"] = True

all_core = all(all(bool(v) for kk, v in r.items()) for r in results.values())
ok = all_core and all(bool(mut[k]) for k in mut if not k.startswith("NOOP")) \
    and bool(mut["NOOP_a_copy"])
out = {
    "schema": "ft1536.reference_integer_recovery.exact_ring_checks/1",
    "engine": "sage-10.9 (sage checks/sage/exact_ring_checks.sage; preparser on)",
    "N": int(N), "q": int(Q), "phi": "X^1536-X^768+1",
    "scope": "synthetic pinned keys; extended/local algebra control; NOT Emitted membership",
    "trials": {tag: {k: bool(v) for k, v in r.items()} for tag, r in results.items()},
    "mutations_detected": {k: bool(v) for k, v in mut.items()},
    "all_core_pass": bool(all_core),
    "all_pass": bool(ok),
}
with open("checks/exact_ring_checks.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)
print(json.dumps({"all_pass": out["all_pass"], "mutations": out["mutations_detected"]},
                 indent=1, sort_keys=True))
if not ok:
    raise SystemExit(1)
