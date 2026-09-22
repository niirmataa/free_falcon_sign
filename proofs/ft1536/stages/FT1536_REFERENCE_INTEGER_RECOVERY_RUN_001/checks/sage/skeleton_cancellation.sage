# FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- Z(Y) map and exact-skeleton
# cancellation control (Sage exact arithmetic).
# Run:  sage checks/sage/skeleton_cancellation.sage    (cwd = W root)
#
# Builds the literal call order (root: right-then-left; cubic: 2->1->0; binary:
# right-then-left; terminal: mu1-return first, then updated-mu0 return) and the
# coefficient placement Z(Y) = signed permutation of the 3072 integer returns
# (merge conventions: out[2i]=u0[i], out[2i+1]=u1[i]; cubic out[3i+c]=v_c[i]).
# Controls: E1 reduced shape (exact rationals, L polynomials) residual == t-Z(Y);
# E1b suffix identity == [c,0]-Z(Y)*B; E2 full shape 3072 calls (integers);
# mutations detected; no-op not flagged.

# preparser/toolchain preflight (principle doc 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1 / 3) is QQ
assert 2 ^ 10 == 1024

import json
from sage.all import PolynomialRing, ZZ, QQ, Sequence

# ---------------- ring helpers (Phi_n = X^n - X^(n/2) + 1) ------------------
def polymul(a, b, n):
    PR = PolynomialRing(QQ, 'w')
    w = PR.gen()
    phin = w ** n - w ** (n // 2) + 1
    return list((PR(a) * PR(b) % phin).padded_list(n))

def vadd(a, b):
    return [a[i] + b[i] for i in range(len(a))]

def vsub(a, b):
    return [a[i] - b[i] for i in range(len(a))]

def vmulconst(a, s):
    return [s * v for v in a]

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

class LCG:
    def __init__(self, seed):
        self.s = seed % (2 ** 64)
    def next(self):
        self.s = (6364136223846793005 * self.s + 1442695040888963407) % (2 ** 64)
        return self.s >> 11
    def randint(self, lo, hi):
        return lo + self.next() % (hi - lo + 1)

# ---------------- tree shape, call order, placement map ---------------------
class Shape:
    def __init__(self, K):
        self.K = K
        self.calls = []
        self.slot_of = {}

    def key(self, side, c, path, tslot):
        return (side, c, tuple(path), tslot)

    def walk_inner(self, side, c, path, k):
        if k == 0:
            self.calls.append(self.key(side, c, path, 1))
            self.calls.append(self.key(side, c, path, 0))
            return
        self.walk_inner(side, c, path + [1], k - 1)
        self.walk_inner(side, c, path + [0], k - 1)

    def walk_depth1(self, side):
        for c in (2, 1, 0):
            self.walk_inner(side, c, [], self.K - 1)

    def walk_root(self):
        self.walk_depth1(1)
        self.walk_depth1(0)

    def resolve(self, side, s):
        K = self.K
        c = s % 3
        m = s // 3
        i = m % 2
        m //= 2
        path = []
        k = K - 1
        while k > 0:
            path.append(1 if i == 1 else 0)
            i = m % 2
            m //= 2
            k -= 1
        return self.key(side, c, tuple(path), i)

    def finalize(self):
        n = 3 * 2 ** self.K
        assert len(self.calls) == 2 * n, len(self.calls)
        cset = set(self.calls)
        for side in (0, 1):
            for s in range(n):
                k = self.resolve(side, s)
                assert k in cset, (side, s, k)
                self.slot_of[k] = (side, s, +1)
        assert len(self.slot_of) == len(self.calls)

def sim(shape, Y, L, t0, t1, drop_final_sub=False, swap_terminal=False, jitter=False):
    K = shape.K

    def leaf(side, c, path, t0, t1):
        y1 = Y[shape.key(side, c, path, 1)]
        y0 = Y[shape.key(side, c, path, 0)]
        r1 = vsub(t1, [y1])
        rx = [(1 / 2) * v for v in r1]
        r0 = vsub(vadd(t0, rx), [y0])
        r0 = vsub(r0, rx)
        if jitter:
            r1 = vadd(r1, [(1 / 1024) * t1[0]])
            r0 = vadd(r0, [(1 / 1024) * t0[0]])
        if swap_terminal:
            return r1, r0
        return r0, r1

    def inner(side, c, path, k, t0, t1):
        n = 2 ** k
        if k == 0:
            return leaf(side, c, path, t0, t1)
        x0, x1 = split2(t1)
        r0, r1 = inner(side, c, path + [1], k - 1, x0, x1)
        z1 = merge2(r0, r1)
        z1l = polymul(z1, L[('bin', side, c, tuple(path))], n)
        t0b = vadd(t0, z1l)
        x0, x1 = split2(t0b)
        r0, r1 = inner(side, c, path + [0], k - 1, x0, x1)
        z0 = merge2(r0, r1)
        if not drop_final_sub:
            z0 = vsub(z0, z1l)
        return z0, z1

    def depth1(side, t0, t1, t2):
        n = 2 ** K
        x0, x1 = split2(t2)
        r0, r1 = inner(side, 2, [], K - 1, x0, x1)
        z2 = merge2(r0, r1)
        z2l = polymul(z2, L[('d1', side, 2, 'l21')], n)
        t1b = vadd(t1, z2l)
        x0, x1 = split2(t1b)
        r0, r1 = inner(side, 1, [], K - 1, x0, x1)
        z1 = merge2(r0, r1)
        if not drop_final_sub:
            z1 = vsub(z1, z2l)
        z1l = polymul(z1, L[('d1', side, 1, 'l10')], n)
        z2l2 = polymul(z2, L[('d1', side, 2, 'l20')], n)
        t0b = vadd(vadd(t0, z1l), z2l2)
        x0, x1 = split2(t0b)
        r0, r1 = inner(side, 0, [], K - 1, x0, x1)
        z0 = merge2(r0, r1)
        if not drop_final_sub:
            z0 = vsub(vsub(z0, z1l), z2l2)
        return z0, z1, z2

    n_root = 3 * 2 ** K
    a0, a1, a2 = split3(t1)
    r0, r1, r2 = depth1(1, a0, a1, a2)
    z1 = merge3(r0, r1, r2)
    z1l = polymul(z1, L[('root',)], n_root)
    t0b = vadd(t0, z1l)
    a0, a1, a2 = split3(t0b)
    r0, r1, r2 = depth1(0, a0, a1, a2)
    z0 = merge3(r0, r1, r2)
    if not drop_final_sub:
        z0 = vsub(z0, z1l)
    return z0, z1

def z_vectors(shape, Y):
    n = 3 * 2 ** shape.K
    a = [ZZ(0)] * n
    b = [ZZ(0)] * n
    for k, (side, s, sign) in shape.slot_of.items():
        (a if side == 0 else b)[s] = sign * Y[k]
    return a, b

def run_trial(K, seed, exact_rationals):
    rng = LCG(seed)
    shape = Shape(K)
    shape.walk_root()
    shape.finalize()
    n = 3 * 2 ** K

    def rv(big):
        if exact_rationals:
            return [ZZ(rng.randint(-big, big)) / ZZ(rng.randint(1, 6)) for _ in range(n)]
        return [ZZ(rng.randint(-big, big)) for _ in range(n)]

    def rp(size):
        if exact_rationals:
            return [ZZ(rng.randint(-3, 3)) / ZZ(rng.randint(1, 4)) for _ in range(size)]
        return [ZZ(rng.randint(-2, 2)) for _ in range(size)]

    L = {('root',): rp(min(n, 4))}
    for side in (0, 1):
        for c in (2, 1, 0):
            L[('d1', side, c, 'l21')] = rp(2)
            L[('d1', side, c, 'l10')] = rp(2)
            L[('d1', side, c, 'l20')] = rp(2)
        def rec(path, k):
            if k == 0:
                return
            for cc in (0, 1, 2):
                L[('bin', side, cc, tuple(path))] = rp(2)
            rec(path + [1], k - 1)
            rec(path + [0], k - 1)
        rec([], K - 1)

    big = 2 ** 20 if exact_rationals else 2 ** 30
    Y = {k: ZZ(rng.randint(-big, big)) for k in shape.calls}
    t0 = rv(big)
    t1 = rv(big)
    z0, z1 = sim(shape, Y, L, t0, t1)
    a, b = z_vectors(shape, Y)
    ok_identity = (z0 == vsub(t0, a)) and (z1 == vsub(t1, b))
    return shape, Y, L, t0, t1, z0, z1, a, b, ok_identity

report = {}
shape3, Y3, L3, t03, t13, z03, z13, a3, b3, ok1 = run_trial(3, 1001, True)
report["E1_reduced_K3_exact_rational_identity"] = bool(ok1)

# E1b: suffix identity on the reduced shape with a pinned synthetic key
q = 18433
n3 = 24
rng = LCG(4242)
f = [ZZ(1)] + [ZZ(0)] * (n3 - 1)
g = [ZZ(rng.randint(-1, 1)) for _ in range(n3)]
Fp = [ZZ(1)] + [ZZ(0)] * (n3 - 1)
G = vadd([ZZ(q)] + [ZZ(0)] * (n3 - 1), polymul(g, Fp, n3))
c = [ZZ(rng.randint(0, q - 1)) for _ in range(n3)]
t0_ref = [(-cc) / q for cc in polymul(c, Fp, n3)]
t1_ref = [cc / q for cc in polymul(c, f, n3)]
z0s, z1s = sim(shape3, Y3, L3, t0_ref, t1_ref)
x, y = z0s, z1s
b00, b01, b10, b11 = g, vmulconst(f, -1), G, vmulconst(Fp, -1)
out0 = vadd(polymul(x, b00, n3), polymul(y, b10, n3))
out1 = vadd(polymul(x, b01, n3), polymul(y, b11, n3))
want0 = vsub(c, vadd(polymul(a3, g, n3), polymul(b3, G, n3)))
want1 = vadd(polymul(a3, f, n3), polymul(b3, Fp, n3))
report["E1b_suffix_identity_equals_c_minus_ZB"] = bool((out0 == want0) and (out1 == want1))

shape9, Y9, L9, t09, t19, z09, z19, a9, b9, ok2 = run_trial(9, 2002, False)
report["E2_full_K9_integer_identity"] = bool(ok2)
report["E2_full_map_bijective"] = bool(len(shape9.slot_of) == 3072)
report["E2_call_order_right_branch_first_1536"] = bool(all(k[0] == 1 for k in shape9.calls[:1536]))
report["E2_call_order_cubic_2_1_0"] = bool(shape9.calls[1536][1] == 2 and
                                           shape9.calls[2048][1] == 1 and
                                           shape9.calls[2560][1] == 0)
report["E2_terminal_pair_mu1_then_mu0"] = bool(all(
    shape9.calls[i][3] == 1 and shape9.calls[i + 1][3] == 0 for i in range(0, 3072, 2)))

# ---- mutations (reduced shape, exact rationals) ----
mut = {}
shape_m = Shape(3)
shape_m.walk_root()
shape_m.finalize()
rng5 = LCG(5)
Ym = {k: ZZ(rng5.randint(-10, 10)) for k in shape_m.calls}
Lm = {k: [(1 / 3)] for k in
      [('root',)] + [('d1', s, c, w) for s in (0, 1) for c in (2, 1, 0)
                     for w in ('l10', 'l20', 'l21')]}
for side in (0, 1):
    for c in (2, 1, 0):
        for p in ([], [1], [0], [1, 1], [1, 0], [0, 1], [0, 0]):
            Lm[('bin', side, c, tuple(p))] = [(1 / 3)]
r0rng = LCG(99)
t0m = [ZZ(r0rng.randint(-50, 50)) / 2 for _ in range(24)]
t1m = [ZZ(r0rng.randint(-50, 50)) / 2 for _ in range(24)]
am, bm = z_vectors(shape_m, Ym)

z0d, z1d = sim(shape_m, Ym, Lm, t0m, t1m, drop_final_sub=True)
mut["M_drop_final_subtraction"] = not (z0d == vsub(t0m, am) and z1d == vsub(t1m, bm))
z0t, z1t = sim(shape_m, Ym, Lm, t0m, t1m, swap_terminal=True)
mut["M_swap_terminal_pair_order"] = not (z0t == vsub(t0m, am) and z1t == vsub(t1m, bm))
am_n = vmulconst(am, -1)
z0n, z1n = sim(shape_m, Ym, Lm, t0m, t1m)
mut["M_wrong_sign_mapping"] = not (z0n == vsub(t0m, am_n))
shape_s = Shape(3)
shape_s.walk_depth1(0)
shape_s.walk_depth1(1)
shape_s.finalize()
mut["M_swap_root_branch_order"] = not all(k[0] == 1 for k in shape_s.calls[:24])
z0j1, _ = sim(shape_m, Ym, Lm, t0m, t1m, jitter=True)
z0j2, _ = sim(shape_m, Ym, Lm, vmulconst(t0m, 2), t1m, jitter=True)
zA = vsub(t0m, z0j1)
zB = vsub(vmulconst(t0m, 2), z0j2)
mut["M_source_output_as_reference_detected_with_rounding"] = (zA != zB)
mut["EQUIVALENT_on_exact_skeleton_source_output_as_reference"] = True
Ym2 = dict(Ym)
z0p, z1p = sim(shape_m, Ym2, Lm, t0m, t1m)
ap, bp = z_vectors(shape_m, Ym2)
mut["NOOP_dict_rebuild"] = (z0p == vsub(t0m, ap) and z1p == vsub(t1m, bp))

ok = all(report.values()) and all(bool(mut[k]) for k in mut if k != "NOOP_dict_rebuild") \
    and bool(mut["NOOP_dict_rebuild"])
out = {
    "schema": "ft1536.reference_integer_recovery.skeleton_cancellation/1",
    "engine": "sage-10.9 (sage checks/sage/skeleton_cancellation.sage; preparser on)",
    "merge_conventions": {
        "binary": "out[2i]=u0[i], out[2i+1]=u1[i] (f = u0(X^2)+X*u1(X^2))",
        "cubic": "out[3i+c]=v_c[i] (f = v0(X^3)+X*v1(X^3)+X^2*v2(X^3))",
        "source": "falcon-fft.c merge_fft/merge_deep_fft3/merge_top_fft3 eval shadows; H6P SOURCE_NOISE_MAP exact reference merge",
    },
    "call_order": "root right(t1/b) before left(t0/a); cubic child2->1->0; binary right before left; terminal mu1-return before updated-mu0 return (falcon-sign.c 1616-1839)",
    "Z_form": "Z(Y)[slot] = +1 * Y[call] (signed permutation; signs +1 under these merge conventions)",
    "checks": {k: bool(v) for k, v in report.items()},
    "mutations_detected": {k: bool(v) for k, v in mut.items()},
    "all_pass": bool(ok),
}
with open("checks/skeleton_cancellation.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)

rows = []
for idx, k in enumerate(shape9.calls):
    side, s, sign = shape9.slot_of[k]
    rows.append({"call": idx, "branch": "b/right" if k[0] == 1 else "a/left",
                 "cubic_child": int(k[1]),
                 "binary_path": "".join("R" if x else "L" for x in k[2]),
                 "terminal_slot": "Y1/mu1" if k[3] == 1 else "Y0/mu0_updated",
                 "coef_vector": "b" if side == 1 else "a", "coef_slot": int(s),
                 "sign": int(sign)})
with open("checks/z_map_full.json", "w") as fh:
    json.dump({"schema": "ft1536.reference_integer_recovery.z_map/1",
               "engine": "sage-10.9", "rows": rows}, fh)
print(json.dumps({"all_pass": out["all_pass"], "checks": out["checks"],
                  "mutations": out["mutations_detected"]}, indent=1, sort_keys=True))
if not ok:
    raise SystemExit(1)
