import ReferenceLower019
import ObservationMoment019

namespace FT1536.S05.ReferencePaid019
open FT1536.Divergence ReferenceLower019
variable {A : Type} [Fintype A]

theorem paid_nonneg (j p realLaw : Law A) (e k : ℝ) (hk : 0<k)
    (cert : AC j p ∧ second j p≤1+e) (lower : OnSupportLower j p realLaw k) :
    0≤paidError e k := by
  have h := paid_budget j p realLaw e k hk cert lower
  have lo := energy_ge_one j realLaw (densityOfAC j realLaw h.1)
  rw [energy_eq_second] at lo
  linarith [h.2]

theorem observed_paid_budget {O : Type} [Fintype O] [DecidableEq O]
    (j p realLaw : Law A) (e k : ℝ) (hk : 0<k)
    (cert : AC j p ∧ second j p≤1+e) (lower : OnSupportLower j p realLaw k) (f : A → O) :
    AC (j.map f) (realLaw.map f) ∧ second (j.map f) (realLaw.map f)≤1+paidError e k := by
  have h := paid_budget j p realLaw e k hk cert lower
  exact ObservationMoment019.full_observation j realLaw _ h.1 h.2 f

#print axioms paid_nonneg
#print axioms observed_paid_budget
end FT1536.S05.ReferencePaid019
