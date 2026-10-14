import FT1536.Basic
import Mathlib.Data.Fintype.Option

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact finite-law algebra, not a definition of the C execution law.
   Failure remains present until conditioning; zero success mass produces
   no conditional law. The counterexample below tests the proposed D1
   inference, not SHAKE or the FT1536 acceptance predicate. -/
namespace FT1536.Source3.KeygenLawBoundary087
open Finset

variable {K : Type} [Fintype K]

noncomputable def successMass (p : Law (Option K)) : ℝ :=
  ∑ k, p.mass (some k)

noncomputable def conditionSuccess (p : Law (Option K)) : Option (Law K) :=
  if positive : 0 < successMass p then
    some (Law.weighted (fun k => p.mass (some k))
      (fun k => p.nonneg (some k)) positive)
  else none

theorem failure_success (p : Law (Option K)) :
    p.mass none + successMass p = 1 := by
  simpa only [successMass, Fintype.sum_option] using p.total

theorem condition_none_iff (p : Law (Option K)) :
    conditionSuccess p = none ↔ successMass p = 0 := by
  have nonnegative : 0 ≤ successMass p :=
    sum_nonneg (fun k _ => p.nonneg (some k))
  unfold conditionSuccess
  split_ifs with positive
  · simp only [false_iff]
    exact ne_of_gt positive
  · simp only [true_iff]
    exact le_antisymm (le_of_not_gt positive) nonnegative

theorem condition_mass (p : Law (Option K)) (q : Law K)
    (identified : conditionSuccess p = some q) (k : K) :
    q.mass k = p.mass (some k) / successMass p := by
  unfold conditionSuccess at identified
  split_ifs at identified with positive
  · cases Option.some.inj identified
    rfl

theorem condition_positive (p : Law (Option K)) (q : Law K)
    (identified : conditionSuccess p = some q) : 0 < successMass p := by
  unfold conditionSuccess at identified
  split_ifs at identified with positive
  · exact positive

theorem law_ext {A : Type} [Fintype A] (p q : Law A)
    (equal : ∀ x, p.mass x = q.mass x) : p = q := by
  cases p with
  | mk pm pn pt =>
    cases q with
    | mk qm qn qt =>
      have same : pm = qm := funext equal
      cases same
      rfl

/-- This is the exact distributional obligation. A loop can preserve the
    conditional law without IID, but it must satisfy these normalized
    mass identities; control flow alone does not imply them. -/
theorem condition_equal_iff (p r : Law (Option K)) (q t : Law K)
    (hp : conditionSuccess p = some q) (hr : conditionSuccess r = some t) :
    q = t ↔ ∀ k, p.mass (some k) / successMass p =
      r.mass (some k) / successMass r := by
  constructor
  · intro equal k
    rw [← condition_mass p q hp k, ← condition_mass r t hr k, equal]
  · intro equal
    apply law_ext
    intro k
    rw [condition_mass p q hp k, condition_mass r t hr k]
    exact equal k

/- A uniform two-bit seed drives two deterministic, correlated attempts.
   Their marginal laws are identical. Each row lists attempt 0, attempt 1:
     0: (some false, none)       1: (some true, some true)
     2: (none, some false)       3: (none, none).
   No premise is used for this example. -/
abbrev Seed := Fin 4

def attempt0 (s : Seed) : Option Bool :=
  if s.val = 0 then some false else if s.val = 1 then some true else none

def attempt1 (s : Seed) : Option Bool :=
  if s.val = 2 then some false else if s.val = 1 then some true else none

def firstSuccess (x y : Option Bool) : Option Bool :=
  match x with
  | some k => some k
  | none => y

def capped (s : Seed) : Option Bool := firstSuccess (attempt0 s) (attempt1 s)

noncomputable def firstLaw : Law (Option Bool) := Law.uniform.map attempt0
noncomputable def nextLaw : Law (Option Bool) := Law.uniform.map attempt1
noncomputable def cappedLaw : Law (Option Bool) := Law.uniform.map capped

theorem same_attempt_marginals : firstLaw = nextLaw := by
  apply law_ext
  intro k
  cases k with
  | none =>
    norm_num [firstLaw, nextLaw, Law.map, Law.bind, Law.pure, Law.uniform,
      Fin.sum_univ_succ, attempt0, attempt1]
  | some b =>
    cases b <;> norm_num [firstLaw, nextLaw, Law.map, Law.bind, Law.pure,
      Law.uniform, Fin.sum_univ_succ, attempt0, attempt1]

theorem first_success_mass : successMass firstLaw = 1/2 := by
  norm_num [successMass, firstLaw, Law.map, Law.bind, Law.pure, Law.uniform,
    Fin.sum_univ_succ, attempt0, Fintype.sum_bool]

theorem capped_success_mass : successMass cappedLaw = 3/4 := by
  norm_num [successMass, cappedLaw, Law.map, Law.bind, Law.pure, Law.uniform,
    Fin.sum_univ_succ, attempt0, attempt1, capped, firstSuccess, Fintype.sum_bool]

noncomputable def firstConditional : Law Bool :=
  Law.weighted (fun k => firstLaw.mass (some k))
    (fun k => firstLaw.nonneg (some k)) (by
      change 0 < successMass firstLaw
      rw [first_success_mass]
      norm_num)

noncomputable def cappedConditional : Law Bool :=
  Law.weighted (fun k => cappedLaw.mass (some k))
    (fun k => cappedLaw.nonneg (some k)) (by
      change 0 < successMass cappedLaw
      rw [capped_success_mass]
      norm_num)

theorem first_conditioned : conditionSuccess firstLaw = some firstConditional := by
  have positive : 0 < successMass firstLaw := by rw [first_success_mass]; norm_num
  simp only [conditionSuccess, positive, dite_true, firstConditional]

theorem capped_conditioned : conditionSuccess cappedLaw = some cappedConditional := by
  have positive : 0 < successMass cappedLaw := by rw [capped_success_mass]; norm_num
  simp only [conditionSuccess, positive, dite_true, cappedConditional]

theorem first_conditional_false : firstConditional.mass false = 1/2 := by
  rw [condition_mass firstLaw firstConditional first_conditioned, first_success_mass]
  norm_num [firstLaw, Law.map, Law.bind, Law.pure, Law.uniform,
    Fin.sum_univ_succ, attempt0]

theorem capped_conditional_false : cappedConditional.mass false = 2/3 := by
  rw [condition_mass cappedLaw cappedConditional capped_conditioned, capped_success_mass]
  norm_num [cappedLaw, Law.map, Law.bind, Law.pure, Law.uniform,
    Fin.sum_univ_succ, attempt0, attempt1, capped, firstSuccess]

/-- Uniform seed and identical attempt marginals do not suffice for D1's
    per-attempt replacement, even with no serialization rejection. -/
theorem conditional_laws_differ : firstConditional ≠ cappedConditional := by
  intro equal
  have massEqual := congrArg (fun p : Law Bool => p.mass false) equal
  rw [first_conditional_false, capped_conditional_false] at massEqual
  norm_num at massEqual

/-- Even the IID-looking availability formula can hold in this example
    while the conditional output identity is false. -/
theorem availability_does_not_certify_key_law :
    successMass cappedLaw = 1 - (1 - successMass firstLaw)^2 ∧
      firstConditional ≠ cappedConditional := by
  refine ⟨?_, conditional_laws_differ⟩
  rw [first_success_mass, capped_success_mass]
  norm_num

end FT1536.Source3.KeygenLawBoundary087
