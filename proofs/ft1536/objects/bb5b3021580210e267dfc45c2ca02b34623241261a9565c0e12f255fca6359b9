import Source3.KeygenMakeAttemptSpine
import Source3.KeygenMakeWorkspaceAllocation
import Source3.CertificateFunctionFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE solver-call frame on EVERY edge of the solver gate: the rejected
    edges (early search rejection, the failed output gate with its PARTIAL
    output-gate writes, and a validation suffix returning zero) keep every
    byte of any protected block, in particular the public h block. This is
    the rejected-edge half of the retry-frame item; the per-retry
    `Initial`/legal/static transport and the gate-time `ReadTmp` tie consume
    it in the next step. The validation-body frame is derived from the raw
    source legs (no accepted-flow premise); the small output body keeps its
    bytes in the destination arrays even when the conversion loop stops half
    way. No certificate outcome, equation or codec fact is a premise. Not a
    review and not a law claim. -/
namespace FT1536.Source3.KeygenMakeRetryFrames
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open ShakeExtractFrame (SameBlock)

/-! ## 1. The write footprint of the small output body -/

/-- Read-only sub-statements (locals only) and `store16` writes confined to
    the named destinations; `plain` calls write only locals. -/
def writesOnly (names : List Name) : KeygenSmallSource.Stmt → Bool
  | .modular code => C99ModularFrame.readOnly code
  | .plain _ _ _ => true
  | .store16 dst _ _ => names.contains dst
  | .seq a b => writesOnly names a && writesOnly names b
  | .scope _ body => writesOnly names body
  | .branch _ yes no => writesOnly names yes && writesOnly names no
  | .loop _ body inc => writesOnly names body && writesOnly names inc

/-- A checked small body keeps every byte of blocks outside the destination
    bindings and keeps the array map: the loop of a rejected conversion may
    stop half way, but its partial writes still land only in the named
    destination arrays. -/
theorem small_frame (names : List Name) (block offset : Nat) :
    ∀ (code : KeygenSmallSource.Stmt) (before : State) (out : Result)
      (_source : KeygenSmallSource.Exec code before out),
      writesOnly names code=true →
      (∀ name, name∈names → ∀ p, before.arrays name=some p → p.block≠block) →
      out.state.arrays=before.arrays ∧
        out.state.heap.bytes block offset=before.heap.bytes block offset := by
  intro code before out source
  induction source with
  | modular code before out source =>
    intro checked outside
    have frame := C99ModularFrame.source_frame code before out source checked
    exact ⟨frame.2,congrArg (fun m : Memory => m.bytes block offset) frame.1⟩
  | plain dst src index before p ty old v address declared call =>
    intro checked outside
    exact ⟨rfl,rfl⟩
  | store16 dst index value before after p v address evaluated store =>
    intro checked outside
    have member : dst∈names := List.contains_iff_mem.mp checked
    cases address with
    | add root qptr i bound ev nonnegative within =>
      have different : block≠root.block := Ne.symm (outside dst member root bound)
      cases within
      refine ⟨rfl,?_⟩
      exact store.2.2.2.2.2.2 block offset (Or.inl different)
  | seqNormal first second before middle out head tail ih1 ih2 =>
    intro checked outside
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    have headFrame := ih1 ha outside
    have middleArrays : middle.arrays=before.arrays := headFrame.1
    have middleBytes : middle.heap.bytes block offset=before.heap.bytes block offset := headFrame.2
    have tailFrame := ih2 hb (fun name member p binding =>
      outside name member p (by rw [← middleArrays]; exact binding))
    exact ⟨tailFrame.1.trans middleArrays,tailFrame.2.trans middleBytes⟩
  | seqExit first second before out head exit ih =>
    intro checked outside
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | scope locals body before out inner ih =>
    intro checked outside
    have innerFrame := ih checked outside
    constructor
    · funext name
      simp only [C99ArrayReference.restoreScope,List.contains_nil]
      exact congrFun innerFrame.1 name
    · have keep : (C99ArrayReference.restoreScope before out.state locals []).heap=out.state.heap := rfl
      rw [keep]
      exact innerFrame.2
  | branchTrue condition yes no before out v guard nonzero body ih =>
    intro checked outside
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside
  | branchFalse condition yes no before out v guard zero body ih =>
    intro checked outside
    exact ih (Bool.and_eq_true_iff.mp checked).2 outside
  | loopFalse condition body increment before v guard zero =>
    intro checked outside
    exact ⟨rfl,rfl⟩
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    intro checked outside
    obtain ⟨checkedBody,checkedInc⟩ := Bool.and_eq_true_iff.mp checked
    have bodyFrame := ih1 checkedBody outside
    have bodyArrays : middle.arrays=before.arrays := bodyFrame.1
    have updateFrame := ih2 checkedInc (fun name member p binding =>
      outside name member p (by rw [← bodyArrays]; exact binding))
    have nextArrays : next.arrays=before.arrays := updateFrame.1.trans bodyArrays
    have nextBytes : next.heap.bytes block offset=before.heap.bytes block offset :=
      updateFrame.2.trans bodyFrame.2
    have restFrame := ih3 checked (fun name member p binding =>
      outside name member p (by rw [← nextArrays]; exact binding))
    exact ⟨restFrame.1.trans nextArrays,restFrame.2.trans nextBytes⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
    intro checked outside
    exact ih (Bool.and_eq_true_iff.mp checked).1 outside

theorem writes_gate_code : writesOnly ["d".toList] KeygenSmallSource.code=true := by decide

/-! ## 2. The output-gate bytes frame, rejected edges included -/

/-- One `poly_big_to_small` call keeps every byte outside its destination
    block; the destination is the bound `d` parameter, the `F` or `G` caller
    array. -/
theorem call_bytes (ctx : KeygenOutputGateSource.Context) (second : Bool) (bigF bigG : ArrayPointer)
    (before after : State) (v : Value) (m0 : ctx.ternary=1)
    (caller : KeygenOutputGateBounds.Caller before bigF bigG)
    (source : KeygenOutputGateSource.Call ctx (KeygenOutputGateSource.arguments second) before after v)
    (block : Nat) (sepF : block≠bigF.block) (sepG : block≠bigG.block) :
    ∀ offset, after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out value binding body returned =>
    have destination : before.arrays
        (KeygenOutputGateBounds.destinationName second).toList=some (if second then bigG else bigF) := by
      cases second
      · exact caller.first
      · exact caller.second
    have fields := KeygenOutputGateBounds.binding_entry ctx before entry second
      (if second then bigG else bigF) m0 caller.logn caller.size destination binding
    have separated : block≠(if second then bigG else bigF).block := by
      cases second
      · exact sepF
      · exact sepG
    intro offset
    have keep := (small_frame ["d".toList] block offset KeygenSmallSource.code entry out body
      writes_gate_code (fun name member p binding' => by
        have equal : name="d".toList := List.mem_singleton.mp member
        subst name
        have same : p=(if second then bigG else bigF) :=
          Option.some.inj (binding'.symm.trans fields.2.1)
        subst p
        exact Ne.symm separated)).2
    have heapEq : entry.heap=before.heap :=
      (C99ArrayReference.bind_heap (KeygenOutputGateSource.view ctx before) KeygenSmallCalls.params
        (List.map KeygenOutputGateSource.lower (KeygenOutputGateSource.arguments second)) entry
        binding).trans rfl
    exact keep.trans (congrArg (fun m : Memory => m.bytes block offset) heapEq)

/-- A negated call evaluation executes exactly one conversion call. -/
theorem negate_call (ctx : KeygenOutputGateSource.Context) (args : List KeygenOutputGateSource.Argument)
    (before after : State) (flag : Bool) (source : KeygenOutputGateSource.Evaluate ctx
      (KeygenOutputGateSource.Condition.negate (KeygenOutputGateSource.Condition.call args))
      before after flag) :
    ∃ v : Value, KeygenOutputGateSource.Call ctx args before after v := by
  cases source with
  | negate value before after v inner =>
    cases inner with
    | call args before after v body => exact ⟨v,body⟩

/-- A failed gate guard keeps every byte outside the F/G destination blocks:
    short-circuit rejection writes at most a partial F column, the two-call
    rejection may also leave a partial G column. -/
theorem failed_guard_bytes (ctx : KeygenOutputGateSource.Context) (bigF bigG : ArrayPointer)
    (before after : State) (m0 : ctx.ternary=1)
    (caller : KeygenOutputGateBounds.Caller before bigF bigG)
    (guard : KeygenOutputGateSource.Evaluate ctx KeygenOutputGateSource.condition before after true)
    (block : Nat) (sepF : block≠bigF.block) (sepG : block≠bigG.block) :
    ∀ offset, after.heap.bytes block offset=before.heap.bytes block offset := by
  cases guard with
  | shortCircuit gLeft gRight gSkip gAfter gFirst =>
    obtain ⟨v,call⟩ := negate_call ctx _ before after true gFirst
    exact call_bytes ctx false bigF bigG before after v m0 caller call block sepF sepG
  | second gLeft gRight gSkip gMiddle gAfter gFlag gFirst gSecond =>
    obtain ⟨va,firstCall⟩ := negate_call ctx _ before gMiddle false gFirst
    have callerM := KeygenOutputGateBounds.caller_preserved ctx _ before gMiddle va bigF bigG caller firstCall
    obtain ⟨vb,secondCall⟩ := negate_call ctx _ gMiddle after true gSecond
    intro offset
    exact (call_bytes ctx true bigF bigG gMiddle after vb m0 callerM secondCall block sepF sepG offset).trans
      (call_bytes ctx false bigF bigG before gMiddle va m0 caller firstCall block sepF sepG offset)

/-- A passing gate guard keeps every byte outside the F/G destination
    blocks: both conversions run to completion. -/
theorem passed_guard_bytes (ctx : KeygenOutputGateSource.Context) (bigF bigG : ArrayPointer)
    (before after : State) (m0 : ctx.ternary=1)
    (caller : KeygenOutputGateBounds.Caller before bigF bigG)
    (guard : KeygenOutputGateSource.Evaluate ctx KeygenOutputGateSource.condition before after false)
    (block : Nat) (sepF : block≠bigF.block) (sepG : block≠bigG.block) :
    ∀ offset, after.heap.bytes block offset=before.heap.bytes block offset := by
  cases guard with
  | second gLeft gRight gSkip gMiddle gAfter gFlag gFirst gSecond =>
    obtain ⟨va,firstCall⟩ := negate_call ctx _ before gMiddle false gFirst
    have callerM := KeygenOutputGateBounds.caller_preserved ctx _ before gMiddle va bigF bigG caller firstCall
    obtain ⟨vb,secondCall⟩ := negate_call ctx _ gMiddle after false gSecond
    intro offset
    exact (call_bytes ctx true bigF bigG gMiddle after vb m0 callerM secondCall block sepF sepG offset).trans
      (call_bytes ctx false bigF bigG before gMiddle va m0 caller firstCall block sepF sepG offset)

/-- THE gate bytes frame on every edge of the output gate, the failed edge
    with its partial output-gate writes included: the guard writes stay in
    F/G and the `return 0` body is state-preserving. -/
theorem gate_frame (ctx : KeygenOutputGateSource.Context) (bigF bigG : ArrayPointer)
    (before : State) (out : Result) (m0 : ctx.ternary=1)
    (caller : KeygenOutputGateBounds.Caller before bigF bigG)
    (source : KeygenOutputGateSource.Exec ctx before out)
    (block : Nat) (sepF : block≠bigF.block) (sepG : block≠bigG.block) :
    ∀ offset, out.state.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | failed middle out guard body =>
    intro offset
    have rejected := KeygenSmallStep.reject_result middle out body
    subst out
    exact failed_guard_bytes ctx bigF bigG before middle m0 caller guard block sepF sepG offset
  | passed after guard =>
    exact passed_guard_bytes ctx bigF bigG before after m0 caller guard block sepF sepG

/-! ## 3. The validation-suffix frame from the raw source legs -/

/-- The four-leg validation suffix keeps every byte outside the scratch
    block on EVERY flow (the final check may return zero): generation writes
    the gm scratch words, the conversion trace writes the four scratch
    views, the transform sequence is scratch-confined and the final check is
    read-only. This is `KeygenMakeMaterialWitness.validation_record_same`
    re-derived from the raw `KeygenRootValidationSource.Exec` legs, with no
    accepted-flow premise. -/
theorem validation_frame (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer)
    (primes rev : ArrayPointer) (entry : KeygenRootValidation.Entry ctx before input primes rev)
    (source : KeygenRootValidationSource.Exec ctx before out) (block : Nat)
    (separate : block≠ctx.scratch.block) :
    SameBlock before.heap out.state.heap block := by
  cases source with
  | run prepared genEntry generated converted transformed out genTernary nttTernary preparation
      genMember genNonzero binding generation genReturn conversion convNormal nttMember nttNonzero
      transforms check =>
    obtain ⟨p0i,state,inverse⟩ := KeygenRootValidationSource.prepared ctx before prepared primes
      entry.size entry.table entry.primeObject preparation
    subst prepared
    have bound := KeygenRootValidationSource.generator_entry before genEntry ctx.scratch primes rev p0i
      entry.logn entry.primeObject entry.revBinding entry.revSource entry.legal binding
    have heapRaw := KeygenLevelCalls.bind_heap _ _ _ _ binding
    have heap : genEntry.heap=before.heap := heapRaw
    have width : ctx.scratch.elementBytes=4 := (bound.2.2.2.2.2.2.2).1
    have genBytes : ∀ offset, generated.state.heap.bytes block offset=genEntry.heap.bytes block offset := by
      intro offset
      exact KeygenMkgm3Frame.outside_bytes KeygenMkgm3Program.code genEntry generated ctx.scratch width
        (by decide) KeygenMkgm3Frame.source_footprint bound.2.2.2.2.1 generation
        block offset (Or.inl separate)
    have inputs := KeygenRootValidation.ready_inputs ctx before input primes rev entry p0i
    have inputsTrace : KeygenResidueTrace.Inputs (KeygenRootValidation.arrays input ctx.scratch)
        (KeygenRootValidationSource.returned (KeygenRootValidationSource.ready before ctx.scratch primes p0i)
          generated) :=
      ⟨inputs.input,inputs.output,inputs.prime,inputs.size⟩
    have caller := KeygenRootValidation.ready_caller ctx before input primes rev entry p0i
    have trace := KeygenResidueLoop.source_trace (KeygenRootValidation.arrays input ctx.scratch)
      (KeygenRootValidationSource.returned (KeygenRootValidationSource.ready before ctx.scratch primes p0i)
        generated) none converted entry.counter inputsTrace conversion
    have outSeparate : ∀ slot : Fin 4,
        block≠((KeygenRootValidation.arrays input ctx.scratch).output slot).block := by
      intro slot bad
      have shape : (KeygenRootValidation.arrays input ctx.scratch).output slot=
          KeygenMkgm3Layout.output ctx.scratch slot := rfl
      have blockEq : ((KeygenRootValidation.arrays input ctx.scratch).output slot).block=
          ctx.scratch.block :=
        (congrArg ArrayPointer.block shape).trans (KeygenMakeMaterialWitness.output_block ctx.scratch slot)
      exact separate (bad.trans blockEq)
    have convBytes : ∀ offset, converted.state.heap.bytes block offset=
        (KeygenRootValidationSource.returned (KeygenRootValidationSource.ready before ctx.scratch primes p0i)
          generated).heap.bytes block offset :=
      KeygenMakeMaterialWitness.trace_bytes (KeygenRootValidation.arrays input ctx.scratch) 0 _ _
        trace.2.2.2 block outSeparate
    have conversionControl := KeygenNttControl.frame KeygenResidueProgram.code
      (KeygenRootValidationSource.returned (KeygenRootValidationSource.ready before ctx.scratch primes p0i)
        generated) converted (by decide) conversion
    have callerOut : KeygenSolverNttCalls.Caller converted.state p0i (KeygenMkgm3Layout.gm ctx.scratch) :=
      ⟨(conversionControl.2.1 _ (by decide)).trans caller.logn,
        (conversionControl.2.1 _ (by decide)).trans caller.prime,
        (conversionControl.2.1 _ (by decide)).trans caller.inverse,
        (congrFun trace.2.2.1 _).trans caller.table⟩
    have bindings : KeygenSolverTransforms.Bindings converted.state ctx.scratch := by
      intro slot
      exact trace.2.1.output slot
    have frame : KeygenNttMemoryFrame.Frame converted.state.heap transformed.heap ctx.scratch :=
      KeygenSolverValidation.sequence_frame [0,1,2,3] converted.state transformed ctx.scratch p0i
        width callerOut bindings (by rw [KeygenSolverTransforms.four_code]; exact transforms)
    have finalHeap : out.state.heap=transformed.heap :=
      KeygenSolverValidation.read_only_heap KeygenSolverTarget.code transformed out (by decide) check
    have genStable := KeygenMemoryStability.modular KeygenMkgm3Program.code genEntry generated generation
    have convStable := KeygenMemoryStability.modular KeygenResidueProgram.code
      (KeygenRootValidationSource.returned (KeygenRootValidationSource.ready before ctx.scratch primes p0i)
        generated) converted conversion
    refine ⟨?_,?_,?_⟩
    · rw [finalHeap]
      have size := frame.1.trans (convStable.size.trans (congrArg Memory.size rfl))
      rw [← heap]
      exact size.trans genStable.size
    · rw [finalHeap]
      have writable := frame.2.1.trans (convStable.writable.trans (congrArg Memory.writable rfl))
      rw [← heap]
      exact writable.trans genStable.writable
    · intro offset
      rw [finalHeap]
      have chain := (frame.2.2 block offset (Or.inl separate)).trans
        ((convBytes offset).trans (congrArg (fun m : Memory => m.bytes block offset) rfl))
      rw [← heap]
      exact chain.trans (genBytes offset)

/-! ## 4. THE solver-call frame on every edge -/

/-- THE solver-call bytes frame on EVERY edge: early search rejection, the
    failed output gate (partial output-gate writes), and the validation
    suffix on either return. Every protected block — in particular the
    public h block — keeps every byte through the call. -/
theorem solver_frame (ctx : Context) (before after : State) (v : Value) (input : Fin 4 → ArrayPointer)
    (_h primes rev : ArrayPointer) (legal : KeygenRootCaller.Legal ctx before input primes rev)
    (source : KeygenRootSource.Call ctx before after v) (block : Nat)
    (protectedBlock : KeygenRootSearch.Protected ctx before block)
    (sepF : block≠(input 2).block) (sepG : block≠(input 3).block) :
    SameBlock before.heap after.heap block := by
  cases source with
  | run entry out v binding body returned =>
    have state := KeygenRootCaller.bind_exact ctx before entry input primes rev legal binding
    subst entry
    have boundHeap : (KeygenRootCaller.bound before ctx input).heap=before.heap := rfl
    have searchProfile : KeygenSearchContext.M0 (KeygenRootCaller.bound before ctx input).heap ctx := by
      simpa only [KeygenRootCaller.bound,C99ArrayReference.bindPointer] using legal.profile
    have searchProtected : KeygenRootSearch.Protected ctx (KeygenRootCaller.bound before ctx input) block := by
      refine ⟨protectedBlock.1,?_⟩
      intro name p tableBinding
      exact protectedBlock.2 name p
        (by simpa only [KeygenRootCaller.bound,C99ArrayReference.bindPointer] using tableBinding)
    have searchBytes (searched : State) (search : KeygenRootSearch.Exec ctx
        (KeygenRootCaller.bound before ctx input) ⟨searched,.normal⟩) :
        SameBlock before.heap searched.heap block := by
      have searchStable := KeygenSearchStability.root ctx (KeygenRootCaller.bound before ctx input)
        ⟨searched,.normal⟩ search
      have frame := KeygenRootSearch.frame ctx (KeygenRootCaller.bound before ctx input)
        ⟨searched,.normal⟩ search searchProfile block searchProtected
      exact ⟨searchStable.size.trans (congrArg Memory.size boundHeap),
        searchStable.writable.trans (congrArg Memory.writable boundHeap),
        fun offset => (frame.2.2.2 offset).trans
          (congrArg (fun m : Memory => m.bytes block offset) boundHeap)⟩
    cases body with
    | searchRejected out search reject =>
      have searchStable := KeygenSearchStability.root ctx (KeygenRootCaller.bound before ctx input) out search
      have frame := KeygenRootSearch.frame ctx (KeygenRootCaller.bound before ctx input) out search
        searchProfile block searchProtected
      refine ⟨?_,?_,?_⟩
      · exact searchStable.size.trans (congrArg Memory.size boundHeap)
      · exact searchStable.writable.trans (congrArg Memory.writable boundHeap)
      · intro offset
        exact (frame.2.2.2 offset).trans
          (congrArg (fun m : Memory => m.bytes block offset) boundHeap)
    | outputRejected searched out search gate reject =>
      obtain ⟨ternary,tmp,member,tmpMember,gateExec⟩ := gate
      have boundEntry := KeygenRootCaller.bound_entry ctx before input primes rev legal
      have hp := KeygenRootObjects.search_profile ctx (KeygenRootCaller.bound before ctx input)
        ⟨searched,.normal⟩ search boundEntry.profile boundEntry.contextProtected
      have ht := KeygenSearchContext.ternary_m0 ctx searched ternary hp member
      have hs := KeygenSearchContext.tmp_value ctx searched tmp tmpMember
      subst ternary tmp
      let view : KeygenOutputGateSource.Context := ⟨1,ctx.scratch⟩
      have caller := KeygenRootSearch.output_caller ctx (KeygenRootCaller.bound before ctx input)
        ⟨searched,.normal⟩ search searchProfile (input 2) (input 3) (boundEntry.inputs 2)
        (boundEntry.inputs 3) block searchProtected
      have head := searchBytes searched search
      have gateStable := KeygenRootObjects.gate view searched out gateExec
      refine ⟨?_,?_,?_⟩
      · exact gateStable.size.trans head.1
      · exact gateStable.writable.trans head.2.1
      · intro offset
        exact (gate_frame view (input 2) (input 3) searched out rfl caller gateExec block sepF sepG offset).trans
          (head.2.2 offset)
    | validated searched passed out search gate validation =>
      obtain ⟨ternary,tmp,member,tmpMember,gateExec⟩ := gate
      have boundEntry := KeygenRootCaller.bound_entry ctx before input primes rev legal
      have hp := KeygenRootObjects.search_profile ctx (KeygenRootCaller.bound before ctx input)
        ⟨searched,.normal⟩ search boundEntry.profile boundEntry.contextProtected
      have ht := KeygenSearchContext.ternary_m0 ctx searched ternary hp member
      have hs := KeygenSearchContext.tmp_value ctx searched tmp tmpMember
      subst ternary tmp
      let view : KeygenOutputGateSource.Context := ⟨1,ctx.scratch⟩
      have caller := KeygenRootSearch.output_caller ctx (KeygenRootCaller.bound before ctx input)
        ⟨searched,.normal⟩ search searchProfile (input 2) (input 3) (boundEntry.inputs 2)
        (boundEntry.inputs 3) block searchProtected
      have head := searchBytes searched search
      have gateStable := KeygenRootObjects.gate view searched ⟨passed,.normal⟩ gateExec
      have gateBytes := gate_frame view (input 2) (input 3) searched ⟨passed,.normal⟩ rfl caller gateExec
        block sepF sepG
      have validationEntry : KeygenRootValidation.Entry ctx passed input primes rev :=
        KeygenRootSource.suffix_entry ctx (KeygenRootCaller.bound before ctx input) searched passed
          input primes rev boundEntry search view gateExec
      have tail := validation_frame ctx passed out input primes rev validationEntry validation block
        (Ne.symm protectedBlock.1)
      refine ⟨?_,?_,?_⟩
      · exact tail.1.trans (gateStable.size.trans head.1)
      · exact tail.2.1.trans (gateStable.writable.trans head.2.1)
      · intro offset
        exact (tail.2.2 offset).trans ((gateBytes offset).trans (head.2.2 offset))

/-- THE solver-call h frame on EVERY edge, the rejected edges included: an
    early search rejection, a failed output gate (whose partial output-gate
    writes land only in F/G) and a validation suffix returning zero all keep
    every byte of the public h block. -/
theorem solver_h_frame (ctx : Context) (before after : State) (v : Value)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (legal : KeygenRootCaller.Legal ctx before input primes rev)
    (source : KeygenRootSource.Call ctx before after v)
    (hProtected : KeygenRootSearch.Protected ctx before h.block)
    (hBigF : h.block≠(input 2).block) (hBigG : h.block≠(input 3).block) :
    SameBlock before.heap after.heap h.block :=
  solver_frame ctx before after v input h primes rev legal source h.block hProtected hBigF hBigG

end FT1536.Source3.KeygenMakeRetryFrames
