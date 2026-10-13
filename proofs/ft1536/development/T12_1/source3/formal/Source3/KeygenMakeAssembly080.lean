import Source3.KeygenEntryAt080
import Source3.KeygenTailCellsAt080
import Source3.KeygenLoopMaterial080
import Source3.KeygenPublicCallerExecution077
import Source3.KeygenSameCertificate080

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenMakeAssembly080
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env inputOf publicOf)
open KeygenLoopAt080

/-- Initial memory and source-static input facts only. Scratch contents and
    all coefficient values are absent. The space bound permits the actual
    automatic bad flag, rather than an assumed live flag value. -/
structure LegalEntry (env : Env) (caller : State) (primes rev : ArrayPointer) : Prop where
  original : KeygenMakeEntry.Original env.ctx (KeygenMakeArguments.entry caller env.args) primes rev
  workspaceExtent : KeygenMakeWorkspaceRelocation.extent env.ctx.scratch=286720
  workspaceAligned : env.ctx.scratch.offset%8=0
  workspaceSpace : C99Automatic32.align4 (caller.heap.size env.ctx.scratch.block)+4<2^64

/-- Fixed source bodies, actual control flow and outer teardown. No codec
    correctness, TailCells, mathematical witness or certificate fact is a
    constructor premise. The public caller relation also binds private calls. -/
inductive Invocation (env : Env) (caller : State) : Result → Prop where
  | readiness (bound : State) (events : List KeygenEntropySource.Event) (raw : Result)
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events raw) (exit : raw.flow≠.normal) :
      Invocation env caller (KeygenMakeLifetime.close bound env.blocks raw)
  | capped (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut : Result)
      (attempts : List (AttemptExecution env.ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩)
      (loop : LoopTrace env.ctx entry loopOut attempts) (aborted : loopOut.flow=KeygenCapExecution.abortFlow) :
      Invocation env caller (KeygenMakeLifetime.close bound env.blocks loopOut)
  | encoded (bound entry : State) (events : List KeygenEntropySource.Event) (loopOut tailOut : Result)
      (attempts : List (AttemptExecution env.ctx)) (publicCalls : List (KeygenPublicCallerSite077.Site env))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
      (ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩)
      (loop : LoopTrace env.ctx entry loopOut attempts) (normal : loopOut.flow=.normal)
      (tail : KeygenPublicCallerExecution077.Encoding env KeygenMakeProgram.encoding loopOut.state tailOut publicCalls) :
      Invocation env caller (KeygenMakeLifetime.close bound env.blocks tailOut)

structure Frontier (env : Env) (caller : State) (out : Result) where
  bound : State
  entry : State
  events : List KeygenEntropySource.Event
  loopOut : Result
  tailOut : Result
  attempts : List (AttemptExecution env.ctx)
  publicCalls : List (KeygenPublicCallerSite077.Site env)
  binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound
  ready : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨entry,.normal⟩
  loop : LoopTrace env.ctx entry loopOut attempts
  loopNormal : loopOut.flow=.normal
  tail : KeygenPublicCallerExecution077.Encoding env KeygenMakeProgram.encoding loopOut.state tailOut publicCalls
  tailSuccess : tailOut.flow=.returned (some (.int32 1))
  output : out=KeygenMakeLifetime.close bound env.blocks tailOut
  cells : KeygenMakeInvocation.TailCells env loopOut.state
  material : KeygenMakeMaterialWitness.Witness loopOut.state.heap (inputOf env) (publicOf env)
  countBound : attempts.length≤3000000
  joined : KeygenSameCertificate080.Joined env.ctx attempts.length (inputOf env) (publicOf env) loopOut.state
  finalCertificate : ∃ rejected final, attempts=rejected++[final] ∧
    (∀ a∈rejected, AttemptRejected a) ∧ AttemptAccepted final ∧ final.out.state=loopOut.state ∧
    KeygenLoopMaterial080.AttemptCertificate env.ctx attempts.length final

/-- Successful source return derives the whole accepted-attempt frontier,
    source-linked certificate package and exact serialization-entry heap. -/
theorem successful_frontier (env : Env) (caller : State) (out : Result) (primes rev : ArrayPointer)
    (legal : LegalEntry env caller primes rev) (source : Invocation env caller out)
    (success : out.flow=.returned (some (.int32 1))) : Nonempty (Frontier env caller out) := by
  cases source with
  | readiness bound events raw binding ready exit =>
    have failure := KeygenMakeLifetime.failed_prefix_result env.ctx bound env.blocks events raw ready exit
    rw [KeygenMakeLifetime.close_flow,failure] at success
    cases success
  | capped bound entry events loopOut attempts binding ready loop aborted =>
    rw [KeygenMakeLifetime.close_flow,aborted] at success
    cases success
  | encoded bound entry events loopOut tailOut attempts publicCalls binding ready loop normal tail =>
    have boundEq := KeygenMakeArguments.bind_exact caller env.args bound binding
    have original : KeygenMakeEntry.Original env.ctx bound primes rev := by rw [boundEq]; exact legal.original
    have shape : KeygenMakeWorkspaceBridge.Shape env.ctx := ⟨legal.workspaceExtent,legal.workspaceAligned⟩
    have space : KeygenMakeCertRelocation.SpaceAt env.ctx.scratch.block entry.heap := by
      change C99Automatic32.align4 (entry.heap.size env.ctx.scratch.block)+4<2^64
      rw [KeygenEntryAt080.scratch_size env.ctx bound entry env.blocks primes rev events original ready,boundEq]
      exact legal.workspaceSpace
    have facts := KeygenEntryAt080.entry_facts env.ctx bound entry env.blocks primes rev events original ready
    have remaining := KeygenMakeLoopChronology.entry_remaining env bound entry primes rev events original ready
    have cells := KeygenTailCellsAt080.loop_cells env entry loopOut attempts loop 0 remaining
      (KeygenMakeLoopChronology.entry_tail_cells env caller bound entry primes rev events original binding ready) normal
    have material := KeygenLoopMaterial080.material env.ctx entry loopOut attempts loop (inputOf env) (publicOf env)
      primes rev shape 0 remaining facts space normal
    have count := (KeygenLoopAt080.loop_bounds env.ctx entry loopOut attempts loop 0 remaining).1
    have certificate := KeygenLoopMaterial080.final_certificate env.ctx entry loopOut attempts loop (inputOf env)
      (publicOf env) primes rev shape 0 remaining facts.initial space normal
    have joined := KeygenSameCertificate080.loop_joined env.ctx entry loopOut attempts loop (inputOf env)
      (publicOf env) primes rev shape 0 remaining facts space normal
    exact ⟨⟨bound,entry,events,loopOut,tailOut,attempts,publicCalls,binding,ready,loop,normal,tail,success,rfl,
      cells,material.1,by simpa [KeygenAttemptCap.limit] using count,by simpa using joined,by simpa using certificate⟩⟩

def callId (env : Env) (caller : State) (out : Result) (frontier : Frontier env caller out) : Nat :=
  frontier.attempts.length

/-- The identifier is scoped to this invocation's chronological source
    trace. It names its final certificate call, with the actual counter. -/
theorem call_id_bound (env : Env) (caller : State) (out : Result) (frontier : Frontier env caller out) :
    1≤callId env caller out frontier ∧ callId env caller out frontier≤3000000 := by
  obtain ⟨rejected,final,shape,_,_,_,_⟩ := frontier.finalCertificate
  have positive : 1≤frontier.attempts.length := by rw [shape,List.length_append,List.length_singleton]; omega
  exact ⟨positive,frontier.countBound⟩

/-- Outer teardown is performed after serialization, and every coefficient,
    public-material and ske automatic object is dead at the actual return. -/
theorem automatic_objects_dead (env : Env) (caller : State) (out : Result)
    (frontier : Frontier env caller out) (slot : Fin 6) : out.state.heap.size (env.blocks slot)=0 := by
  rw [frontier.output]
  exact (KeygenMakeLifetime.close_object frontier.bound env.blocks frontier.tailOut slot).1.trans
    (KeygenMakeLifetime.prefix_empty env.ctx frontier.bound env.blocks frontier.events
      ⟨frontier.entry,.normal⟩ frontier.ready slot)

theorem no_dead_material_read (env : Env) (caller : State) (out : Result)
    (frontier : Frontier env caller out) (slot : Fin 6) (p : ArrayPointer)
    (block : p.block=env.blocks slot) (word : BitVec 16) : ¬C99NarrowReads.Load16 out.state.heap p word := by
  intro read
  cases read with
  | load bytes allocated width initialized =>
    have positive := KeygenCallerEntry.allocated_live _ _ allocated
    rw [block,automatic_objects_dead env caller out frontier slot] at positive
    omega

end FT1536.Source3.KeygenMakeAssembly080
