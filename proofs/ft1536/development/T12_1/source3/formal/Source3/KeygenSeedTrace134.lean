import Source3.KeygenSeedTrace092
import Source3.KeygenSeedPrefix092
import Source3.KeygenWholeCall134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenSeedTrace134
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenWholeCall134 (Trace)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenSeedPrefix092 (Input)


open KeygenSeedTrace092
theorem no_readiness_failure (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded env input.base input.seedBlock seed seeded) (t : Trace env seeded) :
    t.failure ≠ some .readiness := by
  cases t with
  | readiness bound events raw binding ready exit =>
      exact (exit (prefix_facts env input seed seeded bound seeding binding events raw ready).1).elim
  | capped => simp [Trace.failure]
  | tailRejected => simp [Trace.failure]
  | encoded => simp [Trace.failure]

end FT1536.Source3.KeygenSeedTrace134
