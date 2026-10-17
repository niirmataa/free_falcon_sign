import Source3.KeygenFirstMass134
import Source3.KeygenSuccessMass134
import Source3.KeygenModelBinding134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/-! # Consumption chain from a positive first-attempt bound to the model package

`KeygenFirstMass134.quantitative` consumes separately proved lower bounds
`a ≤ acceptMass` and `c ≤ codingRatio` for the first actual attempt. This
module closes the remaining consumption step: any positive product `a * c`
is a strictly positive lower bound `Z ≥ a * c > 0` for the corrected whole
law `KeygenProbability134.successMass`, and any positive `Z` unlocks the
`KeygenModelBinding134.package` (via its `package_none_iff` zero test).

It also records the exact structural reduction behind the analytic route:
positivity of the first-attempt acceptance mass is equivalent to the
existence of one accepting seed under the actual uniform 32-byte input law,
so a strictly positive analytical bound for this law carries the same
existence content as a concrete seed witness. No numerical bound is proved
here; this is the consumer side only. -/
namespace FT1536.Source3.KeygenModelUnlock134
open Finset
open KeygenMakeInvocation (Env)
open KeygenWholeStages109 (Input)
open KeygenSeedEntry089 (Seed)
open KeygenWholeBytes088 (Packet)
open KeygenInputLaw110 (seedLaw)
open KeygenFirstAttempt134 (Accepted FirstEmitted)

/-- Exact finite count form of the first-attempt acceptance mass under the
    actual uniform 32-byte seed law: the count is over seeds. -/
noncomputable def acceptCount (env : Env) (input : Input env) : ℝ := by
  classical
  exact ((univ.filter (fun seed : Seed => Accepted env input seed)).card : ℝ) / (2:ℝ)^256

/-- Exact finite count form of the first-attempt encoded mass. -/
noncomputable def encodedCount (env : Env) (input : Input env) : ℝ := by
  classical
  exact ((univ.filter (fun seed : Seed => FirstEmitted env input seed)).card : ℝ) / (2:ℝ)^256

theorem acceptMass_uniform_count (env : Env) (input : Input env) :
    KeygenFirstMass134.acceptMass env input = acceptCount env input := by
  classical
  exact KeygenSuccessCount110.uniform_event (Accepted env input)

theorem encodedMass_uniform_count (env : Env) (input : Input env) :
    KeygenFirstMass134.encodedMass env input = encodedCount env input := by
  classical
  exact KeygenSuccessCount110.uniform_event (FirstEmitted env input)

/-- Exact structural reduction: positive first-attempt acceptance mass for
    the actual 32-byte seed law is equivalent to the existence of one
    accepting seed. An analytical lower bound `a > 0` for this law therefore
    cannot be weaker than a witness existence statement. -/
theorem acceptMass_positive_iff (env : Env) (input : Input env) :
    0 < KeygenFirstMass134.acceptMass env input ↔ ∃ seed : Seed, Accepted env input seed := by
  classical
  rw [acceptMass_uniform_count]
  show 0 < ((univ.filter (fun seed : Seed => Accepted env input seed)).card : ℝ) / (2:ℝ)^256 ↔
    ∃ seed : Seed, Accepted env input seed
  constructor
  · intro positive
    have countPositive : 0 < (univ.filter (fun seed : Seed => Accepted env input seed)).card := by
      by_contra absent
      have zero : (univ.filter (fun seed : Seed => Accepted env input seed)).card = 0 := by omega
      rw [zero, Nat.cast_zero, zero_div] at positive
      exact (lt_irrefl 0) positive
    obtain ⟨seed, member⟩ := card_pos.mp countPositive
    exact ⟨seed, (mem_filter.mp member).2⟩
  · rintro ⟨seed, accepted⟩
    have one : 1 ≤ (univ.filter (fun seed : Seed => Accepted env input seed)).card :=
      one_le_card.mpr ⟨seed, mem_filter.mpr ⟨mem_univ seed, accepted⟩⟩
    have positive : (0:ℝ) < ((univ.filter (fun seed : Seed => Accepted env input seed)).card : ℝ) := by
      have : (0:ℕ) < (univ.filter (fun seed : Seed => Accepted env input seed)).card :=
        zero_lt_one.trans_le one
      exact_mod_cast this
    exact div_pos positive (by positivity)

theorem encodedMass_positive_iff (env : Env) (input : Input env) :
    0 < KeygenFirstMass134.encodedMass env input ↔ ∃ seed : Seed, FirstEmitted env input seed := by
  classical
  rw [encodedMass_uniform_count]
  show 0 < ((univ.filter (fun seed : Seed => FirstEmitted env input seed)).card : ℝ) / (2:ℝ)^256 ↔
    ∃ seed : Seed, FirstEmitted env input seed
  constructor
  · intro positive
    have countPositive : 0 < (univ.filter (fun seed : Seed => FirstEmitted env input seed)).card := by
      by_contra absent
      have zero : (univ.filter (fun seed : Seed => FirstEmitted env input seed)).card = 0 := by omega
      rw [zero, Nat.cast_zero, zero_div] at positive
      exact (lt_irrefl 0) positive
    obtain ⟨seed, member⟩ := card_pos.mp countPositive
    exact ⟨seed, (mem_filter.mp member).2⟩
  · rintro ⟨seed, emitted⟩
    have one : 1 ≤ (univ.filter (fun seed : Seed => FirstEmitted env input seed)).card :=
      one_le_card.mpr ⟨seed, mem_filter.mpr ⟨mem_univ seed, emitted⟩⟩
    have positive : (0:ℝ) < ((univ.filter (fun seed : Seed => FirstEmitted env input seed)).card : ℝ) := by
      have : (0:ℕ) < (univ.filter (fun seed : Seed => FirstEmitted env input seed)).card :=
        zero_lt_one.trans_le one
      exact_mod_cast this
    exact div_pos positive (by positivity)

/-- The whole-law positivity target `Z ≥ a * c > 0` consumed from the two
    separately proved first-attempt bounds. -/
theorem z_positive_of_first_attempt_bounds (env : Env) (input : Input env) (a c : ℝ)
    (acceptedLower : a ≤ KeygenFirstMass134.acceptMass env input)
    (codingLower : c ≤ KeygenFirstMass134.codingRatio env input)
    (codingNonnegative : 0 ≤ c) (positive : 0 < a * c) :
    0 < KeygenProbability134.successMass env input :=
  positive.trans_le (KeygenFirstMass134.quantitative env input a c
    acceptedLower codingLower codingNonnegative)

theorem z_bound_of_first_attempt_bounds (env : Env) (input : Input env) (a c : ℝ)
    (acceptedLower : a ≤ KeygenFirstMass134.acceptMass env input)
    (codingLower : c ≤ KeygenFirstMass134.codingRatio env input)
    (codingNonnegative : 0 ≤ c) :
    a * c ≤ KeygenProbability134.successMass env input :=
  KeygenFirstMass134.quantitative env input a c acceptedLower codingLower codingNonnegative

/-- Any positive whole-call mass unlocks the model package: the package is
    `none` exactly when the success mass is zero. -/
theorem package_of_z_positive (env : Env) (input : Input env)
    (positive : 0 < KeygenProbability134.successMass env input) :
    ∃ p : KeygenModelBinding134.Package env input,
      KeygenModelBinding134.package env input = some p := by
  have nonzero : KeygenProbability134.successMass env input ≠ 0 := ne_of_gt positive
  have notNone : KeygenModelBinding134.package env input ≠ none := by
    intro absent
    exact nonzero ((KeygenModelBinding134.package_none_iff env input).mp absent)
  obtain ⟨p, eq⟩ := Option.ne_none_iff_exists.mp notNone
  exact ⟨p, eq.symm⟩

theorem package_of_first_attempt_bounds (env : Env) (input : Input env) (a c : ℝ)
    (acceptedLower : a ≤ KeygenFirstMass134.acceptMass env input)
    (codingLower : c ≤ KeygenFirstMass134.codingRatio env input)
    (codingNonnegative : 0 ≤ c) (positive : 0 < a * c) :
    ∃ p : KeygenModelBinding134.Package env input,
      KeygenModelBinding134.package env input = some p :=
  package_of_z_positive env input
    (z_positive_of_first_attempt_bounds env input a c acceptedLower codingLower
      codingNonnegative positive)

/-- Witness route: one successful source seed already unlocks the package. -/
theorem z_positive_of_witness (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame134.evaluate env input seed = some (.inr packet)) :
    0 < KeygenProbability134.successMass env input :=
  (KeygenSuccessMass134.positive_iff_witness env input).mpr ⟨seed, packet, returned⟩

theorem package_of_witness (env : Env) (input : Input env) (seed : Seed) (packet : Packet)
    (returned : KeygenByteGame134.evaluate env input seed = some (.inr packet)) :
    ∃ p : KeygenModelBinding134.Package env input,
      KeygenModelBinding134.package env input = some p :=
  package_of_z_positive env input (z_positive_of_witness env input seed packet returned)

/-- Finite certified-set route: a certified set of distinct successful seeds
    gives `|seeds| / 2^256 ≤ Z`, and positive cardinality unlocks the
    package. A CSV success count is not this premise. -/
theorem package_of_certified_set (env : Env) (input : Input env) (seeds : Finset Seed)
    (certified : ∀ seed ∈ seeds, ∃ packet,
      KeygenByteGame134.evaluate env input seed = some (.inr packet))
    (nonempty : 0 < seeds.card) :
    ∃ p : KeygenModelBinding134.Package env input,
      KeygenModelBinding134.package env input = some p := by
  classical
  obtain ⟨seed, member⟩ := card_pos.mp nonempty
  obtain ⟨packet, returned⟩ := certified seed member
  exact package_of_witness env input seed packet returned

end FT1536.Source3.KeygenModelUnlock134
