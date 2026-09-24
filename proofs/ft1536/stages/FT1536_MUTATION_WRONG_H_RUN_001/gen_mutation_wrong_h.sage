# FT1536 T03 mutation M_wrong_h_relation -> Lean kernel counterexample.
# Run: sage gen_mutation_wrong_h.sage  (SageMath preparser mode, Sage 10.9)
#
# Faithful replication of the PYTHON control
#   stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001/scripts/py_crosscheck/exact_ring_checks.py
# (plain-int list arithmetic mod Phi = X^1536-X^768+1, q = 18433), mutation block
# seeds Random(7)/Random(8)/Random(20260922). All generation arithmetic uses
# Python ints (int() hygiene against the .sage preparser); a Sage-native
# quotient-ring cross-check is done separately on int-normalized vectors.
# Output: MutationWrongHSmall.lean (ops + pinned N=6 literals + theorems),
# verified by `lean MutationWrongHSmall.lean`. The 1536-parameter instance
# stays exact-Python + Sage-native verified (see asserts below + README).
# Scope: kernelizes the key-relation leg of M_wrong_h (h_wrong*f != g) and the
# full conjunction ¬(A /\ congruent) on the pinned instance. Synthetic-key
# control, NOT Emitted membership (per frozen scope).

import random
import json
import hashlib

N = int(1536)
Q = int(18433)

# ---------------- verbatim arithmetic from exact_ring_checks.py ----------------

def zero():
    return [0] * N

def add(a, b):
    return [(x + y) for x, y in zip(a, b)]

def sub(a, b):
    return [(x - y) for x, y in zip(a, b)]

def neg(a):
    return [-x for x in a]

def reduce_raw(c):
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

def modq(a):
    return [x % Q for x in a]

def fmulq(a, b):
    return modq(mul(modq(a), modq(b)))

def fsubq(a, b):
    return [(x - y) % Q for x, y in zip(a, b)]

def fq_equal(a, b):
    return all((x - y) % Q == 0 for x, y in zip(a, b))

def rand_ternary(rng, full=True):
    lo = -1 if full else 0
    return [rng.randint(lo, 1) for _ in range(N)]

def poly_xgcd(a, b):
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
        inv = pow(int(b[db]), int(Q) - 2, int(Q))
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

def degf(p):
    d = len(p) - 1
    while d >= 0 and p[d] % Q == 0:
        d -= 1
    return d

def invert_mod_phi_q(f):
    phi = [0] * (N + 1)
    phi[0] = 1
    phi[N // 2] = -1
    phi[N] = 1
    g, s, t = poly_xgcd(phi, f)
    if degf(g) != 0:
        return None
    invc = pow(int(g[0]), int(Q) - 2, int(Q))
    one = [1] + [0] * (N - 1)
    for cand0 in (s, t):
        for sgn in (1, -1):
            cand = pad([((sgn * invc) * xi) % Q for xi in cand0])
            if fmulq(cand, f) == one:
                return cand
    return None

def build_key(rng, degenerate=False):
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
                Xj[0] -= ji
                Xj[N // 2] += ji
    one = [1] + [0] * (N - 1)
    qq = [Q] + [0] * (N - 1)
    f = add(one, Xj)
    g = list(Xj)
    F = sub([Q - 1] + [0] * (N - 1), Xj)
    G = sub(qq, Xj)
    finv = invert_mod_phi_q(f)
    assert finv is not None, "synthetic f not invertible mod (q,Phi)"
    h = fmulq(g, finv)
    return f, g, F, G, h

def congruent(a, b, c, g, G, f, F, h):
    v1 = sub(c, add(mul(a, g), mul(b, G)))
    v2 = add(mul(a, f), mul(b, F))
    lhs = fsubq(modq(add(v1, fmulq(h, v2))), modq(c))
    return all(x % Q == 0 for x in lhs)

# ---------------- replicate trial draw order (seeds pinned by frozen .py) ----------------
rng = random.Random(int(20260922))
for trial, degenerate in enumerate([True, False]):
    f_t, g_t, F_t, G_t, h_t = build_key(rng, degenerate=degenerate)
    for k in range(3):
        Y = [rng.randint(int(-2 ** 30), int(2 ** 30)) for _ in range(N)]
        Zv = [rng.choice([-1, 1]) * y for y in Y]
        Wv = [rng.choice([-1, 1]) * y for y in Y]
        a_t, b_t = Zv, Wv
        c_t = [rng.randint(0, Q - 1) for _ in range(N)]

# ---------------- mutation block, verbatim ----------------
f, g, F, G, h = build_key(random.Random(int(7)), degenerate=True)
g2 = rand_ternary(random.Random(int(8)), full=True)
a = [rng.randint(int(-2 ** 20), int(2 ** 20)) for _ in range(N)]
b = [rng.randint(int(-2 ** 20), int(2 ** 20)) for _ in range(N)]
c = [rng.randint(0, Q - 1) for _ in range(N)]

g2inv = invert_mod_phi_q(g2)
assert g2inv is not None, "g2 not invertible"
h_wrong = fmulq(f, g2inv)

A_holds = fq_equal(fmulq(h_wrong, f), modq(g))
B_holds = congruent(a, b, c, g, G, f, F, h_wrong)
M_detected = not (A_holds and B_holds)

# validity asserts on the replicated instance
det = sub(mul(f, G), mul(g, F))
assert det == [Q] + [0] * (N - 1), "C1 det identity"
assert fq_equal(fmulq(h, f), modq(g)), "C5 hf=g"
assert fq_equal(fmulq(h, F), modq(G)), "C5 hF=G"
assert congruent(a, b, c, g, G, f, F, h), "correct-h congruence must hold"
assert M_detected, "M_wrong_h must be detected"

# ---------------- small faithful instance for the Lean kernel ----------------
# Measured: full-1536 `decide` exceeds maxRecDepth 1000000 in Lean 4.34 core
# even with an index-based formulation short-circuiting at element 0
# (thunk-nested 1536-wide folds). The kernel therefore proves the SAME code
# shape at small parameters (N=6, q=17, Phi=X^6-X^3+1) with a pinned instance
# built by the IDENTICAL functions below (globals rebound); the 1536 instance
# stays exact-Python + Sage-native verified (asserts above + frozen PASS).
vecs = {k: [int(x) for x in v] for k, v in
        {"f": f, "g": g, "F": F, "G": G, "h_wrong": h_wrong,
         "a": a, "b": b, "c": c}.items()}
assert all(len(v) == N for v in vecs.values())
N0, Q0 = N, Q
N, Q = int(6), int(17)
rSmall = random.Random(int(1000))
fs, gs, Fs, Gs, hs = build_key(rSmall, degenerate=False)
assert invert_mod_phi_q(fs) is not None
g2s = rand_ternary(random.Random(int(1001)), full=True)
assert invert_mod_phi_q(g2s) is not None, "small g2 not invertible; reseed"
h_ws = fmulq(fs, invert_mod_phi_q(g2s))
a_s = [rSmall.randint(int(-2 ** 10), int(2 ** 10)) for _ in range(N)]
b_s = [rSmall.randint(int(-2 ** 10), int(2 ** 10)) for _ in range(N)]
c_s = [rSmall.randint(0, Q - 1) for _ in range(N)]
assert sub(mul(fs, Gs), mul(gs, Fs)) == [Q] + [0] * (N - 1), "small C1"
assert fq_equal(fmulq(hs, fs), modq(gs)), "small C5a"
assert fq_equal(fmulq(hs, Fs), modq(Gs)), "small C5b"
assert congruent(a_s, b_s, c_s, gs, Gs, fs, Fs, hs), "small correct-h"
A_s = fq_equal(fmulq(h_ws, fs), modq(gs))
B_s = congruent(a_s, b_s, c_s, gs, Gs, fs, Fs, h_ws)
assert not (A_s and B_s), "small M must be detected"
svecs = {k: [int(x) for x in v] for k, v in
         {"f": fs, "g": gs, "F": Fs, "G": Gs, "h_wrong": h_ws,
          "a": a_s, "b": b_s, "c": c_s}.items()}
N, Q = N0, Q0

# ---------------- index-based formulation (kernel-friendly) ----------------
# Same mathematics as reduce_raw/mul, but random-access per output index so
# that `decide` on list inequality short-circuits after forcing only the
# differing prefix. Asserted pointwise-equal to the frozen formulation here.

def getd(l, i):
    return l[i] if 0 <= i < len(l) else 0

def conv_at(a, b, k):
    return sum(getd(a, j) * getd(b, k - j) for j in range(k + 1))

def red_at(raw_len, raw, i):
    h = N // 2
    hi1 = min(raw_len, 3 * h)
    r = raw(i)
    if N <= i + h < hi1:
        r += raw(i + h)
    if i + N < hi1:
        r -= raw(i + N)
    if i + 3 * h < raw_len:
        r -= raw(i + 3 * h)
    return r

def idx_mul(a, b):
    raw_len = len(a) + len(b) - 1
    return [red_at(raw_len, lambda k, a=a, b=b: conv_at(a, b, k), i)
            for i in range(N)]

def idx_fmulq(a, b):
    return modq(idx_mul(modq(a), modq(b)))

assert idx_mul(vecs["h_wrong"], vecs["f"]) == mul(vecs["h_wrong"], vecs["f"])
assert idx_fmulq(vecs["h_wrong"], vecs["f"]) == fmulq(vecs["h_wrong"], vecs["f"])
assert idx_mul(vecs["a"], vecs["g"]) == mul(vecs["a"], vecs["g"])

# ---------------- Sage-native independent cross-check ----------------
from sage.all import ZZ, GF, PolynomialRing
Fq = GF(Q)
R = PolynomialRing(Fq, "x")
x = R.gen()
PHIF = x ** N - x ** (N // 2) + 1
Qring = R.quotient(PHIF)
def toQ(v):
    return Qring(R([Fq(int(t) % Q) for t in v]))
assert toQ(vecs["h_wrong"]) * toQ(vecs["f"]) - toQ(vecs["g"]) != 0, "native: key leg fails"
v1n = toQ(vecs["c"]) - (toQ(vecs["a"]) * toQ(vecs["g"]) + toQ(vecs["b"]) * toQ(vecs["G"]))
v2n = toQ(vecs["a"]) * toQ(vecs["f"]) + toQ(vecs["b"]) * toQ(vecs["F"])
assert v1n + toQ(vecs["h_wrong"]) * v2n - toQ(vecs["c"]) != 0, "native: conjunction fails"

# ---------------- frozen pins ----------------
STAGE = "/home/footfalcon/free_falcon_sign/proofs/ft1536/stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001"
frozen = {}
for rel in ["scripts/py_crosscheck/exact_ring_checks.py",
            "checks/sage/exact_ring_checks.sage",
            "checks/exact_ring_checks.json"]:
    with open(STAGE + "/" + rel, "rb") as fh:
        frozen[rel] = hashlib.sha256(fh.read()).hexdigest()

# ---------------- emit self-contained Lean file ----------------
def lean_list(v):
    return "[" + ", ".join(str(t) for t in v) + "]"

lean_template = """-- FT1536 T03 mutation M_wrong_h_relation: Lean kernel counterexample.
--
-- Pinned instance replicated from the frozen PYTHON control
--   scripts/py_crosscheck/exact_ring_checks.py
-- (mutation block seeds Random(7)/Random(8)/Random(20260922), degenerate key),
-- generated by gen_mutation_wrong_h.sage (plain-int replication + Sage-native
-- quotient-ring cross-check). The Lean file below verifies the detection
-- negation by `decide` on the pinned literals: no external oracle is used
-- in the proof itself.
--
-- Frozen pins (SHA-256):
--   scripts/py_crosscheck/exact_ring_checks.py: @@PIN_PY@@
--   checks/sage/exact_ring_checks.sage:        @@PIN_SAGE@@
--   checks/exact_ring_checks.json:             @@PIN_JSON@@
-- N = @@NN@@, q = @@QQ@@, Phi = X^N-X^(N/2)+1.
--
-- Scope: synthetic-key sensitivity control, NOT Emitted membership
-- (per frozen scope). Small faithful instance (N=6, q=17) of the frozen
-- 1536-parameter construction, built by the IDENTICAL code path (seeds
-- Random(1000)/Random(1001)); the full-1536 `decide` exceeds maxRecDepth
-- 1000000 in Lean 4.34 core (measured, see README), so the kernel proves
-- the same code shape here while the 1536 instance stays exact-Python +
-- Sage-native verified.
-- Kernelizes the M_wrong_h detection negation:
-- with the wrong public h, key relation AND congruence cannot both hold.
-- No placeholders, no extra axioms beyond Lean core.

set_option maxHeartbeats 1000000000
set_option maxRecDepth 8192

def Nn : Nat := @@NN@@
def Qq : Int := @@QQ@@

def modqL : List Int -> List Int := List.map (fun x => x % Qq)

def addL : List Int -> List Int -> List Int := List.zipWith (fun x y => x + y)

def subL : List Int -> List Int -> List Int := List.zipWith (fun x y => x - y)

def addPad : List Int -> List Int -> List Int
  | [], ys => ys
  | xs, [] => xs
  | x :: xs, y :: ys => (x + y) :: addPad xs ys

def mulRaw : List Int -> List Int -> List Int
  | [], _ => []
  | a :: as, b => if a == 0 then 0 :: mulRaw as b else addPad (b.map (fun t => a * t)) (0 :: mulRaw as b)

def getDL (l : List Int) (i : Nat) : Int := l.getD i 0

def addAt (l : List Int) (i : Nat) (d : Int) : List Int := l.set i (getDL l i + d)

def subAt (l : List Int) (i : Nat) (d : Int) : List Int := l.set i (getDL l i - d)

def foldRange (f : List Int -> Nat -> List Int) : Nat -> List Int -> Nat -> List Int
  | 0, s, _ => s
  | fuel + 1, s, k => foldRange f fuel (f s k) (k + 1)

def reduceRaw (c : List Int) : List Int :=
  let base := (c.take Nn) ++ List.replicate (Nn - (c.take Nn).length) 0
  let h := Nn / 2
  let n := c.length
  let hi1 := Nat.min n (3 * h)
  let s1 := foldRange (fun out k => subAt (addAt out (k - h) (getDL c k)) (k - Nn) (getDL c k)) (hi1 - Nn) base Nn
  let s2 := foldRange (fun out k => subAt out (k - 3 * h) (getDL c k)) (n - hi1) s1 hi1
  s2.take Nn

def mulL (a b : List Int) : List Int := reduceRaw (mulRaw a b)

def fmulqL (a b : List Int) : List Int := modqL (mulL (modqL a) (modqL b))

def fsubqL (a b : List Int) : List Int :=
  List.zipWith (fun x y => (x - y) % Qq) a b

def fqEqual : List Int -> List Int -> Bool
  | [], _ => true
  | _, [] => true
  | x :: xs, y :: ys => ((x - y) % Qq == 0) && fqEqual xs ys

def congruentL (a b c g G f F h : List Int) : Bool :=
  let v1 := subL c (addL (mulL a g) (mulL b G))
  let v2 := addL (mulL a f) (mulL b F)
  let lhs := fsubqL (modqL (addL v1 (fmulqL h v2))) (modqL c)
  lhs.all (fun x => x == 0)

-- Index-based mirror of mulL/fmulqL (pointwise equal on all inputs; the
-- generator asserts idx_mul = mul and idx_fmulq = fmulq on pinned vectors).
-- Random access keeps kernel depth O(N) per demanded output index, so
-- `decide` on list inequality short-circuits at the first differing index
-- instead of building the whole spine under a lazy fold.
def convAt (a b : List Int) (k : Nat) : Nat -> Int
  | 0 => 0
  | fuel + 1 =>
    let j := k - fuel
    convAt a b k fuel + getDL a j * getDL b (k - j)

def rawAt (a b : List Int) (k : Nat) : Int := convAt a b k (k + 1)

def redAt (rawLen : Nat) (raw : Nat -> Int) (i : Nat) : Int :=
  let h := Nn / 2
  let hi1 := Nat.min rawLen (3 * h)
  raw i
    + (if Nn ≤ i + h ∧ i + h < hi1 then raw (i + h) else 0)
    - (if i + Nn < hi1 then raw (i + Nn) else 0)
    - (if i + 3 * h < rawLen then raw (i + 3 * h) else 0)

def mulAt (a b : List Int) (i : Nat) : Int :=
  redAt (a.length + b.length - 1) (rawAt a b) i

def mulRange (a b : List Int) : List Int := (List.range Nn).map (mulAt a b)

def fmulqI (a b : List Int) : List Int := modqL (mulRange (modqL a) (modqL b))

def fLit : List Int := @@F@@
def gLit : List Int := @@G@@
def FLit : List Int := @@BIGF@@
def GLit : List Int := @@BIGG@@
def hWrongLit : List Int := @@HWRONG@@
def aLit : List Int := @@A@@
def bLit : List Int := @@B@@
def cLit : List Int := @@C@@

-- Key-relation leg: wrong h breaks h*f = g. Stated as a list inequality
-- (equivalent to frozen fq_equal = false: both sides are mod-q
-- representatives in [0, q)).
theorem keyrel_wrong_h_ne : fmulqI hWrongLit fLit ≠ modqL gLit := by
  decide

-- Full M_wrong_h detection: key relation AND congruence cannot both hold
-- for the wrong public h on the pinned instance (both legs evaluated in
-- the kernel at these small parameters; the 1536-parameter legs remain
-- frozen Sage/Python controls per checks/exact_ring_checks.json).
theorem mutation_wrong_h_detected :
    ¬ ((fmulqI hWrongLit fLit = modqL gLit) ∧
      (congruentL aLit bLit cLit gLit GLit fLit FLit hWrongLit = true)) := by
  decide

#check @keyrel_wrong_h_ne
#check @mutation_wrong_h_detected
#print axioms keyrel_wrong_h_ne
#print axioms mutation_wrong_h_detected
"""

out = lean_template
out = out.replace("@@PIN_PY@@", frozen["scripts/py_crosscheck/exact_ring_checks.py"])
out = out.replace("@@PIN_SAGE@@", frozen["checks/sage/exact_ring_checks.sage"])
out = out.replace("@@PIN_JSON@@", frozen["checks/exact_ring_checks.json"])
out = out.replace("@@NN@@", "6")
out = out.replace("@@QQ@@", "17")
out = out.replace("@@F@@", lean_list(svecs["f"]))
out = out.replace("@@G@@", lean_list(svecs["g"]))
out = out.replace("@@BIGF@@", lean_list(svecs["F"]))
out = out.replace("@@BIGG@@", lean_list(svecs["G"]))
out = out.replace("@@HWRONG@@", lean_list(svecs["h_wrong"]))
out = out.replace("@@A@@", lean_list(svecs["a"]))
out = out.replace("@@B@@", lean_list(svecs["b"]))
out = out.replace("@@C@@", lean_list(svecs["c"]))

WDIR = "/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_MUTATION_WRONG_H_2026-09-24"
with open(WDIR + "/MutationWrongHSmall.lean", "w") as fh:
    fh.write(out)
with open(WDIR + "/mutation_vectors.json", "w") as fh:
    json.dump({k: v for k, v in vecs.items()}, fh)
with open(WDIR + "/mutation_vectors_small.json", "w") as fh:
    json.dump({k: v for k, v in svecs.items()}, fh)

import hashlib as hl
print("A_holds=%s B_holds=%s M_detected=%s" % (A_holds, B_holds, M_detected))
print("lean_sha=%s" % hl.sha256(out.encode()).hexdigest())
print("GEN_MUTATION_PASS")
