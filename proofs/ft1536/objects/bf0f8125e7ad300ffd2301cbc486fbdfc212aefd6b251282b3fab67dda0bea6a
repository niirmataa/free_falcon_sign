import Run2.QuotientOperations
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/- Integer recovery in the EXISTING coefficient quotient. This is an internal
   algebraic obligation: the source sampler, conversion gates and final NTT
   check must supply its premises. It is not a successful-KeyGen theorem. -/
set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenIntegerLift
open Polynomial Finset FT1536.Geometry FT1536.Run2.CoefficientQuotient

noncomputable def block (p : Polynomial ℤ) (k : ℕ) : Polynomial ℤ :=
  ∑ i : Fin 768, C (p.coeff (i.val+768*k))*X^i.val

theorem block_coeff (p : Polynomial ℤ) (k n : ℕ) :
    (block p k).coeff n = if n<768 then p.coeff (n+768*k) else 0 := by
  classical
  simp only [block,finsetSum_coeff,coeff_C_mul_X_pow]
  by_cases hn : n<768
  · rw [ite_eq_left hn]
    rw [Finset.sum_eq_single (⟨n,hn⟩ : Fin 768)]
    · simp
    · intro i _ hi
      have hne : i.val≠n := fun h => hi (Fin.ext h)
      simp [Ne.symm hne]
    · simp
  · rw [ite_eq_right hn]
    apply Finset.sum_eq_zero
    intro i _
    have hne : i.val≠n := by have := i.isLt; omega
    simp [Ne.symm hne]

theorem split_four (p : Polynomial ℤ) (hp : p.degree<3072) :
    p=block p 0+X^768*block p 1+X^1536*block p 2+X^2304*block p 3 := by
  apply Polynomial.ext
  intro n
  simp only [coeff_add,coeff_X_pow_mul',block_coeff]
  by_cases h0 : n<768
  · simp [h0,show ¬768≤n by omega,show ¬1536≤n by omega,show ¬2304≤n by omega]
  · by_cases h1 : n<1536
    · simp [h0,show 768≤n by omega,show n-768<768 by omega,
        show ¬1536≤n by omega,show ¬2304≤n by omega,
        show n-768+768*1=n by omega]
    · by_cases h2 : n<2304
      · simp [h0,show 768≤n by omega,show ¬n-768<768 by omega,
          show 1536≤n by omega,show n-1536<768 by omega,
          show ¬2304≤n by omega,show n-1536+768*2=n by omega]
      · by_cases h3 : n<3072
        · simp [h0,show 768≤n by omega,show ¬n-768<768 by omega,
            show 1536≤n by omega,show ¬n-1536<768 by omega,
            show 2304≤n by omega,show n-2304<768 by omega,
            show n-2304+768*3=n by omega]
        · have hz := (degree_lt_iff_coeff_zero p 3072).1 hp n (by omega)
          simp [h0,hz,show 768≤n by omega,show ¬n-768<768 by omega,
            show 1536≤n by omega,show ¬n-1536<768 by omega,
            show 2304≤n by omega,show ¬n-2304<768 by omega]

def fold (p : Polynomial ℤ) : Vec := fun i =>
  (p.coeff i.val-p.coeff (i.val+1536)-p.coeff (i.val+2304),
   p.coeff (i.val+768)+p.coeff (i.val+1536))

theorem fold_polynomial (p : Polynomial ℤ) :
    polynomial (fold p)=block p 0-block p 2-block p 3+X^768*(block p 1+block p 2) := by
  apply Polynomial.ext
  intro n
  by_cases h0 : n<768
  · rw [coefficient_low (fold p) ⟨n,h0⟩]
    simp [fold,coeff_add,coeff_sub,coeff_X_pow_mul',block_coeff,h0,show ¬768≤n by omega]
  · by_cases h1 : n<1536
    · have he : n-768+768=n := by omega
      have hc := coefficient_high (fold p) ⟨n-768,by omega⟩
      rw [he] at hc
      rw [hc]
      simp [fold,coeff_add,coeff_sub,coeff_X_pow_mul',block_coeff,h0,
        show 768≤n by omega,show n-768<768 by omega]
    · rw [coefficient_outside _ n (by omega)]
      simp [coeff_add,coeff_sub,coeff_X_pow_mul',block_coeff,h0,
        show 768≤n by omega,show ¬n-768<768 by omega]

theorem fold_remainder (p : Polynomial ℤ) (hp : p.degree<3072) :
    p%ₘphi ℤ=polynomial (fold p) := by
  apply (div_modByMonic_unique (block p 2+(X^768+1)*block p 3)
    (polynomial (fold p)) (phi_monic ℤ) ?_).2
  constructor
  · rw [fold_polynomial]
    conv_rhs => rw [split_four p hp]
    unfold phi
    have h2 : (X : Polynomial ℤ)^1536=(X^768)^2 := by rw [← pow_mul]
    have h3 : (X : Polynomial ℤ)^2304=(X^768)^3 := by rw [← pow_mul]
    rw [h2,h3]
    ring
  · rw [phi_degree]
    exact polynomial_degree _

theorem product_degree (p q : Polynomial ℤ) (hp : p.degree<1536) (hq : q.degree<1536) :
    (p*q).degree<3072 := by
  have h0 : p.degree+q.degree≤(1536 : WithBot ℕ)+q.degree := add_le_add hp.le (le_refl _)
  have h1 : (1536 : WithBot ℕ)+q.degree<(1536 : WithBot ℕ)+1536 :=
    WithBot.add_lt_add_left (by decide) hq
  have h2 : (1536 : WithBot ℕ)+1536=3072 := by norm_num
  exact (degree_mul_le p q).trans_lt (h0.trans_lt (h1.trans_eq h2))

theorem multiply_fold (v w : Vec) : multiply v w=fold (polynomial v*polynomial w) := by
  have hd := product_degree (polynomial v) (polynomial w) (polynomial_degree v) (polynomial_degree w)
  unfold multiply
  rw [fold_remainder _ hd,coefficients_polynomial]

def Bound (v : Vec) (B : ℤ) : Prop := ∀ i, |(v i).1|≤B ∧ |(v i).2|≤B

theorem polynomial_bound (v : Vec) (B : ℤ) (hB : 0≤B) (hv : Bound v B) (n : ℕ) :
    |(polynomial v).coeff n|≤B := by
  by_cases h0 : n<768
  · rw [coefficient_low v ⟨n,h0⟩]
    exact (hv ⟨n,h0⟩).1
  · by_cases h1 : n<1536
    · have hc := coefficient_high v ⟨n-768,by omega⟩
      have he : n-768+768=n := by omega
      rw [he] at hc
      rw [hc]
      exact (hv _).2
    · rw [coefficient_outside v n (by omega),abs_zero]
      exact hB

theorem product_coeff_bound (v w : Vec) (hv : Bound v 1) (hw : Bound w 2047)
    (n : ℕ) (hn : n<3072) : |(polynomial v*polynomial w).coeff n|≤6288384 := by
  rw [coeff_mul,Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk]
  have hs : (∑ i ∈ range (n+1), |(polynomial v).coeff i*(polynomial w).coeff (n-i)|)
      ≤ ∑ _i ∈ range (n+1), (2047 : ℤ) := by
    apply Finset.sum_le_sum
    intro i _
    rw [abs_mul]
    have h := mul_le_mul (polynomial_bound v 1 (by decide) hv i)
      (polynomial_bound w 2047 (by decide) hw (n-i)) (abs_nonneg _) (by decide : (0 : ℤ)≤1)
    simpa only [one_mul] using h
  have ht := (Finset.abs_sum_le_sum_abs _ _).trans hs
  simp only [Finset.sum_const,Finset.card_range,nsmul_eq_mul] at ht
  have hc : (n+1 : ℤ)≤3072 := by omega
  change |∑ i ∈ range (n+1), (polynomial v).coeff i*(polynomial w).coeff (n-i)|≤6288384
  push_cast at ht
  nlinarith

theorem sub3_bound (a b c A B C : ℤ) (ha : |a|≤A) (hb : |b|≤B) (hc : |c|≤C) :
    |a-b-c|≤A+B+C := by
  have ha' := abs_le.mp ha
  have hb' := abs_le.mp hb
  have hc' := abs_le.mp hc
  apply abs_le.mpr
  omega

theorem add2_bound (a b A B : ℤ) (ha : |a|≤A) (hb : |b|≤B) : |a+b|≤A+B := by
  have ha' := abs_le.mp ha
  have hb' := abs_le.mp hb
  apply abs_le.mpr
  omega

theorem multiply_bound (v w : Vec) (hv : Bound v 1) (hw : Bound w 2047) :
    Bound (multiply v w) 18865152 := by
  rw [multiply_fold]
  intro i
  have h0 := product_coeff_bound v w hv hw i.val (by have := i.isLt; omega)
  have h1 := product_coeff_bound v w hv hw (i.val+768) (by have := i.isLt; omega)
  have h2 := product_coeff_bound v w hv hw (i.val+1536) (by have := i.isLt; omega)
  have h3 := product_coeff_bound v w hv hw (i.val+2304) (by have := i.isLt; omega)
  constructor
  · exact sub3_bound _ _ _ 6288384 6288384 6288384 h0 h2 h3
  · exact (add2_bound _ _ 6288384 6288384 h1 h2).trans (by decide)

noncomputable def residual (f g bigF bigG : Vec) : Vec :=
  multiply f bigG-multiply g bigF-constantCoeffs (18433 : ℤ)

theorem residual_bound (f g bigF bigG : Vec)
    (hf : Bound f 1) (hg : Bound g 1) (hF : Bound bigF 2047) (hG : Bound bigG 2047) :
    Bound (residual f g bigF bigG) 37748737 := by
  have ha := multiply_bound f bigG hf hG
  have hb := multiply_bound g bigF hg hF
  intro i
  have hc : |(constantCoeffs (18433 : ℤ) i).1|≤18433 ∧
      |(constantCoeffs (18433 : ℤ) i).2|≤18433 := by
    by_cases hi : i=0 <;> simp [constantCoeffs,hi]
  constructor
  · change |((multiply f bigG) i).1-((multiply g bigF) i).1-(constantCoeffs (18433 : ℤ) i).1|≤_
    exact sub3_bound _ _ _ 18865152 18865152 18433 (ha i).1 (hb i).1 hc.1
  · change |((multiply f bigG) i).2-((multiply g bigF) i).2-(constantCoeffs (18433 : ℤ) i).2|≤_
    exact sub3_bound _ _ _ 18865152 18865152 18433 (ha i).2 (hb i).2 hc.2

theorem small_mod_zero (z : ℤ) (hz : |z|≤37748737) (hm : (z : ZMod 2147355649)=0) : z=0 := by
  have hd : (2147355649 : ℤ)∣z := (ZMod.intCast_zmod_eq_zero_iff_dvd z 2147355649).mp hm
  exact Int.eq_zero_of_abs_lt_dvd hd (by omega)

theorem exact_ntru_of_modular_check (f g bigF bigG : Vec)
    (hf : Bound f 1) (hg : Bound g 1) (hF : Bound bigF 2047) (hG : Bound bigG 2047)
    (check : mapCoeffs (Int.castRingHom (ZMod 2147355649)) (residual f g bigF bigG)=0) :
    multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ) := by
  have hb := residual_bound f g bigF bigG hf hg hF hG
  have hz : residual f g bigF bigG=0 := by
    funext i
    have hi := congrFun check i
    apply Prod.ext
    · exact small_mod_zero _ (hb i).1 (congrArg Prod.fst hi)
    · exact small_mod_zero _ (hb i).2 (congrArg Prod.snd hi)
  exact sub_eq_zero.mp hz

end FT1536.Source3.KeygenIntegerLift
