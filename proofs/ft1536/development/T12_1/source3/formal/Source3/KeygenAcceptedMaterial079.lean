import Source3.KeygenMakeCertificatePremises

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Reachable certificate workspace and material of the same accepted attempt.
   The old all-state LegalWorkspace premise is absent. Allocation shape and
   entry memory space remain explicit; relocation is a separate obligation. -/
namespace FT1536.Source3.KeygenAcceptedMaterial079
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem attempt_material (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (facts : KeygenMakeAttemptSpine.EntryFacts ctx before input h primes rev)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (space : C99Automatic32.Space before.heap)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (accepted : out.flow=.breakLoop) :
    KeygenMakeMaterialWitness.EncodingInputs out.state.heap input h := by
  cases KeygenMakeAttemptSpine.accepted_spine ctx before out i remaining source accepted with
  | run entry middle sampled res normed publicState rawState pv sv cv cap sampleF sampleG
      resultants norms publicCall publicNonzero solverCall solverReturned certificate =>
    have solverNonzero : sv.integer≠0 := by
      rw [solverReturned]
      decide +kernel
    have sampledRun : KeygenMakeSearchPrefix.Sampled ctx before ⟨rawState,.normal⟩ :=
      .run entry _ cap (.solver normed publicState _
        (.norm middle sampled res _ sampleF sampleG resultants norms)
        (.accept publicState pv publicCall publicNonzero)
        (.accept rawState sv solverCall solverNonzero))
    obtain ⟨gateInitial,frame⟩ := KeygenMakeRetryTransport.sampled_entry ctx before _ i
      input h primes rev remaining facts.initial sampledRun
    have gateSpace := KeygenMakeCertificatePremises.space_of_frame ctx before.heap
      rawState.heap primes rev frame space
    have workspace := KeygenMakeCertificatePremises.gate_workspace ctx rawState shape
      gateInitial.scratch gateSpace
    exact (KeygenMakeAttemptSpine.spine_witness ctx before entry middle sampled res normed
      publicState rawState out.state pv sv cv i input h primes rev remaining facts cap
      sampleF sampleG resultants norms publicCall publicNonzero solverCall solverReturned
      certificate workspace).2

end FT1536.Source3.KeygenAcceptedMaterial079
