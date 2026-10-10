import Parseval014
import Evaluation014

set_option maxRecDepth 4096

/- Full coefficient/evaluation intertwining for the ACTUAL NTRU basis.
   The outer row Bool labels the output component; the outer column Bool
   labels the coefficient half. Both index types have3072 elements. -/
namespace FT1536.S05.FullEvaluation014
open Matrix Finset
open FT1536.Geometry FT1536.Run2.ActualNTRUFiber
open CoefficientGram013 PrimaryBlock014 Parseval014 Evaluation014

def packedComplex (z : Vec × Vec) : Coord → ℂ := fun i => (pack z i : ℂ)

noncomputable def complexMatrix (f g bigF bigG : Vec) : Matrix Coord Coord ℂ :=
  (integerMatrix f g bigF bigG).map (Int.castRingHom ℂ)

theorem complexMatrix_apply (f g bigF bigG : Vec) (u : Vec × Vec) :
    complexMatrix f g bigF bigG *ᵥ packedComplex u=packedComplex (coefficientBasis f g bigF bigG u) := by
  funext i
  have h := congrFun (integerMatrix_apply f g bigF bigG u) i
  change (∑ j, (integerMatrix f g bigF bigG i j : ℂ)*(pack u j : ℂ))=
    (pack (coefficientBasis f g bigF bigG u) i : ℂ)
  simpa only [Matrix.mulVec,dotProduct,Int.cast_sum,Int.cast_mul] using
    congrArg (fun a : ℤ => (a : ℂ)) h

noncomputable def fullEval : Matrix Coord Coord ℂ := fun r i =>
  if r.1=i.2.1 then evaluationMatrix r.2 (i.1,i.2.2) else 0

theorem fullEval_on_packed (z : Vec × Vec) (c : Bool) (p : RootIndex) :
    (fullEval *ᵥ packedComplex z) (c,p)=evaluate (if c then z.2 else z.1) p := by
  cases c
  all_goals simp only [Bool.false_eq_true,ite_false,ite_true,evaluate_sum]
  all_goals simp [Matrix.mulVec,dotProduct,Fintype.sum_prod_type,fullEval,packedComplex,pack,
    evaluationMatrix,power]
  all_goals rw [← sum_add_distrib]
  all_goals apply sum_congr rfl
  all_goals intro j _
  all_goals ring

theorem full_parseval_entry (i j : Coord) :
    (fullEvalᴴ*fullEval) i j=1536*(CoefficientGram013.metric i j : ℂ) := by
  rcases i with ⟨b,c,i⟩
  rcases j with ⟨d,e,j⟩
  rw [Matrix.mul_apply,Fintype.sum_prod_type,Fintype.sum_bool]
  cases c <;> cases e
  all_goals simp only [Matrix.conjTranspose_apply,fullEval,Bool.false_eq_true,Bool.true_eq_false,
    ite_true,ite_false,star_zero,zero_mul,mul_zero,sum_const_zero,zero_add,add_zero]
  · have h := parseval_entry (b,i) (d,j)
    simpa only [Matrix.mul_apply,Matrix.conjTranspose_apply,coefficientMetric,Matrix.submatrix_apply,primary]
      using h
  · simp [CoefficientGram013.metric]
  · simp [CoefficientGram013.metric]
  · have h := parseval_entry (b,i) (d,j)
    simpa [Matrix.mul_apply,Matrix.conjTranspose_apply,coefficientMetric_apply,CoefficientGram013.metric]
      using h

theorem full_parseval : fullEvalᴴ*fullEval=
    (1536 : ℂ) • CoefficientGram013.metric.map Complex.ofRealHom := by
  ext i j
  exact full_parseval_entry i j

noncomputable def pointMatrix (f g bigF bigG : Vec) : Matrix Coord Coord ℂ := fun r s =>
  if r.2=s.2 then
    (if r.1 then (if s.1 then -evaluate bigF r.2 else -evaluate f r.2)
     else (if s.1 then evaluate bigG r.2 else evaluate g r.2)) else 0

theorem pointMatrix_apply (f g bigF bigG : Vec) (x : Coord → ℂ) (c : Bool) (p : RootIndex) :
    (pointMatrix f g bigF bigG *ᵥ x) (c,p)=
      if c then -evaluate f p*x (false,p)-evaluate bigF p*x (true,p)
      else evaluate g p*x (false,p)+evaluate bigG p*x (true,p) := by
  cases c <;> simp [pointMatrix,Matrix.mulVec,dotProduct,Fintype.sum_prod_type] <;> ring

theorem pointMatrix_evaluation (f g bigF bigG : Vec) (u : Vec × Vec) :
    pointMatrix f g bigF bigG *ᵥ (fullEval *ᵥ packedComplex u)=
      fullEval *ᵥ packedComplex (coefficientBasis f g bigF bigG u) := by
  funext r
  rcases r with ⟨c,p⟩
  rw [pointMatrix_apply,fullEval_on_packed,fullEval_on_packed,fullEval_on_packed]
  cases c <;> simp only [ite_true,ite_false,Bool.false_eq_true,coefficientBasis,
    evaluate_add,evaluate_sub,evaluate_neg,evaluate_multiply,neg_mul]

theorem matrices_eq_of_packed (M N : Matrix Coord Coord ℂ)
    (same : ∀ u : Vec × Vec, M *ᵥ packedComplex u=N *ᵥ packedComplex u) : M=N := by
  ext i j
  have h := congrFun (same (unpack (Pi.single j 1))) i
  have packed : packedComplex (unpack (Pi.single j 1))=Pi.single j (1 : ℂ) := by
    funext k
    simp [packedComplex,pack_unpack,Pi.single_apply]
  rw [packed] at h
  simpa using h

theorem actual_intertwining (f g bigF bigG : Vec) :
    fullEval*complexMatrix f g bigF bigG=pointMatrix f g bigF bigG*fullEval := by
  apply matrices_eq_of_packed
  intro u
  rw [← Matrix.mulVec_mulVec,← Matrix.mulVec_mulVec,complexMatrix_apply,pointMatrix_evaluation]

#print axioms complexMatrix_apply
#print axioms fullEval_on_packed
#print axioms full_parseval_entry
#print axioms full_parseval
#print axioms pointMatrix_apply
#print axioms pointMatrix_evaluation
#print axioms matrices_eq_of_packed
#print axioms actual_intertwining
end FT1536.S05.FullEvaluation014
