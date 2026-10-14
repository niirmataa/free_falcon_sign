import Source3.KeygenResultantCall093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenResultantFunction093
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

structure Input where
  before : State
  f : ArrayPointer
  g : ArrayPointer
  fPointer : before.arrays "f".toList = some f
  gPointer : before.arrays "g".toList = some g
  fLive : 0 < before.heap.size f.block
  gLive : 0 < before.heap.size g.block
  tablesLive : RngTemporarySwap090.TablesLive before

def from_samples (ctx : Context) (before middle after : State) (input : Fin 4 → ArrayPointer)
    (h primes rev : ArrayPointer) (initial : KeygenCallerEntry.Initial ctx before input h primes rev)
    (first : KeygenSamplerContext.Call ctx before "f" middle)
    (second : KeygenSamplerContext.Call ctx middle "g" after) : Input := by
  have stable := C99Metadata091.trans before middle after
    (KeygenCappedSampler092.context_stable ctx before middle "f" first)
    (KeygenCappedSampler092.context_stable ctx middle after "g" second)
  have slots := KeygenAttemptSlots.trans before middle after
    (KeygenAttemptMaterial.sampler_slots ctx before middle "f" first)
    (KeygenAttemptMaterial.sampler_slots ctx middle after "g" second)
  refine ⟨after, input 0, input 1, ?_, ?_, ?_, ?_, ?_⟩
  · exact (congrFun slots.1 "f".toList).trans (initial.inputs 0)
  · exact (congrFun slots.1 "g".toList).trans (initial.inputs 1)
  · rw [stable.sizes]
    exact KeygenCallerEntry.allocated_live before.heap (input 0) (initial.allocated 0)
  · rw [stable.sizes]
    exact KeygenCallerEntry.allocated_live before.heap (input 1) (initial.allocated 1)
  · intro name p binding
    rw [stable.tables] at binding
    rw [stable.sizes]
    exact initial.staticLive name p binding

/-- Both source rejection edges and normal fallthrough remain in the
    exact partial result; this function does not condition on acceptance. -/
noncomputable def gate (input : Input) : Part Result where
  Dom := ∃ out, KeygenResultantGate.Exec input.before out
  get domain := Classical.choose domain

theorem gate_spec (input : Input) (out : Result) : out ∈ gate input ↔ KeygenResultantGate.Exec input.before out := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ value, KeygenResultantGate.Exec input.before value := ⟨out, source⟩
    exact ⟨domain, KeygenResultantCall093.gate_unique input.before input.f input.g (Classical.choose domain) out
      input.fPointer input.gPointer input.fLive input.gLive input.tablesLive (Classical.choose_spec domain) source⟩

theorem state_unchanged (input : Input) (out : Result) (returned : out ∈ gate input) : out.state = input.before := by
  have source := (gate_spec input out).mp returned
  cases source
  all_goals grind only [KeygenResultantCall093.call_state]

end FT1536.Source3.KeygenResultantFunction093
