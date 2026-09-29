# Preparation-only arithmetic for T03-B. No source execution or proof replay.
# Usage: sage check_budget.sage INPUT_DIR OUTPUT_JSON
assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024

import json
import sys
from pathlib import Path
from sage.env import SAGE_VERSION

inputs = Path(sys.argv[1])
output = Path(sys.argv[2])
ledger = json.loads((inputs / "T03/checks/gap_composition.json").read_text())
constants = json.loads((inputs / "T03/checks/constants_extract.json").read_text())
terms = {k: QQ(v["exact"]) for k, v in ledger["terms_per_coefficient"].items()}
RIF = RealIntervalField(256)

def record(value):
    value = QQ(value)
    return {"exact": str(value), "display_interval_only": str(RIF(value))}

def constant(section, key):
    value = constants[section][key]
    return QQ(value["exact"] if isinstance(value, dict) else str(value))

def sqrt_up(value):
    assert value >= 0
    upper = QQ(RIF(value).sqrt().upper().exact_rational())
    assert upper >= 0 and upper^2 >= value
    return upper

atomic = ["A1_challenge_fft_words", "A2_det_error_x_challenge",
          "A3_target_rounding_layer", "A4_word_errors_x_target",
          "B_word_residuals_x_Z", "C1_tree_reconstruction_pinned",
          "C2_terminal_box", "C3_defect_x_word_errors",
          "D_suffix_CM_add", "E_ifft"]
assert len(atomic) == len(set(atomic)) == 10
assert all(terms[k] >= 0 for k in atomic)
assert sum(terms[k] for k in atomic) == terms["TOTAL_gap_bound"]
assert sum(terms[k] for k in atomic[:4]) == terms["A_total_refined"]

# Most optimistic ablation: erase ALL contributions involving the three
# families mentioned in §3, including cross terms, but leave A1/A3/D/E.
# This is a floor of that modified MAJORANT, not of the actual source error.
remaining = ["A1_challenge_fft_words", "A3_target_rounding_layer",
             "D_suffix_CM_add", "E_ifft"]
floor_ledger = sum(terms[k] for k in remaining)
assert terms["D_suffix_CM_add"] > 1/2
assert floor_ledger > 16
margin_if_D_zero = 1/2 - sum(terms[k] for k in remaining if k != "D_suffix_CM_add")
assert 0 < margin_if_D_zero < 3/50

# §3 says "one tenth of the 1/2 budget", while the historical producer
# explicitly uses share=1/10. Keep the two values distinct.
historical_share = 1/10
literal_tenth_of_half = (1/10)*(1/2)
assert historical_share == 2*literal_tenth_of_half
assert QQ(ledger["sensitivity_minimal_missing_constants"]["etaT_needed_absolute"]["exact"]) * 1536 * 2048 == historical_share

# Test the rounded (delta, eroot) pair quoted in §3 against the SAME
# triangular expression, using rigorous outward square roots.
H = "H6P/ERROR_LEDGER.json"
sq43 = QQ(ledger["intermediates"]["sqrt43_outward"]["exact"])
assert sq43 > 0 and sq43^2 >= 4/3
amax = constant(H, "actual_basis_a_upper")
perp = constant(H, "orthogonal_residual_row_norm_squared_cap")
cross = constant(H, "nonorthogonal_cross_cap")
delta = QQ("0.0000033")
eroot = QQ("0.000037")
energy = amax*(delta + eroot)^2 + 2*cross*(delta + eroot)*delta + perp*delta^2
C1_at_quoted_pair = sq43 * sqrt_up(energy)
assert (4/3)*energy > historical_share^2

# A concrete, nonbinding allocation for the NEXT proof. These are goals,
# not source-instantiated bounds or new assumptions about required keys.
allocation = {
    "A1": 1/1000,
    "A2_plus_A4_plus_B": 1/10,
    "A3": 1/20,
    "C1": 1/10,
    "C2": 1/10,
    "C3": 1/1000,
    "D": 1/20,
    "E": 1/128,
}
allocation_sum = sum(allocation.values())
assert allocation_sum == 6557/16000
assert 1/2 - allocation_sum == 1443/16000
assert terms["A1_challenge_fft_words"] <= allocation["A1"]
assert terms["E_ifft"] == allocation["E"]

# Meaningful omission control: a proposed completed budget with unchanged
# historical D must fail, even when every other contribution is zero.
def closes(values):
    return all(v >= 0 for v in values) and sum(values) < 1/2

assert closes(list(allocation.values()))
bad_allocation = dict(allocation, D=terms["D_suffix_CM_add"])
assert not closes(list(bad_allocation.values()))
assert not closes([1/2])

result = {
    "schema": "FT1536_T03_B_GAP_PREPARATION_V1",
    "status": "TASK_BUDGET_CONSISTENCY_CHECKED",
    "sage_version": SAGE_VERSION,
    "preparser_checks": True,
    "historical_majorant": record(terms["TOTAL_gap_bound"]),
    "atomic_terms": atomic,
    "remaining_after_idealized_three_family_fix": {
        "terms": remaining,
        "majorant_floor": record(floor_ledger),
        "is_actual_error_lower_bound": False,
    },
    "D_alone": record(terms["D_suffix_CM_add"]),
    "A3_alone": record(terms["A3_target_rounding_layer"]),
    "available_if_D_zero_and_A1_A3_E_unchanged": record(margin_if_D_zero),
    "share_wording": {"producer_share": record(historical_share),
                      "literal_tenth_of_half": record(literal_tenth_of_half)},
    "quoted_tree_pair": {"delta": record(delta), "eroot": record(eroot),
                         "C1_outward": record(C1_at_quoted_pair),
                         "exact_squared_expression_exceeds_0_1_squared": True},
    "proposed_budget_only": {k: record(v) for k, v in allocation.items()},
    "proposed_budget_sum": record(allocation_sum),
    "proposed_budget_strict_margin": record(1/2 - allocation_sum),
    "controls": {"ten_term_recomposition": True, "old_D_rejected": True,
                 "equality_half_rejected": True},
    "source_bounds_proved": False,
    "B_gap_closed": False,
    "independent_review_performed": False,
    "required_domain_counterexample": False,
}
output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
print("SageMath", SAGE_VERSION, "preparser QQ/ZZ: PASS")
for label, value in [("historical majorant", terms["TOTAL_gap_bound"]),
                     ("remaining majorant floor", floor_ledger),
                     ("D alone", terms["D_suffix_CM_add"]),
                     ("remaining margin after D=0", margin_if_D_zero),
                     ("C1 at quoted pair", C1_at_quoted_pair),
                     ("proposed allocation", allocation_sum)]:
    print(label + ":", RIF(value))
print("TASK_BUDGET_CONSISTENCY_CHECKED; source bounds NOT proved; B-gap OPEN")
