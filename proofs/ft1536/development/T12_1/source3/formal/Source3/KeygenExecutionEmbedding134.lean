import Source3.KeygenByteGame134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Structural preservation of old finite source executions. No old/new
   whole-law equality and no preservation of absent executions is asserted. -/
namespace FT1536.Source3.KeygenExecutionEmbedding134
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenWholeBytes088 (Outcome Domain)

theorem ternary (ctx : Context) (before : State) (out : Result)
    (source : KeygenCallerPrefix.Ternary ctx before out) : KeygenCallerPrefix134.Ternary ctx before out := by
  cases source with
  | resultantRejected middle sampled out first second gate rejected =>
      exact .resultantRejected middle sampled out first second gate rejected
  | norm middle sampled res out first second resultants norm =>
      exact .norm middle sampled res out first second resultants (KeygenAttemptNorm133.previous _ _ _ norm)

theorem gates (ctx : Context) (saved entry : State) (out : Result)
    (source : KeygenMakeSearchPrefix.Gates ctx saved entry out) : KeygenMakeSearchPrefix134.Gates ctx saved entry out := by
  cases source with
  | ternaryRejected raw source rejected => exact .ternaryRejected raw (ternary _ _ _ source) rejected
  | publicRejected normed raw source gate rejected => exact .publicRejected normed _ (ternary _ _ _ source) gate rejected
  | solver normed publicState raw source publicGate gate => exact .solver normed publicState _ (ternary _ _ _ source) publicGate gate

theorem sampled (ctx : Context) (before : State) (out : Result)
    (source : KeygenMakeSearchPrefix.Sampled ctx before out) : KeygenMakeSearchPrefix134.Sampled ctx before out := by
  cases source with
  | run entry out cap source => exact .run entry out cap (gates _ _ _ _ source)

theorem attempt (ctx : Context) (before : State) (out : Result)
    (source : KeygenCertificateSource080.Attempt ctx before out) : KeygenCertificateSource134.Attempt ctx before out := by
  cases source with
  | earlyRejected raw source rejected => exact .earlyRejected _ (sampled _ _ _ source) rejected
  | throughCertificate raw source normal out gate => exact .throughCertificate raw (sampled _ _ _ source) normal out gate

def attemptExecution (ctx : Context) (source : KeygenCertificateSource080.AttemptExecution ctx) :
    KeygenCertificateSource134.AttemptExecution ctx :=
  ⟨source.before,source.out,attempt ctx source.before source.out source.source⟩

theorem loop (ctx : Context) (before : State) (out : Result)
    (attempts : List (KeygenCertificateSource080.AttemptExecution ctx))
    (source : KeygenCertificateSource080.Loop ctx before out attempts) :
    KeygenCertificateSource134.Loop ctx before out (attempts.map (attemptExecution ctx)) := by
  induction source with
  | exhausted before out cap exit => exact .exhausted before out cap exit
  | accepted a accepted => exact .accepted (attemptExecution ctx a) accepted
  | retry a out rest rejected tail ih => exact .retry (attemptExecution ctx a) out _ rejected ih

def whole (env : Env) (caller : State) : KeygenWholeCall088.Trace env caller → KeygenWholeCall134.Trace env caller
  | .readiness bound events raw binding ready exit => .readiness bound events raw binding ready exit
  | .capped bound entry events out attempts binding ready source aborted =>
      .capped bound entry events out (attempts.map (attemptExecution env.ctx)) binding ready (loop _ _ _ _ source) aborted
  | .tailRejected bound entry events loopOut tailOut attempts calls binding ready source normal encoding rejected =>
      .tailRejected bound entry events loopOut tailOut (attempts.map (attemptExecution env.ctx)) calls binding ready
        (loop _ _ _ _ source) normal encoding rejected
  | .encoded bound entry events loopOut tailOut attempts binding ready source normal encoding addresses =>
      .encoded bound entry events loopOut tailOut (attempts.map (attemptExecution env.ctx)) binding ready
        (loop _ _ _ _ source) normal encoding addresses

theorem whole_out (env : Env) (caller : State) (source : KeygenWholeCall088.Trace env caller) :
    (whole env caller source).out=source.out := by cases source <;> rfl

theorem whole_failure (env : Env) (caller : State) (source : KeygenWholeCall088.Trace env caller) :
    (whole env caller source).failure=source.failure := by cases source <;> rfl

theorem observed (env : Env) (caller : State) (domain : Domain env caller)
    (source : KeygenWholeCall088.Trace env caller) :
    KeygenWholeBytes134.observe domain (whole env caller source)=KeygenWholeBytes088.observe domain source := by
  cases result : KeygenWholeBytes088.observe domain source with
  | inl cause =>
      have failure := (KeygenWholeBytes088.observe_left_iff domain source cause).mp result
      exact (KeygenWholeBytes134.observe_left_iff domain (whole env caller source) cause).mpr
        ((whole_failure env caller source).trans failure)
  | inr packet =>
      have bytes := (KeygenWholeBytes088.observe_right_iff domain source packet).mp result
      apply (KeygenWholeBytes134.observe_right_iff domain (whole env caller source) packet).mpr
      rw [whole_out]
      exact bytes

theorem source_execution (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (source : KeygenWholeCall134.Trace (canonical env) seeded) :
    ∃ run : KeygenSeededExecution134.Execution env input seed,
      run.outcome=KeygenWholeBytes134.observe (KeygenWholeStages109.domain env input seed seeded seeding) source := by
  let run : KeygenSeededExecution134.Execution env input seed :=
    ⟨seeded,seeding,KeygenWholeTrace134.forget env seeded source⟩
  exact ⟨run,KeygenWholeObservation134.unique env input seed seeded seeding _ _ _ source⟩

theorem of_source (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (source : KeygenWholeCall134.Trace (canonical env) seeded) :
    KeygenByteGame134.evaluate env input seed =
      some (KeygenWholeBytes134.observe (KeygenWholeStages109.domain env input seed seeded seeding) source) := by
  obtain ⟨run,equal⟩ := source_execution env input seed seeded seeding source
  exact (KeygenByteGame134.some_iff env input seed _).mpr ⟨run,equal⟩

theorem old_some (env : Env) (input : Input env) (seed : Seed) (out : Outcome)
    (returned : KeygenByteGame109.evaluate env input seed=some out) :
    KeygenByteGame134.evaluate env input seed=some out := by
  obtain ⟨run,equal⟩ := (KeygenByteGame109.some_iff env input seed out).mp returned
  rw [of_source env input seed run.seeded run.seeding (whole (canonical env) run.seeded run.consumer)]
  rw [observed]
  exact congrArg some equal

end FT1536.Source3.KeygenExecutionEmbedding134
