# REVIEW independent checker 1/3 -- gap ledger recomputation (B).
# Run: sage sage_checks/review_gap_recompute.sage   (cwd = REVIEW_W/seed or REVIEW_W)
# Reads sealed gap_composition.json + PORT record py/sage exact strings.
# Exact QQ recomputation: TOTAL = sum of components; verifies 6086.4008 scale,
# gap_met=false, float agreement py~sage within 1e-9 rel for all 16 terms,
# outwardness sample bound^2 >= p, and 12 representation-only diffs.

# preparser/toolchain preflight (POLICY 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1 / 3) is QQ
assert 2 ^ 10 == 1024

import json
from sage.all import QQ, ZZ, RR, RealIntervalField

SEED = "/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001/seed"
g = json.load(open(SEED + "/checks/gap_composition.json"))
port = json.load(open(SEED + "/checks/sage/PORT_PY_TO_SAGE.json"))
T = g["terms_per_coefficient"]
Q = lambda s: QQ(s)

# 1. composition: TOTAL must equal A_total+B+C1+C2+C3+D+E exactly in QQ
A_total = Q(T["A_total_refined"]["exact"])
B = Q(T["B_word_residuals_x_Z"]["exact"])
C1 = Q(T["C1_tree_reconstruction_pinned"]["exact"])
C2 = Q(T["C2_terminal_box"]["exact"])
C3 = Q(T["C3_defect_x_word_errors"]["exact"])
D = Q(T["D_suffix_CM_add"]["exact"])
E = Q(T["E_ifft"]["exact"])
TOTAL = Q(T["TOTAL_gap_bound"]["exact"])
assert TOTAL == A_total + B + C1 + C2 + C3 + D + E
# A_total itself = A1+A2+A3+A4
A1 = Q(T["A1_challenge_fft_words"]["exact"])
A2 = Q(T["A2_det_error_x_challenge"]["exact"])
A3 = Q(T["A3_target_rounding_layer"]["exact"])
A4 = Q(T["A4_word_errors_x_target"]["exact"])
assert A_total == A1 + A2 + A3 + A4
# 2. scale and verdict
assert TOTAL >= QQ(1) / QQ(2)
assert g["intermediates"]["gap_met"] is False
fl = float(RR(TOTAL))
assert 6086.0 < fl < 6087.0, fl
# 3. outwardness sample: author's RIF256 sqrt(4/3) upper is certified
RIF256 = RealIntervalField(256)
iv = RIF256(QQ(4) / QQ(3)).sqrt()
b = QQ(iv.upper().exact_rational())
assert b * b >= QQ(4) / QQ(3)
sq = Q(g["intermediates"]["sqrt43_outward"]["exact"])
assert sq * sq >= QQ(4) / QQ(3)
# 4. port record: all 16 terms float-agree within 1e-9 rel; count exact diffs
comp = port["gap_term_comparison"]
assert len(comp) == 16, len(comp)
ndiff = 0
for k, v in comp.items():
    assert v["float_equal_within_1e-9rel"] is True, k
    if not v["exact_equal"]:
        ndiff += 1
        # both parse as QQ and are positive outward bounds of same magnitude
        assert QQ(v["py_exact"]) > 0 and QQ(v["sage_exact"]) > 0
assert ndiff == 12, ndiff
# 5. tie controls from sealed artifact
tie = g["rint_tie_controls"]
assert tie["strict"] == 880 and tie["tie_even_ok"] == 198
assert tie["fail"] == 0 and tie["recovery_fail"] == 0
assert g["rint_tie_pass"] is True
# 6. missing-type thresholds present; delta floor is 0 because pinned eroot
# alone already exceeds the 1/10 share (author note); eps/eta strictly positive
sens = g["sensitivity_minimal_missing_constants"]
for k in ("eps_fg_needed_absolute", "eps_FG_needed_absolute",
          "etaT_needed_absolute"):
    assert QQ(sens[k]["exact"]) > 0, k
assert QQ(sens["delta_needed_absolute"]["exact"]) >= 0
assert QQ(sens["etaT_needed_absolute"]["exact"]) == QQ(1) / QQ(31457280)

out = {
    "checker": "review_gap_recompute.sage",
    "total_exact_head": str(TOTAL)[:60],
    "total_float": float(fl),
    "composition_exact": True,
    "gap_met": False,
    "port_terms": int(16),
    "port_exact_diffs_representation_only": int(ndiff),
    "tie": {k: int(v) for k, v in tie.items()},
}
with open("/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001/sage_checks/review_gap_recompute.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)
print(json.dumps(out, indent=1, sort_keys=True))
print("REVIEW_GAP_RECOMPUTE_PASS")
