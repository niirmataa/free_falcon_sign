import Source3.FftTripleLoadState147
import Source3.FftGroupExec143

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleLoadExec147
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents element)
open C99LoopScalar141 (Cell)
open FftTripleLoadShape147 (name index slot)
open FftTripleLoadState147 (state)

def words (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64) : Fin 6 → BitVec 64 :=
  fun i => input (slot n hn u inside length i)

theorem next (s : State) (values : Fin 6 → BitVec 64) (i : Fin 6) :
    state s values (i.val+1)=FftLocalCells140.put (state s values i.val) (name i) (values i) := by
  rw [state,dite_eq_left i.isLt]

theorem step (s : State) (base : ArrayPointer) (n hn u : Nat)
    (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (uCell : Cell s "u".toList u) (hnCell : Cell s "hn".toList hn)
    (input : Fin n → BitVec 64) (represented : Represents s.heap base input) (i : Fin 6) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part (4+i.val))
      (state s (words n hn u inside length input) i.val)
      ⟨state s (words n hn u inside length input) (i.val+1),.normal⟩ := by
  rw [FftTripleLoadShape147.shape,next]
  let values := words n hn u inside length input
  have kept := FftTripleLoadState147.metadata s values i.val
  apply FftGroupExec143.load _ _ _ _ (element base (slot n hn u inside length i)) (values i)
    (FftTripleLoadState147.uninitialized s values i)
  · exact FftTripleLoadShape147.addresses (state s values i.val) base n hn u inside length wordBound capacity
      ((congrFun kept.2.1 "a".toList).trans binding)
      ((FftTripleLoadState147.scope_outside s values i.val "u".toList (by decide +kernel)).trans uCell)
      ((FftTripleLoadState147.scope_outside s values i.val "hn".toList (by decide +kernel)).trans hnCell) i
  · rw [kept.1]
    exact represented (slot n hn u inside length i)

def code := C99ProcedureParser.chain ((FftTripleShape145.statements.drop 4).take 6)
def prefixCode := C99ProcedureParser.chain (FftTripleShape145.statements.take 10)

theorem shape : code=C99ProcedureParser.chain [FftTripleShape145.part 4,FftTripleShape145.part 5,
    FftTripleShape145.part 6,FftTripleShape145.part 7,FftTripleShape145.part 8,FftTripleShape145.part 9] := by rfl

theorem source (s : State) (base : ArrayPointer) (n hn u : Nat)
    (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (uCell : Cell s "u".toList u) (hnCell : Cell s "hn".toList hn)
    (input : Fin n → BitVec 64) (represented : Represents s.heap base input) :
    C99ProcedureReference.Exec KeygenSearchFft.program code (FftTripleDeclare147.after s)
      ⟨state s (words n hn u inside length input) 6,.normal⟩ := by
  rw [shape]
  have one := step s base n hn u inside length wordBound capacity binding uCell hnCell input represented
  exact .seqNormal _ _ _ _ _ (one 0) (.seqNormal _ _ _ _ _ (one 1)
    (.seqNormal _ _ _ _ _ (one 2) (.seqNormal _ _ _ _ _ (one 3)
      (.seqNormal _ _ _ _ _ (one 4) (.seqNormal _ _ _ _ _ (one 5) (.base _ _ _ (.skip _)))))))

theorem prefix_shape : prefixCode=C99ProcedureParser.chain
    (FftTripleShape145.statements.take 4++(FftTripleShape145.statements.drop 4).take 6) := by rfl

theorem prefix_source (s : State) (base : ArrayPointer) (n hn u : Nat)
    (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64)
    (capacity : base.index+n≤base.count) (binding : s.arrays "a".toList=some base)
    (uCell : Cell s "u".toList u) (hnCell : Cell s "hn".toList hn)
    (input : Fin n → BitVec 64) (represented : Represents s.heap base input) :
    C99ProcedureReference.Exec KeygenSearchFft.program prefixCode s
      ⟨state s (words n hn u inside length input) 6,.normal⟩ := by
  rw [prefix_shape]
  exact C99Chain139.append _ _ _ s (FftTripleDeclare147.after s) _ (FftTripleDeclare147.source s)
    (source s base n hn u inside length wordBound capacity binding uCell hnCell input represented)

end FT1536.Source3.FftTripleLoadExec147
