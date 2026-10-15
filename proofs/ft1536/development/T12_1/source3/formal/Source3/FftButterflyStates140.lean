import Source3.FftLoadExec140
import Source3.FftMulClosed140
import Source3.FftHeapTransport140
import Source3.FftFourWrites140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftButterflyStates140
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open FftMulStates140 (Words)

def mulWords (x : Words) (sr si : BitVec 64) : Words := ⟨x.br,x.bi,sr,si⟩
def pairWords (x : Words) (sr si : BitVec 64) : Words :=
  ⟨x.ar,x.ai,FftMulStates140.real (mulWords x sr si),FftMulStates140.imag (mulWords x sr si)⟩

def afterMul (before : State) (x : Words) (sr si : BitVec 64) : State :=
  FftMulStates140.output (FftLoadStates140.s4 before x) (mulWords x sr si)
def afterAdd (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) : State :=
  FftPairStates140.output .add (afterMul before x sr si) (pairWords x sr si) (p 0) (p 1)
def afterSub (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) : State :=
  FftPairStates140.output .sub (afterAdd before x p sr si) (pairWords x sr si) (p 2) (p 3)

def resultWords (x : Words) (sr si : BitVec 64) : Fin 4 → BitVec 64
  | ⟨0,_⟩ => FftPairStates140.real .add (pairWords x sr si)
  | ⟨1,_⟩ => FftPairStates140.imag .add (pairWords x sr si)
  | ⟨2,_⟩ => FftPairStates140.real .sub (pairWords x sr si)
  | ⟨3,_⟩ => FftPairStates140.imag .sub (pairWords x sr si)

def finalHeap (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) : C99MemoryReference.Memory :=
  C99WordStore140.write
    (C99WordStore140.write
      (C99WordStore140.write
        (C99WordStore140.write before.heap (p 0) (resultWords x sr si 0))
        (p 1) (resultWords x sr si 1))
      (p 2) (resultWords x sr si 2))
    (p 3) (resultWords x sr si 3)

def output (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) : State :=
  {before with heap := finalHeap before x p sr si}

theorem mul_entry (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) :
    FftMulStates140.Entry (FftLoadStates140.s4 before x) (mulWords x sr si) :=
  ⟨FftLoadExec140.loaded_cell before x 2,FftLoadExec140.loaded_cell before x 3,
    (FftLoadStates140.locals_outside before x 4 "sr".toList (by decide)).trans entry.sr,
    (FftLoadStates140.locals_outside before x 4 "si".toList (by decide)).trans entry.si⟩

theorem pair_entry (before : State) (x : Words) (sr si : BitVec 64) :
    FftPairStates140.Entry (afterMul before x sr si) (pairWords x sr si) := by
  refine ⟨?_,?_,?_,?_⟩
  · exact (FftMulClosed140.other_local (FftLoadStates140.s4 before x) (mulWords x sr si)
      "a0r".toList (by decide) (by decide)).trans (FftLoadExec140.loaded_cell before x 0)
  · exact (FftMulClosed140.other_local (FftLoadStates140.s4 before x) (mulWords x sr si)
      "a0i".toList (by decide) (by decide)).trans (FftLoadExec140.loaded_cell before x 1)
  · exact (FftLocalCells140.outside
      (FftLocalCells140.put (FftLoadStates140.s4 before x) "a1r".toList (FftMulStates140.real (mulWords x sr si)))
      "a1i".toList "a1r".toList (FftMulStates140.imag (mulWords x sr si)) (by decide)).trans
      (FftLocalCells140.cell_at (FftLoadStates140.s4 before x) "a1r".toList (FftMulStates140.real (mulWords x sr si)))
  · exact FftLocalCells140.cell_at
      (FftLocalCells140.put (FftLoadStates140.s4 before x) "a1r".toList (FftMulStates140.real (mulWords x sr si)))
      "a1i".toList (FftMulStates140.imag (mulWords x sr si))

theorem pair_entry_after_add (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    FftPairStates140.Entry (afterAdd before x p sr si) (pairWords x sr si) :=
  FftHeapTransport140.pair_entry (afterMul before x sr si)
    (FftPairStates140.finalHeap .add (afterMul before x sr si) (pairWords x sr si) (p 0) (p 1))
    (pairWords x sr si) (pair_entry before x sr si)

theorem index_same (before : State) (x : Words) (sr si : BitVec 64) (slot : Fin 4) (name : C99ArrayReference.Name)
    (member : name∈FftLoadShape140.readNames slot) : (afterMul before x sr si).locals name=before.locals name := by
  have outside := FftLoadShape140.index_outside slot name member
  exact (FftMulClosed140.other_local (FftLoadStates140.s4 before x) (mulWords x sr si) name
    (FftLoadStates140.name_different name outside 2) (FftLoadStates140.name_different name outside 3)).trans
    (FftLoadStates140.locals_outside before x 4 name outside)

theorem address_after_mul (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) (slot : Fin 4) :
    C99ArrayReference.Pointer (afterMul before x sr si) "a".toList (FftLoadShape140.index slot) (p slot) := by
  apply FftPointerTransport140.source before (afterMul before x sr si) _ _ (p slot) (entry.address slot) rfl
  intro name member
  rw [FftLoadShape140.read_names] at member
  exact (index_same before x sr si slot name member).symm

theorem address_after_add (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64)
    (entry : FftLoadExec140.Entry before x p sr si) (slot : Fin 4) :
    C99ArrayReference.Pointer (afterAdd before x p sr si) "a".toList (FftLoadShape140.index slot) (p slot) :=
  FftHeapTransport140.pointer (afterMul before x sr si)
    (FftPairStates140.finalHeap .add (afterMul before x sr si) (pairWords x sr si) (p 0) (p 1))
    "a".toList (FftLoadShape140.index slot) (p slot) (address_after_mul before x p sr si entry slot)

theorem final_shape (before : State) (x : Words) (p : Fin 4 → ArrayPointer) (sr si : BitVec 64) :
    afterSub before x p sr si={afterMul before x sr si with heap := finalHeap before x p sr si} := by
  unfold afterSub
  rw [FftFourWrites140.pair_output]
  unfold afterAdd
  rw [FftFourWrites140.pair_output]
  exact FftFourWrites140.compose (afterMul before x sr si) (p 0) (p 1) (p 2) (p 3)
    (FftPairStates140.real .add (pairWords x sr si)) (FftPairStates140.imag .add (pairWords x sr si))
    (FftPairStates140.real .sub (pairWords x sr si)) (FftPairStates140.imag .sub (pairWords x sr si))

end FT1536.Source3.FftButterflyStates140
