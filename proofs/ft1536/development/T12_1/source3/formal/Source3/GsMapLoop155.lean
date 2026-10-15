import Source3.GsMapBody155
import Source3.WordMap155

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsMapLoop155
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Program Exec)
open C99WordBuffer140 (Represents element)
open C99LoopScalar141 (Cell)
open GsMapShape155 (Operation Extra value)

structure Fixed (op : Operation) (factor : BitVec 64) (s : State) (base : ArrayPointer) (n : Nat) : Prop where
  wordBound : n<2^64
  capacity : base.index+n ≤ base.count
  width : base.elementBytes=8
  binding : s.arrays "a".toList=some base
  nCell : Cell s "n".toList n
  writable : s.heap.writable base.block=true
  extra : Extra op factor s

def Invariant (op : Operation) (factor : BitVec 64) (base : ArrayPointer) (n : Nat)
    (s : State) (input : Fin n → BitVec 64) : Prop := Fixed op factor s base n ∧ Represents s.heap base input

theorem next_fixed (op : Operation) (factor : BitVec 64) (s : State) (base : ArrayPointer) (n u : Nat)
    (fixed : Fixed op factor s base n) (word : BitVec 64) (p : ArrayPointer) :
    Fixed op factor (FftLocalCells140.put (GsMapBody155.output s p word) "u".toList (C99NatWord141.word (u+1))) base n := by
  refine ⟨fixed.wordBound,fixed.capacity,fixed.width,fixed.binding,?_,fixed.writable,?_⟩
  · exact (FftLocalCells140.outside _ "u".toList "n".toList _ (by decide)).trans fixed.nCell
  · cases op with
    | adjoint => trivial
    | scale => exact (FftLocalCells140.outside _ "u".toList "x".toList _ (by decide)).trans fixed.extra

theorem rule (program : Program) (op : Operation) (factor : BitVec 64) (base : ArrayPointer) (n : Nat)
    (bound : n<2^64) : C99VectorLoop155.Rule program (GsMapShape155.body op) "n".toList n base n
      (WordMap155.step (value op factor)) (Invariant op factor base n) := by
  refine ⟨bound,fun _ _ h => h.1.nCell,?_⟩
  intro s u input inv uCell inside
  obtain ⟨fixed,represented⟩ := inv
  let slot : Fin n := ⟨u,inside⟩
  let word := value op factor (input slot)
  let middle := GsMapBody155.output s (element base slot) word
  let after := FftLocalCells140.put middle "u".toList (C99NatWord141.word (u+1))
  have address : C99ArrayReference.Pointer s "a".toList FftFirstShape149.index0 (element base slot) :=
    C99PointerNat141.source s _ _ base u (by omega) (by have h:=fixed.capacity; omega) fixed.binding
      (C99LoopScalar141.read s "u".toList u uCell)
  refine ⟨middle,after,GsMapBody155.source program op factor (input slot) s (element base slot) fixed.extra address (represented slot) fixed.writable,
    C99LoopScalar141.increment program middle "u".toList u (by omega) uCell,?_,FftLocalCells140.cell_at middle "u".toList _,?_⟩
  · refine ⟨next_fixed op factor s base n u fixed word (element base slot),?_⟩
    change Represents middle.heap base (WordMap155.step (value op factor) u input)
    rw [WordMap155.step,dite_eq_left inside]
    exact C99WordBuffer140.write_preserves s.heap base input represented fixed.width fixed.writable slot word
  · exact FftFirstFrame149.trans base n s middle after
      (FftFirstFrame149.body base n s middle (GsMapBody155.frame s base slot word fixed.width))
      (FftFirstFrame149.counter base n middle _)

def image {n : Nat} (op : Operation) (factor : BitVec 64) (start : Nat) (input : Fin n → BitVec 64) : Fin n → BitVec 64 :=
  fun i => if start ≤ i.val then value op factor (input i) else input i

theorem values {n : Nat} (op : Operation) (factor : BitVec 64) (start : Nat) (input : Fin n → BitVec 64) (range : start ≤ n) :
    DisjointVectorPass152.run (WordMap155.step (value op factor)) (n-start) start input=image op factor start input := by
  funext i
  rw [WordMap155.pointwise]
  have endIndex : start+(n-start)=n := by omega
  simp only [endIndex,i.isLt,and_true,image]

theorem source (program : Program) (op : Operation) (factor : BitVec 64) (base : ArrayPointer) (n start : Nat)
    (s : State) (input : Fin n → BitVec 64) (fixed : Fixed op factor s base n)
    (represented : Represents s.heap base input) (counter : Cell s "u".toList start) (range : start ≤ n) :
    ∃ after, Exec program (GsMapShape155.loop op) s ⟨after,.normal⟩ ∧
      Fixed op factor after base n ∧ Represents after.heap base (image op factor start input) ∧
      Cell after "u".toList n ∧ FftFirstFrame149.Frame base n s after := by
  obtain ⟨after,loop,inv,endU,frame⟩ := C99VectorLoop155.source program (GsMapShape155.body op) "n".toList n base n
    (WordMap155.step (value op factor)) (Invariant op factor base n) (rule program op factor base n fixed.wordBound)
    start s input ⟨fixed,represented⟩ counter range
  rw [values op factor start input range] at inv
  exact ⟨after,loop,inv.1,inv.2,endU,frame⟩

end FT1536.Source3.GsMapLoop155
