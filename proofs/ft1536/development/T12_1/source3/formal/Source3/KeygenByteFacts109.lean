import Source3.KeygenByteGame109

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenByteFacts109
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed)
open KeygenWholeStages109 (Input)
open KeygenSeededExecution109 (Execution)
open KeygenWholeBytes088 (Packet)

theorem attempt_bound (env : Env) (input : Input env) (seed : Seed) (run : Execution env input seed) :
    run.consumer.attempts.length ≤ 3000000 :=
  run.consumer.attempt_bound run.domain.primes run.domain.rev run.domain.rootLegal

theorem no_extra_entropy (env : Env) (input : Input env) (seed : Seed) (run : Execution env input seed) :
    run.consumer.events = [] :=
  KeygenSeedTrace092.no_entropy_events (canonical env) input seed run.seeded run.seeding run.consumer

theorem decoders_defined (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame109.evaluate env input seed = some (.inr packet)) :
    (KeygenSecretPacket081.DecodeSecret (KeygenWholeBytes088.secretBytes packet)).isSome = true ∧
    (KeygenPublicPacket077.DecodePublic (KeygenWholeBytes088.publicBytes packet)).isSome = true := by
  obtain ⟨run, result, contract, secret, publicBytes⟩ := KeygenByteGame109.successful_source env input seed packet returned
  rw [secret, publicBytes, contract.secretDecoded, contract.publicDecoded]
  exact ⟨rfl, rfl⟩

end FT1536.Source3.KeygenByteFacts109
