import Source3.KeygenLawAlgebra110

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenProbability110
open Finset
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenWholeBytes088 (Outcome Packet)
open KeygenWholeLaw088 (CallOutcome)
open KeygenInputLaw110 (seedLaw)

/-- The actual whole program pushforward. The caller is fixed outside the
    seed map; no execution family, key law, IID or PRG premise is supplied. -/
noncomputable def law (env : Env) (input : Input env) : Law CallOutcome := by
  classical
  exact seedLaw.map (KeygenByteGame109.evaluate env input)

theorem normalized (env : Env) (input : Input env) : ∑ out, (law env input).mass out = 1 := (law env input).total

theorem mass_formula (env : Env) (input : Input env) (out : CallOutcome) :
    (law env input).mass out = ∑ seed, if KeygenByteGame109.evaluate env input seed = out then 1 / (2:ℝ)^256 else 0 := by
  classical
  simp [law, KeygenLawAlgebra110.map_mass, KeygenInputLaw110.seed_mass]

theorem mass_count (env : Env) (input : Input env) (out : CallOutcome) :
    (law env input).mass out =
      ((univ.filter (fun seed : Seed => KeygenByteGame109.evaluate env input seed = out)).card : ℝ) / (2:ℝ)^256 := by
  classical
  rw [mass_formula, ← sum_filter]
  simp [div_eq_mul_inv]

theorem readiness_zero (env : Env) (input : Input env) : (law env input).mass (some (.inl .readiness)) = 0 := by
  rw [mass_formula]
  apply sum_eq_zero
  intro seed _
  simp only [KeygenByteGame109.no_readiness_failure env input seed, ite_false]

noncomputable def successMass (env : Env) (input : Input env) : ℝ := KeygenWholeLaw088.emittedMass (law env input)
noncomputable def successfulLaw (env : Env) (input : Input env) : Option (Law Packet) := KeygenWholeLaw088.successfulLaw (law env input)

theorem accounting (env : Env) (input : Input env) :
    KeygenWholeLaw088.noReturnMass (law env input) +
      (∑ cause, KeygenWholeLaw088.failureMass (law env input) cause) + successMass env input = 1 :=
  KeygenWholeLaw088.full_accounting (law env input)

theorem zero_success (env : Env) (input : Input env) :
    successfulLaw env input = none ↔ successMass env input = 0 :=
  KeygenWholeLaw088.successful_none_iff (law env input)

theorem positive_success (env : Env) (input : Input env) (q : Law Packet)
    (constructed : successfulLaw env input = some q) : 0 < successMass env input :=
  KeygenWholeLaw088.successful_positive (law env input) q constructed

theorem conditional_mass (env : Env) (input : Input env) (q : Law Packet)
    (constructed : successfulLaw env input = some q) (packet : Packet) :
    q.mass packet = (law env input).mass (some (.inr packet)) / successMass env input :=
  KeygenWholeLaw088.successful_mass (law env input) q constructed packet

theorem conditional_count (env : Env) (input : Input env) (q : Law Packet)
    (constructed : successfulLaw env input = some q) (packet : Packet) :
    q.mass packet =
      (((univ.filter (fun seed : Seed => KeygenByteGame109.evaluate env input seed = some (.inr packet))).card : ℝ) /
        (2:ℝ)^256) / successMass env input := by
  rw [conditional_mass env input q constructed packet, mass_count]

theorem positive_source (env : Env) (input : Input env) (packet : Packet)
    (positive : 0 < (law env input).mass (some (.inr packet))) :
    ∃ seed, KeygenByteGame109.evaluate env input seed = some (.inr packet) := by
  classical
  obtain ⟨seed, _, observed⟩ := KeygenWholeLaw088.map_positive_witness seedLaw
    (KeygenByteGame109.evaluate env input) (some (.inr packet)) positive
  exact ⟨seed, observed⟩

theorem conditional_source (env : Env) (input : Input env) (q : Law Packet)
    (constructed : successfulLaw env input = some q) (packet : Packet) (positive : 0 < q.mass packet) :
    ∃ seed, KeygenByteGame109.evaluate env input seed = some (.inr packet) := by
  apply positive_source env input packet
  by_contra failed
  have zero : (law env input).mass (some (.inr packet)) = 0 :=
    le_antisymm (le_of_not_gt failed) ((law env input).nonneg _)
  rw [conditional_mass env input q constructed packet, zero, zero_div] at positive
  exact (lt_irrefl 0) positive

end FT1536.Source3.KeygenProbability110
