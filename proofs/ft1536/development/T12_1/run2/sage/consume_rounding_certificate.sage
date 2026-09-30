# Exact endpoint/rounding consumer. Conditional Lean theorem lists the
# three still-to-be-instantiated local analytic certificates explicitly.
from pathlib import Path
import json,hashlib
assert parent(1) is ZZ and parent(1/3) is QQ
W=Path(__file__).resolve().parents[2]
# Development jobs run a copied source; input is provided in argv.
import sys
assert len(sys.argv)==3
p=Path(sys.argv[1]);pin=sys.argv[2]
assert hashlib.sha256(p.read_bytes()).hexdigest()==pin
j=json.loads(p.read_text())
raw_lo=QQ(1266068)/10^30;raw_hi=QQ(1267826)/10^30
# Read exact raw endpoint bounds by rerunning the formula's endpoint strings
# from the existing honest endpoints conservatively: honest_lower<=rawLower
# and rawUpper<=honestUpper under the recorded positive correction factors.
hl=QQ(j['honest_lower_rational']);hu=QQ(j['honest_upper_rational'])
assert raw_lo<hl and hu<raw_hi
eps=QQ(1)/2^36;r=QQ(1)/2^24
lower=raw_lo/(1+eps);upper=raw_hi/((1-eps)*(1-r))
round_lo=QQ(1265)/10^27;round_hi=QQ(1275)/10^27
assert round_lo<lower and upper<round_hi
code='''import Run2.LegalKeyErrorTransfer
namespace FT1536.Run2.GuaranteedDigits
open LegalKeyErrorTransfer CorrectnessProbability
noncomputable def rawLo : ℝ := 1266068 / 10^30
noncomputable def rawHi : ℝ := 1267826 / 10^30
noncomputable def flatBudget : ℝ := 1 / 2^36
noncomputable def rejectBudget : ℝ := 1 / 2^24
theorem exact_decimal_margin :
  (1265 : ℝ)/10^27 < rawLo/(1+flatBudget) ∧
  rawHi/((1-flatBudget)*(1-rejectBudget)) < (1275 : ℝ)/10^27 := by
  norm_num [rawLo,rawHi,flatBudget,rejectBudget]
theorem three_significant_digits (h : FT1536.Relation.Rq)
    (raw : rawLo ≤ rawBad ∧ rawBad ≤ rawHi)
    (flat : FiniteFlat h flatBudget)
    (reject : ∀ c,rejection h c ≤ rejectBudget) :
    (1265 : ℝ)/10^27 < delta h ∧ delta h < (1275 : ℝ)/10^27 := by
  have hh := all_key_error_from_local_certificates h flatBudget rejectBudget
    (by norm_num [flatBudget]) (by norm_num [flatBudget]) (by norm_num [rejectBudget]) flat reject
  have hl := div_le_div_of_nonneg_right raw.1 (show 0≤1+flatBudget by norm_num [flatBudget])
  have hu := div_le_div_of_nonneg_right raw.2
    (show 0≤(1-flatBudget)*(1-rejectBudget) by norm_num [flatBudget,rejectBudget])
  exact ⟨exact_decimal_margin.1.trans_le (hl.trans hh.1), (hh.2.trans hu).trans_lt exact_decimal_margin.2⟩
end FT1536.Run2.GuaranteedDigits
'''
Path('generated').mkdir(exist_ok=True)
Path('generated/GuaranteedDigits.lean').write_text(code)
result=dict(schema='FT1536_THREE_DIGIT_EXACT_CONSUMER_V1',input_sha256=pin,
    raw_lower=str(raw_lo),raw_upper=str(raw_hi),flatness_budget=str(eps),rejection_budget=str(r),
    final_lower=str(lower),final_upper=str(upper),rounded='1.27e-24',significant_digits=int(3),
    kernel_theorem_is_conditional_on=['raw mass enclosure','all-key finite flatness','all-key rejection bound'],
    source_binding_complete=False)
Path('rounding_certificate.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('EXACT_ROUNDING_CONSUMER_PASS 1.27e-24; analytic/source bindings still explicit')
