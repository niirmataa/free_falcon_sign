import Run2.CorrectnessProbability
import Mathlib.Analysis.Complex.ExponentialBounds

set_option exponentiation.threshold 100000

namespace FT1536.Run2.UniformErrorBound
open Finset PublicSimulation Geometry CorrectnessProbability
open FT1536.Relation

theorem gaussian_le_one (z : BoxPair) : gaussianWeight z ≤ 1 := by
  apply Real.exp_le_one_iff.mpr
  have hn : 0 ≤ Q (decode z) := add_nonneg (Q0_nonneg _) (Q0_nonneg _)
  have hr : (0 : ℝ) ≤ (Q (decode z) : ℝ) := by exact_mod_cast hn
  exact div_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hr) (by positivity)

theorem fiber_normalizer_le_card (A : BoxPair → Rq) (c : Rq) :
    (∑ z,fiberWeight A c z) ≤ (Fintype.card BoxPair : ℝ) := by
  calc
    _ ≤ ∑ _z : BoxPair,(1 : ℝ) := by
      apply sum_le_sum
      intro z _
      unfold fiberWeight
      split_ifs
      · exact gaussian_le_one z
      · norm_num
    _ = _ := by simp

theorem first_atom_bound (A : BoxPair → Rq) (z : BoxPair) (hz : Q (decode z)<B) :
    gaussianWeight z / (Fintype.card BoxPair : ℝ) ≤ (trial A (A z)).mass (some z) := by
  classical
  have hw : 0 < fiberWeight A (A z) z := by simp [fiberWeight,gaussianWeight,Real.exp_pos]
  have hZ : 0 < ∑ y,fiberWeight A (A z) y :=
    sum_pos' (fun y _ => fiberWeight_nonneg A (A z) y) ⟨z,mem_univ _,hw⟩
  rw [FiberBinding.trial_some A (A z) hZ z,ite_eq_left hz]
  simp only [fiberWeight,ite_true]
  exact div_le_div_of_nonneg_left (Real.exp_pos _).le hZ (fiber_normalizer_le_card A (A z))

theorem emitted_atom_bound (h : Rq) (z : BoxPair) (hz : Q (decode z)<B)
    (he : emit z=some z.2) :
    (1/(Fintype.card Rq : ℝ))*(gaussianWeight z/(Fintype.card BoxPair : ℝ)) ≤
      (SigmaMath.freshHonest h).mass (SigmaMath.syndrome h z,some z.2) := by
  have ht := first_atom_bound (SigmaMath.syndrome h) z hz
  have hfirst : (trial (SigmaMath.syndrome h) (SigmaMath.syndrome h z)).mass (some z) ≤
      (MathSign.cap (trial (SigmaMath.syndrome h) (SigmaMath.syndrome h z)) 16).mass (some z) := by
    rw [MathSign.cap_some]
    have hp := mul_le_mul_of_nonneg_right (geometric_bounds h (SigmaMath.syndrome h z)).1
      ((trial (SigmaMath.syndrome h) (SigmaMath.syndrome h z)).nonneg (some z))
    simpa only [one_mul,rejection] using hp
  have hmap := BadVerify.map_mass_ge (MathSign.cap (trial (SigmaMath.syndrome h) (SigmaMath.syndrome h z)) 16)
    (MathSign.emit emit) (some z)
  simp only [MathSign.emit,he] at hmap
  change _ ≤ (1/(Fintype.card Rq : ℝ)) *
    (signBody (SigmaMath.syndrome h) (SigmaMath.syndrome h z)).mass (some z.2)
  exact mul_le_mul_of_nonneg_left (ht.trans (hfirst.trans hmap)) (by positivity)

theorem event_ge_atom {α : Type} [Fintype α] (p : Law α) (E : α → Prop) [DecidablePred E]
    (x : α) (hx : E x) : p.mass x ≤ p.event E := by
  have hh := single_le_sum (s := univ) (f := fun y => if E y then p.mass y else 0)
    (fun y _ => by split_ifs; exact p.nonneg y; rfl) (mem_univ x)
  simpa only [ite_eq_left hx,Law.event] using hh

theorem event_le_without_atom {α : Type} [Fintype α] [DecidableEq α]
    (p : Law α) (E : α → Prop) [DecidablePred E] (x : α) (hx : ¬E x) :
    p.event E ≤ 1-p.mass x := by
  have h : p.event E + p.mass x ≤ 1 := by
    calc
      _ = ∑ y, ((if E y then p.mass y else 0) + if y=x then p.mass y else 0) := by
        rw [sum_add_distrib]
        simp only [sum_ite_eq',mem_univ,ite_true,Law.event]
      _ ≤ ∑ y,p.mass y := by
        apply sum_le_sum
        intro y _
        by_cases hy:y=x
        · subst y; simp [hx]
        · by_cases he:E y <;> simp [hy,he,p.nonneg]
      _ = 1 := p.total
  linarith

noncomputable def D : ℝ := (Fintype.card Rq : ℝ)*(Fintype.card BoxPair : ℝ)

theorem uniform_lower (h : Rq) : Real.exp (-(2051350378 : ℝ)/(2*768^2))/D ≤ delta h := by
  classical
  obtain ⟨z,hz⟩ := full_norm_support_in_box BadVerify.v BadVerify.w centering_can_break_acceptance.1
  have hz2 : decodeVec z.2 = BadVerify.w := congrArg Prod.snd hz
  have hs : PublicSimulation.signed16 z.2 := by
    simpa [PublicSimulation.signed16,FT1536.Relation.signed16,hz2] using BadVerify.w_signed
  have hem : emit z=some z.2 := by simp [emit,hs]
  have hl := emitted_atom_bound h z (by rw [hz]; exact centering_can_break_acceptance.1) hem
  have hb : BadVerify.Bad h (SigmaMath.syndrome h z,some z.2) := by
    refine ⟨z.2,rfl,?_⟩
    simpa [SigmaMath.syndrome,hz,hz2] using BadVerify.rejects h
  have ha := event_ge_atom (SigmaMath.freshHonest h) (BadVerify.Bad h) _ hb
  have hnorm : Q (decode z)=2051350378 := by
    rw [hz]
    simp only [Q,BadVerify.v,BadVerify.w,Q0_spike]
    exact FT1536.Certificate.centering_values.1
  have he : (1/(Fintype.card Rq : ℝ))*(gaussianWeight z/(Fintype.card BoxPair : ℝ)) =
      Real.exp (-(2051350378 : ℝ)/(2*768^2))/D := by
    rw [gaussianWeight,hnorm]
    unfold D
    ring_nf
  rw [he] at hl
  exact hl.trans ha

theorem poly_zero : poly 0=0 := by simp [poly]
theorem mulRq_zero (h : Rq) : mulRq h 0=0 := by
  funext i
  simp [mulRq,poly_zero]

theorem zero_decoded : decode zeroPair = (0,0) := by
  apply Prod.ext <;> funext i <;> simp [decode,decodeVec,zeroPair,zeroVec]

theorem reduce_zero : reduceVec 0=0 := by funext i; simp [reduceVec]
theorem center_zero : centerRq 0=0 := by funext i; norm_num [centerRq,center]
theorem zeroVec_decoded : decodeVec zeroVec=0 := by funext i; norm_num [decodeVec,zeroVec]

theorem zero_valid (h : Rq) : Verify h 0 0 := by
  constructor
  · intro i; norm_num
  · simp only [extract,reduce_zero,mulRq_zero,sub_self,center_zero]
    norm_num [Q,Q0,block,B]

theorem uniform_upper (h : Rq) : delta h ≤ 1-1/D := by
  classical
  have he : emit zeroPair=some zeroPair.2 := by
    have hs : PublicSimulation.signed16 zeroPair.2 := by
      intro i; norm_num [decodeVec,zeroPair,zeroVec]
    simp [emit,hs]
  have hl := emitted_atom_bound h zeroPair (by rw [zero_norm]; norm_num [B]) he
  have hc : SigmaMath.syndrome h zeroPair=0 := by
    simp [SigmaMath.syndrome,A,zero_decoded,reduce_zero,mulRq_zero]
  have hb : ¬BadVerify.Bad h (0,some zeroPair.2) := by
    intro hb
    obtain ⟨s,hs,hn⟩ := hb
    have hs' : s=zeroPair.2 := (Option.some.inj hs).symm
    subst s
    apply hn
    change Verify h 0 (decodeVec zeroVec)
    rw [zeroVec_decoded]
    exact zero_valid h
  have ha := event_le_without_atom (SigmaMath.freshHonest h) (BadVerify.Bad h) (0,some zeroPair.2) hb
  have hnorm : gaussianWeight zeroPair=1 := by simp [gaussianWeight,zero_norm]
  rw [hc,hnorm] at hl
  have heq : (1/(Fintype.card Rq : ℝ))*(1/(Fintype.card BoxPair : ℝ))=1/D := by unfold D; ring_nf
  rw [heq] at hl
  unfold delta
  linarith

theorem rq_card : Fintype.card Rq = 18433^1536 := by
  have hc : SigmaMath.rqFintype = (Pi.instFintype : Fintype Rq) := Subsingleton.elim _ _
  rw [hc]
  have hh := Fintype.card_fun (α := Fin 768) (β := ZMod 18433 × ZMod 18433)
  have hi : Fintype.card Rq = (18433*18433)^768 := by
    rw [hc]
    simpa only [Fintype.card_prod,ZMod.card,Fintype.card_fin] using hh
  rw [hc] at hi
  rw [hi]
  rw [← pow_two, ← pow_mul]

theorem box_card : Fintype.card BoxPair = 131071^3072 := by
  have hv : Fintype.card BoxVec = (131071*131071)^768 := by
    have hc : boxVecFintype = (Pi.instFintype : Fintype BoxVec) := Subsingleton.elim _ _
    rw [hc]
    have hh := Fintype.card_fun (α := Fin 768) (β := Fin 131071 × Fin 131071)
    simpa only [Fintype.card_prod,Fintype.card_fin] using hh
  have hp : Fintype.card BoxPair = Fintype.card BoxVec*Fintype.card BoxVec := by
    have hc : boxPairFintype = instFintypeProd BoxVec BoxVec := Subsingleton.elim _ _
    rw [hc]
    exact Fintype.card_prod _ _
  rw [hp,hv]
  rw [← pow_two (131071 : ℕ), ← pow_mul, ← pow_two, ← pow_mul]

theorem D_exact : D = (18433 : ℝ)^1536 * 131071^3072 := by
  simp only [D,rq_card,box_card,Nat.cast_pow,Nat.cast_ofNat]

theorem D_pos : 0 < D := by rw [D_exact]; positivity

theorem D_le_binary : D ≤ (2 : ℝ)^75264 := by
  have hq : (18433 : ℝ) ≤ 2^15 := by norm_num
  have hb : (131071 : ℝ) ≤ 2^17 := by norm_num
  rw [D_exact]
  calc
    _ ≤ ((2 : ℝ)^15)^1536 * (2^17)^3072 :=
      mul_le_mul (pow_le_pow_left₀ (by norm_num) hq _) (pow_le_pow_left₀ (by norm_num) hb _)
        (by positivity) (by positivity)
    _ = _ := by rw [← pow_mul,← pow_mul,← pow_add]

theorem witness_weight_binary : (1 : ℝ)/2^3480 ≤ Real.exp (-(2051350378 : ℝ)/(2*768^2)) := by
  have he : Real.exp 1 ≤ 4 := (Real.exp_one_lt_three.trans (by norm_num)).le
  have hp : Real.exp (1740 : ℝ) ≤ (4 : ℝ)^1740 := by
    have hh := pow_le_pow_left₀ (Real.exp_pos 1).le he 1740
    rwa [← Real.exp_nat_mul, mul_one] at hh
  have hi := one_div_le_one_div_of_le (Real.exp_pos (1740 : ℝ)) hp
  have hx : -(1740 : ℝ) ≤ -(2051350378 : ℝ)/(2*768^2) := by norm_num
  have hb : (4 : ℝ)^1740 = (2 : ℝ)^3480 := by
    calc
      _ = ((2 : ℝ)^2)^1740 := congrArg (fun x : ℝ => x^1740) (by norm_num)
      _ = _ := (pow_mul 2 2 1740).symm
  rw [hb] at hi
  simp only [one_div,← Real.exp_neg] at hi
  simpa only [one_div] using hi.trans (Real.exp_le_exp.mpr hx)

/- A certified but extremely wide universal envelope. It MUST NOT be
reported as a tight estimate, nor as evidence that the error is large. -/
theorem binary_envelope (h : Rq) :
    (1 : ℝ)/2^78744 ≤ delta h ∧ delta h ≤ 1-(1 : ℝ)/2^75264 := by
  have hl := div_le_div₀ (Real.exp_pos _).le witness_weight_binary D_pos D_le_binary
  have heq : ((1 : ℝ)/2^3480)/2^75264 = 1/2^78744 := by
    rw [div_div,← pow_add]
  rw [heq] at hl
  have hu := one_div_le_one_div_of_le D_pos D_le_binary
  exact ⟨hl.trans (uniform_lower h),by linarith [uniform_upper h]⟩

end FT1536.Run2.UniformErrorBound
