import Source3.KeygenSeedTrace092

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenFirstSamples092
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenSeedEntry089 (Seed)
open KeygenSeedPrefix092 (Input)

/-- Both real sampler calls of the first attempt, after the actual seed,
    whole readiness prefix and cap check. No acceptance gates are skipped
    by this definition: they follow this source boundary. -/
def Source (env : Env) (input : Input env) (seed : Seed) (after : State) : Prop :=
  ∃ ready entry middle, KeygenSeedPrefix092.Source env input seed ready ∧
    KeygenMakeSampling.CappedSetup env.ctx ready ⟨entry, .normal⟩ ∧
    KeygenSamplerContext.Call env.ctx entry "f" middle ∧
    KeygenSamplerContext.Call env.ctx middle "g" after

theorem source_unique (env : Env) (input : Input env) (seed : Seed) (a b : State)
    (first : Source env input seed a) (second : Source env input seed b) : a = b := by
  obtain ⟨ready1, entry1, middle1, head1, cap1, first1, second1⟩ := first
  obtain ⟨ready2, entry2, middle2, head2, cap2, first2, second2⟩ := second
  have same := KeygenSeedPrefix092.source_unique env input seed ready1 ready2 head1 head2
  subst ready2
  have legality := KeygenSeedPrefix092.prepare_legal env input seed ready1
    ((KeygenSeedPrefix092.prepare_spec env input seed ready1).mpr head1)
  exact KeygenCappedSampler092.capped_samples_unique env.ctx ready1 0 legality.1 legality.2
    entry1 middle1 a entry2 middle2 b cap1 first1 second1 cap2 first2 second2

noncomputable def sampleFirst (env : Env) (input : Input env) (seed : Seed) : Part State where
  Dom := ∃ after, Source env input seed after
  get domain := Classical.choose domain

theorem sampleFirst_spec (env : Env) (input : Input env) (seed : Seed) (after : State) :
    after ∈ sampleFirst env input seed ↔ Source env input seed after := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ value, Source env input seed value := ⟨after, source⟩
    exact ⟨domain, source_unique env input seed (Classical.choose domain) after (Classical.choose_spec domain) source⟩

theorem first_cap_cannot_exhaust (env : Env) (input : Input env) (seed : Seed) (ready : State)
    (head : KeygenSeedPrefix092.Source env input seed ready) (out : C99ProcedureReference.Result)
    (cap : KeygenMakeSampling.CappedSetup env.ctx ready out) : out.flow = .normal := by
  have legality := KeygenSeedPrefix092.prepare_legal env input seed ready
    ((KeygenSeedPrefix092.prepare_spec env input seed ready).mpr head)
  rcases KeygenMakeSampling.cap_before_setup env.ctx ready 0 out (by decide) legality.1.1 legality.1.2.1.1 cap with
      exhausted | running
  · have impossible := exhausted.1
    norm_num [KeygenAttemptCap.limit] at impossible
  · exact congrArg C99ProcedureReference.Result.flow running.2.1

end FT1536.Source3.KeygenFirstSamples092
