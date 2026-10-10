import SpectralBlocks014
import ActualMass014

set_option maxRecDepth 4096

/- Reciprocal Schur from the proved canonical Parseval and actual block
   identities. No spectral equality is assumed as a certificate field. -/
namespace FT1536.S05.ReciprocalSchur014
open Matrix Finset
open FT1536.Geometry FT1536.Relation FT1536.Run2.CoefficientQuotient
open CoefficientGram013 PrimaryBlock014 Parseval014 Evaluation014 FullEvaluation014 SpectralBlocks014

noncomputable def H : Matrix (Fin 1536) (Fin 1536) ℝ :=
  coefficientMetric.submatrix localIndex localIndex

theorem H_positive : H.PosDef := coefficientMetric_posDef.submatrix localIndex.injective

theorem V_parseval : Vᴴ*V=(1536 : ℂ) • H.map Complex.ofRealHom := by
  rw [V,Matrix.conjTranspose_submatrix]
  change evaluationMatrixᴴ.submatrix localIndex (Equiv.refl RootIndex)*
    evaluationMatrix.submatrix (Equiv.refl RootIndex) localIndex=_
  rw [Matrix.submatrix_mul_equiv,parseval_matrix]
  rfl

theorem H_inverse : H⁻¹.map Complex.ofRealHom*H.map Complex.ofRealHom=1 := by
  have h := Matrix.nonsing_inv_mul H ((Matrix.isUnit_iff_isUnit_det H).mp H_positive.isUnit)
  simpa using congrArg (fun M : Matrix (Fin 1536) (Fin 1536) ℝ => M.map Complex.ofRealHom) h

noncomputable def U : Matrix (Fin 1536) RootIndex ℂ :=
  (1536 : ℂ)⁻¹ • (H⁻¹.map Complex.ofRealHom*Vᴴ)

theorem U_left : U*V=1 := by
  rw [U,Matrix.smul_mul,Matrix.mul_assoc,V_parseval,Matrix.mul_smul,H_inverse,smul_smul]
  norm_num

theorem U_right : V*U=1 :=
  (Matrix.mul_eq_one_comm_of_equiv (A := U) (B := V) localIndex).mp U_left

theorem U_adjoint : Uᴴ*Vᴴ=1 := by
  rw [← Matrix.conjTranspose_mul,U_right,Matrix.conjTranspose_one]

noncomputable def reciprocal (a : RootIndex → ℂ) : Matrix (Fin 1536) (Fin 1536) ℂ :=
  U*diagonal (fun p => (a p)⁻¹)*Uᴴ

theorem reciprocal_left (a : RootIndex → ℂ) (ha : ∀ p, a p≠0) :
    reciprocal a*weighted a=1 := by
  have diag : diagonal (fun p => (a p)⁻¹)*diagonal a=(1 : Matrix RootIndex RootIndex ℂ) := by
    rw [Matrix.diagonal_mul_diagonal]
    simp [ha]
  calc
    _ = U*(diagonal (fun p => (a p)⁻¹)*(Uᴴ*Vᴴ)*diagonal a)*V := by
      simp only [reciprocal,weighted,Matrix.mul_assoc]
    _ = _ := by rw [U_adjoint,Matrix.mul_one,diag,Matrix.mul_one,U_left]

theorem normalized_inverse (a : RootIndex → ℂ) (ha : ∀ p, a p≠0) :
    ((1536 : ℂ)⁻¹ • weighted a)⁻¹=(1536 : ℂ) • reciprocal a := by
  apply Matrix.inv_eq_left_inv
  rw [Matrix.smul_mul,Matrix.mul_smul,smul_smul,reciprocal_left a ha]
  norm_num

theorem weighted_conj (b : RootIndex → ℂ) : (weighted b)ᴴ=weighted (fun p => star (b p)) := by
  simp only [weighted,Matrix.conjTranspose_mul,Matrix.conjTranspose_conjTranspose,
    Matrix.diagonal_conjTranspose,Matrix.mul_assoc]
  rfl

theorem weighted_reciprocal_product (x a z : RootIndex → ℂ) :
    weighted x*reciprocal a*weighted z=weighted (fun p => x p*(a p)⁻¹*z p) := by
  calc
    _ = Vᴴ*(diagonal x*(V*U)*diagonal (fun p => (a p)⁻¹)*(Uᴴ*Vᴴ)*diagonal z)*V := by
      simp only [weighted,reciprocal,Matrix.mul_assoc]
    _ = _ := by
      rw [U_right,U_adjoint,Matrix.mul_one,Matrix.mul_one,
        Matrix.diagonal_mul_diagonal,Matrix.diagonal_mul_diagonal]
      rfl

theorem weighted_sub (a b : RootIndex → ℂ) : weighted a-weighted b=weighted (fun p => a p-b p) := by
  unfold weighted
  rw [← Matrix.sub_mul,← Matrix.mul_sub,← Matrix.diagonal_sub]

theorem normalized_schur (a b d : RootIndex → ℂ) (ha : ∀ p, a p≠0)
    (det : ∀ p, a p*d p-star (b p)*b p=(18433 : ℂ)^2) :
    (1536 : ℂ)⁻¹ • weighted d-
      ((1536 : ℂ)⁻¹ • weighted b)ᴴ*((1536 : ℂ)⁻¹ • weighted a)⁻¹*
        ((1536 : ℂ)⁻¹ • weighted b)=
      (1536 : ℂ)⁻¹ • weighted (fun p => (18433 : ℂ)^2/a p) := by
  rw [normalized_inverse a ha,Matrix.conjTranspose_smul,weighted_conj]
  simp only [star_inv₀,star_ofNat,Matrix.smul_mul,Matrix.mul_smul,smul_smul]
  simp only [mul_inv_cancel₀ (show (1536 : ℂ)≠0 by norm_num),mul_one]
  rw [weighted_reciprocal_product,← smul_sub,weighted_sub]
  congr 2
  funext p
  apply (eq_div_iff (ha p)).2
  calc
    _ = a p*d p-star (b p)*b p := by field_simp [ha p]
    _ = _ := det p

theorem normSq_cast (z : ℂ) : (Complex.normSq z : ℂ)=star z*z := by
  simpa only [Complex.star_def,mul_comm] using (Complex.mul_conj z).symm

theorem primary_weight (f g bigF bigG : Vec) (p : RootIndex) :
    spectrum f g bigF bigG false false p=(Evaluation014.weight f g p : ℂ) := by
  simp only [SpectralBlocks014.spectrum,amplitude,Bool.false_eq_true,ite_false,ite_true,star_neg,neg_mul,
    Evaluation014.weight,Complex.ofReal_add,normSq_cast]
  ring

theorem point_determinant (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) (p : RootIndex) :
    spectrum f g bigF bigG false false p*spectrum f g bigF bigG true true p-
      star (spectrum f g bigF bigG false true p)*spectrum f g bigF bigG false true p=(18433 : ℂ)^2 := by
  have h : spectrum f g bigF bigG false false p*spectrum f g bigF bigG true true p-
      star (spectrum f g bigF bigG false true p)*spectrum f g bigF bigG false true p=
      star (evaluate f p*evaluate bigG p-evaluate g p*evaluate bigF p)*
        (evaluate f p*evaluate bigG p-evaluate g p*evaluate bigF p) := by
    simp only [SpectralBlocks014.spectrum,amplitude,Bool.false_eq_true,ite_true,ite_false,star_add,star_mul,
      star_neg,star_sub,star_star]
    ring
  rw [h,evaluated_ntru f g bigF bigG ntru p,star_ofNat]
  ring

theorem A_inverse_map (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    (A f g bigF bigG)⁻¹.map Complex.ofRealHom=((A f g bigF bigG).map Complex.ofRealHom)⁻¹ := by
  have hp := A_posDef f g bigF bigG ntru
  have hi := Matrix.nonsing_inv_mul (A f g bigF bigG)
    ((Matrix.isUnit_iff_isUnit_det _).mp hp.isUnit)
  apply Eq.symm
  apply Matrix.inv_eq_left_inv
  simpa using congrArg (fun M : Matrix (Fin 1536) (Fin 1536) ℝ => M.map Complex.ofRealHom) hi

theorem actual_schur_complex (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    (SchurGeometry012.complement (A f g bigF bigG) (C f g bigF bigG) (D f g bigF bigG)).map Complex.ofRealHom=
      (1536 : ℂ)⁻¹ • weighted (fun p => (18433 : ℂ)^2/(Evaluation014.weight f g p : ℂ)) := by
  have nz (p : RootIndex) : spectrum f g bigF bigG false false p≠0 := by
    rw [primary_weight]
    exact Complex.ofReal_ne_zero.mpr (ne_of_gt (weight_positive f g bigF bigG ntru p))
  have hs := normalized_schur (spectrum f g bigF bigG false false)
    (spectrum f g bigF bigG false true) (spectrum f g bigF bigG true true) nz
    (point_determinant f g bigF bigG ntru)
  rw [SchurGeometry012.complement,Matrix.map_sub,Matrix.map_mul,Matrix.map_mul,map_real_conj,
    A_inverse_map f g bigF bigG ntru,A_spectral,C_spectral,D_spectral]
  · simpa only [primary_weight] using hs
  · intro x y
    exact map_sub Complex.ofRealHom x y

theorem actual_schur_spectral (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    SchurGeometry012.complement (A f g bigF bigG) (C f g bigF bigG) (D f g bigF bigG)=
      SpectralDiagonal012.normalized V (fun p => (18433 : ℝ)^2/Evaluation014.weight f g p) := by
  have hw : weighted (fun p => (18433 : ℂ)^2/(Evaluation014.weight f g p : ℂ))=
      SpectralDiagonal012.gram V (fun p => (18433 : ℝ)^2/Evaluation014.weight f g p) := by
    simp only [weighted,SpectralDiagonal012.gram,Complex.ofReal_div,Complex.ofReal_pow,Complex.ofReal_ofNat]
  ext i j
  have hr := congrArg (fun M : Matrix (Fin 1536) (Fin 1536) ℂ => (M i j).re)
    (actual_schur_complex f g bigF bigG ntru)
  rw [hw] at hr
  change SchurGeometry012.complement (A f g bigF bigG) (C f g bigF bigG) (D f g bigF bigG) i j=
    ((1536 : ℂ)⁻¹*SpectralDiagonal012.gram V
      (fun p => (18433 : ℝ)^2/Evaluation014.weight f g p) i j).re at hr
  have reScale : ((1536 : ℂ)⁻¹).re=(1536 : ℝ)⁻¹ := by norm_num
  have imScale : ((1536 : ℂ)⁻¹).im=0 := by norm_num
  rw [Complex.mul_re,reScale,imScale,zero_mul,sub_zero] at hr
  unfold SpectralDiagonal012.normalized
  have cardinal : (Fintype.card RootIndex : ℝ)=1536 := by norm_num [RootIndex]
  rw [cardinal]
  simpa only [div_eq_mul_inv,mul_comm] using hr

theorem V_unit (p : RootIndex) (j : Fin 1536) : star (V p j)*V p j=1 := by
  change star (RootMoments014.point p.1 p.2^(power (localIndex j)))*
    RootMoments014.point p.1 p.2^(power (localIndex j))=1
  rw [star_pow,← mul_pow,RootMoments014.point_unit,one_pow]

/-- The full infinite-fiber mass premise M of sampler007, now from actual
    NTRU/ternarity and the single explicit canonical harmonic lower bound. -/
theorem mass_from_actual_harmonic (f g bigF bigG : Vec) (h fInv : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433))
    (hf : Ternary f) (hg : Ternary g)
    (harmonic : 991≤SpectralDiagonal012.harmonic (Evaluation014.weight f g)) :
    ∃ K : ℝ, 0<K ∧ ∀ t : ℝ, 0<t → t≤1 → ∀ c : Rq,
      (1-FT1536.Run2.T5ScalarMass.massBudget)*(t⁻¹)^1536*K≤ActualMass014.fullMass h c (t*HarmonicMass012.rate) ∧
      ActualMass014.fullMass h c (t*HarmonicMass012.rate)≤
        (1+FT1536.Run2.T5ScalarMass.massBudget)*(t⁻¹)^1536*K := by
  apply ActualMass014.full_mass_of_schur_cap f g bigF bigG h fInv ntru public_eq inverse_eq hf hg
  exact ActualMass014.schur_cap_of_spectral f g bigF bigG V (Evaluation014.weight f g)
    (actual_schur_spectral f g bigF bigG ntru) (weight_positive f g bigF bigG ntru) V_unit harmonic

#print axioms H_positive
#print axioms V_parseval
#print axioms H_inverse
#print axioms U_left
#print axioms U_right
#print axioms U_adjoint
#print axioms reciprocal_left
#print axioms normalized_inverse
#print axioms weighted_conj
#print axioms weighted_reciprocal_product
#print axioms weighted_sub
#print axioms normalized_schur
#print axioms normSq_cast
#print axioms primary_weight
#print axioms point_determinant
#print axioms A_inverse_map
#print axioms actual_schur_complex
#print axioms actual_schur_spectral
#print axioms V_unit
#print axioms mass_from_actual_harmonic
end FT1536.S05.ReciprocalSchur014
