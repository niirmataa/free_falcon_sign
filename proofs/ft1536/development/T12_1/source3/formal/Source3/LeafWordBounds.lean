import Source3.LeafCertificateSuffix

namespace FT1536.Source3.LeafWordBounds
open FT1536.Run2.KeygenLeafGate

/- Exact real decoding of the *stored* normal words. These bounds do not
identify a computed FPEMU leaf with an exact Gram/LDL leaf. That numerical
error and source binding remains a different obligation. -/
theorem accepted_exponent (w : Word)
    (hw : lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat) :
    1033≤w.toNat/2^52 ∧ w.toNat/2^52≤1041 := by
  norm_num [lowerBits,upperBits] at hw
  omega

theorem accepted_value_upper (w : Word)
    (hw : lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat) :
    positiveNormalValue w < (332054 : ℝ) := by
  have he:=(accepted_exponent w hw).2
  by_cases htop : w.toNat/2^52=1041
  · have hrem : w.toNat%2^52≤upperBits.toNat%2^52 := by
      have hupper:=hw.2
      norm_num [upperBits] at hupper
      norm_num [upperBits]
      omega
    have hm : ((2^52+w.toNat%2^52 : ℕ) : ℝ) ≤ ((2^52+upperBits.toNat%2^52 : ℕ) : ℝ) := by
      exact_mod_cast Nat.add_le_add_left hrem (2^52)
    unfold positiveNormalValue
    rw [htop]
    change ((2^52+w.toNat%2^52 : ℕ) : ℝ) * (2 : ℝ)^(-34 : ℤ)<332054
    calc
      _ ≤ ((2^52+upperBits.toNat%2^52 : ℕ) : ℝ) * (2 : ℝ)^(-34 : ℤ) :=
        mul_le_mul_of_nonneg_right hm (zpow_nonneg (by norm_num) _)
      _ < 332054 := by norm_num [upperBits]
  · have hexp : (w.toNat/2^52 : ℕ)-(1075 : ℤ)≤(-35 : ℤ) := by omega
    have hp:=zpow_le_zpow_right₀ (by norm_num : (1 : ℝ)≤2) hexp
    have hm : ((2^52+w.toNat%2^52 : ℕ) : ℝ) < (2^53 : ℝ) := by
      have hr:=Nat.mod_lt w.toNat (by norm_num : 0<2^52)
      exact_mod_cast (show 2^52+w.toNat%2^52<2^53 by omega)
    have hn : (0 : ℝ) ≤ ((2^52+w.toNat%2^52 : ℕ) : ℝ) := Nat.cast_nonneg _
    calc
      positiveNormalValue w ≤ ((2^52+w.toNat%2^52 : ℕ) : ℝ)*(2 : ℝ)^(-35 : ℤ) :=
        mul_le_mul_of_nonneg_left hp hn
      _ < 2^53*(2 : ℝ)^(-35 : ℤ) :=
        mul_lt_mul_of_pos_right hm (zpow_pos (by norm_num) _)
      _ < 332054 := by norm_num

theorem stored_reciprocal_margin (w : Word)
    (hw : lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat) :
    (1023 : ℝ) < 18433^2 / positiveNormalValue w := by
  have hlo:=accepted_value_lower w hw
  have hhi:=accepted_value_upper w hw
  have hpos : (0 : ℝ)<positiveNormalValue w := by linarith
  apply (lt_div_iff₀ hpos).mpr
  nlinarith

theorem source_return_one_stored_bounds (ws result : List Word) (bad : Flag)
    (hlen : ws.length=1536)
    (hexec : LeafCertificateSuffix.suffix ws bad=some (result,CLogic.boolean true)) :
    result=ws ∧ bad=0#32 ∧ ∀ w∈ws,
      positive w=true ∧ (1024 : ℝ)≤positiveNormalValue w ∧
      positiveNormalValue w<332054 ∧ 1023<18433^2/positiveNormalValue w := by
  obtain ⟨hb,hr,hall⟩:=LeafCertificateSuffix.source_return_one_forces_word_bounds ws result bad hlen hexec
  refine ⟨hr,hb,?_⟩
  intro w hw
  have h:=(hall w hw)
  exact ⟨h.1,accepted_value_lower w h.2,accepted_value_upper w h.2,stored_reciprocal_margin w h.2⟩

end FT1536.Source3.LeafWordBounds

#print FT1536.Source3.LeafWordBounds.source_return_one_stored_bounds
#print axioms FT1536.Source3.LeafWordBounds.accepted_value_upper
#print axioms FT1536.Source3.LeafWordBounds.stored_reciprocal_margin
#print axioms FT1536.Source3.LeafWordBounds.source_return_one_stored_bounds
