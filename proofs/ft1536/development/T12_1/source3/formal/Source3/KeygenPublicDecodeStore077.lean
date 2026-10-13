import Source3.KeygenPublicDecodeCertified077
import Source3.KeygenDecodeWrite16
import Source3.KeygenDecodeStaticCertifiedStore

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeStore077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenPublicDecodeCertified077

theorem store (args : Args) (s : State) (rhs : Expr) (ptr next : ArrayPointer) (value : IV)
    (held : s.locals.x=some ptr) (advance : PointerAdd ptr 1 next)
    (calculation : Computes args s.heap s.buf rhs {s.locals with x := some next} value {s.locals with x := some next})
    (allocated : Allocated s.heap ptr) (width : ptr.elementBytes=2) (writable : s.heap.writable ptr.block=true) :
    Checked args (.write (.unary .dereference (.postInc (.variable "x".toList))) .set rhs) s
      ⟨KeygenDecodeWrite16.overwrite s.heap ptr (BitVec.ofInt 16 value.integer),{s.locals with x := some next},s.buf⟩ .normal := by
  let heap := KeygenDecodeWrite16.overwrite s.heap ptr (BitVec.ofInt 16 value.integer)
  have write : Store16 s.heap ptr (BitVec.ofInt 16 value.integer) heap :=
    KeygenDecodeWrite16.exists_store _ _ _ allocated width writable
  refine ⟨.storePointer args s _ rhs _ _ ptr value heap
    (.postInc _ _ _ _ _ (.pointer s.locals ptr next held advance))
    (computes_exists _ _ _ _ _ _ _ calculation) write,?_⟩
  intro after flow source
  cases source with
  | storePointer s pointer rhs actualMiddle actualLast actualPtr actualValue actualHeap address evaluated actualWrite =>
    cases address with
    | postInc name l actualMiddle actualOld actualNext update =>
      cases update with
      | pointer l actualPtr actualNext actualHeld actualAdvance =>
        have samePtr := Option.some.inj (actualHeld.symm.trans held)
        subst actualPtr
        have sameNext := KeygenDecodeCalculation.pointer_unique ptr actualNext next 1 actualAdvance advance
        subst actualNext
        obtain ⟨sameValue,sameLast⟩ := computes_eval _ _ _ _ _ _ _ _ _ calculation evaluated
        cases sameValue; subst actualLast
        have sameHeap := KeygenDecodeStaticCertifiedStore.store_unique s.heap actualHeap heap ptr _ actualWrite write
        subst actualHeap
        exact ⟨rfl,rfl⟩

end FT1536.Source3.KeygenPublicDecodeStore077
