# lemma_chi_tail.sage -- S01 R5: rigorous ideal-model chi-square upper tail
#
# Owner rule FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22: authoritative
# mathematical computation lives in .sage and runs with
#
#     sage scripts/lemma_chi_tail.sage
#
# (standard preparser; pinned launcher /home/footfalcon/.local/bin/sage).
# Exact domains: ZZ / QQ with exactly specified inputs; the transcendental
# exp enclosure uses RealBallField(256) (rigorous outward balls).  This file
# supersedes the Python-Fraction draft preserved in
# proof/drafts/chi_tail_rigorous_draft.py; the port receipt (diff, re-run,
# certificate agreement) is proof/receipts/port_py_to_sage.json.
#
# Model (MODEL_CHI2_IDEAL, ideal continuous, BEFORE casts/retries):
#   2N = 3072 orthonormal coordinates of (z1,z2) w.r.t. Q are iid N(0,sigma^2),
#   sigma = 768; then Q/sigma^2 ~ chi^2(3072) and
#       Pr[Q >= B] = exp(-x) * sum_{k=0}^{1535} x^k/k!,   x = B/(2*sigma^2).
# Closed form: chi^2(2m) = Gamma(m, rate 1/2); m-1 integrations by parts give
#   Pr[T >= v] = e^(-v/2) * sum_{j=0}^{m-1} (v/2)^j/j! = Pr[Poisson(v/2)<=m-1]
# with m = 1536, v = B/sigma^2, x = v/2.  NEGATIVE TEST OF THE IDEAL MODEL
# ONLY: not the real Sign law after casts/retries, not an attack probability,
# not a security level.
#
# Certified chain:
#   1. x = B/(2*sigma^2) in QQ, exactly;
#   2. S = sum_{k=0}^{1535} x^k/k! EXACT in ZZ/QQ (one common denominator
#      b^1535 * 1535!, integer accumulation, one reduction at the end);
#   3. exp(-x) enclosure: RealBallField(256) -- arb's exp is rigorous with
#      outward error bound; cross path delta = x/2^11 with exp(-delta)^2^11
#      in balls (overlap asserted); an exact-QQ alternating-Taylor bracket of
#      exp(-delta) (terms strictly decreasing for 0 < delta < 1; consecutive
#      partial sums bracket the value) cross-checks the ball at delta;
#   4. outward rational bounds of the tail from mid/rad (true value inside
#      [mid-rad, mid+rad]; we use mid +/- 2*rad, exact QQ conversions) and
#      EXACT QQ comparisons against 2^-40 and 2^-28.
#
# Output: results/chi_tail.json (deterministic bytes; no timestamps).

# ---- preflight: preparser/toolchain mode (not a proof of the goal)
assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024

import json as _json
import os as _os

# Package root resolution (sage runs the preprocessed copy, so __file__ does
# NOT point at this .sage source; documented mode is
# `sage scripts/lemma_chi_tail.sage` from the package root).
_PKG = _os.environ.get("FT1536_PKG_ROOT")
if not _PKG:
    for _a in _sys.argv:
        if _a.endswith(".sage") and _os.path.isfile(_a):
            _PKG = _os.path.dirname(_os.path.dirname(_os.path.abspath(_a)))
            break
if not _PKG and _os.path.isfile(_os.path.join(_os.getcwd(), "scripts",
                                              "lemma_chi_tail.sage")):
    _PKG = _os.getcwd()
assert _PKG, "cannot resolve package root (set FT1536_PKG_ROOT)"
HERE = _os.path.join(_PKG, "scripts")
OUT = _os.path.join(_PKG, "results")
_os.makedirs(OUT, exist_ok=True)
print("package root:", _PKG)

# ---------------------------------------------------------------- parameters
q_mod = ZZ(18433)                    # modulus (context only)
N = ZZ(1536)
sigma = ZZ(768)                      # candidate global width (SIG-001 OPEN)
margin = QQ(43)/QQ(40)               # 1.075, exactly
B = ZZ(floor(margin^2 * 2*N * sigma^2))          # 2093922385
B_marginless = ZZ(2*N * sigma^2)                 # 1811939328
dof = ZZ(2*N)                                    # 3072
half_dof = dof / ZZ(2)                           # 1536 (exact QQ!)
two_sigma2 = ZZ(2 * sigma^2)                     # 1179648

assert B == 2093922385 and B_marginless == 1811939328
assert half_dof == 1536 and parent(half_dof) is QQ

x = QQ(B) / QQ(two_sigma2)           # x = B/(2*sigma^2), exactly
a_num = x.numerator()                # a/b coprime
b_den = x.denominator()

# ------------------------------- exact finite Poisson sum over ZZ (b^m * m!)
m = ZZ(half_dof)                     # 1536
fall = ZZ(factorial(m))              # m!/k! at k = 0
bpow = ZZ(b_den)^m                   # b^(m-k) at k = 0
W = ZZ(0)
apow = ZZ(1)
for k in range(m):
    W += apow * bpow * fall          # a^k * b^(m-k) * (m!/k!)
    apow *= ZZ(a_num)
    bpow = bpow // ZZ(b_den)         # exact: b^(m-k-1)
    fall = fall // ZZ(k + 1)         # exact: m!/(k+1)!
S = QQ(W) / QQ(ZZ(b_den)^m * ZZ(factorial(m)))   # S exactly
assert parent(S) is QQ

# --------------------------------------- exp(-x): rigorous balls (arb)
RBF = RealBallField(256)
e_ball = RBF(-x).exp()                       # rigorous enclosure of exp(-x)

# cross path: exp(-delta)^(2^11) with delta = x/2^11 (balls)
delta = x / QQ(2^11)
e_ball2 = (RBF(-delta).exp())^(2^11)
overlap = e_ball.real().overlaps(e_ball2.real())
assert overlap, "exp enclosure paths disagree"

# exact-QQ alternating-Taylor bracket of exp(-delta) (cross-check at delta)
taylor_terms = ZZ(0)
term = QQ(1)
partial = QQ(1)
prev = QQ(1)
while True:
    taylor_terms += 1
    term = term * delta / QQ(taylor_terms)
    prev = partial
    partial = partial - term if taylor_terms % 2 == 1 else partial + term
    if term < QQ(1)/QQ(2^2300):
        t_lo = min(prev, partial)
        t_hi = max(prev, partial)
        break
    if taylor_terms > 100000:
        raise RuntimeError("Taylor bracket did not converge")
d_ball = RBF(-delta).exp()           # rigorous ball for exp(-delta)
taylor_agrees = (d_ball.overlaps(RBF(t_lo)) and d_ball.overlaps(RBF(t_hi))
                 and t_lo <= t_hi)
assert taylor_agrees, "Taylor bracket vs ball mismatch at delta"

# ----------------------------- outward rational tail bounds from the ball
mid = e_ball.mid()                   # RealNumber
rad = e_ball.rad()                   # RealNumber (upper bound of |error|)
E_lo = QQ(mid) - 2*QQ(rad)           # <= exp(-x)
E_HI = QQ(mid) + 2*QQ(rad)           # >= exp(-x)
assert E_lo > 0 and E_lo <= E_HI

T_lo = E_lo * S                      # exact QQ
T_hi = E_HI * S
assert T_lo > 0 and T_lo <= T_hi

# exact QQ comparisons
gt_2_40 = (T_lo > QQ(1)/QQ(2^40))    # certified: tail > 2^-40
lt_2_28 = (T_hi < QQ(1)/QQ(2^28))    # certified: tail < 2^-28
assert gt_2_40 and lt_2_28, "expected 2^-40 < tail < 2^-28"
old_criterion_refuted = gt_2_40      # "accept >= 1 - 2^-40" refuted here

# ball-level relational cross-checks (rigorous True/False)
ball_gt_2_40 = bool(e_ball * S > RBF(1)/RBF(2^40))
ball_lt_2_28 = bool(e_ball * S < RBF(1)/RBF(2^28))
assert ball_gt_2_40 == gt_2_40 and ball_lt_2_28 == lt_2_28

# ------------------------------------------------ outward decimal display
def qq_floor_dec(f, digits):
    f = QQ(f)
    assert f >= 0
    scale = ZZ(10)^digits
    q0 = (f.numerator() * scale) // f.denominator()
    s = str(q0).rjust(digits + 1, "0")
    return s[:-digits] + "." + s[-digits:]


def qq_ceil_dec(f, digits):
    f = QQ(f)
    assert f >= 0
    scale = ZZ(10)^digits
    q0 = -((-f.numerator() * scale) // f.denominator())
    s = str(q0).rjust(digits + 1, "0")
    return s[:-digits] + "." + s[-digits:]


def qq_nearest_dec(f, digits):
    f = QQ(f)
    assert f >= 0
    scale = ZZ(10)^digits
    q0 = (f.numerator() * 2 * scale + f.denominator()) // (2 * f.denominator())
    s = str(q0).rjust(digits + 1, "0")
    return s[:-digits] + "." + s[-digits:]


center_disp = qq_nearest_dec((T_lo + T_hi) / 2, 50)
ball_radius_disp = qq_ceil_dec((T_hi - T_lo) / 2, 8)

# log2 tail bounds: DISPLAY ONLY (RR diagnostic)
RR100 = RealField(100)
lo2 = str(RR100(T_lo).log() / RR100(2).log())
hi2 = str(RR100(T_hi).log() / RR100(2).log())

# --------------------------------------- independent cross-check (diagnostic)
# 500-bit RR pipeline (~150 decimal digits; rounded x and accumulation):
# FLOAT_DIAGNOSTIC, NOT part of the certificate.
RR150 = RealField(500)
xd = RR150(x)
xk = RR150(1)
sd = RR150(0)
for k in range(m):
    if k:
        xk = xk * xd / RR150(k)
    sd += xk
cross_tail = (-xd).exp() * sd
cross_disp = str(cross_tail)
tol = RR150(10)^-120
inside = bool(RR150(T_lo) * (1 - tol) <= cross_tail
              <= RR150(T_hi) * (1 + tol))

# ---------------------------------------------------------------- JSON record
rep = {
    "claim_id": "C19",
    "evidence_class": "RIGOROUS_INTERVAL",
    "mode": "sage lemma_chi_tail.sage (preparser ZZ/QQ exact + RealBallField"
            "(256) exp enclosure; rule FT1536_ZASADA_RACHUNKU_SAGEMATH_"
            "2026-09-22)",
    "model": {
        "name": "MODEL_CHI2_IDEAL",
        "scope": "ideal continuous normalized-canonical coordinates, "
                 "iid N(0, sigma^2) BEFORE casts/retries; NOT the real Sign "
                 "law, NOT an attack probability, NOT a security level",
        "dof": int(dof),
        "sigma": int(sigma),
        "N": int(N),
        "q": int(q_mod),
    },
    "bound": {
        "B": int(B),
        "B_formula": "floor((43/40)^2 * 2N * sigma^2)",
        "B_marginless": int(B_marginless),
    },
    "x_exact": str(x.numerator()) + "/" + str(x.denominator()),
    "x_formula": "x = B/(2*sigma^2)",
    "tail_formula": "Pr[Q >= B] = exp(-x) * sum_{k=0}^{1535} x^k/k!",
    "method": {
        "finite_sum": "exact ZZ accumulation over common denominator "
                      "b^1535 * 1535! (a = num(x), b = den(x)); one QQ "
                      "reduction at the end",
        "exp_enclosure": "RealBallField(256) exp (arb: rigorous outward "
                         "ball); outward rational bounds E = mid +/- 2*rad "
                         "with exact QQ conversions",
        "exp_cross_path": "exp(-delta)^(2^11) in balls, delta = x/2^11 "
                          "(overlap asserted); exact-QQ alternating-Taylor "
                          "bracket of exp(-delta), gap <= first omitted term "
                          "< 2^-2300 (" + str(taylor_terms) + " terms), "
                          "cross-checked against the ball at delta",
        "comparisons": "exact QQ comparisons plus independent ball "
                       "relational cross-checks (agreement asserted)",
        "display_only": "decimal strings and log2 bounds are outward/"
                        "display only; the 500-bit (~150-digit) RR pipeline "
                        "is FLOAT_DIAGNOSTIC, not the certificate",
    },
    "tail_interval": {
        "lo_decimal_50": qq_floor_dec(T_lo, 50),
        "hi_decimal_50": qq_ceil_dec(T_hi, 50),
        "center_display_50": center_disp,
        "ball_radius_display_8": ball_radius_disp,
    },
    "log2_tail_bounds_display": {"lo": lo2, "hi": hi2},
    "comparisons": {
        "certified_tail_gt_2_pow_neg40": bool(gt_2_40),
        "certified_tail_lt_2_pow_neg28": bool(lt_2_28),
        "ball_relational_agrees": bool(ball_gt_2_40 == gt_2_40
                                      and ball_lt_2_28 == lt_2_28),
        "old_criterion_accept_ge_1_minus_2_pow_neg40_refuted":
            bool(old_criterion_refuted),
        "proposed_criterion_2_pow_neg28_status":
            "PROPOSED model-level per-attempt target only; NOT an approved "
            "project goal and NOT a security level (TASK S01 R5)",
    },
    "cross_check_rr500bit": {
        "tail_display": cross_disp,
        "inside_interval_within_rel_tol_1e_minus_120": inside,
        "role": "FLOAT_DIAGNOSTIC independent cross-check (500-bit RR), "
                "not the certificate",
    },
}

with open(_os.path.join(OUT, "chi_tail.json"), "w") as f:
    _json.dump(rep, f, indent=1, sort_keys=True)
    f.write("\n")

print("x =", x.numerator(), "/", x.denominator(), "=", qq_nearest_dec(x, 6))
print("S exact: numerator bits", ZZ(S.numerator()).nbits(),
      "denominator bits", ZZ(S.denominator()).nbits())
print("Taylor terms (cross at delta):", taylor_terms)
print("tail in [", qq_floor_dec(T_lo, 25), ",", qq_ceil_dec(T_hi, 25), "]")
print("center (display):", center_disp)
print("log2 tail display in [", lo2, ",", hi2, "]")
print("certified tail > 2^-40 :", bool(gt_2_40),
      "(old 2^-40 criterion refuted)")
print("certified tail < 2^-28 :", bool(lt_2_28), "(PROPOSED target only)")
print("exp paths overlap:", bool(overlap), "| Taylor bracket agrees:",
      bool(taylor_agrees))
print("RR150 cross-check inside:", inside, str(cross_tail)[:34], "...")
print("SUMMARY: 0 checks failed")
