import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Algebra.BigOperators.Field
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Positivity

/-! Finite probability laws with explicit support. No probability axiom beyond
normalization is used. All laws in this module are specifications. -/
namespace FT1536
open Finset

structure Law (α : Type*) [Fintype α] where
  mass : α → ℝ
  nonneg : ∀ x, 0 ≤ mass x
  total : ∑ x, mass x = 1

namespace Law
variable {α β : Type*} [Fintype α] [Fintype β]

noncomputable def pure [DecidableEq α] (x : α) : Law α where
  mass y := if y = x then 1 else 0
  nonneg y := by split_ifs <;> norm_num
  total := by simp

noncomputable def bind (p : Law α) (k : α → Law β) : Law β where
  mass y := ∑ x, p.mass x * (k x).mass y
  nonneg y := Finset.sum_nonneg fun x _ => mul_nonneg (p.nonneg x) ((k x).nonneg y)
  total := by
    rw [Finset.sum_comm]
    simp_rw [← Finset.mul_sum, Law.total, mul_one]
    exact p.total

noncomputable def map [DecidableEq β] (p : Law α) (f : α → β) : Law β :=
  p.bind fun x => pure (f x)

noncomputable def event (p : Law α) (E : α → Prop) [DecidablePred E] : ℝ :=
  ∑ x, if E x then p.mass x else 0

theorem event_nonneg (p : Law α) (E : α → Prop) [DecidablePred E] :
    0 ≤ p.event E := by
  apply Finset.sum_nonneg
  intro x _
  split_ifs <;> simp_all [p.nonneg]

theorem event_le_one (p : Law α) (E : α → Prop) [DecidablePred E] :
    p.event E ≤ 1 := by
  rw [← p.total]
  apply Finset.sum_le_sum
  intro x _
  split_ifs <;> simp_all [p.nonneg]

theorem event_mono (p : Law α) (E F : α → Prop) [DecidablePred E] [DecidablePred F]
    (h : ∀ x, E x → F x) : p.event E ≤ p.event F := by
  apply Finset.sum_le_sum
  intro x _
  by_cases he : E x
  · simp [he, h x he]
  · simp only [he, ite_false]
    split_ifs
    · exact p.nonneg x
    · rfl

theorem remove_bad_bound (p : Law α) (Win Bad : α → Prop)
    [DecidablePred Win] [DecidablePred Bad] :
    p.event Win ≤ p.event (fun x => Win x ∧ ¬ Bad x) + p.event Bad := by
  unfold event
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro x _
  by_cases hw : Win x <;> by_cases hb : Bad x <;> simp [hw, hb, p.nonneg]

noncomputable def uniform [Nonempty α] : Law α where
  mass _ := 1 / Fintype.card α
  nonneg _ := by positivity
  total := by simp [Fintype.card_ne_zero]

noncomputable def weighted (w : α → ℝ) (hw : ∀ x, 0 ≤ w x)
    (hz : 0 < ∑ x, w x) : Law α where
  mass x := w x / ∑ y, w y
  nonneg x := div_nonneg (hw x) hz.le
  total := by rw [← Finset.sum_div]; exact div_self (ne_of_gt hz)

end Law
end FT1536
