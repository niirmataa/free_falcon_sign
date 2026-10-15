import Source3.FftTripleFinalCells147
import Source3.FftTripleStore146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleWriteContext147
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open FftTripleWords147 (Inputs storeWords)
open FftTripleAddShape146 (storeParameters)

structure Context (s : State) (base : ArrayPointer) (n hn u : Nat) : Prop where
  inside : u+2<hn
  length : 2*hn≤n
  wordBound : n<2^64
  width : base.elementBytes=8
  capacity : base.index+n≤base.count
  writable : s.heap.writable base.block=true
  binding : s.arrays "a".toList=some base
  uCell : Cell s "u".toList u
  hnCell : Cell s "hn".toList hn

structure Operands (s : State) (x : Inputs) : Prop where
  ar : ∀ i, s.locals (storeParameters i).inputs.ar=some (.uint64,some (.uint64 (storeWords x i).ar))
  ai : ∀ i, s.locals (storeParameters i).inputs.ai=some (.uint64,some (.uint64 (storeWords x i).ai))
  br : ∀ i, s.locals (storeParameters i).inputs.br=some (.uint64,some (.uint64 (storeWords x i).br))
  bi : ∀ i, s.locals (storeParameters i).inputs.bi=some (.uint64,some (.uint64 (storeWords x i).bi))

theorem context_transfer (s after : State) (base : ArrayPointer) (n hn u : Nat)
    (context : Context s base n hn u) (frame : FftGroupFrame143.Frame base n s after) : Context after base n hn u := by
  refine ⟨context.inside,context.length,context.wordBound,context.width,context.capacity,?_,?_,?_,?_⟩
  · rw [frame.writable]; exact context.writable
  · rw [frame.arrays]; exact context.binding
  · exact (congrFun frame.locals "u".toList).trans context.uCell
  · exact (congrFun frame.locals "hn".toList).trans context.hnCell

theorem operands_transfer (s after : State) (x : Inputs) (operands : Operands s x) (locals : after.locals=s.locals) : Operands after x := by
  refine ⟨?_,?_,?_,?_⟩
  · intro i; rw [locals]; exact operands.ar i
  · intro i; rw [locals]; exact operands.ai i
  · intro i; rw [locals]; exact operands.br i
  · intro i; rw [locals]; exact operands.bi i

theorem arithmetic_operands (s : State) (x : Inputs) (entry : FftTripleArithmetic147.Entry s x) :
    Operands (FftTripleArithmetic147.state10 s x) x :=
  ⟨FftTripleFinalCells147.ar s x entry,FftTripleFinalCells147.ai s x entry,
    FftTripleFinalCells147.br s x,FftTripleFinalCells147.bi s x⟩

theorem frame_trans (s t after : State) (base : ArrayPointer) (n : Nat)
    (first : FftGroupFrame143.Frame base n s t) (second : FftGroupFrame143.Frame base n t after) :
    FftGroupFrame143.Frame base n s after :=
  ⟨second.locals.trans first.locals,second.arrays.trans first.arrays,second.globals.trans first.globals,
    second.tables.trans first.tables,second.sizes.trans first.sizes,second.writable.trans first.writable,
    fun block offset outside => (second.bytes block offset outside).trans (first.bytes block offset outside)⟩

end FT1536.Source3.FftTripleWriteContext147
