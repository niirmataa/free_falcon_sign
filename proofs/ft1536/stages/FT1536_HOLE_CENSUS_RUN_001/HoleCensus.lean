-- FT1536 hole census: prefix tables give contiguous support (generic kernel).
--
-- The full-size census (banks 0..4 x 512 entries) is done exactly in
-- census_holes.sage (prefix property, zero interior holes). This file proves
-- the LOGIC once, generally: a prefix table covers its whole window.
-- Tested by `lean HoleCensus.lean`; instant elaboration, no big literals.

def countNonzero : List Nat -> Nat
  | [] => 0
  | 0 :: xs => countNonzero xs
  | _ :: xs => 1 + countNonzero xs

-- Prefix: any nonzero entry forces all earlier entries nonzero.
-- Equivalently: no interior holes.
def isPrefix (l : List Nat) : Prop :=
  ∀ i, l.getD i 0 ≠ 0 → ∀ j, j < i → l.getD j 0 ≠ 0

def support (l : List Nat) (k : Nat) : Prop := l.getD k 0 ≠ 0

theorem prefix_nil : isPrefix [] := by
  intro i h
  simp at h

theorem prefix_cons (a : Nat) (as : List Nat) (h : isPrefix (a :: as)) :
    isPrefix as := by
  intro i hi j hji
  have hS : (a :: as).getD (i + 1) 0 ≠ 0 := by simpa using hi
  have hJ := h (i + 1) hS (j + 1) (by omega)
  simpa using hJ

-- Zero head + prefix forces every entry to zero.
theorem head_zero_all_zero (l : List Nat) (h : isPrefix (0 :: l)) (k : Nat) :
    (0 :: l).getD k 0 = 0 := by
  induction l generalizing k with
  | nil => cases k <;> rfl
  | cons b bs ih =>
    have hb : b = 0 := by
      cases Decidable.em (b = 0) with
      | inl h => exact h
      | inr hne =>
        have h1 : (0 :: b :: bs).getD 1 0 ≠ 0 := by simpa using hne
        have h0 := h 1 h1 0 (by omega)
        simp at h0
    subst hb
    cases k with
    | zero => rfl
    | succ k =>
      have hsub : isPrefix (0 :: bs) := by
        intro i hi j hji
        have hS : (0 :: 0 :: bs).getD (i + 1) 0 ≠ 0 := by
          cases i with
          | zero => simp at hi
          | succ i => simpa using hi
        have hJ := h (i + 1) hS (j + 1) (by omega)
        cases j with
        | zero => simp at hJ
        | succ j => simpa using hJ
      exact ih hsub k

theorem count_eq_zero_of_all_zero (l : List Nat)
    (hall : ∀ k, l.getD k 0 = 0) : countNonzero l = 0 := by
  induction l with
  | nil => rfl
  | cons b bs ih =>
    have hb : b = 0 := by
      have h0 := hall 0
      simpa using h0
    subst hb
    exact ih (fun k => by simpa using hall (k + 1))

theorem count_zero_of_head_zero_prefix (l : List Nat)
    (h : isPrefix (0 :: l)) : countNonzero (0 :: l) = 0 :=
  count_eq_zero_of_all_zero _ (head_zero_all_zero l h)

theorem count_cons_nonzero (a : Nat) (as : List Nat) (ha : a ≠ 0) :
    countNonzero (a :: as) = 1 + countNonzero as := by
  cases a with
  | zero => simp at ha
  | succ n => rfl

-- Main: a prefix table has no holes inside its nonzero window.
theorem prefix_covers_window (l : List Nat) (h : isPrefix l) (k : Nat)
    (hk : k < countNonzero l) : support l k := by
  induction l generalizing k with
  | nil => simp [countNonzero] at hk
  | cons a as ih =>
    by_cases ha : a = 0
    · subst ha
      have hc := count_zero_of_head_zero_prefix as h
      omega
    · cases k with
      | zero =>
        show a ≠ 0
        exact ha
      | succ k =>
        have hcount := count_cons_nonzero a as ha
        have hs := ih (prefix_cons a as h) k (by omega)
        simpa [support] using hs

-- Tiny examples: the same shape the Sage census checks at full size.
example : support [3, 1, 2] 2 := by unfold support; decide
example : countNonzero [5, 0, 7] = 2 := by decide

#check @prefix_covers_window
#print axioms prefix_covers_window
