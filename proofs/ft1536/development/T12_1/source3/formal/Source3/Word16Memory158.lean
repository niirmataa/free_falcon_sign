import Source3.C99NarrowReads
import Source3.KeygenResidueVectors

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Word16Memory158
open C99MemoryReference
open C99NarrowReads (Load16)
open KeygenSmallOutput (Store16 byte16)

def write (before : Memory) (p : ArrayPointer) (word : BitVec 16) : Memory where
  bytes := fun block offset => if inside : block=p.block ∧ p.offset ≤ offset ∧ offset<p.offset+2 then
    some (byte16 word ⟨offset-p.offset,by omega⟩) else before.bytes block offset
  size := before.size
  writable := before.writable

theorem source (before : Memory) (p : ArrayPointer) (word : BitVec 16)
    (allocated : Allocated before p) (width : p.elementBytes=2) (writable : before.writable p.block=true) :
    Store16 before p word (write before p word) := by
  refine ⟨allocated,width,writable,rfl,rfl,?_,?_⟩
  · intro i
    have inside : p.block=p.block ∧ p.offset ≤ p.offset+i.val ∧ p.offset+i.val<p.offset+2 := by have bound:=i.isLt; omega
    dsimp only [write]
    rw [dite_eq_left inside]
    congr 2
    apply Fin.ext
    change p.offset+i.val-p.offset=i.val
    omega
  · intro block offset outside
    have absent : ¬(block=p.block ∧ p.offset ≤ offset ∧ offset<p.offset+2) := by omega
    simp only [write,dite_eq_right absent]

theorem here (before : Memory) (p : ArrayPointer) (word : BitVec 16)
    (allocated : Allocated before p) (width : p.elementBytes=2) (writable : before.writable p.block=true) :
    Load16 (write before p word) p word := by
  have stored := source before p word allocated width writable
  have loaded : Load16 (write before p word) p (C99NarrowReads.le16 (byte16 word)) :=
    .load _ _ (byte16 word) allocated width stored.2.2.2.2.2.1
  simpa only [KeygenResidueVectors.join_bytes] using loaded

def Separate (p q : ArrayPointer) : Prop := p.block≠q.block ∨ p.offset+2 ≤ q.offset ∨ q.offset+2 ≤ p.offset

theorem outside (before : Memory) (p q : ArrayPointer) (word old : BitVec 16)
    (separate : Separate p q) (read : Load16 before q old) : Load16 (write before p word) q old := by
  apply C99NarrowReads.load16_transport before (write before p word) q old read rfl
  intro i
  have bound:=i.isLt
  have absent : ¬(q.block=p.block ∧ p.offset ≤ q.offset+i.val ∧ q.offset+i.val<p.offset+2) := by
    unfold Separate at separate
    omega
  simp only [write,dite_eq_right absent]

def element (base : ArrayPointer) {n : Nat} (i : Fin n) : ArrayPointer := {base with index := base.index+i.val}
def Represents (heap : Memory) (base : ArrayPointer) {n : Nat} (values : Fin n → BitVec 16) : Prop :=
  ∀ i, Load16 heap (element base i) (values i)
theorem separate {n : Nat} (base : ArrayPointer) (width : base.elementBytes=2) (i j : Fin n) (different : i≠j) :
    Separate (element base i) (element base j) := by
  have distinct : i.val≠j.val := fun same => different (Fin.ext same)
  unfold Separate element ArrayPointer.offset
  rw [width]
  change base.block≠base.block ∨ base.base+2*(base.index+i.val)+2 ≤ base.base+2*(base.index+j.val) ∨
    base.base+2*(base.index+j.val)+2 ≤ base.base+2*(base.index+i.val)
  omega

end FT1536.Source3.Word16Memory158
