import FT1536.Model
import FT1536.Adaptive

namespace FT1536.Run2
open Finset

/- Finite-support laws on arbitrary outputs. The sample space is latent. -/
structure Dist (α : Type) where
  Sample : Type
  finite : Fintype Sample
  law : @Law Sample finite
  out : Sample → α

attribute [instance] Dist.finite

namespace Dist
noncomputable def pure {α : Type} (x : α) : Dist α :=
  ⟨Unit, inferInstance, Law.pure (), fun _ => x⟩

noncomputable def draw {α : Type} [Fintype α] (p : Law α) : Dist α :=
  ⟨α, inferInstance, p, id⟩

noncomputable def bind {α β : Type} (p : Dist α) (f : α → Dist β) : Dist β where
  Sample := (x : p.Sample) × (f (p.out x)).Sample
  finite := inferInstance
  law := {
    mass := fun z => p.law.mass z.1 * (f (p.out z.1)).law.mass z.2
    nonneg := fun z => mul_nonneg (p.law.nonneg _) ((f _).law.nonneg _)
    total := by
      rw [Fintype.sum_sigma]
      simp_rw [← mul_sum]
      have h (x : p.Sample) : (∑ y, (f (p.out x)).law.mass y) = 1 := (f (p.out x)).law.total
      simp_rw [h, mul_one]
      exact p.law.total }
  out z := (f (p.out z.1)).out z.2

noncomputable def map {α β : Type} (p : Dist α) (f : α → β) : Dist β :=
  {p with out := f ∘ p.out}

noncomputable def expect {α : Type} (p : Dist α) (f : α → ℝ) : ℝ :=
  ∑ x, p.law.mass x * f (p.out x)

noncomputable def event {α : Type} (p : Dist α) (E : α → Prop) : ℝ := by
  classical
  exact p.law.event (fun x => E (p.out x))

def Same {α : Type} (p q : Dist α) : Prop := ∀ f : α → ℝ, p.expect f = q.expect f

theorem expect_bind {α β : Type} (p : Dist α) (k : α → Dist β) (f : β → ℝ) :
    (p.bind k).expect f = p.expect (fun x => (k x).expect f) := by
  dsimp only [expect, bind]
  rw [Fintype.sum_sigma]
  apply sum_congr rfl
  intro x _
  rw [mul_sum]
  apply sum_congr rfl
  intro y _
  ring

theorem expect_pure {α : Type} (x : α) (f : α → ℝ) : (pure x).expect f = f x := by
  change (∑ u : Unit, (Law.pure ()).mass u * f x) = f x
  rw [← sum_mul, Law.total, one_mul]

theorem bind_assoc {α β γ : Type} (p : Dist α) (f : α → Dist β) (g : β → Dist γ) :
    Same ((p.bind f).bind g) (p.bind fun x => (f x).bind g) := by
  intro h
  simp only [expect_bind]

theorem bind_comm {α β γ : Type} (p : Dist α) (q : Dist β) (f : α → β → Dist γ) :
    Same (p.bind fun x => q.bind (f x)) (q.bind fun y => p.bind fun x => f x y) := by
  intro h
  simp only [expect_bind]
  dsimp only [expect]
  simp_rw [mul_sum]
  rw [sum_comm]
  apply sum_congr rfl
  intro y _
  apply sum_congr rfl
  intro x _
  ring

theorem same_event {α : Type} (p q : Dist α) (h : Same p q) (E : α → Prop) :
    p.event E = q.event E := by
  classical
  have hh := h (fun x => if E x then 1 else 0)
  simpa [event, Law.event, expect, mul_ite] using hh

theorem event_nonneg {α : Type} (p : Dist α) (E : α → Prop) : 0 ≤ p.event E := by
  classical
  exact p.law.event_nonneg _

theorem event_le_one {α : Type} (p : Dist α) (E : α → Prop) : p.event E ≤ 1 := by
  classical
  exact p.law.event_le_one _

end Dist
end FT1536.Run2
