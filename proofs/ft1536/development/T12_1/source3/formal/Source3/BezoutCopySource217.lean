import Source3.BezoutMemcpy217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The original memcpy statement for one bounded Bezout limb image. -/
namespace FT1536.Source3.BezoutCopySource217
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open ZintNormWalkFlat208 (Data)
open KeygenZintCall (Exec)

def count (name : String) : CLogic.Expr := .bin .mul (.var name.toList) (.literal .u64 4)
def copy (dst src len : String) : KeygenZintCall.Stmt :=
  ZintNormWalk194.wordArray (.copy dst.toList src.toList C99ProcedureParser.zero C99ProcedureParser.zero (count len))
def after (s : State) (dst src : ArrayPointer) (n : Nat) : State :=
  {s with heap:=MemmoveWord177.snapshot s.heap dst src (4*n)}

theorem count_eval (s : State) (name : String) (n : Nat) (bound : n≤335) (cell : Cell s name.toList n) :
    C99ArrayReference.scalar s (count name) (.uint64 (word (4*n))) := by
  have product := NttInverseFinalPass192.word_mul n 4 (by omega) (by decide)
  have eq : n*4=4*n := by omega
  rw [eq] at product
  exact .arithmetic .times _ _ _ _ _ (.variable _ _ _ cell) (.literal .uint64 4) product

theorem source (s : State) (dstName srcName lenName : String) (dst src : ArrayPointer) (n : Nat)
    (bound : n≤335) (dstBinding : s.arrays dstName.toList=some dst) (srcBinding : s.arrays srcName.toList=some src)
    (length : Cell s lenName.toList n) (dstRange : dst.offset+4*n≤dst.base+dst.elementBytes*dst.count)
    (srcRange : src.offset+4*n≤src.base+src.elementBytes*src.count)
    (dstObject : dst.base+dst.elementBytes*dst.count≤s.heap.size dst.block)
    (srcObject : src.base+src.elementBytes*src.count≤s.heap.size src.block)
    (dstSize : s.heap.size dst.block<2^64) (srcSize : s.heap.size src.block<2^64)
    (writable : s.heap.writable dst.block=true) (dstWidth : dst.elementBytes=4) (srcWidth : src.elementBytes=4)
    (data : Data s src n W)
    (apart : dst.block≠src.block ∨ dst.offset+4*n≤src.offset ∨ src.offset+4*n≤dst.offset) :
    Exec (copy dstName srcName lenName) s ⟨after s dst src n,.normal⟩ := by
  have countBound : 4*n<2^64 := by omega
  have dcap : dst.index+0≤dst.count := by
    have h:=dstRange
    simp only [C99MemoryReference.ArrayPointer.offset,dstWidth] at h
    omega
  have scap : src.index+0≤src.count := by
    have h:=srcRange
    simp only [C99MemoryReference.ArrayPointer.offset,srcWidth] at h
    omega
  have move := BezoutMemcpy217.source s.heap dst src n dstRange srcRange dstObject srcObject dstSize srcSize writable srcWidth
    (fun j jb => ⟨W j,data j jb⟩) apart
  have destination := RootBinding175.zero s dstName dst dstBinding dcap
  have sourcePointer := RootBinding175.zero s srcName src srcBinding scap
  have dObj : dst.offset+(word (4*n)).toNat≤dst.base+dst.elementBytes*dst.count := by
    rw [C99NatWord141.to_nat _ countBound]; exact dstRange
  have sObj : src.offset+(word (4*n)).toNat≤src.base+src.elementBytes*src.count := by
    rw [C99NatWord141.to_nat _ countBound]; exact srcRange
  have actual : C99MemoryReference.Memcpy s.heap dst src (word (4*n)).toNat (MemmoveWord177.snapshot s.heap dst src (4*n)) := by
    rw [C99NatWord141.to_nat _ countBound]; exact move
  exact ZintNormWord194.word_run _ _ _ (.modular _ _ _ (.base _ _ _
    (.copy _ _ _ _ _ _ _ _ _ _ destination sourcePointer (count_eval s lenName n bound length) dObj sObj actual)))

end FT1536.Source3.BezoutCopySource217
