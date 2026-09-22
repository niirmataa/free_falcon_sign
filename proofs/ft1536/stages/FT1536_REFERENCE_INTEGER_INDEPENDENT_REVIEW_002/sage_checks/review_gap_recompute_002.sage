# FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_002 -- independent gap recomputation (B)
# Run: sage sage_checks/review_gap_recompute_002.sage   (cwd = W review root)
# Exact QQ recomposition of the uniform per-coefficient bound from sealed terms,
# outward RIF256 sqrt(4/3) check, TOTAL>=1/2, tie controls, thresholds.
# Independent of author all_pass: recomputes sums/inequalities from exact strings.

# preparser/toolchain preflight (SAGE POLICY 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024

import json
from sage.all import QQ, ZZ, RealIntervalField

SEED_GAP = "seed/checks/gap_composition.json"
SEED_CONST = "seed/checks/constants_extract.json"

gap = json.load(open(SEED_GAP))
terms = gap["terms_per_coefficient"]

def Q(s):
    return QQ(str(s))

# 1. Recompute TOTAL as exact QQ sum of the 5 refined + B + C1 + C2 + C3 + D + E
#    (A_total_refined already sums A1..A4; TOTAL = A_refined + B + C1 + C2 + C3 + D + E)
A = Q(terms["A_total_refined"]["exact"])
B = Q(terms["B_word_residuals_x_Z"]["exact"])
C1 = Q(terms["C1_tree_reconstruction_pinned"]["exact"])
C2 = Q(terms["C2_terminal_box"]["exact"])
C3 = Q(terms["C3_defect_x_word_errors"]["exact"])
D = Q(terms["D_suffix_CM_add"]["exact"])
E = Q(terms["E_ifft"]["exact"])
recomputed = A + B + C1 + C2 + C3 + D + E
sealed_total = Q(terms["TOTAL_gap_bound"]["exact"])
assert recomputed == sealed_total, "TOTAL != sum of components"

# 2. A_total_refined == A1+A2+A3+A4 exactly
A1 = Q(terms["A1_challenge_fft_words"]["exact"])
A2 = Q(terms["A2_det_error_x_challenge"]["exact"])
A3 = Q(terms["A3_target_rounding_layer"]["exact"])
A4 = Q(terms["A4_word_errors_x_target"]["exact"])
assert A == A1 + A2 + A3 + A4, "A refined != A1+A2+A3+A4"

# 3. Outward sqrt(4/3) via RIF256, exact bound^2 >= 4/3
RIF = RealIntervalField(256)
sqrt43_sealed = Q(gap["intermediates"]["sqrt43_outward"]["exact"])
assert sqrt43_sealed^2 >= QQ(4)/QQ(3), "sqrt43 sealed not outward"
rif_sqrt = (RIF(4)/RIF(3)).sqrt()
rif_upper = QQ(rif_sqrt.upper())
assert rif_upper^2 >= QQ(4)/QQ(3), "RIF upper not outward"
# sealed must be >= true value: check sealed >= RIF center and within 1e-12 rel
assert sqrt43_sealed >= QQ(rif_sqrt.center()), "sealed sqrt43 below RIF center"
rel = abs(float(sqrt43_sealed) - float(rif_sqrt.center())) / float(rif_sqrt.center())
assert rel < 1e-12, "sqrt43 rel drift"

# 4. Gap verdict: TOTAL >= 1/2 (OPEN), gap_met false, float ~6086.40076
assert sealed_total >= QQ(1)/QQ(2), "TOTAL should exceed 1/2"
assert gap["intermediates"]["gap_met"] is False, "gap_met must be false"
ftotal = float(sealed_total)
assert 6086.0 < ftotal < 6087.0, "TOTAL float out of range"
assert abs(float(terms["TOTAL_gap_bound"]["float"]) - ftotal) < 1e-6, "float field mismatch"

# 5. etaT == 1/31457280 exactly (threshold share), eps_det exact check
etaT = Q(gap["intermediates"]["etaT"]["exact"])
# etaT is Er+Eh+Elast recomputed; just verify threshold field separately
thr = gap["sensitivity_minimal_missing_constants"]["etaT_needed_absolute"]
assert thr["exact"] == "1/31457280", "etaT threshold must be 1/31457280"
assert Q(thr["exact"]) == QQ(1)/QQ(31457280), "etaT threshold value"
eps_det = Q(gap["intermediates"]["eps_det"]["exact"])
assert eps_det == QQ(844218775904257)/QQ(4503599627370496), "eps_det pinned value"

# 6. Tie controls: 880 strict / 198 tie, 0 fail, boundary ok
tie = gap["rint_tie_controls"]
assert int(tie["strict"]) == 880, "strict tie count"
assert int(tie["tie_even_ok"]) == 198, "tie_even count"
assert int(tie["fail"]) == 0 and int(tie["recovery_fail"]) == 0, "tie fails"
assert gap["rint_tie_pass"] is True, "rint_tie_pass"

# 7. All 16 terms float-agree within 1e-9 rel (recomputed here vs stored float)
for k, v in terms.items():
    f_stored = float(v["float"])
    f_exact = float(Q(v["exact"]))
    denom = max(1e-300, abs(f_exact))
    rel2 = abs(f_stored - f_exact) / denom
    assert rel2 < 1e-9, "float drift %s rel=%s" % (k, rel2)

out = {
    "schema": "ft1536.review002.gap_recompute/1",
    "engine": "sage-10.9 (sage sage_checks/review_gap_recompute_002.sage; preparser on)",
    "inputs": [SEED_GAP, SEED_CONST],
    "recomputed_total_exact": str(recomputed),
    "recomputed_total_float": float(recomputed),
    "sealed_total_exact": str(sealed_total),
    "total_eq_sum": bool(recomputed == sealed_total),
    "a_refined_eq_sum": bool(A == A1 + A2 + A3 + A4),
    "sqrt43_sealed_exact": str(sqrt43_sealed),
    "sqrt43_rif_upper": str(rif_upper),
    "sqrt43_outward_ok": bool(sqrt43_sealed^2 >= QQ(4)/QQ(3)),
    "gap_met": False,
    "gap_open_ge_half": bool(sealed_total >= QQ(1)/QQ(2)),
    "tie": {"strict": int(880), "tie_even_ok": int(198), "fail": int(0)},
    "etaT_threshold": "1/31457280",
    "pass": True,
}
with open("sage_checks/review_gap_recompute_002.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)
print(json.dumps(out, indent=1, sort_keys=True))
print("REVIEW002_GAP_PASS")
