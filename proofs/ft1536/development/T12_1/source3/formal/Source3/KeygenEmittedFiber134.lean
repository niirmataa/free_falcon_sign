import Source3.KeygenEmittedFiber083
import Source3.KeygenPublicComplete082
import Run2.ActualNTRUFiber
import Source3.KeygenPublicComplete134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenEmittedFiber134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open FT1536.Geometry FT1536.Relation FT1536.Run2.CoefficientQuotient
open FT1536.Run2.ActualNTRUFiber


open KeygenEmittedFiber083
abbrev f (r : KeygenPublicComplete134.Output env caller out) : Vec := r.secret.vectors 0

abbrev g (r : KeygenPublicComplete134.Output env caller out) : Vec := r.secret.vectors 1

abbrev bigF (r : KeygenPublicComplete134.Output env caller out) : Vec := r.secret.vectors 2

abbrev bigG (r : KeygenPublicComplete134.Output env caller out) : Vec := r.secret.vectors 3

abbrev h (r : KeygenPublicComplete134.Output env caller out) : Rq := r.secret.h

abbrev fInv (r : KeygenPublicComplete134.Output env caller out) : Rq := r.secret.fInv

def FiberFacts (r : KeygenPublicComplete134.Output env caller out) : Prop :=
  ∃ (ntru : multiply (f r) (bigG r)-multiply (g r) (bigF r)=constantCoeffs (18433 : Int))
    (publicEq : mulRq (h r) (reduceVec (f r))=reduceVec (g r))
    (inverseEq : mulRq (fInv r) (reduceVec (f r))=constantCoeffs (1 : ZMod 18433)),
    ∀ c : Rq,
      (∀ u : Vec×Vec,
        (coordinates (f r) (g r) (bigF r) (bigG r) (h r) (fInv r) c ntru publicEq inverseEq u).val=
          (centerRq c,0)+coefficientBasis (f r) (g r) (bigF r) (bigG r) u) ∧
      (∀ a : Real,
        (∑' z : {z : Vec×Vec // A (h r) z=c}, Real.exp (-a*(Geometry.Q z.val : Real)))=
          ∑' u : Vec×Vec,
            Real.exp (-a*(Geometry.Q ((centerRq c,0)+coefficientBasis (f r) (g r) (bigF r) (bigG r) u) : Real)))

theorem from_output (r : KeygenPublicComplete134.Output env caller out) : FiberFacts r := by
  let ntru : multiply (f r) (bigG r)-multiply (g r) (bigF r)=constantCoeffs (18433 : Int) := r.secret.laws.2.2.1
  let publicEq : mulRq (h r) (reduceVec (f r))=reduceVec (g r) := r.secret.laws.2.2.2.2.1
  let inverseEq : mulRq (fInv r) (reduceVec (f r))=constantCoeffs (1 : ZMod 18433) := r.secret.laws.2.2.2.2.2
  exact ⟨ntru,publicEq,inverseEq,fun c =>
    ⟨coordinates_formula (f r) (g r) (bigF r) (bigG r) (h r) (fInv r) c ntru publicEq inverseEq,
      gaussian_fiber_in_basis (f r) (g r) (bigF r) (bigG r) (h r) (fInv r) c ntru publicEq inverseEq⟩⟩

end FT1536.Source3.KeygenEmittedFiber134
