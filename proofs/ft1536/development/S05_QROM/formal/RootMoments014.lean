import Mathlib.RingTheory.RootsOfUnity.Complex
import Mathlib.Algebra.Ring.GeomSum
import Mathlib.Tactic

/- Exact canonical roots, preparatory to the FT1536 Parseval instance.
   No FFT error model or sampling assertion is an input. -/
namespace FT1536.S05.RootMoments014
open Complex Finset

noncomputable def tau : ℂ := Complex.exp (2*Real.pi*Complex.I/4608)
noncomputable def beta : ℂ := tau^768

theorem tau_primitive : IsPrimitiveRoot tau 4608 :=
  Complex.isPrimitiveRoot_exp 4608 (by decide)

theorem beta_primitive : IsPrimitiveRoot beta 6 :=
  tau_primitive.pow (by decide) (by decide)

theorem beta_cube : beta^3= -1 :=
  (beta_primitive.pow (by decide) (show 6=3*2 by decide)).eq_neg_one_of_two_right

theorem beta_ne_neg_one : beta≠ -1 := by
  intro equal
  have h := beta_primitive.pow_ne_one_of_pos_of_lt (show 2≠0 by decide) (show 2<6 by decide)
  apply h
  rw [equal]
  norm_num

theorem beta_polynomial : beta^2-beta+1=0 := by
  have product : (beta+1)*(beta^2-beta+1)=0 := by
    calc
      _ = beta^3+1 := by ring
      _ = 0 := by rw [beta_cube]; ring
  have first : beta+1≠0 := by
    intro h
    apply beta_ne_neg_one
    exact eq_neg_of_add_eq_zero_left h
  exact (mul_eq_zero.mp product).resolve_left first

theorem beta_fifth : beta^5=1-beta := by
  have square : beta^2=beta-1 := by
    calc
      _ = (beta^2-beta+1)+(beta-1) := by ring
      _ = _ := by rw [beta_polynomial,zero_add]
  calc
    _ = beta^2*beta^3 := by ring
    _ = _ := by rw [square,beta_cube]; ring

theorem tau_unit : star tau*tau=1 := by
  have hn : Complex.normSq tau=1 := by
    rw [Complex.normSq_eq_norm_sq,tau_primitive.norm'_eq_one (by decide)]
    norm_num
  simp only [star_def,mul_comm,Complex.mul_conj,hn,Complex.ofReal_one]

def exponent (b : Bool) (j : Fin 768) : ℕ := (if b then 5 else 1)+6*j.val
noncomputable def point (b : Bool) (j : Fin 768) : ℂ := tau^(exponent b j)

theorem point_unit (b : Bool) (j : Fin 768) : star (point b j)*point b j=1 := by
  rw [point,star_pow,← mul_pow,tau_unit,one_pow]

theorem point_distinct : Function.Injective (fun p : Bool × Fin 768 => point p.1 p.2) := by
  intro p q equal
  have small (b : Bool) (j : Fin 768) : exponent b j<4608 := by
    have hj:=j.isLt
    cases b <;> dsimp [exponent] <;> omega
  have ex := tau_primitive.pow_inj (small p.1 p.2) (small q.1 q.2) equal
  rcases p with ⟨b,j⟩
  rcases q with ⟨c,k⟩
  cases b <;> cases c <;> simp only [exponent,Bool.false_eq_true,ite_false,ite_true] at ex
  all_goals first | exfalso; omega | congr 1; apply Fin.ext; omega

theorem geometric_zero (k : ℕ) (hk : ¬768∣k) :
    (∑ j : Fin 768, (tau^(6*k))^j.val)=0 := by
  have neq : tau^(6*k)≠1 := by
    intro equal
    obtain ⟨d,hd⟩ := (tau_primitive.pow_eq_one_iff_dvd (6*k)).mp equal
    exact hk ⟨d,by omega⟩
  have power : (tau^(6*k))^768=1 := by
    rw [← pow_mul,show 6*k*768=4608*k by omega,pow_mul,tau_primitive.pow_eq_one,one_pow]
  have geom := mul_neg_geom_sum (tau^(6*k)) 768
  rw [power,sub_self] at geom
  have zero := (mul_eq_zero.mp geom).resolve_left (sub_ne_zero.mpr neq.symm)
  rw [Fin.sum_univ_eq_sum_range]
  exact zero

theorem point_power (b : Bool) (j : Fin 768) (k : ℕ) :
    point b j^k=tau^((if b then 5 else 1)*k)*(tau^(6*k))^j.val := by
  rw [point,← pow_mul,show exponent b j*k=(if b then 5 else 1)*k+(6*k)*j.val by unfold exponent; ring,
    pow_add]
  simp only [pow_mul]

noncomputable def moment (k : ℕ) : ℂ := ∑ p : Bool × Fin 768, point p.1 p.2^k

theorem moment_factor (k : ℕ) :
    moment k=(tau^k+tau^(5*k))*(∑ j : Fin 768, (tau^(6*k))^j.val) := by
  unfold moment
  simp only [Fintype.sum_prod_type,Fintype.sum_bool,point_power,Bool.false_eq_true,ite_true,ite_false,one_mul]
  rw [← mul_sum,← mul_sum]
  ring

theorem moment_zero : moment 0=1536 := by
  simp only [moment,pow_zero,sum_const,card_univ,Fintype.card_prod,Fintype.card_bool,Fintype.card_fin,nsmul_eq_mul]
  norm_num

theorem moment_middle : moment 768=768 := by
  rw [moment_factor]
  have hp : tau^(6*768)=1 := tau_primitive.pow_eq_one
  simp only [hp,one_pow,sum_const,card_univ,Fintype.card_fin,nsmul_eq_mul,mul_one]
  have h5 : tau^(5*768)=beta^5 := by rw [beta,← pow_mul]
  rw [h5]
  change (beta+beta^5)*768=768
  rw [beta_fifth]
  ring

theorem moment_small (k : ℕ) (hk : k<1536) :
    moment k=if k=0 then 1536 else if k=768 then 768 else 0 := by
  by_cases zero : k=0
  · subst k
    simpa only [ite_true] using moment_zero
  by_cases mid : k=768
  · subst k
    simpa only [show (768 : ℕ)≠0 by decide,ite_false,ite_true] using moment_middle
  have notdiv : ¬768∣k := by rintro ⟨d,hd⟩; omega
  rw [ite_eq_right zero,ite_eq_right mid,moment_factor,geometric_zero k notdiv,mul_zero]

theorem point_middle (b : Bool) (j : Fin 768) :
    point b j^768=if b then beta^5 else beta := by
  rw [point_power]
  have hp : tau^(6*768)=1 := tau_primitive.pow_eq_one
  rw [hp,one_pow,mul_one]
  cases b
  · simp only [Bool.false_eq_true,ite_false,one_mul,beta]
  · simp only [ite_true,beta]
    rw [← pow_mul]

theorem point_polynomial (b : Bool) (j : Fin 768) :
    point b j^1536-point b j^768+1=0 := by
  rw [show 1536=768*2 by decide,pow_mul,point_middle]
  cases b
  · exact beta_polynomial
  · simp only [ite_true,beta_fifth]
    calc
      _ = beta^2-beta+1 := by ring
      _ = 0 := beta_polynomial

#print axioms tau_primitive
#print axioms beta_primitive
#print axioms beta_cube
#print axioms beta_ne_neg_one
#print axioms beta_polynomial
#print axioms beta_fifth
#print axioms tau_unit
#print axioms point_unit
#print axioms point_distinct
#print axioms geometric_zero
#print axioms point_power
#print axioms moment_factor
#print axioms moment_zero
#print axioms moment_middle
#print axioms moment_small
#print axioms point_middle
#print axioms point_polynomial
end FT1536.S05.RootMoments014
