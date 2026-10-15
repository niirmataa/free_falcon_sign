import Source3.FftTripleIndices146
import Source3.FpcPairBuffer146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleStore146
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99WordBuffer140 (Represents element)
open C99LoopScalar141 (Cell)
open FftTripleIndices146 (realSlot imagSlot)
open FftTripleAddShape146 (storeParameters)
open FftMulStates140 (Words)

def output (s : State) (base : ArrayPointer) (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n)
    (i : Fin 3) (x : Words) :=
  FpcAddStore146.output s x (element base (realSlot n hn u inside length i)) (element base (imagSlot n hn u inside length i))

def values (n hn u : Nat) (inside : u+2<hn) (length : 2*hn≤n) (i : Fin 3) (x : Words)
    (input : Fin n → BitVec 64) :=
  C99TwoWordBuffer146.values input (realSlot n hn u inside length i) (imagSlot n hn u inside length i)
    (FftPairStates140.real .add x) (FftPairStates140.imag .add x)

/-- Source addresses and allocation are derived from counters and a represented buffer. -/
theorem source_and_image (s : State) (base : ArrayPointer) (n hn u : Nat)
    (inside : u+2<hn) (length : 2*hn≤n) (wordBound : n<2^64) (i : Fin 3) (x : Words)
    (input : Fin n → BitVec 64) (represented : Represents s.heap base input)
    (width : base.elementBytes=8) (capacity : base.index+n≤base.count)
    (writable : s.heap.writable base.block=true) (binding : s.arrays "a".toList=some base)
    (uCell : Cell s "u".toList u) (hnCell : Cell s "hn".toList hn)
    (ar : s.locals (storeParameters i).inputs.ar=some (.uint64,some (.uint64 x.ar)))
    (ai : s.locals (storeParameters i).inputs.ai=some (.uint64,some (.uint64 x.ai)))
    (br : s.locals (storeParameters i).inputs.br=some (.uint64,some (.uint64 x.br)))
    (bi : s.locals (storeParameters i).inputs.bi=some (.uint64,some (.uint64 x.bi))) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part (22+i.val)) s
      ⟨output s base n hn u inside length i x,.normal⟩ ∧
      Represents (output s base n hn u inside length i x).heap base (values n hn u inside length i x input) ∧
      FftGroupFrame143.Frame base n s (output s base n hn u inside length i x) := by
  let r := realSlot n hn u inside length i
  let q := imagSlot n hn u inside length i
  refine ⟨?_,?_,?_⟩
  · exact FftTripleAddCalls146.store_source i s x (element base r) (element base q) ar ai br bi
      (FftTripleIndices146.real_address s base n hn u inside length wordBound capacity binding uCell i)
      (FftTripleIndices146.imag_address s base n hn u inside length wordBound capacity binding uCell hnCell i)
      (FftLoadExec140.allocated_of_load s.heap (element base r) (input r) (represented r))
      (FftLoadExec140.allocated_of_load s.heap (element base q) (input q) (represented q)) width width writable writable
  · exact FpcPairBuffer146.image .add s base input represented width writable r q x
  · exact FpcPairBuffer146.frame .add s base width r q x

end FT1536.Source3.FftTripleStore146
