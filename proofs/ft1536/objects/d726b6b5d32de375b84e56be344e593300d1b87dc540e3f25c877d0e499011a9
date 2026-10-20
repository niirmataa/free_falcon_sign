import Source3.KeygenIntegerLift
import Run2.ActualNTRUFiber

/- Internal composition. These are explicitly the obligations still to be
   obtained from the source execution, not a definition of emitted success. -/
namespace FT1536.Source3.KeygenFiberAssembly
open FT1536.Geometry FT1536.Relation FT1536.Run2.CoefficientQuotient
open KeygenIntegerLift FT1536.Run2.ActualNTRUFiber

theorem from_modular_check (f g bigF bigG : Vec) (h fInv : Rq)
    (hf : Bound f 1) (hg : Bound g 1) (hF : Bound bigF 2047) (hG : Bound bigG 2047)
    (check : mapCoeffs (Int.castRingHom (ZMod 2147355649)) (residual f g bigF bigG)=0)
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433)) :
    ∃ ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ),
      ∀ c : Rq,
        (∀ u : Vec×Vec,
          (coordinates f g bigF bigG h fInv c ntru public_eq inverse_eq u).val =
            (centerRq c,0)+coefficientBasis f g bigF bigG u) ∧
        (∀ a : ℝ,
          (∑' z : {z : Vec×Vec // A h z=c}, Real.exp (-a*(FT1536.Geometry.Q z.val : ℝ))) =
            ∑' u : Vec×Vec,
              Real.exp (-a*(FT1536.Geometry.Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ))) := by
  let hn := exact_ntru_of_modular_check f g bigF bigG hf hg hF hG check
  refine ⟨hn,fun c => ⟨?_,?_⟩⟩
  · exact coordinates_formula f g bigF bigG h fInv c hn public_eq inverse_eq
  · exact gaussian_fiber_in_basis f g bigF bigG h fInv c hn public_eq inverse_eq

end FT1536.Source3.KeygenFiberAssembly
