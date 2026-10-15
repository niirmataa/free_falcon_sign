import Source3.KeygenSeededExecution109
import Source3.KeygenWholeObservation109
import Source3.KeygenWholeBytes134
import Source3.KeygenWholeCall134
import Source3.KeygenWholeObservation134
import Source3.KeygenWholeTrace134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenSeededExecution134
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenWholeStages109 (Input)
open KeygenWholeBytes088 (Outcome)
open KeygenWholeBytes134 (observe)





open KeygenSeededExecution109
structure Execution (env : Env) (input : Input env) (seed : Seed) where
  seeded : State
  seeding : Seeded (canonical env) input.base input.seedBlock seed seeded
  trace : KeygenWholeTrace134.Trace env seeded

def Execution.domain (run : Execution env input seed) : KeygenWholeBytes088.Domain (canonical env) run.seeded :=
  KeygenWholeStages109.domain env input seed run.seeded run.seeding

noncomputable def Execution.consumer (run : Execution env input seed) : KeygenWholeCall134.Trace (canonical env) run.seeded :=
  Classical.choose (KeygenWholeTrace134.refine env run.seeded run.domain run.trace)

theorem Execution.consumer_failure (run : Execution env input seed) : run.consumer.failure = run.trace.failure :=
  (Classical.choose_spec (KeygenWholeTrace134.refine env run.seeded run.domain run.trace)).2

noncomputable def Execution.outcome (run : Execution env input seed) : Outcome := observe run.domain run.consumer

theorem unique (env : Env) (input : Input env) (seed : Seed) (a b : Execution env input seed) : a.outcome = b.outcome := by
  cases a with
  | mk seededA initA traceA =>
      cases b with
      | mk seededB initB traceB =>
          have states := KeygenSeedFunction089.seeded_unique (canonical env) input.base input.seedBlock seed seededA seededB initA initB
          subst seededB
          exact KeygenWholeObservation134.unique env input seed seededA initA _ _ _ _

end FT1536.Source3.KeygenSeededExecution134
