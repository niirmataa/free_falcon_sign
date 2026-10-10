import FullEvaluation014

set_option maxRecDepth 4096

/- Exact spectral block identities derived from actual coefficient evaluation
   and the proved Parseval instance, not supplied as certificate fields. -/
namespace FT1536.S05.SpectralBlocks014
open Matrix Finset
open FT1536.Geometry
open CoefficientGram013 PrimaryBlock014 Parseval014 Evaluation014 FullEvaluation014

theorem map_real_conj {i j : Type} (M : Matrix i j ℝ) :
    Mᴴ.map Complex.ofRealHom=(M.map Complex.ofRealHom)ᴴ := by
  ext i j
  simp [Matrix.conjTranspose_apply]

theorem complexMatrix_from_real (f g bigF bigG : Vec) :
    complexMatrix f g bigF bigG=(realMatrix f g bigF bigG).map Complex.ofRealHom := by
  ext i j
  change (integerMatrix f g bigF bigG i j : ℂ)=((integerMatrix f g bigF bigG i j : ℝ) : ℂ)
  norm_cast

theorem gram_complex (f g bigF bigG : Vec) :
    (gram f g bigF bigG).map Complex.ofRealHom=
      (complexMatrix f g bigF bigG)ᴴ*CoefficientGram013.metric.map Complex.ofRealHom*
        complexMatrix f g bigF bigG := by
  rw [gram,Matrix.map_mul,Matrix.map_mul,map_real_conj,← complexMatrix_from_real]

noncomputable def evaluatedBasis (f g bigF bigG : Vec) : Matrix Coord Coord ℂ :=
  pointMatrix f g bigF bigG*fullEval

theorem evaluated_gram (f g bigF bigG : Vec) :
    (evaluatedBasis f g bigF bigG)ᴴ*evaluatedBasis f g bigF bigG=
      (1536 : ℂ) • (gram f g bigF bigG).map Complex.ofRealHom := by
  rw [evaluatedBasis,← actual_intertwining]
  calc
    _ = (complexMatrix f g bigF bigG)ᴴ*(fullEvalᴴ*fullEval)*complexMatrix f g bigF bigG := by
      rw [Matrix.conjTranspose_mul]
      noncomm_ring
    _ = _ := by
      rw [full_parseval,Matrix.mul_smul,Matrix.smul_mul,gram_complex]

noncomputable def amplitude (f g bigF bigG : Vec) (out input : Bool) (p : RootIndex) : ℂ :=
  if out then (if input then -evaluate bigF p else -evaluate f p)
  else (if input then evaluate bigG p else evaluate g p)

theorem evaluatedBasis_entry (f g bigF bigG : Vec) (r i : Coord) :
    evaluatedBasis f g bigF bigG r i=
      amplitude f g bigF bigG r.1 i.2.1 r.2*evaluationMatrix r.2 (i.1,i.2.2) := by
  rw [evaluatedBasis,Matrix.mul_apply]
  change (pointMatrix f g bigF bigG *ᵥ (fun k => fullEval k i)) r=_
  rcases r with ⟨out,p⟩
  rcases i with ⟨b,input,j⟩
  rw [pointMatrix_apply]
  cases out <;> cases input <;> simp [fullEval,amplitude]

noncomputable def spectrum (f g bigF bigG : Vec) (c d : Bool) (p : RootIndex) : ℂ :=
  star (amplitude f g bigF bigG false c p)*amplitude f g bigF bigG false d p+
  star (amplitude f g bigF bigG true c p)*amplitude f g bigF bigG true d p

theorem evaluated_gram_entry (f g bigF bigG : Vec) (i j : Coord) :
    ((evaluatedBasis f g bigF bigG)ᴴ*evaluatedBasis f g bigF bigG) i j=
      ∑ p : RootIndex, (star (evaluationMatrix p (i.1,i.2.2))*
        spectrum f g bigF bigG i.2.1 j.2.1 p*evaluationMatrix p (j.1,j.2.2)) := by
  rw [Matrix.mul_apply,Fintype.sum_prod_type,Fintype.sum_bool]
  simp only [Matrix.conjTranspose_apply,evaluatedBasis_entry,star_mul]
  rw [← sum_add_distrib]
  apply sum_congr rfl
  intro p _
  unfold spectrum
  ring

noncomputable def V : Matrix RootIndex (Fin 1536) ℂ :=
  evaluationMatrix.submatrix id localIndex

noncomputable def weighted (w : RootIndex → ℂ) : Matrix (Fin 1536) (Fin 1536) ℂ :=
  Vᴴ*diagonal w*V

theorem weighted_entry (w : RootIndex → ℂ) (i j : Fin 1536) :
    weighted w i j=∑ p : RootIndex, (star (V p i)*w p*V p j) := by
  rw [weighted,Matrix.mul_assoc,Matrix.mul_apply]
  simp only [Matrix.diagonal_mul,Matrix.conjTranspose_apply,mul_assoc]

noncomputable def selected (c : Bool) (i : Fin 1536) : Coord := ((localIndex i).1,c,(localIndex i).2)

theorem actual_block_spectral (f g bigF bigG : Vec) (c d : Bool) :
    ((gram f g bigF bigG).submatrix (selected c) (selected d)).map Complex.ofRealHom=
      (1536 : ℂ)⁻¹ • weighted (spectrum f g bigF bigG c d) := by
  ext i j
  have h := congrArg (fun M : Matrix Coord Coord ℂ => M (selected c i) (selected d j))
    (evaluated_gram f g bigF bigG)
  rw [evaluated_gram_entry] at h
  change (∑ p : RootIndex, star (V p i)*spectrum f g bigF bigG c d p*V p j)=
    (1536 : ℂ)*(gram f g bigF bigG (selected c i) (selected d j) : ℂ) at h
  rw [← weighted_entry] at h
  change (gram f g bigF bigG (selected c i) (selected d j) : ℂ)=
    (1536 : ℂ)⁻¹*weighted (spectrum f g bigF bigG c d) i j
  rw [h,← mul_assoc]
  norm_num

theorem A_spectral (f g bigF bigG : Vec) :
    (A f g bigF bigG).map Complex.ofRealHom=(1536 : ℂ)⁻¹ • weighted (spectrum f g bigF bigG false false) :=
  actual_block_spectral f g bigF bigG false false

theorem C_spectral (f g bigF bigG : Vec) :
    (C f g bigF bigG).map Complex.ofRealHom=(1536 : ℂ)⁻¹ • weighted (spectrum f g bigF bigG false true) :=
  actual_block_spectral f g bigF bigG false true

theorem D_spectral (f g bigF bigG : Vec) :
    (D f g bigF bigG).map Complex.ofRealHom=(1536 : ℂ)⁻¹ • weighted (spectrum f g bigF bigG true true) :=
  actual_block_spectral f g bigF bigG true true

#print axioms map_real_conj
#print axioms complexMatrix_from_real
#print axioms gram_complex
#print axioms evaluated_gram
#print axioms evaluatedBasis_entry
#print axioms evaluated_gram_entry
#print axioms weighted_entry
#print axioms actual_block_spectral
#print axioms A_spectral
#print axioms C_spectral
#print axioms D_spectral
end FT1536.S05.SpectralBlocks014
