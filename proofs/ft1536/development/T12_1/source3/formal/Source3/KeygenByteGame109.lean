import Source3.KeygenSeededExecution109

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenByteGame109
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenWholeStages109 (Input)
open KeygenWholeBytes088 (Outcome Packet observe)
open KeygenSeededExecution109 (Execution)

/-- Whole source-defined outcome for one input seed. Choice ranges over
    ALL finite executions and is observationally irrelevant by unique.
    none is absence of a finite defined initialization+invocation, not a
    disguised return0 or a claim of proven infinite defined execution. -/
noncomputable def evaluate (env : Env) (input : Input env) (seed : Seed) : Option Outcome := by
  classical
  exact if present : Nonempty (Execution env input seed) then some (Classical.choice present).outcome else none

theorem of_execution (env : Env) (input : Input env) (seed : Seed) (run : Execution env input seed) :
    evaluate env input seed = some run.outcome := by
  have present : Nonempty (Execution env input seed) := ⟨run⟩
  unfold evaluate
  rw [dite_eq_left present]
  exact congrArg some (KeygenSeededExecution109.unique env input seed (Classical.choice present) run)

theorem none_iff (env : Env) (input : Input env) (seed : Seed) :
    evaluate env input seed = none ↔ ¬ Nonempty (Execution env input seed) := by
  unfold evaluate
  split_ifs with present <;> simp [present]

theorem some_iff (env : Env) (input : Input env) (seed : Seed) (out : Outcome) :
    evaluate env input seed = some out ↔ ∃ run : Execution env input seed, run.outcome = out := by
  constructor
  · intro value
    unfold evaluate at value
    split_ifs at value with present
    · exact ⟨Classical.choice present, Option.some.inj value⟩
  · rintro ⟨run, equal⟩
    rw [of_execution env input seed run, equal]

theorem of_source (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (source : KeygenWholeCall088.Trace (canonical env) seeded) :
    evaluate env input seed = some (observe (KeygenWholeStages109.domain env input seed seeded seeding) source) := by
  obtain ⟨run, equal⟩ := KeygenSeededExecution109.source_execution env input seed seeded seeding source
  exact (some_iff env input seed _).mpr ⟨run, equal⟩

theorem no_readiness_failure (env : Env) (input : Input env) (seed : Seed) :
    evaluate env input seed ≠ some (.inl .readiness) := by
  intro failed
  obtain ⟨run, observed⟩ := (some_iff env input seed _).mp failed
  have classified := (KeygenWholeBytes088.observe_left_iff run.domain run.consumer .readiness).mp observed
  exact KeygenSeedTrace092.no_readiness_failure (canonical env) input seed run.seeded run.seeding run.consumer classified

theorem successful_source (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : evaluate env input seed = some (.inr packet)) :
    ∃ run : Execution env input seed,
      ∃ result : KeygenSourceToFiber001.Output (canonical env) run.seeded run.consumer.out,
        KeygenSourceToFiber001.Contract result ∧
        KeygenWholeBytes088.secretBytes packet = KeygenSourceToFiber001.secretBytes result ∧
        KeygenWholeBytes088.publicBytes packet = KeygenSourceToFiber001.publicBytes result := by
  obtain ⟨run, observed⟩ := (some_iff env input seed _).mp returned
  exact ⟨run, KeygenWholeBytes088.observed_contract run.domain run.consumer packet observed⟩

end FT1536.Source3.KeygenByteGame109
