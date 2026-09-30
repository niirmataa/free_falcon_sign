import Run2.UniformErrorBound
import Mathlib.Algebra.Polynomial.Eval.Defs

set_option exponentiation.threshold 100000

namespace FT1536.Run2.ExactCounting
open Finset PublicSimulation Geometry FiberBinding CorrectnessProbability
open FT1536.Relation

noncomputable def temperature : ℝ := Real.exp (-(1 : ℝ)/1179648)
def degree (z : BoxPair) : ℕ := (Q (decode z)).toNat

theorem norm_nonneg (z : BoxPair) : 0 ≤ Q (decode z) :=
  add_nonneg (Q0_nonneg _) (Q0_nonneg _)

theorem weight_is_monomial (z : BoxPair) : gaussianWeight z = temperature^degree z := by
  rw [temperature,← Real.exp_nat_mul]
  have hn : ((degree z : ℕ) : ℤ)=Q (decode z) := Int.toNat_of_nonneg (norm_nonneg z)
  have hr : (degree z : ℝ)=(Q (decode z) : ℝ) := by exact_mod_cast hn
  rw [hr]
  unfold gaussianWeight
  norm_num
  ring

/- Every coefficient counts points exactly; no floating arithmetic enters. -/
noncomputable def countPolynomial (P : BoxPair → Prop) : Polynomial ℤ := by
  classical
  exact ∑ z, if P z then Polynomial.monomial (degree z) 1 else 0

noncomputable def evalCount (p : Polynomial ℤ) : ℝ :=
  p.eval₂ (Int.castRingHom ℝ) temperature

theorem coefficient_is_count (P : BoxPair → Prop) [DecidablePred P] (n : ℕ) :
    (countPolynomial P).coeff n =
      ((univ.filter (fun z => P z ∧ degree z=n)).card : ℤ) := by
  classical
  unfold countPolynomial
  rw [Polynomial.finsetSum_coeff]
  have he (z : BoxPair) :
      (@ite (Polynomial ℤ) (P z) (Classical.propDecidable _) (Polynomial.monomial (degree z) 1) 0).coeff n =
      if P z ∧ degree z=n then 1 else 0 := by
    by_cases hp : P z <;> by_cases hd : degree z=n <;>
      simp [hp,hd,Polynomial.coeff_monomial]
  simp_rw [he]
  simp

theorem eval_count (P : BoxPair → Prop) [DecidablePred P] :
    evalCount (countPolynomial P) = ∑ z, if P z then gaussianWeight z else 0 := by
  classical
  simp only [evalCount,countPolynomial,Polynomial.eval₂_finsetSum]
  apply sum_congr rfl
  intro z _
  by_cases hp : P z
  · simp [hp,Polynomial.eval₂_monomial,weight_is_monomial]
  · simp [hp]

noncomputable def Z (h c : Rq) : Polynomial ℤ :=
  countPolynomial (fun z => SigmaMath.syndrome h z=c)
noncomputable def S (h c : Rq) : Polynomial ℤ :=
  countPolynomial (fun z => SigmaMath.syndrome h z=c ∧ Q (decode z)<B)
noncomputable def F (h c : Rq) : Polynomial ℤ :=
  countPolynomial (fun z => SigmaMath.syndrome h z=c ∧ Q (decode z)<B ∧ badReply h c (emit z))

theorem Z_value (h c : Rq) : evalCount (Z h c) = ∑ z, fiberWeight (SigmaMath.syndrome h) c z := by
  rw [Z,eval_count]
  rfl

theorem S_value (h c : Rq) : evalCount (S h c) = ∑ z, acceptedWeight (SigmaMath.syndrome h) c z := by
  classical
  rw [S,eval_count]
  apply sum_congr rfl
  intro z _
  unfold acceptedWeight fiberWeight
  split_ifs <;> simp_all

theorem center_range (x : ℤ) : -65535 ≤ center x ∧ center x ≤ 65535 := by
  have h0 := Int.emod_nonneg (x+9216) (by norm_num : (18433 : ℤ) ≠ 0)
  have h1 := Int.emod_lt_of_pos (x+9216) (by norm_num : (0 : ℤ)<18433)
  unfold center
  omega

theorem every_fiber_nonempty (h c : Rq) : ∃ z : BoxPair, SigmaMath.syndrome h z=c := by
  let v := centerRq c
  have hv (i : Fin 768) : (-65535 ≤ (v i).1 ∧ (v i).1 ≤ 65535) ∧
      (-65535 ≤ (v i).2 ∧ (v i).2 ≤ 65535) :=
    ⟨center_range _,center_range _⟩
  refine ⟨(encodeVec v hv,zeroVec),?_⟩
  simp only [SigmaMath.syndrome,decode,decode_encodeVec,UniformErrorBound.zeroVec_decoded,
    A,UniformErrorBound.reduce_zero,UniformErrorBound.mulRq_zero,add_zero]
  exact reduce_center c

theorem Z_positive (h c : Rq) : 0 < evalCount (Z h c) := by
  classical
  rw [Z_value]
  obtain ⟨z,hz⟩ := every_fiber_nonempty h c
  apply sum_pos' (fun z _ => fiberWeight_nonneg _ _ z)
  exact ⟨z,mem_univ _,by simp [fiberWeight,hz,gaussianWeight,Real.exp_pos]⟩

theorem rejection_exact (h c : Rq) : rejection h c =
    (evalCount (Z h c)-evalCount (S h c))/evalCount (Z h c) := by
  have hz := Z_positive h c
  have ht := (trial (SigmaMath.syndrome h) c).total
  rw [Fintype.sum_option] at ht
  have hc := Z_value h c
  simp_rw [FiberBinding.trial_some _ _ (by rwa [←hc]) ] at ht
  rw [← sum_div] at ht
  have hs := S_value h c
  unfold acceptedWeight at hs
  rw [←hs,←hc] at ht
  unfold rejection
  apply (eq_div_iff (ne_of_gt hz)).2
  have hh := (div_eq_iff (ne_of_gt hz)).mp (show evalCount (S h c)/evalCount (Z h c) =
    1-(trial (SigmaMath.syndrome h) c).mass none by linarith)
  linarith

theorem one_try_bad_exact (h c : Rq) : tBad h c = evalCount (F h c)/evalCount (Z h c) := by
  classical
  rw [tBad,CorrectnessProbability.map_event]
  rw [Law.event,Fintype.sum_option]
  have hnone : ¬badReply h c (MathSign.emit emit none) := fun h => h
  rw [ite_eq_right hnone,zero_add]
  change (∑ z, if badReply h c (emit z) then (trial (SigmaMath.syndrome h) c).mass (some z) else 0) = _
  have hZ := Z_positive h c
  have hc := Z_value h c
  simp_rw [FiberBinding.trial_some _ _ (by rwa [←hc])]
  rw [F,eval_count,Finset.sum_div]
  apply sum_congr rfl
  intro z _
  rw [hc]
  unfold fiberWeight
  by_cases ha : SigmaMath.syndrome h z=c <;> by_cases hn : Q (decode z)<B <;>
    by_cases hb : badReply h c (emit z) <;> simp [ha,hn,hb]

/- Exact rational expression evaluated at one specified transcendental
constant. Computing its coefficient tables is the remaining counting problem. -/
theorem exact_error_number (h : Rq) : delta h =
    (1/(18433 : ℝ)^1536) * ∑ c,
      (evalCount (F h c)/evalCount (Z h c)) *
      ∑ i ∈ range 16, ((evalCount (Z h c)-evalCount (S h c))/evalCount (Z h c))^i := by
  rw [delta_exact,mul_sum]
  simp only [UniformErrorBound.rq_card,Nat.cast_pow,Nat.cast_ofNat]
  apply sum_congr rfl
  intro c _
  rw [one_try_bad_exact]
  simp_rw [rejection_exact]
  ring

end FT1536.Run2.ExactCounting
