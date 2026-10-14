import Source3.KeygenSuccessCount110

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLawSupport110
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenSeededExecution109 (Execution)
open KeygenWholeBytes088 (Packet)
open KeygenWholeCall088 (Failure)

theorem failure_iff (env : Env) (input : Input env) (seed : Seed) (cause : Failure) :
    KeygenByteGame109.evaluate env input seed = some (.inl cause) ↔
      ∃ run : Execution env input seed, run.trace.failure = some cause := by
  constructor
  · intro failed
    obtain ⟨run, observed⟩ := (KeygenByteGame109.some_iff env input seed _).mp failed
    have classified := (KeygenWholeBytes088.observe_left_iff run.domain run.consumer cause).mp observed
    rw [run.consumer_failure] at classified
    exact ⟨run, classified⟩
  · rintro ⟨run, classified⟩
    apply (KeygenByteGame109.some_iff env input seed _).mpr
    refine ⟨run, ?_⟩
    apply (KeygenWholeBytes088.observe_left_iff run.domain run.consumer cause).mpr
    rw [run.consumer_failure]
    exact classified

theorem conditioned_decoders (env : Env) (input : Input env) (q : Law Packet)
    (constructed : KeygenProbability110.successfulLaw env input = some q)
    (packet : Packet) (positive : 0 < q.mass packet) :
    (KeygenSecretPacket081.DecodeSecret (KeygenWholeBytes088.secretBytes packet)).isSome = true ∧
    (KeygenPublicPacket077.DecodePublic (KeygenWholeBytes088.publicBytes packet)).isSome = true := by
  obtain ⟨seed, returned⟩ := KeygenProbability110.conditional_source env input q constructed packet positive
  exact KeygenByteFacts109.decoders_defined env input seed packet returned

theorem conditioned_source (env : Env) (input : Input env) (q : Law Packet)
    (constructed : KeygenProbability110.successfulLaw env input = some q)
    (packet : Packet) (positive : 0 < q.mass packet) :
    ∃ seed, ∃ run : Execution env input seed,
      ∃ result : KeygenSourceToFiber001.Output (KeygenCanonicalAddresses108.canonical env) run.seeded run.consumer.out,
        KeygenSourceToFiber001.Contract result ∧
        KeygenWholeBytes088.secretBytes packet = KeygenSourceToFiber001.secretBytes result ∧
        KeygenWholeBytes088.publicBytes packet = KeygenSourceToFiber001.publicBytes result := by
  obtain ⟨seed, returned⟩ := KeygenProbability110.conditional_source env input q constructed packet positive
  exact ⟨seed, KeygenByteGame109.successful_source env input seed packet returned⟩

end FT1536.Source3.KeygenLawSupport110
