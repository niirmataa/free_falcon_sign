import Source3.FftTripleBody147
import Source3.FftPinned139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTriplingInvariant148
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open FftTripleBody147 (Constants)

structure Fixed (s : State) (base : ArrayPointer) (c : Constants) : Prop where
  width : base.elementBytes=8
  capacity : base.index+1536≤base.count
  writable : s.heap.writable base.block=true
  binding : s.arrays "a".toList=some base
  hnCell : Cell s "hn".toList 768
  tableBinding : s.arrays "fpr_gm3_cubic".toList=some (FftGlobalMemory.pointer .cubic)
  pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment s.heap
  w2rCell : s.locals "fpr_W2R".toList=some (.uint64,some (.uint64 c.w2r))
  w2iCell : s.locals "fpr_W2I".toList=some (.uint64,some (.uint64 c.w2i))
  w4rCell : s.locals "fpr_W4R".toList=some (.uint64,some (.uint64 c.w4r))
  w4iCell : s.locals "fpr_W4I".toList=some (.uint64,some (.uint64 c.w4i))

theorem context (s : State) (base : ArrayPointer) (c : Constants) (k : Nat) (fixed : Fixed s base c)
    (uCell : Cell s "u".toList (3*k)) (vCell : Cell s "v".toList (2*(512+k))) (range : k<256) :
    FftTripleBody147.Context s base 1536 768 (3*k) (512+k) c :=
  ⟨⟨by omega,by decide,by decide,fixed.width,fixed.capacity,fixed.writable,fixed.binding,uCell,fixed.hnCell⟩,
    by omega,vCell,fixed.tableBinding,fixed.pinned,fixed.w2rCell,fixed.w2iCell,fixed.w4rCell,fixed.w4iCell⟩

theorem transfer (s after : State) (base : ArrayPointer) (c : Constants) (fixed : Fixed s base c)
    (frame : FftGroupFrame143.Frame base 1536 s after)
    (pinned : CertificateM0Environment.Pinned FftGlobalMemory.environment after.heap) : Fixed after base c := by
  refine ⟨fixed.width,fixed.capacity,?_,?_,?_,?_,pinned,?_,?_,?_,?_⟩
  · rw [frame.writable]; exact fixed.writable
  · rw [frame.arrays]; exact fixed.binding
  · exact (congrFun frame.locals "hn".toList).trans fixed.hnCell
  · rw [frame.arrays]; exact fixed.tableBinding
  · rw [frame.locals]; exact fixed.w2rCell
  · rw [frame.locals]; exact fixed.w2iCell
  · rw [frame.locals]; exact fixed.w4rCell
  · rw [frame.locals]; exact fixed.w4iCell

theorem put (s : State) (base : ArrayPointer) (c : Constants) (fixed : Fixed s base c)
    (name : Name) (value : BitVec 64) (counter : name="u".toList ∨ name="v".toList) :
    Fixed (FftLocalCells140.put s name value) base c := by
  have hn : "hn".toList≠name := by rcases counter with rfl|rfl <;> decide
  have w2r : "fpr_W2R".toList≠name := by rcases counter with rfl|rfl <;> decide
  have w2i : "fpr_W2I".toList≠name := by rcases counter with rfl|rfl <;> decide
  have w4r : "fpr_W4R".toList≠name := by rcases counter with rfl|rfl <;> decide
  have w4i : "fpr_W4I".toList≠name := by rcases counter with rfl|rfl <;> decide
  exact ⟨fixed.width,fixed.capacity,fixed.writable,fixed.binding,
    (FftLocalCells140.outside s name _ value hn).trans fixed.hnCell,fixed.tableBinding,fixed.pinned,
    (FftLocalCells140.outside s name _ value w2r).trans fixed.w2rCell,
    (FftLocalCells140.outside s name _ value w2i).trans fixed.w2iCell,
    (FftLocalCells140.outside s name _ value w4r).trans fixed.w4rCell,
    (FftLocalCells140.outside s name _ value w4i).trans fixed.w4iCell⟩

theorem guard (s : State) (base : ArrayPointer) (c : Constants) (k : Nat) (fixed : Fixed s base c)
    (uCell : Cell s "u".toList (3*k)) (range : k≤256) :
    C99ArrayReference.scalar s (FftMiddleShape139.condition FftTripleShape145.loop)
      (C99ScalarReference.boolean (decide (k<256))) := by
  rw [FftTripleShape145.loop_test]
  have result := C99LoopScalar141.less s (.var "u".toList) (.var "hn".toList) (3*k) 768 (by omega) (by decide)
    (C99LoopScalar141.read s "u".toList (3*k) uCell) (C99LoopScalar141.read s "hn".toList 768 fixed.hnCell)
  have equivalent : 3*k<768 ↔ k<256 := by omega
  simpa only [equivalent] using result

end FT1536.Source3.FftTriplingInvariant148
