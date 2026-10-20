import Source3.NttInverseCorrectionLoop192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Keep-extended re-proof of the corrective Montgomery scaling loop of the
   accepted modp_iNTT3_ext corpus (the sealed NttInverseCorrectionLoop192
   loop at n = 512 steps with one write each): in addition to the executed
   image and the caller frames, every load from a cell separate from the
   walked a region survives the whole loop and the heap writability is
   transported unchanged. The per-cell bystander keep is the shape
   NttInverseMiddleRounds192.source already exports; values stay executed
   words and no inverse or divisibility property is assumed. -/
namespace FT1536.Source3.NttInverseCorrectionLoopKeep194
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open NttInverseCorrectionLoop192 (walk scale Image Fixed scaleLoop output next
  output_locals output_arrays output_fixed next_fixed output_image next_locals next_arrays
  body_run inc_run guard_run)
open C99NatWord141 (word)

theorem body_keep (s : State) (a : ArrayPointer) (stride n i : Nat) (written : BitVec 32)
    (slot : i < n) (q : ArrayPointer)
    (separate : ∀ x : Nat, x < n → Separate (walk a x stride) q)
    (z : BitVec 32) (load : Load32 s.heap q z) :
    Load32 (output s a stride i written).heap q z :=
  Word32Memory176.outside s.heap (walk a i stride) q written z (separate i slot) load

theorem body_writable (s : State) (a : ArrayPointer) (stride i : Nat) (z : BitVec 32) :
    (output s a stride i z).heap.writable=s.heap.writable := rfl

theorem remaining (count i : Nat) (s : State) (a : ArrayPointer) (stride n : Nat)
    (p p0i ni : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a stride n p p0i ni fv)
    (uCell : Cell s "u".toList i) (r1Binding : s.arrays "r1".toList=some (walk a i stride))
    (image : Image s a stride n p p0i ni fv i) (finish : i+count=n) :
    ∃ after, Exec scaleLoop s ⟨after,.normal⟩ ∧
      Fixed after a stride n p p0i ni fv ∧ Cell after "u".toList n ∧
      after.arrays "r1".toList=some (walk a n stride) ∧
      Image after a stride n p p0i ni fv n ∧
      (∀ name : Name, name ≠ "u".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name ≠ "r1".toList → after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < n → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=s.heap.writable := by
  induction count generalizing i s with
  | zero =>
    have equal : i=n := by omega
    subst i
    have false : C99ArrayReference.scalar s NttInversePrograms192.cGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        guard_run s a stride n n p p0i ni fv fixed fixed.nBound uCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,uCell,r1Binding,image,
      fun _ _ => rfl,fun _ _ => rfl,fun _ _ _ load => load,rfl⟩
  | succ count ih =>
    have slot : i < n := by omega
    have iBound : i < 2^64 := by have := fixed.nBound; omega
    have nonzero : (C99ScalarReference.boolean (decide (i < n))).integer ≠ 0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    have body : Exec NttInversePrograms192.cBody s
        ⟨output s a stride i (scale (fv i) ni p p0i),.normal⟩ :=
      body_run s a stride n i p p0i ni fv fixed slot r1Binding image
    have bodyFixed : Fixed (output s a stride i (scale (fv i) ni p p0i)) a stride n p p0i ni fv :=
      output_fixed s a stride n i p p0i ni fv _ fixed
    have bodyImage : Image (output s a stride i (scale (fv i) ni p p0i)) a stride n p p0i ni fv (i+1) :=
      output_image s a stride n i p p0i ni fv fixed slot image
    have bodyKeep : ∀ q : ArrayPointer, (∀ x : Nat, x < n → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z →
        Load32 (output s a stride i (scale (fv i) ni p p0i)).heap q z :=
      fun q separate z load =>
        body_keep s a stride n i (scale (fv i) ni p p0i) slot q separate z load
    have bodyWritable : (output s a stride i (scale (fv i) ni p p0i)).heap.writable=
        s.heap.writable := body_writable s a stride i (scale (fv i) ni p p0i)
    have update : Exec NttInversePrograms192.cStep
        (output s a stride i (scale (fv i) ni p p0i)) ⟨next (output s a stride i (scale (fv i) ni p p0i)) a stride i,.normal⟩ :=
      inc_run (output s a stride i (scale (fv i) ni p p0i)) a stride n i p p0i ni fv bodyFixed slot
        ((output_locals s a stride i _ "u".toList).trans uCell)
        ((output_arrays s a stride i _ "r1".toList).trans r1Binding)
    set tail : State := next (output s a stride i (scale (fv i) ni p p0i)) a stride i with tailEq
    have tailFixed : Fixed tail a stride n p p0i ni fv := by
      rw [tailEq]
      exact next_fixed (output s a stride i (scale (fv i) ni p p0i)) a stride n i p p0i ni fv bodyFixed
    have tailCell : Cell tail "u".toList (i+1) := by
      rw [tailEq]
      exact FftLocalCells140.cell_at
        (output s a stride i (scale (fv i) ni p p0i)) "u".toList (word (i+1))
    have tailX : tail.arrays "r1".toList=some (walk a (i+1) stride) := by
      rw [tailEq]
      rfl
    have tailImage : Image tail a stride n p p0i ni fv (i+1) := by
      rw [tailEq]
      intro j jBound
      have keep : (next (output s a stride i (scale (fv i) ni p p0i)) a stride i).heap=
          (output s a stride i (scale (fv i) ni p p0i)).heap := rfl
      constructor
      · intro position
        rw [keep]
        exact (bodyImage j jBound).1 position
      · intro position
        rw [keep]
        exact (bodyImage j jBound).2 position
    obtain ⟨after,rest,finalFixed,finalCell,finalX,finalImage,finalLocals,finalArrays,
      finalKeep,finalWritable⟩ :=
      ih (i+1) tail tailFixed tailCell tailX tailImage (by omega)
    refine ⟨after,?_,finalFixed,finalCell,finalX,finalImage,?_,?_,?_,?_⟩
    · refine .loopNormal _ _ _ s
        (output s a stride i (scale (fv i) ni p p0i)) tail ⟨after,.normal⟩
        (C99ScalarReference.boolean (decide (i < n))) ?_ nonzero body update rest
      exact guard_run s a stride n i p p0i ni fv fixed iBound uCell
    · intro name different
      have first : tail.locals name=s.locals name := by
        rw [tailEq]
        exact next_locals (output s a stride i (scale (fv i) ni p p0i)) a stride i name different
      exact (finalLocals name different).trans first
    · intro name different
      have first : tail.arrays name=s.arrays name := by
        rw [tailEq]
        exact (next_arrays (output s a stride i (scale (fv i) ni p p0i)) a stride i name different).trans
          (output_arrays s a stride i _ name)
      exact (finalArrays name different).trans first
    · intro q separate z load
      exact finalKeep q separate z (bodyKeep q separate z load)
    · exact finalWritable.trans bodyWritable

theorem source (s : State) (a : ArrayPointer) (stride n : Nat)
    (p p0i ni : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a stride n p p0i ni fv)
    (uCell : Cell s "u".toList 0) (r1Binding : s.arrays "r1".toList=some (walk a 0 stride))
    (image : Image s a stride n p p0i ni fv 0) :
    ∃ after, Exec scaleLoop s ⟨after,.normal⟩ ∧
      Fixed after a stride n p p0i ni fv ∧ Cell after "u".toList n ∧
      after.arrays "r1".toList=some (walk a n stride) ∧
      Image after a stride n p p0i ni fv n ∧
      (∀ name : Name, name ≠ "u".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name ≠ "r1".toList → after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < n → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=s.heap.writable :=
  remaining n 0 s a stride n p p0i ni fv fixed uCell r1Binding image (by omega)

end FT1536.Source3.NttInverseCorrectionLoopKeep194
