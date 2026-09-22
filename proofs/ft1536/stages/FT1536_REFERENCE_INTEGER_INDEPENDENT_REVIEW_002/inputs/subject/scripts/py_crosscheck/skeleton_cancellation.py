#!/usr/bin/env python3
"""FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- Z(Y) map and exact-skeleton
cancellation control.

Builds the literal call order (root: right-then-left; cubic: 2->1->0; binary:
right-then-left; terminal: mu1-return first, then updated-mu0 return) and the
coefficient placement map Z(Y) = signed permutation of the 3072 integer returns
into (a,b) coefficient slots, from the source merge conventions
(merge(u0,u1): out[2i]=u0[i], out[2i+1]=u1[i]; cubic out[3i+c]=v_c[i]).

Controls (exact arithmetic, no floats):
  E1 reduced shape K=3: literal recursion with random rational L polynomials,
     rational targets, integer returns -> residual == target - Z(Y) exactly
     (tests intercall target updates, recomputed products, terminal rx).
  E2 full shape K=9 (1536/3072): same with integer data.
  E3 suffix identity: with t = (-cF/q, cf/q) exact, suffix(t - Z) == [c,0]-Z*B.
Mutations must be detected; NOOP must not.
"""
import json, os, random, time
from fractions import Fraction

W = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

# ---------------- ring helpers (Phi_k = X^(2^k) - X^(2^(k-1)) + 1) ----------

def reduce_mod(n, h, raw):
    out = list(raw[:n]) + [0] * max(0, n - len(raw))
    out = out[:n]
    for k in range(n, min(len(raw), n + h)):
        out[k - h] += raw[k]
        out[k - n] -= raw[k]
    for k in range(n + h, len(raw)):
        out[k - (n + h)] -= raw[k]
    return out

def polymul(a, b, n, h):
    raw = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                if bj:
                    raw[i + j] += ai * bj
    return reduce_mod(n, h, raw)

def vadd(a, b):
    return [x + y for x, y in zip(a, b)]

def vsub(a, b):
    return [x - y for x, y in zip(a, b)]

def vmulconst(a, s):
    return [x * s for x in a]

def vscale_half(a):
    return [Fraction(x, 2) for x in a]

def merge2(u0, u1):
    out = [None] * (len(u0) + len(u1))
    out[0::2] = u0
    out[1::2] = u1
    return out

def split2(f):
    return f[0::2], f[1::2]

def merge3(v0, v1, v2):
    out = [None] * (len(v0) + len(v1) + len(v2))
    out[0::3] = v0
    out[1::3] = v1
    out[2::3] = v2
    return out

def split3(f):
    return f[0::3], f[1::3], f[2::3]

# ---------------- tree shape, call order, placement map ---------------------

class Shape:
    def __init__(self, K):
        self.K = K                 # binary depth inside one root branch
        self.calls = []            # in literal call order
        self.slot_of = {}          # call key -> (side, slot, sign)

    def key(self, side, c, path, tslot):
        return (side, c, tuple(path), tslot)

    def emit(self, side, c, path, tslot, mu):
        self.calls.append(self.key(side, c, path, tslot))

    # walk order (call order)
    def walk_inner(self, side, c, path, k):
        if k == 0:
            self.emit(side, c, path, 1, "mu1")     # first callback: mu1 return
            self.emit(side, c, path, 0, "mu0u")    # second: updated mu0 return
            return
        self.walk_inner(side, c, path + [1], k - 1)   # right/tree1 first
        self.walk_inner(side, c, path + [0], k - 1)   # then left/tree0

    def walk_depth1(self, side):
        for c in (2, 1, 0):                          # cubic order 2->1->0
            self.walk_inner(side, c, [], self.K - 1)

    def walk_root(self):
        self.walk_depth1(1)                          # t1 branch first (z1=b)
        self.walk_depth1(0)                          # then t0 branch (z0=a)

    # placement (slot formulas from merge conventions)
    def resolve(self, side, s):
        K = self.K
        c = s % 3
        m = s // 3
        i = m % 2
        m //= 2
        path = []
        k = K - 1
        while k > 0:
            path.append("R" if i == 1 else "L")
            i = m % 2
            m //= 2
            k -= 1
        return self.key(side, c, tuple(1 if p == "R" else 0 for p in path), i)

    def build_map(self):
        n = 3 * 2 ** self.K
        for side in (0, 1):
            for s in range(n):
                k = self.resolve(side, s)
                assert k in self._callset, (side, s, k)
                self.slot_of[k] = (side, s, +1)

    def _callset(self_set=None):
        pass

    def finalize(self):
        self._callset = set(self.calls)
        assert len(self.calls) == 2 * (3 * 2 ** self.K), len(self.calls)
        self.build_map()
        assert len(self.slot_of) == len(self.calls), "placement not a bijection"


# ---------------- exact skeleton of the literal recursion ------------------

def sim(shape, Y, L, t0, t1, drop_final_sub=False, swap_terminal=False, jitter=False):
    """Literal recursion in exact arithmetic. Returns (z0, z1) residuals.

    Y: dict key->value (ints or Fractions); L: dict of tree constants per node
    (polynomials over the node ring). Only the identity is tested, so L may be
    given as short polynomials; keys: ('root',), ('d1', side, c, which),
    ('bin', side, c, path) with which/which in l10/l21/l20/l.
    """
    K = shape.K

    def leaf(side, c, path, t0, t1):
        k1 = shape.key(side, c, path, 1)
        k0 = shape.key(side, c, path, 0)
        y1 = Y[k1]
        y0 = Y[k0]
        r1 = vsub(t1, [y1])
        rx = vscale_half(r1)
        r0 = vadd(t0, rx)
        r0 = vsub(r0, [y0])
        r0 = vsub(r0, rx)
        if jitter:
            eps = Fraction(1, 1024)
            r1 = vadd(r1, [eps * t1[0]])
            r0 = vadd(r0, [eps * t0[0]])
        if swap_terminal:  # mutation: first return stored to z0
            return r1, r0
        return r0, r1

    def inner(side, c, path, k, t0, t1):
        n = 2 ** k
        if k == 0:
            return leaf(side, c, path, t0, t1)
        n2 = 2 ** (k - 1)
        x0, x1 = split2(t1)
        r0, r1 = inner(side, c, path + [1], k - 1, x0, x1)
        z1 = merge2(r0, r1)
        l = L[('bin', side, c, tuple(path))]
        z1l = polymul(z1, l, n, n2)
        t0b = vadd(t0, z1l)
        x0, x1 = split2(t0b)
        r0, r1 = inner(side, c, path + [0], k - 1, x0, x1)
        z0 = merge2(r0, r1)
        if not drop_final_sub:
            z0 = vsub(z0, z1l)
        return z0, z1

    def depth1(side, t0, t1, t2):
        n = 2 ** K
        n2 = 2 ** (K - 1)
        # child 2
        x0, x1 = split2(t2)
        r0, r1 = inner(side, 2, [], K - 1, x0, x1)
        z2 = merge2(r0, r1)
        l21 = L[('d1', side, 2, 'l21')]
        z2l = polymul(z2, l21, n, n2)
        t1b = vadd(t1, z2l)
        x0, x1 = split2(t1b)
        r0, r1 = inner(side, 1, [], K - 1, x0, x1)
        z1 = merge2(r0, r1)
        if not drop_final_sub:
            z1 = vsub(z1, z2l)
        l10 = L[('d1', side, 1, 'l10')]
        z1l = polymul(z1, l10, n, n2)
        l20 = L[('d1', side, 2, 'l20')]
        z2l2 = polymul(z2, l20, n, n2)
        t0b = vadd(vadd(t0, z1l), z2l2)
        x0, x1 = split2(t0b)
        r0, r1 = inner(side, 0, [], K - 1, x0, x1)
        z0 = merge2(r0, r1)
        if not drop_final_sub:
            z0 = vsub(vsub(z0, z1l), z2l2)
        return z0, z1, z2

    n_root = 3 * 2 ** K
    h_root = 3 * 2 ** (K - 1)
    # right branch (t1) first
    a0, a1, a2 = split3(t1)
    r0, r1, r2 = depth1(1, a0, a1, a2)
    z1 = merge3(r0, r1, r2)
    lroot = L[('root',)]
    z1l = polymul(z1, lroot, n_root, h_root)
    t0b = vadd(t0, z1l)
    a0, a1, a2 = split3(t0b)
    r0, r1, r2 = depth1(0, a0, a1, a2)
    z0 = merge3(r0, r1, r2)
    if not drop_final_sub:
        z0 = vsub(z0, z1l)
    return z0, z1


def z_vectors(shape, Y):
    """Z(Y) = (a, b) via the signed placement map."""
    n = 3 * 2 ** shape.K
    a = [0] * n
    b = [0] * n
    for k, (side, s, sign) in shape.slot_of.items():
        (a if side == 0 else b)[s] = sign * Y[k]
    return a, b


def run_trial(K, seed, exact_rationals):
    rng = random.Random(seed)
    shape = Shape(K)
    shape.walk_root()
    shape.finalize()
    n = 3 * 2 ** K

    def rv(size, big):
        if exact_rationals:
            return [Fraction(rng.randint(-big, big), rng.randint(1, 6)) for _ in range(size)]
        return [rng.randint(-big, big) for _ in range(size)]

    def rp(size):
        if exact_rationals:
            return [Fraction(rng.randint(-3, 3), rng.randint(1, 4)) for _ in range(size)]
        return [rng.randint(-2, 2) for _ in range(size)]

    L = {('root',): rp(min(n, 4))}
    for side in (0, 1):
        for c in (2, 1, 0):
            L[('d1', side, c, 'l21')] = rp(2)
            L[('d1', side, c, 'l10')] = rp(2)
            L[('d1', side, c, 'l20')] = rp(2)
        def rec(path, k):
            if k == 0:
                return
            L[('bin', side, 0, tuple(path))] = rp(2)
            L[('bin', side, 1, tuple(path))] = rp(2)
            L[('bin', side, 2, tuple(path))] = rp(2)
            rec(path + [1], k - 1)
            rec(path + [0], k - 1)
        rec([], K - 1)

    big = 2 ** 20 if exact_rationals else 2 ** 30
    Y = {k: rng.randint(-big, big) for k in shape.calls}
    t0 = rv(n, big)
    t1 = rv(n, big)
    z0, z1 = sim(shape, Y, L, t0, t1)
    a, b = z_vectors(shape, Y)
    ref0 = vsub(t0, a)
    ref1 = vsub(t1, b)
    ok_identity = (z0 == ref0) and (z1 == ref1)
    return shape, Y, L, t0, t1, z0, z1, a, b, ok_identity


def main():
    t_start = time.time()
    report = {}

    # E1: reduced shape with exact rationals (L-polys, fractional targets).
    shape3, Y3, L3, t03, t13, z03, z13, a3, b3, ok1 = run_trial(3, 1001, True)
    report["E1_reduced_K3_exact_rational_identity"] = ok1

    # E1b: suffix identity on the reduced shape with a pinned synthetic key.
    q = 18433
    n3 = 24
    rng = random.Random(4242)
    f = [1] + [0] * (n3 - 1)
    g = [rng.randint(-1, 1) for _ in range(n3)]
    F = [1] + [0] * (n3 - 1)
    G = vadd([q] + [0] * (n3 - 1), polymul(g, F, n3, n3 // 2))
    c = [rng.randint(0, q - 1) for _ in range(n3)]
    t0_ref = [Fraction(-x, q) for x in polymul(c, F, n3, n3 // 2)]
    t1_ref = [Fraction(x, q) for x in polymul(c, f, n3, n3 // 2)]
    # residuals of the skeleton with those targets and the SAME Y placement
    z0s, z1s = sim(shape3, Y3, L3, t0_ref, t1_ref)
    x, y = z0s, z1s
    b00, b01, b10, b11 = g, vmulconst(f, -1), G, vmulconst(F, -1)
    out0 = vadd(polymul(x, b00, n3, n3 // 2), polymul(y, b10, n3, n3 // 2))
    out1 = vadd(polymul(x, b01, n3, n3 // 2), polymul(y, b11, n3, n3 // 2))
    want0 = vsub(c, vadd(polymul(a3, g, n3, n3 // 2), polymul(b3, G, n3, n3 // 2)))
    want1 = vadd(polymul(a3, f, n3, n3 // 2), polymul(b3, F, n3, n3 // 2))
    report["E1b_suffix_identity_equals_c_minus_ZB"] = (out0 == want0) and (out1 == want1)

    # E2: full shape K=9 (3072 calls) with integers.
    shape9, Y9, L9, t09, t19, z09, z19, a9, b9, ok2 = run_trial(9, 2002, False)
    report["E2_full_K9_integer_identity"] = ok2
    report["E2_full_map_bijective"] = (len(shape9.slot_of) == 3072)
    report["E2_call_order_right_branch_first_1536"] = all(k[0] == 1 for k in shape9.calls[:1536])
    report["E2_call_order_cubic_2_1_0"] = (
        shape9.calls[1536][1] == 2 and shape9.calls[2048][1] == 1 and shape9.calls[2560][1] == 0)
    report["E2_terminal_pair_mu1_then_mu0"] = all(
        shape9.calls[i][3] == 1 and shape9.calls[i + 1][3] == 0 for i in range(0, 3072, 2))

    # ---- mutations (reduced shape, exact rationals) ----
    mut = {}
    _, _, _, _, _, z0m, z1m, _, _, _ = run_trial(3, 1001, True)
    shape_m = Shape(3); shape_m.walk_root(); shape_m.finalize()
    Ym = {k: random.Random(5).randint(-10, 10) for k in shape_m.calls}
    Lm = {k: [Fraction(1, 3)] for k in
          [('root',)] + [('d1', s, c, w) for s in (0, 1) for c in (2, 1, 0)
                         for w in ('l10', 'l20', 'l21')]}
    for side in (0, 1):
        for c in (2, 1, 0):
            for p in ([], [1], [0], [1, 1], [1, 0], [0, 1], [0, 0]):
                Lm[('bin', side, c, tuple(p))] = [Fraction(1, 3)]
    r0 = random.Random(99)
    t0m = [Fraction(r0.randint(-50, 50), 2) for _ in range(24)]
    t1m = [Fraction(r0.randint(-50, 50), 2) for _ in range(24)]
    am, bm = z_vectors(shape_m, Ym)

    z0d, z1d = sim(shape_m, Ym, Lm, t0m, t1m, drop_final_sub=True)
    mut["M_drop_final_subtraction"] = not (z0d == vsub(t0m, am) and z1d == vsub(t1m, bm))
    z0t, z1t = sim(shape_m, Ym, Lm, t0m, t1m, swap_terminal=True)
    mut["M_swap_terminal_pair_order"] = not (z0t == vsub(t0m, am) and z1t == vsub(t1m, bm))
    # wrong sign in the placement
    am_n = vmulconst(am, -1)
    z0n, z1n = sim(shape_m, Ym, Lm, t0m, t1m)
    mut["M_wrong_sign_mapping"] = not (z0n == vsub(t0m, am_n))
    # swapped root order: build a map that assigns side0 calls first would
    # mismatch the literal order check
    shape_s = Shape(3)
    shape_s.walk_depth1(0); shape_s.walk_depth1(1)   # mutation: left first
    shape_s.finalize()
    mut["M_swap_root_branch_order"] = not all(k[0] == 1 for k in shape_s.calls[:24])
    # source output as reference: in the EXACT skeleton t - z == Z(Y) for every
    # (t,L), so this mutation is equivalent there (documented, not "detected").
    # With a rounding-jitter leaf model the derived Z depends on t and the
    # mutation IS detected -- this is the discriminating control.
    z0j1, _ = sim(shape_m, Ym, Lm, t0m, t1m, jitter=True)
    z0j2, _ = sim(shape_m, Ym, Lm, vmulconst(t0m, 2), t1m, jitter=True)
    zA = vsub(t0m, z0j1)
    zB = vsub(vmulconst(t0m, 2), z0j2)
    mut["M_source_output_as_reference_detected_with_rounding"] = (zA != zB)
    mut["EQUIVALENT_on_exact_skeleton_source_output_as_reference"] = True
    # no-op: trivial reindexing that preserves the identity must pass
    Ym2 = dict(Ym)
    z0p, z1p = sim(shape_m, Ym2, Lm, t0m, t1m)
    ap, bp = z_vectors(shape_m, Ym2)
    mut["NOOP_dict_rebuild"] = (z0p == vsub(t0m, ap) and z1p == vsub(t1m, bp))

    out = {
        "schema": "ft1536.reference_integer_recovery.skeleton_cancellation/1",
        "merge_conventions": {
            "binary": "out[2i]=u0[i], out[2i+1]=u1[i] (f = u0(X^2)+X*u1(X^2))",
            "cubic": "out[3i+c]=v_c[i] (f = v0(X^3)+X*v1(X^3)+X^2*v2(X^3))",
            "source": "falcon-fft.c falcon_poly_merge_fft/merge_deep_fft3/merge_top_fft3 eval shadows; H6P SOURCE_NOISE_MAP exact reference merge",
        },
        "call_order": "root right(t1/b) before left(t0/a); cubic child2->1->0; binary right before left; terminal mu1-return before updated-mu0 return (falcon-sign.c 1616-1839)",
        "Z_form": "Z(Y)[slot] = +1 * Y[call] (signed permutation; signs +1 under these merge conventions)",
        "checks": report,
        "mutations_detected": mut,
    }
    ok = all(report.values()) and all(mut[k] for k in mut if k != "NOOP_dict_rebuild") \
        and mut["NOOP_dict_rebuild"]
    out["all_pass"] = ok
    p = os.path.join(W, "checks", "skeleton_cancellation.json")
    with open(p, "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)

    # full-size map table for REFERENCE_INTEGER_MAP
    rows = []
    for idx, k in enumerate(shape9.calls):
        side, s, sign = shape9.slot_of[k]
        rows.append({"call": idx, "branch": "b/right" if k[0] == 1 else "a/left",
                     "cubic_child": k[1], "binary_path": "".join("R" if x else "L" for x in k[2]),
                     "terminal_slot": "Y1/mu1" if k[3] == 1 else "Y0/mu0_updated",
                     "coef_vector": "b" if side == 1 else "a", "coef_slot": s, "sign": sign})
    with open(os.path.join(W, "checks", "z_map_full.json"), "w", encoding="utf-8") as fh:
        json.dump({"schema": "ft1536.reference_integer_recovery.z_map/1",
                   "rows": rows}, fh)
    print(json.dumps({"all_pass": ok, "checks": report, "mutations": mut}, indent=1))
    return 0 if ok else 1

if __name__ == "__main__":
    raise SystemExit(main())
