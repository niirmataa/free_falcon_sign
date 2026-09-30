import FT1536.Relation
import Mathlib.Tactic.ComputeDegree
import Mathlib.Algebra.Polynomial.RingDivision

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Run2.PolynomialReference
open Polynomial FT1536.Relation
abbrev F := ZMod 18433
instance : Fact ((1 : ℕ)<18433) := ⟨by decide⟩

theorem modulus_monic : (modulus : Polynomial F).Monic := by
  unfold modulus
  monicity <;> norm_num

theorem modulus_degree : (modulus : Polynomial F).degree=1536 := by
  unfold modulus
  compute_degree <;> norm_num

theorem low_remainder (i : ℕ) (hi : i<1536) : (X^i : Polynomial F)%ₘmodulus=X^i := by
  apply (modByMonic_eq_self_iff modulus_monic).2
  rw [degree_X_pow,modulus_degree]
  exact_mod_cast hi

theorem first_remainder (i : ℕ) (hi : i<768) :
    (X^(i+1536) : Polynomial F)%ₘmodulus=X^(i+768)-X^i := by
  have hd : modulus ∣ (X^(i+1536) : Polynomial F)-(X^(i+768)-X^i) := by
    refine ⟨X^i,?_⟩
    unfold modulus
    simp only [pow_add]
    ring
  rw [modByMonic_eq_of_dvd_sub modulus_monic hd]
  apply (modByMonic_eq_self_iff modulus_monic).2
  apply (degree_sub_le _ _).trans_lt
  rw [modulus_degree]
  apply max_lt
  · rw [degree_X_pow]; exact_mod_cast (show i+768<1536 by omega)
  · rw [degree_X_pow]; exact_mod_cast (show i<1536 by omega)

theorem second_remainder (i : ℕ) (hi : i<768) :
    (X^(i+2304) : Polynomial F)%ₘmodulus= -X^i := by
  have hp2 := pow_mul (X : Polynomial F) 768 2
  have hp3 := pow_mul (X : Polynomial F) 768 3
  norm_num only [Nat.reduceMul] at hp2 hp3
  have hd : modulus ∣ (X^(i+2304) : Polynomial F)-(-X^i) := by
    refine ⟨X^(i+768)+X^i,?_⟩
    unfold modulus
    simp only [pow_add,hp2,hp3]
    ring
  rw [modByMonic_eq_of_dvd_sub modulus_monic hd]
  apply (modByMonic_eq_self_iff modulus_monic).2
  rw [degree_neg,degree_X_pow,modulus_degree]
  exact_mod_cast (show i<1536 by omega)

/- Only three cases and at most two coefficient writes per monomial. -/
def remainderTerms (k : Fin 3072) : List (Fin 1536 × F) :=
  if h : k.val<1536 then [(⟨k.val,h⟩,1)]
  else if h' : k.val<2304 then
    [(⟨k.val-768,by omega⟩,1),(⟨k.val-1536,by omega⟩,-1)]
  else [(⟨k.val-2304,by omega⟩,-1)]

noncomputable def termsPoly (xs : List (Fin 1536 × F)) : Polynomial F :=
  (xs.map (fun z => C z.2 * X^z.1.val)).sum

theorem remainderTerms_correct (k : Fin 3072) :
    termsPoly (remainderTerms k)=(X^k.val : Polynomial F)%ₘmodulus := by
  unfold remainderTerms
  split
  next h => simp [termsPoly,low_remainder k.val h]
  next h =>
    split
    next h' =>
      have hi : k.val-1536<768 := by omega
      have hk : k.val=(k.val-1536)+1536 := by omega
      have hr := first_remainder (k.val-1536) hi
      rw [←hk] at hr
      rw [hr]
      have he : k.val-768=k.val-1536+768 := by omega
      simp [termsPoly,he,sub_eq_add_neg]
    next h' =>
      have hi : k.val-2304<768 := by have hn:=k.isLt; omega
      have hk : k.val=(k.val-2304)+2304 := by omega
      have hr := second_remainder (k.val-2304) hi
      rw [←hk] at hr
      rw [hr]
      simp [termsPoly]

theorem remainder_writes_at_most_two (k : Fin 3072) : (remainderTerms k).length≤2 := by
  unfold remainderTerms
  split
  · simp
  · split <;> simp

abbrev TermIndex := Fin 768 × Bool
/- Keep the executable finite enumeration opaque to kernel unification;
otherwise elaboration tries to expand millions of concrete list elements.
Its complete enumeration is still the ordinary product Fintype. -/
opaque termFinite : Fintype TermIndex := instFintypeProd (Fin 768) Bool
attribute [instance] termFinite
def exponent (i : TermIndex) : ℕ := i.1.val+if i.2 then 768 else 0
def coefficient (a : Rq) (i : TermIndex) : F := if i.2 then (a i.1).2 else (a i.1).1

theorem exponent_lt (i : TermIndex) : exponent i<1536 := by
  unfold exponent
  have hh := i.1.isLt
  split <;> omega

def productExponent (i j : TermIndex) : Fin 3072 :=
  ⟨exponent i+exponent j,by have hi:=exponent_lt i; have hj:=exponent_lt j; omega⟩

def coefficientOfTerms (xs : List (Fin 1536 × F)) (r : Fin 1536) : F :=
  (xs.map (fun t => if t.1=r then t.2 else 0)).sum

/- A concrete, computable coefficient loop; it contains no Polynomial or
noncomputable normalizer operation. Each (i,j) has ≤2 reduced monomials. -/
def multiplyCoefficient (a b : Rq) (r : Fin 1536) : F :=
  ∑ i : TermIndex, ∑ j : TermIndex,
    coefficient a i*coefficient b j*coefficientOfTerms (remainderTerms (productExponent i j)) r

def multiply (a b : Rq) : Rq := fun i =>
  (multiplyCoefficient a b ⟨i.val,by have hh:=i.isLt; omega⟩,
   multiplyCoefficient a b ⟨i.val+768,by have hh:=i.isLt; omega⟩)

theorem coefficientOfTerms_correct (xs : List (Fin 1536 × F)) (r : Fin 1536) :
    (termsPoly xs).coeff r.val=coefficientOfTerms xs r := by
  induction xs with
  | nil => simp [termsPoly,coefficientOfTerms]
  | cons x xs ih =>
    simp only [termsPoly,coefficientOfTerms,List.map_cons,List.sum_cons,coeff_add,coeff_C_mul,coeff_X_pow] at *
    rw [ih]
    by_cases hx : x.1=r
    · simp [hx]
    · have hn : x.1.val≠r.val := fun hh => hx (Fin.ext hh)
      simp [hx,Ne.symm hn]

theorem poly_as_terms (a : Rq) : poly a =
    ∑ i : TermIndex, C (coefficient a i)*X^(exponent i) := by
  have hi : termFinite=instFintypeProd (Fin 768) Bool := Subsingleton.elim _ _
  rw [hi]
  simp [poly,Fintype.sum_prod_type,coefficient,exponent,add_comm]

theorem remainder_sum {I : Type} (s : Finset I) (p : I → Polynomial F) :
    (∑ i∈s,p i)%ₘmodulus=∑ i∈s,p i%ₘmodulus := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih => simp only [Finset.sum_insert ha,add_modByMonic,ih]

theorem product_remainder_terms (a b : Rq) :
    (poly a*poly b)%ₘmodulus =
      ∑ i : TermIndex, ∑ j : TermIndex,
        C (coefficient a i*coefficient b j)*termsPoly (remainderTerms (productExponent i j)) := by
  rw [poly_as_terms,poly_as_terms,Finset.sum_mul]
  simp_rw [Finset.mul_sum,remainder_sum]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  have hm : C (coefficient a i)*X^(exponent i)*(C (coefficient b j)*X^(exponent j)) =
      C (coefficient a i*coefficient b j)*X^(exponent i+exponent j) := by
    rw [map_mul,pow_add]
    ring
  rw [hm,←smul_eq_C_mul,smul_modByMonic,smul_eq_C_mul,remainderTerms_correct]
  rfl

theorem multiplyCoefficient_correct (a b : Rq) (r : Fin 1536) :
    multiplyCoefficient a b r=((poly a*poly b)%ₘmodulus).coeff r.val := by
  rw [product_remainder_terms]
  rw [Polynomial.finsetSum_coeff]
  apply Finset.sum_congr rfl
  intro i _
  rw [Polynomial.finsetSum_coeff]
  apply Finset.sum_congr rfl
  intro j _
  rw [coeff_C_mul,coefficientOfTerms_correct]

theorem multiply_correct (a b : Rq) : multiply a b=mulRq a b := by
  funext i
  exact Prod.ext (multiplyCoefficient_correct a b _) (multiplyCoefficient_correct a b _)

theorem term_count : Fintype.card TermIndex=1536 := by
  have hi : termFinite=instFintypeProd (Fin 768) Bool := Subsingleton.elim _ _
  rw [hi]
  simp [TermIndex,Fintype.card_prod]

theorem coefficient_loop_iterations :
    (∑ _i : TermIndex, ∑ _j : TermIndex,(1 : ℕ))=1536*1536 := by
  simp [term_count]

theorem reduced_term_visits :
    (∑ i : TermIndex, ∑ j : TermIndex,(remainderTerms (productExponent i j)).length)≤2*1536*1536 := by
  calc
    _ ≤ ∑ _i : TermIndex, ∑ _j : TermIndex,(2 : ℕ) := by
      apply Finset.sum_le_sum
      intro i _
      apply Finset.sum_le_sum
      intro j _
      exact remainder_writes_at_most_two _
    _ = _ := by simp [term_count]

end FT1536.Run2.PolynomialReference
