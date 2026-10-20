import Source3.KeygenReadyResult
import Source3.KeygenMakePrologue

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete enclosing7805--7838 prefix with ALL readiness source paths.
   Unlike047, normal completion is not restricted to already-ready input.
   Both the caller failure edge and the external entropy events are retained. -/
namespace FT1536.Source3.KeygenMakeReady
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)

theorem block_frame (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event) (v : Value)
    (source : KeygenRngReference.Call ctx before events after v) (block : Nat) (different : block≠ctx.object.block) :
    KeygenMakeObjects.Block before.heap after.heap block := by
  have first := KeygenRngFrame.call_frame ctx before after events v source block 0 (Or.inl different)
  exact ⟨congrFun first.1 block,congrFun first.2.1 block,
    fun o => (KeygenRngFrame.call_frame ctx before after events v source block o (Or.inl different)).2.2⟩
theorem profile_frame (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event) (v : Value)
    (source : KeygenRngReference.Call ctx before events after v) (profile : KeygenSearchContext.M0 before.heap ctx) :
    KeygenSearchContext.M0 after.heap ctx := by
  have size := (KeygenRngFrame.call_frame ctx before after events v source (ctx.object.block+1) 0 (Or.inl (by omega))).1
  constructor
  · apply Gate00Memory.load32_transport _ _ _ _ profile.1 size
    intro i
    exact (KeygenRngFrame.call_frame ctx before after events v source _ _ (Or.inr (Or.inl (by
      have hi := i.isLt; dsimp [KeygenSearchContext.field,ArrayPointer.offset]; omega)))).2.2
  · apply Gate00Memory.load32_transport _ _ _ _ profile.2 size
    intro i
    exact (KeygenRngFrame.call_frame ctx before after events v source _ _ (Or.inr (Or.inl (by
      have hi := i.isLt; dsimp [KeygenSearchContext.field,ArrayPointer.offset]; omega)))).2.2
theorem tmp_frame (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event) (v : Value)
    (source : KeygenRngReference.Call ctx before events after v)
    (word : BitVec 64) (bytes : Load64 before.heap (KeygenSearchContext.field ctx 432 8) word) :
    Load64 after.heap (KeygenSearchContext.field ctx 432 8) word := by
  cases bytes with
  | load data allocated width values =>
    have first := KeygenRngFrame.call_frame ctx before after events v source (ctx.object.block+1) 0 (Or.inl (by omega))
    refine .load _ _ data (by simpa only [Allocated,first.1] using allocated) width ?_
    intro i
    exact (KeygenRngFrame.call_frame ctx before after events v source _ _ (Or.inr (Or.inr (by
      dsimp [KeygenSearchContext.field,ArrayPointer.offset]; omega)))).2.2.trans (values i)
theorem initial_frame (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event) (v : Value)
    (source : KeygenRngReference.Call ctx before events after v) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx before input h primes rev) : KeygenCallerEntry.Initial ctx after input h primes rev := by
  have slots := KeygenRngReference.call_slots ctx before after events v source
  have size := (KeygenRngFrame.call_frame ctx before after events v source (ctx.object.block+1) 0 (Or.inl (by omega))).1
  have writable := (KeygenRngFrame.call_frame ctx before after events v source (ctx.object.block+1) 0 (Or.inl (by omega))).2.1
  refine ⟨slots.2.1 ▸ initial.context,fun slot => slots.2.1 ▸ initial.inputs slot,slots.2.1 ▸ initial.publicPointer,
    profile_frame ctx before after events v source initial.profile,slots.2.2.2 ▸ initial.table,
    KeygenMakeEntry.prime_block _ _ primes (block_frame ctx before after events v source primes.block
      (initial.contextTables _ _ initial.table)) initial.primeObject,slots.2.2.2 ▸ initial.revBinding,
    KeygenMakeEntry.rev_block _ _ rev (block_frame ctx before after events v source rev.block
      (initial.contextTables _ _ initial.revBinding)) initial.revSource,
    ?_,?_,initial.width,initial.scratchSeparate,initial.distinct,initial.contextSeparate,initial.contextScratch,
    ?_,?_,initial.publicSeparate,initial.publicContext,?_⟩
  · simpa only [KeygenMkgm3Layout.Legal,size,writable] using initial.scratch
  · intro slot; simpa only [Allocated,size] using initial.allocated slot
  · simpa only [slots.2.2.2] using initial.contextTables
  · simpa only [slots.2.2.2] using initial.inputTables
  · simpa only [slots.2.2.2,size] using initial.staticLive
def returnedZero : C99ProcedureReference.Stmt := .ret (some (.scalar (.literal .i32 0)))
inductive Gate (ctx : Context) (before : State) : List KeygenEntropySource.Event → Result → Prop where
  | normal (events : List KeygenEntropySource.Event) (after : State) (word : BitVec 32) (v : Value)
      (call : KeygenRngReference.Call ctx before events after (.int32 word))
      (test : KeygenReadyFast.NotTest after word v) (zero : v.integer=0) : Gate ctx before events ⟨after,.normal⟩
  | failure (events : List KeygenEntropySource.Event) (after : State) (word : BitVec 32) (v : Value) (out : Result)
      (call : KeygenRngReference.Call ctx before events after (.int32 word))
      (test : KeygenReadyFast.NotTest after word v) (nonzero : v.integer≠0)
      (returned : C99ProcedureReference.Exec (fun _ => none) returnedZero after out) : Gate ctx before events out
theorem failure_result (before : State) (out : Result)
    (source : C99ProcedureReference.Exec (fun _ => none) returnedZero before out) : out=⟨before,.returned (some (.int32 0))⟩ := by
  cases source with
  | returnValue s e v value => cases value with | scalar e v evaluated => cases evaluated; rfl
theorem gate_normal (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event)
    (source : Gate ctx before events ⟨after,.normal⟩) : KeygenRngReference.Call ctx before events after (.int32 1) := by
  cases source with
  | normal after word v call test zero =>
    have nonzero := KeygenReadyFast.skipped_nonzero after word v test zero
    rcases KeygenReadyResult.call_value ctx before after events (.int32 word) call with h | h
    · rw [h] at nonzero; exact False.elim (nonzero (by rfl))
    · rw [h] at call; exact call
  | failure after word v out call test nonzero returned =>
    have bad := congrArg Result.flow (failure_result after ⟨_,.normal⟩ returned)
    cases bad
inductive Prefix (ctx : Context) (before : State) (blocks : Fin 6 → Nat) : List KeygenEntropySource.Event → Result → Prop where
  | run (objects initialized dimensioned : State) (events : List KeygenEntropySource.Event) (out : Result)
      (declarations : KeygenMakePrologue.Declarations before blocks objects)
      (counter : C99ProcedureReference.Exec (fun _ => none) KeygenMakePrologue.countCode objects ⟨initialized,.normal⟩)
      (dimensions : KeygenMakePrologue.Dimensions ctx initialized dimensioned)
      (gate : Gate ctx dimensioned events out) : Prefix ctx before blocks events out
theorem normal_prefix (ctx : Context) (before after : State) (blocks : Fin 6 → Nat) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx before primes rev) (events : List KeygenEntropySource.Event)
    (source : Prefix ctx before blocks events ⟨after,.normal⟩) :
    KeygenCapWords.Count after 0 ∧
    KeygenCallerEntry.Initial ctx after (KeygenMakeEntry.input blocks) (KeygenMakeEntry.publicPointer blocks) primes rev ∧
    KeygenReadyResult.flagPresent ctx after.heap .seeded ∧ KeygenReadyResult.flagPresent ctx after.heap .flipped := by
  cases source with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
    have initial := KeygenMakePrologue.initial ctx before objects primes rev original blocks declarations
    have objectsEq : objects=KeygenMakePrologue.declared before blocks := by cases declarations; rfl
    subst objects
    have initializedEq : initialized=KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks) :=
      congrArg Result.state (KeygenMakePrologue.count_result before blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have profile : KeygenSearchContext.M0 (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)).heap ctx := initial.profile
    have dimensionsEq := KeygenMakePrologue.dimensions_result ctx (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)) dimensioned profile dimensions
    subst dimensioned
    have readyInitial := KeygenMakePrologue.ready_initial ctx before blocks primes rev initial
    have call := gate_normal ctx _ after events gate
    have slots := KeygenRngReference.call_slots ctx _ after events (.int32 1) call
    have locals : after.locals=(KeygenMakePrologue.ready before blocks).locals := slots.1
    have count : KeygenCapWords.Count after 0 := by
      change after.locals "local_attempts".toList=some (.uint64,some (.uint64 0))
      rw [locals]
      exact KeygenMakePrologue.ready_count before blocks
    exact ⟨count,initial_frame ctx _ after events (.int32 1) call _ _ _ _ readyInitial,
      KeygenReadyResult.call_flags ctx _ after events call⟩
theorem literal_prefix_source :
    (KeygenM0Preprocess.preprocess ((Pinned.keygenLines.drop 7804).take 34)).bind
      (fun lines => C99ProcedureParser.tokens (lines.flatMap String.toList)) =
    C99ProcedureParser.tokens ("unsigned logn, ter; size_t n, u; " ++
      "int16_t f[3072], g[3072], F[3072], G[3072]; uint16_t h[3072]; " ++
      "size_t klen, skoff; unsigned char *skbuf; int16_t *ske[4]; " ++
      "int i; uint64_t local_attempts; local_attempts = 0; " ++
      "logn = fk->logn; ter = fk->ternary; n = MKN(logn, ter); " ++
      "if (!rng_ready(fk)) { return 0; }").toList := KeygenMakePrologue.prefix_tokens_source

theorem normal_prefix_locals (ctx : Context) (before after : State) (blocks : Fin 6 → Nat) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx before primes rev) (events : List KeygenEntropySource.Event)
    (source : Prefix ctx before blocks events ⟨after,.normal⟩) :
    after.locals=(KeygenMakePrologue.ready before blocks).locals := by
  cases source with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
    have initial := KeygenMakePrologue.initial ctx before objects primes rev original blocks declarations
    have objectsEq : objects=KeygenMakePrologue.declared before blocks := by cases declarations; rfl
    subst objects
    have initializedEq : initialized=KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks) :=
      congrArg Result.state (KeygenMakePrologue.count_result before blocks ⟨initialized,.normal⟩ counter)
    subst initialized
    have profile : KeygenSearchContext.M0 (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)).heap ctx := initial.profile
    have dimensionsEq := KeygenMakePrologue.dimensions_result ctx (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)) dimensioned profile dimensions
    subst dimensioned
    exact (KeygenRngReference.call_slots ctx _ after events (.int32 1) (gate_normal ctx _ after events gate)).1

end FT1536.Source3.KeygenMakeReady
