import FT1536.Basic
import Mathlib.Data.Fintype.Option

namespace FT1536.MathSign
open Finset
variable {α β R : Type*} [Fintype α] [DecidableEq α]

/- `none` in the trial is a norm rejection, not an observed reply. `none` in
the capped result is exhaustion. The terminal alphabet α may itself contain
an encoding-failure tag, which stops immediately and is not retried. -/
noncomputable def cap (trial : Law (Option α)) : ℕ → Law (Option α)
  | 0 => Law.pure none
  | n + 1 => trial.bind fun x => match x with
    | none => cap trial n
    | some y => Law.pure (some y)

theorem cap_none (trial : Law (Option α)) (n : ℕ) :
    (cap trial n).mass none = trial.mass none ^ n := by
  induction n with
  | zero => simp [cap, Law.pure]
  | succ n ih =>
    simp [cap, Law.bind, Law.pure, Fintype.sum_option, ih, pow_succ, mul_comm]

theorem cap_some (trial : Law (Option α)) (n : ℕ) (x : α) :
    (cap trial n).mass (some x) =
      (∑ i ∈ range n, trial.mass none ^ i) * trial.mass (some x) := by
  induction n with
  | zero => simp [cap, Law.pure]
  | succ n ih =>
    simp only [cap, Law.bind, Fintype.sum_option, Law.pure]
    simp only [Option.some.injEq, mul_ite, mul_one, mul_zero, sum_ite_eq,
      mem_univ, ite_true]
    rw [ih]
    have geo : trial.mass none * (∑ i ∈ range n, trial.mass none ^ i) + 1 =
        ∑ i ∈ range (n+1), trial.mass none ^ i := by
      rw [sum_range_succ']
      simp only [pow_zero, pow_succ', ← mul_sum]
    rw [← geo]
    ring

theorem full_reply_law (trial : Law (Option α)) (n : ℕ) :
    (∑ o, (cap trial n).mass o) = 1 ∧
    (cap trial n).mass none = trial.mass none ^ n ∧
    (∀ x, (cap trial n).mass (some x) =
      (∑ i ∈ range n, trial.mass none ^ i) * trial.mass (some x)) :=
  ⟨(cap trial n).total, cap_none trial n, cap_some trial n⟩

theorem cap16_exhaustion (trial : Law (Option α)) :
    (cap trial 16).mass none = (1 - (1 - trial.mass none)) ^ 16 := by
  simpa using cap_none trial 16

/- Exact observation map: PRE_ABORT has no nonce. POST_ABORT has a nonce.
There is no Verify call in this map and therefore no hidden correctness filter. -/
abbrev Observation (R α : Type*) := Option (R × Option α)

def emit (encode : α → Option β) : Option α → Option β
  | none => none
  | some x => encode x

noncomputable def observe [Fintype β] [DecidableEq β] [Fintype R] [DecidableEq R]
    (ready : Bool) (nonce : Law R) (body : R → Law (Option α))
    (encode : α → Option β) : Law (Observation R β) :=
  if ready then nonce.bind (fun r => (body r).map fun z => some (r, emit encode z))
  else Law.pure none

omit [DecidableEq α] in
theorem pre_abort_has_no_nonce [Fintype β] [DecidableEq β] [Fintype R] [DecidableEq R]
    (nonce : Law R) (body : R → Law (Option α)) (encode : α → Option β) :
    (observe false nonce body encode).mass none = 1 := by
  simp [observe, Law.pure]

omit [Fintype α] [DecidableEq α] in
theorem positive_reply_not_filtered (encode : α → Option β) (x : α) :
    emit encode (some x) = encode x := rfl

end FT1536.MathSign
