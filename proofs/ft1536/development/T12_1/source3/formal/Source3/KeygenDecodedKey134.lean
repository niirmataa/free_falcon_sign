import Source3.KeygenDecodedKey111
import Source3.KeygenLawSupport110
import FT1536.Model
import Source3.KeygenByteFacts134
import Source3.KeygenByteGame134
import Source3.KeygenSeededExecution134
import Source3.KeygenSourceToFiber134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenDecodedKey134
open KeygenWholeBytes088 (Secret Packet secretBytes publicBytes)
open KeygenSecretPacket081 (Material DecodeSecret)
open KeygenPublicPacket077 (DecodePublic)
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)




open KeygenDecodedKey111
theorem source_decode (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame134.evaluate env input seed = some (.inr packet)) : decode packet = some (joint packet) := by
  have parsed := KeygenByteFacts134.decoders_defined env input seed packet returned
  exact decode_defined packet parsed.1 parsed.2

theorem same_material (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame134.evaluate env input seed = some (.inr packet)) :
    ∃ run : KeygenSeededExecution134.Execution env input seed,
      ∃ result : KeygenSourceToFiber134.Output (KeygenCanonicalAddresses108.canonical env) run.seeded run.consumer.out,
        KeygenSourceToFiber134.Contract result ∧
        (joint packet).1.val = (result.secret.vectors 0, result.secret.vectors 1, result.secret.vectors 2, result.secret.vectors 3) ∧
        (joint packet).2 = result.secret.h := by
  obtain ⟨run, result, contract, secret, publicEq⟩ := KeygenByteGame134.successful_source env input seed packet returned
  have decodedSecret : DecodeSecret (secretBytes packet) = some
      (result.secret.vectors 0, result.secret.vectors 1, result.secret.vectors 2, result.secret.vectors 3) := by
    rw [secret]
    exact contract.secretDecoded
  have decodedPublic : DecodePublic (publicBytes packet) = some result.secret.h := by
    rw [publicEq]
    exact contract.publicDecoded
  exact ⟨run, result, contract, joint_values packet _ _ decodedSecret decodedPublic⟩

end FT1536.Source3.KeygenDecodedKey134
