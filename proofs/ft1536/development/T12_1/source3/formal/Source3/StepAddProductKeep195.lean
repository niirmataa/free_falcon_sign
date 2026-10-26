import Source3.StepAddProduct195
import Source3.StepProductKeepCell194
import Source3.StepGsProductKeepCell194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepAddProductKeep195
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open SelectedStepLayout187 (fd gd t1)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open StepCopyBody190 (addr)
open StepAddProduct195

theorem fd_source (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    ∃ out, KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.productFd s ⟨out,.normal⟩ ∧
      StepProductFixed191.Image out fd 1 2 256 p1 p0i1 r21 W 256 ∧
      StepNttImage195.Image out t1 W ∧ C99LoopScalar141.Cell out "v".toList 256 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Nat, i<256 → Separate (addr fd 1 i 2) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) := by
  have zero : C99LoopScalar141.Cell (fdMid s) "v".toList 0 :=
    FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)
  have empty := StepProductFixed191.empty_image (fdMid s) fd 1 2 256 p1 p0i1 r21 W
  have vacuous : StepCopyKeep193.Reads (fdMid s) t1 0 W := fun k bound => absurd bound (by omega)
  have apart : ∀ i : Fin 256, ∀ k : Nat, k<0 →
      Separate (addr fd 1 i.val 2) ({t1 with index:=t1.index+k}) :=
    fun _ _ bound => absurd bound (by omega)
  obtain ⟨out,run,fixed,vCell,xCell,image,locals,arrays,keepA,keepB,keep,writable⟩ :=
    StepProductKeepCell194.source (fdMid s) fd t1 1 2 256 p1 p0i1 r21 W
      (fd_fixed s W input) zero rfl empty t1 0 W vacuous apart t1 0 W vacuous apart
  refine ⟨out,?_,image,?_,vCell,?_,?_,?_⟩
  · rw [(StepNttProductImage195.product_shapes).1]
    exact .seqNormal _ _ s (fdMid s) _ (fd_init s W input) run
  · intro j bound
    exact fixed.src ⟨j,bound⟩
  · intro name different
    exact (locals name different).trans (fd_locals s name different)
  · intro name different
    exact (arrays name different).trans (fd_arrays s name different)
  · intro q separate w read
    exact keep q separate w read

theorem gd_source (s : State) (W : Nat → BitVec 32) (input : Input s W) :
    ∃ out, KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.productGd s ⟨out,.normal⟩ ∧
      StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21 W 256 ∧
      StepNttImage195.Image out t1 W ∧ C99LoopScalar141.Cell out "v".toList 256 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Nat, i<256 → Separate (addr gd 1 i 2) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) := by
  have zero : C99LoopScalar141.Cell (gdMid s) "v".toList 0 :=
    FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)
  have empty := StepProductFixed191.empty_image (gdMid s) gd 1 2 256 p1 p0i1 r21 W
  have vacuous : StepCopyKeep193.Reads (gdMid s) t1 0 W := fun k bound => absurd bound (by omega)
  have apart : ∀ i : Fin 256, ∀ k : Nat, k<0 →
      Separate (addr gd 1 i.val 2) ({t1 with index:=t1.index+k}) :=
    fun _ _ bound => absurd bound (by omega)
  obtain ⟨out,run,fixed,vCell,xCell,image,locals,arrays,keepA,keepB,keep,writable⟩ :=
    StepGsProductKeepCell194.source (gdMid s) gd t1 1 2 256 p1 p0i1 r21 W
      (gd_fixed s W input) zero rfl empty t1 0 W vacuous apart t1 0 W vacuous apart
  refine ⟨out,?_,image,?_,vCell,?_,?_,?_⟩
  · rw [(StepNttProductImage195.product_shapes).2]
    exact .seqNormal _ _ s (gdMid s) _ (gd_init s W input) run
  · intro j bound
    exact fixed.src ⟨j,bound⟩
  · intro name different
    exact (locals name different).trans (gd_locals s name different)
  · intro name different
    exact (arrays name different).trans (gd_arrays s name different)
  · intro q separate w read
    exact keep q separate w read

end FT1536.Source3.StepAddProductKeep195
