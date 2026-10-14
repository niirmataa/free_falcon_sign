import Source3.KeygenLawSupport110
import FT1536.Model

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodedKey111
open KeygenWholeBytes088 (Secret Packet secretBytes publicBytes)
open KeygenSecretPacket081 (Material DecodeSecret)
open KeygenPublicPacket077 (DecodePublic)
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)

/-- Totalization is used only to obtain a finite carrier. Actual source
    outputs are proved to decode, so this fallback has no source mass. -/
def secretValue (packet : Secret) : Material := (DecodeSecret packet.2.val).getD (0,0,0,0)

def SecretKey := {value : Material // ∃ packet : Secret, secretValue packet = value}

def secretKey (packet : Secret) : SecretKey := ⟨secretValue packet, ⟨packet,rfl⟩⟩

instance finiteSecretKey : Finite SecretKey :=
  Finite.of_surjective secretKey (by
    intro key
    obtain ⟨packet, same⟩ := key.property
    exact ⟨packet, Subtype.ext same⟩)

noncomputable instance secretKeyFintype : Fintype SecretKey := Fintype.ofFinite SecretKey

noncomputable instance secretKeyDecidableEq : DecidableEq SecretKey := Classical.decEq SecretKey

def joint (packet : Packet) : SecretKey × Relation.Rq :=
  (secretKey packet.1, (DecodePublic (publicBytes packet)).getD 0)

def decode (packet : Packet) : Option (SecretKey × Relation.Rq) :=
  if (DecodeSecret (secretBytes packet)).isSome && (DecodePublic (publicBytes packet)).isSome
    then some (joint packet) else none

theorem joint_values (packet : Packet) (material : Material) (h : Relation.Rq)
    (secret : DecodeSecret (secretBytes packet) = some material)
    (publicEq : DecodePublic (publicBytes packet) = some h) :
    (joint packet).1.val = material ∧ (joint packet).2 = h := by
  exact ⟨congrArg (fun result : Option Material => result.getD (0,0,0,0)) secret,
    congrArg (fun result : Option Relation.Rq => result.getD 0) publicEq⟩

theorem decode_defined (packet : Packet)
    (secret : (DecodeSecret (secretBytes packet)).isSome = true)
    (publicEq : (DecodePublic (publicBytes packet)).isSome = true) : decode packet = some (joint packet) := by
  simp [decode, secret, publicEq]

theorem source_decode (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame109.evaluate env input seed = some (.inr packet)) : decode packet = some (joint packet) := by
  have parsed := KeygenByteFacts109.decoders_defined env input seed packet returned
  exact decode_defined packet parsed.1 parsed.2

theorem same_material (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame109.evaluate env input seed = some (.inr packet)) :
    ∃ run : KeygenSeededExecution109.Execution env input seed,
      ∃ result : KeygenSourceToFiber001.Output (KeygenCanonicalAddresses108.canonical env) run.seeded run.consumer.out,
        KeygenSourceToFiber001.Contract result ∧
        (joint packet).1.val = (result.secret.vectors 0, result.secret.vectors 1, result.secret.vectors 2, result.secret.vectors 3) ∧
        (joint packet).2 = result.secret.h := by
  obtain ⟨run, result, contract, secret, publicEq⟩ := KeygenByteGame109.successful_source env input seed packet returned
  have decodedSecret : DecodeSecret (secretBytes packet) = some
      (result.secret.vectors 0, result.secret.vectors 1, result.secret.vectors 2, result.secret.vectors 3) := by
    rw [secret]
    exact contract.secretDecoded
  have decodedPublic : DecodePublic (publicBytes packet) = some result.secret.h := by
    rw [publicEq]
    exact contract.publicDecoded
  exact ⟨run, result, contract, joint_values packet _ _ decodedSecret decodedPublic⟩

end FT1536.Source3.KeygenDecodedKey111
