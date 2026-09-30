import Run2.EmitMixture
import Run2.BadVerify

namespace FT1536.Run2.FiberBinding
open Finset PublicSimulation

theorem map_mass {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (p : Law α) (f : α → β) (b : β) :
    (p.map f).mass b = ∑ x, if f x = b then p.mass x else 0 := by
  simp only [Law.map,Law.bind,Law.pure]
  apply sum_congr rfl
  intro x _
  by_cases h : f x = b
  · simp [h]
  · simp [h,Ne.symm h]

theorem trial_some (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hZ : 0 < ∑ z, fiberWeight A c z) (z : BoxPair) :
    (trial A c).mass (some z) =
      (if Geometry.Q (decode z) < Geometry.B then fiberWeight A c z else 0) /
      (∑ y, fiberWeight A c y) := by
  classical
  rw [trial,dite_eq_left hZ,map_mass]
  have he (x : BoxPair) :
      (if (if Geometry.Q (decode x) < Geometry.B then some x else none) = some z then
        (Law.weighted (fiberWeight A c) (fiberWeight_nonneg A c) hZ).mass x else 0) =
      if x = z then
        (if Geometry.Q (decode z) < Geometry.B then fiberWeight A c z else 0) /
        (∑ y, fiberWeight A c y) else 0 := by
    by_cases hx : x=z
    · subst x; split_ifs <;> simp_all [Law.weighted]
    · split_ifs <;> simp_all
  simp_rw [he]
  simp

noncomputable def acceptedWeight (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (z : BoxPair) : ℝ := if Geometry.Q (decode z) < Geometry.B then fiberWeight A c z else 0

theorem acceptedWeight_nonneg (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (z : BoxPair) : 0 ≤ acceptedWeight A c z := by
  unfold acceptedWeight
  split_ifs
  · exact fiberWeight_nonneg A c z
  · rfl

noncomputable def acceptedLaw (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) : Law BoxPair :=
  Law.weighted _ (acceptedWeight_nonneg A c) hS

theorem S_le_Z (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq) :
    (∑ z, acceptedWeight A c z) ≤ ∑ z, fiberWeight A c z := by
  apply sum_le_sum
  intro z _
  unfold acceptedWeight
  split_ifs
  · rfl
  · exact fiberWeight_nonneg A c z

theorem acceptance_probability (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) :
    1-(trial A c).mass none = (∑ z, acceptedWeight A c z)/(∑ z, fiberWeight A c z) := by
  have hZ := hS.trans_le (S_le_Z A c)
  have ht := (trial A c).total
  rw [Fintype.sum_option] at ht
  simp_rw [trial_some A c hZ] at ht
  rw [← sum_div] at ht
  unfold acceptedWeight
  linarith

theorem trial_accepted_factor (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) (z : BoxPair) :
    (trial A c).mass (some z) =
      (1-(trial A c).mass none)*(acceptedLaw A c hS).mass z := by
  rw [trial_some A c (hS.trans_le (S_le_Z A c)), acceptance_probability A c hS]
  change acceptedWeight A c z / _ = _ * (acceptedWeight A c z / _)
  field_simp

noncomputable def pi (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq) : ℝ :=
  1-(trial A c).mass none^16

noncomputable def L (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) : Law (Option BoxVec) :=
  (acceptedLaw A c hS).map emit

theorem pi_bounds (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) : 0 < pi A c ∧ pi A c ≤ 1 := by
  have hZ := hS.trans_le (S_le_Z A c)
  have ha : 0 < 1-(trial A c).mass none := by
    rw [acceptance_probability A c hS]
    exact div_pos hS hZ
  have hf0 := (trial A c).nonneg none
  have hf1 : (trial A c).mass none < 1 := by linarith
  have hp : (trial A c).mass none^16 < 1 := pow_lt_one₀ hf0 hf1 (by norm_num)
  have hp0 := pow_nonneg hf0 16
  unfold pi
  constructor <;> linarith

theorem signBody_after_emit (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) (o : Option BoxVec) :
    (signBody A c).mass o = pi A c*(L A c hS).mass o +
      if o = none then 1-pi A c else 0 := by
  classical
  have hh := EmitMixture.cap_emit (trial A c) (acceptedLaw A c hS) emit
    (trial_accepted_factor A c hS) 16 o
  simpa only [signBody,pi,L,sub_sub_cancel] using hh

theorem law_ext {α : Type} [Fintype α] (p q : Law α) (h : ∀ x,p.mass x=q.mass x) : p=q := by
  cases p with
  | mk pm pn pt =>
    cases q with
    | mk qm qn qt =>
      have hh : pm=qm := funext h
      cases hh
      rfl

theorem signBody_is_mix (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) :
    signBody A c = EmitMixture.mix (pi A c) (pi_bounds A c hS).1.le
      (pi_bounds A c hS).2 (L A c hS) := by
  apply law_ext
  intro o
  exact signBody_after_emit A c hS o

theorem signBody_exact_chi2 (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) :
    1+(Divergence.chi2 (L A c hS) (signBody A c)).toReal =
      (1-(L A c hS).mass none)/pi A c +
      (L A c hS).mass none^2/(1-pi A c+pi A c*(L A c hS).mass none) := by
  rw [signBody_is_mix A c hS]
  exact EmitMixture.exact_chi2 _ (pi_bounds A c hS).1 (pi_bounds A c hS).2 _

theorem acceptedWeight_fiber (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (z : BoxPair) : acceptedWeight A c z = if A z = c then boundedWeight z else 0 := by
  unfold acceptedWeight fiberWeight boundedWeight
  split_ifs <;> rfl

noncomputable def nu (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq) : ℝ :=
  (∑ z, acceptedWeight A c z) / ∑ z, boundedWeight z

theorem public_joint_factor (A : BoxPair → FT1536.Relation.Rq) (c : FT1536.Relation.Rq)
    (hS : 0 < ∑ z, acceptedWeight A c z) (o : Option BoxVec) :
    (publicJoint A).mass (c,o) = nu A c * (L A c hS).mass o := by
  classical
  rw [publicJoint,map_mass]
  simp only [L,map_mass,acceptedLaw,Law.weighted,nu]
  rw [mul_sum]
  apply sum_congr rfl
  intro z _
  rw [acceptedWeight_fiber]
  by_cases ha : A z=c <;> by_cases ho : emit z=o
  · simp only [ha,ho,ite_true]
    change boundedWeight z / (∑ y,boundedWeight y) = _
    field_simp
  · simp [ha,ho]
  · simp [ha,ho]
  · simp [ha,ho]

end FT1536.Run2.FiberBinding
