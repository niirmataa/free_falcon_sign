import Source3.KeygenReadySeeded091
import Source3.KeygenSamplerFunction091

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenReadyCall091
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

def SeededFlags (ctx : Context) (s : State) : Prop :=
  Load32 s.heap (KeygenReadyFast.field ctx .seeded) 1 ∧
    Load32 s.heap (KeygenReadyFast.field ctx .flipped) 0

theorem binding_flags (ctx : Context) (before entry : State)
    (binding : C99ArrayReference.Bind before KeygenRngReference.readyParams KeygenRngReference.readyArguments entry)
    (flags : SeededFlags ctx before) : SeededFlags ctx entry := by
  have heap := C99ArrayReference.bind_heap _ _ _ _ binding
  simpa only [SeededFlags, heap] using flags

theorem result (ctx : Context) (before after : State) (events : List KeygenEntropySource.Event) (v : Value)
    (flags : SeededFlags ctx before) (source : KeygenRngReference.Call ctx before events after v) :
    v = .int32 1 ∧ events = [] := by
  cases source with
  | run entry events out v binding body conversion =>
      have entryFlags := binding_flags ctx before entry binding flags
      obtain ⟨finished, flip, returned, silent⟩ :=
        KeygenReadySeeded091.ready_path ctx entry events out entryFlags.1 entryFlags.2 body
      rw [returned] at conversion
      cases conversion
      exact ⟨rfl, silent⟩

theorem call_unique (ctx : Context) (before a b : State) (events1 events2 : List KeygenEntropySource.Event)
    (v1 v2 : Value) (flags : SeededFlags ctx before)
    (first : KeygenRngReference.Call ctx before events1 a v1)
    (second : KeygenRngReference.Call ctx before events2 b v2) :
    a = b ∧ v1 = v2 ∧ events1 = events2 := by
  have r1 := result ctx before a events1 v1 flags first
  have r2 := result ctx before b events2 v2 flags second
  refine ⟨?_, r1.1.trans r2.1.symm, r1.2.trans r2.2.symm⟩
  cases first with
  | run e1 events1 o1 v1 bind1 body1 ret1 =>
      cases second with
      | run e2 events2 o2 v2 bind2 body2 ret2 =>
          have entries := C99ArrayDeterminism089.parameters before _ _ e1 e2 bind1 bind2
          subst e2
          have entryFlags := binding_flags ctx before e1 bind1 flags
          have same := (KeygenReadySeeded091.ready_unique ctx e1 events1 events2 o1 o2
            entryFlags.1 entryFlags.2 body1 body2).1
          rw [same]

structure Input (ctx : Context) where
  before : State
  flags : SeededFlags ctx before

/-- Exact partial readiness after the replacement-seed API. The source
    result and the absence of entropy events are derived above. -/
noncomputable def ready (ctx : Context) (input : Input ctx) : Part State where
  Dom := ∃ after, KeygenRngReference.Call ctx input.before [] after (.int32 1)
  get domain := Classical.choose domain

theorem ready_spec (ctx : Context) (input : Input ctx) (after : State) :
    after ∈ ready ctx input ↔ KeygenRngReference.Call ctx input.before [] after (.int32 1) := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ value, KeygenRngReference.Call ctx input.before [] value (.int32 1) := ⟨after, source⟩
    exact ⟨domain, (call_unique ctx input.before (Classical.choose domain) after [] []
      (.int32 1) (.int32 1) input.flags (Classical.choose_spec domain) source).1⟩

def from_seed (env : KeygenMakeInvocation.Env) (base : State) (block : Nat)
    (seed : KeygenSeedEntry089.Seed) (after : State)
    (source : KeygenSeedEntry089.Seeded env base block seed after) : Input env.ctx :=
  ⟨after, KeygenSeedFlags089.seeded_flags env base block seed after source⟩

end FT1536.Source3.KeygenReadyCall091
