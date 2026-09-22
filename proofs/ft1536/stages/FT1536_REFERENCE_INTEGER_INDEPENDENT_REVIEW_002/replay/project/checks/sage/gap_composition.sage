# FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- recovery-gap composition (B) and
# rint tie controls (C) -- Sage exact arithmetic (QQ, outward sqrt).
# Run:  sage checks/sage/gap_composition.sage    (cwd = W root; needs
#       checks/constants_extract.json from scripts/extract_constants.py)
#
# Composes the uniform per-coefficient gap |pre_rint - v_ref| from pinned
# bootstrap constants only (exact outward rationals), keeps looser routes with
# their numbers, and solves the sensitivity thresholds (what constants WOULD
# suffice for a strict <1/2 gap). Transport: pinned convention
# |coeff_r| <= sqrt(4/3) * pointwise-root bound (H6P ERROR_LEDGER 3, A2).

# preparser/toolchain preflight (principle doc 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1 / 3) is QQ
assert 2 ^ 10 == 1024

import json
from sage.all import QQ, ZZ, RR, RealIntervalField

CE = json.load(open("checks/constants_extract.json"))

def exf(rel, key):
    v = CE[rel][key]
    return QQ(v["exact"]) if isinstance(v, dict) else QQ(str(v))

R = "ROOT/ROOT_CERTIFICATE.json"
P = "POST/artifacts/numeric_certificate.json"
G = "TARGETS/INITIAL_TARGET_CERTIFICATE.json"
H = "H6P/ERROR_LEDGER.json"

eps_fg = exf(R, "constants.fft_component_error_fg")
eps_FG = exf(R, "constants.fft_component_error_FG")
abs_fg = exf(R, "constants.fft_component_abs_fg")
abs_FG = exf(R, "constants.fft_component_abs_FG")
Xcap = exf(P, "sampling_return.returned_x_cap")
Ycap = QQ(CE[P]["sampling_return.right_y_cap"])
t0cap = QQ(str(CE[G]["targets.0.source_modulus_and_component_upper"]))
t1cap = QQ(str(CE[G]["targets.1.source_modulus_and_component_upper"]))
Cwcap = exf(G, "targets.0.primitive_preflight.FFT_input_component")
rho0 = exf(G, "targets.0.rounding_only_error_outward")
rho1 = exf(G, "targets.1.rounding_only_error_outward")
ideE0 = exf(G, "targets.0.ideal_reference_error_outward")
ideE1 = exf(G, "targets.1.ideal_reference_error_outward")
chalE = exf(G, "fft_challenge_component_error")
Er = exf(H, "terminal_source_sub_error")
Eh = exf(H, "terminal_half_error")
Elast = exf(H, "terminal_last_sub_error")
delta = exf(H, "both_branch_reconstruction_delta")
eroot = exf(H, "root_CM_plus_sub_error")
amax = exf(H, "actual_basis_a_upper")
Pperp = exf(H, "orthogonal_residual_row_norm_squared_cap")
Cross = exf(H, "nonorthogonal_cross_cap")
graphB = exf(H, "graph_basis_coefficient_error")
postCM = exf(H, "post_CM_add_coefficient_error")
ifftE = exf(H, "source_iFFT_error")
coef_FG = QQ(2047)
coef_fg = QQ(1)
Qq = QQ(18433)
Nn = QQ(1536)

RIF256 = RealIntervalField(256)

def sqrt_up_exact_int(p):
    """independent exact-integer outward enclosure (crosscheck)."""
    if p <= 0:
        return QQ(0)
    num = ZZ(p.numerator() * 10 ** 24 // p.denominator())
    t = num.isqrt()
    return (t + 1) / (10 ** 12)

def sqrt_up(p):
    """strict outward upper bound for sqrt(p) >= 0: RealIntervalField(256)
    enclosure, upper endpoint is an exact rational (principle: real bounds via
    rigorous balls/intervals with outward enclosure)."""
    if p <= 0:
        return QQ(0)
    iv = RIF256(p).sqrt()
    bound = QQ(iv.upper().exact_rational())
    assert bound * bound >= p          # exact outwardness certificate (ZZ/QQ)
    return bound

SQ43 = sqrt_up(QQ(4) / QQ(3))

def tr(b):
    return SQ43 * b

# A: target/construction terms through the exact coefficient basis
eps_det = 2 * (eps_FG * abs_fg + eps_fg * abs_FG) + eps_FG ** 2 + eps_fg ** 2
A1 = tr(chalE)
A2 = tr(Cwcap / Qq * eps_det)
A3 = tr(rho0 * abs_fg + rho1 * abs_FG)
A4 = tr(t0cap * eps_fg + t1cap * eps_FG)
A_total = A1 + A2 + A3 + A4
A_coarse = tr((ideE0 + rho0) * abs_fg + (ideE1 + rho1) * abs_FG)

# B: Z(Y)*(B'_words - B_exact)
B_total = tr((t0cap + Xcap) * eps_fg + (t1cap + Ycap) * eps_FG)

# C: tree identity defects through the exact basis
etaT = Er + Eh + Elast
C1 = graphB
C1_alt_boxes = tr((delta + eroot) * sqrt_up(amax) + delta * sqrt_up(Pperp))

def eimage_of(xx):
    return amax * (xx + eroot) ** 2 + 2 * Cross * (xx + eroot) * xx + Pperp * xx ** 2

C1_formula = tr(sqrt_up(eimage_of(delta)))
C2 = Nn * (coef_fg + coef_FG) * etaT
C3 = tr((delta + eroot + Nn * etaT) * (eps_fg + eps_FG))
C_failed_conv = Nn * sqrt_up(QQ(2)) * (delta + eroot) * coef_FG

D_suffix = postCM
E_ifft = ifftE
TOTAL = A_total + B_total + C1 + C2 + C3 + D_suffix + E_ifft

# sensitivity (per-coefficient share 1/10 of the strict 1/2 budget)
share = QQ(1) / QQ(10)
k_word = min(share / B_total, share / (A2 + A4))
eps_fg_need = eps_fg * k_word
eps_FG_need = eps_FG * k_word
rel_need_fg = eps_fg_need / abs_fg
rel_need_FG = eps_FG_need / abs_FG
lo, hi = QQ(0), delta
for _ in range(200):
    mid = (lo + hi) / 2
    if tr(sqrt_up(eimage_of(mid))) <= share:
        lo = mid
    else:
        hi = mid
delta_need = lo
etaT_need = share / (Nn * (coef_fg + coef_FG))

# --- C controls: fpr_rint nearest-even rule (RINT_REFINEMENT) vs exact oracle ---
def rint_rule(num, e):
    den = ZZ(2) ** e
    neg = num < 0
    aa = -num if neg else num
    qq, rr = divmod(ZZ(aa), den)
    if 2 * rr > den or (2 * rr == den and (ZZ(qq) % 2 == 1)):
        qq += 1
    return -qq if neg else qq

def oracle(num, den):
    neg = num < 0
    aa = -num if neg else num
    qq, rr = divmod(ZZ(aa), ZZ(den))
    if 2 * rr > den or (2 * rr == den and (ZZ(qq) % 2 == 1)):
        qq += 1
    return -qq if neg else qq

tie = {"strict": 0, "tie_even_ok": 0, "fail": 0, "recovery_fail": 0}
for e in (1, 2, 3, 10, 24, 52, 63):
    den = ZZ(2) ** e
    for v in (0, 1, 2, 3, 32767, 32768, -1, -2, -32768, 4572095, -4572095):
        for off in (0, 1, den - 1, den // 2, den // 2 + 1, den // 2 - 1, den):
            for sgn in (1, -1):
                num = sgn * (ZZ(v) * den + off)
                got = rint_rule(num, e)
                want = oracle(num, den)
                if got != want:
                    tie["fail"] += 1
                elif 2 * (abs(num) % den) == den:
                    tie["tie_even_ok"] += 1
                else:
                    tie["strict"] += 1
                for cand in set([want, want - 1, want + 1]):
                    d_ = abs(num / den - QQ(cand))
                    if d_ < (1 / 2) and got != cand:
                        tie["recovery_fail"] += 1
                    if d_ == (1 / 2) and cand % 2 == 0 and got != cand:
                        tie["recovery_fail"] += 1
tie["boundary_half_values_ok"] = all(
    rint_rule(ZZ(2 * v + 1) * (ZZ(2) ** 4), 5) == (v if v % 2 == 0 else v + 1)
    for v in range(-8, 8))
tie_pass = (tie["fail"] == 0 and tie["recovery_fail"] == 0
            and tie["boundary_half_values_ok"])

def rec(qqval):
    return {"exact": str(qqval), "float": float(RR(qqval))}

# crosscheck: BOTH enclosures are certified outward (bound^2 >= 4/3 over QQ);
# tightness comparison is informational only (RIF(256) upper is tighter here).
sq43_int = sqrt_up_exact_int(QQ(4) / QQ(3))
assert sq43_int * sq43_int >= QQ(4) / QQ(3)
assert SQ43 * SQ43 >= QQ(4) / QQ(3)

out = {
    "schema": "ft1536.reference_integer_recovery.gap_composition/1",
    "engine": "sage-10.9 (sage checks/sage/gap_composition.sage; preparser on)",
    "transport_convention": "coeff <= sqrt(4/3) * pointwise-root bound (pinned H6P A2)",
    "terms_per_coefficient": {
        "A1_challenge_fft_words": rec(A1),
        "A2_det_error_x_challenge": rec(A2),
        "A3_target_rounding_layer": rec(A3),
        "A4_word_errors_x_target": rec(A4),
        "A_total_refined": rec(A_total),
        "A_coarse_pinned_route": rec(A_coarse),
        "B_word_residuals_x_Z": rec(B_total),
        "C1_tree_reconstruction_pinned": rec(C1),
        "C1_formula_crosscheck": rec(C1_formula),
        "C1_alt_independent_boxes": rec(C1_alt_boxes),
        "C2_terminal_box": rec(C2),
        "C3_defect_x_word_errors": rec(C3),
        "C_failed_convolution_route": rec(C_failed_conv),
        "D_suffix_CM_add": rec(D_suffix),
        "E_ifft": rec(E_ifft),
        "TOTAL_gap_bound": rec(TOTAL),
    },
    "intermediates": {
        "eps_det": rec(eps_det),
        "etaT": rec(etaT),
        "sqrt43_outward": rec(SQ43),
        "sqrt43_outward_crosscheck_exact_int": rec(sq43_int),
        "real_bound_engine": "RealIntervalField(256) outward right endpoint",
        "required_gap_strict": "1/2",
        "gap_met": bool(TOTAL < (1 / 2)),
    },
    "sensitivity_minimal_missing_constants": {
        "eps_fg_needed_absolute": rec(eps_fg_need),
        "eps_FG_needed_absolute": rec(eps_FG_need),
        "eps_fg_needed_relative_to_value_cap": rec(rel_need_fg),
        "eps_FG_needed_relative_to_value_cap": rec(rel_need_FG),
        "delta_needed_absolute": rec(delta_need),
        "etaT_needed_absolute": rec(etaT_need),
        "note": "thresholds are per-coefficient shares 1/10 of the strict 1/2 budget; delta floor already dominated by eroot (share needs eroot too)",
    },
    "rint_tie_controls": {k: int(v) for k, v in tie.items()},
    "rint_tie_pass": bool(tie_pass),
}
with open("checks/gap_composition.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)
for k, v in out["terms_per_coefficient"].items():
    print("%-34s %-24s ~ %.8g" % (k, v["exact"][:22], v["float"]))
print("rint tie pass:", out["rint_tie_pass"], out["rint_tie_controls"])
print("TOTAL < 1/2 :", out["intermediates"]["gap_met"])
if not (out["rint_tie_pass"] and not out["intermediates"]["gap_met"]):
    raise SystemExit(1)
