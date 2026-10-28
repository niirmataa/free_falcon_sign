import Source3.BezoutInitLowBit217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The two source copies and low-bit store at selected geometry. -/
namespace FT1536.Source3.BezoutInitMore217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open KeygenZintCall (Exec Stmt)
open KeygenSmallOutput (element)
open StepCopyBody190 (elem)
open NinthStepLayout217 (fd gd)
open DeepestSelectedCrt217 (tmp)
open BezoutPointerSetup217 (v1)
open ZintNormWalkFlat208 (Data)

def code : Stmt := .seq BezoutInitMoreCopies217.first (.seq BezoutInitMoreCopies217.second BezoutInitLowBit217.store)
def after (s : State) (nx ny : Nat) (X : Nat → BitVec 32) :=
  BezoutInitLowBit217.after (BezoutInitMoreCopies217.after s nx ny) (X 0)

theorem source (s : State) (nx ny : Nat) (X Y : Nat → BitVec 32) (h : BezoutInitMoreCopies217.Input s nx ny X Y)
    (positive : 0<nx) :
    Exec code s ⟨after s nx ny X,.normal⟩ ∧
    Data (after s nx ny X) fd 335 X ∧ Data (after s nx ny X) gd 335 Y ∧
    Data (after s nx ny X) tmp ny Y ∧ Data (after s nx ny X) v1 nx (BezoutInitLowBit217.image X) := by
  obtain ⟨runU,runV,xf,yf,uf,vf⟩:=BezoutInitMoreCopies217.source s nx ny X Y h
  let copied := BezoutInitMoreCopies217.after s nx ny
  have extent : 4*71680≤copied.heap.size 31 := h.extent
  have size : copied.heap.size 31<2^64 := h.size
  have alloc : Allocated copied.heap v1 := by
    have proof := BezoutInitCopies217.allocated_at copied.heap 1675 0 extent size (by decide)
    exact proof
  have writable : copied.heap.writable v1.block=true := h.writable
  have binding : copied.arrays "v1".toList=some v1 := h.v1Binding
  obtain ⟨storeRun,vImage⟩:=BezoutInitLowBit217.source copied nx X positive binding alloc writable vf
  have sepX : ∀ i<335, Word32Memory176.Separate v1 (elem fd i) := by
    intro i bound; right; right; change 0+4*(670+i)+4≤0+4*1675; omega
  have sepY : ∀ i<335, Word32Memory176.Separate v1 (elem gd i) := by
    intro i bound; right; right; change 0+4*(1005+i)+4≤0+4*1675; omega
  have sepU : ∀ i<ny, Word32Memory176.Separate v1 (elem tmp i) := by
    intro i bound; right; right; change 0+4*(1340+i)+4≤0+4*1675; have b:=h.nyBound; omega
  exact ⟨.seqNormal _ _ _ _ _ runU (.seqNormal _ _ _ _ _ runV storeRun),
    BezoutInitLowBit217.keep_data copied (X 0) fd 335 X xf sepX,
    BezoutInitLowBit217.keep_data copied (X 0) gd 335 Y yf sepY,
    BezoutInitLowBit217.keep_data copied (X 0) tmp ny Y uf sepU,vImage⟩

theorem keep_data (s : State) (nx ny n : Nat) (X W : Nat → BitVec 32) (root : ArrayPointer)
    (data : Data s root n W)
    (sepU : ∀ i<n, (elem root i).block≠tmp.block ∨ (elem root i).offset+4≤tmp.offset ∨ tmp.offset+4*ny≤(elem root i).offset)
    (sepV : ∀ i<n, (elem root i).block≠v1.block ∨ (elem root i).offset+4≤v1.offset ∨ v1.offset+4*nx≤(elem root i).offset)
    (sepWord : ∀ i<n, Word32Memory176.Separate v1 (elem root i)) : Data (after s nx ny X) root n W := by
  intro i bound
  exact Word32Memory176.outside _ v1 (elem root i) _ _ (sepWord i bound)
    (BezoutCopyFrame217.outside _ v1 fd (elem root i) (4*nx) _ (sepV i bound)
      (BezoutCopyFrame217.outside s.heap tmp gd (elem root i) (4*ny) _ (sepU i bound) (data i bound)))

end FT1536.Source3.BezoutInitMore217
