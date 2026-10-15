import Source3.FftGroupStates143
import Source3.FftLoopFrame141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupFrame143
open C99ArrayReference (State Name restoreScope)
open C99MemoryReference (ArrayPointer)
open FftGroupStates143 (real imag limit initial)
open FftMiddleShape139 (scopeLocals scopePointers groupBody)

structure Frame (base : ArrayPointer) (n : Nat) (before after : State) : Prop where
  locals : after.locals=before.locals
  arrays : after.arrays=before.arrays
  globals : after.globals=before.globals
  tables : after.tables=before.tables
  sizes : after.heap.size=before.heap.size
  writable : after.heap.writable=before.heap.writable
  bytes : ∀ block offset, FftLoopFrame141.Outside base n block offset → after.heap.bytes block offset=before.heap.bytes block offset

theorem initial_outside (s : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) (name : Name)
    (outside : name∉scopeLocals groupBody) : (initial s x start ht).locals name=s.locals name := by
  have notV : name≠"v".toList := by intro same; subst name; exact outside (by decide +kernel)
  have notV2 : name≠"v2".toList := by intro same; subst name; exact outside (by decide +kernel)
  have notSr : name≠"sr".toList := by intro same; subst name; exact outside (by decide +kernel)
  have notSi : name≠"si".toList := by intro same; subst name; exact outside (by decide +kernel)
  have notCounters : name∉FftGroupDeclare143.counters := by
    intro member
    rcases List.mem_cons.mp member with same | rest
    · exact notV same
    · rcases List.mem_cons.mp rest with same | empty
      · exact notV2 same
      · cases empty
  have notScalars : name∉FftGroupDeclare143.scalars := by
    intro member
    rcases List.mem_cons.mp member with same | rest
    · exact notSr same
    · rcases List.mem_cons.mp rest with same | empty
      · exact notSi same
      · cases empty
  exact (FftLocalCells140.outside _ _ _ _ notV).trans
    ((FftLocalCells140.outside _ _ _ _ notV2).trans
      ((FftLocalCells140.outside _ _ _ _ notSi).trans
        ((FftLocalCells140.outside _ _ _ _ notSr).trans (FftGroupDeclare143.outside s name notCounters notScalars))))

theorem restored (s tail : State) (x : BitVec 64 × BitVec 64) (start ht : Nat) (base : ArrayPointer) (n : Nat)
    (frame : FftLoopFrame141.Frame base n (initial s x start ht) tail) :
    Frame base n s (restoreScope s tail (scopeLocals groupBody) (scopePointers groupBody)) := by
  refine ⟨?_,?_,frame.globals,frame.tables,frame.sizes,frame.writable,frame.bytes⟩
  · funext name
    change (if (scopeLocals groupBody).contains name then s.locals name else tail.locals name)=s.locals name
    by_cases member : name∈scopeLocals groupBody
    · have contained : (scopeLocals groupBody).contains name=true := List.contains_iff_mem.mpr member
      simp only [contained,ite_true]
    · have absent : (scopeLocals groupBody).contains name=false := by
        cases found : (scopeLocals groupBody).contains name with
        | false => rfl
        | true => exact (member (List.contains_iff_mem.mp found)).elim
      simp only [absent,Bool.false_eq_true,ite_false]
      have notV : name≠"v".toList := by intro same; subst name; exact member (by decide +kernel)
      exact (frame.locals name notV).trans (initial_outside s x start ht name member)
  · change tail.arrays=s.arrays
    exact frame.arrays

end FT1536.Source3.FftGroupFrame143
