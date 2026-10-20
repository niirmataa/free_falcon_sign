import Run2.LegalKeyErrorTransfer

namespace FT1536.Run2.GaussianFiberTilt
open Finset PublicSimulation Geometry ExactCounting CorrectnessProbability
open FT1536.Relation

noncomputable def alpha : ℝ := 1/1179648

noncomputable def weight (a : ℝ) (z : BoxPair) : ℝ :=
  Real.exp (-a*(Q (decode z) : ℝ))

noncomputable def fiberMass (h c : Rq) (a : ℝ) : ℝ :=
  ∑ z, if SigmaMath.syndrome h z=c then weight a z else 0

noncomputable def rejectedMass (h c : Rq) (a : ℝ) : ℝ :=
  ∑ z, if SigmaMath.syndrome h z=c ∧ B≤Q (decode z) then weight a z else 0

theorem weight_at_alpha (z : BoxPair) : weight alpha z=gaussianWeight z := by
  unfold weight alpha gaussianWeight
  congr 1
  norm_num
  ring

theorem fiberMass_at_alpha (h c : Rq) : fiberMass h c alpha=evalCount (Z h c) := by
  rw [Z_value]
  simp only [fiberMass,fiberWeight,weight_at_alpha]

theorem fiberMass_pos (h c : Rq) (a : ℝ) : 0<fiberMass h c a := by
  classical
  obtain ⟨z,hz⟩:=every_fiber_nonempty h c
  apply sum_pos'
  · intro y _
    split_ifs
    · exact (Real.exp_pos _).le
    · exact le_rfl
  · exact ⟨z,mem_univ _,by simp [hz,weight,Real.exp_pos]⟩

theorem rejectedMass_at_alpha (h c : Rq) :
    rejectedMass h c alpha=evalCount (Z h c)-evalCount (S h c) := by
  classical
  rw [Z_value,S_value,←sum_sub_distrib]
  unfold rejectedMass
  apply sum_congr rfl
  intro z _
  by_cases hc : SigmaMath.syndrome h z=c <;> by_cases hb : Q (decode z)<B <;>
    simp [hc,hb,not_lt.mp,weight_at_alpha,FiberBinding.acceptedWeight,fiberWeight]

theorem rejection_is_weight_ratio (h c : Rq) :
    rejection h c=rejectedMass h c alpha/fiberMass h c alpha := by
  rw [rejectedMass_at_alpha,fiberMass_at_alpha,rejection_exact]

theorem tilted_atom (a t : ℝ) (ht : 0≤t) (z : BoxPair) (hz : B≤Q (decode z)) :
    weight a z≤Real.exp (-t*(B : ℝ))*weight (a-t) z := by
  unfold weight
  rw [←Real.exp_add]
  apply Real.exp_le_exp.mpr
  have hr : (B : ℝ)≤(Q (decode z) : ℝ) := by exact_mod_cast hz
  have hh:=mul_nonneg ht (sub_nonneg.mpr hr)
  calc
    _ ≤ -a*(Q (decode z) : ℝ)+t*((Q (decode z) : ℝ)-(B : ℝ)) := le_add_of_nonneg_right hh
    _ = _ := by ring

theorem rejectedMass_tilt (h c : Rq) (a t : ℝ) (ht : 0≤t) :
    rejectedMass h c a≤Real.exp (-t*(B : ℝ))*fiberMass h c (a-t) := by
  classical
  rw [fiberMass,mul_sum]
  unfold rejectedMass
  apply sum_le_sum
  intro z _
  by_cases hc : SigmaMath.syndrome h z=c
  · simp only [hc,true_and,ite_true]
    split_ifs with hb
    · exact tilted_atom a t ht z hb
    · exact mul_nonneg (Real.exp_pos _).le (Real.exp_pos _).le
  · simp [hc]

/- An inequality for the actual finite-box trial, obtained from its exact
weight law. The exponential moment is another explicit fiber sum, not a
global correctness certificate assumed in the premise. -/
theorem rejection_chernoff (h c : Rq) (t : ℝ) (ht : 0≤t) :
    rejection h c≤Real.exp (-t*(B : ℝ))*(fiberMass h c (alpha-t)/fiberMass h c alpha) := by
  rw [rejection_is_weight_ratio]
  have hh:=div_le_div_of_nonneg_right (rejectedMass_tilt h c alpha t ht)
    (fiberMass_pos h c alpha).le
  simpa only [mul_div_assoc] using hh

end FT1536.Run2.GaussianFiberTilt
