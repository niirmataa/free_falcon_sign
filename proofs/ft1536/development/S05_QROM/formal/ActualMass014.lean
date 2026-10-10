import PrimaryBlock014
import HarmonicMass012

set_option maxRecDepth 32768

/- Q-SAMPLER: consume the old mass theorem on the actual coefficient Gram.
   The remaining Schur/spectral cap is explicit, never an emitted-key claim. -/
namespace FT1536.S05.ActualMass014
open Matrix
open FT1536.Geometry FT1536.Relation FT1536.Run2.CoefficientQuotient
open CoefficientGram013 PrimaryBlock014 SchurGeometry012 GaussianFromSchur012
open BlockGaussian012 TemperatureScale012 HarmonicMass012
open FT1536.Run2.T5ScalarMass

noncomputable def splitCoordinates :
    ((Fin 1536 → ℤ) × (Fin 1536 → ℤ)) ≃ (Coord → ℤ) :=
  (Equiv.prodComm _ _).trans ((Equiv.sumArrowEquivProdArrow (Fin 1536) (Fin 1536) ℤ).symm.trans
    (Equiv.arrowCongr blockIndex (Equiv.refl ℤ)))

theorem split_first (z : (Fin 1536 → ℤ) × (Fin 1536 → ℤ)) (i : Fin 1536) :
    splitCoordinates z (first i)=z.2 i := by
  change Sum.elim z.2 z.1 (blockIndex.symm (blockIndex (Sum.inl i)))=z.2 i
  rw [Equiv.symm_apply_apply]
  rfl

theorem split_second (z : (Fin 1536 → ℤ) × (Fin 1536 → ℤ)) (i : Fin 1536) :
    splitCoordinates z (second i)=z.1 i := by
  change Sum.elim z.2 z.1 (blockIndex.symm (blockIndex (Sum.inr i)))=z.1 i
  rw [Equiv.symm_apply_apply]
  rfl

noncomputable def fullMass (h c : Rq) (a : ℝ) : ℝ :=
  ∑' z : {z : Vec × Vec // FT1536.Relation.A h z=c}, Real.exp (-a*(Geometry.Q z.val : ℝ))

noncomputable def firstShift (f g bigF bigG : Vec) (c : Rq) : Fin 1536 → ℝ :=
  affineShift f g bigF bigG (centerRq c,0) ∘ first
noncomputable def secondShift (f g bigF bigG : Vec) (c : Rq) : Fin 1536 → ℝ :=
  affineShift f g bigF bigG (centerRq c,0) ∘ second

theorem fullMass_eq_block (f g bigF bigG : Vec) (h fInv c : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433)) (a : ℝ) :
    fullMass h c a=blockMass a (PrimaryBlock014.A f g bigF bigG) (C f g bigF bigG) (D f g bigF bigG)
      (firstShift f g bigF bigG c) (secondShift f g bigF bigG c) := by
  rw [fullMass,gaussian_fiber_in_gram f g bigF bigG h fInv c ntru public_eq inverse_eq a]
  rw [← splitCoordinates.tsum_eq (fun x : Coord → ℤ => Real.exp (-a*energy
    (gram f g bigF bigG) ((fun i => (x i : ℝ))+affineShift f g bigF bigG (centerRq c,0))))]
  unfold blockMass
  apply tsum_congr
  intro z
  have coords : ((fun i => (splitCoordinates z i : ℝ))+affineShift f g bigF bigG (centerRq c,0)) ∘ blockIndex=
      Sum.elim (translated (firstShift f g bigF bigG c) z.2)
        (translated (secondShift f g bigF bigG c) z.1) := by
    funext i
    cases i with
    | inl i =>
      change (splitCoordinates z (first i) : ℝ)+_= (z.2 i : ℝ)+_
      rw [split_first]
      rfl
    | inr i =>
      change (splitCoordinates z (second i) : ℝ)+_= (z.1 i : ℝ)+_
      rw [split_second]
      rfl
  have he := grouped_energy f g bigF bigG ntru
    ((fun i => (splitCoordinates z i : ℝ))+affineShift f g bigF bigG (centerRq c,0))
  rw [coords] at he
  change Real.exp (-a*energy _ _)=Real.exp (-a*energy _ _)
  rw [he]

/-- Exact remaining quantitative input: the diagonal of THIS Schur complement. -/
def SchurCap (f g bigF bigG : Vec) : Prop :=
  ∀ i, complement (PrimaryBlock014.A f g bigF bigG) (C f g bigF bigG) (D f g bigF bigG) i i≤pivotCap

theorem full_mass_of_schur_cap (f g bigF bigG : Vec) (h fInv : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433))
    (hf : Ternary f) (hg : Ternary g) (capS : SchurCap f g bigF bigG) :
    ∃ K : ℝ, 0<K ∧ ∀ t : ℝ, 0<t → t≤1 → ∀ c : Rq,
      (1-massBudget)*(t⁻¹)^1536*K≤fullMass h c (t*rate) ∧
      fullMass h c (t*rate)≤(1+massBudget)*(t⁻¹)^1536*K := by
  let AA := PrimaryBlock014.A f g bigF bigG
  let CC := C f g bigF bigG
  let DD := D f g bigF bigG
  have hA := A_posDef f g bigF bigG ntru
  have hG := block_posDef f g bigF bigG ntru
  have hr : 0<rate := by norm_num [rate]
  have capA : ∀ i, AA i i≤pivotCap := fun i => (A_cap f g bigF bigG hf hg i).trans primary_cap
  refine ⟨common rate AA*common rate (complement AA CC DD),
    block_common_positive rate AA CC DD pivotCap hA hG hr capA capS scalar_limit.le,?_⟩
  intro t ht ht1 c
  rw [fullMass_eq_block f g bigF bigG h fInv c ntru public_eq inverse_eq (t*rate)]
  exact block_mass_all_temperatures (by norm_num) rate AA CC DD pivotCap hA hG hr
    (by norm_num [pivotCap]) capA capS scalar_limit.le t ht ht1 _ _

theorem schur_cap_of_spectral {I : Type} [Fintype I] [DecidableEq I] [Nonempty I]
    (f g bigF bigG : Vec) (V : Matrix I (Fin 1536) ℂ) (w : I → ℝ)
    (spectral : complement (PrimaryBlock014.A f g bigF bigG) (C f g bigF bigG) (D f g bigF bigG)=
      SpectralDiagonal012.normalized V (fun i => 18433^2/w i))
    (positive : ∀ i, 0<w i) (unit : ∀ i j, star (V i j)*V i j=1)
    (harmonic : 991≤SpectralDiagonal012.harmonic w) : SchurCap f g bigF bigG := by
  unfold SchurCap
  rw [spectral]
  exact SpectralDiagonal012.reciprocal_diagonal_bound V w positive 18433 991
    (by norm_num) harmonic unit

#print axioms split_first
#print axioms split_second
#print axioms fullMass_eq_block
#print axioms full_mass_of_schur_cap
#print axioms schur_cap_of_spectral
end FT1536.S05.ActualMass014
