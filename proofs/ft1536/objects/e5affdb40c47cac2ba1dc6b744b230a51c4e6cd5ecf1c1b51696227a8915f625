import FT1536.Basic

namespace FT1536.Run2.CyclicAliases

def exactInterval (M k l u x : ℕ) : Prop := M*k+l≤x ∧ x≤M*k+u
def modularInterval (M l u x : ℕ) : Prop := l≤x%M ∧ x%M≤u

instance (M k l u x : ℕ) : Decidable (exactInterval M k l u x) :=
  inferInstanceAs (Decidable (M*k+l≤x ∧ x≤M*k+u))
instance (M l u x : ℕ) : Decidable (modularInterval M l u x) :=
  inferInstanceAs (Decidable (l≤x%M ∧ x%M≤u))

theorem exact_implies_modular (M k l u x : ℕ) (hM : 0<M) (_hlu : l≤u) (hu : u<M)
    (h : exactInterval M k l u x) : modularInterval M l u x := by
  have he := Nat.div_add_mod x M
  have hm := Nat.mod_lt x hM
  have hq : x/M=k := by
    by_contra hn
    rcases Nat.lt_or_gt_of_ne hn with hlo | hhi
    · have ht := Nat.mul_le_mul_left M (Nat.succ_le_of_lt hlo)
      simp only [Nat.mul_succ] at ht
      unfold exactInterval at h
      omega
    · have ht := Nat.mul_le_mul_left M (Nat.succ_le_of_lt hhi)
      simp only [Nat.mul_succ] at ht
      unfold exactInterval at h
      omega
  rw [hq] at he
  unfold exactInterval at h
  unfold modularInterval
  omega

theorem modular_alias_partition (M k l u x : ℕ) (_hM : 0<M)
    (h : modularInterval M l u x) :
    exactInterval M k l u x ∨ x+M≤M*k+u ∨ M*k+l+M≤x := by
  have he := Nat.div_add_mod x M
  unfold modularInterval at h
  by_cases hq : x/M=k
  · left
    rw [hq] at he
    unfold exactInterval
    omega
  · rcases Nat.lt_or_gt_of_ne hq with hlo | hhi
    · right; left
      have ht := Nat.mul_le_mul_left M (Nat.succ_le_of_lt hlo)
      simp only [Nat.mul_succ] at ht
      omega
    · right; right
      have ht := Nat.mul_le_mul_left M (Nat.succ_le_of_lt hhi)
      simp only [Nat.mul_succ] at ht
      omega

theorem alias_probability {Ω : Type} [Fintype Ω] (p : Law Ω) (X : Ω → ℕ)
    (M k l u : ℕ) (hM : 0<M) (hlu : l≤u) (hu : u<M) :
    p.event (fun o => exactInterval M k l u (X o)) ≤ p.event (fun o => modularInterval M l u (X o)) ∧
    p.event (fun o => modularInterval M l u (X o)) ≤
      p.event (fun o => exactInterval M k l u (X o)) +
      p.event (fun o => X o+M≤M*k+u) + p.event (fun o => M*k+l+M≤X o) := by
  constructor
  · exact p.event_mono _ _ (fun o h => exact_implies_modular M k l u (X o) hM hlu hu h)
  · unfold Law.event
    rw [← Finset.sum_add_distrib,← Finset.sum_add_distrib]
    apply Finset.sum_le_sum
    intro o _
    have hh := modular_alias_partition M k l u (X o) hM
    split_ifs <;> simp_all [modularInterval,exactInterval] <;>
      have hn := p.nonneg o <;> linarith

end FT1536.Run2.CyclicAliases
