import RootMoments014
import MonomialIsometry014

set_option maxRecDepth 32768

/- Actual quotient evaluation at the proved FT1536 roots. No FFT routine,
   numerical approximation or desired spectral equation is a premise. -/
namespace FT1536.S05.Evaluation014
open Polynomial Finset
open FT1536.Geometry FT1536.Relation FT1536.Run2.CoefficientQuotient

abbrev RootIndex := Bool × Fin 768

theorem polynomial_vanishes (p : RootIndex) :
    (phi ℤ).eval₂ (Int.castRingHom ℂ) (RootMoments014.point p.1 p.2)=0 := by
  change (X^1536-X^768+1 : Polynomial ℤ).eval₂ (Int.castRingHom ℂ) (RootMoments014.point p.1 p.2)=0
  rw [eval₂_add,eval₂_sub,eval₂_pow,eval₂_pow,eval₂_X,eval₂_one]
  exact RootMoments014.point_polynomial p.1 p.2

noncomputable def atRoot (p : RootIndex) : FT1536.Run2.CoefficientQuotient.Q ℤ →+* ℂ :=
  AdjoinRoot.lift (Int.castRingHom ℂ) (RootMoments014.point p.1 p.2)
    (polynomial_vanishes p)

noncomputable def evaluate (v : Vec) (p : RootIndex) : ℂ := atRoot p (toQuot v)

theorem at_root (p : RootIndex) :
    atRoot p MonomialIsometry014.root=RootMoments014.point p.1 p.2 := by
  exact AdjoinRoot.lift_root _

theorem evaluate_add (v w : Vec) (p : RootIndex) : evaluate (v+w) p=evaluate v p+evaluate w p := by
  rw [evaluate,toQuot_add,map_add]
  rfl

theorem evaluate_neg (v : Vec) (p : RootIndex) : evaluate (-v) p= -evaluate v p := by
  rw [evaluate,toQuot_neg,map_neg]
  rfl

theorem evaluate_sub (v w : Vec) (p : RootIndex) : evaluate (v-w) p=evaluate v p-evaluate w p := by
  rw [evaluate,toQuot_sub,map_sub]
  rfl

theorem evaluate_multiply (v w : Vec) (p : RootIndex) :
    evaluate (multiply v w) p=evaluate v p*evaluate w p := by
  rw [evaluate,toQuot_multiply,map_mul]
  rfl

theorem evaluate_constant (a : ℤ) (p : RootIndex) : evaluate (constantCoeffs a) p=(a : ℂ) := by
  rw [evaluate,toQuot_constant]
  exact AdjoinRoot.lift_of _

theorem evaluate_sum (v : Vec) (p : RootIndex) : evaluate v p=
    ∑ j : Fin 768, ((v j).1*RootMoments014.point p.1 p.2^j.val+
      (v j).2*RootMoments014.point p.1 p.2^(j.val+768)) := by
  rw [evaluate,MonomialIsometry014.quotient_sum,map_sum]
  apply sum_congr rfl
  intro j _
  rw [map_add,map_mul,map_mul,map_pow,map_pow,at_root,map_intCast,map_intCast]

theorem evaluate_unit (high : Bool) (j : Fin 768) (p : RootIndex) :
    evaluate (MonomialIsometry014.unitVec high j) p=
      RootMoments014.point p.1 p.2^(j.val+if high then 768 else 0) := by
  rw [evaluate,MonomialIsometry014.quotient_unit,map_pow,at_root]

theorem evaluated_ntru (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) (p : RootIndex) :
    evaluate f p*evaluate bigG p-evaluate g p*evaluate bigF p=18433 := by
  have h := congrArg (fun v => evaluate v p) ntru
  simpa only [evaluate_sub,evaluate_multiply,evaluate_constant,Int.cast_ofNat] using h

noncomputable def weight (f g : Vec) (p : RootIndex) : ℝ :=
  Complex.normSq (evaluate f p)+Complex.normSq (evaluate g p)

theorem weight_positive (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) (p : RootIndex) :
    0<weight f g p := by
  have hf := Complex.normSq_nonneg (evaluate f p)
  have hg := Complex.normSq_nonneg (evaluate g p)
  by_contra hn
  have hzero : weight f g p≤0 := not_lt.mp hn
  unfold weight at hzero
  have zf : Complex.normSq (evaluate f p)=0 := by linarith
  have zg : Complex.normSq (evaluate g p)=0 := by linarith
  rw [Complex.normSq_eq_zero] at zf zg
  have h := evaluated_ntru f g bigF bigG ntru p
  rw [zf,zg,zero_mul,zero_mul,sub_zero] at h
  norm_num at h

#print axioms polynomial_vanishes
#print axioms at_root
#print axioms evaluate_add
#print axioms evaluate_neg
#print axioms evaluate_sub
#print axioms evaluate_multiply
#print axioms evaluate_constant
#print axioms evaluate_sum
#print axioms evaluate_unit
#print axioms evaluated_ntru
#print axioms weight_positive
end FT1536.S05.Evaluation014
