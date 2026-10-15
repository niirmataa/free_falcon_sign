import Source3.FftTripleWriteContext147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleWrites147
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents)
open FftTripleWords147 (Inputs storeWords)
open FftTripleWriteContext147 (Context Operands)

def first (s : State) (base : ArrayPointer) (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (x : Inputs) :=
  FftTripleStore146.output s base n hn u inside length 0 (storeWords x 0)
def second (s : State) (base : ArrayPointer) (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (x : Inputs) :=
  FftTripleStore146.output (first s base n hn u inside length x) base n hn u inside length 1 (storeWords x 1)
def after (s : State) (base : ArrayPointer) (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (x : Inputs) :=
  FftTripleStore146.output (second s base n hn u inside length x) base n hn u inside length 2 (storeWords x 2)

def values (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (x : Inputs) (input : Fin n → BitVec 64) :=
  FftTripleStore146.values n hn u inside length 2 (storeWords x 2)
    (FftTripleStore146.values n hn u inside length 1 (storeWords x 1)
      (FftTripleStore146.values n hn u inside length 0 (storeWords x 0) input))

def code := C99ProcedureParser.chain ((FftTripleShape145.statements.drop 22).take 3)
theorem shape : code=C99ProcedureParser.chain [FftTripleShape145.part 22,FftTripleShape145.part 23,FftTripleShape145.part 24] := by rfl

theorem source_and_image (s : State) (base : ArrayPointer) (n hn u : Nat) (x : Inputs)
    (context : Context s base n hn u) (operands : Operands s x) (input : Fin n → BitVec 64)
    (represented : Represents s.heap base input) :
    C99ProcedureReference.Exec KeygenSearchFft.program code s ⟨after s base n hn u context.inside context.length x,.normal⟩ ∧
      Represents (after s base n hn u context.inside context.length x).heap base
        (values n hn u context.inside context.length x input) ∧
      FftGroupFrame143.Frame base n s (after s base n hn u context.inside context.length x) := by
  obtain ⟨source0,image0,frame0⟩ := FftTripleStore146.source_and_image s base n hn u context.inside context.length context.wordBound
    0 (storeWords x 0) input represented context.width context.capacity context.writable context.binding context.uCell context.hnCell
    (operands.ar 0) (operands.ai 0) (operands.br 0) (operands.bi 0)
  have context1 := FftTripleWriteContext147.context_transfer s _ base n hn u context frame0
  have operands1 := FftTripleWriteContext147.operands_transfer s _ x operands frame0.locals
  obtain ⟨source1,image1,frame1⟩ := FftTripleStore146.source_and_image (first s base n hn u context.inside context.length x)
    base n hn u context.inside context.length context.wordBound 1 (storeWords x 1) _ image0 context.width context.capacity
    context1.writable context1.binding context1.uCell context1.hnCell (operands1.ar 1) (operands1.ai 1) (operands1.br 1) (operands1.bi 1)
  have context2 := FftTripleWriteContext147.context_transfer _ _ base n hn u context1 frame1
  have operands2 := FftTripleWriteContext147.operands_transfer _ _ x operands1 frame1.locals
  obtain ⟨source2,image2,frame2⟩ := FftTripleStore146.source_and_image (second s base n hn u context.inside context.length x)
    base n hn u context.inside context.length context.wordBound 2 (storeWords x 2) _ image1 context.width context.capacity
    context2.writable context2.binding context2.uCell context2.hnCell (operands2.ar 2) (operands2.ai 2) (operands2.br 2) (operands2.bi 2)
  refine ⟨?_,image2,?_⟩
  · rw [shape]
    exact .seqNormal _ _ s (first s base n hn u context.inside context.length x) _ source0
      (.seqNormal _ _ _ (second s base n hn u context.inside context.length x) _ source1
        (.seqNormal _ _ _ (after s base n hn u context.inside context.length x) _ source2 (.base _ _ _ (.skip _))))
  · exact FftTripleWriteContext147.frame_trans s _ _ base n frame0 (FftTripleWriteContext147.frame_trans _ _ _ base n frame1 frame2)

end FT1536.Source3.FftTripleWrites147
