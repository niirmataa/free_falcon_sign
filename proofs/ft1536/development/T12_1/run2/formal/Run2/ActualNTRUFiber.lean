import Run2.NTRUBasis
import Run2.QuotientOperations

namespace FT1536.Run2.ActualNTRUFiber
open FT1536.Geometry FT1536.Relation
open CoefficientQuotient

/- These are the usual exact NTRU/public/invertibility equations, expressed
   in the same coefficient representation as the existing signer. -/
noncomputable def key (f g bigF bigG : Vec) (h fInv : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433)) :
    NTRUBasis.Key CoefficientQuotient.reduce (18433 : CoefficientQuotient.Q ℤ) where
  f := toQuot f
  g := toQuot g
  bigF := toQuot bigF
  bigG := toQuot bigG
  h := toQuot h
  fInv := toQuot fInv
  ntru := by
    rw [← toQuot_multiply, ← toQuot_multiply, ← toQuot_sub, ntru, toQuot_constant]
    simp only [map_ofNat]
  public_eq := by
    rw [reduce_binding, reduce_binding, ← mulRq_binding, public_eq]
  inverse_eq := by
    rw [reduce_binding, ← mulRq_binding, inverse_eq, toQuot_constant, map_one]

noncomputable def pairEquiv : (Vec×Vec) ≃
    (CoefficientQuotient.Q ℤ×CoefficientQuotient.Q ℤ) :=
  (CoefficientQuotient.equiv ℤ).prodCongr (CoefficientQuotient.equiv ℤ)

theorem pairEquiv_add (u v : Vec×Vec) : pairEquiv (u+v)=pairEquiv u+pairEquiv v := by
  apply Prod.ext <;> exact toQuot_add _ _

noncomputable def coefficientBasis (f g bigF bigG : Vec) (u : Vec×Vec) : Vec×Vec :=
  (multiply g u.1+multiply bigG u.2, -multiply f u.1-multiply bigF u.2)

theorem coefficient_basis_binding (f g bigF bigG : Vec) (h fInv : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433)) (u : Vec×Vec) :
    pairEquiv (coefficientBasis f g bigF bigG u)=
      NTRUBasis.basis (key f g bigF bigG h fInv ntru public_eq inverse_eq) (pairEquiv u) := by
  apply Prod.ext
  · change toQuot (multiply g u.1+multiply bigG u.2)=toQuot g*toQuot u.1+toQuot bigG*toQuot u.2
    rw [toQuot_add, toQuot_multiply, toQuot_multiply]
  · change toQuot (-multiply f u.1-multiply bigF u.2)= -toQuot f*toQuot u.1-toQuot bigF*toQuot u.2
    rw [toQuot_sub, toQuot_neg, toQuot_multiply, toQuot_multiply]
    ring

noncomputable def fiberEquiv (h c : Rq) :
    {z : Vec×Vec // A h z=c} ≃
      {z : CoefficientQuotient.Q ℤ×CoefficientQuotient.Q ℤ //
        NTRUBasis.graph CoefficientQuotient.reduce (toQuot h) z=toQuot c} where
  toFun z := ⟨(toQuot z.val.1,toQuot z.val.2), by
    change CoefficientQuotient.reduce (toQuot z.val.1)+
      toQuot h*CoefficientQuotient.reduce (toQuot z.val.2)=toQuot c
    rw [← actual_A_binding, z.property]⟩
  invFun z := ⟨(fromQuot z.val.1,fromQuot z.val.2), by
    apply toQuot_injective (ZMod 18433)
    rw [actual_A_binding, to_from, to_from]
    exact z.property⟩
  left_inv z := by
    apply Subtype.ext
    apply Prod.ext <;> exact from_to _
  right_inv z := by
    apply Subtype.ext
    apply Prod.ext <;> exact to_from _

theorem centered_lift (h c : Rq) :
    NTRUBasis.graph CoefficientQuotient.reduce (toQuot h)
      (toQuot (centerRq c),0)=toQuot c := by
  simp only [NTRUBasis.graph, map_zero, mul_zero, add_zero, reduce_binding, reduce_center]

/- An actual equivalence onto the entire fiber of Relation.A, including every
   target c. No determinant/index assertion or surjectivity is assumed. -/
noncomputable def coordinates (f g bigF bigG : Vec) (h fInv c : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433)) :
    (Vec×Vec) ≃ {z : Vec×Vec // A h z=c} :=
  pairEquiv.trans ((NTRUBasis.affineEquiv
    (key f g bigF bigG h fInv ntru public_eq inverse_eq)
    reduce_q_zero q_multiplication_injective reduce_kernel_q
    (toQuot c) (toQuot (centerRq c),0) (centered_lift h c)).trans (fiberEquiv h c).symm)

theorem coordinates_formula (f g bigF bigG : Vec) (h fInv c : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433)) (u : Vec×Vec) :
    (coordinates f g bigF bigG h fInv c ntru public_eq inverse_eq u).val =
      (centerRq c,0)+coefficientBasis f g bigF bigG u := by
  let k := key f g bigF bigG h fInv ntru public_eq inverse_eq
  let e := NTRUBasis.affineEquiv k reduce_q_zero q_multiplication_injective reduce_kernel_q
    (toQuot c) (toQuot (centerRq c),0) (centered_lift h c)
  have hx := congrArg Subtype.val ((fiberEquiv h c).apply_symm_apply (e (pairEquiv u)))
  have hleft : pairEquiv (coordinates f g bigF bigG h fInv c ntru public_eq inverse_eq u).val =
      (toQuot (centerRq c),0)+NTRUBasis.basis k (pairEquiv u) := hx
  have ht : pairEquiv (centerRq c,0)=(toQuot (centerRq c),0) :=
    Prod.ext rfl toQuot_zero
  apply pairEquiv.injective
  rw [hleft, pairEquiv_add, coefficient_basis_binding f g bigF bigG h fInv ntru public_eq inverse_eq, ht]

theorem all_fiber_points (f g bigF bigG : Vec) (h fInv c : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433))
    (z : Vec×Vec) (hz : A h z=c) :
    ∃! u : Vec×Vec, (coordinates f g bigF bigG h fInv c ntru public_eq inverse_eq u).val=z := by
  let e := coordinates f g bigF bigG h fInv c ntru public_eq inverse_eq
  refine ⟨e.symm ⟨z,hz⟩, ?_, ?_⟩
  · exact congrArg Subtype.val (e.apply_symm_apply ⟨z,hz⟩)
  · intro u hu
    apply e.injective
    apply Subtype.ext
    rw [hu]
    exact (congrArg Subtype.val (e.apply_symm_apply ⟨z,hz⟩)).symm

theorem fiber_weight_reindex (f g bigF bigG : Vec) (h fInv c : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433))
    (weight : (Vec×Vec) → ℝ) :
    (∑' u : Vec×Vec, weight (coordinates f g bigF bigG h fInv c ntru public_eq inverse_eq u).val)=
      ∑' z : {z : Vec×Vec // A h z=c}, weight z.val :=
  (coordinates f g bigF bigG h fInv c ntru public_eq inverse_eq).tsum_eq (fun z => weight z.val)

theorem gaussian_fiber_in_basis (f g bigF bigG : Vec) (h fInv c : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433)) (a : ℝ) :
    (∑' z : {z : Vec×Vec // A h z=c}, Real.exp (-a*(Geometry.Q z.val : ℝ))) =
      ∑' u : Vec×Vec, Real.exp (-a*(Geometry.Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ)) := by
  have hr := fiber_weight_reindex f g bigF bigG h fInv c ntru public_eq inverse_eq
    (fun z : Vec×Vec => Real.exp (-a*(Geometry.Q z : ℝ)))
  rw [← hr]
  apply tsum_congr
  intro u
  rw [coordinates_formula]

end FT1536.Run2.ActualNTRUFiber
