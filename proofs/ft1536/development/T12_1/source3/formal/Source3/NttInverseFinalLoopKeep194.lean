import Source3.NttInverseFinalLoop192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Keep-extended re-proof of the degree-1 butterfly loop of the accepted
   modp_iNTT3_ext final pass (the sealed NttInverseFinalLoop192 loop with
   hn = 256 iterations and two writes each): in addition to the executed
   two-sided image and the caller frames, every load from a cell separate
   from the walked a region survives the whole loop and the heap
   writability is transported unchanged. The per-cell bystander keep is
   the shape NttInverseMiddleRounds192.source already exports; values
   stay executed words and no root or transform property is assumed. -/
namespace FT1536.Source3.NttInverseFinalLoopKeep194
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk)
open NttInverseFinalBody192 (low high names withC firstHeap secondHeap output)
open NttInverseFinalExec192 (body_run inc_run next)
open NttInverseFinalLoop192 (Image Fixed finalLoop out_local out_array output_fixed output_image
  next_locals next_arrays next_fixed guard_run step_capacity)

theorem body_keep (s : State) (a : ArrayPointer) (stride hn i : Nat) (fv0 fv1 w p p0i : BitVec 32)
    (slot : i < hn) (q : ArrayPointer)
    (separate : ∀ x : Nat, x < 2*hn → Separate (walk a x stride) q)
    (z : BitVec 32) (load : Load32 s.heap q z) :
    Load32 (output s a stride hn i fv0 fv1 w p p0i).heap q z := by
  have cHeap : (withC s fv0 fv1 w p p0i).heap=s.heap := rfl
  have first : Load32 (firstHeap s a stride i fv0 fv1 w p p0i) q z := by
    show Load32 (Word32Memory176.write (withC s fv0 fv1 w p p0i).heap (walk a i stride)
      (low fv0 fv1 w p p0i)) q z
    rw [cHeap]
    exact Word32Memory176.outside s.heap (walk a i stride) q (low fv0 fv1 w p p0i) z
      (separate i (by omega)) load
  have second : Load32 (secondHeap s a stride hn i fv0 fv1 w p p0i) q z := by
    show Load32 (Word32Memory176.write (firstHeap s a stride i fv0 fv1 w p p0i)
      (walk a (i+hn) stride) (high fv0 fv1 w p p0i)) q z
    exact Word32Memory176.outside (firstHeap s a stride i fv0 fv1 w p p0i)
      (walk a (i+hn) stride) q (high fv0 fv1 w p p0i) z (separate (i+hn) (by omega)) first
  show Load32 (secondHeap s a stride hn i fv0 fv1 w p p0i) q z
  exact second

theorem body_writable (s : State) (a : ArrayPointer) (stride hn i : Nat) (fv0 fv1 w p p0i : BitVec 32) :
    (output s a stride hn i fv0 fv1 w p p0i).heap.writable=s.heap.writable := rfl

theorem remaining (count i : Nat) (s : State) (a : ArrayPointer) (stride hn : Nat)
    (p p0i w : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a stride hn p p0i w fv)
    (uCell : Cell s "u".toList i) (r1Binding : s.arrays "r1".toList=some (walk a i stride))
    (r2Binding : s.arrays "r2".toList=some (walk a (i+hn) stride))
    (image : Image s a stride hn w p p0i fv i) (finish : i+count=hn) :
    ∃ after, Exec finalLoop s ⟨after,.normal⟩ ∧
      Fixed after a stride hn p p0i w fv ∧ Cell after "u".toList hn ∧
      after.arrays "r1".toList=some (walk a hn stride) ∧
      after.arrays "r2".toList=some (walk a (hn+hn) stride) ∧
      Image after a stride hn w p p0i fv hn ∧
      (∀ name : Name, name ≠ "u".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name ≠ "r1".toList → name ≠ "r2".toList →
        after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < 2*hn → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=s.heap.writable := by
  induction count generalizing i s with
  | zero =>
    have equal : i=hn := by omega
    subst i
    have false : C99ArrayReference.scalar s NttInversePrograms192.uGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        guard_run s a stride hn hn p p0i w fv fixed fixed.hnBound uCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,uCell,r1Binding,r2Binding,
      image,fun _ _ => rfl,fun _ _ _ => rfl,fun _ _ _ load => load,rfl⟩
  | succ count ih =>
    have slot : i < hn := by omega
    have iBound : i < 2^64 := by have := fixed.hnBound; omega
    have nonzero : (C99ScalarReference.boolean (decide (i < hn))).integer ≠ 0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    have body : Exec NttInversePrograms192.fBody s
        ⟨output s a stride hn i (fv i) (fv (i+hn)) w p p0i,.normal⟩ :=
      body_run s a stride hn i p p0i w (fv i) (fv (i+hn)) fixed.pCell fixed.iCell fixed.wCell
        r1Binding r2Binding ((image i slot).2 (Nat.le_refl i)).1 ((image i slot).2 (Nat.le_refl i)).2
        fixed.aWidth fixed.aWritable
    have bodyFixed : Fixed (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn
        p p0i w fv :=
      output_fixed s a stride hn i p p0i w fv (fv i) (fv (i+hn)) fixed
    have bodyImage : Image (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn
        w p p0i fv (i+1) :=
      output_image s a stride hn i p p0i w fv fixed slot image
    have bodyKeep : ∀ q : ArrayPointer, (∀ x : Nat, x < 2*hn → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z →
        Load32 (output s a stride hn i (fv i) (fv (i+hn)) w p p0i).heap q z :=
      fun q separate z load => body_keep s a stride hn i (fv i) (fv (i+hn)) w p p0i slot q
        separate z load
    have bodyWritable : (output s a stride hn i (fv i) (fv (i+hn)) w p p0i).heap.writable=
        s.heap.writable := body_writable s a stride hn i (fv i) (fv (i+hn)) w p p0i
    have update : Exec NttInversePrograms192.uStep
        (output s a stride hn i (fv i) (fv (i+hn)) w p p0i)
        ⟨next (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn i,.normal⟩ :=
      inc_run (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn i
        ((out_local s a stride hn i (fv i) (fv (i+hn)) w p p0i "stride".toList).trans
          fixed.strideCell)
        fixed.strideBound
        ((out_local s a stride hn i (fv i) (fv (i+hn)) w p p0i "u".toList).trans uCell)
        iBound
        ((out_array s a stride hn i (fv i) (fv (i+hn)) w p p0i "r1".toList).trans r1Binding)
        ((out_array s a stride hn i (fv i) (fv (i+hn)) w p p0i "r2".toList).trans r2Binding)
        (step_capacity bodyFixed i slot).1 (step_capacity bodyFixed i slot).2
    set tail : State :=
      next (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn i with tailEq
    have tailFixed : Fixed tail a stride hn p p0i w fv := by
      rw [tailEq]
      exact next_fixed (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn i
        p p0i w fv bodyFixed
    have tailCell : Cell tail "u".toList (i+1) := by
      rw [tailEq]
      exact FftLocalCells140.cell_at
        (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) "u".toList (word (i+1))
    have tailR1 : tail.arrays "r1".toList=some (walk a (i+1) stride) := by
      rw [tailEq]
      rfl
    have tailR2 : tail.arrays "r2".toList=some (walk a (i+1+hn) stride) := by
      rw [tailEq]
      rfl
    have tailImage : Image tail a stride hn w p p0i fv (i+1) := by
      rw [tailEq]
      intro j jBound
      have keep : (next (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn i).heap=
          (output s a stride hn i (fv i) (fv (i+hn)) w p p0i).heap := rfl
      constructor
      · intro position
        rw [keep]
        exact (bodyImage j jBound).1 position
      · intro position
        rw [keep]
        exact (bodyImage j jBound).2 position
    obtain ⟨after,rest,finalFixed,finalCell,finalR1,finalR2,finalImage,finalLocals,
      finalArrays,finalKeep,finalWritable⟩ :=
      ih (i+1) tail tailFixed tailCell tailR1 tailR2 tailImage (by omega)
    refine ⟨after,?_,finalFixed,finalCell,finalR1,finalR2,finalImage,?_,?_,?_,?_⟩
    · refine .loopNormal _ _ _ s
        (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) tail ⟨after,.normal⟩
        (C99ScalarReference.boolean (decide (i < hn))) ?_ nonzero body update rest
      exact guard_run s a stride hn i p p0i w fv fixed iBound uCell
    · intro name different
      have first : tail.locals name=s.locals name := by
        rw [tailEq]
        exact (next_locals (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn i
          name different).trans
          (out_local s a stride hn i (fv i) (fv (i+hn)) w p p0i name)
      exact (finalLocals name different).trans first
    · intro name first second
      have kept : tail.arrays name=s.arrays name := by
        rw [tailEq]
        exact (next_arrays (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn i
          name first second).trans
          (out_array s a stride hn i (fv i) (fv (i+hn)) w p p0i name)
      exact (finalArrays name first second).trans kept
    · intro q separate z load
      exact finalKeep q separate z (bodyKeep q separate z load)
    · exact finalWritable.trans bodyWritable

theorem source (s : State) (a : ArrayPointer) (stride hn : Nat)
    (p p0i w : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a stride hn p p0i w fv)
    (uCell : Cell s "u".toList 0) (r1Binding : s.arrays "r1".toList=some (walk a 0 stride))
    (r2Binding : s.arrays "r2".toList=some (walk a (0+hn) stride))
    (image : Image s a stride hn w p p0i fv 0) :
    ∃ after, Exec finalLoop s ⟨after,.normal⟩ ∧
      Fixed after a stride hn p p0i w fv ∧ Cell after "u".toList hn ∧
      after.arrays "r1".toList=some (walk a hn stride) ∧
      after.arrays "r2".toList=some (walk a (hn+hn) stride) ∧
      Image after a stride hn w p p0i fv hn ∧
      (∀ name : Name, name ≠ "u".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name ≠ "r1".toList → name ≠ "r2".toList →
        after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < 2*hn → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=s.heap.writable :=
  remaining hn 0 s a stride hn p p0i w fv fixed uCell r1Binding r2Binding image (by omega)

end FT1536.Source3.NttInverseFinalLoopKeep194
