import Source3.FftOuterSetup144
import Source3.FftGroupsFrame143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftOuterFrame144
open C99ArrayReference (State Name restoreScope)
open C99MemoryReference (ArrayPointer)
open C99NatWord141 (word)
open FftOuterShape144 (names)

def assigned (tail : State) (t : Nat) := FftLocalCells140.put tail "t".toList (word (t/2))
def closed (s tail : State) (t : Nat) := restoreScope s (assigned tail t) names []
def next (s tail : State) (t m : Nat) := FftLocalCells140.put (closed s tail t) "m".toList (word (m*2))

structure Frame (base : ArrayPointer) (n : Nat) (before after : State) : Prop where
  locals : ∀ name, name≠"t".toList → name≠"m".toList → after.locals name=before.locals name
  arrays : after.arrays=before.arrays
  globals : after.globals=before.globals
  tables : after.tables=before.tables
  sizes : after.heap.size=before.heap.size
  writable : after.heap.writable=before.heap.writable
  bytes : ∀ block offset, FftLoopFrame141.Outside base n block offset → after.heap.bytes block offset=before.heap.bytes block offset

theorem body_local (s tail : State) (t m : Nat) (base : ArrayPointer) (n : Nat)
    (frame : FftGroupsFrame143.Frame base n (FftOuterStates144.initial s t m) tail)
    (name : Name) (notT : name≠"t".toList) : (closed s tail t).locals name=s.locals name := by
  change (if names.contains name then s.locals name else (assigned tail t).locals name)=s.locals name
  by_cases member : name∈names
  · have yes : names.contains name=true := List.contains_iff_mem.mpr member
    simp only [yes,ite_true]
  · have no : names.contains name=false := by
      cases found : names.contains name with
      | false => rfl
      | true => exact (member (List.contains_iff_mem.mp found)).elim
    simp only [no,Bool.false_eq_true,ite_false]
    have notU : name≠"u1".toList := by intro same; subst name; exact member (by decide)
    have notV : name≠"v1".toList := by intro same; subst name; exact member (by decide)
    exact (FftLocalCells140.outside tail _ name _ notT).trans
      ((frame.locals name notU notV).trans (FftOuterStates144.initial_outside s t m name member))

theorem body_t (s tail : State) (t : Nat) : C99LoopScalar141.Cell (closed s tail t) "t".toList (t/2) := by
  change (if names.contains "t".toList then s.locals "t".toList else (assigned tail t).locals "t".toList)=_
  have no : names.contains "t".toList=false := by decide
  simp only [no,Bool.false_eq_true,ite_false]
  exact FftLocalCells140.cell_at _ _ _

theorem complete (s tail : State) (t m : Nat) (base : ArrayPointer) (n : Nat)
    (frame : FftGroupsFrame143.Frame base n (FftOuterStates144.initial s t m) tail) : Frame base n s (next s tail t m) :=
  ⟨fun name nt nm => (FftLocalCells140.outside _ _ name _ nm).trans (body_local s tail t m base n frame name nt),
    frame.arrays,frame.globals,frame.tables,frame.sizes,frame.writable,frame.bytes⟩

theorem next_t (s tail : State) (t m : Nat) : C99LoopScalar141.Cell (next s tail t m) "t".toList (t/2) :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans (body_t s tail t)

theorem next_m (s tail : State) (t m : Nat) : C99LoopScalar141.Cell (next s tail t m) "m".toList (m*2) :=
  FftLocalCells140.cell_at _ _ _

theorem refl (base : ArrayPointer) (n : Nat) (s : State) : Frame base n s s :=
  ⟨fun _ _ _ => rfl,rfl,rfl,rfl,rfl,rfl,fun _ _ _ => rfl⟩

theorem trans (base : ArrayPointer) (n : Nat) (s t u : State)
    (first : Frame base n s t) (second : Frame base n t u) : Frame base n s u :=
  ⟨fun name h k => (second.locals name h k).trans (first.locals name h k),second.arrays.trans first.arrays,
    second.globals.trans first.globals,second.tables.trans first.tables,second.sizes.trans first.sizes,
    second.writable.trans first.writable,fun block offset h => (second.bytes block offset h).trans (first.bytes block offset h)⟩

end FT1536.Source3.FftOuterFrame144
