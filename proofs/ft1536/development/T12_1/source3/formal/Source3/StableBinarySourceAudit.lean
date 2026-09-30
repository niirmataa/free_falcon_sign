import Source3.StableBinarySourceProof
import Source3.StableBinaryAudit
import Source3.FprPrimitivesAudit

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinarySourceAudit
open FT1536.Source3

def wrongRight : List String := StableBinaryPin.lines.set 22
  "\tft_stable_binary_inplace_keygen(values, hn, scratch, bad);\n"

theorem rejects_wrong_right : StableBinarySourceSyntax.parse wrongRight=none := by decide

/- Replacing the C fpr_add spelling still parses, but it produces a DIFFERENT
   operational AST. No token-equality trick silently identifies its call
   with the pinned addition. -/
def wrongAdd : List String := StableBinaryPin.lines.set 14
  "\tsum = ft_stable_positive_keygen(fpr_mul(a, b), bad);\n"

theorem wrong_add_changes_ast :
    StableBinarySourceSyntax.parse wrongAdd = some
      {StableBinarySourceSyntax.expected with
        sum := {StableBinarySourceSyntax.expected.sum with callee := "fpr_mul".toList}} := by
  decide

end FT1536.Source3.StableBinarySourceAudit

#print axioms FT1536.Source3.StableBinarySourceAudit.rejects_wrong_right
#print axioms FT1536.Source3.StableBinarySourceAudit.wrong_add_changes_ast
#print axioms FT1536.Source3.StableBinaryAudit.rejects_bad_reset
#print axioms FT1536.Source3.FprPrimitivesAudit.mul_normalize_mutation_changes_word
#print axioms FT1536.Source3.FprPrimitivesAudit.div_54_changes_word
