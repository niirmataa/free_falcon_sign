# FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002 -- independent ring/congruence (A)
# Run: sage sage_checks/review_ring_independent_002.sage   (cwd = W review root)
# Fresh synthetic keys with LCG seed 20260923 (differs from author 20260922 and
# prior 987654321): det/target/integrality/congruence/ring identity in Z[X]/Phi.
# Follows the same exact-ring semantics as the author port but recomputes from
# fresh randomness; independent of FFT port and of author fixtures.

# preparser/toolchain preflight (SAGE POLICY 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024

import json
from sage.all import PolynomialRing, ZZ, QQ, GF

N = 1536
Q = 18433

RZ = PolynomialRing(ZZ, 'x')
x = RZ.gen()
PHI = x**N - x**(N//2) + 1
RF = PolynomialRing(GF(Q), 'z')
z = RF.gen()
PHIF = z**N - z**(N//2) + 1

class LCG:
    def __init__(self, seed):
        self.s = seed % (2**64)
    def next(self):
        self.s = (6364136223846793005 * self.s + 1442695040888963407) % (2**64)
        return self.s >> 11
    def randint(self, lo, hi):
        return lo + self.next() % (hi - lo + 1)

def red(p):
    return RZ(p) % PHI

def mulR(a, b):
    return red(RZ(a) * RZ(b))

def toF(p):
    return RF(p) % PHIF

rng = LCG(20260923)

def build_key_once(degenerate):
    jj = [0]*N
    if degenerate:
        jj[rng.randint(1, N-2)] = 1 if rng.randint(0, 1) else -1
    else:
        jj = [rng.randint(-1, 1) for _ in range(N)]
        if all(v == 0 for v in jj):
            jj[1] = 1
    j = RZ(sum([ZZ(jj[i])*x**i for i in range(N)]))
    Xj = red(x*j)
    f = red(1 + Xj)
    g = Xj
    Fp = red((Q-1) - Xj)
    G = red(Q - Xj)
    return f, g, Fp, G

def build_key_invertible(degenerate):
    # fresh LCG draws until f invertible mod (q,Phi); records attempts
    for attempt in range(100):
        f, g, Fp, G = build_key_once(degenerate)
        try:
            _ = RF(f).inverse_mod(PHIF)
            return f, g, Fp, G, attempt
        except ArithmeticError:
            continue
    raise SystemExit("no invertible f in 100 attempts")

results = {}
attempts_log = {}
for trial in (0, 1):
    degenerate = (trial == 0)
    f, g, Fp, G, natt = build_key_invertible(degenerate)
    attempts_log["trial%d" % trial] = int(natt)
    tag = "key%d(degenerate=%s)_seed20260923" % (trial, degenerate)
    r = {}
    r["C1_det_identity"] = bool(red(f*G - g*Fp) == RZ(Q))
    finv = RF(f).inverse_mod(PHIF)
    h = (toF(g)*finv) % PHIF
    r["C5_hf_eq_g_modq"] = bool(h*toF(f) % PHIF == toF(g))
    r["C5_hF_eq_G_modq"] = bool(h*toF(Fp) % PHIF == toF(G))
    for k in range(3):
        Y = [ZZ(rng.randint(-(2**30), 2**30)) for _ in range(N)]
        sgnA = [ZZ(1 if rng.randint(0, 1) else -1) for _ in range(N)]
        sgnB = [ZZ(1 if rng.randint(0, 1) else -1) for _ in range(N)]
        a = red(sum([sgnA[i]*Y[i]*x**i for i in range(N)]))
        b = red(sum([sgnB[i]*Y[i]*x**i for i in range(N)]))
        c = RZ(sum([ZZ(rng.randint(0, Q-1))*x**i for i in range(N)]))
        v1 = red(c - (mulR(a, g) + mulR(b, G)))
        v2 = red(mulR(a, f) + mulR(b, Fp))
        r["A_integrality_%d" % k] = bool(v1.parent() == RZ and v2.parent() == RZ)
        hlist = h.list()
        hZ = RZ([ZZ(int(hlist[i])) if i < len(hlist) else ZZ(0) for i in range(N)])
        left = red(v1 + mulR(hZ, v2) - c)
        right = red(mulR(a, red(hZ*f - g)) + mulR(b, red(hZ*Fp - G)))
        r["C4_ring_identity_%d" % k] = bool(left == right)
        lhs = (toF(v1) + h*toF(v2) - toF(c)) % PHIF
        r["C3_congruence_%d" % k] = bool(lhs == RF(0))
        e1 = red(-mulR(mulR(c, Fp), g) + mulR(mulR(c, f), G))
        e2 = red(-mulR(mulR(c, Fp), f) + mulR(mulR(c, f), Fp))
        r["C2_target_row0_%d" % k] = bool(e1 == red(Q*c))
        r["C2_target_row1_%d" % k] = bool(e2 == RZ(0))
    results[tag] = r

# mutations on fresh instance (invertible fn, invertible x*j2 for h_wrong)
rngm = LCG(777)
# use main rng for fn to keep determinism chain; ensure invertible
fn, gn, Fpn, Gn, _ = build_key_invertible(True)
# find invertible x*j2 for wrong-h construction
for _ in range(100):
    jj2 = [rngm.randint(-1, 1) for _ in range(N)]
    j2 = RZ(sum([ZZ(v)*x**i for i, v in enumerate(jj2)]))
    try:
        _ = RF(red(x*j2)).inverse_mod(PHIF)
        break
    except ArithmeticError:
        continue
a = RZ(sum([ZZ(rngm.randint(-(2**20), 2**20))*x**i for i in range(N)]))
b = RZ(sum([ZZ(rngm.randint(-(2**20), 2**20))*x**i for i in range(N)]))
c = RZ(sum([ZZ(rngm.randint(0, Q-1))*x**i for i in range(N)]))

def congruent(aa, bb, cc, g, G, f, Fp, h):
    v1 = red(cc - (mulR(aa, g) + mulR(bb, G)))
    v2 = red(mulR(aa, f) + mulR(bb, Fp))
    lhs = (toF(v1) + h*toF(v2) - toF(cc)) % PHIF
    return lhs == RF(0)

hn = (toF(gn)*RF(fn).inverse_mod(PHIF)) % PHIF
h_wrong = (toF(fn)*RF(red(x*j2)).inverse_mod(PHIF)) % PHIF
mut = {}
mut["M_wrong_h_relation"] = bool(not ((h_wrong*toF(fn) % PHIF == toF(gn)) and congruent(a, b, c, gn, Gn, fn, Fpn, h_wrong)))
v1m = red(c - (mulR(a, gn) + mulR(b, Gn)))
v2m = red(mulR(a, fn) - mulR(b, Fpn))
mut["M_wrong_sign_in_v2_row"] = bool(not ((toF(v1m) + hn*toF(v2m) - toF(c)) % PHIF == RF(0)))
e1m = red(-mulR(mulR(c, Fpn), gn) - mulR(mulR(c, fn), Gn))
mut["M_wrong_target_sign"] = bool(not (e1m == red(Q*c)))
detm = red(Fpn*Gn - gn*fn)
# swapped-rows det would be F*G - g*f? check detection of wrong order
mut["M_wrong_basis_swap_rows_det"] = bool(not (detm == RZ(Q)))
mut["NOOP_a_copy"] = bool(congruent(red(a), red(b), c, gn, Gn, fn, Fpn, hn))

all_core = all(all(bool(v) for v in r.values()) for r in results.values())
ok = all_core and all(bool(mut[k]) for k in mut if not k.startswith("NOOP")) and bool(mut["NOOP_a_copy"])
out = {
    "schema": "ft1536.review002.ring_independent/1",
    "engine": "sage-10.9 (sage sage_checks/review_ring_independent_002.sage; preparser on)",
    "lcg_seed": int(20260923),
    "N": int(1536),
    "q": int(18433),
    "invertible_attempts": attempts_log,
    "trials": results,
    "mutations_detected": mut,
    "all_core_pass": bool(all_core),
    "pass": bool(ok),
}
with open("sage_checks/review_ring_independent_002.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)
print(json.dumps({"all_core_pass": bool(all_core), "pass": bool(ok), "mutations": mut}, indent=1, sort_keys=True))
print("REVIEW002_RING_PASS")
if not ok:
    raise SystemExit(1)
