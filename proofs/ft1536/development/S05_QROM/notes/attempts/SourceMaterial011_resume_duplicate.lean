import Source3.KeygenMakeAttemptSpine
import Run2.ActualNTRUFiber

/- Q-KEY: proof-obligation interface at the encoding INPUT boundary.
   No theorem about completed encoding, emitted probabilities, harmonic
   mass, sampler execution or QROM security is asserted by this file. -/
namespace FT1536.S05.SourceMaterial011
open Geometry FT1536.Relation Run2.CoefficientQuotient
open Source3
open Source3.C99MemoryReference (Memory ArrayPointer)

structure CoefficientKey (h : Rq) where
  f : Vec
  g : Vec
  bigF : Vec
  bigG : Vec
  fInv : Rq
  fSmall : KeygenIntegerLift.Bound f 1
  gSmall : KeygenIntegerLift.Bound g 1
  bigFSmall : KeygenIntegerLift.Bound bigF 2047
  bigGSmall : KeygenIntegerLift.Bound bigG 2047
  ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)
  public_eq : mulRq h (reduceVec f)=reduceVec g
  inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433)

def RepresentsKey {h : Rq} (heap : Memory) (input : Fin 4 → ArrayPointer)
    (pub : ArrayPointer) (k : CoefficientKey h) : Prop :=
  KeygenMaterial.Represents heap (input 0) k.f ∧
  KeygenMaterial.Represents heap (input 1) k.g ∧
  KeygenMaterial.Represents heap (input 2) k.bigF ∧
  KeygenMaterial.Represents heap (input 3) k.bigG ∧
  KeygenPublicNormalizePolynomial.Represents heap pub h

theorem public_cell_unique (heap : Memory) (p : ArrayPointer) (i : Nat)
    (x y : KeygenPublicAlgebra.R)
    (hx : KeygenPublicInputCells.Cell heap p i x)
    (hy : KeygenPublicInputCells.Cell heap p i y) : x=y := by
  obtain ⟨wx,lx,_,ex⟩ := hx
  obtain ⟨wy,ly,_,ey⟩ := hy
  have hw := C99NarrowReads.load16_deterministic _ _ _ _ lx ly
  exact ex.symm.trans ((congrArg (fun w : BitVec 16 => (w.toNat : KeygenPublicAlgebra.R)) hw).trans ey)

theorem public_representation_unique (heap : Memory) (pub : ArrayPointer) (h k : Rq)
    (hh : KeygenPublicNormalizePolynomial.Represents heap pub h)
    (hk : KeygenPublicNormalizePolynomial.Represents heap pub k) : h=k := by
  funext i
  exact Prod.ext (public_cell_unique heap pub i.val _ _ (hh i).1 (hk i).1)
    (public_cell_unique heap pub (i.val+768) _ _ (hh i).2 (hk i).2)

theorem key_of_encoding_inputs (heap : Memory) (input : Fin 4 → ArrayPointer)
    (pub : ArrayPointer) (source : KeygenMakeMaterialWitness.EncodingInputs heap input pub) :
    ∃ h : Rq, ∃ k : CoefficientKey h, RepresentsKey heap input pub k := by
  obtain ⟨f,g,bigF,bigG,fInvH,fInv,rf,rg,rF,rG,rh,bounds,equation,publicEq,inverseEq⟩ := source
  change KeygenIntegerLift.Bound f 1 ∧ KeygenIntegerLift.Bound g 1 ∧
    KeygenIntegerLift.Bound bigF 2047 ∧ KeygenIntegerLift.Bound bigG 2047 at bounds
  change multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ) at equation
  let key : CoefficientKey fInvH :=
    ⟨f,g,bigF,bigG,fInv,bounds.1,bounds.2.1,bounds.2.2.1,bounds.2.2.2,equation,publicEq,inverseEq⟩
  exact ⟨fInvH,key,rf,rg,rF,rG,rh⟩

/-- The h in the algebraic equations is exactly the h represented by the
    same physical public array; no independent or freshly chosen key. -/
theorem key_at_same_public_array (heap : Memory) (input : Fin 4 → ArrayPointer)
    (pub : ArrayPointer) (h : Rq)
    (source : KeygenMakeMaterialWitness.EncodingInputs heap input pub)
    (read : KeygenPublicNormalizePolynomial.Represents heap pub h) :
    ∃ k : CoefficientKey h, RepresentsKey heap input pub k := by
  obtain ⟨h',k,repr⟩ := key_of_encoding_inputs heap input pub source
  have same := public_representation_unique heap pub h' h repr.2.2.2.2 read
  subst h'
  exact ⟨k,repr⟩

/-- Workspace is required only at an actual accepted certificate call,
    not at every arbitrary State. This obligation remains explicit. -/
def WorkspaceAtCall (ctx : KeygenSearchContext.Context) (out : C99ArrayReference.State) : Prop :=
  ∀ raw value, KeygenMakeCertCall.Call ctx raw out value true →
    KeygenMakeCertMaterial.LegalWorkspace raw ctx

theorem key_of_accepted_attempt (ctx : KeygenSearchContext.Context)
    (before : C99ArrayReference.State) (out : C99ProcedureReference.Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (pub primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : KeygenMakeAttemptSpine.EntryFacts ctx before input pub primes rev)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (accepted : out.flow=.breakLoop) (workspace : WorkspaceAtCall ctx out.state) :
    ∃ h : Rq, ∃ k : CoefficientKey h, RepresentsKey out.state.heap input pub k := by
  cases KeygenMakeAttemptSpine.accepted_spine ctx before out i remaining source accepted with
  | run entry middle sampled res normed publicState rawState pv sv cv cap sampleF sampleG
      resultants norms publicCall publicNonzero solverCall solverReturned certificate =>
    have encoding := (KeygenMakeAttemptSpine.spine_witness ctx before entry middle sampled
      res normed publicState rawState out.state pv sv cv i input pub primes rev remaining
      facts cap sampleF sampleG resultants norms publicCall publicNonzero solverCall
      solverReturned certificate (workspace rawState cv certificate)).2
    exact key_of_encoding_inputs out.state.heap input pub encoding

noncomputable def coordinates {h : Rq} (k : CoefficientKey h) (c : Rq) :
    (Vec×Vec) ≃ {z : Vec×Vec // A h z=c} :=
  Run2.ActualNTRUFiber.coordinates k.f k.g k.bigF k.bigG h k.fInv c
    k.ntru k.public_eq k.inverse_eq

theorem coordinates_formula {h : Rq} (k : CoefficientKey h) (c : Rq) (u : Vec×Vec) :
    (coordinates k c u).val=(centerRq c,0)+
      Run2.ActualNTRUFiber.coefficientBasis k.f k.g k.bigF k.bigG u :=
  Run2.ActualNTRUFiber.coordinates_formula k.f k.g k.bigF k.bigG h k.fInv c
    k.ntru k.public_eq k.inverse_eq u

theorem every_fiber_point {h : Rq} (k : CoefficientKey h) (c : Rq)
    (z : Vec×Vec) (hz : A h z=c) : ∃! u, (coordinates k c u).val=z :=
  Run2.ActualNTRUFiber.all_fiber_points k.f k.g k.bigF k.bigG h k.fInv c
    k.ntru k.public_eq k.inverse_eq z hz

theorem gaussian_reindex {h : Rq} (k : CoefficientKey h) (c : Rq) (a : ℝ) :
    (∑' z : {z : Vec×Vec // A h z=c}, Real.exp (-a*(Q z.val : ℝ))) =
      ∑' u : Vec×Vec, Real.exp (-a*(Q ((centerRq c,0)+
        Run2.ActualNTRUFiber.coefficientBasis k.f k.g k.bigF k.bigG u) : ℝ)) :=
  Run2.ActualNTRUFiber.gaussian_fiber_in_basis k.f k.g k.bigF k.bigG h k.fInv c
    k.ntru k.public_eq k.inverse_eq a


/-- Only workspaces at certificate calls reaching this output are required.
    This preserves the actual source execution boundary without claiming
    legality of arbitrary unrelated machine states. -/
theorem accepted_attempt_key (ctx : KeygenSearchContext.Context)
    (before : C99ArrayReference.State) (out : C99ProcedureReference.Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (pub primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : KeygenMakeAttemptSpine.EntryFacts ctx before input pub primes rev)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (accepted : out.flow=.breakLoop)
    (workspaces : ∀ raw v, KeygenMakeCertCall.Call ctx raw out.state v true →
      KeygenMakeCertMaterial.LegalWorkspace raw ctx) :
    ∃ h : Rq, ∃ k : CoefficientKey h, RepresentsKey out.state.heap input pub k := by
  cases KeygenMakeAttemptSpine.accepted_spine ctx before out i remaining source accepted with
  | run entry middle sampled res normed publicState rawState publicValue solverValue certValue
      cap sampleF sampleG resultants norms publicCall publicNonzero solverCall solverReturned certificate =>
    have inputs := (KeygenMakeAttemptSpine.spine_witness ctx before entry middle sampled res normed
      publicState rawState out.state publicValue solverValue certValue i input pub primes rev
      remaining facts cap sampleF sampleG resultants norms publicCall publicNonzero solverCall
      solverReturned certificate (workspaces rawState certValue certificate)).2
    exact key_of_encoding_inputs out.state.heap input pub inputs

#print axioms accepted_attempt_key
#print axioms public_cell_unique
#print axioms public_representation_unique
#print axioms key_of_encoding_inputs
#print axioms key_at_same_public_array
#print axioms key_of_accepted_attempt
#print axioms coordinates_formula
#print axioms every_fiber_point
#print axioms gaussian_reindex
end FT1536.S05.SourceMaterial011
