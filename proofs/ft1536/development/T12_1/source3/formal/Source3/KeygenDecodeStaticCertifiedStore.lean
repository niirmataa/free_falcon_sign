import Source3.KeygenDecodeStaticCertified
import Source3.KeygenDecodeWrite16

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticCertifiedStore
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenDecodeStaticCertified

theorem store_unique (heap a b : Memory) (ptr : ArrayPointer) (word : BitVec 16)
    (first : Store16 heap ptr word a) (second : Store16 heap ptr word b) : a=b := by
  have bytes : a.bytes=b.bytes := by
    funext block offset
    by_cases same : block=ptr.block
    · subst block
      by_cases low : offset=ptr.offset
      · subst offset; exact first.2.2.2.2.2.1.trans second.2.2.2.2.2.1.symm
      · by_cases high : offset=ptr.offset+1
        · subst offset; exact first.2.2.2.2.2.2.1.trans second.2.2.2.2.2.2.1.symm
        · have outside : ptr.block≠ptr.block ∨ offset<ptr.offset ∨ ptr.offset+2≤offset := by omega
          exact (first.2.2.2.2.2.2.2 _ _ outside).trans (second.2.2.2.2.2.2.2 _ _ outside).symm
    · exact (first.2.2.2.2.2.2.2 _ _ (Or.inl same)).trans (second.2.2.2.2.2.2.2 _ _ (Or.inl same)).symm
  have size := first.2.2.2.1.trans second.2.2.2.1.symm
  have writable := first.2.2.2.2.1.trans second.2.2.2.2.1.symm
  cases a; cases b
  cases bytes; cases size; cases writable
  rfl

theorem store (args : Args) (s : State) (index rhs : Expr) (m last : Locals)
    (ptr atWord : ArrayPointer) (offset value : IV)
    (held : s.locals.x=some ptr)
    (indexValue : Computes args s.heap s.buf index s.locals offset m)
    (nonnegative : 0≤offset.integer) (advance : PointerAdd ptr offset.integer.toNat atWord)
    (rhsValue : Computes args s.heap s.buf rhs m value last)
    (allocated : Allocated s.heap atWord) (width : atWord.elementBytes=2)
    (writable : s.heap.writable atWord.block=true) :
    Checked args (.write (.index (.variable "x".toList) index) .set rhs) s
      ⟨KeygenDecodeWrite16.overwrite s.heap atWord (BitVec.ofInt 16 value.integer),last,s.buf⟩ .normal := by
  let heap := KeygenDecodeWrite16.overwrite s.heap atWord (BitVec.ofInt 16 value.integer)
  have write : Store16 s.heap atWord (BitVec.ofInt 16 value.integer) heap :=
    KeygenDecodeWrite16.exists_store s.heap atWord _ allocated width writable
  refine ⟨.store args s index rhs m last ptr atWord offset value heap held
    (computes_exists _ _ _ _ _ _ _ indexValue) nonnegative advance
    (computes_exists _ _ _ _ _ _ _ rhsValue) write,?_⟩
  intro after flow source
  cases source with
  | store s index rhs actualMiddle actualLast actualPtr actualAt actualOffset actualValue actualHeap original indexSource actualNonnegative actualAdvance rhsSource actualWrite =>
    have samePtr := Option.some.inj (original.symm.trans held)
    subst actualPtr
    obtain ⟨sameOffset,sameMiddle⟩ := computes_eval _ _ _ _ _ _ _ _ _ indexValue indexSource
    cases sameOffset; subst actualMiddle
    have sameAt := KeygenDecodeCalculation.pointer_unique _ _ _ _ actualAdvance advance
    subst actualAt
    obtain ⟨sameValue,sameLast⟩ := computes_eval _ _ _ _ _ _ _ _ _ rhsValue rhsSource
    cases sameValue; subst actualLast
    have sameHeap := store_unique s.heap actualHeap heap atWord _ actualWrite write
    subst actualHeap
    exact ⟨rfl,rfl⟩

end FT1536.Source3.KeygenDecodeStaticCertifiedStore
