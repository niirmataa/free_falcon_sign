import Source3.FftTripleLoadShape147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleLoadState147
open C99ArrayReference (State Name)
open FftTripleLoadShape147 (name)

/-- Only the six source-assigned input cells are updated after declarations. -/
def state (s : State) (words : Fin 6 → BitVec 64) : Nat → State
  | 0 => FftTripleDeclare147.after s
  | k+1 => if bound : k<6 then FftLocalCells140.put (state s words k) (name ⟨k,bound⟩) (words ⟨k,bound⟩) else state s words k

theorem metadata (s : State) (words : Fin 6 → BitVec 64) (k : Nat) :
    (state s words k).heap=s.heap ∧ (state s words k).arrays=s.arrays ∧
    (state s words k).globals=s.globals ∧ (state s words k).tables=s.tables := by
  induction k with
  | zero => exact ⟨rfl,rfl,rfl,rfl⟩
  | succ k ih =>
    rw [state]
    split <;> exact ih

theorem outside (s : State) (words : Fin 6 → BitVec 64) (k : Nat) (key : Name)
    (absent : key∉FftTripleDeclare147.inputNames) :
    (state s words k).locals key=(FftTripleDeclare147.after s).locals key := by
  induction k with
  | zero => rfl
  | succ k ih =>
    rw [state]
    split
    next bound =>
      have different : key≠name ⟨k,bound⟩ := by
        intro same
        exact absent (same ▸ FftTripleLoadShape147.member ⟨k,bound⟩)
      exact (FftLocalCells140.outside _ _ key _ different).trans ih
    next => exact ih

theorem scope_outside (s : State) (words : Fin 6 → BitVec 64) (k : Nat) (key : Name)
    (absent : key∉FftTripleDeclare147.names) : (state s words k).locals key=s.locals key :=
  (outside s words k key (fun member => absent (List.mem_append_left _ member))).trans
    (FftTripleDeclare147.outside s key absent)

theorem declared (s : State) (words : Fin 6 → BitVec 64) (k : Nat) :
    C99Declared147.Declared (state s words k) FftTripleDeclare147.names := by
  induction k with
  | zero => exact FftTripleDeclare147.declared s
  | succ k ih =>
    rw [state]
    split
    next => exact C99Declared147.put _ _ _ _ ih
    next => exact ih

theorem unwritten (s : State) (words : Fin 6 → BitVec 64) (k : Nat) (i : Fin 6) (range : k ≤ i.val) :
    (state s words k).locals (name i)=(FftTripleDeclare147.after s).locals (name i) := by
  induction k with
  | zero => rfl
  | succ k ih =>
    have bound : k<6 := by have h:=i.isLt; omega
    rw [state,dite_eq_left bound]
    have different : name i≠name ⟨k,bound⟩ := by
      intro same
      have equal : i.val=k := congrArg Fin.val (FftTripleLoadShape147.injective same)
      omega
    exact (FftLocalCells140.outside _ _ _ _ different).trans (ih (by omega))

theorem uninitialized (s : State) (words : Fin 6 → BitVec 64) (i : Fin 6) :
    (state s words i.val).locals (name i)=some (.uint64,none) :=
  (unwritten s words i.val i (Nat.le_refl _)).trans (FftTripleDeclare147.uninitialized s (name i) (FftTripleLoadShape147.scope_member i))

theorem written (s : State) (words : Fin 6 → BitVec 64) (k : Nat) (i : Fin 6) (range : i.val < k) (cap : k ≤ 6) :
    (state s words k).locals (name i)=some (.uint64,some (.uint64 (words i))) := by
  induction k with
  | zero => omega
  | succ k ih =>
    have bound : k<6 := by omega
    rw [state,dite_eq_left bound]
    by_cases same : i.val=k
    · have equal : i=⟨k,bound⟩ := Fin.ext same
      rw [equal]
      exact FftLocalCells140.cell_at _ _ _
    · have different : name i≠name ⟨k,bound⟩ := by
        intro equal
        exact same (congrArg Fin.val (FftTripleLoadShape147.injective equal))
      exact (FftLocalCells140.outside _ _ _ _ different).trans (ih (by omega) (by omega))

end FT1536.Source3.FftTripleLoadState147
