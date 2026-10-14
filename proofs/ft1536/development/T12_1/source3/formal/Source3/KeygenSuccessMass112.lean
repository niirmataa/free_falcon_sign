import Source3.KeygenModelBinding111

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSuccessMass112
open Finset
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenWholeBytes088 (Packet)
open KeygenSuccessCount110 (Successful)
open KeygenInputLaw110 (seedLaw)

/-- Exact finite input-atom mass; no empirical frequency appears. -/
noncomputable def atom : ℝ := 1 / (2 : ℝ)^256

theorem atom_positive : 0 < atom := by unfold atom; positivity

theorem event_lower_of_witness (event : Seed → Prop) [DecidablePred event]
    (seed : Seed) (accepted : event seed) : atom ≤ seedLaw.event event := by
  classical
  rw [KeygenSuccessCount110.uniform_event]
  have one : 1 ≤ (univ.filter event).card :=
    one_le_card.mpr ⟨seed, mem_filter.mpr ⟨mem_univ seed, accepted⟩⟩
  have realOne : (1 : ℝ) ≤ ((univ.filter event).card : ℝ) := by exact_mod_cast one
  exact div_le_div_of_nonneg_right realOne (by positivity)

theorem success_lower_of_witness (env : Env) (input : Input env)
    (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame109.evaluate env input seed = some (.inr packet)) :
    atom ≤ KeygenProbability110.successMass env input := by
  classical
  rw [KeygenSuccessCount110.success_count]
  have one : 1 ≤ (univ.filter (fun s : Seed => Successful (KeygenByteGame109.evaluate env input s))).card :=
    one_le_card.mpr ⟨seed, mem_filter.mpr ⟨mem_univ seed, ⟨packet, returned⟩⟩⟩
  have realOne : (1 : ℝ) ≤
      ((univ.filter (fun s : Seed => Successful (KeygenByteGame109.evaluate env input s))).card : ℝ) := by
    exact_mod_cast one
  exact div_le_div_of_nonneg_right realOne (by positivity)

theorem source_lower (env : Env) (input : Input env) (seed : Seed)
    (run : KeygenSeededExecution109.Execution env input seed) (packet : Packet)
    (returned : run.outcome = .inr packet) : atom ≤ KeygenProbability110.successMass env input := by
  apply success_lower_of_witness env input seed packet
  rw [KeygenByteGame109.of_execution env input seed run, returned]

theorem positive_iff_witness (env : Env) (input : Input env) :
    0 < KeygenProbability110.successMass env input ↔
      ∃ seed packet, KeygenByteGame109.evaluate env input seed = some (.inr packet) := by
  classical
  constructor
  · intro positive
    rw [KeygenSuccessCount110.success_count] at positive
    have countPositive : 0 <
        (univ.filter (fun s : Seed => Successful (KeygenByteGame109.evaluate env input s))).card := by
      by_contra absent
      have zero : (univ.filter (fun s : Seed => Successful (KeygenByteGame109.evaluate env input s))).card = 0 := by omega
      rw [zero, Nat.cast_zero, zero_div] at positive
      exact (lt_irrefl 0) positive
    obtain ⟨seed, member⟩ := card_pos.mp countPositive
    obtain ⟨packet, returned⟩ := (mem_filter.mp member).2
    exact ⟨seed, packet, returned⟩
  · rintro ⟨seed, packet, returned⟩
    exact atom_positive.trans_le (success_lower_of_witness env input seed packet returned)

/-- A certified subset is sufficient; a CSV success count is not this premise. -/
theorem certified_set_lower (env : Env) (input : Input env) (seeds : Finset Seed)
    (certified : ∀ seed ∈ seeds, ∃ packet,
      KeygenByteGame109.evaluate env input seed = some (.inr packet)) :
    (seeds.card : ℝ) / (2 : ℝ)^256 ≤ KeygenProbability110.successMass env input := by
  classical
  rw [KeygenSuccessCount110.success_count]
  have included : seeds ⊆ univ.filter (fun seed : Seed => Successful (KeygenByteGame109.evaluate env input seed)) := by
    intro seed member
    exact mem_filter.mpr ⟨mem_univ seed, certified seed member⟩
  have counts := card_le_card included
  have realCounts : (seeds.card : ℝ) ≤
      ((univ.filter (fun seed : Seed => Successful (KeygenByteGame109.evaluate env input seed))).card : ℝ) := by
    exact_mod_cast counts
  exact div_le_div_of_nonneg_right realCounts (by positivity)

end FT1536.Source3.KeygenSuccessMass112
