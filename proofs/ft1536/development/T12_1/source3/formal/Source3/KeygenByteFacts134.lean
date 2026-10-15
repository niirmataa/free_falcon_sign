import Source3.KeygenByteFacts109
import Source3.KeygenByteGame109
import Source3.KeygenByteGame134
import Source3.KeygenSeededExecution134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenByteFacts134
open KeygenMakeInvocation (Env)
open KeygenCanonicalAddresses108 (canonical)
open KeygenSeedEntry089 (Seed)
open KeygenWholeStages109 (Input)
open KeygenSeededExecution134 (Execution)
open KeygenWholeBytes088 (Packet)


open KeygenByteFacts109
theorem decoders_defined (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame134.evaluate env input seed = some (.inr packet)) :
    (KeygenSecretPacket081.DecodeSecret (KeygenWholeBytes088.secretBytes packet)).isSome = true ∧
    (KeygenPublicPacket077.DecodePublic (KeygenWholeBytes088.publicBytes packet)).isSome = true := by
  obtain ⟨run, result, contract, secret, publicBytes⟩ := KeygenByteGame134.successful_source env input seed packet returned
  rw [secret, publicBytes, contract.secretDecoded, contract.publicDecoded]
  exact ⟨rfl, rfl⟩

end FT1536.Source3.KeygenByteFacts134
