import Run2.RadialSymmetry
import Run2.RadialObligations

set_option maxHeartbeats 4000000
set_option maxRecDepth 65536

-- Local instance hygiene (bez democji mean ⟨law⟩ (λ…) rozwija elems — pętla).
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

/- ============================================================================
   Redukcja hchange do prymitywnego ogonu wspolrzednej (domkniecie kernelowe).

   Lancuch (kernelowo, bez sorry):
     changed => |x|>=9217 lub |y|>=9217            (center_local + omega)
     => changeProbability <= P(|x|>=9217) + P(|y|>=9217)   (mono + union)
     = 2*P(|x|>=9217)                              (symetria swapBlock)
     <= 2*tau9217 = changedBlockCap                (zewn. ogon + norm_num)
     => changeProbability^2 <= changeCap2          (cap^2 <= changeCap2)
     => pairPenalty <= multiCap                    (RadialObligations).

   Pozostaje zewnetrzne (scisle sprawdzone przez Sage/Arb512):
   P(|x|>=9217) <= tau9217 (checker tail_obligations).
   ============================================================================ -/

namespace FT1536.Run2.ChangedTailReduction

open Finset PublicSimulation Geometry RawProductLaw RawRadialEvents CenteringTriangle
open RawRadialEnclosure RawIndependence RadialSymmetry RadialObligations

/-! ## Piny liczbowe (weryfikacja exact QQ w checkersie Sage) -/

def tau9217 : ℚ := 269732934410771771958 / 10^45
def changedBlockCap : ℚ := 539465868821543543916 / 10^45

theorem cap_arith_Q :
    (2:ℚ) * tau9217 = changedBlockCap ∧ changedBlockCap^2 ≤ changeCap2 := by
  norm_num [tau9217, changedBlockCap, changeCap2]

/-! ## changed implikuje ruch wspolrzednej poza centrum -/

theorem changed_range (b : Block) (h : changed b) :
    9217 ≤ |(blockDecode b).1| ∨ 9217 ≤ |(blockDecode b).2| := by
  by_contra hc
  simp only [not_or] at hc
  obtain ⟨h1, h2⟩ := hc
  have h1' : |(blockDecode b).1| < 9217 := lt_of_not_ge h1
  have h2' : |(blockDecode b).2| < 9217 := lt_of_not_ge h2
  have hx : -(9216:ℤ) ≤ (blockDecode b).1 ∧ (blockDecode b).1 ≤ 9216 := by
    rw [abs_lt] at h1'
    omega
  have hy : -(9216:ℤ) ≤ (blockDecode b).2 ∧ (blockDecode b).2 ≤ 9216 := by
    rw [abs_lt] at h2'
    omega
  have cx : center (blockDecode b).1 = (blockDecode b).1 := by
    rw [center_local (blockDecode b).1 (by omega) (by omega)]
    have k1 : ¬((blockDecode b).1 < -9216) := by omega
    have k2 : ¬(9216 < (blockDecode b).1) := by omega
    simp [k1, k2]
  have cy : center (blockDecode b).2 = (blockDecode b).2 := by
    rw [center_local (blockDecode b).2 (by omega) (by omega)]
    have k1 : ¬((blockDecode b).2 < -9216) := by omega
    have k2 : ¬(9216 < (blockDecode b).2) := by omega
    simp [k1, k2]
  apply h
  simp only [centeredEnergy, blockEnergy, cx, cy]

/-! ## Narzedzia probabilistyczne (prob = mean ∘ indicator) -/

theorem prob_nonneg {Ω : Type*} [Fintype Ω] (p : Law Ω) (P : Ω → Prop) :
    0 ≤ prob p P := by
  classical
  simp only [prob, mean]
  exact Finset.sum_nonneg fun x _ => mul_nonneg (p.nonneg x) (indicator_nonnegative _)

theorem prob_mono {Ω : Type*} [Fintype Ω] (p : Law Ω) (P Q : Ω → Prop)
    (h : ∀ x, P x → Q x) : prob p P ≤ prob p Q := by
  classical
  simp only [prob, mean]
  apply Finset.sum_le_sum
  intro x _
  by_cases hp : P x
  · have hq := h x hp
    simp [indicator, hp, hq]
  · by_cases hq : Q x
    · simp [indicator, hp, hq, p.nonneg x]
    · simp [indicator, hp, hq]

theorem indicator_or_le (P Q : Prop) : indicator (P ∨ Q) ≤ indicator P + indicator Q := by
  classical
  by_cases hp : P <;> by_cases hq : Q <;> simp [indicator, hp, hq]

theorem prob_or_le {Ω : Type*} [Fintype Ω] (p : Law Ω) (P Q : Ω → Prop) :
    prob p (fun x => P x ∨ Q x) ≤ prob p P + prob p Q := by
  classical
  simp only [prob, mean]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro x _
  have hi := indicator_or_le (P x) (Q x)
  nlinarith [p.nonneg x]

/-! ## Symetria x/y na poziomie blockLaw (swapBlock) -/

theorem blockLaw_mass_swap (b : Block) : blockLaw.mass (swapBlock b) = blockLaw.mass b := by
  simp only [blockLaw, Law.weighted, blockWeight]
  rw [blockEnergy_swapBlock]

def swapBlockEquiv : Block ≃ Block := ⟨swapBlock, swapBlock, swapBlock_invol, swapBlock_invol⟩

theorem prob_swap_invariant (P : Block → Prop) :
    prob blockLaw (fun b => P (swapBlock b)) = prob blockLaw P := by
  classical
  simp only [prob, mean]
  have hpt : ∀ b : Block,
      blockLaw.mass (swapBlock b) * indicator (P (swapBlock (swapBlock b)))
        = blockLaw.mass b * indicator (P b) := by
    intro b
    rw [swapBlock_invol, blockLaw_mass_swap]
  have hsum : (∑ b : Block, blockLaw.mass (swapBlock b) * indicator (P (swapBlock (swapBlock b))))
      = (∑ b : Block, blockLaw.mass b * indicator (P b)) :=
    Finset.sum_congr rfl (fun b _ => hpt b)
  have h := sum_equiv_self swapBlockEquiv
    (fun b => blockLaw.mass b * indicator (P (swapBlock b)))
  calc (∑ b : Block, blockLaw.mass b * indicator (P (swapBlock b)))
      = (∑ x : Block,
          (fun b => blockLaw.mass b * indicator (P (swapBlock b))) (swapBlockEquiv x)) := h.symm
    _ = (∑ b : Block,
          blockLaw.mass (swapBlock b) * indicator (P (swapBlock (swapBlock b)))) := rfl
    _ = (∑ b : Block, blockLaw.mass b * indicator (P b)) := hsum

/-! ## Redukcja changeProbability do ogonu wspolrzednej -/

theorem changeProbability_le_two_tau
    (h : prob blockLaw (fun b => 9217 ≤ |(blockDecode b).1|) ≤ (tau9217:ℝ)) :
    changeProbability ≤ (changedBlockCap:ℝ) := by
  classical
  have hmono : changeProbability ≤ prob blockLaw
      (fun b => 9217 ≤ |(blockDecode b).1| ∨ 9217 ≤ |(blockDecode b).2|) := by
    simp only [changeProbability]
    apply prob_mono
    intro b hb
    exact changed_range b hb
  have hsym : prob blockLaw (fun b => 9217 ≤ |(blockDecode b).2|)
      = prob blockLaw (fun b => 9217 ≤ |(blockDecode b).1|) := by
    have h1 := prob_swap_invariant (fun b => 9217 ≤ |(blockDecode b).1|)
    have h2 : (fun b => 9217 ≤ |(blockDecode (swapBlock b)).1|)
        = (fun b => 9217 ≤ |(blockDecode b).2|) := by
      funext b
      simp only [blockDecode_swapBlock]
    rw [← h2]
    exact h1
  have hunion := prob_or_le blockLaw
    (fun b => 9217 ≤ |(blockDecode b).1|) (fun b => 9217 ≤ |(blockDecode b).2|)
  have htwo : prob blockLaw (fun b => 9217 ≤ |(blockDecode b).1|)
      + prob blockLaw (fun b => 9217 ≤ |(blockDecode b).2|)
      ≤ (2:ℝ) * (tau9217:ℝ) := by
    rw [hsym]
    nlinarith [h]
  have hcap : (2:ℝ) * (tau9217:ℝ) = (changedBlockCap:ℝ) := by
    norm_num [tau9217, changedBlockCap]
  linarith

theorem hchange_of_tau
    (h : prob blockLaw (fun b => 9217 ≤ |(blockDecode b).1|) ≤ (tau9217:ℝ)) :
    changeProbability^2 ≤ (changeCap2:ℝ) := by
  have hle := changeProbability_le_two_tau h
  have h0 : 0 ≤ changeProbability := prob_nonneg blockLaw changed
  have hsq : changeProbability^2 ≤ (changedBlockCap:ℝ)^2 := by
    have h1 : changeProbability * changeProbability
        ≤ (changedBlockCap:ℝ) * (changedBlockCap:ℝ) :=
      mul_le_mul hle hle h0 (by norm_num [changedBlockCap])
    simpa only [pow_two] using h1
  have hcap : (changedBlockCap:ℝ)^2 ≤ (changeCap2:ℝ) := by
    exact_mod_cast cap_arith_Q.2
  exact le_trans hsq hcap

/-- Domkniecie hpair z prymitywnego ogonu: gotowe do wpięcia w
    enclosure_of_reduced_obligations zamiast surowego hchange. -/
theorem pairPenalty_of_tau
    (h : prob blockLaw (fun b => 9217 ≤ |(blockDecode b).1|) ≤ (tau9217:ℝ)) :
    pairPenalty ≤ (multiCap:ℝ) :=
  pairPenalty_of_changeCap (hchange_of_tau h)

#print axioms cap_arith_Q
#print axioms changed_range
#print axioms prob_swap_invariant
#print axioms changeProbability_le_two_tau
#print axioms hchange_of_tau
#print axioms pairPenalty_of_tau

end FT1536.Run2.ChangedTailReduction
