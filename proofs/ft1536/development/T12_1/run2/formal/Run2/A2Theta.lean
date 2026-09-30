import FT1536.Geometry
import Mathlib.Topology.Algebra.InfiniteSum.Real
import Mathlib.Topology.Algebra.InfiniteSum.NatInt
import Mathlib.Analysis.SpecificLimits.Normed

namespace FT1536.Run2.A2Theta
open Geometry

def degree (x y : ℤ) : ℕ := (block x y).toNat

theorem degree_cast (x y : ℤ) : (degree x y : ℤ) = block x y :=
  Int.toNat_of_nonneg (block_nonneg x y)

theorem degree_axis (x : ℤ) : x.natAbs ≤ degree x 0 := by
  have hx : (x.natAbs : ℤ)^2 = x^2 := by simp
  have hn : (0 : ℤ) ≤ x.natAbs := by positivity
  have hs : (x.natAbs : ℤ) ≤ (x.natAbs : ℤ)^2 := by
    rcases eq_or_lt_of_le hn with hz | hp
    · nlinarith
    · have hp' : (1 : ℤ) ≤ x.natAbs := by omega
      nlinarith
  have hd := degree_cast x 0
  unfold block at hd
  omega

theorem degree_l1 (x y : ℤ) : x.natAbs+y.natAbs ≤ degree x y+1 := by
  have hx : (x.natAbs : ℤ)^2 = x^2 := by simp
  have hy : (y.natAbs : ℤ)^2 = y^2 := by simp
  have hd := degree_cast x y
  have hb : (x.natAbs : ℤ)+(y.natAbs : ℤ) ≤ block x y+1 := by
    unfold block
    nlinarith [sq_nonneg (x+y), sq_nonneg ((x.natAbs : ℤ)-1),
      sq_nonneg ((y.natAbs : ℤ)-1)]
  omega

noncomputable def axis (r : ℝ) (x : ℤ) : ℝ := if x=0 then 0 else r^x.natAbs
noncomputable def origin (x : ℤ) : ℝ := if x=0 then 1 else 0
noncomputable def powerWeight (r : ℝ) (z : ℤ×ℤ) : ℝ := r^degree z.1 z.2
noncomputable def majorant (r : ℝ) (z : ℤ×ℤ) : ℝ :=
  origin z.1*origin z.2 + origin z.1*axis r z.2 +
    axis r z.1*origin z.2 + axis r z.1*axis r z.2/r

theorem axis_nonnegative (r : ℝ) (hr : 0 ≤ r) (x : ℤ) : 0 ≤ axis r x := by
  unfold axis
  split_ifs <;> positivity

theorem origin_nonnegative (x : ℤ) : 0 ≤ origin x := by
  unfold origin
  split_ifs <;> norm_num

theorem atom_majorant (r : ℝ) (hr0 : 0 < r) (hr1 : r ≤ 1) (z : ℤ×ℤ) :
    powerWeight r z ≤ majorant r z := by
  rcases z with ⟨x,y⟩
  by_cases hx : x=0
  · subst x
    by_cases hy : y=0
    · subst y
      simp [powerWeight, majorant, origin, axis, degree, block]
    · have hh := pow_le_pow_of_le_one hr0.le hr1 (degree_axis y)
      simpa [powerWeight, majorant, origin, axis, hy, degree, block] using hh
  · by_cases hy : y=0
    · subst y
      simpa [powerWeight, majorant, origin, axis, hx] using
        pow_le_pow_of_le_one hr0.le hr1 (degree_axis x)
    · simp only [powerWeight, majorant, origin, axis, hx, hy, ite_false,
        zero_mul, mul_zero, zero_add, add_zero]
      apply (le_div_iff₀ hr0).2
      rw [← pow_succ, ← pow_add]
      exact pow_le_pow_of_le_one hr0.le hr1 (degree_l1 x y)

theorem hasSum_axis (r : ℝ) (hr0 : 0 ≤ r) (hr1 : r < 1) :
    HasSum (axis r) (2*r/(1-r)) := by
  have hgeom := hasSum_geometric_of_lt_one hr0 hr1
  have hs : HasSum (fun n : ℕ => r^(n+1)) (r/(1-r)) := by
    convert hgeom.mul_left r using 1
    · ext n
      rw [pow_succ]
      ring
    · ring
  have hp : HasSum (fun n : ℕ => axis r (n+1)) (r/(1-r)) := by
    convert hs using 1
    ext n
    have he : (n : ℤ)+1 = ((n+1 : ℕ) : ℤ) := by omega
    rw [he]
    have hne : ((n+1 : ℕ) : ℤ) ≠ 0 := by omega
    simp only [axis, hne, ite_false, Int.natAbs_natCast]
  have hn : HasSum (fun n : ℕ => axis r (-(n+1))) (r/(1-r)) := by
    convert hs using 1
    ext n
    have he : (n : ℤ)+1 = ((n+1 : ℕ) : ℤ) := by omega
    rw [he]
    have hne : ((n+1 : ℕ) : ℤ) ≠ 0 := by omega
    have hneg : -((n+1 : ℕ) : ℤ) ≠ 0 := neg_ne_zero.mpr hne
    simp only [axis, hneg, ite_false, Int.natAbs_neg, Int.natAbs_natCast]
  convert hp.of_add_one_of_neg_add_one hn using 1
  simp only [axis, ite_true]
  ring

theorem hasSum_origin : HasSum origin 1 := by
  exact hasSum_ite_eq (0 : ℤ) (1 : ℝ)

theorem summable_product {α β : Type*} (f : α → ℝ) (g : β → ℝ)
    (hf : Summable f) (hg : Summable g) (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x) :
    Summable (fun z : α×β => f z.1*g z.2) := by
  apply (summable_prod_of_nonneg (fun z => mul_nonneg (hf0 z.1) (hg0 z.2))).2
  constructor
  · intro x
    exact hg.mul_left (f x)
  · simp only [tsum_mul_left]
    exact hf.mul_right _

theorem hasSum_majorant (r : ℝ) (hr0 : 0 ≤ r) (hr1 : r < 1) :
    HasSum (majorant r) (1+2*(2*r/(1-r))+(2*r/(1-r))^2/r) := by
  have h0 := hasSum_origin
  have h1 := hasSum_axis r hr0 hr1
  have h00 := h0.mul h0 (summable_product origin origin h0.summable h0.summable
    origin_nonnegative origin_nonnegative)
  have h01 := h0.mul h1 (summable_product origin (axis r) h0.summable h1.summable
    origin_nonnegative (axis_nonnegative r hr0))
  have h10 := h1.mul h0 (summable_product (axis r) origin h1.summable h0.summable
    (axis_nonnegative r hr0) origin_nonnegative)
  have h11 := h1.mul h1 (summable_product (axis r) (axis r) h1.summable h1.summable
    (axis_nonnegative r hr0) (axis_nonnegative r hr0))
  convert ((h00.add h01).add h10).add (h11.mul_right (1/r)) using 1
  · ext z
    simp only [majorant]
    ring
  · ring

theorem power_summable (r : ℝ) (hr0 : 0 < r) (hr1 : r < 1) :
    Summable (powerWeight r) :=
  (hasSum_majorant r hr0.le hr1).summable.of_nonneg_of_le
    (fun _ => pow_nonneg hr0.le _) (atom_majorant r hr0 hr1.le)

theorem power_theta_bound (r : ℝ) (hr0 : 0 < r) (hr1 : r < 1) :
    (∑' z : ℤ×ℤ, powerWeight r z) ≤ 1+8*r/(1-r)^2 := by
  have hb := (power_summable r hr0 hr1).tsum_le_tsum (atom_majorant r hr0 hr1.le)
    (hasSum_majorant r hr0.le hr1).summable
  rw [(hasSum_majorant r hr0.le hr1).tsum_eq] at hb
  refine hb.trans ?_
  have h1 : 0 < 1-r := by linarith
  have he : 1+2*(2*r/(1-r))+(2*r/(1-r))^2/r =
      1+(8*r-4*r^2)/(1-r)^2 := by
    field_simp [ne_of_gt hr0, ne_of_gt h1]
    ring
  rw [he]
  have hn : 8*r-4*r^2 ≤ 8*r := by nlinarith [sq_nonneg r]
  have hd := div_le_div_of_nonneg_right hn (sq_nonneg (1-r))
  linarith only [hd]

noncomputable def gaussianAtom (k : ℝ) (z : ℤ×ℤ) : ℝ :=
  Real.exp (-k*(block z.1 z.2 : ℝ))

theorem gaussian_as_power (k : ℝ) (z : ℤ×ℤ) :
    gaussianAtom k z = powerWeight (Real.exp (-k)) z := by
  rw [powerWeight, ← Real.exp_nat_mul]
  have hd : (degree z.1 z.2 : ℝ) = (block z.1 z.2 : ℝ) := by
    exact_mod_cast degree_cast z.1 z.2
  rw [hd, gaussianAtom]
  congr 1
  ring

theorem gaussian_summable (k : ℝ) (hk : 0 < k) : Summable (gaussianAtom k) := by
  have he : gaussianAtom k = powerWeight (Real.exp (-k)) := funext (gaussian_as_power k)
  rw [he]
  exact power_summable (Real.exp (-k)) (Real.exp_pos _)
    (Real.exp_lt_one_iff.mpr (neg_neg_of_pos hk))

theorem gaussian_theta_bound (k r : ℝ) (hk : 0 < k) (hr0 : 0 < r) (hr1 : r < 1)
    (hkr : Real.exp (-k) ≤ r) :
    (∑' z : ℤ×ℤ, gaussianAtom k z) ≤ 1+8*r/(1-r)^2 := by
  have hp : ∀ z, gaussianAtom k z ≤ powerWeight r z := by
    intro z
    rw [gaussian_as_power, powerWeight, powerWeight]
    exact pow_le_pow_left₀ (Real.exp_pos _).le hkr _
  exact ((gaussian_summable k hk).tsum_le_tsum hp
    (power_summable r hr0 hr1)).trans (power_theta_bound r hr0 hr1)

end FT1536.Run2.A2Theta
