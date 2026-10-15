import Source3.FftTripleLocal147
import Source3.FftTripleWrites147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleBody147
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open C99LoopScalar141 (Cell)

structure Constants where
  w2r : BitVec 64
  w2i : BitVec 64
  w4r : BitVec 64
  w4i : BitVec 64

structure Context (s : State) (base : ArrayPointer) (n hn u q : Nat) (c : Constants) : Prop where
  write : FftTripleWriteContext147.Context s base n hn u
  tableBound : q<2048
  vCell : Cell s "v".toList (2*q)
  tableBinding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic)
  pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap
  w2rCell : s.locals "fpr_W2R".toList=some (.uint64,some (.uint64 c.w2r))
  w2iCell : s.locals "fpr_W2I".toList=some (.uint64,some (.uint64 c.w2i))
  w4rCell : s.locals "fpr_W4R".toList=some (.uint64,some (.uint64 c.w4r))
  w4iCell : s.locals "fpr_W4I".toList=some (.uint64,some (.uint64 c.w4i))

def rawAfter (s : State) (base : ArrayPointer) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n)
    (input : Fin n → BitVec 64) (c : Constants) :=
  FftTripleWrites147.after (FftTripleLocal147.after s n hn u q inside length input c.w2r c.w2i c.w4r c.w4i)
    base n hn u inside length (FftTripleLocal147.data n hn u q inside length input c.w2r c.w2i c.w4r c.w4i)

def output (s : State) (base : ArrayPointer) (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n)
    (input : Fin n → BitVec 64) (c : Constants) : State :=
  {s with heap := (rawAfter s base n hn u q inside length input c).heap}

def values (n hn u q : Nat) (inside : u+2<hn) (length : 2*hn≤n) (input : Fin n → BitVec 64) (c : Constants) :=
  FftTripleWrites147.values n hn u inside length
    (FftTripleLocal147.data n hn u q inside length input c.w2r c.w2i c.w4r c.w4i) input

theorem shape : FftTripleShape145.loopBody=.scope FftTripleDeclare147.names []
    (C99ProcedureParser.chain (FftTripleShape145.statements.take 22++(FftTripleShape145.statements.drop 22).take 3)) := by rfl

/-- One complete original tripling body, including all loads/macros/stores and scope. -/
theorem source_and_image (s : State) (base : ArrayPointer) (n hn u q : Nat)
    (input : Fin n → BitVec 64) (c : Constants) (context : Context s base n hn u q c)
    (represented : Represents s.heap base input) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.loopBody s
      ⟨output s base n hn u q context.write.inside context.write.length input c,.normal⟩ ∧
      Represents (output s base n hn u q context.write.inside context.write.length input c).heap base
        (values n hn u q context.write.inside context.write.length input c) ∧
      FftGroupFrame143.Frame base n s (output s base n hn u q context.write.inside context.write.length input c) := by
  let wc := context.write
  let d := FftTripleLocal147.data n hn u q wc.inside wc.length input c.w2r c.w2i c.w4r c.w4i
  let middle := FftTripleLocal147.after s n hn u q wc.inside wc.length input c.w2r c.w2i c.w4r c.w4i
  have head := FftTripleLocal147.source s base n hn u q wc.inside wc.length wc.wordBound context.tableBound
    wc.capacity wc.binding wc.uCell wc.hnCell context.vCell context.tableBinding context.pinned input represented
    c.w2r c.w2i c.w4r c.w4i context.w2rCell context.w2iCell context.w4rCell context.w4iCell
  have localFrame := FftTripleLocal147.frame s n hn u q wc.inside wc.length input c.w2r c.w2i c.w4r c.w4i
  have heapSame := FftTripleLocal147.heap s n hn u q wc.inside wc.length input c.w2r c.w2i c.w4r c.w4i
  have writeContext : FftTripleWriteContext147.Context middle base n hn u := by
    refine ⟨wc.inside,wc.length,wc.wordBound,wc.width,wc.capacity,?_,?_,?_,?_⟩
    · rw [heapSame]
      exact wc.writable
    · rw [localFrame.arrays]
      exact wc.binding
    · exact (localFrame.locals "u".toList (by decide +kernel)).trans wc.uCell
    · exact (localFrame.locals "hn".toList (by decide +kernel)).trans wc.hnCell
  have operands : FftTripleWriteContext147.Operands middle d :=
    FftTripleWriteContext147.arithmetic_operands _ _
      (FftTripleLocal147.entry s n hn u q wc.inside wc.length input c.w2r c.w2i c.w4r c.w4i
        context.w2rCell context.w2iCell context.w4rCell context.w4iCell)
  have middleImage : Represents middle.heap base input := by rw [heapSame]; exact represented
  obtain ⟨tail,finalImage,writeFrame⟩ := FftTripleWrites147.source_and_image middle base n hn u d writeContext operands input middleImage
  let final := rawAfter s base n hn u q wc.inside wc.length input c
  have finalFrame : C99ScopeFrame147.Frame FftTripleDeclare147.names s final :=
    C99ScopeFrame147.trans _ s middle final localFrame
      ⟨fun key _ => congrFun writeFrame.locals key,writeFrame.arrays,writeFrame.globals,writeFrame.tables⟩
  have scope := C99ScopeFrame147.restored FftTripleDeclare147.names s final finalFrame
  refine ⟨?_,finalImage,?_⟩
  · change C99ProcedureReference.Exec KeygenSearchFft.program FftTripleShape145.loopBody s ⟨{s with heap := final.heap},.normal⟩
    rw [← scope,shape]
    exact .scope _ _ _ s ⟨final,.normal⟩ (C99Chain139.append _ _ _ s middle ⟨final,.normal⟩ head tail)
  · refine ⟨rfl,rfl,rfl,rfl,?_,?_,?_⟩
    · exact writeFrame.sizes.trans (congrArg (fun heap : C99MemoryReference.Memory => heap.size) heapSame)
    · exact writeFrame.writable.trans (congrArg (fun heap : C99MemoryReference.Memory => heap.writable) heapSame)
    · intro block offset outside
      exact (writeFrame.bytes block offset outside).trans
        (congrArg (fun heap : C99MemoryReference.Memory => heap.bytes block offset) heapSame)

end FT1536.Source3.FftTripleBody147
