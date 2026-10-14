import Source3.KeygenModelLaw111
import AssemblyComp

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenModelBinding111
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenWholeBytes088 (Packet)
open KeygenDecodedKey111 (SecretKey joint)
open KeygenModelLaw111 (Key)

/-- Concrete outputs of two independently defined computations: successful
    source bytes and successful decoded-model seeds. This is not a free
    source-law equality or an arbitrary proposition supplied by the caller. -/
def Identified (env : Env) (input : Input env) (packets : Law Packet) (model : Law Key) : Prop :=
  KeygenProbability110.successfulLaw env input = some packets ∧
  KeygenModelLaw111.successfulLaw env input = some model

theorem identify (env : Env) (input : Input env) (packets : Law Packet) (model : Law Key)
    (source : Identified env input packets model) : packets.map joint = model := by
  classical
  have actual := KeygenModelLaw111.conditioned_binding env input packets source.1
  rw [source.2] at actual
  exact (Option.some.inj actual).symm

theorem binding (env : Env) (input : Input env) (packets : Law Packet) (model : Law Key) :
    AssemblyComp.KeyLawBinding (Identified env input packets model) (packets.map joint) model :=
  ⟨identify env input packets model⟩

structure Package (env : Env) (input : Input env) where
  packets : Law Packet
  model : Law Key
  packetSource : KeygenProbability110.successfulLaw env input = some packets
  modelSource : KeygenModelLaw111.successfulLaw env input = some model

noncomputable def package (env : Env) (input : Input env) : Option (Package env input) :=
  match hp : KeygenProbability110.successfulLaw env input with
  | none => none
  | some packets =>
      match hm : KeygenModelLaw111.successfulLaw env input with
      | none => none
      | some model => some ⟨packets,model,hp,hm⟩

theorem package_none_iff (env : Env) (input : Input env) :
    package env input = none ↔ KeygenProbability110.successMass env input = 0 := by
  classical
  unfold package
  split
  next hp =>
    constructor
    · intro _
      exact (KeygenProbability110.zero_success env input).mp hp
    · intro _
      rfl
  next packets hp =>
    split
    next hm =>
      have actual := KeygenModelLaw111.conditioned_binding env input packets hp
      rw [hm] at actual
      cases actual
    next model hm =>
      have positive := KeygenProbability110.positive_success env input packets hp
      simp [ne_of_gt positive]

theorem Package.identified (p : Package env input) : Identified env input p.packets p.model :=
  ⟨p.packetSource,p.modelSource⟩

theorem Package.laws_equal (p : Package env input) : p.packets.map joint = p.model :=
  identify env input p.packets p.model p.identified

theorem Package.assembly (p : Package env input) :
    AssemblyComp.KeyLawBinding (Identified env input p.packets p.model) (p.packets.map joint) p.model :=
  binding env input p.packets p.model

/-- SigmaMath receives the public marginal of the SAME joint law. -/
theorem public_marginal (env : Env) (input : Input env) (packets : Law Packet) (model : Law Key)
    (source : Identified env input packets model) :
    SigmaMath.muH model = packets.map (fun packet => (joint packet).2) := by
  classical
  rw [← identify env input packets model source]
  exact KeygenLawAlgebra110.map_map packets joint Prod.snd

theorem model_source (env : Env) (input : Input env) (packets : Law Packet) (model : Law Key)
    (source : Identified env input packets model) (key : Key) (positive : 0 < model.mass key) :
    ∃ seed, ∃ run : KeygenSeededExecution109.Execution env input seed,
      ∃ result : KeygenSourceToFiber001.Output (KeygenCanonicalAddresses108.canonical env) run.seeded run.consumer.out,
        KeygenSourceToFiber001.Contract result ∧
        key.1.val = (result.secret.vectors 0, result.secret.vectors 1, result.secret.vectors 2, result.secret.vectors 3) ∧
        key.2 = result.secret.h := by
  classical
  have mapped : 0 < (packets.map joint).mass key := by rw [identify env input packets model source]; exact positive
  obtain ⟨packet, mass, decoded⟩ := KeygenWholeLaw088.map_positive_witness packets joint key mapped
  obtain ⟨seed, returned⟩ := KeygenProbability110.conditional_source env input packets source.1 packet mass
  obtain ⟨run, result, contract, secret, publicEq⟩ := KeygenDecodedKey111.same_material env input seed packet returned
  rw [decoded] at secret publicEq
  exact ⟨seed,run,result,contract,secret,publicEq⟩

end FT1536.Source3.KeygenModelBinding111
