import Source3.Word16Memory158
import Source3.Gate00Memory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Word32Memory176
open C99MemoryReference

def write (before : Memory) (p : ArrayPointer) (word : BitVec 32) : Memory where
  bytes := fun block offset => if inside : block=p.block ∧ p.offset≤offset ∧ offset<p.offset+4 then
    some (byte32 word ⟨offset-p.offset,by omega⟩) else before.bytes block offset
  size := before.size
  writable := before.writable

theorem source (before : Memory) (p : ArrayPointer) (word : BitVec 32)
    (allocated : Allocated before p) (width : p.elementBytes=4) (writable : before.writable p.block=true) :
    Store32 before p word (write before p word) := by
  refine ⟨allocated,width,writable,rfl,rfl,?_,?_⟩
  · intro i
    have inside : p.block=p.block ∧ p.offset≤p.offset+i.val ∧ p.offset+i.val<p.offset+4 := by have bound:=i.isLt; omega
    dsimp only [write]
    rw [dite_eq_left inside]
    congr 2
    apply Fin.ext
    change p.offset+i.val-p.offset=i.val
    omega
  · intro block offset outside
    have absent : ¬(block=p.block ∧ p.offset≤offset ∧ offset<p.offset+4) := by omega
    simp only [write,dite_eq_right absent]

theorem here (before : Memory) (p : ArrayPointer) (word : BitVec 32)
    (allocated : Allocated before p) (width : p.elementBytes=4) (writable : before.writable p.block=true) :
    Load32 (write before p word) p word := by
  have stored := source before p word allocated width writable
  have loaded : Load32 (write before p word) p (le32 (byte32 word)) :=
    .load _ _ (byte32 word) allocated width stored.2.2.2.2.2.1
  have join : le32 (byte32 word)=word := StableBinaryByteView.flag_join_bytes word
  rw [join] at loaded
  exact loaded

def Separate (p q : ArrayPointer) : Prop := p.block≠q.block ∨ p.offset+4≤q.offset ∨ q.offset+4≤p.offset

theorem outside (before : Memory) (p q : ArrayPointer) (word old : BitVec 32)
    (separate : Separate p q) (read : Load32 before q old) : Load32 (write before p word) q old := by
  apply Gate00Memory.load32_transport before (write before p word) q old read rfl
  intro i
  have bound:=i.isLt
  have absent : ¬(q.block=p.block ∧ p.offset≤q.offset+i.val ∧ q.offset+i.val<p.offset+4) := by
    unfold Separate at separate
    omega
  simp only [write,dite_eq_right absent]

theorem outside16 (before : Memory) (p q : ArrayPointer) (word : BitVec 32) (old : BitVec 16)
    (different : p.block≠q.block) (read : C99NarrowReads.Load16 before q old) :
    C99NarrowReads.Load16 (write before p word) q old := by
  apply C99NarrowReads.load16_transport before (write before p word) q old read rfl
  intro i
  simp only [write,Ne.symm different,false_and,dite_false]

def element (base : ArrayPointer) {n : Nat} (i : Fin n) : ArrayPointer := {base with index:=base.index+i.val}
def Represents (heap : Memory) (base : ArrayPointer) {n : Nat} (values : Fin n → BitVec 32) : Prop :=
  ∀ i, Load32 heap (element base i) (values i)

theorem separate {n : Nat} (base : ArrayPointer) (width : base.elementBytes=4) (i j : Fin n) (different : i≠j) :
    Separate (element base i) (element base j) := by
  have distinct : i.val≠j.val := fun same => different (Fin.ext same)
  unfold Separate element ArrayPointer.offset
  rw [width]
  change base.block≠base.block ∨ base.base+4*(base.index+i.val)+4≤base.base+4*(base.index+j.val) ∨
    base.base+4*(base.index+j.val)+4≤base.base+4*(base.index+i.val)
  omega

end FT1536.Source3.Word32Memory176
