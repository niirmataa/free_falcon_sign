import Source3.KeygenSamplerOuter091

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerFunction091
open C99ArrayReference (State Arg)
open ShakeExtractSource (Layout)
open KeygenSamplerTail091 (Legal)

structure Input (ctx : Layout) where
  before : State
  legal : Legal ctx before

/-- The complete actual MODE1 sampler call, including all scalar rejections
    and all output coefficients. This is a partial function of its original
    SHAKE state, with no independent or uniform replacement for any draw. -/
noncomputable def sample (ctx : Layout) (input : Input ctx) (args : List Arg) : Part State where
  Dom := ∃ after, KeygenSamplerCalls.Call ctx input.before args after
  get domain := Classical.choose domain

theorem sample_spec (ctx : Layout) (input : Input ctx) (args : List Arg) (after : State) :
    after ∈ sample ctx input args ↔ KeygenSamplerCalls.Call ctx input.before args after := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result, KeygenSamplerCalls.Call ctx input.before args result := ⟨after, source⟩
    exact ⟨domain, KeygenSamplerOuter091.call_unique ctx input.before
      (Classical.choose domain) after args input.legal (Classical.choose_spec domain) source⟩

theorem returned_legal (ctx : Layout) (input : Input ctx) (args : List Arg) (after : State)
    (returned : after ∈ sample ctx input args) : Legal ctx after :=
  KeygenSamplerTail091.stable_legal ctx input.before after
    (KeygenSamplerOuter091.call_stable ctx input.before after args ((sample_spec ctx input args after).mp returned))
    input.legal

def successor (ctx : Layout) (input : Input ctx) (args : List Arg) (after : State)
    (returned : after ∈ sample ctx input args) : Input ctx :=
  ⟨after, returned_legal ctx input args after returned⟩

/-- Exact sequential composition: the second call starts in the first
    call's returned state, preserving correlations through the stream. -/
noncomputable def pair (ctx : Layout) (input : Input ctx) (firstArgs secondArgs : List Arg) : Part State :=
  (sample ctx input firstArgs).bind fun middle =>
    ⟨∃ after, KeygenSamplerCalls.Call ctx middle secondArgs after, fun domain => Classical.choose domain⟩

theorem pair_spec (ctx : Layout) (input : Input ctx) (firstArgs secondArgs : List Arg) (after : State) :
    after ∈ pair ctx input firstArgs secondArgs ↔
      ∃ middle, KeygenSamplerCalls.Call ctx input.before firstArgs middle ∧
        KeygenSamplerCalls.Call ctx middle secondArgs after := by
  change after ∈ (sample ctx input firstArgs).bind _ ↔ _
  rw [Part.mem_bind_iff]
  constructor
  · rintro ⟨middle, first, domain, equal⟩
    refine ⟨middle, (sample_spec ctx input firstArgs middle).mp first, ?_⟩
    have second := Classical.choose_spec domain
    rw [← equal]
    exact second
  · rintro ⟨middle, first, second⟩
    have member := (sample_spec ctx input firstArgs middle).mpr first
    let domain : ∃ result, KeygenSamplerCalls.Call ctx middle secondArgs result := ⟨after, second⟩
    exact ⟨middle, member, domain, KeygenSamplerOuter091.call_unique ctx middle
      (Classical.choose domain) after secondArgs (returned_legal ctx input firstArgs middle member)
      (Classical.choose_spec domain) second⟩

end FT1536.Source3.KeygenSamplerFunction091
