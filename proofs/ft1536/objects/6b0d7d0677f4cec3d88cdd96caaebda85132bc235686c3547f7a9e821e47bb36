import FT1536.Basic

namespace FT1536.ROM
variable {R M C : Type} [DecidableEq R] [DecidableEq M]
abbrev Name (R M : Type) := R × M

structure Entry (R M C : Type) where
  name : Name R M
  value : C
  target : Option ℕ

structure State (R M C : Type) where
  table : List (Entry R M C)
  seen : List M
  used : ℕ

def empty : State R M C := ⟨[], [], 0⟩

def lookup (x : Name R M) (s : State R M C) : Option (Entry R M C) :=
  s.table.find? fun e => e.name == x

def Unique (s : State R M C) : Prop := (s.table.map Entry.name).Nodup

theorem lookup_miss (x : Name R M) (s : State R M C) (h : lookup x s = none) :
    x ∉ s.table.map Entry.name := by
  simp only [lookup, List.find?_eq_none, beq_iff_eq] at h
  intro hx
  obtain ⟨e, he, hn⟩ := List.mem_map.mp hx
  exact h e he hn

def Good (targets : ℕ → C) (s : State R M C) : Prop :=
  ∀ e ∈ s.table, match e.target with
    | none => e.name.2 ∈ s.seen
    | some j => j < s.used ∧ e.value = targets j

def hash (targets : ℕ → C) (x : Name R M) (s : State R M C) : C × State R M C :=
  match lookup x s with
  | some e => (e.value, s)
  | none => (targets s.used,
      ⟨⟨x, targets s.used, some s.used⟩ :: s.table, s.seen, s.used+1⟩)

/- Seen is updated before deciding the prefix branch or sampling a nonce. -/
def submit (m : M) (s : State R M C) : State R M C := {s with seen := m :: s.seen}

/- None means stopped game/no win; it is not a returned signature abort. -/
def program (x : Name R M) (c : C) (s : State R M C) : Option (State R M C) :=
  match lookup x s with
  | some _ => none
  | none => some ⟨⟨x,c,none⟩ :: s.table, s.seen, s.used⟩

omit [DecidableEq R] [DecidableEq M] in
theorem empty_good (targets : ℕ → C) : Good targets (empty : State R M C) := by
  intro e he
  simp [empty] at he

theorem hash_good (targets : ℕ → C) (x : Name R M) (s : State R M C)
    (h : Good targets s) : Good targets (hash targets x s).2 := by
  unfold hash
  split
  · exact h
  · intro e he
    simp only [List.mem_cons] at he
    rcases he with rfl | he
    · exact ⟨Nat.lt_succ_self _, rfl⟩
    · have hh := h e he
      cases ht : e.target with
      | none => simpa [ht] using hh
      | some j =>
        simp only [ht] at hh ⊢
        exact ⟨Nat.lt_succ_of_lt hh.1, hh.2⟩

theorem hash_used_le (targets : ℕ → C) (x : Name R M) (s : State R M C) :
    (hash targets x s).2.used ≤ s.used+1 := by
  unfold hash
  split
  · exact Nat.le_succ _
  · rfl

theorem hash_unique (targets : ℕ → C) (x : Name R M) (s : State R M C)
    (h : Unique s) : Unique (hash targets x s).2 := by
  unfold hash
  split
  · exact h
  next hm => exact List.nodup_cons.mpr ⟨lookup_miss x s hm, h⟩

omit [DecidableEq R] [DecidableEq M] in
theorem submit_good (targets : ℕ → C) (m : M) (s : State R M C)
    (h : Good targets s) : Good targets (submit m s) := by
  intro e he
  have hh := h e he
  cases ht : e.target with
  | none => exact List.mem_cons_of_mem m (by simpa [ht] using hh)
  | some j => simpa [ht, submit] using hh

omit [DecidableEq R] [DecidableEq M] in
theorem submitted_even_on_abort (m : M) (s : State R M C) : m ∈ (submit m s).seen := by
  simp [submit]

theorem program_good (targets : ℕ → C) (x : Name R M) (c : C) (s s' : State R M C)
    (h : Good targets s) (hm : x.2 ∈ s.seen) (hp : program x c s = some s') :
    Good targets s' ∧ s'.used = s.used := by
  unfold program at hp
  split at hp
  · contradiction
  · cases hp
    constructor
    · intro e he
      rcases List.mem_cons.mp he with rfl | he
      · exact hm
      · exact h e he
    · rfl

theorem program_unique (x : Name R M) (c : C) (s s' : State R M C)
    (h : Unique s) (hp : program x c s = some s') : Unique s' := by
  unfold program at hp
  split at hp
  · contradiction
  next hm =>
    cases hp
    exact List.nodup_cons.mpr ⟨lookup_miss x s hm, h⟩

theorem lookup_mem (x : Name R M) (s : State R M C) (e : Entry R M C)
    (h : lookup x s = some e) : e ∈ s.table ∧ e.name = x := by
  have hh := List.find?_some h
  exact ⟨List.mem_of_find?_eq_some h, by simpa using hh⟩

/- The same entry supplies both value and index. Duplicate target values and
zero targets are unrestricted. Fresh messages cannot have a Sign-origin entry. -/
theorem indexed_entry (targets : ℕ → C) (s : State R M C) (x : Name R M)
    (e : Entry R M C) (hg : Good targets s) (hf : x.2 ∉ s.seen)
    (hl : lookup x s = some e) : ∃ j, e.target = some j ∧ j < s.used ∧ e.value = targets j := by
  obtain ⟨hm, hn⟩ := lookup_mem x s e hl
  have he := hg e hm
  cases ht : e.target with
  | none => exact False.elim (hf (by simpa [ht, hn] using he))
  | some j => exact ⟨j, rfl, by simpa [ht] using he⟩

theorem final_hash_index (targets : ℕ → C) (s : State R M C) (x : Name R M)
    (hg : Good targets s) (hf : x.2 ∉ s.seen) :
    ∃ j, j < (hash targets x s).2.used ∧ (hash targets x s).1 = targets j := by
  unfold hash
  split
  next e he =>
    obtain ⟨j, _, hj, hv⟩ := indexed_entry targets s x e hg hf he
    exact ⟨j, hj, hv⟩
  next => exact ⟨s.used, Nat.lt_succ_self _, rfl⟩

theorem target_count_le_QH_add_one (targets : ℕ → C) (s : State R M C)
    (x : Name R M) (QH : ℕ) (h : s.used ≤ QH) :
    (hash targets x s).2.used ≤ QH+1 := (hash_used_le targets x s).trans (Nat.add_le_add_right h 1)

theorem hash_cached (targets : ℕ → C) (s : State R M C) (x : Name R M)
    (e : Entry R M C) (h : lookup x s = some e) : hash targets x s = (e.value,s) := by
  simp [hash,h]

theorem hash_nonanticipating (t u : ℕ → C) (s : State R M C) (x : Name R M)
    (h : t s.used = u s.used) : hash t x s = hash u x s := by
  unfold hash
  split <;> simp_all

theorem fixed_length_framing {Byte : Type} (r r' m m' : List Byte)
    (hLen : r.length = r'.length) (h : r ++ m = r' ++ m') : r = r' ∧ m = m' :=
  List.append_inj h hLen

/- A pure execution trace is a sequence of public operations; adaptivity is
unrestricted because each next operation can be any function of prior replies.
The semantic/probabilistic adversary interpreter is a separate obligation. -/
inductive Reachable (targets : ℕ → C) : ℕ → State R M C → Prop
  | init : Reachable targets 0 empty
  | hashStep {n s} (x : Name R M) : Reachable targets n s →
      Reachable targets (n+1) (hash targets x s).2
  | submitStep {n s} (m : M) : Reachable targets n s →
      Reachable targets n (submit m s)
  | programStep {n s s'} (x : Name R M) (c : C) : Reachable targets n s →
      x.2 ∈ s.seen → program x c s = some s' → Reachable targets n s'

theorem reachable_invariants (targets : ℕ → C) {n : ℕ} {s : State R M C}
    (h : Reachable targets n s) : Good targets s ∧ s.used ≤ n := by
  induction h with
  | init => exact ⟨empty_good targets, Nat.le_refl 0⟩
  | hashStep x _ ih =>
    exact ⟨hash_good _ _ _ ih.1, (hash_used_le _ _ _).trans (Nat.add_le_add_right ih.2 1)⟩
  | submitStep m _ ih => exact ⟨submit_good _ _ _ ih.1, ih.2⟩
  | programStep x c _ hm hp ih =>
    obtain ⟨hg, he⟩ := program_good _ _ _ _ _ ih.1 hm hp
    exact ⟨hg, he ▸ ih.2⟩

theorem reachable_unique (targets : ℕ → C) {n : ℕ} {s : State R M C}
    (h : Reachable targets n s) : Unique s := by
  induction h with
  | init => exact List.nodup_nil
  | hashStep x _ ih => exact hash_unique _ _ _ ih
  | submitStep m _ ih => exact ih
  | programStep x c _ _ hp ih => exact program_unique _ _ _ _ ih hp

end FT1536.ROM
