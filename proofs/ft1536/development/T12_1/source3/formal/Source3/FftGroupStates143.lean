import Source3.FftGroupDeclare143
import Source3.FftControlShape142

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupStates143
open C99ArrayReference (State Name)
open FftLocalCells140 (put)
open C99NatWord141 (word)
open C99LoopScalar141 (Cell)

def real (s : State) (x : BitVec 64 × BitVec 64) := put (FftGroupDeclare143.after s) "sr".toList x.1
def imag (s : State) (x : BitVec 64 × BitVec 64) := put (real s x) "si".toList x.2
def limit (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) := put (imag s x) "v2".toList (word (start+ht))
def initial (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) := put (limit s x start ht) "v".toList (word start)

theorem declared_cell (s : State) (name : Name) (value : Nat)
    (outside : name∉FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody)
    (old : Cell s name value) : Cell (FftGroupDeclare143.after s) name value := by
  apply FftGroupDeclare143.cell s name value _ _ old
  · intro member
    apply outside
    rw [FftControlShape142.group_names]
    exact List.mem_append_left FftGroupDeclare143.scalars member
  · intro member
    apply outside
    rw [FftControlShape142.group_names]
    exact List.mem_append_right FftGroupDeclare143.counters member

theorem imag_cell (s : State) (x : BitVec 64 × BitVec 64) (name : Name) (value : Nat)
    (outside : name∉FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody)
    (old : Cell s name value) : Cell (imag s x) name value := by
  have notSr : name≠"sr".toList := by intro same; subst name; exact outside (by decide +kernel)
  have notSi : name≠"si".toList := by intro same; subst name; exact outside (by decide +kernel)
  exact (FftLocalCells140.outside _ _ _ _ notSi).trans
    ((FftLocalCells140.outside _ _ _ _ notSr).trans (declared_cell s name value outside old))

theorem initial_cell (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) (name : Name) (value : Nat)
    (outside : name∉FftMiddleShape139.scopeLocals FftMiddleShape139.groupBody)
    (old : Cell s name value) : Cell (initial s x start ht) name value := by
  have notV : name≠"v".toList := by intro same; subst name; exact outside (by decide +kernel)
  have notV2 : name≠"v2".toList := by intro same; subst name; exact outside (by decide +kernel)
  exact (FftLocalCells140.outside _ _ _ _ notV).trans
    ((FftLocalCells140.outside _ _ _ _ notV2).trans (imag_cell s x name value outside old))

theorem real_cell (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) :
    (initial s x start ht).locals "sr".toList=some (.uint64,some (.uint64 x.1)) := by
  exact (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _)))

theorem imag_value (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) :
    (initial s x start ht).locals "si".toList=some (.uint64,some (.uint64 x.2)) :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _))

theorem stop_cell (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) :
    Cell (initial s x start ht) "v2".toList (start+ht) :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at _ _ _)

theorem counter_cell (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) :
    Cell (initial s x start ht) "v".toList start := FftLocalCells140.cell_at _ _ _

end FT1536.Source3.FftGroupStates143
