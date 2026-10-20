import FT1536.Basic

namespace FT1536.Run2.Binning
open Finset

def energy {k : ℕ} (x : Fin k → ℕ) : ℕ := ∑ i,x i
def binned {k : ℕ} (w : ℕ) (x : Fin k → ℕ) : ℕ := ∑ i,x i/w

theorem exact_remainder {k : ℕ} (w : ℕ) (x : Fin k → ℕ) :
    energy x = w*binned w x + ∑ i,x i%w := by
  unfold energy binned
  rw [mul_sum,←sum_add_distrib]
  apply sum_congr rfl
  intro i _
  exact (Nat.div_add_mod (x i) w).symm

theorem range {k : ℕ} (w : ℕ) (hw : 0<w) (x : Fin k → ℕ) :
    w*binned w x ≤ energy x ∧ energy x ≤ w*binned w x+k*(w-1) := by
  have hr : (∑ i,x i%w) ≤ k*(w-1) := by
    calc
      _ ≤ ∑ _i : Fin k,(w-1) := sum_le_sum fun i _ => by have h := Nat.mod_lt (x i) hw; omega
      _ = _ := by simp
  rw [exact_remainder w x]
  constructor <;> omega

theorem interval_lower {k : ℕ} (w : ℕ) (hw : 0<w) (x : Fin k → ℕ) (L U : ℕ)
    (hl : L≤w*binned w x) (hu : w*binned w x+k*(w-1)<U) :
    L≤energy x ∧ energy x<U := by
  obtain ⟨h0,h1⟩ := range w hw x
  omega

theorem interval_upper {k : ℕ} (w : ℕ) (hw : 0<w) (x : Fin k → ℕ) (L U : ℕ)
    (h : L≤energy x ∧ energy x<U) :
    L≤w*binned w x+k*(w-1) ∧ w*binned w x<U := by
  obtain ⟨h0,h1⟩ := range w hw x
  omega

theorem probability_bracket {Ω : Type} [Fintype Ω] {k : ℕ} (p : Law Ω)
    (x : Ω → Fin k → ℕ) (w : ℕ) (hw : 0<w) (L U : ℕ) :
    p.event (fun o => L≤w*binned w (x o) ∧ w*binned w (x o)+k*(w-1)<U) ≤
      p.event (fun o => L≤energy (x o) ∧ energy (x o)<U) ∧
    p.event (fun o => L≤energy (x o) ∧ energy (x o)<U) ≤
      p.event (fun o => L≤w*binned w (x o)+k*(w-1) ∧ w*binned w (x o)<U) := by
  constructor
  · exact p.event_mono _ _ (fun o h => interval_lower w hw (x o) L U h.1 h.2)
  · exact p.event_mono _ _ (fun o h => interval_upper w hw (x o) L U h)

end FT1536.Run2.Binning
