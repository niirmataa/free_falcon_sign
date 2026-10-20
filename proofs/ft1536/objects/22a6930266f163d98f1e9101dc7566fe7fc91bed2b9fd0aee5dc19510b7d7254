import Run2.PublicErrorIdentity

namespace FT1536.Run2.LegalKeyErrorTransfer
open Finset PublicSimulation Geometry CorrectnessProbability ExactCounting PublicErrorIdentity
open FT1536.Relation

noncomputable def totalWeight : ℝ := evalCount (countPolynomial (fun _ => True))
noncomputable def rawBad : ℝ := evalCount (countPolynomial
  (fun z => Q (decode z)<B ∧ publicBadSample z))/totalWeight

theorem totalWeight_pos : 0<totalWeight := by
  classical
  rw [totalWeight,eval_count]
  simp only [ite_true]
  exact sum_pos' (fun z _ => (Real.exp_pos _).le)
    ⟨zeroPair,mem_univ _,Real.exp_pos _⟩

theorem F_nonnegative (h c : Rq) : 0≤evalCount (F h c) := by
  classical
  rw [F,eval_count]
  apply sum_nonneg
  intro z _
  split_ifs
  · exact (Real.exp_pos _).le
  · rfl

theorem rawBad_sum (h : Rq) : rawBad=(∑ c,evalCount (F h c))/totalWeight := by
  unfold rawBad
  rw [←numerator_partition h]
  simp only [evalCount,Polynomial.eval₂_finsetSum]

/- Intermediate mass certificate. It is NOT a definition of a selected subset
of legitimate keys. An all-successful-KeyGen implication must supply it. -/
def FiniteFlat (h : Rq) (eps : ℝ) : Prop := ∀ c,
  (1-eps)*totalWeight ≤ (Fintype.card Rq : ℝ)*evalCount (Z h c) ∧
  (Fintype.card Rq : ℝ)*evalCount (Z h c) ≤ (1+eps)*totalWeight

theorem first_bad_flat_bounds (h : Rq) (eps : ℝ) (_he0 : 0≤eps) (he1 : eps<1)
    (hf : FiniteFlat h eps) : rawBad/(1+eps) ≤ firstBad h ∧ firstBad h ≤ rawBad/(1-eps) := by
  have hcard : 0<(Fintype.card Rq : ℝ) := by positivity
  have ht := totalWeight_pos
  rw [rawBad_sum h]
  unfold firstBad
  simp_rw [one_try_bad_exact]
  constructor
  · rw [div_div,Finset.sum_div]
    apply sum_le_sum
    intro c _
    have ha := div_le_div_of_nonneg_left (F_nonnegative h c)
      (mul_pos hcard (Z_positive h c)) (hf c).2
    have hl : totalWeight*(1+eps)=(1+eps)*totalWeight := mul_comm _ _
    rw [hl]
    convert ha using 1
    ring
  · rw [div_div,Finset.sum_div]
    apply sum_le_sum
    intro c _
    have ha := div_le_div_of_nonneg_left (F_nonnegative h c)
      (mul_pos (by linarith : 0<1-eps) ht) (hf c).1
    have hl : totalWeight*(1-eps)=(1-eps)*totalWeight := mul_comm _ _
    rw [hl]
    convert ha using 1
    ring

theorem geometric_loss_bound (h c : Rq) (r : ℝ) (hr : r<1) (hf : rejection h c≤r) :
    (∑ i ∈ range 16,rejection h c^i) ≤ 1/(1-r) := by
  have hn : 0≤∑ i ∈ range 16,rejection h c^i :=
    sum_nonneg fun i _ => pow_nonneg (rejection_bounds h c).1 i
  have hg := MathSign.geometric_acceptance (rejection h c) 16
  have hm := mul_le_mul_of_nonneg_left (show 1-r≤1-rejection h c by linarith) hn
  have hp := pow_nonneg (rejection_bounds h c).1 16
  apply (le_div_iff₀ (by linarith : 0<1-r)).2
  nlinarith

theorem capped_upper_from_rejection (h : Rq) (r : ℝ) (hr : r<1)
    (hf : ∀ c,rejection h c≤r) : delta h ≤ firstBad h/(1-r) := by
  rw [delta_exact]
  unfold firstBad
  rw [sum_div]
  apply sum_le_sum
  intro c _
  have ht : 0≤tBad h c := Law.event_nonneg _ _
  have hh := mul_le_mul_of_nonneg_right (geometric_loss_bound h c r hr (hf c)) ht
  have hm := mul_le_mul_of_nonneg_left hh (show 0≤1/(Fintype.card Rq : ℝ) by positivity)
  convert hm using 1 <;> ring

theorem all_key_error_from_local_certificates (h : Rq) (eps r : ℝ)
    (he0 : 0≤eps) (he1 : eps<1) (hr : r<1)
    (hf : FiniteFlat h eps) (hrej : ∀ c,rejection h c≤r) :
    rawBad/(1+eps) ≤ delta h ∧ delta h ≤ rawBad/((1-eps)*(1-r)) := by
  obtain ⟨hl,hu⟩ := first_bad_flat_bounds h eps he0 he1 hf
  constructor
  · exact hl.trans (total_error_bounds h).1
  · have hh := capped_upper_from_rejection h r hr hrej
    have hu' := div_le_div_of_nonneg_right hu (show 0≤1-r by linarith)
    rw [div_div] at hu'
    exact hh.trans hu'

end FT1536.Run2.LegalKeyErrorTransfer
