import Run2.GaussianFiberTilt
import Mathlib.Analysis.Complex.ExponentialBounds

namespace FT1536.Run2.RejectionNumericMargin
open Finset GaussianFiberTilt CorrectnessProbability Geometry
open FT1536.Relation

theorem log_eight_sevenths : Real.log ((8 : ℝ)/7)≤13354/100000 := by
  have hh:=Real.sum_le_exp_of_nonneg (x:=(13354 : ℝ)/100000) (by norm_num) 5
  norm_num [Finset.sum_range_succ] at hh
  apply (Real.log_le_iff_le_exp (by norm_num : (0 : ℝ)<8/7)).2
  linarith

theorem fixed_tilt_margin :
    (1536 : ℝ)*Real.log ((8 : ℝ)/7)-(B : ℝ)/9437184≤
      -(24 : ℝ)*Real.log 2-1/16 := by
  have hl:=log_eight_sevenths
  have h2:=Real.log_two_lt_d9
  norm_num only [B,Int.cast_ofNat] at *
  linarith

theorem rejection_numeric :
    Real.exp (-(B : ℝ)/9437184)*((17 : ℝ)/16*(8/7)^1536)<1/2^24 := by
  have hp : ((8 : ℝ)/7)^1536=Real.exp ((1536 : ℝ)*Real.log ((8 : ℝ)/7)) := by
    have he:=Real.exp_nat_mul (Real.log ((8 : ℝ)/7)) 1536
    norm_num only [Nat.cast_ofNat] at he
    rw [Real.exp_log (by norm_num : (0 : ℝ)<8/7)] at he
    exact he.symm
  have hsmall : (17 : ℝ)/16<Real.exp (1/16) := by
    have hh:=Real.sum_le_exp_of_nonneg (x:=(1 : ℝ)/16) (by norm_num) 3
    norm_num [Finset.sum_range_succ] at hh
    linarith
  have hpow : Real.exp (-(24 : ℝ)*Real.log 2)=1/(2 : ℝ)^24 := by
    have he:=Real.exp_nat_mul (Real.log 2) 24
    norm_num only [Nat.cast_ofNat] at he
    rw [Real.exp_log (by norm_num : (0 : ℝ)<2)] at he
    rw [neg_mul,Real.exp_neg,he]
    rw [one_div]
  rw [hp]
  calc
    _ = (17/16)*Real.exp ((1536 : ℝ)*Real.log (8/7)-(B : ℝ)/9437184) := by
      simp only [Real.exp_sub,neg_div,Real.exp_neg]
      ring
    _ ≤ (17/16)*Real.exp (-(24 : ℝ)*Real.log 2-1/16) :=
      mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr fixed_tilt_margin) (by norm_num)
    _ < Real.exp (1/16)*Real.exp (-(24 : ℝ)*Real.log 2-1/16) :=
      mul_lt_mul_of_pos_right hsmall (Real.exp_pos _)
    _ = _ := by
      rw [←Real.exp_add]
      have he : (1/16 : ℝ)+(-(24 : ℝ)*Real.log 2-1/16)= -(24 : ℝ)*Real.log 2 := by ring
      rw [he,hpow]

theorem actual_rejection_from_tilted_normalizers (h c : Rq)
    (hn : fiberMass h c (alpha-alpha/8)/fiberMass h c alpha≤(17 : ℝ)/16*(8/7)^1536) :
    rejection h c<1/(2 : ℝ)^24 := by
  have hh:=rejection_chernoff h c (alpha/8) (by norm_num [alpha])
  have hm:=mul_le_mul_of_nonneg_left hn (Real.exp_pos (-(alpha/8)*(B : ℝ))).le
  have he : -(alpha/8)*(B : ℝ)= -(B : ℝ)/9437184 := by unfold alpha; ring
  rw [he] at hh hm
  exact (hh.trans hm).trans_lt rejection_numeric

end FT1536.Run2.RejectionNumericMargin
