import Source3.KeygenSeedPrefix092

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSeedTrace092
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenWholeCall088 (Trace)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenSeedPrefix092 (Input)

theorem prefix_facts (env : Env) (input : Input env) (seed : Seed) (seeded bound : State)
    (seeding : Seeded env input.base input.seedBlock seed seeded)
    (binding : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params (KeygenMakeArguments.values env.args) bound)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : KeygenMakeReady.Prefix env.ctx bound env.blocks events out) :
    out.flow = .normal ∧ events = [] := by
  have equal := KeygenMakeArguments.bind_exact seeded env.args bound binding
  subst bound
  let legal := KeygenSeedPrefix092.prefixInput env input seed seeded seeding
  obtain ⟨_, after, returned, silent, call⟩ := KeygenPrefixFunction092.prefix_path env.ctx legal.before
    env.blocks legal.primes legal.rev legal.original legal.flags events out source
  exact ⟨congrArg Result.flow returned, silent⟩

/-- No readiness-failure trace can occur after a defined replacement-seed
    execution in the stated legal caller domain. Nonreturn is not excluded. -/
theorem no_readiness_failure (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded env input.base input.seedBlock seed seeded) (t : Trace env seeded) :
    t.failure ≠ some .readiness := by
  cases t with
  | readiness bound events raw binding ready exit =>
      exact (exit (prefix_facts env input seed seeded bound seeding binding events raw ready).1).elim
  | capped => simp [Trace.failure]
  | tailRejected => simp [Trace.failure]
  | encoded => simp [Trace.failure]

theorem no_entropy_events (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded env input.base input.seedBlock seed seeded) (t : Trace env seeded) : t.events = [] := by
  cases t with
  | readiness bound events raw binding ready exit =>
      exact (prefix_facts env input seed seeded bound seeding binding events raw ready).2
  | capped bound entry events loopOut attempts binding ready loop aborted =>
      exact (prefix_facts env input seed seeded bound seeding binding events _ ready).2
  | tailRejected bound entry events loopOut tailOut attempts calls binding ready loop normal tail rejected =>
      exact (prefix_facts env input seed seeded bound seeding binding events _ ready).2
  | encoded bound entry events loopOut tailOut attempts binding ready loop normal tail addresses =>
      exact (prefix_facts env input seed seeded bound seeding binding events _ ready).2

end FT1536.Source3.KeygenSeedTrace092
