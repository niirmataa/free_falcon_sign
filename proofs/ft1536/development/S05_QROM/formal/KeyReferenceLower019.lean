import ReferencePaid019

namespace FT1536.S05.KeyReferenceLower019
open FT1536.Divergence ReferenceLower019
variable {H A : Type} [Fintype H] [Fintype A]

/-- Same key law on both sides, and only its actual support is required. -/
theorem joint_lower (mu : Law H) (j p realLaw : H → Law A) (k : ℝ)
    (lower : ∀ h,mu.mass h≠0 → OnSupportLower (j h) (p h) (realLaw h) k) :
    OnSupportLower (joint mu j) (joint mu p) (joint mu realLaw) k := by
  rintro ⟨h,a⟩ hj
  have hm : mu.mass h≠0 := by
    intro hz
    exact hj (by simp [joint,hz])
  have hja : (j h).mass a≠0 := by
    intro hz
    exact hj (by simp [joint,hz])
  have step := mul_le_mul_of_nonneg_left (lower h hm a hja) (mu.nonneg h)
  change mu.mass h*(p h).mass a≤k*(mu.mass h*(realLaw h).mass a)
  nlinarith [step]

theorem joint_paid (mu : Law H) (j p realLaw : H → Law A) (e k : ℝ) (hk : 0<k)
    (cert : AC (joint mu j) (joint mu p) ∧ second (joint mu j) (joint mu p)≤1+e)
    (lower : ∀ h,mu.mass h≠0 → OnSupportLower (j h) (p h) (realLaw h) k) :
    AC (joint mu j) (joint mu realLaw) ∧ second (joint mu j) (joint mu realLaw)≤1+paidError e k :=
  paid_budget _ _ _ e k hk cert (joint_lower mu j p realLaw k lower)

#print axioms joint_lower
#print axioms joint_paid
end FT1536.S05.KeyReferenceLower019
