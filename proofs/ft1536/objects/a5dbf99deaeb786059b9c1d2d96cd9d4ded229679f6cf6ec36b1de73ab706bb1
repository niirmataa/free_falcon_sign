import Run2.CoefficientQuotient

set_option maxRecDepth 32768

namespace FT1536.Run2.CoefficientQuotient
open Polynomial Finset
variable {R S : Type*} [CommRing R] [CommRing S]
instance : Fact ((1 : ℕ)<18433) := ⟨by decide⟩

theorem polynomial_zero : polynomial (0 : Coeff R)=0 := by simp [polynomial]

theorem polynomial_add (v w : Coeff R) : polynomial (v+w)=polynomial v+polynomial w := by
  unfold polynomial
  rw [← sum_add_distrib]
  apply sum_congr rfl
  intro i _
  simp only [Pi.add_apply, Prod.fst_add, Prod.snd_add, map_add]
  ring

theorem toQuot_zero : toQuot (0 : Coeff R)=0 := by simp [toQuot, polynomial_zero]

theorem toQuot_add (v w : Coeff R) : toQuot (v+w)=toQuot v+toQuot w := by
  simp only [toQuot, polynomial_add, map_add]

theorem toQuot_neg (v : Coeff R) : toQuot (-v)= -toQuot v := by
  apply eq_neg_iff_add_eq_zero.mpr
  rw [← toQuot_add, neg_add_cancel, toQuot_zero]

theorem toQuot_sub (v w : Coeff R) : toQuot (v-w)=toQuot v-toQuot w := by
  simp only [sub_eq_add_neg, toQuot_add, toQuot_neg]

def constantCoeffs (a : R) : Coeff R := fun i => if i=0 then (a,0) else (0,0)

theorem polynomial_constant (a : R) : polynomial (constantCoeffs a)=C a := by
  rw [polynomial, sum_eq_single (0 : Fin 768)]
  · simp [constantCoeffs]
  · intro i _ hi
    simp [constantCoeffs, hi]
  · simp

theorem toQuot_constant (a : R) : toQuot (constantCoeffs a)=AdjoinRoot.of (phi R) a := by
  rw [toQuot, polynomial_constant, AdjoinRoot.mk_C]

def scalarCoeffs (a : R) (v : Coeff R) : Coeff R := fun i => (a*(v i).1,a*(v i).2)

theorem polynomial_scalar (a : R) (v : Coeff R) :
    polynomial (scalarCoeffs a v)=C a*polynomial v := by
  unfold polynomial
  rw [mul_sum]
  apply sum_congr rfl
  intro i _
  simp only [scalarCoeffs, map_mul]
  ring

theorem toQuot_scalar (a : R) (v : Coeff R) :
    toQuot (scalarCoeffs a v)=AdjoinRoot.of (phi R) a*toQuot v := by
  simp only [toQuot, polynomial_scalar, map_mul, AdjoinRoot.mk_C]

theorem toQuot_nat_scalar (n : ℕ) (v : Coeff R) :
    toQuot (scalarCoeffs (n : R) v)=(n : Q R)*toQuot v := by
  simpa only [map_natCast] using toQuot_scalar (n : R) v

theorem toQuot_q_scalar (v : Coeff ℤ) :
    toQuot (scalarCoeffs (18433 : ℤ) v)=(18433 : Q ℤ)*toQuot v := by
  simpa only [Nat.cast_ofNat] using toQuot_nat_scalar 18433 v

def mapCoeffs (f : R →+* S) (v : Coeff R) : Coeff S := fun i => (f (v i).1,f (v i).2)

theorem map_shape (f : R →+* S) (n m : ℕ) :
    (X^n-X^m+1 : Polynomial R).map f=(X^n-X^m+1 : Polynomial S) := by
  simp only [Polynomial.map_add, Polynomial.map_sub, Polynomial.map_pow,
    Polynomial.map_X, Polynomial.map_one]

theorem phi_map (f : R →+* S) : (phi R).map f=phi S := map_shape f 1536 768

noncomputable def quotientMap (f : R →+* S) : Q R →+* Q S :=
  AdjoinRoot.map f (phi R) (phi S) (by simpa only [phi_map] using dvd_refl (phi S))

theorem quotientMap_toQuot (f : R →+* S) (v : Coeff R) :
    quotientMap f (toQuot v)=toQuot (mapCoeffs f v) := by
  simp [quotientMap, toQuot, polynomial, map_sum, mapCoeffs,
    AdjoinRoot.mk_C, AdjoinRoot.mk_X]

noncomputable def multiply (v w : Coeff R) : Coeff R :=
  coefficients ((polynomial v*polynomial w)%ₘphi R)

theorem toQuot_remainder [Nontrivial R] (p : Polynomial R) :
    toQuot (coefficients (p%ₘphi R))=AdjoinRoot.mk (phi R) p := by
  have hd : (p%ₘphi R).degree<1536 := by
    rw [← phi_degree R]
    exact degree_modByMonic_lt _ (phi_monic R)
  unfold toQuot
  rw [polynomial_coefficients _ hd]
  exact AdjoinRoot.mk_leftInverse (phi_monic R)
    (AdjoinRoot.mk (phi R) p)

theorem toQuot_multiply [Nontrivial R] (v w : Coeff R) :
    toQuot (multiply v w)=toQuot v*toQuot w := by
  unfold multiply
  rw [toQuot_remainder]
  simp only [toQuot, map_mul]

theorem mulRq_binding (v w : FT1536.Relation.Rq) :
    toQuot (FT1536.Relation.mulRq v w)=toQuot v*toQuot w :=
  toQuot_multiply v w

noncomputable def reduce : Q ℤ →+* Q (ZMod 18433) := quotientMap (Int.castRingHom _)

theorem reduce_binding (v : FT1536.Geometry.Vec) :
    reduce (toQuot v)=toQuot (FT1536.Relation.reduceVec v) :=
  quotientMap_toQuot _ v

theorem actual_A_binding (h : FT1536.Relation.Rq) (z : FT1536.Geometry.Vec×FT1536.Geometry.Vec) :
    toQuot (FT1536.Relation.A h z)=reduce (toQuot z.1)+toQuot h*reduce (toQuot z.2) := by
  rw [FT1536.Relation.A, toQuot_add, mulRq_binding, reduce_binding, reduce_binding]

theorem reduce_q_zero : reduce (18433 : Q ℤ)=0 := by
  have hh : reduce (18433 : Q ℤ)=AdjoinRoot.of (phi (ZMod 18433)) (18433 : ZMod 18433) := by
    simp only [map_ofNat]
  rw [hh]
  have hz : (18433 : ZMod 18433)=0 := by
    simpa only [Nat.cast_ofNat] using ZMod.natCast_self 18433
  rw [hz, map_zero]

theorem q_multiplication_injective : Function.Injective (fun x : Q ℤ => (18433 : Q ℤ)*x) := by
  intro x y hxy
  have he : toQuot (scalarCoeffs (18433 : ℤ) (fromQuot x))=
      toQuot (scalarCoeffs (18433 : ℤ) (fromQuot y)) := by
    rw [toQuot_q_scalar, toQuot_q_scalar, to_from, to_from]
    exact hxy
  have hv := toQuot_injective ℤ he
  have hw : fromQuot x=fromQuot y := by
    funext i
    have hi := congrFun hv i
    have h0 := congrArg Prod.fst hi
    have h1 := congrArg Prod.snd hi
    simp only [scalarCoeffs] at h0 h1
    apply Prod.ext <;> omega
  rw [← to_from x, ← to_from y, hw]

theorem reduce_kernel_q (x : Q ℤ) : reduce x=0 ↔ ∃ u : Q ℤ, (18433 : Q ℤ)*u=x := by
  constructor
  · intro hx
    let v := fromQuot x
    have hv : mapCoeffs (Int.castRingHom (ZMod 18433)) v=0 := by
      apply toQuot_injective (ZMod 18433)
      rw [← quotientMap_toQuot, toQuot_zero]
      change reduce (toQuot (fromQuot x))=0
      rw [to_from, hx]
    let u : Coeff ℤ := fun i => ((v i).1/18433,(v i).2/18433)
    have he : scalarCoeffs (18433 : ℤ) u=v := by
      funext i
      have hi := congrFun hv i
      have h0 : ((v i).1 : ZMod 18433)=0 := congrArg Prod.fst hi
      have h1 : ((v i).2 : ZMod 18433)=0 := congrArg Prod.snd hi
      have hd0 := (ZMod.intCast_zmod_eq_zero_iff_dvd (v i).1 18433).mp h0
      have hd1 := (ZMod.intCast_zmod_eq_zero_iff_dvd (v i).2 18433).mp h1
      apply Prod.ext
      · change 18433*((v i).1/18433)=(v i).1
        simpa only [mul_comm, Nat.cast_ofNat] using Int.ediv_mul_cancel hd0
      · change 18433*((v i).2/18433)=(v i).2
        simpa only [mul_comm, Nat.cast_ofNat] using Int.ediv_mul_cancel hd1
    refine ⟨toQuot u, ?_⟩
    rw [← toQuot_q_scalar, he]
    exact to_from x
  · rintro ⟨u,hu⟩
    rw [← hu, map_mul, reduce_q_zero, zero_mul]

end FT1536.Run2.CoefficientQuotient
