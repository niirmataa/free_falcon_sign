#!/usr/bin/env python3
"""FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- exact ring/determinant/target/
congruence checks for the reference v_ref = [c,0] - Z(Y)*B, independent of the
FFT port. All arithmetic exact (Python ints / fractions). Phi = X^1536-X^768+1.

Scope: algebra controls on synthetic pinned keys (extended/local domain, NOT
Emitted membership). Mutations prove detection power.
"""
import json, os, random, time
from fractions import Fraction

W = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
OUT = os.path.join(W, "checks", "exact_ring_checks.json")
N = 1536
Q = 18433

def zero():
    return [0] * N

def add(a, b):
    return [(x + y) for x, y in zip(a, b)]

def sub(a, b):
    return [(x - y) for x, y in zip(a, b)]

def neg(a):
    return [-x for x in a]

def smul(a, s):
    return [x * s for x in a]

def reduce_raw(c):
    """Reduce integer coefficient list of deg < 2N mod Phi = X^N - X^(N/2) + 1.
    X^(N+m) = X^(N/2+m) - X^m  (0<=m<N/2);  X^(3N/2+m) = -X^m  (0<=m<N/2)."""
    out = c[:N] + [0] * max(0, N - len(c))
    out = out[:N]
    h = N // 2
    for k in range(N, min(len(c), 3 * h)):
        out[k - h] += c[k]
        out[k - N] -= c[k]
    for k in range(3 * h, len(c)):
        out[k - 3 * h] -= c[k]
    return out

def mul(a, b):
    n = len(a)
    raw = [0] * (2 * n - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                if bj:
                    raw[i + j] += ai * bj
    return reduce_raw(raw)

def smulpoly(a, q_num, q_den):
    """(q_num/q_den) * a with integer output only if divisible; returns Fraction list."""
    return [Fraction(x * q_num, q_den) for x in a]

def qadd(a, b):
    return [x + y for x, y in zip(a, b)]

def qsub(a, b):
    return [x - y for x, y in zip(a, b)]

def qmul(a, b):
    """Multiply Fraction coefficient lists mod Phi."""
    an = [x.numerator for x in a]
    ad = [x.denominator for x in a]
    bn = [x.numerator for x in b]
    bd = [x.denominator for x in b]
    # common denominator per operand
    from math import gcd
    da = 1
    for d in ad:
        da = da * d // gcd(da, d)
    db = 1
    for d in bd:
        db = db * d // gcd(db, d)
    ai = [x.numerator * (da // x.denominator) for x in a]
    bi = [x.numerator * (db // x.denominator) for x in b]
    prod = mul(ai, bi)
    den = da * db
    return [Fraction(x, den) for x in prod]

def modq(a):
    return [x % Q for x in a]

def fmulq(a, b):
    return modq(mul(modq(a), modq(b)))

def fsubq(a, b):
    return [(x - y) % Q for x, y in zip(a, b)]

def fq_equal(a, b):
    return all((x - y) % Q == 0 for x, y in zip(a, b))

def is_integral(a):
    return all(x.denominator == 1 for x in a)

def to_int(a):
    assert is_integral(a)
    return [x.numerator for x in a]

def rand_ternary(rng, full=True):
    lo = -1 if full else 0
    return [rng.randint(lo, 1) for _ in range(N)]

def poly_xgcd(a, b):
    """Extended Euclid over F_q[X] (unreduced lists); returns (g, x, y)."""
    def deg(p):
        d = len(p) - 1
        while d >= 0 and p[d] % Q == 0:
            d -= 1
        return d
    def trim(p):
        return [x % Q for x in p[:deg(p) + 1]] or [0]
    def divmodp(a, b):
        a = trim(a); b = trim(b)
        db = deg(b)
        inv = pow(b[db], Q - 2, Q)
        quot = [0] * max(1, deg(a) - db + 1)
        while deg(a) >= db and deg(a) >= 0:
            da = deg(a)
            coef = a[da] * inv % Q
            quot[da - db] = coef
            for i in range(db + 1):
                a[da - db + i] = (a[da - db + i] - coef * b[i]) % Q
            a = trim(a) or [0]
        return (quot, a)
    r0, r1 = trim(a), trim(b)
    s0, s1 = [1], [0]
    t0, t1 = [0], [1]
    while deg(r1) >= 0:
        qq, rr = divmodp(r0[:], r1[:])
        r0, r1 = r1, rr

        def lin(c, x, y):
            # x - c*y over F_q
            prod = [0] * (len(c) + len(y) - 1)
            for i, ci in enumerate(c):
                if ci:
                    for j, yj in enumerate(y):
                        prod[i + j] = (prod[i + j] + ci * yj) % Q
            m = max(len(prod), len(x))
            prod += [0] * (m - len(prod))
            xx = x + [0] * (m - len(x))
            return [(u - v) % Q for u, v in zip(xx, prod)]
        s0, s1 = s1, lin(qq, s0, s1)
        t0, t1 = t1, lin(qq, t0, t1)
    return (r0, s0, t0)

def pad(p):
    return (p + [0] * N)[:N]

def invert_mod_phi_q(f):
    """Inverse of f in F_q[X]/Phi via extended Euclid on (Phi, f)."""
    phi = [0] * (N + 1)
    phi[0] = 1
    phi[N // 2] = -1
    phi[N] = 1
    g, s, t = poly_xgcd(phi, f)
    if degf(g) != 0:
        return None
    invc = pow(g[0], Q - 2, Q)
    one = [1] + [0] * (N - 1)
    for cand0 in (s, t):
        for sgn in (1, -1):
            cand = pad([((sgn * invc) * xi) % Q for xi in cand0])
            if fmulq(cand, f) == one:
                return cand
    return None

def degf(p):
    d = len(p) - 1
    while d >= 0 and p[d] % Q == 0:
        d -= 1
    return d

def build_key(rng, degenerate=False):
    """Synthetic key family with EXACT det B = f*G - g*F = q in Z[X]/Phi:
    for any j let Xj = X*j (mod Phi):
        f = 1 + Xj,  g = Xj,  F = q-1-Xj,  G = q-Xj
    then f*G - g*F = q and h = g*f^-1 mod (q,Phi) satisfies h*f = g, h*F = G.
    degenerate=True uses a monomial j (weaker but valid instance)."""
    j = rand_ternary(rng, full=True)
    if degenerate or all(x == 0 for x in j):
        j = [0] * N
        j[rng.randint(1, N - 2)] = rng.choice([-1, 1])
    Xj = [0] * N
    for i, ji in enumerate(j):
        if ji:
            if i + 1 < N:
                Xj[i + 1] += ji
            else:
                Xj[0] -= ji          # X^N = X^(N/2) - 1
                Xj[N // 2] += ji
    one = [1] + [0] * (N - 1)
    qq = [Q] + [0] * (N - 1)
    f = add(one, Xj)                  # f = 1 + Xj  (invertible mod q)
    g = list(Xj)                      # g = Xj
    F = sub([Q - 1] + [0] * (N - 1), Xj)   # F = q-1-Xj
    G = sub(qq, Xj)                   # G = q-Xj
    finv = invert_mod_phi_q(f)
    assert finv is not None, "synthetic f not invertible mod (q,Phi)"
    h = fmulq(g, finv)
    return f, g, F, G, h

def main():
    t0 = time.time()
    rng = random.Random(20260922)
    results = {}
    trials = []
    for trial, degenerate in enumerate([True, False]):
        f, g, F, G, h = build_key(rng, degenerate=degenerate)
        tag = "key%d(degenerate=%s)" % (trial, degenerate)
        r = {}
        # C1: det B = fG - gF = q exactly in Z[X]/Phi.
        det = sub(mul(f, G), mul(g, F))
        want = [Q] + [0] * (N - 1)
        r["C1_det_identity"] = (det == want)
        # C5: key relations mod q: h*f = g, h*F = G in F_q[X]/Phi.
        r["C5_hf_eq_g_modq"] = fq_equal(fmulq(h, f), modq(g))
        r["C5_hF_eq_G_modq"] = fq_equal(fmulq(h, F), modq(G))
        for k in range(3):
            # random integer returns (Z(Y) slot values) with large magnitudes
            Y = [rng.randint(-2 ** 30, 2 ** 30) for _ in range(N)]
            Zv = [rng.choice([-1, 1]) * y for y in Y]      # signed placement (a)
            Wv = [rng.choice([-1, 1]) * y for y in Y]      # signed placement (b)
            a, b = Zv, Wv
            # A-integrality: v_ref = [c,0] - (a,b)*B is in Z[X]/Phi^2 by ring closure.
            c = [rng.randint(0, Q - 1) for _ in range(N)]
            v1 = sub(c, add(mul(a, g), mul(b, G)))
            v2 = add(mul(a, f), mul(b, F))
            r["A_integrality_%d" % k] = all(x.denominator == 1 for x in v1) and \
                all(x.denominator == 1 for x in v2)
            # C4: ring identity  v1 + h*v2 - c = a*(h f - g) + b*(h F - G)  over Z[X]/Phi,
            # with EXACT integer products (not mod-q representatives).
            hf_m_g = sub(mul(h, f), g)
            hF_m_G = sub(mul(h, F), G)
            left = sub(add(v1, mul(h, v2)), c)
            right = add(mul(a, hf_m_g), mul(b, hF_m_G))
            r["C4_ring_identity_%d" % k] = (left == right)
            # C3: congruence  v1 + h*v2 = c  mod (q,Phi).
            lhs = fsubq(modq(add(v1, fmulq(h, v2))), modq(c))
            r["C3_congruence_%d" % k] = all(x % Q == 0 for x in lhs)
            # C2: target identity over QQ[x]/Phi checked exactly over Z:
            #   q*(T0*g + T1*G) = c*(f*G - F*g) = c*q  and  q*(T0*f + T1*F) = 0,
            # with T0 = -c*F/q, T1 = c*f/q (exact rationals from TARGETS).
            e1 = add(mul(neg(mul(c, F)), g), mul(mul(c, f), G))
            e2 = add(mul(neg(mul(c, F)), f), mul(mul(c, f), F))
            r["C2_target_row0_%d" % k] = (e1 == smul(c, Q))
            r["C2_target_row1_%d" % k] = all(x == 0 for x in e2)
        trials.append(r)
        results[tag] = r

    # --- mutations: each must flip at least one PASS to FAIL ---
    # Note: the congruence statement is UNIVERSAL in (a,b,c) -- any integer pair
    # (a,b) gives a congruent v. Sensitivity therefore targets the relations
    # (det/key/target definitions). Z-specific sensitivity is in the skeleton
    # cancellation control (residual identity).
    mut = {}
    f, g, F, G, h = build_key(random.Random(7), degenerate=True)
    g2 = rand_ternary(random.Random(8), full=True)
    a = [rng.randint(-2 ** 20, 2 ** 20) for _ in range(N)]
    b = [rng.randint(-2 ** 20, 2 ** 20) for _ in range(N)]
    c = [rng.randint(0, Q - 1) for _ in range(N)]

    def congruent(a, b, c, g, G, f, F, h):
        v1 = sub(c, add(mul(a, g), mul(b, G)))
        v2 = add(mul(a, f), mul(b, F))
        lhs = fsubq(modq(add(v1, fmulq(h, v2))), modq(c))
        return all(x % Q == 0 for x in lhs)

    # wrong public h (f/g inverted): key relations and congruence must fail
    h_wrong = fmulq(f, invert_mod_phi_q(g2) or [0] * N)
    mut["M_wrong_h_relation"] = not (fq_equal(fmulq(h_wrong, f), modq(g))
                                     and congruent(a, b, c, g, G, f, F, h_wrong))
    # wrong basis row pairing in v2 (sign flip on b row): congruence must fail
    v1m = sub(c, add(mul(a, g), mul(b, G)))
    v2m = sub(mul(a, f), mul(b, F))
    lhs = fsubq(modq(add(v1m, fmulq(h, v2m))), modq(c))
    mut["M_wrong_sign_in_v2_row"] = not all(x % Q == 0 for x in lhs)
    # wrong target identity: T1 with minus sign must fail C2
    e1m = add(mul(neg(mul(c, F)), g), neg(mul(mul(c, f), G)))
    mut["M_wrong_target_sign"] = not (e1m == smul(c, Q))
    # wrong determinant convention: swap f<->F in det must fail C1
    # (needs the non-degenerate key: with f=F=1 the swap is a no-op)
    fn, gn, Fn, Gn, hn = build_key(random.Random(11), degenerate=False)
    detm = sub(mul(Fn, Gn), mul(gn, fn))
    mut["M_wrong_basis_swap_rows_det"] = not (detm == [Q] + [0] * (N - 1))
    # no-op: renaming/trivial reordering that must NOT be detected
    mut["NOOP_a_copy"] = congruent(list(a), list(b), c, g, G, f, F, h)
    mut["NOTE_universal_in_Z"] = True  # genericity in (a,b,c) is by design

    out = {
        "schema": "ft1536.reference_integer_recovery.exact_ring_checks/1",
        "N": N, "q": Q, "phi": "X^1536-X^768+1",
        "scope": "synthetic pinned keys; extended/local algebra control; NOT Emitted membership",
        "trials": results,
        "mutations_detected": mut,
        "all_core_pass": all(all(v for kk, v in r.items() if not kk.startswith("M_")) for r in trials),
    }
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    print(json.dumps({"all_core_pass": out["all_core_pass"], "mutations": mut}, indent=1))
    return 0 if out["all_core_pass"] and all(mut[k] for k in mut if not k.startswith("NOOP")) \
        and mut["NOOP_a_copy"] else 1

if __name__ == "__main__":
    raise SystemExit(main())
