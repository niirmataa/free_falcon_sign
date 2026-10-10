import TemperatureScale012
import SpectralDiagonal012

/- Q-SAMPLER proof obligation: a conditional, concrete-parameter interface.
   Exact coefficient-Gram / spectral equalities are INPUTS, not source facts
   established in this module. The common scale is shift/temperature independent. -/
namespace FT1536.S05.HarmonicMass012
open Matrix
open SchurGeometry012 GaussianFromSchur012 BlockGaussian012 TemperatureScale012
open FT1536.Run2.T5ScalarMass

noncomputable def rate : ℝ := 1/(2*768^2)
noncomputable def pivotCap : ℝ := 18433^2/991

theorem scalar_limit : rate*pivotCap/Real.pi=maxCoefficient := by
  unfold rate pivotCap maxCoefficient
  ring

theorem primary_cap : (4608 : ℝ)≤pivotCap := by norm_num [pivotCap]

/-- All affine shifts and temperatures, from exact block geometry and a
    unit-modulus spectral representation of the Schur complement. -/
theorem harmonic_mass {i : Type} [Fintype i] [DecidableEq i] [Nonempty i]
    (A D : FinMatrix 1536) (B : Matrix (Fin 1536) (Fin 1536) ℝ)
    (V : Matrix i (Fin 1536) ℂ) (w : i → ℝ)
    (hA : A.PosDef) (hG : (fromBlocks A B Bᴴ D).PosDef)
    (primary : ∀ j, A j j≤4608)
    (spectral : complement A B D=SpectralDiagonal012.normalized V (fun x => 18433^2/w x))
    (positive : ∀ x, 0<w x)
    (unit : ∀ x j, star (V x j)*V x j=1)
    (harmonic : 991≤SpectralDiagonal012.harmonic w) :
    ∃ C : ℝ, 0<C ∧ ∀ (t : ℝ), 0<t → t≤1 →
      ∀ (s u : Fin 1536 → ℝ),
      (1-massBudget)*(t⁻¹)^1536*C≤blockMass (t*rate) A B D s u ∧
      blockMass (t*rate) A B D s u≤(1+massBudget)*(t⁻¹)^1536*C := by
  have capA : ∀ j, A j j≤pivotCap := fun j => (primary j).trans primary_cap
  have capS : ∀ j, complement A B D j j≤pivotCap := by
    rw [spectral]
    exact SpectralDiagonal012.reciprocal_diagonal_bound V w positive 18433 991
      (by norm_num) harmonic unit
  have hr : 0<rate := by norm_num [rate]
  refine ⟨common rate A*common rate (complement A B D),
    block_common_positive rate A B D pivotCap hA hG hr capA capS scalar_limit.le, ?_⟩
  intro t ht ht1 s u
  exact block_mass_all_temperatures (by norm_num) rate A B D pivotCap hA hG hr
    (by norm_num [pivotCap]) capA capS scalar_limit.le t ht ht1 s u

#print axioms scalar_limit
#print axioms primary_cap
#print axioms harmonic_mass
end FT1536.S05.HarmonicMass012
