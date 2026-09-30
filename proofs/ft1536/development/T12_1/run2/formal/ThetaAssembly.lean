import BlockTheta
import ThetaBox
import ThetaFinal

/-!
# ThetaAssembly — montaż ThetaBounds i pełny lemat 2 BEZ premises

Z Faz A–D: `theta2_lower`/`theta2_upper` (ThetaFinal) dają kanapkę Θ₂,
`blockSum_eq_boxSum` + `boxSum_le_theta2` + `tail_le_pow300` (ThetaBox) mostki
blockSum ↔ Θ₂ z ogonem ≤ 2⁻³⁰⁰. Składamy `thetaBounds : ThetaBounds`
i certyfikat numeryczny `hnum_cert` (eksplicytne granice wymiarne —
`Real.exp_one_gt_d9` + minoranty wykładnicze), po czym
`full_rejection_bound_no_premises : Rejection (fun _ => ()) () ≤ 2⁻²⁴`
— lemat 2 bez jakichkolwiek premises.

Pełny lemat 2 bez jakichkolwiek przesłanek (premises): kanapka Θ₂ i certyfikat
numeryczny są udowodnione kernelowo.

Zero luk dowodowych (także w szkicach); podniesienie `exponentiation.threshold`
na dwóch twierdzeniach arytmetycznych to parametr obliczeniowy `norm_num`
(jak w ThetaBox), nie wyciszenie ostrzeżeń.
-/

-- Higiena instancji (jak w MgfProduct/BlockTheta; nie przenosi się przez olean):
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.ThetaAssembly

open Real Finset FT1536 FT1536.PublicSimulation FT1536.Geometry FT1536.MgfProduct
  FT1536.RejectionBound FT1536.BlockTheta FT1536.ThetaBox FT1536.ThetaFinal
  FT1536.ThetaPoisson FT1536.Theta2Split

/-! ## Minoranty wykładnicze (bez szeregów: e^{X/3} > X/3) -/

/-- Wykładniczy minorant: e^{-X} ≤ 27/X³ dla X > 0. -/
theorem exp_neg_le_inv_pow3 {X : ℝ} (hX : 0 < X) :
    Real.exp (-X) <= 27 / X^3 := by
  have hX3 : (0:ℝ) < X / 3 := by positivity
  have he : X / 3 + 1 < Real.exp (X / 3) := Real.add_one_lt_exp (ne_of_gt hX3)
  have hgt : (0:ℝ) <= X / 3 := le_of_lt hX3
  have hcube : (X / 3)^3 < (Real.exp (X / 3))^3 :=
    pow_lt_pow_left₀ (by linarith) hgt (by norm_num)
  have hX3eq : X / 3 + X / 3 + X / 3 = X := by ring
  have hexp1 : Real.exp (X / 3 + X / 3 + X / 3) = (Real.exp (X / 3))^3 := by
    rw [Real.exp_add, Real.exp_add]
    ring
  have hexpX : Real.exp X = (Real.exp (X / 3))^3 := by
    have h := hexp1
    rw [hX3eq] at h
    exact h
  have hX3cube : (X / 3)^3 = X^3 / 27 := by
    rw [div_pow, show (3:ℝ)^3 = 27 by norm_num]
  have hlow : X^3 / 27 < Real.exp X := by
    rw [hexpX, ← hX3cube]
    exact hcube
  have h27 : (27:ℝ) * (X^3 / 27) = X^3 := by ring
  have h27b : X^3 < 27 * Real.exp X := by
    have hmul := mul_lt_mul_of_pos_left hlow (by norm_num : (0:ℝ) < 27)
    rw [h27] at hmul
    exact hmul
  have hposX3 : (0:ℝ) < X^3 := by positivity
  rw [Real.exp_neg, le_div_iff₀ hposX3]
  have hconv : (Real.exp X)⁻¹ * X^3 = X^3 / Real.exp X := by
    rw [mul_comm, div_eq_mul_inv]
  rw [hconv, div_le_iff₀ (Real.exp_pos X)]
  exact le_of_lt h27b

/-! ## Kroki numeryczne dla sStar i c0 -/

/-- 24·e^{-π²/(3sStar)} ≤ eps = 2⁻²⁰ (margines astronomiczny: ~10⁻¹⁷). -/
theorem sStar_exp_le :
    24 * Real.exp (-(Real.pi^2 / (3 * sStar))) <= eps := by
  have hpos : (0:ℝ) < 3 * sStar := mul_pos (by norm_num) sStar_pos
  have hX3 : (0:ℝ) < 3 / sStar := div_pos (by norm_num) sStar_pos
  have hXlo : 3 / sStar <= Real.pi^2 / (3 * sStar) := by
    rw [le_div_iff₀ hpos]
    have h : 3 / sStar * (3 * sStar) = 9 := by
      rw [div_mul_eq_mul_div, ← mul_assoc, mul_div_cancel_right₀ _ (ne_of_gt sStar_pos)]
      norm_num
    rw [h]
    have h9 : (9:ℝ) <= Real.pi^2 := by nlinarith [Real.pi_gt_three]
    exact h9
  have hm : Real.exp (-(Real.pi^2 / (3 * sStar))) <= Real.exp (-(3 / sStar)) :=
    (Real.exp_le_exp).2 (neg_le_neg hXlo)
  have h3 : Real.exp (-(3 / sStar)) <= 27 / (3 / sStar)^3 := exp_neg_le_inv_pow3 hX3
  have h24 : 24 * Real.exp (-(Real.pi^2 / (3 * sStar)))
      <= 24 * (27 / (3 / sStar)^3) :=
    mul_le_mul_of_nonneg_left (le_trans hm h3) (by norm_num)
  have hval : 24 * (27 / (3 / sStar)^3) <= eps := by norm_num [sStar, eps]
  exact le_trans h24 hval

/-- M(c₀) = 4e^{-π²/(3c₀)} ≤ 2⁻²¹ (margines astronomiczny: ~10⁻¹⁸). -/
theorem c0_exp_le :
    4 * Real.exp (-(Real.pi^2 / (3 * c0))) <= ((2:ℝ)^21)⁻¹ := by
  have hpos : (0:ℝ) < 3 * c0 := mul_pos (by norm_num) c0_pos
  have hX3 : (0:ℝ) < 3 / c0 := div_pos (by norm_num) c0_pos
  have hXlo : 3 / c0 <= Real.pi^2 / (3 * c0) := by
    rw [le_div_iff₀ hpos]
    have h : 3 / c0 * (3 * c0) = 9 := by
      rw [div_mul_eq_mul_div, ← mul_assoc, mul_div_cancel_right₀ _ (ne_of_gt c0_pos)]
      norm_num
    rw [h]
    have h9 : (9:ℝ) <= Real.pi^2 := by nlinarith [Real.pi_gt_three]
    exact h9
  have hm : Real.exp (-(Real.pi^2 / (3 * c0))) <= Real.exp (-(3 / c0)) :=
    (Real.exp_le_exp).2 (neg_le_neg hXlo)
  have h3 : Real.exp (-(3 / c0)) <= 27 / (3 / c0)^3 := exp_neg_le_inv_pow3 hX3
  have h4 : 4 * Real.exp (-(Real.pi^2 / (3 * c0))) <= 4 * (27 / (3 / c0)^3) :=
    mul_le_mul_of_nonneg_left (le_trans hm h3) (by norm_num)
  have hval : 4 * (27 / (3 / c0)^3) <= ((2:ℝ)^21)⁻¹ := by norm_num [c0]
  exact le_trans h4 hval

-- Próg potęgowy podniesiony — parametr obliczeniowy `norm_num`
-- (jak w ThetaBox; nie wyciszenie ostrzeżeń).
set_option exponentiation.threshold 512 in
theorem pow300_inv_le : ((2:ℝ)^300)⁻¹ <= (3538944:ℝ) * (((2:ℝ)^21)⁻¹) := by
  norm_num

/-- Dolna granica K = 2π/(c₀√3) ≥ 3538944 = 3/c₀. -/
theorem c0_K_lo : (3538944:ℝ) <= 2 * (Real.pi / (c0 * Real.sqrt 3)) := by
  have hsq32 : Real.sqrt 3 <= 2 := by
    have h1 : Real.sqrt 3 <= Real.sqrt (2^2) := Real.sqrt_le_sqrt (by norm_num)
    have h2 : Real.sqrt (2^2) = (2:ℝ) := Real.sqrt_sq (by norm_num)
    rw [h2] at h1
    exact h1
  have hc0 : (3538944:ℝ) * c0 = 3 := by norm_num [c0]
  have hKconv : (2 * Real.pi) / (c0 * Real.sqrt 3)
      = 2 * (Real.pi / (c0 * Real.sqrt 3)) := by ring
  have h1 : (3538944:ℝ) <= (2 * Real.pi) / (c0 * Real.sqrt 3) := by
    rw [le_div_iff₀ (mul_pos c0_pos (by norm_num : (0:ℝ) < Real.sqrt 3))]
    have h2 : (3538944:ℝ) * (c0 * Real.sqrt 3) = 3 * Real.sqrt 3 := by
      rw [← mul_assoc, hc0]
    rw [h2]
    nlinarith [hsq32, Real.pi_gt_three]
  rw [← hKconv]
  exact h1

/-! ## Montaż ThetaBounds -/

-- Próg potęgowy podniesiony — parametr obliczeniowy arytmetyki numerycznej
-- (jak w ThetaBox; nie wyciszenie ostrzeżeń).
set_option exponentiation.threshold 512 in
/-- Premisa analityczna lematu 2, teraz UDOWODNIONA (Fazy A–D). -/
theorem thetaBounds : ThetaBounds := by
  refine ⟨?_, ?_⟩
  · -- górna: blockSum sStar ≤ Uint
    have hs : (0:ℝ) < sStar := sStar_pos
    have hs1 : sStar <= 1 := by norm_num [sStar]
    have hbs : blockSum sStar = boxSum sStar := blockSum_eq_boxSum sStar
    have hbt : boxSum sStar <= Theta2 sStar := boxSum_le_theta2 sStar hs
    have hu := theta2_upper sStar hs hs1
    have he := sStar_exp_le
    have hnn : (0:ℝ) <= 2 * (Real.pi / (sStar * Real.sqrt 3)) := by positivity
    have h1 : (1 + 24 * Real.exp (-(Real.pi^2 / (3 * sStar)))) <= 1 + eps := by
      linarith [he]
    have h2 := mul_le_mul_of_nonneg_left h1 hnn
    have h3 : 2 * (Real.pi / (sStar * Real.sqrt 3)) * (1 + eps)
        = (2 * Real.pi / (sStar * Real.sqrt 3)) * (1 + eps) := by ring
    rw [h3] at h2
    have h4 : blockSum sStar <= (2 * Real.pi / (sStar * Real.sqrt 3)) * (1 + eps) := by
      rw [hbs]
      exact le_trans (le_trans hbt hu) h2
    exact h4
  · -- dolna: Lint ≤ blockSum c0
    have hc : (0:ℝ) < c0 := c0_pos
    have hc1 : c0 <= 1 := by norm_num [c0]
    have hlo := theta2_lower c0 hc hc1
    have htail : Theta2 c0 - boxSum c0 <= ((2:ℝ)^300)⁻¹ := tail_le_pow300
    have hbs : blockSum c0 = boxSum c0 := blockSum_eq_boxSum c0
    have hM := c0_exp_le
    have heps : (2:ℝ) * (((2:ℝ)^21)⁻¹) = eps := by norm_num [eps]
    have hKM : ((2:ℝ)^21)⁻¹ <= eps - 4 * Real.exp (-(Real.pi^2 / (3 * c0))) := by
      linarith [hM, heps]
    have hKlo := c0_K_lo
    have hKnn : (0:ℝ) <= 2 * (Real.pi / (c0 * Real.sqrt 3)) := by positivity
    have hprod := mul_le_mul hKlo hKM (by norm_num) hKnn
    have hconst := pow300_inv_le
    have hnonneg : (0:ℝ) <= 2 * (Real.pi / (c0 * Real.sqrt 3))
        * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * c0)))) - ((2:ℝ)^300)⁻¹
        - 2 * (Real.pi / (c0 * Real.sqrt 3)) * (1 - eps) := by
      nlinarith [hprod, hconst]
    have hKconv : (2 * Real.pi) / (c0 * Real.sqrt 3)
        = 2 * (Real.pi / (c0 * Real.sqrt 3)) := by ring
    have hmain : (2 * Real.pi / (c0 * Real.sqrt 3)) * (1 - eps) <= blockSum c0 := by
      rw [hKconv]
      have hstep : 2 * (Real.pi / (c0 * Real.sqrt 3)) * (1 - eps)
          <= 2 * (Real.pi / (c0 * Real.sqrt 3))
            * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * c0)))) - ((2:ℝ)^300)⁻¹ := by
        linarith [hnonneg]
      have hchain : 2 * (Real.pi / (c0 * Real.sqrt 3))
          * (1 - 4 * Real.exp (-(Real.pi^2 / (3 * c0)))) - ((2:ℝ)^300)⁻¹
        <= blockSum c0 := by
        nlinarith [hlo, htail, hbs]
      exact le_trans hstep hchain
    exact hmain

/-! ## Certyfikat numeryczny hnum (wymiarne granice exp) -/

/-- Exp(-239) ≤ (10⁹/2718281828)^239 — z `Real.exp_one_gt_d9`. -/
theorem exp_neg_239_le : Real.exp (-(239:ℝ)) <= ((10:ℝ)^9 / 2718281828)^239 := by
  have hm : (2718281828:ℝ) / 10^9 < 2.7182818283 := by norm_num
  have he1 : (2718281828:ℝ) / 10^9 < Real.exp 1 := lt_trans hm Real.exp_one_gt_d9
  have hbase : (Real.exp 1)⁻¹ <= (10:ℝ)^9 / 2718281828 := by
    have hposa : (0:ℝ) < 2718281828 / 10^9 := by norm_num
    have hposb : (0:ℝ) < Real.exp 1 := Real.exp_pos 1
    have h2 := (inv_lt_inv₀ hposb hposa).2 he1
    have h3 : ((2718281828:ℝ) / 10^9)⁻¹ = (10:ℝ)^9 / 2718281828 := by norm_num
    exact le_of_lt (h2.trans_le (le_of_eq h3))
  have h239 : Real.exp (239:ℝ) = (Real.exp 1)^239 := by
    have h := Real.exp_nat_mul (1:ℝ) 239
    push_cast at h
    rw [mul_one] at h
    exact h
  have heq : Real.exp (-(239:ℝ)) = ((Real.exp 1)⁻¹)^239 := by
    rw [Real.exp_neg, h239, inv_pow]
  rw [heq]
  exact pow_le_pow_left₀ (inv_nonneg.mpr (le_of_lt (Real.exp_pos 1))) hbase 239

/-- Exp(-47185/1179648) ≤ 1/(1+f) = 1179648/1226833 — z `Real.add_one_lt_exp`. -/
theorem exp_neg_f_le : Real.exp (-(47185 / 1179648 : ℝ)) <= (1179648 / 1226833 : ℝ) := by
  have hf : (0:ℝ) < 47185 / 1179648 := by norm_num
  have h1 : 47185 / 1179648 + 1 < Real.exp (47185 / 1179648) :=
    Real.add_one_lt_exp (ne_of_gt hf)
  have h1' : (1226833 / 1179648 : ℝ) < Real.exp (47185 / 1179648) := by
    have h : 47185 / 1179648 + 1 = (1226833 / 1179648 : ℝ) := by norm_num
    rw [h] at h1
    exact h1
  have h2 := (inv_lt_inv₀ (Real.exp_pos _) (by norm_num)).2 h1'
  have h3 : ((1226833:ℝ) / 1179648)⁻¹ = (1179648 / 1226833 : ℝ) := by norm_num
  have h4 : (Real.exp (47185 / 1179648))⁻¹ <= (1179648 / 1226833 : ℝ) :=
    le_of_lt (h2.trans_le (le_of_eq h3))
  have h5 : Real.exp (-(47185 / 1179648 : ℝ)) = (Real.exp (47185 / 1179648))⁻¹ := by
    rw [Real.exp_neg]
  rw [h5]
  exact h4

/-- Rozkład wykładnika: -lam·B = -(239 + 47185/1179648). -/
theorem exp_neg_lamB_le :
    Real.exp (-lam * (B : ℝ))
      <= ((10:ℝ)^9 / 2718281828)^239 * (1179648 / 1226833 : ℝ) := by
  have hsplit : -lam * (B : ℝ) = -(239 + 47185 / 1179648) := by norm_num [lam, B]
  have hneg : -(239 + 47185 / 1179648 : ℝ) = -239 + -(47185 / 1179648) := by ring
  rw [hsplit, hneg, Real.exp_add]
  have h1 := exp_neg_239_le
  have h2 := exp_neg_f_le
  exact mul_le_mul h1 h2 (Real.exp_pos _).le (by norm_num)

-- Próg potęgowy podniesiony — parametr obliczeniowy `norm_num`
-- (Rrat^1536 wymaga progu ≥ 1536; nie wyciszenie ostrzeżeń).
set_option exponentiation.threshold 4096 in
/-- Certyfikat wymiary: (10⁹/2718281828)^239·(1179648/1226833)·Rrat^1536 ≤ 2⁻²⁴·0,9. -/
theorem hnum_rational :
    ((10:ℝ)^9 / 2718281828)^239 * (1179648 / 1226833 : ℝ) * (Rrat ^ 1536)
      <= (1 / 2^24 : ℝ) * 9 / 10 := by
  norm_num [Rrat]

/-- Certyfikat numeryczny hnum (Sage/Arb) — teraz UDOWODNIONY kernelowo. -/
theorem hnum_cert :
    Real.exp (-lam * (B : ℝ)) * (Rrat ^ 1536) <= (1 / 2^24 : ℝ) * 9 / 10 := by
  have h1 := exp_neg_lamB_le
  have h2 : Real.exp (-lam * (B : ℝ)) * (Rrat ^ 1536)
      <= ((10:ℝ)^9 / 2718281828)^239 * (1179648 / 1226833 : ℝ) * (Rrat ^ 1536) :=
    mul_le_mul_of_nonneg_right h1 (pow_nonneg (by norm_num [Rrat]) 1536)
  exact le_trans h2 hnum_rational

/-! ## Pełny lemat 2 BEZ premises -/

/-- Lemat 2 BEZ premises: `Rejection (fun _ => ()) () ≤ 2⁻²⁴` —
norm-reject pełnej wagi; ThetaBounds i hnum udowodnione kernelowo. -/
theorem full_rejection_bound_no_premises :
    Rejection (fun _ : BoxPair => ()) () <= 1 / 2^24 :=
  full_rejection_bound thetaBounds hnum_cert

end FT1536.ThetaAssembly
