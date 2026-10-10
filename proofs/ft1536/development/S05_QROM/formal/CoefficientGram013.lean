import Run2.ActualNTRUFiber
import SchurGeometry012
import Mathlib.LinearAlgebra.Matrix.ToLin

/- Q-SAMPLER: actual coefficient-basis energy, not an assumed gramEq.
   Coordinate order is (half, component, A2-pair); no legacy LDL list claim. -/
namespace FT1536.S05.CoefficientGram013
open Matrix Finset
open FT1536.Geometry FT1536.Run2.CoefficientQuotient FT1536.Run2.ActualNTRUFiber
open SchurGeometry012

abbrev PairIndex := Bool × Fin 768
abbrev Coord := Bool × PairIndex

def pack (z : Vec × Vec) (i : Coord) : ℤ :=
  let p := (if i.2.1 then z.2 else z.1) i.2.2
  if i.1 then p.2 else p.1

def unpack (x : Coord → ℤ) : Vec × Vec :=
  ((fun i => (x (false,false,i),x (true,false,i))),
   (fun i => (x (false,true,i),x (true,true,i))))

theorem unpack_pack (z : Vec × Vec) : unpack (pack z)=z := by rfl
theorem pack_unpack (x : Coord → ℤ) : pack (unpack x)=x := by
  funext i
  rcases i with ⟨b,c,j⟩
  cases b <;> cases c <;> rfl

def coordinateEquiv : (Vec × Vec) ≃+ (Coord → ℤ) where
  toFun := pack
  invFun := unpack
  left_inv := unpack_pack
  right_inv := pack_unpack
  map_add' u v := by
    funext i
    rcases i with ⟨b,c,j⟩
    cases b <;> cases c <;> rfl

theorem dimension : Fintype.card Coord=3072 := by norm_num [Coord,PairIndex]

theorem multiply_add_right (f u v : Vec) : multiply f (u+v)=multiply f u+multiply f v := by
  apply toQuot_injective ℤ
  rw [toQuot_add,toQuot_multiply,toQuot_add,toQuot_multiply,toQuot_multiply,mul_add]

theorem multiply_zero_right (f : Vec) : multiply f 0=0 := by
  apply toQuot_injective ℤ
  rw [toQuot_multiply,toQuot_zero,mul_zero]

noncomputable def basisHom (f g bigF bigG : Vec) : (Vec × Vec) →+ (Vec × Vec) where
  toFun := coefficientBasis f g bigF bigG
  map_zero' := by simp [coefficientBasis,multiply_zero_right]
  map_add' u v := by
    apply Prod.ext <;> simp only [coefficientBasis,Prod.fst_add,Prod.snd_add,multiply_add_right]
    · abel
    · abel

noncomputable def basisLinear (f g bigF bigG : Vec) : (Coord → ℤ) →ₗ[ℤ] (Coord → ℤ) :=
  (coordinateEquiv.toAddMonoidHom.comp
    ((basisHom f g bigF bigG).comp coordinateEquiv.symm.toAddMonoidHom)).toIntLinearMap

noncomputable def integerMatrix (f g bigF bigG : Vec) : Matrix Coord Coord ℤ :=
  LinearMap.toMatrix' (basisLinear f g bigF bigG)

theorem integerMatrix_apply (f g bigF bigG : Vec) (u : Vec × Vec) :
    integerMatrix f g bigF bigG *ᵥ pack u=pack (coefficientBasis f g bigF bigG u) := by
  rw [integerMatrix,LinearMap.toMatrix'_mulVec]
  change pack (coefficientBasis f g bigF bigG (unpack (pack u)))=_
  rw [unpack_pack]

noncomputable def realMatrix (f g bigF bigG : Vec) : Matrix Coord Coord ℝ :=
  (integerMatrix f g bigF bigG).map (Int.castRingHom ℝ)

def realPack (z : Vec × Vec) : Coord → ℝ := fun i => (pack z i : ℝ)

theorem realMatrix_apply (f g bigF bigG : Vec) (u : Vec × Vec) :
    realMatrix f g bigF bigG *ᵥ realPack u=realPack (coefficientBasis f g bigF bigG u) := by
  funext i
  have h := congrFun (integerMatrix_apply f g bigF bigG u) i
  change (∑ j, (integerMatrix f g bigF bigG i j : ℝ)*(pack u j : ℝ))=
    (pack (coefficientBasis f g bigF bigG u) i : ℝ)
  simpa only [Matrix.mulVec,dotProduct,Int.cast_sum,Int.cast_mul] using
    congrArg (fun a : ℤ => (a : ℝ)) h

noncomputable def metric : Matrix Coord Coord ℝ := fun i j =>
  if i.2=j.2 then (if i.1=j.1 then 1 else 1/2) else 0

theorem metric_mulVec (x : Coord → ℝ) (b : Bool) (j : PairIndex) :
    (metric *ᵥ x) (b,j)=x (b,j)+x (!b,j)/2 := by
  cases b <;> simp [Matrix.mulVec,dotProduct,metric,Fintype.sum_prod_type] <;> ring

theorem metric_energy (x : Coord → ℝ) :
    energy metric x=∑ j : PairIndex, (x (false,j)^2+x (false,j)*x (true,j)+x (true,j)^2) := by
  rw [energy,dotProduct,Fintype.sum_prod_type]
  simp only [metric_mulVec,Pi.star_apply,star_trivial]
  rw [Fintype.sum_bool,← sum_add_distrib]
  apply sum_congr rfl
  intro j _
  simp only [Bool.not_false,Bool.not_true]
  ring

theorem actual_metric_energy (z : Vec × Vec) : energy metric (realPack z)=(Geometry.Q z : ℝ) := by
  rw [metric_energy]
  simp [Fintype.sum_prod_type,realPack,pack,Geometry.Q,Geometry.Q0,Geometry.block]
  exact add_comm _ _

noncomputable def gram (f g bigF bigG : Vec) : Matrix Coord Coord ℝ :=
  (realMatrix f g bigF bigG)ᴴ*metric*realMatrix f g bigF bigG

theorem energy_pullback (M : Matrix Coord Coord ℝ) (x : Coord → ℝ) :
    energy (Mᴴ*metric*M) x=energy metric (M*ᵥ x) := by
  simp only [energy,star_mulVec,dotProduct_mulVec,vecMul_vecMul]

theorem actual_gram_energy (f g bigF bigG : Vec) (u : Vec × Vec) :
    energy (gram f g bigF bigG) (realPack u)=
      (Geometry.Q (coefficientBasis f g bigF bigG u) : ℝ) := by
  rw [gram,energy_pullback,realMatrix_apply,actual_metric_energy]

theorem realPack_add (z u : Vec × Vec) : realPack (z+u)=realPack z+realPack u := by
  have h := coordinateEquiv.map_add z u
  funext i
  change (pack (z+u) i : ℝ)=(pack z i : ℝ)+(pack u i : ℝ)
  rw [show pack (z+u) i=pack z i+pack u i from congrFun h i,Int.cast_add]

theorem actual_affine_energy (f g bigF bigG : Vec) (z u : Vec × Vec) :
    energy metric (realPack z+realMatrix f g bigF bigG *ᵥ realPack u)=
      (Geometry.Q (z+coefficientBasis f g bigF bigG u) : ℝ) := by
  rw [realMatrix_apply,← realPack_add,actual_metric_energy]

theorem metric_hermitian : metric.IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  simp only [metric,star_trivial,eq_comm]

theorem metric_posDef : metric.PosDef := by
  apply Matrix.PosDef.of_dotProduct_mulVec_pos metric_hermitian
  intro x hx
  change 0<energy metric x
  rw [metric_energy]
  have nonnegative (j : PairIndex) :
      0≤x (false,j)^2+x (false,j)*x (true,j)+x (true,j)^2 := by
    nlinarith [sq_nonneg (x (false,j)+x (true,j)),sq_nonneg (x (false,j)),sq_nonneg (x (true,j))]
  obtain ⟨i,hi⟩ := Function.ne_iff.mp hx
  have hxi : x i≠0 := hi
  apply Finset.sum_pos' (fun j _ => nonnegative j)
  refine ⟨i.2,mem_univ _,?_⟩
  rcases i with ⟨b,j⟩
  cases b
  · have hp := sq_pos_of_ne_zero hxi
    nlinarith [sq_nonneg (x (false,j)+x (true,j)),sq_nonneg (x (true,j))]
  · have hp := sq_pos_of_ne_zero hxi
    nlinarith [sq_nonneg (x (false,j)+x (true,j)),sq_nonneg (x (false,j))]

theorem toQuot_zsmul (a : ℤ) (v : Vec) :
    toQuot (a • v)=(a : FT1536.Run2.CoefficientQuotient.Q ℤ)*toQuot v := by
  have hscalar : a • v=scalarCoeffs a v := by
    funext i
    apply Prod.ext <;> simp [scalarCoeffs]
  rw [hscalar,toQuot_scalar]
  exact congrArg (fun w => w*toQuot v) (map_intCast (AdjoinRoot.of (phi ℤ)) a)

/-- Integer adjugate identity uses only exact NTRU, no public-key or mass premise. -/
theorem dual_after_basis (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) (u : Vec × Vec) :
    coefficientBasis (-f) (-bigF) (-g) (-bigG) (coefficientBasis f g bigF bigG u)=
      (18433 : ℤ) • u := by
  have hn := congrArg (toQuot (R:=ℤ)) ntru
  simp only [toQuot_sub,toQuot_multiply,toQuot_constant,map_ofNat] at hn
  apply Prod.ext
  · apply toQuot_injective ℤ
    change toQuot (multiply (-bigF) (multiply g u.1+multiply bigG u.2)+
      multiply (-bigG) (-multiply f u.1-multiply bigF u.2))=toQuot ((18433 : ℤ) • u.1)
    simp only [toQuot_add,toQuot_multiply,toQuot_sub,toQuot_neg,toQuot_zsmul,Int.cast_ofNat]
    calc
      _ = (toQuot f*toQuot bigG-toQuot g*toQuot bigF)*toQuot u.1 := by ring
      _ = _ := by rw [hn]
  · apply toQuot_injective ℤ
    change toQuot (-multiply (-f) (multiply g u.1+multiply bigG u.2)-
      multiply (-g) (-multiply f u.1-multiply bigF u.2))=toQuot ((18433 : ℤ) • u.2)
    simp only [toQuot_add,toQuot_multiply,toQuot_sub,toQuot_neg,toQuot_zsmul,Int.cast_ofNat]
    calc
      _ = (toQuot f*toQuot bigG-toQuot g*toQuot bigF)*toQuot u.2 := by ring
      _ = _ := by rw [hn]

theorem integer_matrix_duality (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    integerMatrix (-f) (-bigF) (-g) (-bigG)*integerMatrix f g bigF bigG=
      (18433 : ℤ) • (1 : Matrix Coord Coord ℤ) := by
  have maps : (basisLinear (-f) (-bigF) (-g) (-bigG)).comp (basisLinear f g bigF bigG)=
      (18433 : ℤ) • (LinearMap.id : (Coord → ℤ) →ₗ[ℤ] (Coord → ℤ)) := by
    apply LinearMap.ext
    intro x
    funext i
    change pack (coefficientBasis (-f) (-bigF) (-g) (-bigG)
      (unpack (pack (coefficientBasis f g bigF bigG (unpack x))))) i=18433*x i
    rw [unpack_pack,dual_after_basis f g bigF bigG ntru]
    have hp := map_zsmul coordinateEquiv (18433 : ℤ) (unpack x)
    have hi := congrFun hp i
    change pack ((18433 : ℤ) • unpack x) i=18433*pack (unpack x) i at hi
    rw [pack_unpack] at hi
    exact hi
  rw [integerMatrix,integerMatrix,← LinearMap.toMatrix'_comp,maps,map_smul,LinearMap.toMatrix'_id]

theorem real_matrix_duality (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    realMatrix (-f) (-bigF) (-g) (-bigG)*realMatrix f g bigF bigG=
      (18433 : ℝ) • (1 : Matrix Coord Coord ℝ) := by
  ext i j
  have h := congrArg (fun M : Matrix Coord Coord ℤ => (M i j : ℝ))
    (integer_matrix_duality f g bigF bigG ntru)
  simpa [realMatrix,Matrix.mul_apply,Matrix.one_apply,Int.cast_sum,Int.cast_mul] using h

theorem real_matrix_injective (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    Function.Injective (realMatrix f g bigF bigG).mulVec := by
  intro x y equal
  have h := congrArg (fun z => realMatrix (-f) (-bigF) (-g) (-bigG) *ᵥ z) equal
  rw [Matrix.mulVec_mulVec,Matrix.mulVec_mulVec,real_matrix_duality f g bigF bigG ntru,
    Matrix.smul_mulVec,Matrix.smul_mulVec,one_mulVec,one_mulVec] at h
  funext i
  have hi : (18433 : ℝ)*x i=18433*y i := congrFun h i
  linarith

theorem actual_gram_posDef (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    (gram f g bigF bigG).PosDef :=
  metric_posDef.conjTranspose_mul_mul_same (real_matrix_injective f g bigF bigG ntru)

noncomputable def inverseMatrix (f g bigF bigG : Vec) : Matrix Coord Coord ℝ :=
  (1/18433 : ℝ) • realMatrix (-f) (-bigF) (-g) (-bigG)

theorem matrix_inverse (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    inverseMatrix f g bigF bigG*realMatrix f g bigF bigG=1 ∧
      realMatrix f g bigF bigG*inverseMatrix f g bigF bigG=1 := by
  have left : inverseMatrix f g bigF bigG*realMatrix f g bigF bigG=1 := by
    rw [inverseMatrix,Matrix.smul_mul,real_matrix_duality f g bigF bigG ntru,smul_smul]
    norm_num
  exact ⟨left,(Matrix.mul_eq_one_comm_of_equiv
    (A := inverseMatrix f g bigF bigG) (B := realMatrix f g bigF bigG) (Equiv.refl Coord)).mp left⟩

noncomputable def affineShift (f g bigF bigG : Vec) (z : Vec × Vec) : Coord → ℝ :=
  inverseMatrix f g bigF bigG *ᵥ realPack z

theorem matrix_shift (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) (z : Vec × Vec) :
    realMatrix f g bigF bigG *ᵥ affineShift f g bigF bigG z=realPack z := by
  rw [affineShift,Matrix.mulVec_mulVec,(matrix_inverse f g bigF bigG ntru).2,one_mulVec]

theorem actual_affine_gram_energy (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) (z u : Vec × Vec) :
    energy (gram f g bigF bigG) (realPack u+affineShift f g bigF bigG z)=
      (Geometry.Q (z+coefficientBasis f g bigF bigG u) : ℝ) := by
  rw [gram,energy_pullback,mulVec_add,matrix_shift f g bigF bigG ntru,add_comm]
  exact actual_affine_energy f g bigF bigG z u

/-- Full actual fiber, with its explicit real shift; no gramEq premise. -/
theorem gaussian_fiber_in_gram (f g bigF bigG : Vec) (h fInv c : FT1536.Relation.Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : FT1536.Relation.mulRq h (FT1536.Relation.reduceVec f)=FT1536.Relation.reduceVec g)
    (inverse_eq : FT1536.Relation.mulRq fInv (FT1536.Relation.reduceVec f)=constantCoeffs (1 : ZMod 18433))
    (a : ℝ) :
    (∑' z : {z : Vec × Vec // FT1536.Relation.A h z=c}, Real.exp (-a*(Geometry.Q z.val : ℝ)))=
      ∑' x : Coord → ℤ, Real.exp (-a*energy (gram f g bigF bigG)
        ((fun i => (x i : ℝ))+affineShift f g bigF bigG (FT1536.Relation.centerRq c,0))) := by
  rw [gaussian_fiber_in_basis f g bigF bigG h fInv c ntru public_eq inverse_eq a]
  rw [← coordinateEquiv.toEquiv.tsum_eq (fun x : Coord → ℤ => Real.exp (-a*energy
    (gram f g bigF bigG) ((fun i => (x i : ℝ))+affineShift f g bigF bigG (FT1536.Relation.centerRq c,0))))]
  apply tsum_congr
  intro u
  change Real.exp (-a*(Geometry.Q _ : ℝ))=Real.exp (-a*energy _ (realPack u+_))
  rw [actual_affine_gram_energy f g bigF bigG ntru]

theorem reindexed_gram_posDef (e : Fin 3072 ≃ Coord) (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    ((gram f g bigF bigG).submatrix e e).PosDef :=
  (actual_gram_posDef f g bigF bigG ntru).submatrix e.injective

#print axioms unpack_pack
#print axioms pack_unpack
#print axioms dimension
#print axioms multiply_add_right
#print axioms multiply_zero_right
#print axioms integerMatrix_apply
#print axioms realMatrix_apply
#print axioms metric_mulVec
#print axioms metric_energy
#print axioms actual_metric_energy
#print axioms energy_pullback
#print axioms actual_gram_energy
#print axioms realPack_add
#print axioms actual_affine_energy
#print axioms metric_hermitian
#print axioms metric_posDef
#print axioms toQuot_zsmul
#print axioms dual_after_basis
#print axioms integer_matrix_duality
#print axioms real_matrix_duality
#print axioms real_matrix_injective
#print axioms actual_gram_posDef
#print axioms matrix_inverse
#print axioms matrix_shift
#print axioms actual_affine_gram_energy
#print axioms gaussian_fiber_in_gram
#print axioms reindexed_gram_posDef
end FT1536.S05.CoefficientGram013
