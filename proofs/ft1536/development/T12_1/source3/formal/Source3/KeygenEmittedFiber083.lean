import Source3.KeygenPublicComplete082
import Run2.ActualNTRUFiber

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Bounded preparation for B1.10: consume the completed observed source
   output directly. This does not complete B1.11 replay/mutation/review. -/
namespace FT1536.Source3.KeygenEmittedFiber083
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open FT1536.Geometry FT1536.Relation FT1536.Run2.CoefficientQuotient
open FT1536.Run2.ActualNTRUFiber

abbrev f (r : KeygenPublicComplete082.Output env caller out) : Vec := r.secret.vectors 0
abbrev g (r : KeygenPublicComplete082.Output env caller out) : Vec := r.secret.vectors 1
abbrev bigF (r : KeygenPublicComplete082.Output env caller out) : Vec := r.secret.vectors 2
abbrev bigG (r : KeygenPublicComplete082.Output env caller out) : Vec := r.secret.vectors 3
abbrev h (r : KeygenPublicComplete082.Output env caller out) : Rq := r.secret.h
abbrev fInv (r : KeygenPublicComplete082.Output env caller out) : Rq := r.secret.fInv

def FiberFacts (r : KeygenPublicComplete082.Output env caller out) : Prop :=
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

theorem from_output (r : KeygenPublicComplete082.Output env caller out) : FiberFacts r := by
  let ntru : multiply (f r) (bigG r)-multiply (g r) (bigF r)=constantCoeffs (18433 : Int) := r.secret.laws.2.2.1
  let publicEq : mulRq (h r) (reduceVec (f r))=reduceVec (g r) := r.secret.laws.2.2.2.2.1
  let inverseEq : mulRq (fInv r) (reduceVec (f r))=constantCoeffs (1 : ZMod 18433) := r.secret.laws.2.2.2.2.2
  exact ⟨ntru,publicEq,inverseEq,fun c =>
    ⟨coordinates_formula (f r) (g r) (bigF r) (bigG r) (h r) (fInv r) c ntru publicEq inverseEq,
      gaussian_fiber_in_basis (f r) (g r) (bigF r) (bigG r) (h r) (fInv r) c ntru publicEq inverseEq⟩⟩

theorem emitted_to_actual_fiber (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : KeygenSecretInvocation081.PinnedExec env caller out)
    (success : out.flow=.returned (some (.int32 1))) :
    ∃ result : KeygenPublicComplete082.Output env caller out, FiberFacts result := by
  obtain ⟨result⟩ := KeygenPublicComplete082.observed_pair env caller out primes rev rootLegal buffers comp capacity publicLegal source success
  exact ⟨result,from_output result⟩

theorem actual_observed_fiber (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev)
    (buffers : KeygenOutputMemory081.Legal env caller) (comp : env.args.comp=1)
    (capacity : BitVec 64) (publicLegal : KeygenPublicEntry082.Legal env caller capacity)
    (source : KeygenSecretInvocation081.PinnedExec env caller out)
    (success : out.flow=.returned (some (.int32 1))) (sk pk : List (BitVec 8))
    (secretObserved : KeygenSecretObserved081.ObservedSecret env.args.privkey env.args.privkeyLen out.state.heap sk)
    (publicObserved : KeygenPublicObserved077.ObservedPublic env.args.pubkey env.args.pubkeyLen out.state.heap pk) :
    ∃ result : KeygenPublicComplete082.Output env caller out,
      KeygenSecretPacket081.DecodeSecret sk=some (f result,g result,bigF result,bigG result) ∧
      KeygenPublicPacket077.DecodePublic pk=some (h result) ∧ FiberFacts result := by
  obtain ⟨result,secretDecoded,publicDecoded,lengths⟩ := KeygenPublicComplete082.actual_observed_pair env caller out primes rev
    rootLegal buffers comp capacity publicLegal source success sk pk secretObserved publicObserved
  exact ⟨result,secretDecoded,publicDecoded,from_output result⟩

end FT1536.Source3.KeygenEmittedFiber083
