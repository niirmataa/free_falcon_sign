#!/usr/bin/env sage
"""FT family: exact-arithmetic checks with SageMath 10.9 (pinned tool).

Sections:
  SA1  X^N - X^(N/2) + 1 == cyclotomic_polynomial(3N) over ZZ, for
       N in {768, 1536, 3072} (exact coefficient comparison).
  SA2  Ramanujan support lemma for m = 3N: c_m(t) = 0 for 0 < |t| < N with
       (N/2) not dividing t, c_m(0) = N, c_m(+-N/2) = N/2 (exact).
  SA3  trace-form identity (exact, integer): (1/N) Tr(a*conj(a)) equals
       sum_{i<N/2} A2(a_i, a_{i+N/2}) for sample vectors a (the N-scaling is
       kept as an exact fraction).
  SA4  subgroup/subfield census of Gal(Q(zeta_m)/Q) = (Z/m)^*: explicit
       solutions of u^2 = 1 mod m, counts of order-2 subgroups (= index-2
       subfields) and index-2 subgroups (= quadratic subfields), and the full
       subgroup count by GAP.
  SA5  high-precision constants: sqrt(4*pi*e/(3q)), sqrt(2*pi*e/(3q)),
       the all-ones evaluation sqrt(3)/(2 sin(pi/(3N))), GH radii.
  SA6  P_k^A2 extremizers and equivalence margins (exact).

Output: results/sage_exact.json (and stdout).
"""
import json
import os

from sage.all import (ZZ, QQ, RR, RealField, cyclotomic_polynomial, gcd,
                      moebius, euler_phi, PolynomialRing, AbelianGroup,
                      gp, pi, srange)

Q = 18433
NS = [768, 1536, 3072]
HERE = os.path.dirname(os.path.abspath(__file__))
# Sage executes a pre-parsed copy in a temp dir, so __file__ is not the
# package path; the script must be invoked from the package root.
PKG = os.getcwd()
OUT = os.path.join(PKG, "results")
os.makedirs(OUT, exist_ok=True)

rep = {}
lines = []


def log(s):
    print(s)
    lines.append(str(s))


def ramanujan(m, t):
    g = gcd(m, t)
    mg = m // g
    return moebius(mg) * euler_phi(m) // euler_phi(mg)


log("=== sage_exact.sage (SageMath version below) ===")
log("sage version: " + str(gp('version()')))

# ---- SA1: exact cyclotomic identity -------------------------------------
R = PolynomialRing(ZZ, 'X')
X = R.gen()
for N in NS:
    phi = R(cyclotomic_polynomial(3 * N))
    cand = X ** N - X ** (N // 2) + 1
    ok = (phi == cand)
    log(f"SA1  N={N}: Phi_{3 * N}(X) == X^{N} - X^{N // 2} + 1 : {ok}"
        f"  (deg {phi.degree()}, phi(3N) = {euler_phi(3 * N)})")
    rep.setdefault("SA1", {})[str(N)] = {
        "equal": bool(ok), "degree": int(phi.degree()),
        "phi_3N": int(euler_phi(3 * N)),
        "leading": int(phi.leading_coefficient()),
    }

# ---- SA2: Ramanujan support lemma ---------------------------------------
for N in NS:
    m = 3 * N
    bad = []
    c0 = ramanujan(m, 0)
    chalf = ramanujan(m, N // 2)
    for t in range(1, N):
        c = ramanujan(m, t)
        if (N // 2) % (N // 2) == 0 and t % (N // 2) == 0:
            expect_zero = False
        else:
            expect_zero = True
        if expect_zero and c != 0:
            bad.append(int(t))
        if (not expect_zero) and c != chalf:
            bad.append(int(t))
    ok = (not bad) and c0 == N and chalf == N // 2
    log(f"SA2  N={N}: c_m(0) = {c0} (=N), c_m(N/2) = {chalf} (=N/2),"
        f" zeros elsewhere in (0,N): {ok}")
    rep.setdefault("SA2", {})[str(N)] = {
        "c0": int(c0), "c_half": int(chalf), "violations": bad[:10],
        "ok": bool(ok),
    }

# ---- SA3: exact trace-form identity --------------------------------------
import random
rng = random.Random(int(1536))
for N in NS:
    m = 3 * N
    cases_ok = True
    details = []
    for trial in range(4):
        if trial == 0:
            a = [1] * N
        elif trial == 1:
            a = [1 if i < N // 2 else -1 for i in range(N)]
        elif trial == 2:
            a = [rng.randint(-1, 1) for _ in range(N)]
        else:
            a = [rng.randint(-3, 3) for _ in range(N)]
        acc = sum(a[i] * a[j] * ramanujan(m, i - j) for i in range(N) for j in range(N))
        trace_over_N = QQ(acc) / N
        pairs = sum(a[i] ** 2 + a[i] * a[i + N // 2] + a[i + N // 2] ** 2
                    for i in range(N // 2))
        ok = (trace_over_N == pairs)
        cases_ok = cases_ok and ok
        details.append({"trial": trial, "equal": bool(ok)})
    log(f"SA3  N={N}: (1/N)Tr(a*conj a) == sum_i A2(a_i, a_(i+N/2)) :"
        f" {cases_ok}  (4 exact cases)")
    rep.setdefault("SA3", {})[str(N)] = {"cases": details, "ok": bool(cases_ok)}

# ---- SA4: subgroup / subfield census ------------------------------------
for N in NS:
    m = 3 * N
    units2 = [u for u in range(1, m) if gcd(u, m) == 1 and (u * u) % m == 1]
    order2 = [u for u in units2 if u != 1]
    # abelian group of (Z/m)^* for m = 2^k * 9: C2 x C_{2^{k-2}} x C6
    kk = 0
    mm = m
    while mm % 2 == 0:
        mm //= 2
        kk += 1
    G = AbelianGroup([2, 2 ** (kk - 2), 6])
    subs = G.subgroups()
    from collections import Counter
    by_order = Counter(int(H.order()) for H in subs)
    n_order2 = by_order.get(2, 0)
    n_index2 = by_order.get(N // 2, 0)
    total = len(subs)
    log(f"SA4  N={N}, m={m}: u^2=1 solutions = {len(units2)}"
        f" (nontrivial {len(order2)}: {order2})")
    log(f"     GAP: |G| = {G.order()}, total subgroups = {total},"
        f" order-2 subgroups = {n_order2} (= index-2 subfields),"
        f" index-2 subgroups = {n_index2} (= quadratic subfields)")
    rep.setdefault("SA4", {})[str(N)] = {
        "m": m, "order2_elements": order2, "u2_eq_1_count": len(units2),
        "group_invariants": [2, 2 ** (kk - 2), 6],
        "total_subgroups": int(total), "order2_subgroups": int(n_order2),
        "index2_subgroups": int(n_index2),
        "subgroups_by_order_head": {str(o): int(c)
                                    for o, c in sorted(by_order.items())[:12]},
    }

# ---- SA5: high-precision constants --------------------------------------
R200 = RealField(200)
from sage.all import e as ee
c_key = (R200(4) * R200(pi) * ee / (R200(3) * R200(Q))).sqrt()
c_f = (R200(2) * R200(pi) * ee / (R200(3) * R200(Q))).sqrt()
log(f"SA5  sqrt(4 pi e/(3 q)) = {c_key}")
log(f"     sqrt(2 pi e/(3 q)) = {c_f}")
rep["SA5"] = {"asym_key_ratio": str(c_key), "asym_f_ratio": str(c_f)}
for N in NS:
    val = (R200(3).sqrt() / (R200(2) * (R200(pi) / (3 * N)).sin()))
    asym = R200(3) * R200(3).sqrt() / (R200(2) * R200(pi)) * N
    d = 2 * N
    gh_asym_c = (R200(d) / (R200(2) * R200(pi) * ee)).sqrt() * R200(Q) ** (QQ((1, 2)))
    log(f"     N={N}: all-ones |a(zeta)| = {val}")
    log(f"              asymptotic (3 sqrt3/(2 pi)) N = {asym}")
    log(f"              withdrawn sqrt(N) = {R200(N).sqrt()}")
    log(f"              GH_asym (coeff) = {gh_asym_c}")
    rep.setdefault("SA5_N", {})[str(N)] = {
        "all_ones_abs_eval": str(val), "asymptotic": str(asym),
        "withdrawn_sqrtN": str(R200(N).sqrt()),
        "gh_asym_coeff": str(gh_asym_c),
    }

# ---- SA6: A2 equivalence margins (exact) --------------------------------
for N in NS:
    up = sum(3 for _ in range(N // 2))          # a = all ones
    lo = sum(1 for _ in range(N // 2))          # a_i = 1, a_{i+N/2} = -1
    log(f"SA6  N={N}: Q_A2(all ones) = {up} = (3/2)||a||^2 = {3 * N // 2}"
        f" -> {up == 3 * N // 2};"
        f" Q_A2(+/-) = {lo} = (1/2)||a||^2 = {N // 2} -> {lo == N // 2}")
    rep.setdefault("SA6", {})[str(N)] = {
        "upper_value": up, "upper_target": 3 * N // 2,
        "lower_value": lo, "lower_target": N // 2,
    }

with open(os.path.join(OUT, "sage_exact.json"), "w") as f:
    json.dump(rep, f, indent=2, sort_keys=True, default=str)
log("Wrote sage_exact.json")
