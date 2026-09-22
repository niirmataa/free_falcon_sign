#!/usr/bin/env python3
"""FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- recovery-gap composition (B) and
rint tie controls (C).

Composes the uniform per-coefficient gap  |pre_rint - v_ref|  from pinned
bootstrap constants only (exact outward rationals), keeps looser routes with
their numbers, and solves the sensitivity thresholds (what constants WOULD
suffice for a strict <1/2 gap). Also checks the nearest-even tie semantics of
fpr_rint (RINT_REFINEMENT rule) against an exact dyadic oracle.

Frames: pointwise-root bounds are transported with the pinned convention
|coeff_r| <= sqrt(4/3)*pointwise  (H6P ERROR_LEDGER 3, A2 transport).
"""
import json, os
from fractions import Fraction as F
from math import isqrt

W = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
CE = json.load(open(os.path.join(W, "checks", "constants_extract.json")))
POST = CE["POST/artifacts/numeric_certificate.json"]
H6P = CE["H6P/ERROR_LEDGER.json"]
TGT = CE["TARGETS/INITIAL_TARGET_CERTIFICATE.json"]
ROOT = CE["ROOT/ROOT_CERTIFICATE.json"]

def ex(section, key):
    v = section[key]
    return F(v["exact"]) if isinstance(v, dict) else F(str(v))

def exf(rel, key):
    return ex(CE[rel], key)

Q = F(18433)
N = F(1536)

# --- pinned constants (exact) ---
R = "ROOT/ROOT_CERTIFICATE.json"
P = "POST/artifacts/numeric_certificate.json"
G = "TARGETS/INITIAL_TARGET_CERTIFICATE.json"
H = "H6P/ERROR_LEDGER.json"
eps_fg   = exf(R, "constants.fft_component_error_fg")      # 2^-26 small row words
eps_FG   = exf(R, "constants.fft_component_error_FG")      # 2^-15 large row words
abs_fg   = exf(R, "constants.fft_component_abs_fg")        # ~1536
abs_FG   = exf(R, "constants.fft_component_abs_FG")        # ~3144192
Xcap     = exf(P, "sampling_return.returned_x_cap")        # |x_C| root cap
Ycap     = F(CE[P]["sampling_return.right_y_cap"])         # |y_C| root cap
t0cap    = F(CE[G]["targets.0.source_modulus_and_component_upper"])
t1cap    = F(CE[G]["targets.1.source_modulus_and_component_upper"])
Cwcap    = exf(G, "targets.0.primitive_preflight.FFT_input_component")
rho0     = exf(G, "targets.0.rounding_only_error_outward")  # 1/8192
rho1     = exf(G, "targets.1.rounding_only_error_outward")  # 1/2^24
ideE0    = exf(G, "targets.0.ideal_reference_error_outward")
ideE1    = exf(G, "targets.1.ideal_reference_error_outward")
chalE    = exf(G, "fft_challenge_component_error")          # 1/8192
recipE   = exf(G, "reciprocal.absolute_error")
Er       = exf(H, "terminal_source_sub_error")              # 2^-20
Eh       = exf(H, "terminal_half_error")                    # 2^-1023
Elast    = exf(H, "terminal_last_sub_error")
delta    = exf(H, "both_branch_reconstruction_delta")       # 20102235062439/2^49
eroot    = exf(H, "root_CM_plus_sub_error")
amax     = exf(H, "actual_basis_a_upper")
Pperp    = exf(H, "orthogonal_residual_row_norm_squared_cap")
Cross    = exf(H, "nonorthogonal_cross_cap")
graphB   = exf(H, "graph_basis_coefficient_error")          # sqrt(4/3 Eimage)
postCM   = exf(H, "post_CM_add_coefficient_error")
ifftE    = exf(H, "source_iFFT_error")                      # 1/128
coef_FG  = F(2047)   # targets.0.ideal_coefficient_cap (P_key cap |F_i|,|G_i|)
coef_fg  = F(1)      # full ternary |f_i|,|g_i| <= 1

def tr(b):
    """pinned A2 transport of a pointwise-root modulus bound."""
    return SQ43 * b

# outward sqrt(4/3) as exact rational upper bound: sqrt(4/3) = 2/sqrt(3);
# 1/sqrt(3) < 6369051672525773/11035124828510720? use continued fraction of sqrt(3).
# sqrt(3) > 9354940337/5400833137? Use isqrt-based: sqrt(4/3) <= 2*q/isqrt(3 q^2) style.
def sqrt_up_rat(p, qn):
    """upper bound for sqrt(p/qn) as Fraction, tight to 1e-12 (strictly >=)."""
    if p <= 0:
        return F(0)
    num, den = p.numerator * qn.denominator, p.denominator * qn.numerator
    big = 10 ** 24
    t = isqrt((num * big) // den)
    while (t + 1) ** 2 * den <= num * big:
        t += 1
    while t * t * den > num * big:
        t -= 1
    return F(t + 1, 10 ** 12)

SQ43 = sqrt_up_rat(F(4, 3), F(1))  # >= sqrt(4/3)

def tr(b):
    return SQ43 * b

# --- A: target/construction terms through the exact coefficient basis ---
eps_det = 2 * (eps_FG * abs_fg + eps_fg * abs_FG) + eps_FG ** 2 + eps_fg ** 2
A1 = tr(chalE)                                   # challenge FFT words vs eval(c)
A2 = tr(Cwcap / Q * eps_det)                     # rounded-basis det error x |C/q|
A3 = tr(rho0 * abs_fg + rho1 * abs_FG)           # target rounding layer x basis words
A4 = tr(t0cap * eps_fg + t1cap * eps_FG)         # word errors x target operands
A_total = A1 + A2 + A3 + A4
A_coarse = tr((ideE0 + rho0) * abs_fg + (ideE1 + rho1) * abs_FG)  # pinned 1/4 route

# --- B: Z(Y)*(B'_words - B_exact) ---
B_total = tr((t0cap + Xcap) * eps_fg + (t1cap + Ycap) * eps_FG)

# --- C: tree identity defects through the exact basis ---
etaT = Er + Eh + Elast
C1 = graphB                                     # pinned correlated triangular route
C1_alt_boxes = tr((delta + eroot) * (amax ** F(1, 2) if False else sqrt_up_rat(amax, F(1)))
                  + delta * sqrt_up_rat(Pperp, F(1)))            # independent boxes (worse)
eimage_of = lambda x: amax * (x + eroot) ** 2 + 2 * Cross * (x + eroot) * x + Pperp * x ** 2
C1_formula = tr(sqrt_up_rat(eimage_of(delta), F(1)))
C2 = N * (coef_fg + coef_FG) * etaT             # terminal sub/half/last-sub, coeff box
C3 = tr((delta + eroot + N * etaT) * (eps_fg + eps_FG))           # defect x word errors
C_failed_conv = N * sqrt_up_rat(F(2), 1) * (delta + eroot) * coef_FG  # loose convolution route

D_suffix = postCM
E_ifft = ifftE

TOTAL = A_total + B_total + C1 + C2 + C3 + D_suffix + E_ifft

# --- sensitivity: what would suffice for TOTAL < 1/2 with slack shares ---
share = F(1, 10)
k_word = min(share / B_total, share / (A2 + A4))
eps_fg_need = eps_fg * k_word
eps_FG_need = eps_FG * k_word
rel_need_fg = eps_fg_need / abs_fg
rel_need_FG = eps_FG_need / abs_FG
# delta needed for C1 <= share: solve quadratic numerically (outward conservative)
lo, hi = F(0), delta
for _ in range(200):
    mid = (lo + hi) / 2
    if tr(sqrt_up_rat(eimage_of(mid), F(1))) <= share:
        lo = mid
    else:
        hi = mid
delta_need = lo
etaT_need = share / (N * (coef_fg + coef_FG))

# --- C controls: fpr_rint nearest-even rule (RINT_REFINEMENT) vs exact oracle ---
def rint_rule(m, e):
    """fpr_rint model for value m/2^e (m integer, e in [13,63]-class dyadic):
    write m = q*2^e + r, 0<=r<2^e; increment iff 2r>2^e or (2r=2^e and q odd);
    symmetric nearest-even via signed reconstruction."""
    den = 1 << e
    neg = m < 0
    a = -m if neg else m
    qq, r = divmod(a, den)
    if 2 * r > den or (2 * r == den and (qq % 2 == 1)):
        qq += 1
    return -qq if neg else qq

def oracle(t):
    """exact nearest integer, ties to even, on Fraction t."""
    n, d = t.numerator, t.denominator
    q_, r = divmod(n, d)
    if 2 * r > d or (2 * r == d and (q_ % 2 == 1)):
        q_ += 1
    return q_

tie = {"strict": 0, "tie_even_ok": 0, "tie_odd_case": 0, "fail": 0, "recovery_fail": 0}
cases = []
for e in (1, 2, 3, 10, 24, 52, 63):
    den = 1 << e
    for v in (0, 1, 2, 3, 32767, 32768, -1, -2, -32768, 4572095, -4572095):
        for off in (0, 1, den - 1, den // 2, den // 2 + 1, den // 2 - 1, den):
            for sgn in (1, -1):
                m = sgn * (v * den + off)
                got = rint_rule(m, e)
                want = oracle(F(m, den))
                ok = got == want
                tie["fail" if not ok else ("tie_even_ok" if 2 * (abs(m) % den) == den else "strict")] += 1
                # recovery lemma instances: |t - v| < 1/2 => rint = v ; =1/2 ties-even
                if ok:
                    for cand in set([oracle(F(m, den)), oracle(F(m, den)) - 1, oracle(F(m, den)) + 1]):
                        t = F(m, den)
                        d_ = abs(t - cand)
                        if d_ < F(1, 2) and got != cand:
                            tie["recovery_fail"] += 1
                        if d_ == F(1, 2) and cand % 2 == 0 and got != cand:
                            tie["recovery_fail"] += 1
                if not ok:
                    cases.append([m, e, got, want])
tie["boundary_half_values_ok"] = all(
    rint_rule(int(F(2 * v + 1, 1) * (1 << 4)), 5) == (v if v % 2 == 0 else v + 1)
    for v in range(-8, 8))
tie_pass = tie["fail"] == 0 and tie["recovery_fail"] == 0 and tie["boundary_half_values_ok"]

out = {
    "schema": "ft1536.reference_integer_recovery.gap_composition/1",
    "transport_convention": "coeff <= sqrt(4/3) * pointwise-root bound (pinned H6P A2)",
    "terms_per_coefficient": {
        "A1_challenge_fft_words": {"exact": str(A1), "float": float(A1)},
        "A2_det_error_x_challenge": {"exact": str(A2), "float": float(A2)},
        "A3_target_rounding_layer": {"exact": str(A3), "float": float(A3)},
        "A4_word_errors_x_target": {"exact": str(A4), "float": float(A4)},
        "A_total_refined": {"exact": str(A_total), "float": float(A_total)},
        "A_coarse_pinned_route": {"exact": str(A_coarse), "float": float(A_coarse)},
        "B_word_residuals_x_Z": {"exact": str(B_total), "float": float(B_total)},
        "C1_tree_reconstruction_pinned": {"exact": str(C1), "float": float(C1)},
        "C1_formula_crosscheck": {"exact": str(C1_formula), "float": float(C1_formula)},
        "C1_alt_independent_boxes": {"exact": str(C1_alt_boxes), "float": float(C1_alt_boxes)},
        "C2_terminal_box": {"exact": str(C2), "float": float(C2)},
        "C3_defect_x_word_errors": {"exact": str(C3), "float": float(C3)},
        "C_failed_convolution_route": {"exact": str(C_failed_conv), "float": float(C_failed_conv)},
        "D_suffix_CM_add": {"exact": str(D_suffix), "float": float(D_suffix)},
        "E_ifft": {"exact": str(E_ifft), "float": float(E_ifft)},
        "TOTAL_gap_bound": {"exact": str(TOTAL), "float": float(TOTAL)},
    },
    "intermediates": {
        "eps_det": {"exact": str(eps_det), "float": float(eps_det)},
        "etaT": {"exact": str(etaT), "float": float(etaT)},
        "sqrt43_outward": {"exact": str(SQ43), "float": float(SQ43)},
        "required_gap_strict": "1/2",
        "gap_met": bool(TOTAL < F(1, 2)),
    },
    "sensitivity_minimal_missing_constants": {
        "eps_fg_needed_absolute": {"exact": str(eps_fg_need), "float": float(eps_fg_need)},
        "eps_FG_needed_absolute": {"exact": str(eps_FG_need), "float": float(eps_FG_need)},
        "eps_fg_needed_relative_to_value_cap": {"exact": str(rel_need_fg), "float": float(rel_need_fg)},
        "eps_FG_needed_relative_to_value_cap": {"exact": str(rel_need_FG), "float": float(rel_need_FG)},
        "delta_needed_absolute": {"exact": str(delta_need), "float": float(delta_need)},
        "etaT_needed_absolute": {"exact": str(etaT_need), "float": float(etaT_need)},
        "note": "thresholds are per-coefficient shares 1/10 of the strict 1/2 budget",
    },
    "rint_tie_controls": tie,
    "rint_tie_pass": tie_pass,
    "rint_mismatch_cases_head": cases[:5],
}
os.makedirs(os.path.join(W, "checks"), exist_ok=True)
with open(os.path.join(W, "checks", "gap_composition.json"), "w", encoding="utf-8") as f:
    json.dump(out, f, indent=1, sort_keys=True)

for k, v in out["terms_per_coefficient"].items():
    print("%-34s %-24s ~ %.8g" % (k, v["exact"][:22], v["float"]))
print()
print("rint tie pass:", tie_pass, tie)
print("TOTAL < 1/2 :", out["intermediates"]["gap_met"])
