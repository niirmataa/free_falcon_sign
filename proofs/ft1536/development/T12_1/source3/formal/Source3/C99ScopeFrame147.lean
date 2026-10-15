import Source3.FftLocalCells140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ScopeFrame147
open C99ArrayReference (State Name restoreScope)

structure Frame (names : List Name) (before after : State) : Prop where
  locals : ∀ key, key∉names → after.locals key=before.locals key
  arrays : after.arrays=before.arrays
  globals : after.globals=before.globals
  tables : after.tables=before.tables

theorem refl (names : List Name) (s : State) : Frame names s s := ⟨fun _ _ => rfl,rfl,rfl,rfl⟩

theorem trans (names : List Name) (s t u : State) (first : Frame names s t) (second : Frame names t u) : Frame names s u :=
  ⟨fun key outside => (second.locals key outside).trans (first.locals key outside),
    second.arrays.trans first.arrays,second.globals.trans first.globals,second.tables.trans first.tables⟩

theorem weaken (narrow wide : List Name) (s t : State) (subset : ∀ key∈narrow, key∈wide) (frame : Frame narrow s t) : Frame wide s t :=
  ⟨fun key outside => frame.locals key (fun member => outside (subset key member)),frame.arrays,frame.globals,frame.tables⟩

theorem put (names : List Name) (s : State) (target : Name) (value : BitVec 64) (inside : target∈names) :
    Frame names s (FftLocalCells140.put s target value) := by
  refine ⟨?_,rfl,rfl,rfl⟩
  intro key outside
  have different : key≠target := by intro same; subst key; exact outside inside
  exact FftLocalCells140.outside s target key value different

theorem heap_only (names : List Name) (s : State) (heap : C99MemoryReference.Memory) : Frame names s {s with heap := heap} :=
  ⟨fun _ _ => rfl,rfl,rfl,rfl⟩

/-- A proved local frame identifies the entire scope-restored state. -/
theorem restored (names : List Name) (s after : State) (frame : Frame names s after) :
    restoreScope s after names []={s with heap := after.heap} := by
  have cells : C99ScalarReference.restore s.locals after.locals names=s.locals := by
    funext key
    change (if names.contains key then s.locals key else after.locals key)=s.locals key
    by_cases member : key∈names
    · have yes : names.contains key=true := List.contains_iff_mem.mpr member
      simp only [yes,ite_true]
    · have no : names.contains key=false := by
        cases found : names.contains key with
        | false => rfl
        | true => exact (member (List.contains_iff_mem.mp found)).elim
      simp only [no,Bool.false_eq_true,ite_false]
      exact frame.locals key member
  change ({heap := after.heap, locals := C99ScalarReference.restore s.locals after.locals names, arrays := after.arrays, globals := after.globals, tables := after.tables} : State) = {s with heap := after.heap}
  rw [cells,frame.arrays,frame.globals,frame.tables]

end FT1536.Source3.C99ScopeFrame147
