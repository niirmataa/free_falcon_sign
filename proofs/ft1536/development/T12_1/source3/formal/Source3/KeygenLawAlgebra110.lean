import Source3.KeygenInputLaw110

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLawAlgebra110
open Finset

variable {A B C : Type} [Fintype A] [Fintype B] [Fintype C]

theorem ext (p q : Law A) (same : ∀ a, p.mass a = q.mass a) : p = q := by
  have functions : p.mass = q.mass := funext same
  cases p
  cases q
  cases functions
  rfl

theorem map_mass [DecidableEq B] (p : Law A) (f : A → B) (b : B) :
    (p.map f).mass b = ∑ a, if f a = b then p.mass a else 0 := by
  simp [Law.map, Law.bind, Law.pure, eq_comm]

theorem map_event [DecidableEq B] (p : Law A) (f : A → B) (event : B → Prop) [DecidablePred event] :
    (p.map f).event event = p.event (fun a => event (f a)) := by
  classical
  change (∑ b, if event b then (p.map f).mass b else 0) = _
  simp_rw [map_mass]
  have exchange : (∑ b, if event b then ∑ a, if f a = b then p.mass a else 0 else 0) =
      ∑ b, ∑ a, if event b then (if f a = b then p.mass a else 0) else 0 := by
    apply sum_congr rfl
    intro b _
    by_cases inside : event b <;> simp [inside]
  rw [exchange, sum_comm]
  unfold Law.event
  apply sum_congr rfl
  intro a _
  calc
    (∑ b, if event b then (if f a = b then p.mass a else 0) else 0) =
        (if event (f a) then (if f a = f a then p.mass a else 0) else 0) := by
      apply sum_eq_single (f a)
      · intro b _ different
        simp [Ne.symm different]
      · intro absent
        exact (absent (mem_univ _)).elim
    _ = if event (f a) then p.mass a else 0 := by simp

theorem map_map [DecidableEq B] [DecidableEq C] (p : Law A) (f : A → B) (g : B → C) :
    (p.map f).map g = p.map (g ∘ f) := by
  apply ext
  intro c
  simp only [Law.map, Law.bind, Law.pure, Function.comp_apply]
  simp_rw [sum_mul]
  rw [sum_comm]
  apply sum_congr rfl
  intro a _
  simp_rw [mul_assoc]
  rw [← mul_sum]
  simp
  rw [sum_eq_single (f a)]
  · by_cases equal : c = g (f a) <;> simp [equal]
  · intro b _ different
    simp [different]
  · intro absent
    exact (absent (mem_univ _)).elim

end FT1536.Source3.KeygenLawAlgebra110
