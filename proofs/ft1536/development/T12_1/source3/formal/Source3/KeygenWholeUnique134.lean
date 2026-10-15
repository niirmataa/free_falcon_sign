import Source3.KeygenWholeUnique109
import Source3.KeygenWholeStages109
import Source3.KeygenWholeCall134
import Source3.KeygenWholeStages134
import Source3.KeygenWholeTrace134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenWholeUnique134
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenWholeStages109 (Input)
open KeygenWholeTrace134 (Trace)


open KeygenWholeUnique109
theorem raw (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (a b : Trace env seeded) : a.out = b.out ∧ a.failure = b.failure := by
  have prefixes := KeygenWholeStages109.prefixes env input seed seeded seeding
  have normal := KeygenWholeStages109.prefix_normal env input seed seeded seeding
  have loops := KeygenWholeStages134.loops env input seed seeded seeding
  have tails := KeygenWholeStages134.tails env input seed seeded seeding
  have abortDistinct : KeygenCapExecution.abortFlow ≠ C99ProcedureReference.Flow.normal := by decide
  cases a <;> cases b
  all_goals simp only [Trace.out, Trace.failure] at *
  all_goals grind (ematch := 12)

theorem source (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (a b : KeygenWholeCall134.Trace (canonical env) seeded) : a.out = b.out ∧ a.failure = b.failure := by
  have same := raw env input seed seeded seeding (KeygenWholeTrace134.forget env seeded a) (KeygenWholeTrace134.forget env seeded b)
  simpa only [KeygenWholeTrace134.forget_out, KeygenWholeTrace134.forget_failure] using same

end FT1536.Source3.KeygenWholeUnique134
