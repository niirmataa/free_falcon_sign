import Run2.LegalKeyErrorTransfer
import Mathlib.Algebra.BigOperators.Ring.Finset

-- Local instance hygiene: keep the inherited choice-based declarations
-- unchanged, but use the canonical Pi/Prod enumerations in this proof.
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.Run2.RawProductLaw
open Finset PublicSimulation Geometry ExactCounting LegalKeyErrorTransfer PublicErrorIdentity

abbrev Block := Fin 131071 × Fin 131071
def blockDecode (b : Block) : ℤ×ℤ := ((b.1.val : ℤ)-65535,(b.2.val : ℤ)-65535)
def blockEnergy (b : Block) : ℤ := Geometry.block (blockDecode b).1 (blockDecode b).2
noncomputable def blockWeight (b : Block) : ℝ := Real.exp (-(blockEnergy b : ℝ)/1179648)
noncomputable def blockNormalizer : ℝ := ∑ b : Block, blockWeight b

theorem blockNormalizer_pos : 0<blockNormalizer := by
  unfold blockNormalizer
  exact sum_pos (fun _ _ => Real.exp_pos _) univ_nonempty

noncomputable def blockLaw : Law Block :=
  Law.weighted blockWeight (fun _ => (Real.exp_pos _).le) blockNormalizer_pos

theorem exp_pair_sum {I : Type*} [Fintype I] (a b : I → ℤ) (d : ℝ) :
    Real.exp (-((∑ i,a i)+(∑ i,b i) : ℤ)/d)=
      (∏ i,Real.exp (-(a i : ℝ)/d))*(∏ i,Real.exp (-(b i : ℝ)/d)) := by
  rw [← Real.exp_sum, ← Real.exp_sum, ← Real.exp_add]
  congr 1
  simp only [Int.cast_add, Int.cast_sum, ← sum_div, sum_neg_distrib]
  ring

theorem actual_weight_product (z : BoxPair) :
    gaussianWeight z=(∏ i : Fin 768,blockWeight (z.1 i))*(∏ i : Fin 768,blockWeight (z.2 i)) := by
  have hh := exp_pair_sum (fun i : Fin 768 => blockEnergy (z.1 i))
    (fun i : Fin 768 => blockEnergy (z.2 i)) 1179648
  simpa only [gaussianWeight, Q, Q0, decode, decodeVec, blockWeight, blockEnergy, blockDecode,
    show (2*768^2 : ℝ)=1179648 by norm_num] using hh

theorem vector_product_sum (f : Block → ℝ) :
    (∑ v : BoxVec, ∏ i : Fin 768, f (v i))=(∑ b : Block,f b)^768 := by
  simpa only [Finset.prod_const, Finset.card_univ, Fintype.card_fin] using
    (Fintype.prod_sum (fun _ : Fin 768 => f)).symm

theorem vector_product_sum_family (f : Fin 768 → Block → ℝ) :
    (∑ v : BoxVec, ∏ i : Fin 768,f i (v i))=∏ i : Fin 768,∑ b : Block,f i b :=
  (Fintype.prod_sum f).symm

theorem vector_weight_sum :
    (∑ v : BoxVec, ∏ i : Fin 768, blockWeight (v i))=blockNormalizer^768 :=
  vector_product_sum blockWeight

/- A single explicit boundary transport, instead of forcing DEFEQ between
   Fintype.ofFinite and piFinset during every generic lemma application. -/
theorem legacy_box_sum (f : BoxPair → ℝ) :
    @Finset.sum BoxPair ℝ _ (@Finset.univ BoxPair boxPairFintype) f =
      ∑ z : BoxPair,f z := by
  have hf : boxPairFintype=(inferInstance : Fintype BoxPair) := Subsingleton.elim _ _
  rw [hf]

theorem totalWeight_as_sum : totalWeight=∑ z : BoxPair, gaussianWeight z := by
  rw [totalWeight, eval_count]
  simp only [ite_true]
  exact legacy_box_sum gaussianWeight

theorem actual_normalizer_product : totalWeight=blockNormalizer^1536 := by
  rw [totalWeight_as_sum]
  simp_rw [actual_weight_product]
  rw [Fintype.sum_prod_type]
  simp_rw [← mul_sum]
  rw [← sum_mul, vector_weight_sum, ← pow_add]

noncomputable def rawLaw : Law BoxPair :=
  Law.weighted gaussianWeight (fun _ => (Real.exp_pos _).le)
    (by rw [← totalWeight_as_sum]; exact totalWeight_pos)

noncomputable def vectorLaw : Law BoxVec where
  mass v := ∏ i : Fin 768, blockLaw.mass (v i)
  nonneg v := prod_nonneg fun i _ => blockLaw.nonneg (v i)
  total := by
    rw [vector_product_sum, blockLaw.total, one_pow]

noncomputable def productLaw : Law BoxPair where
  mass z := vectorLaw.mass z.1*vectorLaw.mass z.2
  nonneg z := mul_nonneg (vectorLaw.nonneg z.1) (vectorLaw.nonneg z.2)
  total := by
    rw [Fintype.sum_prod_type]
    simp_rw [← mul_sum, vectorLaw.total, mul_one]
    exact vectorLaw.total

theorem actual_mass_product (z : BoxPair) : rawLaw.mass z=productLaw.mass z := by
  simp only [rawLaw, productLaw, vectorLaw, Law.weighted]
  rw [← totalWeight_as_sum, actual_normalizer_product, actual_weight_product]
  simp only [blockLaw, Law.weighted, prod_div_distrib, prod_const, card_univ, Fintype.card_fin]
  rw [div_mul_div_comm, ← pow_add]
  rfl

theorem rawLaw_eq_productLaw : rawLaw=productLaw := by
  cases hp : rawLaw with
  | mk p pn pt =>
    cases hq : productLaw with
    | mk q qn qt =>
      have hh : p=q := funext fun z => by
        have hz := actual_mass_product z
        simpa only [hp,hq] using hz
      cases hh
      rfl

def rawEvent (z : BoxPair) : Prop :=
  Q (decode z)<B ∧ publicBadSample z
noncomputable instance : DecidablePred rawEvent := Classical.decPred _

theorem rawBad_is_event : rawBad=rawLaw.event rawEvent := by
  classical
  rw [rawBad, eval_count,
    legacy_box_sum (fun z => if Q (decode z)<B ∧ publicBadSample z then gaussianWeight z else 0),
    Law.event, sum_div]
  apply sum_congr rfl
  intro z _
  change (if Q (decode z)<B ∧ publicBadSample z then gaussianWeight z else 0)/totalWeight =
    if rawEvent z then gaussianWeight z/(∑ y,gaussianWeight y) else 0
  rw [← totalWeight_as_sum]
  by_cases h : Q (decode z)<B ∧ publicBadSample z
  · have he : rawEvent z := h
    rw [ite_eq_left h, ite_eq_left he]
  · have he : ¬rawEvent z := h
    rw [ite_eq_right h, ite_eq_right he, zero_div]

theorem rawBad_is_product_event : rawBad=productLaw.event rawEvent := by
  rw [rawBad_is_event, rawLaw_eq_productLaw]

end FT1536.Run2.RawProductLaw
