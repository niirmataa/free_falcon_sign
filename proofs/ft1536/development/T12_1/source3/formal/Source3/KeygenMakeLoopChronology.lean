import Source3.KeygenMakeInvocation
import Source3.KeygenMakeRetryTransport

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE loop-trace chronology composition of the per-retry entry transport
   with the derivation of the `TailCells` tail-entry class across rejected
   attempts. The per-retry transport of `KeygenMakeRetryTransport` moves the
   `Initial`/legal/static facts and the gate-time member read through ONE
   attempt at a time; this module folds that transport over the WHOLE capped
   loop chronology (`KeygenMakeCertChronology.LoopTrace`): on the successful
   edge a sequence of rejected attempts followed by the accepted final
   attempt carries the entry facts, the entry frame and the advanced loop
   counter to the loop output state.

   `TailCells` -- the cell facts read by the 18-statement encoding tail at
   its entry state -- is the named explicit input class of the whole-
   invocation machine (`KeygenMakeInvocation.Invocation.encoded`). Its
   derivation ACROSS REJECTED ATTEMPTS is delivered here: the cell class
   holds at the loop entry (from the executed argument binding, the
   declaration allocation and the readiness prefix, given the pinned M0
   profile of the fk object) and survives every attempt instance on every
   return edge (the sampler setup rebinds only `rt1`/`rt2`/`rt3`, the
   five-gate prefix preserves the slot map, the scope close restores only
   `norm`/`bound` and the runtime names, and the certificate gate keeps
   every cell). No codec body, exact encoded length or codec write frame
   appears as a premise; B1.08/09 and B4/B5 stay outside. Not a review and
   not a law claim. -/
namespace FT1536.Source3.KeygenMakeLoopChronology
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)

/-! ## 0. The prologue state cells -/

/-- The declaration allocation binds every automatic-object name to its
    fresh block pointer; the later scalar declarations and assignments
    change only locals. -/
theorem ready_arrays_object (s : State) (blocks : Fin 6 → Nat) (slot : Fin 6) :
    (KeygenMakePrologue.ready s blocks).arrays (KeygenMakeObjects.name slot)=
      some (KeygenMakeObjects.pointer blocks slot) := by
  fin_cases slot <;> rfl

/-- The prologue leaves every array cell outside the six automatic objects
    and `skbuf` unchanged. -/
theorem ready_arrays_other (s : State) (blocks : Fin 6 → Nat) (n : Name)
    (different : ∀ slot : Fin 6, n≠KeygenMakeObjects.name slot) (outside : n≠"skbuf".toList) :
    (KeygenMakePrologue.ready s blocks).arrays n=s.arrays n := by
  have hf : n≠['f'] := different 0
  have hg : n≠['g'] := different 1
  have hF : n≠['F'] := different 2
  have hG : n≠['G'] := different 3
  have hh : n≠['h'] := different 4
  have hske : n≠['s','k','e'] := different 5
  have hskbuf : n≠['s','k','b','u','f'] := outside
  simp [KeygenMakePrologue.ready,KeygenMakePrologue.sized,KeygenMakePrologue.ternary,
    KeygenMakePrologue.logged,KeygenMakePrologue.counted,KeygenMakePrologue.declared,
    KeygenMakePrologue.tailDeclared,KeygenMakePrologue.a6,KeygenMakePrologue.middle,
    KeygenMakePrologue.a5,KeygenMakePrologue.a4,KeygenMakePrologue.a3,KeygenMakePrologue.a2,
    KeygenMakePrologue.a1,KeygenMakePrologue.a0,KeygenCallerInit.scalarDeclared,
    KeygenMakeObjects.enter,KeygenMakeObjects.name,C99ArrayReference.bindPointer,
    C99ArrayReference.bindValue,C99DeclarationStatements.effect,hf,hg,hF,hG,hh,hske,hskbuf]

/-- The prologue leaves the `comp` parameter cell unchanged (the body never
    declares `comp`). -/
theorem ready_comp (s : State) (blocks : Fin 6 → Nat) :
    (KeygenMakePrologue.ready s blocks).locals "comp".toList=s.locals "comp".toList := by
  rfl

/-- The prologue profile assignments store `logn = 10` (the fk logn member
    under the pinned M0 profile). -/
theorem ready_logn (s : State) (blocks : Fin 6 → Nat) :
    (KeygenMakePrologue.ready s blocks).locals "logn".toList=some (.uint32,some (.uint32 10)) := by
  simp [KeygenMakePrologue.ready,KeygenMakePrologue.sized,KeygenMakePrologue.ternary,
    KeygenMakePrologue.logged,C99ArrayReference.bindValue,C99ScalarReference.set]
  exact C99CountedWords.convert_self (Value.uint32 10)

/-- The prologue profile assignments store `ter = 1` (the fk ternary member
    under the pinned M0 profile). -/
theorem ready_ter (s : State) (blocks : Fin 6 → Nat) :
    (KeygenMakePrologue.ready s blocks).locals "ter".toList=some (.uint32,some (.uint32 1)) := by
  simp [KeygenMakePrologue.ready,KeygenMakePrologue.sized,KeygenMakePrologue.ternary,
    C99ArrayReference.bindValue,C99ScalarReference.set]
  exact C99CountedWords.convert_self (Value.uint32 1)

/-- The prologue size assignment stores `n = 1536`. -/
theorem ready_limit (s : State) (blocks : Fin 6 → Nat) :
    C99CountedWords.Limit (KeygenMakePrologue.ready s blocks) := by
  simp [C99CountedWords.Limit,KeygenMakePrologue.ready,KeygenMakePrologue.sized,
    C99ArrayReference.bindValue,C99ScalarReference.set]
  exact C99CountedWords.convert_self (Value.uint64 1536)

/-- The prologue dimensions at the ready state: `n`/`logn`/`ter` under the
    pinned M0 profile. -/
theorem ready_dimensions (s : State) (blocks : Fin 6 → Nat) :
    KeygenMakeSearchPrefix.Dimensions (KeygenMakePrologue.ready s blocks) :=
  ⟨ready_limit s blocks,ready_logn s blocks,ready_ter s blocks⟩

/-! ## 1. Per-attempt preservation of the tail-entry cells -/

theorem advanced_arrays (s : State) (i : Nat) (n : Name) :
    (KeygenCapWords.advanced s i).arrays n=s.arrays n := rfl

theorem advanced_comp (s : State) (i : Nat) :
    (KeygenCapWords.advanced s i).locals "comp".toList=s.locals "comp".toList := rfl

/-- The scope close restores `norm`/`bound` and the three runtime scratch
    names; every other array cell keeps the inner value. -/
theorem state_close_arrays (saved s : State) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) :
    (KeygenCallerPrefix.close saved s).arrays n=s.arrays n := by
  have absent : KeygenCallerInit.rtNames.contains n=false := by
    cases h : KeygenCallerInit.rtNames.contains n with
    | false => rfl
    | true => exact (outside (List.contains_iff_mem.mp h)).elim
  simp only [KeygenCallerPrefix.close,C99ArrayReference.restoreScope,absent,ite_false,
    Bool.false_eq_true]

theorem result_close_arrays (saved : State) (raw : Result) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) :
    (KeygenMakeSearchPrefix.close saved raw).state.arrays n=raw.state.arrays n := by
  have absent : KeygenCallerInit.rtNames.contains n=false := by
    cases h : KeygenCallerInit.rtNames.contains n with
    | false => rfl
    | true => exact (outside (List.contains_iff_mem.mp h)).elim
  simp only [KeygenMakeSearchPrefix.close,KeygenCallerPrefix.close,
    C99ArrayReference.restoreScope,absent,ite_false,Bool.false_eq_true]

/-- The public computation call keeps the whole slot map. -/
theorem public_gate_arrays (before : State) (out : Result)
    (source : KeygenAttemptMaterial.PublicGate before out) : out.state.arrays=before.arrays := by
  cases source with
  | reject after v call _zero | accept after v call _nonzero =>
    cases call; rfl

/-- The solver gate call keeps the whole slot map. -/
theorem root_gate_arrays (ctx : Context) (before : State) (out : Result)
    (source : KeygenCallerSuccess.RootGate ctx before out) : out.state.arrays=before.arrays := by
  cases source with
  | reject after v call _zero | accept after v call _nonzero =>
    exact (KeygenRootSource.slots ctx before after v call).2.1

/-- The five-gate prefix preserves every array cell outside the three
    runtime scratch names. -/
theorem gates_arrays (ctx : Context) (saved entry : State) (out : Result)
    (source : KeygenMakeSearchPrefix.Gates ctx saved entry out) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) : out.state.arrays n=entry.arrays n := by
  cases source with
  | ternaryRejected raw gate _rejected =>
    rw [result_close_arrays saved raw n outside,
      (KeygenCallerPrefix.ternary_slots ctx entry raw gate).1]
  | publicRejected normed idx source gate _rejected =>
    rw [public_gate_arrays _ out gate,state_close_arrays saved normed n outside,
      (KeygenCallerPrefix.ternary_slots ctx entry ⟨normed,.normal⟩ source).1]
  | solver normed publicState idx source publicGate gate =>
    rw [root_gate_arrays ctx publicState out gate,
      public_gate_arrays _ ⟨publicState,.normal⟩ publicGate,
      state_close_arrays saved normed n outside,
      (KeygenCallerPrefix.ternary_slots ctx entry ⟨normed,.normal⟩ source).1]

/-- One whole `Sampled` attempt preserves every array cell outside the
    three runtime scratch names. -/
theorem sampled_arrays (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeSearchPrefix.Sampled ctx before out) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) : out.state.arrays n=before.arrays n := by
  cases source with
  | run entry idx cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have entryEq : entry=KeygenMakeSearchPrefix.updated ctx before i :=
        congrArg Result.state running.2.1
      subst entry
      rw [gates_arrays ctx before (KeygenMakeSearchPrefix.updated ctx before i) out gates n outside,
        KeygenMakeSearchPrefix.updated,
        KeygenMakeSampling.prepared_slot ctx (KeygenCapWords.advanced before i) n outside,
        advanced_arrays before i n]

/-- THE array cells of the encoding tail survive one whole attempt on every
    return edge at every name outside `rt1`/`rt2`/`rt3`. -/
theorem attempt_arrays (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out) (n : Name)
    (outside : n∉KeygenCallerInit.rtNames) : out.state.arrays n=before.arrays n := by
  cases source with
  | earlyRejected idx sample _rejected =>
    exact sampled_arrays ctx before out i remaining sample n outside
  | throughCertificate raw sample _atCert idx2 gate =>
    rw [(KeygenMakeCertCall.gate_cells ctx raw.state out gate).2.1]
    exact sampled_arrays ctx before raw i remaining sample n outside

/-- The `comp` parameter cell survives the sampler setup of one attempt. -/
theorem sampled_comp (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeSearchPrefix.Sampled ctx before out) :
    out.state.locals "comp".toList=before.locals "comp".toList := by
  cases source with
  | run entry idx cap gates =>
    rcases KeygenMakeSampling.cap_before_setup ctx before i ⟨entry,.normal⟩
      remaining.2.2 remaining.1 remaining.2.1.1 cap with aborted | running
    · have impossible := congrArg Result.flow aborted.2
      cases impossible
    · have entryEq : entry=KeygenMakeSearchPrefix.updated ctx before i :=
        congrArg Result.state running.2.1
      subst entry
      rw [KeygenMakeSearchPrefix.gates_locals ctx before
          (KeygenMakeSearchPrefix.updated ctx before i) out gates "comp".toList (by decide),
        KeygenMakeSearchPrefix.updated,
        KeygenMakeSearchPrefix.prepared_local ctx (KeygenCapWords.advanced before i)
          "comp".toList (by decide),
        advanced_comp before i]

/-- THE `comp` parameter cell survives one whole attempt on every return
    edge. -/
theorem attempt_comp (ctx : Context) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out) :
    out.state.locals "comp".toList=before.locals "comp".toList := by
  cases source with
  | earlyRejected idx sample _rejected => exact sampled_comp ctx before out i remaining sample
  | throughCertificate raw sample _atCert idx2 gate =>
    rw [(KeygenMakeCertCall.gate_cells ctx raw.state out gate).1]
    exact sampled_comp ctx before raw i remaining sample

/-- The `skeName` cells are the four material names, never runtime scratch
    names. -/
theorem skeName_not_rt (slot : Fin 4) :
    KeygenMakeInvocation.skeName slot∉KeygenCallerInit.rtNames := by
  fin_cases slot <;> decide

/-- THE `TailCells` class survives one whole attempt on every return edge:
    the array cells move by `attempt_arrays`, `comp` by `attempt_comp` and
    the `logn`/`ter` profile locals by the advanced `Remaining` instance of
    the attempt (`Dimensions`). -/
theorem attempt_tail_cells (env : Env) (before : State) (out : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (cells : KeygenMakeInvocation.TailCells env before)
    (source : KeygenMakeCertChronology.AttemptExec env.ctx before out) :
    KeygenMakeInvocation.TailCells env out.state := by
  have advanced : KeygenMakeSearchPrefix.Remaining out.state (i+1) :=
    (KeygenMakeCertChronology.attempt_remaining env.ctx before out i remaining source).2.1
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · rw [attempt_arrays env.ctx before out i remaining source "privkey".toList (by decide)]
    exact cells.privkey
  · rw [attempt_arrays env.ctx before out i remaining source "privkey_len".toList (by decide)]
    exact cells.privkeyLen
  · rw [attempt_arrays env.ctx before out i remaining source "pubkey".toList (by decide)]
    exact cells.pubkey
  · rw [attempt_arrays env.ctx before out i remaining source "pubkey_len".toList (by decide)]
    exact cells.pubkeyLen
  · rw [attempt_comp env.ctx before out i remaining source]
    exact cells.comp
  · exact advanced.2.1.2.1
  · exact advanced.2.1.2.2
  · intro slot
    rw [attempt_arrays env.ctx before out i remaining source (KeygenMakeInvocation.skeName slot)
      (skeName_not_rt slot)]
    exact cells.material slot
  · rw [attempt_arrays env.ctx before out i remaining source "h".toList (by decide)]
    exact cells.publicCell
  · rw [attempt_arrays env.ctx before out i remaining source "ske".toList (by decide)]
    exact cells.ske

/-! ## 2. The loop-trace chronology composition -/

/-- THE loop-trace chronology composition of the per-retry transport at the
    cell level: a whole `LoopTrace` carries the `TailCells` class from the
    loop entry to the loop output on the successful edge, through every
    rejected attempt instance. -/
theorem loop_tail_cells (env : Env) (before : State) (out : Result)
    (attempts : List (KeygenMakeCertChronology.AttemptExecution env.ctx))
    (loop : KeygenMakeCertChronology.LoopTrace env.ctx before out attempts) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      KeygenMakeInvocation.TailCells env before → out.flow=.normal →
      KeygenMakeInvocation.TailCells env out.state := by
  induction loop with
  | exhausted _b _o _cap exit =>
    intro i remaining cells succeeded
    exact (exit succeeded).elim
  | accepted a _last =>
    intro i remaining cells succeeded
    exact attempt_tail_cells env a.before a.out i remaining cells a.source
  | retry a _out _rest _rejected _tail ih =>
    intro i remaining cells succeeded
    exact ih (i+1)
      (KeygenMakeCertChronology.attempt_remaining env.ctx a.before a.out i remaining a.source).2.1
      (attempt_tail_cells env a.before a.out i remaining cells a.source) succeeded

/-- THE loop-trace chronology composition of the per-retry entry transport:
    a whole `LoopTrace` carries the `Initial`/legal/static facts, the entry
    frame and the advanced loop counter from the loop entry to the loop
    output on the successful edge. Every rejected attempt instance hands
    its transported facts to the next retry. -/
theorem loop_retry_entry (ctx : Context) (before : State) (out : Result)
    (attempts : List (KeygenMakeCertChronology.AttemptExecution ctx))
    (loop : KeygenMakeCertChronology.LoopTrace ctx before out attempts)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      KeygenCallerEntry.Initial ctx before input h primes rev →
      (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
        KeygenMakeCertCall.Call ctx s t w ret →
          KeygenMakeRetryTransport.CertEntryFrame ctx s.heap t.heap primes rev) →
      out.flow=.normal →
      KeygenCallerEntry.Initial ctx out.state input h primes rev ∧
        KeygenMakeSearchPrefix.Remaining out.state (i+attempts.length) ∧
        KeygenMakeRetryTransport.EntryFrame ctx before.heap out.state.heap primes rev := by
  induction loop with
  | exhausted _b _o _cap exit =>
    intro i remaining initial certFrame succeeded
    exact (exit succeeded).elim
  | accepted a _last =>
    intro i remaining initial certFrame succeeded
    obtain ⟨stepInitial,stepFrame⟩ :=
      KeygenMakeRetryTransport.attempt_entry ctx a.before a.out i input h primes rev remaining
        initial a.source certFrame
    refine ⟨stepInitial,?_,stepFrame⟩
    simpa using
      (KeygenMakeCertChronology.attempt_remaining ctx a.before a.out i remaining a.source).2.1
  | retry a out rest _rejected _tail ih =>
    intro i remaining initial certFrame succeeded
    have advanced : KeygenMakeSearchPrefix.Remaining a.out.state (i+1) :=
      (KeygenMakeCertChronology.attempt_remaining ctx a.before a.out i remaining a.source).2.1
    obtain ⟨stepInitial,stepRemaining,stepFrame⟩ := ih (i+1) advanced
      (KeygenMakeRetryTransport.initial_of_attempt ctx a.before a.out i input h primes rev remaining
        initial a.source certFrame) certFrame succeeded
    refine ⟨stepInitial,?_,
      KeygenMakeRetryTransport.entry_frame_trans ctx a.before.heap a.out.state.heap out.state.heap
        primes rev (KeygenMakeRetryTransport.frame_of_attempt ctx a.before a.out i input h primes rev
          remaining initial a.source certFrame) stepFrame⟩
    have length : i+(a::rest).length=(i+1)+rest.length := by
      simp only [List.length_cons]; omega
    rw [length]
    exact stepRemaining

/-! ## 3. The tail-entry derivation at the accepted-break state -/

/-- The `TailCells` class at the loop entry state: the external argument
    cells and `comp` from the executed argument binding, the `logn`/`ter`
    profile locals and the six automatic-object cells from the declaration
    allocation and prologue assignments (pinned to 10/1 by the M0 profile
    of the fk object), all preserved by the readiness gate call. -/
theorem entry_tail_cells (env : Env) (caller bound after : State) (primes rev : ArrayPointer)
    (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original env.ctx bound primes rev)
    (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params
      (KeygenMakeArguments.values env.args) bound)
    (readyPrefix : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩) :
    KeygenMakeInvocation.TailCells env after := by
  cases readyPrefix with
  | run objects initialized dimensioned idx1 idx2 declarations counter dimensions gate =>
    have objectsEq : objects=KeygenMakePrologue.declared bound env.blocks := by
      cases declarations; rfl
    subst objects
    have initializedEq :
        initialized=KeygenMakePrologue.counted (KeygenMakePrologue.declared bound env.blocks) :=
      congrArg Result.state
        (KeygenMakePrologue.count_result bound env.blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have initial := KeygenMakePrologue.initial env.ctx bound
      (KeygenMakePrologue.declared bound env.blocks) primes rev original env.blocks declarations
    have profile : KeygenSearchContext.M0
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared bound env.blocks)).heap env.ctx :=
      initial.profile
    have dimensionsEq :=
      KeygenMakePrologue.dimensions_result env.ctx
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared bound env.blocks)) dimensioned
        profile dimensions
    subst dimensioned
    have call := KeygenMakeReady.gate_normal env.ctx _ after events gate
    have slots := KeygenRngReference.call_slots env.ctx _ after events (.int32 1) call
    have cells := KeygenMakeArguments.actual_cells caller env.args bound binding
    have arrays : after.arrays=(KeygenMakePrologue.ready bound env.blocks).arrays := slots.2.1
    have locals : after.locals=(KeygenMakePrologue.ready bound env.blocks).locals := slots.1
    refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
    · rw [arrays]
      exact (ready_arrays_other bound env.blocks "privkey".toList
        (fun slot => by fin_cases slot <;> decide) (by decide)).trans cells.2.2.1
    · rw [arrays]
      exact (ready_arrays_other bound env.blocks "privkey_len".toList
        (fun slot => by fin_cases slot <;> decide) (by decide)).trans cells.2.2.2.1
    · rw [arrays]
      exact (ready_arrays_other bound env.blocks "pubkey".toList
        (fun slot => by fin_cases slot <;> decide) (by decide)).trans cells.2.2.2.2.1
    · rw [arrays]
      exact (ready_arrays_other bound env.blocks "pubkey_len".toList
        (fun slot => by fin_cases slot <;> decide) (by decide)).trans cells.2.2.2.2.2.1
    · rw [locals]
      exact (ready_comp bound env.blocks).trans cells.2.1
    · rw [locals]
      exact ready_logn bound env.blocks
    · rw [locals]
      exact ready_ter bound env.blocks
    · intro slot
      rw [arrays]
      exact ready_arrays_object bound env.blocks ⟨slot.val,by have := slot.isLt; omega⟩
    · rw [arrays]
      exact ready_arrays_object bound env.blocks 4
    · rw [arrays]
      exact ready_arrays_object bound env.blocks 5

/-- The `Dimensions` facts at the loop entry state: the prologue `n`/`logn`/
    `ter` cells under the pinned M0 profile. -/
theorem entry_dimensions (env : Env) (bound after : State) (primes rev : ArrayPointer)
    (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original env.ctx bound primes rev)
    (readyPrefix : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩) :
    KeygenMakeSearchPrefix.Dimensions after := by
  cases readyPrefix with
  | run objects initialized dimensioned idx1 idx2 declarations counter dimensions gate =>
    have objectsEq : objects=KeygenMakePrologue.declared bound env.blocks := by
      cases declarations; rfl
    subst objects
    have initializedEq :
        initialized=KeygenMakePrologue.counted (KeygenMakePrologue.declared bound env.blocks) :=
      congrArg Result.state
        (KeygenMakePrologue.count_result bound env.blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have initial := KeygenMakePrologue.initial env.ctx bound
      (KeygenMakePrologue.declared bound env.blocks) primes rev original env.blocks declarations
    have profile : KeygenSearchContext.M0
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared bound env.blocks)).heap env.ctx :=
      initial.profile
    have dimensionsEq :=
      KeygenMakePrologue.dimensions_result env.ctx
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared bound env.blocks)) dimensioned
        profile dimensions
    subst dimensioned
    have call := KeygenMakeReady.gate_normal env.ctx _ after events gate
    have slots := KeygenRngReference.call_slots env.ctx _ after events (.int32 1) call
    have locals : after.locals=(KeygenMakePrologue.ready bound env.blocks).locals := slots.1
    exact KeygenMakeCertChronology.dimensions_cells locals (ready_dimensions bound env.blocks)

/-- The `Remaining 0` loop-entry instance: the readiness prefix pins the
    attempt counter to 0 and the prologue dimensions. -/
theorem entry_remaining (env : Env) (bound after : State) (primes rev : ArrayPointer)
    (events : List KeygenEntropySource.Event)
    (original : KeygenMakeEntry.Original env.ctx bound primes rev)
    (readyPrefix : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩) :
    KeygenMakeSearchPrefix.Remaining after 0 :=
  ⟨(KeygenMakeReady.normal_prefix env.ctx bound after env.blocks primes rev original events
      readyPrefix).1,
    entry_dimensions env bound after primes rev events original readyPrefix,by decide⟩

/-- THE derivation of the `TailCells` class across rejected attempts: the
    class holds at the loop entry and survives every attempt instance, so at
    the accepted-break state (the encoding-tail entry) of a successful
    capped loop the tail-entry cells hold. -/
theorem tail_cells_of_loop (env : Env) (caller bound after : State) (primes rev : ArrayPointer)
    (events : List KeygenEntropySource.Event) (loopOut : Result)
    (attempts : List (KeygenMakeCertChronology.AttemptExecution env.ctx))
    (original : KeygenMakeEntry.Original env.ctx bound primes rev)
    (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params
      (KeygenMakeArguments.values env.args) bound)
    (readyPrefix : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩)
    (loop : KeygenMakeCertChronology.LoopTrace env.ctx after loopOut attempts)
    (succeeded : loopOut.flow=.normal) : KeygenMakeInvocation.TailCells env loopOut.state :=
  loop_tail_cells env after loopOut attempts loop 0
    (entry_remaining env bound after primes rev events original readyPrefix)
    (entry_tail_cells env caller bound after primes rev events original binding readyPrefix)
    succeeded

/-- THE composition of the loop-trace chronology of the per-retry transport
    with the derivation of the `TailCells` class: at the accepted-break
    state of a successful capped loop the tail-entry cells hold, the
    per-retry `Initial`/legal/static facts have been transported through
    every rejected attempt instance and the loop counter advanced by the
    attempt count. -/
theorem loop_tail_entry (env : Env) (caller bound after : State) (primes rev : ArrayPointer)
    (events : List KeygenEntropySource.Event) (loopOut : Result)
    (attempts : List (KeygenMakeCertChronology.AttemptExecution env.ctx))
    (original : KeygenMakeEntry.Original env.ctx bound primes rev)
    (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params
      (KeygenMakeArguments.values env.args) bound)
    (readyPrefix : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩)
    (loop : KeygenMakeCertChronology.LoopTrace env.ctx after loopOut attempts)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call env.ctx s t w ret →
        KeygenMakeRetryTransport.CertEntryFrame env.ctx s.heap t.heap primes rev)
    (succeeded : loopOut.flow=.normal) :
    KeygenMakeInvocation.TailCells env loopOut.state ∧
      KeygenCallerEntry.Initial env.ctx loopOut.state (KeygenMakeEntry.input env.blocks)
        (KeygenMakeEntry.publicPointer env.blocks) primes rev ∧
      KeygenMakeSearchPrefix.Remaining loopOut.state attempts.length ∧
      KeygenMakeRetryTransport.EntryFrame env.ctx after.heap loopOut.state.heap primes rev := by
  have normal := KeygenMakeReady.normal_prefix env.ctx bound after env.blocks primes rev original
    events readyPrefix
  obtain ⟨stepInitial,stepRemaining,stepFrame⟩ := loop_retry_entry env.ctx after loopOut attempts loop
    (KeygenMakeEntry.input env.blocks) (KeygenMakeEntry.publicPointer env.blocks) primes rev 0
    (entry_remaining env bound after primes rev events original readyPrefix)
    normal.2.1 certFrame succeeded
  exact ⟨tail_cells_of_loop env caller bound after primes rev events loopOut attempts original
      binding readyPrefix loop succeeded,by simpa using stepInitial,by simpa using stepRemaining,
      stepFrame⟩

end FT1536.Source3.KeygenMakeLoopChronology
