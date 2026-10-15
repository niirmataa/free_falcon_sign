import Source3.KeygenFirstAttempt112
import Source3.KeygenSuccessMass112
import Source3.KeygenByteGame134
import Source3.KeygenCertificateSource134
import Source3.KeygenSeededExecution134
import Source3.KeygenWholeBytes134
import Source3.KeygenWholeTrace134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenFirstAttempt134
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed Seeded)
open KeygenSeededExecution134 (Execution)
open KeygenWholeBytes088 (Packet)




open KeygenFirstAttempt112
structure First (env : Env) (input : Input env) (seed : Seed) where
  seeded : State
  seeding : Seeded (canonical env) input.base input.seedBlock seed seeded
  bound : State
  entry : State
  events : List KeygenEntropySource.Event
  binding : KeygenMakeArguments.Bind seeded KeygenMakeArguments.params
    (KeygenMakeArguments.values (canonical env).args) bound
  ready : KeygenMakeReady.Prefix (canonical env).ctx bound (canonical env).blocks events ⟨entry,.normal⟩
  attempt : KeygenCertificateSource134.AttemptExecution (canonical env).ctx
  start : attempt.before = entry
  accepted : attempt.out.flow = .breakLoop

structure Encoded (first : First env input seed) where
  out : Result
  calls : List (KeygenPublicCallerSite077.Site (canonical env))
  source : KeygenPublicCallerExecution077.Encoding (canonical env) KeygenMakeProgram.encoding
    first.attempt.out.state out calls
  success : out.flow = .returned (some (.int32 1))

def Accepted (env : Env) (input : Input env) (seed : Seed) : Prop := Nonempty (First env input seed)

def FirstEmitted (env : Env) (input : Input env) (seed : Seed) : Prop :=
  ∃ first : First env input seed, Nonempty (Encoded first)

theorem first_emitted_accepted (env : Env) (input : Input env) (seed : Seed)
    (emitted : FirstEmitted env input seed) : Accepted env input seed := by
  obtain ⟨first, _⟩ := emitted
  exact ⟨first⟩

def execution (first : First env input seed) (encoded : Encoded first) : Execution env input seed :=
  ⟨first.seeded, first.seeding,
    .tail first.bound first.entry first.events ⟨first.attempt.out.state,.normal⟩ encoded.out
      [first.attempt] encoded.calls first.binding first.ready
      (by rw [← first.start]; exact .accepted first.attempt first.accepted)
      rfl encoded.source⟩

theorem execution_success (first : First env input seed) (encoded : Encoded first) :
    (execution first encoded).trace.failure = none := by
  simp only [execution, KeygenWholeTrace134.Trace.failure, encoded.success, ite_true]

theorem first_emitted_success (env : Env) (input : Input env) (seed : Seed)
    (emitted : FirstEmitted env input seed) :
    KeygenSuccessCount110.Successful (KeygenByteGame134.evaluate env input seed) := by
  obtain ⟨first, ⟨encoded⟩⟩ := emitted
  let run := execution first encoded
  have failure : run.consumer.failure = none := run.consumer_failure.trans (execution_success first encoded)
  have success := run.consumer.failure_none_iff.mp failure
  obtain ⟨packet, observed⟩ := KeygenWholeBytes134.success_has_packet run.domain run.consumer success
  have outcome : run.outcome = .inr packet :=
    (KeygenWholeBytes134.observe_right_iff run.domain run.consumer packet).mpr ⟨success, observed⟩
  exact ⟨packet, (KeygenByteGame134.some_iff env input seed _).mpr ⟨run, outcome⟩⟩

end FT1536.Source3.KeygenFirstAttempt134
