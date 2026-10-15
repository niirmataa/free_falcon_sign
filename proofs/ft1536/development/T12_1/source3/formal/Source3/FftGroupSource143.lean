import Source3.FftGroupExec143
import Source3.FftGroupFrame143
import Source3.FftLoopInduction141
import Source3.FftReferenceCompose141

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftGroupSource143
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)
open FftMiddleShape139

def values (n hn ht : Nat) (length : 2*hn≤n) (m u start : Nat) (input : Fin n → BitVec 64) :=
  FftLoopInduction141.values n hn ht length (FftGroupTwiddle143.pair (m+u)).1 (FftGroupTwiddle143.pair (m+u)).2 ht start input

theorem fixed (s : State) (base : ArrayPointer) (n hn m u start ht : Nat)
    (entry : FftGroupExec143.Entry s m u start ht) (width : base.elementBytes=8)
    (capacity : base.index+n≤base.count) (length : 2*hn≤n) (range : start+ht+ht≤hn)
    (wordBound : n<2^64) (binding : s.arrays "a".toList=some base)
    (hnCell : Cell s "hn".toList hn) (writable : s.heap.writable base.block=true) :
    FftLoopInvariant141.Fixed (FftGroupStates143.initial s (FftGroupTwiddle143.pair (m+u)) start ht)
      base n hn ht (start+ht) (FftGroupTwiddle143.pair (m+u)).1 (FftGroupTwiddle143.pair (m+u)).2 :=
  ⟨width,capacity,length,range,wordBound,binding,
    FftGroupStates143.initial_cell s _ start ht _ hn (by decide +kernel) hnCell,
    FftGroupStates143.initial_cell s _ start ht _ ht (by decide +kernel) entry.htCell,
    FftGroupStates143.stop_cell s _ start ht,FftGroupStates143.real_cell s _ start ht,
    FftGroupStates143.imag_value s _ start ht,writable⟩

/-- The entire original group body for arbitrary legal controls and input words. -/
theorem source (s : State) (base : ArrayPointer) (n hn m u start ht : Nat)
    (input : Fin n → BitVec 64) (entry : FftGroupExec143.Entry s m u start ht)
    (width : base.elementBytes=8) (capacity : base.index+n≤base.count)
    (length : 2*hn≤n) (range : start+ht+ht≤hn) (wordBound : n<2^64)
    (binding : s.arrays "a".toList=some base) (hnCell : Cell s "hn".toList hn)
    (writable : s.heap.writable base.block=true) (represented : Represents s.heap base input) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program groupBody s ⟨after,.normal⟩ ∧
      Represents after.heap base (values n hn ht length m u start input) ∧ FftGroupFrame143.Frame base n s after := by
  have startFixed := fixed s base n hn m u start ht entry width capacity length range wordBound binding hnCell writable
  obtain ⟨tail,loop,_,_,image,frame⟩ := FftLoopInduction141.source
    (FftGroupStates143.initial s (FftGroupTwiddle143.pair (m+u)) start ht) base n hn ht (start+ht) start
    (FftGroupTwiddle143.pair (m+u)).1 (FftGroupTwiddle143.pair (m+u)).2 input startFixed
    (FftGroupStates143.counter_cell s _ start ht) represented (by omega)
  refine ⟨restoreScope s tail (scopeLocals groupBody) (scopePointers groupBody),?_,?_,?_⟩
  · exact FftReferenceCompose141.group _ _ _ _ (FftGroupExec143.prologue s m u start ht entry)
      (FftGroupExec143.initial_source s _ start ht entry.startCell) loop
  · change Represents tail.heap base (FftLoopInduction141.values n hn ht length
      (FftGroupTwiddle143.pair (m+u)).1 (FftGroupTwiddle143.pair (m+u)).2 ht start input)
    simpa only [Nat.add_sub_cancel_left] using image
  · exact FftGroupFrame143.restored s tail _ start ht base n frame

end FT1536.Source3.FftGroupSource143
