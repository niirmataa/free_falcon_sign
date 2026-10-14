import Source3.KeygenWholeObservation109

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSeededExecution109
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenWholeStages109 (Input)
open KeygenWholeBytes088 (Outcome observe)

/-- An execution witness, never an input to the probabilistic experiment.
    Both initialization and the complete raw invocation execute fixed code;
    every defined return, including failure, is admitted. -/
structure Execution (env : Env) (input : Input env) (seed : Seed) where
  seeded : State
  seeding : Seeded (canonical env) input.base input.seedBlock seed seeded
  trace : KeygenWholeTrace109.Trace env seeded

def Execution.domain (run : Execution env input seed) : KeygenWholeBytes088.Domain (canonical env) run.seeded :=
  KeygenWholeStages109.domain env input seed run.seeded run.seeding

noncomputable def Execution.consumer (run : Execution env input seed) : KeygenWholeCall088.Trace (canonical env) run.seeded :=
  Classical.choose (KeygenWholeTrace109.refine env run.seeded run.domain run.trace)

theorem Execution.consumer_out (run : Execution env input seed) : run.consumer.out = run.trace.out :=
  (Classical.choose_spec (KeygenWholeTrace109.refine env run.seeded run.domain run.trace)).1

theorem Execution.consumer_failure (run : Execution env input seed) : run.consumer.failure = run.trace.failure :=
  (Classical.choose_spec (KeygenWholeTrace109.refine env run.seeded run.domain run.trace)).2

noncomputable def Execution.outcome (run : Execution env input seed) : Outcome := observe run.domain run.consumer

theorem unique (env : Env) (input : Input env) (seed : Seed) (a b : Execution env input seed) : a.outcome = b.outcome := by
  cases a with
  | mk seededA initA traceA =>
      cases b with
      | mk seededB initB traceB =>
          have states := KeygenSeedFunction089.seeded_unique (canonical env) input.base input.seedBlock seed seededA seededB initA initB
          subst seededB
          exact KeygenWholeObservation109.unique env input seed seededA initA _ _ _ _

theorem source_execution (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (source : KeygenWholeCall088.Trace (canonical env) seeded) :
    ∃ run : Execution env input seed,
      run.outcome = observe (KeygenWholeStages109.domain env input seed seeded seeding) source := by
  let run : Execution env input seed := ⟨seeded,seeding,KeygenWholeTrace109.forget env seeded source⟩
  exact ⟨run, KeygenWholeObservation109.unique env input seed seeded seeding _ _ _ source⟩

end FT1536.Source3.KeygenSeededExecution109
