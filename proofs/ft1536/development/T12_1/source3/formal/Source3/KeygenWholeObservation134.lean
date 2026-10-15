import Source3.KeygenWholeObservation109
import Source3.KeygenWholeUnique109
import Source3.KeygenWholeBytes134
import Source3.KeygenWholeCall134
import Source3.KeygenWholeUnique134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenWholeObservation134
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenWholeBytes088 (Domain Outcome Packet)
open KeygenWholeBytes134 (observe)
open KeygenWholeCall134 (Trace)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenWholeStages109 (Input)


open KeygenWholeObservation109
theorem congruent (env : Env) (caller : State) (da db : Domain env caller) (a b : Trace env caller)
    (state : a.out = b.out) (failure : a.failure = b.failure) : observe da a = observe db b := by
  cases observed : observe da a with
  | inl cause =>
      have left := (KeygenWholeBytes134.observe_left_iff da a cause).mp observed
      have right : b.failure = some cause := by rw [← failure]; exact left
      exact ((KeygenWholeBytes134.observe_left_iff db b cause).mpr right).symm
  | inr packet =>
      obtain ⟨success, bytes⟩ := (KeygenWholeBytes134.observe_right_iff da a packet).mp observed
      have right : KeygenSourceToFiber001.Success b.out ∧ KeygenWholeBytes088.Observed env b.out packet := by
        rw [← state]
        exact ⟨success, bytes⟩
      exact ((KeygenWholeBytes134.observe_right_iff db b packet).mpr right).symm

theorem unique (env : Env) (input : Input env) (seed : Seed) (seeded : State)
    (seeding : Seeded (canonical env) input.base input.seedBlock seed seeded)
    (da db : Domain (canonical env) seeded) (a b : Trace (canonical env) seeded) : observe da a = observe db b := by
  have same := KeygenWholeUnique134.source env input seed seeded seeding a b
  exact congruent (canonical env) seeded da db a b same.1 same.2

end FT1536.Source3.KeygenWholeObservation134
