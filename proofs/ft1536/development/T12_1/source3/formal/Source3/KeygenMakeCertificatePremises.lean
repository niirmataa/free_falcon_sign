import Source3.KeygenMakeLoopChronology
import Source3.KeygenMakeWorkspaceAllocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE reachable-state repair of the `invocation_certificate` premises.
   The 060/061 shape of that theorem consumed the two global quantifiers
   `(s : State) → KeygenMakeSearchPrefix.Dimensions s` and
   `(s : State) → KeygenMakeCertMaterial.LegalWorkspace s env.ctx`. The
   first is UNSATISFIABLE (kernel refutation `no_global_dimensions` below,
   mirroring the S05 cross-lane witness `GlobalDimensionsObstruction017`
   at commit `ef354c48`, pinned read-only and never imported), so the
   success branch of the theorem was vacuous. This module replaces both
   quantifiers with REACHABLE-STATE derivations along the actual execution
   chronology:

   * the gate-state `Dimensions` are DERIVED by the attempt-level
     `Remaining` transport to the certificate-gate state
     (`attempt_gate_dimensions`) folded over the whole capped loop on the
     successful edge (`loop_gate_reachable`), starting from the
     allocation-derived loop-entry facts of `entry_dimensions`/
     `entry_remaining` (consumed through `entry_of_allocation`);
   * the gate-state `LegalWorkspace` is DERIVED at that same reachable
     state (`gate_workspace`) from the transported scratch legality and
     automatic-object space (both frame-preserved facts of the `Initial`
     class), the allocation `Shape` of the `fk->tmp` workspace, and the
     gate call's own bridge field (`workspace_scratch_block` fixes
     `ctx.scratch.block=0` per bind -- never an assumption).

   `invocation_certificate_reachable` is the repaired export: the same
   conclusion as `invocation_certificate` (the accepted certificate call
   and its complete `CertPackage` at the gate call of this invocation),
   with the premises reduced to reachable entry facts (the
   allocation-derived `Original` at the argument-binding state, the
   executed readiness prefix, the workspace `Shape`, the entry
   `C99Automatic32.Space` bound and the named `CertEntryFrame` residual).
   Every remaining premise class is reachable and achievable: `Original`
   and `Remaining 0` come from `entry_of_allocation` over the pinned
   prologue, `Shape` from the executed workspace allocation binding, and
   `LegalWorkspace` at the gate state is constructed (not assumed) by
   `gate_workspace`. No all-state quantifier, no codec outcome, no exact
   encoded length and no codec write frame appears as a premise. The loop
   chronology and the `TailCells` derivation of
   `Source3.KeygenMakeLoopChronology` are consumed, never re-derived by
   assumption. Not a review, not a codec claim and not a law claim;
   B1.08/09 and B4/B5 stay outside. -/
namespace FT1536.Source3.KeygenMakeCertificatePremises
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)

/-! ## 0. The trap record: unbounded state quantifiers are uninhabited -/

/-- The empty-locals state has no `Dimensions` instance: the `logn` cell
    cannot read `some` from a state whose locals are all `none`. Kernel
    mirror of the S05 witness `empty_locals_not_dimensions` (read-only
    cross-lane pin). -/
theorem empty_locals_not_dimensions (caller : State) :
    ¬KeygenMakeSearchPrefix.Dimensions {caller with locals := fun _ => none} := by
  intro h
  have impossible := h.2.1
  cases impossible

/-- THE trap record of the 062 premise class: the unqualified all-`State`
    `Dimensions` quantifier of the 060/061 `invocation_certificate` is
    UNSATISFIABLE, so every success conclusion drawn under it was vacuous.
    The repaired premises below live only at reachable states of the
    execution chronology. -/
theorem no_global_dimensions (caller : State) :
    ¬((s : State) → KeygenMakeSearchPrefix.Dimensions s) := by
  intro all
  exact empty_locals_not_dimensions caller (all {caller with locals := fun _ => none})

/-! ## 1. The attempt-level Remaining transport to the certificate gate -/

/-- THE attempt-level `Remaining` transport to the certificate-gate state:
    the sampled prefix of a `throughCertificate` attempt carries the
    advanced `Remaining` instance of the attempt to its certificate-entry
    state, so the gate-state `Dimensions` are DERIVED at that reachable
    state -- the quantifier over all states is never used. -/
theorem attempt_gate_dimensions (ctx : Context) (before : State) (raw : Result) (i : Nat)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (sample : KeygenMakeSearchPrefix.Sampled ctx before raw) :
    KeygenMakeSearchPrefix.Dimensions raw.state :=
  (KeygenMakeSearchPrefix.sampled_remaining ctx before raw i remaining sample).2.1.2.1

/-- THE certificate-gate premises of one accepted attempt: on the accepted
    break of a `throughCertificate` attempt the gate call exists (the gate
    is mandatory under the derived `Profile`), and the gate state carries
    the DERIVED `Dimensions`, the transported `Initial`/legal/static facts
    and the entry frame from the attempt input. No all-state quantifier and
    no workspace premise is used at this level. -/
theorem attempt_gate_reachable (ctx : Context) (before : State) (out : Result) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (remaining : KeygenMakeSearchPrefix.Remaining before i)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (source : KeygenMakeCertChronology.AttemptExec ctx before out)
    (accepted : out.flow=Flow.breakLoop) :
    ∃ (rawState afterState : State) (v : Value),
      KeygenMakeCertCall.Call ctx rawState afterState v true ∧
      KeygenMakeSearchPrefix.Dimensions rawState ∧
      KeygenCallerEntry.Initial ctx rawState input h primes rev ∧
      KeygenMakeRetryTransport.EntryFrame ctx before.heap rawState.heap primes rev := by
  cases source with
  | earlyRejected _ _ rejected =>
    rw [rejected] at accepted
    cases accepted
  | throughCertificate raw sample atCert _ gate =>
    have dims := attempt_gate_dimensions ctx before raw i remaining sample
    have profile := KeygenMakeCertCall.profile_of_dimensions raw.state dims
    obtain ⟨afterState,v,call,_⟩ :=
      KeygenMakeCertCall.accepted_break_requires_call ctx raw.state out gate profile accepted
    obtain ⟨gateInitial,gateFrame⟩ :=
      KeygenMakeRetryTransport.sampled_entry ctx before raw i input h primes rev remaining initial
        sample
    exact ⟨raw.state,afterState,v,call,dims,gateInitial,gateFrame⟩

/-! ## 2. The workspace class at a reachable gate state -/

/-- `C99Automatic32.Space` is a function of the block-0 heap size, so it
    transports along every entry frame (`EntryFrame.sizes`). -/
theorem space_of_frame (ctx : Context) (before after : Memory) (primes rev : ArrayPointer)
    (frame : KeygenMakeRetryTransport.EntryFrame ctx before after primes rev)
    (space : C99Automatic32.Space before) : C99Automatic32.Space after := by
  have zero : after.size 0=before.size 0 := congrFun frame.sizes 0
  show C99Automatic32.align4 (after.size 0)+4<2^64
  rw [zero]
  show C99Automatic32.Space before
  exact space

/-- THE reachable-state derivation of the workspace class: at any state
    carrying the transported scratch legality and the automatic-object
    space, every `CertBind` of that state has a legal certificate frame.
    The canonical block-0 numbering is read off the bind's own bridge
    field (`workspace_scratch_block`), never assumed; the workspace
    `Shape` is the allocation-derived extent/alignment of `ctx.scratch`. -/
theorem gate_workspace (ctx : Context) (s : State)
    (shape : KeygenMakeWorkspaceBridge.Shape ctx)
    (scratchLegal : KeygenMkgm3Layout.Legal s.heap ctx.scratch)
    (space : C99Automatic32.Space s.heap) :
    KeygenMakeCertMaterial.LegalWorkspace s ctx := by
  intro args bind
  have block0 : ctx.scratch.block=0 := KeygenMakeCertMaterial.workspace_scratch_block s ctx args bind
  exact KeygenMakeWorkspaceBridge.legalWorkspace_of_shape s ctx shape scratchLegal block0 space args
    bind

/-! ## 3. The loop-fold to the accepted final attempt -/

/-- THE loop-trace chronology transport of the certificate-gate premises:
    on the successful edge of a whole `LoopTrace` the rejected attempts
    chain to the accepted final attempt, carrying the `Remaining` counter,
    the `Initial`/legal/static facts and the automatic-object space to the
    certificate-gate state of that final attempt -- where the gate
    premises hold in their DERIVED reachable form. -/
theorem loop_gate_reachable (ctx : Context) (before : State) (out : Result)
    (attempts : List (KeygenMakeCertChronology.AttemptExecution ctx))
    (loop : KeygenMakeCertChronology.LoopTrace ctx before out attempts)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer) :
    ∀ (i : Nat), KeygenMakeSearchPrefix.Remaining before i →
      KeygenCallerEntry.Initial ctx before input h primes rev →
      C99Automatic32.Space before.heap →
      (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
        KeygenMakeCertCall.Call ctx s t w ret →
          KeygenMakeRetryTransport.CertEntryFrame ctx s.heap t.heap primes rev) →
      out.flow=.normal →
      ∃ (rawState afterState : State) (v : Value),
        KeygenMakeCertCall.Call ctx rawState afterState v true ∧
        KeygenMakeSearchPrefix.Dimensions rawState ∧
        KeygenCallerEntry.Initial ctx rawState input h primes rev ∧
        C99Automatic32.Space rawState.heap := by
  induction loop with
  | exhausted _b _o _cap exit =>
    intro i remaining initial space certFrame succeeded
    exact (exit succeeded).elim
  | accepted a _last =>
    intro i remaining initial space certFrame succeeded
    have acceptedFlow : a.out.flow=Flow.breakLoop := _last
    obtain ⟨rawState,afterState,v,call,dims,gateInitial,gateFrame⟩ :=
      attempt_gate_reachable ctx a.before a.out i input h primes rev remaining initial a.source
        acceptedFlow
    refine ⟨rawState,afterState,v,call,dims,gateInitial,?_⟩
    exact space_of_frame ctx a.before.heap rawState.heap primes rev gateFrame space
  | retry a _out _rest _rejected _tail ih =>
    intro i remaining initial space certFrame succeeded
    have advanced : KeygenMakeSearchPrefix.Remaining a.out.state (i+1) :=
      (KeygenMakeCertChronology.attempt_remaining ctx a.before a.out i remaining a.source).2.1
    have stepInitial : KeygenCallerEntry.Initial ctx a.out.state input h primes rev :=
      KeygenMakeRetryTransport.initial_of_attempt ctx a.before a.out i input h primes rev remaining
        initial a.source certFrame
    have stepFrame : KeygenMakeRetryTransport.EntryFrame ctx a.before.heap a.out.state.heap primes
        rev :=
      KeygenMakeRetryTransport.frame_of_attempt ctx a.before a.out i input h primes rev remaining
        initial a.source certFrame
    exact ih (i+1) advanced stepInitial
      (space_of_frame ctx a.before.heap a.out.state.heap primes rev stepFrame space) certFrame
      succeeded

/-! ## 4. The repaired certificate export -/

/-- THE reachable-state replacement of the `invocation_certificate`
    premises: given the entry facts of one whole invocation (the executed
    argument binding state's allocation facts, the readiness prefix, the
    capped loop chronology), the workspace allocation `Shape`, the entry
    space bound and the named certificate-call entry-frame residual, a
    successful loop yields the accepted mandatory certificate call of THIS
    invocation at its gate state and the complete `CertPackage` there --
    with `Dimensions`/`LegalWorkspace` DERIVED at that reachable state in
    place of the uninhabited all-state quantifiers. The entry facts come
    from `entry_of_allocation` over the pinned prologue; the loop
    chronology of `Source3.KeygenMakeLoopChronology` is consumed. -/
theorem invocation_certificate_reachable (env : Env) (bound after : State)
    (primes rev : ArrayPointer) (events : List KeygenEntropySource.Event) (loopOut : Result)
    (attempts : List (KeygenMakeCertChronology.AttemptExecution env.ctx))
    (original : KeygenMakeEntry.Original env.ctx bound primes rev)
    (readyPrefix : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩)
    (loop : KeygenMakeCertChronology.LoopTrace env.ctx after loopOut attempts)
    (shape : KeygenMakeWorkspaceBridge.Shape env.ctx)
    (space : C99Automatic32.Space after.heap)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call env.ctx s t w ret →
        KeygenMakeRetryTransport.CertEntryFrame env.ctx s.heap t.heap primes rev)
    (succeeded : loopOut.flow=.normal) :
    ∃ (rawState afterState : State) (v : Value),
      KeygenMakeCertCall.Call env.ctx rawState afterState v true ∧
      KeygenMakeInvocation.CertPackage env.ctx rawState afterState := by
  have facts := KeygenMakeAttemptSpine.entry_of_allocation env.ctx bound after env.blocks primes rev
    events original readyPrefix
  obtain ⟨rawState,afterState,v,call,dims,gateInitial,gateSpace⟩ :=
    loop_gate_reachable env.ctx after loopOut attempts loop (KeygenMakeEntry.input env.blocks)
      (KeygenMakeEntry.publicPointer env.blocks) primes rev 0 facts.2 facts.1 space certFrame
      succeeded
  have workspace := gate_workspace env.ctx rawState shape gateInitial.scratch gateSpace
  exact ⟨rawState,afterState,v,call,
    KeygenMakeInvocation.cert_package env.ctx rawState afterState v call dims workspace⟩

/-- THE repaired `invocation_certificate` at the whole-invocation level:
    the same conclusion as the 060/061 theorem (the accepted certificate
    call and its `CertPackage` at the gate call of THIS invocation), with
    the premises reduced to (i) the reachable entry facts of the
    invocation's own readiness-prefix boundary (the allocation-derived
    `Original` and the entry space bound -- achievable facts of the
    executed prologue), (ii) the workspace allocation `Shape`, and (iii)
    the named `CertEntryFrame` residual. The uninhabited all-state
    `Dimensions`/`LegalWorkspace` quantifiers are gone: the gate-state
    instances are derived along the execution chronology. -/
theorem invocation_certificate_of_entry (env : Env) (caller : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : KeygenMakeInvocation.Invocation env caller events out)
    (success : out.flow=.returned (some (.int32 1)))
    (primes rev : ArrayPointer)
    (shape : KeygenMakeWorkspaceBridge.Shape env.ctx)
    (certFrame : ∀ (s t : State) (w : Value) (ret : Bool),
      KeygenMakeCertCall.Call env.ctx s t w ret →
        KeygenMakeRetryTransport.CertEntryFrame env.ctx s.heap t.heap primes rev)
    (entry : ∀ (bound after : State),
      KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩ →
        KeygenMakeEntry.Original env.ctx bound primes rev ∧
          C99Automatic32.Space after.heap) :
    ∃ (rawState afterState : State) (v : Value),
      KeygenMakeCertCall.Call env.ctx rawState afterState v true ∧
      KeygenMakeInvocation.CertPackage env.ctx rawState afterState := by
  cases source with
  | encoded bound after loopOut attempts tailOut binding readyPrefix loop succeeded cells legal
      tail =>
    obtain ⟨original,space⟩ := entry bound after readyPrefix
    exact invocation_certificate_reachable env bound after primes rev events loopOut attempts
      original readyPrefix loop shape space certFrame succeeded
  | capped bound after loopOut attempts binding readyPrefix loop aborted =>
    rw [KeygenMakeLifetime.close_flow,aborted] at success
    have different : (KeygenCapExecution.abortFlow : Flow)≠.returned (some (.int32 1)) := by decide
    exact (different success).elim

end FT1536.Source3.KeygenMakeCertificatePremises
