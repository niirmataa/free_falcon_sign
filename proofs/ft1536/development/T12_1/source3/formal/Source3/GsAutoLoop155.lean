import Source3.GsAutoValues155
import Source3.GsInvNormInvariant154

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsAutoLoop155
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents element)
open C99LoopScalar141 (Cell)
open GsInvNormInvariant154 (low high)

structure Fixed (s : State) (a b : ArrayPointer) (n hn : Nat) (multiplier : Fin hn → BitVec 64) : Prop where
  length : 2*hn ≤ n
  wordBound : n<2^64
  capacityA : a.index+n ≤ a.count
  capacityB : b.index+hn ≤ b.count
  widthA : a.elementBytes=8
  bindingA : s.arrays "a".toList=some a
  bindingB : s.arrays "b".toList=some b
  hnCell : Cell s "hn".toList hn
  writableA : s.heap.writable a.block=true
  multiplierImage : Represents s.heap b multiplier
  separate : ∀ (i : Fin n) (j : Fin hn), C99WordRead140.Separate (element a i) (element b j)

def Invariant (a b : ArrayPointer) (n hn : Nat) (multiplier : Fin hn → BitVec 64)
    (s : State) (input : Fin n → BitVec 64) : Prop := Fixed s a b n hn multiplier ∧ Represents s.heap a input

def middle (s : State) (a : ArrayPointer) (n hn : Nat) (length : 2*hn ≤ n) (multiplier : Fin hn → BitVec 64)
    (input : Fin n → BitVec 64) (i : Fin hn) : State :=
  GsAutoBody155.output s (element a (low length i)) (element a (high length i))
    (input (low length i)) (input (high length i)) (multiplier i)

theorem body_source (s : State) (a b : ArrayPointer) (n hn : Nat) (multiplier : Fin hn → BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s a b n hn multiplier)
    (represented : Represents s.heap a input) (i : Fin hn) (counter : Cell s "u".toList i.val) :
    C99ProcedureReference.Exec KeygenSearchFft.program GsAutoShape155.body s
      ⟨middle s a n hn fixed.length multiplier input i,.normal⟩ := by
  have pa := GsInvNormInvariant154.addresses s a n hn i.val "a".toList fixed.length fixed.wordBound
    fixed.capacityA fixed.bindingA fixed.hnCell counter i.isLt
  have length:=fixed.length
  have bound:=fixed.wordBound
  have capacity:=fixed.capacityB
  have inside:=i.isLt
  have pb : Pointer s "b".toList FftFirstShape149.index0 (element b i) :=
    C99PointerNat141.source s _ _ b i.val (by omega) (by omega) fixed.bindingB
      (C99LoopScalar141.read s "u".toList i.val counter)
  have different : low fixed.length i≠high fixed.length i := by
    intro same
    have values := congrArg Fin.val same
    change i.val=i.val+hn at values
    omega
  exact GsAutoBody155.source KeygenSearchFft.program s _ _ _ _ _ _ pa.1 pa.2 pb
    (represented (low fixed.length i)) (represented (high fixed.length i)) (fixed.multiplierImage i)
    fixed.writableA fixed.writableA (C99WordBuffer140.separate a fixed.widthA _ _ different)
    (fixed.separate (low fixed.length i) i)

theorem next_fixed (s : State) (a b : ArrayPointer) (n hn : Nat) (multiplier : Fin hn → BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s a b n hn multiplier) (i : Fin hn) :
    Fixed (FftLocalCells140.put (middle s a n hn fixed.length multiplier input i) "u".toList (C99NatWord141.word (i.val+1)))
      a b n hn multiplier := by
  refine ⟨fixed.length,fixed.wordBound,fixed.capacityA,fixed.capacityB,fixed.widthA,fixed.bindingA,fixed.bindingB,
    ?_,fixed.writableA,?_,fixed.separate⟩
  · exact (FftLocalCells140.outside _ "u".toList "hn".toList _ (by decide)).trans fixed.hnCell
  · intro j
    exact C99WordRead140.outside _ (element a (high fixed.length i)) (element b j) _ (multiplier j)
      (fixed.separate (high fixed.length i) j)
      (C99WordRead140.outside s.heap (element a (low fixed.length i)) (element b j) _ (multiplier j)
        (fixed.separate (low fixed.length i) j) (fixed.multiplierImage j))

theorem rule (a b : ArrayPointer) (n hn : Nat) (length : 2*hn ≤ n) (bound : n<2^64) (multiplier : Fin hn → BitVec 64) :
    C99VectorLoop155.Rule KeygenSearchFft.program GsAutoShape155.body "hn".toList hn a n
      (GsAutoValues155.advance n hn length multiplier) (Invariant a b n hn multiplier) := by
  refine ⟨by omega,fun _ _ h => h.1.hnCell,?_⟩
  intro s u input inv counter inside
  obtain ⟨fixed,represented⟩ := inv
  let i : Fin hn := ⟨u,inside⟩
  let mid := middle s a n hn length multiplier input i
  let after := FftLocalCells140.put mid "u".toList (C99NatWord141.word (u+1))
  refine ⟨mid,after,body_source s a b n hn multiplier input fixed represented i counter,
    C99LoopScalar141.increment _ mid "u".toList u (by omega) counter,?_,FftLocalCells140.cell_at mid "u".toList _,?_⟩
  · refine ⟨next_fixed s a b n hn multiplier input fixed i,?_⟩
    change Represents mid.heap a (GsAutoValues155.advance n hn length multiplier u input)
    rw [GsAutoValues155.advance,dite_eq_left inside]
    exact C99TwoWordBuffer146.preserves s.heap a input represented fixed.widthA fixed.writableA
      (low length i) (high length i) _ _
  · exact FftFirstFrame149.trans a n s mid after
      (FftFirstFrame149.body a n s mid (FftFirstBuffer149.output_frame s a (low length i) (high length i)
        (FprMulFast137.word (input (low length i)) (multiplier i))
        (FprMulFast137.word (input (high length i)) (multiplier i)) fixed.widthA))
      (FftFirstFrame149.counter a n mid _)

theorem source (s : State) (a b : ArrayPointer) (n hn : Nat) (multiplier : Fin hn → BitVec 64)
    (input : Fin n → BitVec 64) (fixed : Fixed s a b n hn multiplier)
    (represented : Represents s.heap a input) (counter : Cell s "u".toList 0) :
    ∃ after, C99ProcedureReference.Exec KeygenSearchFft.program GsAutoShape155.loop s ⟨after,.normal⟩ ∧
      Fixed after a b n hn multiplier ∧
      Represents after.heap a (GsAutoValues155.image n hn fixed.length multiplier hn 0 input) ∧
      FftFirstFrame149.Frame a n s after := by
  obtain ⟨after,loop,inv,_counter,frame⟩ := C99VectorLoop155.source KeygenSearchFft.program GsAutoShape155.body
    "hn".toList hn a n (GsAutoValues155.advance n hn fixed.length multiplier) (Invariant a b n hn multiplier)
    (rule a b n hn fixed.length fixed.wordBound multiplier) 0 s input ⟨fixed,represented⟩ counter (by omega)
  rw [Nat.sub_zero,GsAutoValues155.pointwise] at inv
  exact ⟨after,loop,inv.1,inv.2,frame⟩

end FT1536.Source3.GsAutoLoop155
