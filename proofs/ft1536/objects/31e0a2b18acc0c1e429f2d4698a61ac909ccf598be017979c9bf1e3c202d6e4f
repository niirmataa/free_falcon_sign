#!/usr/bin/env python3
"""R5 (S01): rigorous ideal-model chi-square upper tail for the FT1536 bound.

Model (MODEL_CHI2_IDEAL, ideal continuous, BEFORE casts/retries):
  the 2N = 3072 normalized orthonormal coordinates of (z1,z2) w.r.t. the Q
  form are iid N(0, sigma^2), sigma = 768.  Then Q/sigma^2 ~ chi^2(3072) and

    Pr[Q >= B] = Pr[chi^2(3072) >= B/sigma^2]
               = exp(-x) * sum_{k=0}^{1535} x^k / k!,      x = B/(2*sigma^2).

Derivation of the closed form (analytic, recorded in RESEARCH_NOTES_PL.md):
  chi^2(2m) is Gamma(m, rate 1/2) (Erlang).  With f(t) = t^(m-1) e^(-t/2)
  / (2^m (m-1)!) and m-1 integrations by parts,
  Pr[T >= v] = e^(-v/2) * sum_{j=0}^{m-1} (v/2)^j / j!
             = Pr[Poisson(v/2) <= m-1].   Here m = 1536, v = B/sigma^2,
  so x = v/2 = B/(2*sigma^2) and the sum stops at k = 1535.

This is a NEGATIVE test of the ideal model only:  not the real Sign law after
rint/int16 casts and retries, not an attack probability, not a security level.

Certified chain (exact rational core + outward transcendental bounds):
  1. x = B/(2*sigma^2) is an exact `Fraction`;
  2. the finite Poisson sum S = sum_{k=0}^{1535} x^k/k! is EXACT, accumulated
     with integers over one common denominator b^1535 * 1535!  (a = num(x),
     b = den(x)); no float and no big-fraction gcd churn;
  3. exp enclosure, two independent outward methods (argument rounding is
     never hidden):
     (M1) exact-`Fraction` alternating Taylor series of exp(-delta) at
          delta = x/2^11 (0 < delta < 1 => term magnitudes strictly
          decreasing => consecutive partial sums bracket the value, gap <=
          first omitted term < 2^-2300), endpoints converted OUTWARD
          (floor/ceil at 300 significant digits), then 11 interval squarings
          in Decimal, each step widened by +/- 4 ulp (covers the half-even
          rounding of the squaring itself);
     (M2) monotonicity in the argument: x is enclosed OUTWARD by exact
          decimals x_lo <= x <= x_hi (floor/ceil at 300 significant digits),
          exp(-x) in [exp(-x_hi), exp(-x_lo)], each `decimal.Decimal.exp`
          (correctly rounded per the General Decimal Arithmetic spec)
          widened by +/- 4 ulp;
     both enclosures are outward for exp(-x), so their intersection is;
     agreement (overlap) is asserted;
  4. the tail interval [S*e_lo, S*e_hi] uses exact rational arithmetic and
     the comparisons against 2^-40 and 2^-28 are exact cross-multiplied
     rational comparisons.

Decimal displays (50 fractional digits) use directed integer scaling (floor
for the lower endpoint, ceil for the upper one), so the printed strings are
outward.  log2 bounds and the 60-digit `decimal` recomputation are display /
cross-check only.

Output: results/chi_tail.json  (deterministic bytes; no timestamps).
"""
import json
import math
import os
from decimal import Decimal, localcontext
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "results")
os.makedirs(OUT, exist_ok=True)

# ---------------------------------------------------------------- parameters
Q = 18433                     # modulus (context only; not used in the tail)
N = 1536
SIGMA = 768                   # candidate global width (sigma), ideal model
MARGIN_NUM, MARGIN_DEN = 43, 40     # 1.075
B = (MARGIN_NUM ** 2 * 2 * N * SIGMA * SIGMA) // (MARGIN_DEN ** 2)   # 2093922385
B_MARGINLESS = 2 * N * SIGMA * SIGMA                                 # 1811939328
DOF = 2 * N                   # 3072 = chi^2 dof
HALF_DOF = DOF // 2           # 1536 = sum upper index + 1
SQ_2SIGMA2 = 2 * SIGMA * SIGMA    # 1179648
SIG_DIGITS = 300              # outward conversion precision
ULP_WIDEN = 4                 # ulp widening for correctly-rounded ops

assert B == 2093922385 and B_MARGINLESS == 1811939328

X = Fraction(B, SQ_2SIGMA2)   # x = B/(2*sigma^2) exactly
A, BB = X.numerator, X.denominator   # a/b, coprime


# --------------------------------------------------- exact rational helpers
def poisson_sum_exact(a: int, b: int, m: int) -> Fraction:
    """S = sum_{k=0}^{m-1} (a/b)^k/k! exactly, over denominator b^m * m!.

    Numerator W = sum_k a^k * b^(m-k) * (m!/k!): integer terms built
    incrementally (m!/k! telescopes), one gcd at the end.
    """
    fall = math.factorial(m)   # m!/k! at k = 0
    bpow = pow(b, m)           # b^(m-k) at k = 0
    w = 0
    apow = 1
    for k in range(m):
        w += apow * bpow * fall
        apow *= a
        bpow //= b             # exact: b^(m-k-1)
        fall //= (k + 1)       # exact: m!/(k+1)!
    return Fraction(w, pow(b, m) * math.factorial(m))


def frac_to_dec_sig(f: Fraction, sig: int, mode: str) -> Decimal:
    """Exact outward (or nearest) conversion of a positive Fraction to a
    Decimal with `sig` significant digits:  mode 'floor' gives d <= f,
    'ceil' gives d >= f (both are EXACT decimals, no rounding gap hidden)."""
    assert f > 0
    e = int((f.numerator.bit_length() - f.denominator.bit_length()) * 0.30103)
    # adjust estimated decimal exponent so that 10^e <= f < 10^(e+1)
    while Fraction(10) ** e > f:
        e -= 1
    while Fraction(10) ** (e + 1) <= f:
        e += 1
    shift = sig - 1 - e                       # scale f by 10^shift
    if shift >= 0:
        scaled = Fraction(f.numerator * 10 ** shift, f.denominator)
    else:
        scaled = Fraction(f.numerator, f.denominator * 10 ** (-shift))
    if mode == "floor":
        q = scaled.numerator // scaled.denominator
    elif mode == "ceil":
        q = -((-scaled.numerator) // scaled.denominator)
    elif mode == "near":
        q = (2 * scaled.numerator + scaled.denominator) // (2 * scaled.denominator)
    else:
        raise ValueError(mode)
    # EXACT decimal q * 10^-shift: the tuple constructor never rounds
    # (Decimal.scaleb would round to the ambient context precision!)
    return Decimal((0, tuple(int(c) for c in str(q)), -shift))


def frac_floor_dec(f: Fraction, digits: int) -> str:
    sign = "-" if f < 0 else ""
    f = abs(f)
    scale = 10 ** digits
    q = (f.numerator * scale) // f.denominator
    s = str(q).rjust(digits + 1, "0")
    return f"{sign}{s[:-digits] or '0'}.{s[-digits:]}"


def frac_ceil_dec(f: Fraction, digits: int) -> str:
    sign = "-" if f < 0 else ""
    f = abs(f)
    scale = 10 ** digits
    q = -((-f.numerator * scale) // f.denominator)
    s = str(q).rjust(digits + 1, "0")
    return f"{sign}{s[:-digits] or '0'}.{s[-digits:]}"


def frac_nearest_dec(f: Fraction, digits: int) -> str:
    sign = "-" if f < 0 else ""
    f = abs(f)
    scale = 10 ** digits
    q = (f.numerator * 2 * scale + f.denominator) // (2 * f.denominator)
    s = str(q).rjust(digits + 1, "0")
    return f"{sign}{s[:-digits] or '0'}.{s[-digits:]}"


# --------------------------------------------- M1: exact Taylor + squarings
def exp_neg_enclosure_M1(x: Fraction, shift: int = 11, taylor_bits: int = 2300):
    """[lo, hi] (Decimals) with lo <= exp(-x) <= hi via
    exp(-x) = exp(-delta)^(2^shift), delta = x/2^shift, exact-Fraction
    alternating Taylor bracket, outward endpoint conversion, then `shift`
    interval squarings with +/- 4 ulp widening (monotone t -> t^2 on t > 0,
    so [lo,hi]^2 = [lo^2, hi^2])."""
    delta = x / (1 << shift)                   # exact, 0 < delta < 1
    term = Fraction(1)
    partial = Fraction(1)                      # S_0 = 1
    prev = partial
    k = 1
    while True:
        term = term * delta / k
        prev = partial
        partial = partial - term if k % 2 == 1 else partial + term
        if term < Fraction(1, 1 << taylor_bits):
            lo, hi = (min(prev, partial), max(prev, partial))
            break
        k += 1
        if k > 100000:
            raise RuntimeError("Taylor did not converge")
    dlo = frac_to_dec_sig(lo, SIG_DIGITS, "floor")
    dhi = frac_to_dec_sig(hi, SIG_DIGITS, "ceil")
    with localcontext() as ctx:
        ctx.prec = SIG_DIGITS + 10
        for _ in range(shift):
            sq_lo = dlo * dlo
            sq_hi = dhi * dhi
            dlo = sq_lo - ULP_WIDEN * Decimal(1).scaleb(sq_lo.adjusted()
                                                        - (SIG_DIGITS + 10) + 1)
            dhi = sq_hi + ULP_WIDEN * Decimal(1).scaleb(sq_hi.adjusted()
                                                        - (SIG_DIGITS + 10) + 1)
    return dlo, dhi, k


# --------------------------------------- M2: monotone argument enclosure
def exp_neg_enclosure_M2(x: Fraction, sig: int = SIG_DIGITS):
    """[lo, hi] (Decimals) with lo <= exp(-x) <= hi via x in [x_lo, x_hi]
    outward and monotonicity of exp(-t); each Decimal.exp (correctly rounded)
    widened by +/- 4 ulp."""
    x_lo = frac_to_dec_sig(x, sig, "floor")
    x_hi = frac_to_dec_sig(x, sig, "ceil")

    def exp_widened(t: Decimal) -> (Decimal, Decimal):
        with localcontext() as ctx:
            ctx.prec = sig + 10
            r = (-t).exp()                    # correctly rounded (half-even)
            ulp = Decimal(1).scaleb(r.adjusted() - (sig + 10) + 1)
            return r - ULP_WIDEN * ulp, r + ULP_WIDEN * ulp

    hi_r, hi_u = exp_widened(x_lo)            # upper side: smallest argument
    lo_r, lo_u = exp_widened(x_hi)            # lower side: largest argument
    return lo_r, hi_u


S = poisson_sum_exact(A, BB, HALF_DOF)        # exact finite Poisson sum

m1_lo, m1_hi, taylor_steps = exp_neg_enclosure_M1(X)
m2_lo, m2_hi = exp_neg_enclosure_M2(X)

assert m1_lo > 0 and m2_lo > 0, "exp enclosure went non-positive"
agree = not (m1_hi < m2_lo or m2_hi < m1_lo)
assert agree, ("exp enclosures disagree: M1=[%s, %s] M2=[%s, %s]"
               % (m1_lo, m1_hi, m2_lo, m2_hi))

# intersection (both outward => still outward) as exact Fractions
E_LO = max(Fraction(m1_lo), Fraction(m2_lo))
E_HI = min(Fraction(m1_hi), Fraction(m2_hi))
assert E_LO > 0 and E_LO <= E_HI

# ------------------------------------------------------- tail = exp(-x) * S
T_LO = E_LO * S
T_HI = E_HI * S

POW_2_NEG_40 = Fraction(1, 1 << 40)
POW_2_NEG_28 = Fraction(1, 1 << 28)
gt_2_40 = T_LO > POW_2_NEG_40          # certified: tail > 2^-40
lt_2_28 = T_HI < POW_2_NEG_28          # certified: tail < 2^-28
assert gt_2_40 and lt_2_28, "expected 2^-40 < tail < 2^-28"
OLD_CRITERION_REFUTED = gt_2_40        # "accept >= 1 - 2^-40" refuted here

# ------------------------------------------------------------ log2 display
with localcontext() as ctx:
    ctx.prec = 80
    dlo = Decimal(T_LO.numerator) / Decimal(T_LO.denominator)
    dhi = Decimal(T_HI.numerator) / Decimal(T_HI.denominator)
    lo2 = str((dlo.ln() / Decimal(2).ln()).quantize(Decimal(1).scaleb(-6)))
    hi2 = str((dhi.ln() / Decimal(2).ln()).quantize(Decimal(1).scaleb(-6)))

center_disp = frac_nearest_dec((T_LO + T_HI) / 2, 50)
ball_radius_disp = frac_ceil_dec((T_HI - T_LO) / 2, 8)

# --------------------------------------------------- independent cross-check
# non-rigorous 150-digit Decimal pipeline (rounded x, rounded accumulation),
# compared to the certificate with an explicit 1e-120 relative tolerance.
with localcontext() as ctx:
    ctx.prec = 150
    xd = Decimal(X.numerator) / Decimal(X.denominator)
    xk = Decimal(1)
    sd = Decimal(0)
    for k in range(HALF_DOF):
        if k:
            xk = xk * xd / k
        sd += xk
    cross_tail = (-xd).exp() * sd
    cross_disp = str(cross_tail)
    tol = Decimal(10) ** -120
    dlo_c = Decimal(T_LO.numerator) / Decimal(T_LO.denominator)
    dhi_c = Decimal(T_HI.numerator) / Decimal(T_HI.denominator)
    inside = (dlo_c * (1 - tol) <= cross_tail <= dhi_c * (1 + tol))

# ---------------------------------------------------------------- JSON record
rep = {
    "claim_id": "C19",
    "evidence_class": "RIGOROUS_INTERVAL",
    "model": {
        "name": "MODEL_CHI2_IDEAL",
        "scope": "ideal continuous normalized-canonical coordinates, "
                 "iid N(0, sigma^2) BEFORE casts/retries; NOT the real Sign "
                 "law, NOT an attack probability, NOT a security level",
        "dof": DOF,
        "sigma": SIGMA,
        "N": N,
        "q": Q,
    },
    "bound": {
        "B": B,
        "B_formula": "floor((43/40)^2 * 2N * sigma^2)",
        "B_marginless": B_MARGINLESS,
    },
    "x_exact": f"{X.numerator}/{X.denominator}",
    "x_formula": "x = B/(2*sigma^2)",
    "tail_formula": "Pr[Q >= B] = exp(-x) * sum_{k=0}^{1535} x^k/k!",
    "method": {
        "finite_sum": "exact integer accumulation over common denominator "
                      "b^1535 * 1535! (a = num(x), b = den(x))",
        "exp_enclosure_M1": "exact-Fraction alternating Taylor of exp(-delta), "
                            "delta = x/2^11 (bracket = consecutive partial "
                            "sums, gap <= first omitted term < 2^-2300), "
                            "outward floor/ceil endpoint conversion at 300 "
                            "significant digits, then 11 interval squarings "
                            "with +/- 4 ulp widening per step",
        "exp_enclosure_M2": "x enclosed outward by exact decimals x_lo/x_hi "
                            "(floor/ceil, 300 significant digits) and "
                            "monotonicity: exp(-x) in [exp(-x_hi), "
                            "exp(-x_lo)]; each decimal.exp (correctly rounded "
                            "per General Decimal Arithmetic spec) widened by "
                            "+/- 4 ulp",
        "exp_final": "intersection of M1 and M2 (both outward; overlap "
                     "asserted)",
        "taylor_steps": taylor_steps,
        "comparisons": "exact cross-multiplied rational comparisons",
        "display_only": "decimal strings, log2 bounds and the 150-digit "
                        "recomputation are display / cross-check only",
    },
    "tail_interval": {
        "lo_decimal_50": frac_floor_dec(T_LO, 50),
        "hi_decimal_50": frac_ceil_dec(T_HI, 50),
        "center_display_50": center_disp,
        "ball_radius_display_8": ball_radius_disp,
    },
    "log2_tail_bounds_display": {"lo": lo2, "hi": hi2},
    "comparisons": {
        "certified_tail_gt_2_pow_neg40": bool(gt_2_40),
        "certified_tail_lt_2_pow_neg28": bool(lt_2_28),
        "old_criterion_accept_ge_1_minus_2_pow_neg40_refuted": bool(
            OLD_CRITERION_REFUTED),
        "proposed_criterion_2_pow_neg28_status":
            "PROPOSED model-level per-attempt target only; NOT an approved "
            "project goal and NOT a security level (TASK S01 R5)",
    },
    "cross_check_decimal_150": {
        "tail_display": cross_disp,
        "inside_certified_interval_within_rel_tol_1e_minus_120": bool(inside),
        "role": "independent non-rigorous cross-check (rounded x and "
                "150-digit accumulation), not part of the certificate",
    },
}

with open(os.path.join(OUT, "chi_tail.json"), "w", encoding="utf-8") as f:
    json.dump(rep, f, indent=1, sort_keys=True)
    f.write("\n")

print("x =", f"{X.numerator}/{X.denominator}", "=", frac_nearest_dec(X, 6))
print("S exact: numerator bits", S.numerator.bit_length(),
      "denominator bits", S.denominator.bit_length())
print("Taylor steps (M1):", taylor_steps)
print("tail in [", frac_floor_dec(T_LO, 25), ",", frac_ceil_dec(T_HI, 25), "]")
print("center (display):", center_disp)
print("log2 tail in [", lo2, ",", hi2, "]")
print("certified tail > 2^-40 :", gt_2_40, "(old 2^-40 criterion refuted)")
print("certified tail < 2^-28 :", lt_2_28, "(PROPOSED target only)")
print("M1/M2 exp enclosures agree:", agree)
print("decimal cross-check inside interval:", inside, cross_disp[:34], "...")
print("SUMMARY: 0 checks failed" if (gt_2_40 and lt_2_28 and inside and agree)
      else "SUMMARY: FAILED")
