import FT1536.Basic

namespace FT1536.ROM
open Finset
variable {R X H : Type*} [Fintype R] [Nonempty R] [DecidableEq R] [DecidableEq X]

theorem uniform_event_card (E : R → Prop) [DecidablePred E] :
    (Law.uniform : Law R).event E = ((univ.filter E).card : ℝ) / Fintype.card R := by
  unfold Law.event Law.uniform
  rw [← sum_filter]
  simp

theorem fresh_nonce_conflict (frame : R → X) (hinj : Function.Injective frame)
    (table : Finset X) :
    (Law.uniform : Law R).event (fun r => frame r ∈ table) ≤
      (table.card : ℝ) / Fintype.card R := by
  rw [uniform_event_card]
  have hc : (univ.filter fun r => frame r ∈ table).card ≤ table.card := by
    apply card_le_card_of_injOn frame
    · intro r hr; exact (mem_filter.mp hr).2
    · intro r _ s _ hrs; exact hinj hrs
  exact div_le_div_of_nonneg_right (by exact_mod_cast hc) (by positivity)

omit [Fintype R] [Nonempty R] [DecidableEq R] [DecidableEq X] in
theorem adaptive_average [Fintype H] (p : Law H) (risk : H → ℝ) (bound : ℝ)
    (h : ∀ hist, risk hist ≤ bound) : ∑ hist, p.mass hist * risk hist ≤ bound := by
  calc
    _ ≤ ∑ hist, p.mass hist * bound :=
      sum_le_sum fun hist _ => mul_le_mul_of_nonneg_left (h hist) (p.nonneg hist)
    _ = _ := by rw [← sum_mul, p.total, one_mul]

omit [Fintype R] [Nonempty R] [DecidableEq R] [DecidableEq X] in
theorem event_union_bound {Ω : Type*} [Fintype Ω] (p : Law Ω) (n : ℕ)
    (E : ℕ → Ω → Prop) [∀ i, DecidablePred (E i)] :
    p.event (fun x => ∃ i ∈ range n, E i x) ≤ ∑ i ∈ range n, p.event (E i) := by
  classical
  unfold Law.event
  rw [sum_comm]
  apply sum_le_sum
  intro x _
  split_ifs with hx
  · obtain ⟨i, hi, he⟩ := hx
    calc
      _ = (if E i x then p.mass x else 0) := by simp [he]
      _ ≤ ∑ j ∈ range n, if E j x then p.mass x else 0 := by
        apply single_le_sum _ hi
        intro j _
        split_ifs <;> simp_all [p.nonneg]
  · exact sum_nonneg fun i _ => by split_ifs <;> simp_all [p.nonneg]

theorem programming_conflict_bound (frame : H → R → X)
    (hinj : ∀ hist, Function.Injective (frame hist))
    [Fintype H] (histLaw : Law H) (table : H → Finset X) (K : ℕ)
    (hsize : ∀ hist, (table hist).card ≤ K) :
    (∑ hist, histLaw.mass hist * (Law.uniform : Law R).event
      (fun r => frame hist r ∈ table hist)) ≤ (K : ℝ) / Fintype.card R := by
  apply adaptive_average
  intro hist
  exact (fresh_nonce_conflict (frame hist) (hinj hist) (table hist)).trans
    (div_le_div_of_nonneg_right (by exact_mod_cast hsize hist) (by positivity))

omit [Fintype R] [Nonempty R] [DecidableEq R] [DecidableEq X] in
theorem collision_sum (qs qh : ℕ) :
    (∑ i ∈ range qs, ((qh+i : ℕ) : ℝ)) =
      (qs : ℝ)*qh + (qs : ℝ)*((qs-1 : ℕ) : ℝ)/2 := by
  have hi : (∑ i ∈ range qs, (i : ℝ)) = (qs : ℝ)*((qs : ℝ)-1)/2 := by
    induction qs with
    | zero => simp
    | succ n ih => rw [sum_range_succ, ih]; push_cast; ring
  simp only [Nat.cast_add, sum_add_distrib, sum_const, card_range, nsmul_eq_mul, hi]
  cases qs with
  | zero => simp
  | succ n => simp only [Nat.add_sub_cancel, Nat.cast_add, Nat.cast_one]; ring

omit [Fintype R] [Nonempty R] [DecidableEq R] [DecidableEq X] in
theorem accumulated_conflicts {Ω : Type*} [Fintype Ω] (p : Law Ω)
    (qs qh : ℕ) (E : ℕ → Ω → Prop) [∀ i, DecidablePred (E i)]
    (h : ∀ i ∈ range qs, p.event (E i) ≤ ((qh+i : ℕ) : ℝ)/(2^320 : ℝ)) :
    p.event (fun x => ∃ i ∈ range qs, E i x) ≤
      min 1 (((qs : ℝ)*qh+(qs : ℝ)*((qs-1 : ℕ) : ℝ)/2)/(2^320 : ℝ)) := by
  classical
  apply le_min (p.event_le_one _)
  calc
    _ ≤ ∑ i ∈ range qs, p.event (E i) := event_union_bound p qs E
    _ ≤ ∑ i ∈ range qs, ((qh+i : ℕ) : ℝ)/(2^320 : ℝ) := sum_le_sum h
    _ = _ := by rw [← sum_div, collision_sum]

end FT1536.ROM
