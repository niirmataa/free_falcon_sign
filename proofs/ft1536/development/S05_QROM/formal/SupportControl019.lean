import BoundaryControls019

namespace FT1536.S05.SupportControl019
open BoundaryControls019 FT1536.Divergence

/-- Lean's real division defines division by zero as zero. The raw finite
    second sum therefore cannot replace the separate AC obligation. -/
theorem raw_second_misleads : second independent correlated=1/4 := by
  norm_num [second,correlated,independent,answer,Law.map,Law.bind,Law.pure,Law.uniform,Divergence.joint,Fintype.sum_prod_type]

theorem no_chi2_certificate : chi2 independent correlated=⊤ := by
  classical
  simp [chi2,independent_not_ac]

#print axioms raw_second_misleads
#print axioms no_chi2_certificate
end FT1536.S05.SupportControl019
