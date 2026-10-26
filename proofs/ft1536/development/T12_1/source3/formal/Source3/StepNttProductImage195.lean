import Source3.StepNttRoundImage195
import Source3.StepNttKeep195
import Source3.MakeFgAddPrimeShape194
import Source3.StepProductBody191

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/-! # Doubling images at the tail exit and the pair-product reads

The selected full=0 tail executes the actual skipped triple branch.
Its heap equality transports all 512 image words. The product bridge
uses the original shifted indices, pointer rules and loads, shared by
productFd/productGd. Destination layout and enclosing section assembly
remain separate obligations. No spectral or root/table law is claimed.
-/
namespace FT1536.Source3.StepNttProductImage195
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open C99ModularReference (Exec Eval)
open KeygenNttLoopSupport (USlot)
open StepNttMiddle195 (MFixed)
open StepNttMloop195
open StepNttImage195 (Image)
open StepNttRoundImage195

theorem tail_run_image (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0i : BitVec 32) (W : Nat → BitVec 32) (wide : 512≤gmn)
    (fixed : MFixed s a gm gvs pw p0i) (image : Image s a W)
    (tFree : ∃ old, s.locals "t".toList=some (.uint64,old))
    (mFree : ∃ old, s.locals "m".toList=some (.uint64,old)) :
    ∃ out, Exec StepNttBody195.tailT s ⟨out,.normal⟩ ∧ MFixed out a gm gvs pw p0i ∧
      USlot out "m" 512 ∧ USlot out "t" 1 ∧
      NttWriteFrame182.Frame a 512 s.heap out.heap ∧
      Image out a (doublingWords gvs W pw p0i) := by
  obtain ⟨oldT,tCell⟩ := tFree
  obtain ⟨oldM,mCell⟩ := mFree
  have tRun : Exec KeygenNttForwardPrograms.tFromHalf s ⟨tFrom s,.normal⟩ :=
    t_init s oldT tCell fixed.hnSlot
  have mRun : Exec KeygenNttForwardPrograms.mInit (tFrom s) ⟨mStart s,.normal⟩ :=
    m_init s oldM mCell
  obtain ⟨out,walkRun,mFixed,mOut,tOut,frame,outImage⟩ := m_walk_image 8 2 256 selected_plan (mStart s) a gm
    gvs pw p0i W wide (m_start_fixed s a gm gvs pw p0i fixed)
    (StepNttImage195.image_keep image rfl) rfl rfl
  have triple : Exec KeygenNttForwardPrograms.triplePass out ⟨out,.normal⟩ :=
    triple_skip out mFixed.fullSlot
  have mHeadRun : Exec StepNttBody195.mHead (tFrom s) ⟨out,.normal⟩ :=
    .seqNormal _ _ (tFrom s) (mStart s) ⟨out,.normal⟩ mRun walkRun
  have middle : Exec StepNttBody195.tailMiddle (tFrom s) ⟨out,.normal⟩ :=
    .seqNormal _ _ (tFrom s) out ⟨out,.normal⟩ mHeadRun triple
  have tail : Exec StepNttBody195.tailT s ⟨out,.normal⟩ :=
    .seqNormal _ _ s (tFrom s) ⟨out,.normal⟩ tRun middle
  exact ⟨out,tail,mFixed,mOut,tOut,frame,
    StepNttImage195.image_keep outImage (StepNttKeep195.tail_keep_words rfl)⟩

/-- The two actual source expressions shared by the fd and gd bodies. -/
theorem product_shapes :
    MakeFgAddPrimeShape194.productFd=
      .seq MakeFgProductShape191.productInit MakeFgProductShape191.productLoop ∧
    MakeFgAddPrimeShape194.productGd=
      .seq MakeFgGsShape194.productInitGd MakeFgProductShape191.productLoop :=
  ⟨MakeFgAddPrimeShape194.productFd_shape,MakeFgAddPrimeShape194.productGd_shape⟩

/-- Transfer through the taken tail frame, then read the shifted pair. -/
theorem tail_pair_loads {s2 out : State} {t1 : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s2 t1 W) (heap : out.heap=s2.heap) (v : Nat) (bound : v<256) :
    Load32 out.heap (StepCopyBody190.elem t1 (2*v)) (W (2*v)) ∧
    Load32 out.heap (StepCopyBody190.elem t1 (2*v+1)) (W (2*v+1)) := by
  have kept : Image out t1 W :=
    StepNttImage195.image_keep image (StepNttKeep195.tail_keep_words heap)
  exact ⟨kept (2*v) (by omega),kept (2*v+1) (by omega)⟩

/-- Evaluate the literal t1[(v<<1)+0/1] expressions at the product state. -/
theorem product_reads {s2 out : State} {t1 : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s2 t1 W) (heap : out.heap=s2.heap) (v : Nat) (bound : v<256)
    (binding : out.arrays "t1".toList=some t1) (counter : C99LoopScalar141.Cell out "v".toList v) :
    Eval out (MakeFgProductShape191.readT1 0) (.uint32 (W (2*v))) ∧
    Eval out (MakeFgProductShape191.readT1 1) (.uint32 (W (2*v+1))) := by
  obtain ⟨low,high⟩ := tail_pair_loads image heap v bound
  have capacity : t1.index+(2*v+1)<t1.count := by
    have allocated := StepNttFirstLoop195.load_allocated high
    exact allocated.2.2.1
  exact ⟨.load32 _ _ _ _
      (StepProductBody191.t1_address out t1 (MakeFgProductShape191.index 0) (2*v) (by omega)
        (by omega) binding (StepProductBody191.index0_value out v (by omega) (by omega) counter)) low,
    .load32 _ _ _ _
      (StepProductBody191.t1_address out t1 (MakeFgProductShape191.index 1) (2*v+1) (by omega)
        (by omega) binding (StepProductBody191.index1_value out v (by omega) (by omega) counter)) high⟩

/-- The reads occur in order after the actual declarations/w0 assignment. -/
theorem product_assignments {s2 out : State} {t1 : ArrayPointer} {W : Nat → BitVec 32}
    (image : Image s2 t1 W) (heap : out.heap=s2.heap) (v : Nat) (bound : v<256)
    (binding : out.arrays "t1".toList=some t1) (counter : C99LoopScalar141.Cell out "v".toList v) :
    KeygenMakeFgSource.Exec MakeFgProductShape191.w0Assign (StepProductBody191.declared out)
      ⟨StepProductBody191.w0s out (W (2*v)),.normal⟩ ∧
    KeygenMakeFgSource.Exec MakeFgProductShape191.w1Assign (StepProductBody191.w0s out (W (2*v)))
      ⟨StepProductBody191.w1s out (W (2*v)) (W (2*v+1)),.normal⟩ := by
  have declaredCounter : C99LoopScalar141.Cell (StepProductBody191.declared out) "v".toList v :=
    (StepProductBody191.declared_outside out "v".toList (by decide) (by decide)).trans counter
  have counterW0 : C99LoopScalar141.Cell (StepProductBody191.w0s out (W (2*v))) "v".toList v :=
    (ModularAtoms178.outside (StepProductBody191.declared out) "w0" "v" (W (2*v)) (by decide)).trans
      declaredCounter
  have low := (product_reads image (show (StepProductBody191.declared out).heap=s2.heap from heap)
    v bound binding declaredCounter).1
  have high := (product_reads image (show (StepProductBody191.w0s out (W (2*v))).heap=s2.heap from heap)
    v bound binding counterW0).2
  exact ⟨.level _ _ _ (.modular _ _ _ (ModularAtoms178.assign _ "w0" none _ _ rfl low)),
    .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign _ "w1" none _ _ rfl high))⟩

end FT1536.Source3.StepNttProductImage195
