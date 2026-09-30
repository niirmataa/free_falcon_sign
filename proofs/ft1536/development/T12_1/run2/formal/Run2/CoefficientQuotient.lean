import FT1536.Relation
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.Tactic.ComputeDegree

-- Kernel checking the fixed degree-1536 polynomial needs the same recursion
-- allowance as PolynomialReference; memory/thread/wall limits are unchanged.
set_option maxRecDepth 32768

namespace FT1536.Run2.CoefficientQuotient
open Polynomial Finset

abbrev Coeff (R : Type*) := Fin 768 → R×R
noncomputable def phi (R : Type*) [CommRing R] : Polynomial R := X^1536-X^768+1

theorem phi_monic (R : Type*) [CommRing R] [Nontrivial R] : (phi R).Monic := by
  unfold phi
  monicity <;> norm_num

theorem phi_degree (R : Type*) [CommRing R] [Nontrivial R] : (phi R).degree=1536 := by
  unfold phi
  compute_degree <;> norm_num

abbrev Q (R : Type*) [CommRing R] := AdjoinRoot (phi R)

noncomputable def polynomial {R : Type*} [CommRing R] (v : Coeff R) : Polynomial R :=
  ∑ i, (C (v i).1*X^i.val+C (v i).2*X^(i.val+768))

def coefficients {R : Type*} [CommRing R] (p : Polynomial R) : Coeff R :=
  fun i => (p.coeff i.val, p.coeff (i.val+768))

theorem coefficient_low {R : Type*} [CommRing R] (v : Coeff R) (i : Fin 768) :
    (polynomial v).coeff i.val=(v i).1 := by
  rw [polynomial, finsetSum_coeff]
  have he (j : Fin 768) :
      (C (v j).1*X^j.val+C (v j).2*X^(j.val+768)).coeff i.val =
        if j=i then (v j).1 else 0 := by
    by_cases hj : j=i
    · subst j
      simp [coeff_add, coeff_C_mul, coeff_X_pow]
    · have hji : i.val≠j.val := fun h => hj (Fin.ext h.symm)
      have hhi : i.val≠j.val+768 := by have hi:=i.isLt; omega
      simp [coeff_add, coeff_C_mul, coeff_X_pow, hj, hji, hhi]
  simp_rw [he]
  simp

theorem coefficient_high {R : Type*} [CommRing R] (v : Coeff R) (i : Fin 768) :
    (polynomial v).coeff (i.val+768)=(v i).2 := by
  rw [polynomial, finsetSum_coeff]
  have he (j : Fin 768) :
      (C (v j).1*X^j.val+C (v j).2*X^(j.val+768)).coeff (i.val+768) =
        if j=i then (v j).2 else 0 := by
    have hlo : i.val+768≠j.val := by have hj:=j.isLt; omega
    by_cases hj : j=i
    · subst j
      simp [coeff_add, coeff_C_mul, coeff_X_pow]
    · have hhi : i.val≠j.val := fun h => hj (Fin.ext h.symm)
      simp [coeff_add, coeff_C_mul, coeff_X_pow, hj, hlo, hhi]
  simp_rw [he]
  simp

theorem coefficient_outside {R : Type*} [CommRing R] (v : Coeff R) (n : ℕ) (hn : 1536≤n) :
    (polynomial v).coeff n=0 := by
  rw [polynomial, finsetSum_coeff]
  apply sum_eq_zero
  intro i _
  have h0 : n≠i.val := by have hi:=i.isLt; omega
  have h1 : n≠i.val+768 := by have hi:=i.isLt; omega
  simp [coeff_add, coeff_C_mul, coeff_X_pow, h0, h1]

theorem polynomial_degree {R : Type*} [CommRing R] (v : Coeff R) :
    (polynomial v).degree < 1536 := by
  apply (degree_lt_iff_coeff_zero _ 1536).2
  intro n hn
  exact coefficient_outside v n hn

theorem coefficients_polynomial {R : Type*} [CommRing R] (v : Coeff R) :
    coefficients (polynomial v)=v := by
  funext i
  exact Prod.ext (coefficient_low v i) (coefficient_high v i)

theorem polynomial_coefficients {R : Type*} [CommRing R] (p : Polynomial R)
    (hp : p.degree<1536) : polynomial (coefficients p)=p := by
  apply Polynomial.ext
  intro n
  by_cases h0 : n<768
  · have hh := coefficient_low (coefficients p) ⟨n,h0⟩
    rw [hh]
    rfl
  · by_cases h1 : n<1536
    · have he : n-768+768=n := by omega
      have hh := coefficient_high (coefficients p) ⟨n-768,by omega⟩
      simpa only [coefficients, he] using hh
    · rw [coefficient_outside _ n (by omega)]
      exact ((degree_lt_iff_coeff_zero p 1536).1 hp n (by omega)).symm

noncomputable def toQuot {R : Type*} [CommRing R] (v : Coeff R) : Q R :=
  AdjoinRoot.mk (phi R) (polynomial v)

noncomputable def fromQuot {R : Type*} [CommRing R] [Nontrivial R] (x : Q R) : Coeff R :=
  coefficients (AdjoinRoot.modByMonicHom (phi_monic R) x)

theorem from_to {R : Type*} [CommRing R] [Nontrivial R] (v : Coeff R) :
    fromQuot (toQuot v)=v := by
  unfold fromQuot toQuot
  rw [AdjoinRoot.modByMonicHom_mk]
  have hd : (polynomial v).degree < (phi R).degree := by
    rw [phi_degree]
    exact polynomial_degree v
  rw [(modByMonic_eq_self_iff (phi_monic R)).2 hd, coefficients_polynomial]

theorem to_from {R : Type*} [CommRing R] [Nontrivial R] (x : Q R) :
    toQuot (fromQuot x)=x := by
  obtain ⟨p,rfl⟩ := AdjoinRoot.mk_surjective x
  unfold fromQuot toQuot
  rw [AdjoinRoot.modByMonicHom_mk]
  have hd : (p %ₘ phi R).degree < 1536 := by
    rw [← phi_degree R]
    exact degree_modByMonic_lt p (phi_monic R)
  rw [polynomial_coefficients _ hd]
  exact AdjoinRoot.mk_leftInverse (phi_monic R) (AdjoinRoot.mk (phi R) p)

noncomputable def equiv (R : Type*) [CommRing R] [Nontrivial R] : Coeff R ≃ Q R where
  toFun := toQuot
  invFun := fromQuot
  left_inv := from_to
  right_inv := to_from

theorem toQuot_injective (R : Type*) [CommRing R] [Nontrivial R] :
    Function.Injective (toQuot (R:=R)) := (equiv R).injective

end FT1536.Run2.CoefficientQuotient
