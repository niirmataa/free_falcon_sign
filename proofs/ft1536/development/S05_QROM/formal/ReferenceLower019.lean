import JointInterface019

/- Denominator-law change is paid explicitly. A certificate against the
   ideal reference is not silently a certificate against source Sign. -/
namespace FT1536.S05.ReferenceLower019
open Finset FT1536.Divergence
variable {A : Type} [Fintype A]

def OnSupportLower (j p realLaw : Law A) (k : ℝ) : Prop :=
  ∀ a,j.mass a≠0 → p.mass a≤k*realLaw.mass a

theorem ac_transfer (j p realLaw : Law A) (ac : AC j p) (k : ℝ)
    (lower : OnSupportLower j p realLaw k) : AC j realLaw := by
  intro a hr
  by_cases hj : j.mass a=0
  · exact hj
  · have hp := lower a hj
    rw [hr,mul_zero] at hp
    exact ac a (le_antisymm hp (p.nonneg a))

theorem atom_transfer (j p realLaw : Law A) (ac : AC j p) (k : ℝ) (hk : 0<k)
    (lower : OnSupportLower j p realLaw k) (a : A) :
    j.mass a^2/realLaw.mass a≤k*(j.mass a^2/p.mass a) := by
  by_cases hj : j.mass a=0
  · simp [hj]
  · have hp0 : p.mass a≠0 := fun hz => hj (ac a hz)
    have hp : 0<p.mass a := lt_of_le_of_ne (p.nonneg a) (Ne.symm hp0)
    have hd : p.mass a/k≤realLaw.mass a := (div_le_iff₀ hk).2 (by simpa [mul_comm] using lower a hj)
    calc
      _ ≤ j.mass a^2/(p.mass a/k) := div_le_div_of_nonneg_left (sq_nonneg _) (div_pos hp hk) hd
      _ = _ := by field_simp

theorem second_transfer (j p realLaw : Law A) (ac : AC j p) (k : ℝ) (hk : 0<k)
    (lower : OnSupportLower j p realLaw k) :
    second j realLaw≤k*second j p := by
  unfold second
  rw [mul_sum]
  exact sum_le_sum (fun a _ => atom_transfer j p realLaw ac k hk lower a)

theorem budget_transfer (j p realLaw : Law A) (e k : ℝ) (hk : 0<k)
    (cert : AC j p ∧ second j p≤1+e) (lower : OnSupportLower j p realLaw k) :
    AC j realLaw ∧ second j realLaw≤k*(1+e) :=
  ⟨ac_transfer j p realLaw cert.1 k lower,
    (second_transfer j p realLaw cert.1 k hk lower).trans (mul_le_mul_of_nonneg_left cert.2 hk.le)⟩

noncomputable def paidError (e k : ℝ) : ℝ := k*(1+e)-1

theorem paid_budget (j p realLaw : Law A) (e k : ℝ) (hk : 0<k)
    (cert : AC j p ∧ second j p≤1+e) (lower : OnSupportLower j p realLaw k) :
    AC j realLaw ∧ second j realLaw≤1+paidError e k := by
  have h := budget_transfer j p realLaw e k hk cert lower
  have he : k*(1+e)=1+paidError e k := by unfold paidError; ring
  rwa [he] at h

theorem paidError_one (e : ℝ) : paidError e 1=e := by unfold paidError; ring

#print axioms ac_transfer
#print axioms atom_transfer
#print axioms second_transfer
#print axioms budget_transfer
#print axioms paid_budget
#print axioms paidError_one
end FT1536.S05.ReferenceLower019
