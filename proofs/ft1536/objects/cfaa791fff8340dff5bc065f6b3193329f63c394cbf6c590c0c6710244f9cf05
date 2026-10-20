import Run2.RadialTriangleSplit

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

-- Local instance hygiene (bez democji mean ⟨law⟩ (λ…) rozwija elems — pętla).
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

/- ============================================================================
   Symetrie rozkładu radialSum (punkty 1-2 wiązania silnika).

   Silnik liczy `4*768 * (masa trójkąta kanonicznego)`; RadialTriangleSplit
   dał rozbiór na 4 regiony x 768. Tu dowodzimy, że:
   - cztery regiony mają RÓWNĄ masę (mapy negBlock/swapBlock na bloku:
     block_neg/block_swap/center_neg, masa rawLaw niezmienna),
   - wszystkie 768 współrzędnych mają RÓWNĄ masę (zamiana par współrzędnych),
   stąd `radialSum = 4*768 * mean rawLaw (radialHit ∧ region1)`.

   Kolejne: wiązanie binning/CDF-okien silnika z tą masą (hsumL/hsumU)
   oraz rozliczenie obowiązków ogonowych.
   ============================================================================ -/

namespace FT1536.Run2.RadialSymmetry

open Finset PublicSimulation Geometry RawProductLaw RawRadialEvents CenteringTriangle
open RadialTriangleSplit

/-! ## Pomocnicze dla Function.update (bez ryzyka sygnatur Mathlib) -/

theorem update_at_eq {α β : Type*} [DecidableEq α] (v : α → β) (i : α) (x : β) :
    Function.update v i x i = x := by
  simp only [Function.update]
  simp

theorem update_at_ne {α β : Type*} [DecidableEq α] (v : α → β) (i j : α) (x : β)
    (h : j ≠ i) : Function.update v i x j = v j := by
  simp only [Function.update, h]
  simp

/-! ## Sumy przez ekwiwalencje (reindexing) -/

theorem sum_equiv_self {Ω : Type*} [Fintype Ω] {γ : Type*} [AddCommMonoid γ]
    (e : Ω ≃ Ω) (g : Ω → γ) : (∑ x, g (e x)) = ∑ x, g x := by
  refine Finset.sum_bij (fun a _ => e a) ?_ ?_ ?_ ?_
  · intro a _
    exact Finset.mem_univ _
  · intro a₁ a₂ _ _ h
    exact e.injective h
  · intro b _
    exact ⟨e.symm b, Finset.mem_univ _, Equiv.apply_symm_apply e b⟩
  · intro a _
    rfl

theorem mean_equiv_invariant {Ω : Type*} [Fintype Ω] (p : Law Ω) (e : Ω ≃ Ω)
    (hm : ∀ x, p.mass (e x) = p.mass x) (f : Ω → ℝ) :
    mean p (fun x => f (e x)) = mean p f := by
  simp only [mean]
  have hpoint : ∀ x, p.mass x * f (e x) = p.mass (e x) * f (e x) := by
    intro x
    rw [(hm x).symm]
  simp_rw [hpoint]
  exact sum_equiv_self e (fun y => p.mass y * f y)

/-! ## Mapy na bloku: negBlock, swapBlock -/

def negBlock (b : Block) : Block :=
  (⟨131070 - b.1.val, by have h := b.1.isLt; omega⟩,
    ⟨131070 - b.2.val, by have h := b.2.isLt; omega⟩)

def swapBlock (b : Block) : Block := (⟨b.2.val, b.2.isLt⟩, ⟨b.1.val, b.1.isLt⟩)

theorem blockDecode_negBlock (b : Block) :
    blockDecode (negBlock b) = (-(blockDecode b).1, -(blockDecode b).2) := by
  simp only [blockDecode, negBlock]
  refine Prod.ext ?_ ?_
  · rw [Nat.cast_sub (show b.1.val ≤ 131070 by omega)]
    omega
  · rw [Nat.cast_sub (show b.2.val ≤ 131070 by omega)]
    omega

theorem blockDecode_swapBlock (b : Block) :
    blockDecode (swapBlock b) = ((blockDecode b).2, (blockDecode b).1) := by
  simp only [blockDecode, swapBlock]

theorem negBlock_invol (b : Block) : negBlock (negBlock b) = b := by
  simp only [negBlock]
  refine Prod.ext ?_ ?_
  · refine Fin.ext ?_
    have h := b.1.isLt
    dsimp only
    omega
  · refine Fin.ext ?_
    have h := b.2.isLt
    dsimp only
    omega

theorem swapBlock_invol (b : Block) : swapBlock (swapBlock b) = b := by
  simp only [swapBlock]

theorem blockEnergy_negBlock (b : Block) : blockEnergy (negBlock b) = blockEnergy b := by
  simp only [blockEnergy, blockDecode_negBlock, block_neg]

theorem blockEnergy_swapBlock (b : Block) : blockEnergy (swapBlock b) = blockEnergy b := by
  simp only [blockEnergy, blockDecode_swapBlock, block_swap]

theorem centeredEnergy_negBlock (b : Block) :
    centeredEnergy (negBlock b) = centeredEnergy b := by
  simp only [centeredEnergy, blockDecode_negBlock, center_neg, block_neg]

theorem centeredEnergy_swapBlock (b : Block) :
    centeredEnergy (swapBlock b) = centeredEnergy b := by
  simp only [centeredEnergy, blockDecode_swapBlock, block_swap]

/-! ## Krzyżowanie regionów przez mapy bloku -/

theorem region1_negBlock (b : Block) : region1 (negBlock b) ↔ region2 b := by
  simp only [region1, region2, blockDecode_negBlock]

theorem region2_negBlock (b : Block) : region2 (negBlock b) ↔ region1 b := by
  simp only [region1, region2, blockDecode_negBlock, neg_neg]

theorem region3_negBlock (b : Block) : region3 (negBlock b) ↔ region4 b := by
  simp only [region3, region4, blockDecode_negBlock]

theorem region1_swapBlock (b : Block) : region1 (swapBlock b) ↔ region3 b := by
  simp only [region1, region3, blockDecode_swapBlock]

theorem region3_swapBlock (b : Block) : region3 (swapBlock b) ↔ region1 b := by
  simp only [region1, region3, blockDecode_swapBlock]

/-! ## before/energy jako sumy i ich niezmienniczość -/

theorem before_as_sums (z : BoxPair) :
    before z = (∑ j : Fin 768, blockEnergy (z.1 j)) + (∑ j : Fin 768, blockEnergy (z.2 j)) := by
  simp only [before, Q, Q0, decode, decodeVec, blockEnergy, blockDecode]

theorem gaussianWeight_eq_before (z : BoxPair) :
    gaussianWeight z = Real.exp (-(before z : ℝ) / (2 * 768^2)) := by
  simp only [gaussianWeight, before]

theorem before_replace (z : BoxPair) (i : Fin 768) (f : Block → Block)
    (hf : ∀ b, blockEnergy (f b) = blockEnergy b) :
    before (Function.update z.1 i (f (z.1 i)), z.2) = before z := by
  rw [before_as_sums, before_as_sums]
  refine congrArg₂ (fun a b => a + b) ?_ rfl
  apply Finset.sum_congr rfl
  intro j _
  by_cases hji : j = i
  · subst hji
    simp only [Function.update]
    simp [hf]
  · simp only [Function.update]
    simp [hji]

theorem gaussianWeight_replace (z : BoxPair) (i : Fin 768) (f : Block → Block)
    (hf : ∀ b, blockEnergy (f b) = blockEnergy b) :
    gaussianWeight (Function.update z.1 i (f (z.1 i)), z.2) = gaussianWeight z := by
  rw [gaussianWeight_eq_before, gaussianWeight_eq_before, before_replace z i f hf]

theorem rawLaw_mass_eq (z : BoxPair) :
    rawLaw.mass z = gaussianWeight z / ∑ y : BoxPair, gaussianWeight y := by
  simp only [rawLaw, Law.weighted]

theorem rawLaw_mass_replace (z : BoxPair) (i : Fin 768) (f : Block → Block)
    (hf : ∀ b, blockEnergy (f b) = blockEnergy b) :
    rawLaw.mass (Function.update z.1 i (f (z.1 i)), z.2) = rawLaw.mass z := by
  rw [rawLaw_mass_eq, rawLaw_mass_eq, gaussianWeight_replace z i f hf]

/-! ## Pary map na BoxPair i ich inwolutywność -/

def negPair (i : Fin 768) (z : BoxPair) : BoxPair :=
  (Function.update z.1 i (negBlock (z.1 i)), z.2)

def swPair (i : Fin 768) (z : BoxPair) : BoxPair :=
  (Function.update z.1 i (swapBlock (z.1 i)), z.2)

theorem negPair_at (z : BoxPair) (i : Fin 768) :
    (negPair i z).1 i = negBlock (z.1 i) :=
  update_at_eq z.1 i (negBlock (z.1 i))

theorem swPair_at (z : BoxPair) (i : Fin 768) :
    (swPair i z).1 i = swapBlock (z.1 i) :=
  update_at_eq z.1 i (swapBlock (z.1 i))

theorem negPair_invol (i : Fin 768) : Function.Involutive (negPair i) := by
  intro z
  apply Prod.ext
  · funext j
    by_cases hji : j = i
    · subst hji
      simp only [negPair]
      rw [update_at_eq, update_at_eq, negBlock_invol]
    · simp only [negPair]
      rw [update_at_ne _ _ _ _ hji, update_at_ne _ _ _ _ hji]
  · rfl

theorem swPair_invol (i : Fin 768) : Function.Involutive (swPair i) := by
  intro z
  apply Prod.ext
  · funext j
    by_cases hji : j = i
    · subst hji
      simp only [swPair]
      rw [update_at_eq, update_at_eq, swapBlock_invol]
    · simp only [swPair]
      rw [update_at_ne _ _ _ _ hji, update_at_ne _ _ _ _ hji]
  · rfl

theorem rawLaw_mass_negPair (z : BoxPair) (i : Fin 768) :
    rawLaw.mass (negPair i z) = rawLaw.mass z :=
  rawLaw_mass_replace z i negBlock (fun b => blockEnergy_negBlock b)

theorem rawLaw_mass_swPair (z : BoxPair) (i : Fin 768) :
    rawLaw.mass (swPair i z) = rawLaw.mass z :=
  rawLaw_mass_replace z i swapBlock (fun b => blockEnergy_swapBlock b)

/-! ## Niezmienniczość radialHit przez mapy bloku -/

theorem radialHit_negPair (z : BoxPair) (i : Fin 768) :
    radialHit (negPair i z) i ↔ radialHit z i := by
  have hb : before (negPair i z) = before z :=
    before_replace z i negBlock (fun b => blockEnergy_negBlock b)
  have he : blockEnergy ((negPair i z).1 i) = blockEnergy (z.1 i) := by
    rw [negPair_at, blockEnergy_negBlock]
  have hc : centeredEnergy ((negPair i z).1 i) = centeredEnergy (z.1 i) := by
    rw [negPair_at, centeredEnergy_negBlock]
  simp only [radialHit, oneChange, hb, he, hc]

theorem radialHit_swPair (z : BoxPair) (i : Fin 768) :
    radialHit (swPair i z) i ↔ radialHit z i := by
  have hb : before (swPair i z) = before z :=
    before_replace z i swapBlock (fun b => blockEnergy_swapBlock b)
  have he : blockEnergy ((swPair i z).1 i) = blockEnergy (z.1 i) := by
    rw [swPair_at, blockEnergy_swapBlock]
  have hc : centeredEnergy ((swPair i z).1 i) = centeredEnergy (z.1 i) := by
    rw [swPair_at, centeredEnergy_swapBlock]
  simp only [radialHit, oneChange, hb, he, hc]

theorem mean_negPair_invariant (i : Fin 768) (f : BoxPair → ℝ) :
    mean rawLaw (fun z => f (negPair i z)) = mean rawLaw f :=
  mean_equiv_invariant rawLaw ⟨negPair i, negPair i, negPair_invol i, negPair_invol i⟩
    (fun z => rawLaw_mass_negPair z i) f

theorem mean_swPair_invariant (i : Fin 768) (f : BoxPair → ℝ) :
    mean rawLaw (fun z => f (swPair i z)) = mean rawLaw f :=
  mean_equiv_invariant rawLaw ⟨swPair i, swPair i, swPair_invol i, swPair_invol i⟩
    (fun z => rawLaw_mass_swPair z i) f

/-! ## Równość mas czterech regionów -/

theorem T2_eq_T1 (i : Fin 768) :
    mean rawLaw (fun z => indicator (radialHit z i ∧ region2 (z.1 i))) =
      mean rawLaw (fun z => indicator (radialHit z i ∧ region1 (z.1 i))) := by
  classical
  have hp : ∀ z : BoxPair,
      indicator (radialHit z i ∧ region2 (z.1 i))
        = indicator (radialHit (negPair i z) i ∧ region1 ((negPair i z).1 i)) := by
    intro z
    refine congrArg indicator (propext ⟨?_, ?_⟩)
    · intro h
      rw [negPair_at]
      exact ⟨(radialHit_negPair z i).mpr h.1, (region1_negBlock (z.1 i)).mpr h.2⟩
    · intro h
      have h1 : (negPair i z).1 i = negBlock (z.1 i) := negPair_at z i
      rw [h1] at h
      exact ⟨(radialHit_negPair z i).mp h.1, (region1_negBlock (z.1 i)).mp h.2⟩
  have hA := mean_congr rawLaw
    (fun z => indicator (radialHit z i ∧ region2 (z.1 i)))
    (fun z => indicator (radialHit (negPair i z) i ∧ region1 ((negPair i z).1 i))) hp
  have hB := mean_negPair_invariant i (fun z => indicator (radialHit z i ∧ region1 (z.1 i)))
  exact hA.trans hB

theorem T3_eq_T1 (i : Fin 768) :
    mean rawLaw (fun z => indicator (radialHit z i ∧ region3 (z.1 i))) =
      mean rawLaw (fun z => indicator (radialHit z i ∧ region1 (z.1 i))) := by
  classical
  have hp : ∀ z : BoxPair,
      indicator (radialHit z i ∧ region3 (z.1 i))
        = indicator (radialHit (swPair i z) i ∧ region1 ((swPair i z).1 i)) := by
    intro z
    refine congrArg indicator (propext ⟨?_, ?_⟩)
    · intro h
      rw [swPair_at]
      exact ⟨(radialHit_swPair z i).mpr h.1, (region1_swapBlock (z.1 i)).mpr h.2⟩
    · intro h
      have h1 : (swPair i z).1 i = swapBlock (z.1 i) := swPair_at z i
      rw [h1] at h
      exact ⟨(radialHit_swPair z i).mp h.1, (region1_swapBlock (z.1 i)).mp h.2⟩
  have hA := mean_congr rawLaw
    (fun z => indicator (radialHit z i ∧ region3 (z.1 i)))
    (fun z => indicator (radialHit (swPair i z) i ∧ region1 ((swPair i z).1 i))) hp
  have hB := mean_swPair_invariant i (fun z => indicator (radialHit z i ∧ region1 (z.1 i)))
  exact hA.trans hB

theorem T4_eq_T1 (i : Fin 768) :
    mean rawLaw (fun z => indicator (radialHit z i ∧ region4 (z.1 i))) =
      mean rawLaw (fun z => indicator (radialHit z i ∧ region1 (z.1 i))) := by
  classical
  have hp : ∀ z : BoxPair,
      indicator (radialHit z i ∧ region4 (z.1 i))
        = indicator (radialHit (negPair i z) i ∧ region3 ((negPair i z).1 i)) := by
    intro z
    refine congrArg indicator (propext ⟨?_, ?_⟩)
    · intro h
      rw [negPair_at]
      exact ⟨(radialHit_negPair z i).mpr h.1, (region3_negBlock (z.1 i)).mpr h.2⟩
    · intro h
      have h1 : (negPair i z).1 i = negBlock (z.1 i) := negPair_at z i
      rw [h1] at h
      exact ⟨(radialHit_negPair z i).mp h.1, (region3_negBlock (z.1 i)).mp h.2⟩
  have hA := mean_congr rawLaw
    (fun z => indicator (radialHit z i ∧ region4 (z.1 i)))
    (fun z => indicator (radialHit (negPair i z) i ∧ region3 ((negPair i z).1 i))) hp
  have hB := mean_negPair_invariant i (fun z => indicator (radialHit z i ∧ region3 (z.1 i)))
  exact (hA.trans hB).trans (T3_eq_T1 i)

theorem radialHit_mean_canonical (i : Fin 768) :
    mean rawLaw (fun z => indicator (radialHit z i)) =
      (4 : ℝ) * mean rawLaw (fun z => indicator (radialHit z i ∧ region1 (z.1 i))) := by
  rw [radialHit_mean_4sum, T2_eq_T1, T3_eq_T1, T4_eq_T1]
  ring

/-! ## Symetria 768 współrzędnych (zamiana par) -/

def swapIdx (i j : Fin 768) : Fin 768 := if j = 0 then i else if j = i then 0 else j

def cpair (i : Fin 768) (z : BoxPair) : BoxPair := (fun j => z.1 (swapIdx i j), z.2)


theorem swapIdx_zero (i : Fin 768) : swapIdx i 0 = i := by
  simp [swapIdx]

theorem swapIdx_invol (i : Fin 768) : Function.Involutive (swapIdx i) := by
  intro j
  by_cases hj0 : j = 0
  · subst hj0
    by_cases hi0 : i = 0
    · subst hi0
      simp [swapIdx]
    · simp [swapIdx, hi0]
  · by_cases hji : j = i
    · subst hji
      simp [swapIdx, hj0]
    · simp [swapIdx, hj0, hji]

def swapIdxEquiv (i : Fin 768) : Fin 768 ≃ Fin 768 :=
  ⟨swapIdx i, swapIdx i, swapIdx_invol i, swapIdx_invol i⟩

theorem cpair_invol (i : Fin 768) : Function.Involutive (cpair i) := by
  intro z
  apply Prod.ext
  · funext j
    simp only [cpair]
    rw [swapIdx_invol]
  · rfl

theorem before_cpair (z : BoxPair) (i : Fin 768) : before (cpair i z) = before z := by
  rw [before_as_sums, before_as_sums]
  refine congrArg₂ (fun a b => a + b) ?_ rfl
  have h := sum_equiv_self (swapIdxEquiv i) (fun j => blockEnergy (z.1 j))
  exact h

theorem rawLaw_mass_cpair (z : BoxPair) (i : Fin 768) :
    rawLaw.mass (cpair i z) = rawLaw.mass z := by
  rw [rawLaw_mass_eq, rawLaw_mass_eq, gaussianWeight_eq_before, gaussianWeight_eq_before,
    before_cpair z i]

theorem mean_cpair_invariant (i : Fin 768) (f : BoxPair → ℝ) :
    mean rawLaw (fun z => f (cpair i z)) = mean rawLaw f :=
  mean_equiv_invariant rawLaw ⟨cpair i, cpair i, cpair_invol i, cpair_invol i⟩
    (fun z => rawLaw_mass_cpair z i) f

theorem radialHit_cpair (z : BoxPair) (i : Fin 768) :
    radialHit (cpair i z) 0 ↔ radialHit z i := by
  have hb : before (cpair i z) = before z := before_cpair z i
  have h0 : (cpair i z).1 0 = z.1 i := by
    simp only [cpair, swapIdx_zero]
  have he : blockEnergy ((cpair i z).1 0) = blockEnergy (z.1 i) := by
    rw [h0]
  have hc : centeredEnergy ((cpair i z).1 0) = centeredEnergy (z.1 i) := by
    rw [h0]
  simp only [radialHit, oneChange, hb, he, hc]

theorem radialHit_mean_cpair (i : Fin 768) :
    mean rawLaw (fun z => indicator (radialHit z i ∧ region1 (z.1 i))) =
      mean rawLaw (fun z => indicator (radialHit z 0 ∧ region1 (z.1 0))) := by
  classical
  have hp : ∀ z : BoxPair,
      indicator (radialHit z i ∧ region1 (z.1 i))
        = indicator (radialHit (cpair i z) 0 ∧ region1 ((cpair i z).1 0)) := by
    intro z
    refine congrArg indicator (propext ⟨?_, ?_⟩)
    · intro h
      rw [show (cpair i z).1 0 = z.1 i by simp only [cpair, swapIdx_zero]]
      exact ⟨(radialHit_cpair z i).mpr h.1, h.2⟩
    · intro h
      rw [show (cpair i z).1 0 = z.1 i by simp only [cpair, swapIdx_zero]] at h
      exact ⟨(radialHit_cpair z i).mp h.1, h.2⟩
  have hA := mean_congr rawLaw
    (fun z => indicator (radialHit z i ∧ region1 (z.1 i)))
    (fun z => indicator (radialHit (cpair i z) 0 ∧ region1 ((cpair i z).1 0))) hp
  have hB := mean_cpair_invariant i (fun z => indicator (radialHit z 0 ∧ region1 (z.1 0)))
  exact hA.trans hB

/-! ## Teza główna warstwy strukturalnej: radialSum = 4*768*trójkąt kanoniczny -/

theorem radialSum_4_768 :
    radialSum = (4 : ℝ) * 768 *
      mean rawLaw (fun z => indicator (radialHit z 0 ∧ region1 (z.1 0))) := by
  classical
  have hm (i : Fin 768) :
      mean rawLaw (fun z => indicator (radialHit z i)) = rawLaw.event (fun z => radialHit z i) :=
    mean_indicator _ _
  show (∑ i : Fin 768, rawLaw.event (fun z => radialHit z i)) = _
  simp_rw [← hm, radialHit_mean_canonical, radialHit_mean_cpair]
  rw [Finset.sum_const, Finset.card_fin, nsmul_eq_mul]
  ring

#print axioms sum_equiv_self
#print axioms T2_eq_T1
#print axioms T3_eq_T1
#print axioms T4_eq_T1
#print axioms radialHit_mean_canonical
#print axioms radialHit_mean_cpair
#print axioms radialSum_4_768

end FT1536.Run2.RadialSymmetry
