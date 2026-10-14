import Source3.KeygenWholeStages109

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWholeUnique109
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenWholeStages109 (Input)
open KeygenWholeTrace109 (Trace)

theorem raw (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (a b : Trace env seeded) : a.out = b.out ∧ a.failure = b.failure := by
  have prefixes := KeygenWholeStages109.prefixes env input seed seeded seeding
  have normal := KeygenWholeStages109.prefix_normal env input seed seeded seeding
  have loops := KeygenWholeStages109.loops env input seed seeded seeding
  have tails := KeygenWholeStages109.tails env input seed seeded seeding
  have abortDistinct : KeygenCapExecution.abortFlow ≠ C99ProcedureReference.Flow.normal := by decide
  cases a <;> cases b
  all_goals simp only [Trace.out, Trace.failure] at *
  all_goals grind (ematch := 12)

theorem source (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (a b : KeygenWholeCall088.Trace (canonical env) seeded) : a.out = b.out ∧ a.failure = b.failure := by
  have same := raw env input seed seeded seeding (KeygenWholeTrace109.forget env seeded a) (KeygenWholeTrace109.forget env seeded b)
  simpa only [KeygenWholeTrace109.forget_out, KeygenWholeTrace109.forget_failure] using same

end FT1536.Source3.KeygenWholeUnique109
