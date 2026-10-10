import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Algebra.Order.Star.Real
import Mathlib.Basic.Complex.BigOperators
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/- Q-SAMPLER: exact diagonal identities for a unit-modulus evaluation matrix.
   The Fourier/source equality and full Schur spectral instance are separate. -/
namespace FT1536.S05.SpectralDiagonal012
open Matrix Finset
variable {i j : Type} [Fintype i] [DecidableEq i]

noncomputable def gram (V : Matrix i j ℂ) (w : i → ℝ) : Matrix j j ℂ :=
  Vᴴ*diagonal (fun x => (w x : ℂ))*V

noncomputable def normalized (V : Matrix i j ℂ) (w : i → ℝ) : Matrix j j ℝ :=
  fun a b => (gram V w a b).re/(Fintype.card i : ℝ)

theorem diagonal_gram (V : Matrix i j ℂ) (w : i → ℝ) (a : j)
    (unit : ∀ x, star (V x a)*V x a=1) :
    gram V w a a=∑ x, (w x : ℂ) := by
  unfold gram
  rw [Matrix.mul_assoc,Matrix.mul_apply]
  simp only [Matrix.diagonal_mul,Matrix.conjTranspose_apply]
  apply sum_congr rfl
  intro x _
  calc
    _ = (w x : ℂ)*(star (V x a)*V x a) := by ring
    _ = _ := by rw [unit x,mul_one]

theorem diagonal_normalized (V : Matrix i j ℂ) (w : i → ℝ) (a : j)
    (unit : ∀ x, star (V x a)*V x a=1) :
    normalized V w a a=(∑ x, w x)/(Fintype.card i : ℝ) := by
  unfold normalized
  rw [diagonal_gram V w a unit]
  simp

noncomputable def harmonic (w : i → ℝ) : ℝ :=
  (Fintype.card i : ℝ)/(∑ x, 1/w x)

omit [DecidableEq i] in
theorem inverse_sum_pos [Nonempty i] (w : i → ℝ) (hw : ∀ x, 0<w x) :
    0<∑ x, 1/w x :=
  Finset.sum_pos (fun x _ => one_div_pos.mpr (hw x)) Finset.univ_nonempty

omit [DecidableEq i] in
theorem harmonic_pos [Nonempty i] (w : i → ℝ) (hw : ∀ x, 0<w x) :
    0<harmonic w := by
  exact div_pos (by exact_mod_cast Fintype.card_pos) (inverse_sum_pos w hw)

theorem reciprocal_diagonal [Nonempty i] (V : Matrix i j ℂ) (w : i → ℝ)
    (hw : ∀ x, 0<w x) (q : ℝ) (a : j) (unit : ∀ x, star (V x a)*V x a=1) :
    normalized V (fun x => q^2/w x) a a=q^2/harmonic w := by
  rw [diagonal_normalized V _ a unit]
  have card : (Fintype.card i : ℝ)≠0 := by exact_mod_cast Fintype.card_ne_zero
  have sums : (∑ x,1/w x)≠0 := ne_of_gt (inverse_sum_pos w hw)
  have equal : (∑ x,q^2/w x)=q^2*(∑ x,1/w x) := by
    rw [mul_sum]
    apply sum_congr rfl
    intro x _
    ring
  rw [equal]
  unfold harmonic
  field_simp

theorem reciprocal_diagonal_bound [Nonempty i] (V : Matrix i j ℂ) (w : i → ℝ)
    (hw : ∀ x, 0<w x) (q L : ℝ) (hL : 0<L) (hH : L≤harmonic w)
    (unit : ∀ x a, star (V x a)*V x a=1) :
    ∀ a, normalized V (fun x => q^2/w x) a a≤q^2/L := by
  intro a
  rw [reciprocal_diagonal V w hw q a (fun x => unit x a)]
  exact div_le_div_of_nonneg_left (sq_nonneg q) hL hH

#print axioms diagonal_gram
#print axioms diagonal_normalized
#print axioms inverse_sum_pos
#print axioms harmonic_pos
#print axioms reciprocal_diagonal
#print axioms reciprocal_diagonal_bound
end FT1536.S05.SpectralDiagonal012
