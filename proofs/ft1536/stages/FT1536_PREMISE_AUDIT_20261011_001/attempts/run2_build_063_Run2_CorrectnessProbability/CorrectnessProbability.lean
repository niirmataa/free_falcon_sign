import Run2.FiberBinding

namespace FT1536.Run2.CorrectnessProbability
open Finset PublicSimulation Geometry
open FT1536.Relation

theorem map_event {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (p : Law α) (f : α → β) (E : β → Prop) [DecidablePred E] :
    (p.map f).event E = p.event (fun x => E (f x)) := by
  unfold Law.event
  simp_rw [FiberBinding.map_mass]
  have hd (b : β) : (if E b then ∑ x,if f x=b then p.mass x else 0 else 0) =
      ∑ x,if E b then (if f x=b then p.mass x else 0) else 0 := by
    by_cases hb : E b <;> simp [hb]
  simp_rw [hd]
  rw [sum_comm]
  apply sum_congr rfl
  intro x _
  by_cases he : E (f x)
  · have hh (b : β) : (if E b then if f x=b then p.mass x else 0 else 0) =
        if f x=b then p.mass x else 0 := by
      by_cases hb : f x=b <;> simp_all
    simp_rw [hh]
    simp [he]
  · have hh (b : β) : (if E b then if f x=b then p.mass x else 0 else 0) = 0 := by
      by_cases hb : f x=b <;> simp_all
    simp [hh,he]

theorem cap_event {α β : Type} [Fintype α] [DecidableEq α] [Fintype β] [DecidableEq β]
    (p : Law (Option α)) (emit : α → Option β) (E : Option β → Prop) [DecidablePred E]
    (hn : ¬ E none) (n : ℕ) :
    ((MathSign.cap p n).map (MathSign.emit emit)).event E =
      (∑ i ∈ range n,p.mass none^i) * (p.map (MathSign.emit emit)).event E := by
  rw [map_event,map_event]
  simp only [Law.event,Fintype.sum_option,MathSign.emit,hn,ite_false,zero_add]
  simp_rw [MathSign.cap_some]
  rw [mul_sum]
  apply sum_congr rfl
  intro x _
  by_cases hx : E (emit x) <;> simp [hx]

noncomputable def badReply (h c : Rq) : Option BoxVec → Prop
  | none => False
  | some s => ¬ Verify h c (decodeVec s)
noncomputable instance (h c : Rq) : DecidablePred (badReply h c) := Classical.decPred _

noncomputable def tBad (h c : Rq) : ℝ :=
  ((trial (SigmaMath.syndrome h) c).map (MathSign.emit emit)).event (badReply h c)
noncomputable def rejection (h c : Rq) : ℝ := (trial (SigmaMath.syndrome h) c).mass none

theorem body_bad_exact (h c : Rq) :
    (signBody (SigmaMath.syndrome h) c).event (badReply h c) =
      (∑ i ∈ range 16,rejection h c^i) * tBad h c :=
  cap_event _ _ _ (fun h => h) 16

noncomputable def delta (h : Rq) : ℝ := (SigmaMath.freshHonest h).event (BadVerify.Bad h)
noncomputable def firstBad (h : Rq) : ℝ := ∑ c, (1/(Fintype.card Rq : ℝ))*tBad h c

theorem delta_exact (h : Rq) : delta h =
    ∑ c, (1/(Fintype.card Rq : ℝ)) * (∑ i ∈ range 16,rejection h c^i) * tBad h c := by
  classical
  unfold delta Law.event
  rw [Fintype.sum_prod_type]
  have he (c : Rq) : (∑ o, if BadVerify.Bad h (c,o) then (SigmaMath.freshHonest h).mass (c,o) else 0) =
      (1/(Fintype.card Rq : ℝ)) * (signBody (SigmaMath.syndrome h) c).event (badReply h c) := by
    rw [Law.event,mul_sum]
    apply sum_congr rfl
    intro o _
    have hp : BadVerify.Bad h (c,o) ↔ badReply h c o := by
      cases o <;> simp [BadVerify.Bad,badReply]
    simp only [hp, SigmaMath.freshHonest,honestJoint,Divergence.joint,Law.uniform]
    split_ifs <;> ring
  simp_rw [he,body_bad_exact,mul_assoc]

theorem rejection_bounds (h c : Rq) : 0 ≤ rejection h c ∧ rejection h c ≤ 1 := by
  refine ⟨(trial _ _).nonneg _,?_⟩
  have hs := (trial (SigmaMath.syndrome h) c).total
  rw [Fintype.sum_option] at hs
  have hn : 0 ≤ ∑ z,(trial (SigmaMath.syndrome h) c).mass (some z) :=
    sum_nonneg fun z _ => (trial _ _).nonneg _
  unfold rejection
  linarith

theorem geometric_bounds (h c : Rq) :
    1 ≤ (∑ i ∈ range 16,rejection h c^i) ∧ (∑ i ∈ range 16,rejection h c^i) ≤ 16 := by
  constructor
  · have hh := single_le_sum (s := range 16) (f := fun i => rejection h c^i)
      (fun i _ => pow_nonneg (rejection_bounds h c).1 i) (show 0 ∈ range 16 by simp)
    simpa using hh
  · calc
      _ ≤ ∑ _i ∈ range 16,(1 : ℝ) := sum_le_sum fun i _ =>
        pow_le_one₀ (rejection_bounds h c).1 (rejection_bounds h c).2
      _ = _ := by simp

theorem total_error_bounds (h : Rq) : firstBad h ≤ delta h ∧ delta h ≤ min 1 (16*firstBad h) := by
  have ht (c : Rq) : 0 ≤ tBad h c := Law.event_nonneg _ _
  constructor
  · rw [delta_exact]
    unfold firstBad
    apply sum_le_sum
    intro c _
    have hh := mul_le_mul_of_nonneg_right (geometric_bounds h c).1 (ht c)
    have hu : 0 ≤ 1/(Fintype.card Rq : ℝ) := by positivity
    have hk := mul_le_mul_of_nonneg_left hh hu
    simpa only [one_mul,mul_assoc] using hk
  · apply le_min (Law.event_le_one _ _)
    change delta h ≤ 16*firstBad h
    rw [delta_exact]
    unfold firstBad
    rw [mul_sum]
    apply sum_le_sum
    intro c _
    have hh := mul_le_mul_of_nonneg_right (geometric_bounds h c).2 (ht c)
    have hu : 0 ≤ 1/(Fintype.card Rq : ℝ) := by positivity
    have hk := mul_le_mul_of_nonneg_left hh hu
    nlinarith

theorem total_error_positive (h : Rq) : 0 < delta h := BadVerify.freshHonest_badVerify_positive h

end FT1536.Run2.CorrectnessProbability
