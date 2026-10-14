import Source3.KeygenLawBoundary087
import Mathlib.Data.Fintype.Card

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Cardinal obstruction at the input boundary. This quantifies over EVERY
   deterministic map from one 32-byte seed, including a partial output map.
   It is not a proof that source KeyGen terminates or has a successful seed.
   The target here is the full pre-gate MODE1 pair, not accepted key material. -/
namespace FT1536.Source3.KeygenSeedSupport087
open Finset KeygenLawBoundary087

abbrev Seed32 := Fin 32 → Fin 256
abbrev Candidate := Fin 3072 → Fin 3

theorem seed_power_bound : (256 : ℕ)^32 < 3^256 := by norm_num

theorem extended_power_bound (n : ℕ) (large : 256 ≤ n) : (256 : ℕ)^32 < 3^n :=
  Nat.lt_of_lt_of_le seed_power_bound (Nat.pow_le_pow_right (by decide) large)

theorem fewer_seeds : Fintype.card Seed32 < Fintype.card Candidate := by
  simpa only [Seed32, Candidate, Fintype.card_fun, Fintype.card_fin]
    using extended_power_bound 3072 (by decide)

theorem not_surjective (f : Seed32 → Candidate) : ¬ Function.Surjective f := by
  intro surjective
  have bound := Fintype.card_le_of_surjective f surjective
  exact (Nat.not_le_of_gt fewer_seeds) bound

/-- A seed can yield at most one candidate. Allowing failures does not
    enlarge the reachable candidate set. -/
theorem missing_candidate (run : Seed32 → Option Candidate) :
    ∃ c, ∀ s, run s ≠ some c := by
  classical
  by_contra! covered
  let complete : Seed32 → Candidate := fun s => (run s).getD (fun _ => 0)
  apply not_surjective complete
  intro c
  obtain ⟨s, value⟩ := covered c
  exact ⟨s, by simp [complete, value]⟩

/-- Exact seeded conditional laws cannot equal the uniform law on all
    3^3072 pre-gate candidates. This holds for every seed distribution,
    not just the already authorized uniform-seed experiment. -/
theorem conditioned_not_full_uniform (seedLaw : Law Seed32)
    (run : Seed32 → Option Candidate) (q : Law Candidate)
    (conditional : conditionSuccess (seedLaw.map run) = some q) :
    q ≠ Law.uniform := by
  classical
  obtain ⟨c, missing⟩ := missing_candidate run
  have zero : (seedLaw.map run).mass (some c) = 0 := by
    change (∑ s, seedLaw.mass s * (Law.pure (run s)).mass (some c)) = 0
    apply sum_eq_zero
    intro s _
    simp [Law.pure, Ne.symm (missing s)]
  have qzero : q.mass c = 0 := by
    rw [condition_mass _ q conditional, zero, zero_div]
  intro equal
  rw [equal] at qzero
  have positive : 0 < (Law.uniform : Law Candidate).mass c := by
    change 0 < 1 / (Fintype.card Candidate : ℝ)
    positivity
  exact (ne_of_gt positive) qzero

end FT1536.Source3.KeygenSeedSupport087
