import Source3.KeygenReadyCall091

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPrefixFunction092
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenReadyCall091 (SeededFlags)

theorem declaration_flags (ctx : Context) (before after : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (original : KeygenMakeEntry.Original ctx before primes rev)
    (flags : SeededFlags ctx before) (source : KeygenMakePrologue.Declarations before blocks after) :
    SeededFlags ctx after := by
  have allocation := KeygenMakePrologue.allocation_projection before after blocks source
  have frame := KeygenMakeObjects.live_frame 0 (KeygenMakePrologue.projectionStart before) after blocks
    allocation ctx.object.block (KeygenMakeEntry.object_live ctx before primes rev original)
  exact ⟨KeygenMakeEntry.load32_block _ _ _ _ frame flags.1,
    KeygenMakeEntry.load32_block _ _ _ _ frame flags.2⟩

theorem gate_path (ctx : Context) (before : State) (events : List KeygenEntropySource.Event) (out : Result)
    (flags : SeededFlags ctx before) (source : KeygenMakeReady.Gate ctx before events out) :
    ∃ after, out = ⟨after, .normal⟩ ∧ events = [] ∧ KeygenRngReference.Call ctx before [] after (.int32 1) := by
  cases source with
  | normal after word v call test zero =>
      obtain ⟨value, silent⟩ := KeygenReadyCall091.result ctx before after events (.int32 word) flags call
      have same : word = 1 := Value.int32.inj value
      subst word
      subst events
      exact ⟨after, rfl, rfl, call⟩
  | failure after word v out call test nonzero returned =>
      have value := (KeygenReadyCall091.result ctx before after events (.int32 word) flags call).1
      have same : word = 1 := Value.int32.inj value
      subst word
      have zero := KeygenReadyFast.not_test after 1 v test
      rw [zero] at nonzero
      norm_num [C99ScalarReference.boolean, Value.integer] at nonzero

theorem gate_unique (ctx : Context) (before : State) (events1 events2 : List KeygenEntropySource.Event)
    (a b : Result) (flags : SeededFlags ctx before)
    (first : KeygenMakeReady.Gate ctx before events1 a) (second : KeygenMakeReady.Gate ctx before events2 b) :
    a = b ∧ events1 = events2 := by
  obtain ⟨sa, ea, silentA, callA⟩ := gate_path ctx before events1 a flags first
  obtain ⟨sb, eb, silentB, callB⟩ := gate_path ctx before events2 b flags second
  have same := (KeygenReadyCall091.call_unique ctx before sa sb [] [] (.int32 1) (.int32 1) flags callA callB).1
  subst sb
  exact ⟨ea.trans eb.symm, silentA.trans silentB.symm⟩

/-- The complete real declaration/count/dimension/readiness prefix on the
    replacement-seeded path. Its fixed state is derived from the source. -/
theorem prefix_path (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (original : KeygenMakeEntry.Original ctx before primes rev)
    (flags : SeededFlags ctx before) (events : List KeygenEntropySource.Event) (out : Result)
    (source : KeygenMakeReady.Prefix ctx before blocks events out) :
    SeededFlags ctx (KeygenMakePrologue.ready before blocks) ∧
      ∃ after, out = ⟨after, .normal⟩ ∧ events = [] ∧
        KeygenRngReference.Call ctx (KeygenMakePrologue.ready before blocks) [] after (.int32 1) := by
  cases source with
  | run objects initialized dimensioned events out declarations counter dimensions gate =>
      have initial := KeygenMakePrologue.initial ctx before objects primes rev original blocks declarations
      have kept := declaration_flags ctx before objects blocks primes rev original flags declarations
      have objectsEq : objects = KeygenMakePrologue.declared before blocks := by cases declarations; rfl
      subst objects
      have initializedEq : initialized = KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks) :=
        congrArg Result.state (KeygenMakePrologue.count_result before blocks ⟨initialized, .normal⟩ counter)
      subst initialized
      have dimensionedEq := KeygenMakePrologue.dimensions_result ctx
        (KeygenMakePrologue.counted (KeygenMakePrologue.declared before blocks)) dimensioned initial.profile dimensions
      subst dimensioned
      exact ⟨kept, gate_path ctx _ events out kept gate⟩

theorem prefix_unique (ctx : Context) (before : State) (blocks : Fin 6 → Nat)
    (primes rev : ArrayPointer) (original : KeygenMakeEntry.Original ctx before primes rev)
    (flags : SeededFlags ctx before) (events1 events2 : List KeygenEntropySource.Event) (a b : Result)
    (first : KeygenMakeReady.Prefix ctx before blocks events1 a)
    (second : KeygenMakeReady.Prefix ctx before blocks events2 b) : a = b ∧ events1 = events2 := by
  obtain ⟨readyFlags, sa, ea, silentA, callA⟩ := prefix_path ctx before blocks primes rev original flags events1 a first
  obtain ⟨_, sb, eb, silentB, callB⟩ := prefix_path ctx before blocks primes rev original flags events2 b second
  have same := (KeygenReadyCall091.call_unique ctx _ sa sb [] [] (.int32 1) (.int32 1) readyFlags callA callB).1
  subst sb
  exact ⟨ea.trans eb.symm, silentA.trans silentB.symm⟩

structure Input (ctx : Context) where
  before : State
  blocks : Fin 6 → Nat
  primes : ArrayPointer
  rev : ArrayPointer
  original : KeygenMakeEntry.Original ctx before primes rev
  flags : SeededFlags ctx before

noncomputable def runPrefix (ctx : Context) (input : Input ctx) : Part State where
  Dom := ∃ after, KeygenMakeReady.Prefix ctx input.before input.blocks [] ⟨after, .normal⟩
  get domain := Classical.choose domain

theorem prefix_spec (ctx : Context) (input : Input ctx) (after : State) :
    after ∈ runPrefix ctx input ↔ KeygenMakeReady.Prefix ctx input.before input.blocks [] ⟨after, .normal⟩ := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ value, KeygenMakeReady.Prefix ctx input.before input.blocks [] ⟨value, .normal⟩ := ⟨after, source⟩
    refine ⟨domain, ?_⟩
    exact congrArg Result.state (prefix_unique ctx input.before input.blocks input.primes input.rev
      input.original input.flags [] [] _ _ (Classical.choose_spec domain) source).1

end FT1536.Source3.KeygenPrefixFunction092
