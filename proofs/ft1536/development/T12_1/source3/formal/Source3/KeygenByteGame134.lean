import Source3.KeygenByteGame109
import Source3.KeygenSeededExecution109
import Source3.KeygenSeedTrace134
import Source3.KeygenSeededExecution134
import Source3.KeygenSourceToFiber134
import Source3.KeygenWholeBytes134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenByteGame134
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenWholeStages109 (Input)
open KeygenWholeBytes088 (Outcome Packet)
open KeygenWholeBytes134 (observe)
open KeygenSeededExecution134 (Execution)






open KeygenByteGame109
noncomputable def evaluate (env : Env) (input : Input env) (seed : Seed) : Option Outcome := by
  classical
  exact if present : Nonempty (Execution env input seed) then some (Classical.choice present).outcome else none

theorem of_execution (env : Env) (input : Input env) (seed : Seed) (run : Execution env input seed) :
    evaluate env input seed = some run.outcome := by
  have present : Nonempty (Execution env input seed) := ⟨run⟩
  unfold evaluate
  rw [dite_eq_left present]
  exact congrArg some (KeygenSeededExecution134.unique env input seed (Classical.choice present) run)

theorem some_iff (env : Env) (input : Input env) (seed : Seed) (out : Outcome) :
    evaluate env input seed = some out ↔ ∃ run : Execution env input seed, run.outcome = out := by
  constructor
  · intro value
    unfold evaluate at value
    split_ifs at value with present
    · exact ⟨Classical.choice present, Option.some.inj value⟩
  · rintro ⟨run, equal⟩
    rw [of_execution env input seed run, equal]

theorem no_readiness_failure (env : Env) (input : Input env) (seed : Seed) :
    evaluate env input seed ≠ some (.inl .readiness) := by
  intro failed
  obtain ⟨run, observed⟩ := (some_iff env input seed _).mp failed
  have classified := (KeygenWholeBytes134.observe_left_iff run.domain run.consumer .readiness).mp observed
  exact KeygenSeedTrace134.no_readiness_failure (canonical env) input seed run.seeded run.seeding run.consumer classified

theorem successful_source (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : evaluate env input seed = some (.inr packet)) :
    ∃ run : Execution env input seed,
      ∃ result : KeygenSourceToFiber134.Output (canonical env) run.seeded run.consumer.out,
        KeygenSourceToFiber134.Contract result ∧
        KeygenWholeBytes088.secretBytes packet = KeygenSourceToFiber134.secretBytes result ∧
        KeygenWholeBytes088.publicBytes packet = KeygenSourceToFiber134.publicBytes result := by
  obtain ⟨run, observed⟩ := (some_iff env input seed _).mp returned
  exact ⟨run, KeygenWholeBytes134.observed_contract run.domain run.consumer packet observed⟩

end FT1536.Source3.KeygenByteGame134
