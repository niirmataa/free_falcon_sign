import RootMoments014
import PrimaryBlock014

set_option maxRecDepth 2048

/- Canonical FT1536 Parseval identity for the actual A2 coefficient metric.
   This is a proved instance, not a Fourier/Gram certificate assumed as input. -/
namespace FT1536.S05.Parseval014
open Matrix Finset
open RootMoments014 CoefficientGram013 PrimaryBlock014

noncomputable def correlation (e f : ℕ) : ℂ :=
  ∑ p : Bool × Fin 768, star (point p.1 p.2^e)*point p.1 p.2^f

theorem correlation_diff (e f : ℕ) (hef : e≤f) : correlation e f=moment (f-e) := by
  unfold correlation moment
  apply sum_congr rfl
  intro p _
  rw [show f=e+(f-e) by omega,pow_add,star_pow,← mul_assoc,← mul_pow,point_unit,one_pow,one_mul]
  rw [show e+(f-e)-e=f-e by omega]

theorem correlation_star (e f : ℕ) : star (correlation e f)=correlation f e := by
  simp only [correlation,star_sum,star_mul,star_star]

theorem correlation_of_le (e f : ℕ) (he : e<1536) (hf : f<1536) (hef : e≤f) :
    correlation e f=if e=f then 1536 else if e+768=f ∨ f+768=e then 768 else 0 := by
  rw [correlation_diff e f hef,moment_small (f-e) (by omega)]
  have hz : (f-e=0) ↔ e=f := by omega
  have hm : (f-e=768) ↔ e+768=f := by omega
  have hn : ¬f+768=e := by omega
  simp only [hz,hm,hn,or_false]

theorem correlation_formula (e f : ℕ) (he : e<1536) (hf : f<1536) :
    correlation e f=if e=f then 1536 else if e+768=f ∨ f+768=e then 768 else 0 := by
  by_cases h : e≤f
  · exact correlation_of_le e f he hf h
  · have hh := congrArg star (correlation_of_le f e hf he (by omega))
    rw [correlation_star] at hh
    have hs : star (if f=e then (1536 : ℂ) else if f+768=e ∨ e+768=f then 768 else 0)=
        (if f=e then (1536 : ℂ) else if f+768=e ∨ e+768=f then 768 else 0) := by
      split_ifs <;> simp only [star_ofNat,star_zero]
    rw [hs] at hh
    simpa only [eq_comm,or_comm] using hh

def power (i : LocalCoord) : ℕ := i.2.val+if i.1 then 768 else 0

theorem power_lt (i : LocalCoord) : power i<1536 := by
  have h:=i.2.isLt
  rcases i with ⟨b,j⟩
  cases b <;> dsimp [power] <;> omega

noncomputable def evaluationMatrix : Matrix (Bool × Fin 768) LocalCoord ℂ :=
  fun p i => point p.1 p.2^(power i)

noncomputable def coefficientMetric : Matrix LocalCoord LocalCoord ℝ :=
  CoefficientGram013.metric.submatrix primary primary

theorem coefficientMetric_apply (i j : LocalCoord) :
    coefficientMetric i j=if i.2=j.2 then (if i.1=j.1 then 1 else 1/2) else 0 := by
  simp [coefficientMetric,CoefficientGram013.metric,primary]

theorem parseval_entry (i j : LocalCoord) :
    (evaluationMatrixᴴ*evaluationMatrix) i j=1536*(coefficientMetric i j : ℂ) := by
  rw [Matrix.mul_apply]
  change correlation (power i) (power j)=_
  rw [correlation_formula _ _ (power_lt i) (power_lt j),coefficientMetric_apply]
  rcases i with ⟨b,i⟩
  rcases j with ⟨c,j⟩
  have hi:=i.isLt
  have hj:=j.isLt
  cases b <;> cases c
  all_goals simp only [power,Bool.false_eq_true,Bool.true_eq_false,ite_true,ite_false,Nat.add_zero]
  all_goals by_cases hij : i=j
  all_goals try subst j
  all_goals split_ifs
  all_goals solve | norm_num | omega

theorem parseval_matrix : evaluationMatrixᴴ*evaluationMatrix=
    (1536 : ℂ) • coefficientMetric.map (Complex.ofRealHom) := by
  ext i j
  exact parseval_entry i j

theorem coefficientMetric_posDef : coefficientMetric.PosDef := by
  apply CoefficientGram013.metric_posDef.submatrix
  intro i j equal
  have same : (Sum.inl i : LocalCoord ⊕ LocalCoord)=Sum.inl j := grouping.injective equal
  exact Sum.inl.inj same

#print axioms correlation_diff
#print axioms correlation_star
#print axioms correlation_of_le
#print axioms correlation_formula
#print axioms power_lt
#print axioms coefficientMetric_apply
#print axioms parseval_entry
#print axioms parseval_matrix
#print axioms coefficientMetric_posDef
end FT1536.S05.Parseval014
