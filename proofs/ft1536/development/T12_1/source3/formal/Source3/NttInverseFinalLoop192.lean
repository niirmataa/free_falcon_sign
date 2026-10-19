import Source3.NttInverseFinalExec192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete original degree-1 butterfly loop of the accepted
   modp_iNTT3_ext final pass at logn9/full0: hn=256 paired iterations,
   the executed two-sided image of the a+u / a+hn+u walks, the u/r1/r2
   increment and the whole loop statement execution. Values are only the
   executed operations; no root or transform property is assumed. -/
namespace FT1536.Source3.NttInverseFinalLoop192
open C99ArrayReference (State Name Pointer bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk walk_index walk_count walk_width walk_step)
open NttInverseFinalBody192 (bb subA mid low high names declared withA0 withA1 withB withC
  firstHeap first secondHeap second output)
open NttInverseFinalExec192 (next body_run inc_run)

def finalLoop : C99ModularReference.Stmt :=
  .loop NttInversePrograms192.uGuard NttInversePrograms192.fBody NttInversePrograms192.uStep

def lowWord (fv : Nat → BitVec 32) (j hn : Nat) (w p p0i : BitVec 32) : BitVec 32 :=
  low (fv j) (fv (j+hn)) w p p0i
def highWord (fv : Nat → BitVec 32) (j hn : Nat) (w p p0i : BitVec 32) : BitVec 32 :=
  high (fv j) (fv (j+hn)) w p p0i

def Image (s : State) (a : ArrayPointer) (stride hn : Nat) (w p p0i : BitVec 32)
    (fv : Nat → BitVec 32) (i : Nat) : Prop :=
  ∀ j : Nat, j < hn →
    ((j < i → Load32 s.heap (walk a j stride) (lowWord fv j hn w p p0i) ∧
              Load32 s.heap (walk a (j+hn) stride) (highWord fv j hn w p p0i)) ∧
     (i ≤ j → Load32 s.heap (walk a j stride) (fv j) ∧
              Load32 s.heap (walk a (j+hn) stride) (fv (j+hn))))

structure Fixed (s : State) (a : ArrayPointer) (stride hn : Nat) (p p0i w : BitVec 32)
    (fv : Nat → BitVec 32) : Prop where
  hnBound : hn < 2^64
  hnPositive : 0 < hn
  strideBound : stride < 2^64
  aWidth : a.elementBytes=4
  aCapacity : a.index+2*hn*stride ≤ a.count
  aWritable : s.heap.writable a.block=true
  hnCell : USlot s "hn" hn
  strideCell : USlot s "stride" stride
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  wCell : Slot s "w" w
  separate : ∀ j k : Nat, j < 2*hn → k < 2*hn → j ≠ k →
    Word32Memory176.Separate (walk a j stride) (walk a k stride)

theorem out_local (s : State) (a : ArrayPointer) (stride hn i : Nat) (fv0 fv1 w p p0i : BitVec 32)
    (name : Name) : (output s a stride hn i fv0 fv1 w p p0i).locals name=s.locals name :=
  congrFun (NttInverseFinalBody192.after_locals s a stride hn i fv0 fv1 w p p0i) name

theorem out_array (s : State) (a : ArrayPointer) (stride hn i : Nat) (fv0 fv1 w p p0i : BitVec 32)
    (name : Name) : (output s a stride hn i fv0 fv1 w p p0i).arrays name=s.arrays name :=
  congrFun (NttInverseFinalBody192.after_arrays s a stride hn i fv0 fv1 w p p0i) name

theorem pair_capacity_low (a : ArrayPointer) (stride hn i : Nat)
    (capacity : a.index+2*hn*stride≤a.count) (slot : i<hn) :
    a.index+i*stride+stride≤a.count := by
  have step : (i+1)*stride≤(2*hn)*stride := Nat.mul_le_mul_right stride (by omega)
  rw [Nat.add_mul,Nat.one_mul] at step
  omega

theorem pair_capacity_high (a : ArrayPointer) (stride hn i : Nat)
    (capacity : a.index+2*hn*stride≤a.count) (slot : i<hn) :
    a.index+(i+hn)*stride+stride≤a.count := by
  have step : (i+hn+1)*stride≤(2*hn)*stride := Nat.mul_le_mul_right stride (by omega)
  rw [Nat.add_mul,Nat.one_mul] at step
  omega

theorem step_capacity (fixed : Fixed s a stride hn p p0i w fv) (i : Nat) (slot : i < hn) :
    (walk a i stride).index+stride≤(walk a i stride).count ∧
    (walk a (i+hn) stride).index+stride≤(walk a (i+hn) stride).count := by
  constructor
  · rw [walk_index,walk_count]
    exact pair_capacity_low a stride hn i fixed.aCapacity slot
  · rw [walk_index,walk_count]
    exact pair_capacity_high a stride hn i fixed.aCapacity slot

theorem write_allocated (h : C99MemoryReference.Memory) (p q : ArrayPointer) (w : BitVec 32)
    (allocated : Allocated h q) : Allocated (Word32Memory176.write h p w) q := allocated

theorem low_separate (fixed : Fixed s a stride hn p p0i w fv) (i : Nat) (slot : i < hn) :
    Word32Memory176.Separate (walk a i stride) (walk a (i+hn) stride) :=
  fixed.separate i (i+hn) (by omega) (by omega) (by
    intro equal
    have := fixed.hnPositive
    omega)

theorem output_fixed (s : State) (a : ArrayPointer) (stride hn i : Nat) (p p0i w : BitVec 32)
    (fv : Nat → BitVec 32) (fv0 fv1 : BitVec 32) (fixed : Fixed s a stride hn p p0i w fv) :
    Fixed (output s a stride hn i fv0 fv1 w p p0i) a stride hn p p0i w fv where
  hnBound := fixed.hnBound
  hnPositive := fixed.hnPositive
  strideBound := fixed.strideBound
  aWidth := fixed.aWidth
  aCapacity := fixed.aCapacity
  aWritable := fixed.aWritable
  hnCell := (out_local s a stride hn i fv0 fv1 w p p0i "hn".toList).trans fixed.hnCell
  strideCell := (out_local s a stride hn i fv0 fv1 w p p0i "stride".toList).trans
    fixed.strideCell
  pCell := (out_local s a stride hn i fv0 fv1 w p p0i "p".toList).trans fixed.pCell
  iCell := (out_local s a stride hn i fv0 fv1 w p p0i "p0i".toList).trans fixed.iCell
  wCell := (out_local s a stride hn i fv0 fv1 w p p0i "w".toList).trans fixed.wCell
  separate := fixed.separate

theorem output_image (s : State) (a : ArrayPointer) (stride hn i : Nat) (p p0i w : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride hn p p0i w fv) (slot : i < hn)
    (image : Image s a stride hn w p p0i fv i) :
    Image (output s a stride hn i (fv i) (fv (i+hn)) w p p0i) a stride hn w p p0i fv (i+1) := by
  intro j jBound
  have raw := (image j jBound).2
  have scaled := (image j jBound).1
  have heap : (output s a stride hn i (fv i) (fv (i+hn)) w p p0i).heap=
      secondHeap s a stride hn i (fv i) (fv (i+hn)) w p p0i := rfl
  have separateLow : Word32Memory176.Separate (walk a (i+hn) stride) (walk a i stride) := by
    cases low_separate fixed i slot with
    | inl different => exact Or.inl (Ne.symm different)
    | inr side =>
      cases side with
      | inl left => exact Or.inr (Or.inr left)
      | inr right => exact Or.inr (Or.inl right)
  have separateJ : j < 2*hn := by omega
  have separateJH : j+hn < 2*hn := by omega
  have separateI : i < 2*hn := by omega
  have separateIH : i+hn < 2*hn := by omega
  constructor
  · intro position
    have jle : j ≤ i := by omega
    by_cases same : j=i
    · subst same
      constructor
      · rw [heap]
        exact Word32Memory176.outside _ (walk a (j+hn) stride) (walk a j stride) _ _
          separateLow
          (Word32Memory176.here (withC s (fv j) (fv (j+hn)) w p p0i).heap (walk a j stride)
            (low (fv j) (fv (j+hn)) w p p0i)
            (StepProductFixed191.load_allocated ((image j slot).2 (Nat.le_refl j)).1)
            ((walk_width a j stride).trans fixed.aWidth) fixed.aWritable)
      · rw [heap]
        exact Word32Memory176.here (firstHeap s a stride j (fv j) (fv (j+hn)) w p p0i)
          (walk a (j+hn) stride) (high (fv j) (fv (j+hn)) w p p0i)
          (write_allocated (withC s (fv j) (fv (j+hn)) w p p0i).heap (walk a j stride)
            (walk a (j+hn) stride) (low (fv j) (fv (j+hn)) w p p0i)
            (StepProductFixed191.load_allocated ((image j slot).2 (Nat.le_refl j)).2))
          ((walk_width a (j+hn) stride).trans fixed.aWidth) fixed.aWritable
    · constructor
      · rw [heap]
        exact Word32Memory176.outside _ (walk a (i+hn) stride) (walk a j stride) _ _
          (fixed.separate (i+hn) j separateIH separateJ (by omega))
          (Word32Memory176.outside _ (walk a i stride) (walk a j stride) _ _
            (fixed.separate i j separateI separateJ (by omega))
            (scaled (by omega)).1)
      · rw [heap]
        exact Word32Memory176.outside _ (walk a (i+hn) stride) (walk a (j+hn) stride) _ _
          (fixed.separate (i+hn) (j+hn) separateIH separateJH (by omega))
          (Word32Memory176.outside _ (walk a i stride) (walk a (j+hn) stride) _ _
            (fixed.separate i (j+hn) separateI separateJH (by omega))
            (scaled (by omega)).2)
  · intro position
    constructor
    · rw [heap]
      exact Word32Memory176.outside _ (walk a (i+hn) stride) (walk a j stride) _ _
        (fixed.separate (i+hn) j separateIH separateJ (by omega))
        (Word32Memory176.outside _ (walk a i stride) (walk a j stride) _ _
          (fixed.separate i j separateI separateJ (by omega))
          (raw (by omega)).1)
    · rw [heap]
      exact Word32Memory176.outside _ (walk a (i+hn) stride) (walk a (j+hn) stride) _ _
        (fixed.separate (i+hn) (j+hn) separateIH separateJH (by omega))
        (Word32Memory176.outside _ (walk a i stride) (walk a (j+hn) stride) _ _
          (fixed.separate i (j+hn) separateI separateJH (by omega))
          (raw (by omega)).2)

theorem next_locals (s : State) (a : ArrayPointer) (stride hn i : Nat) (name : Name)
    (different : name≠"u".toList) :
    (next s a stride hn i).locals name=s.locals name := by
  have unfold : (next s a stride hn i).locals name=
      (bindPointer (bindPointer (FftLocalCells140.put s "u".toList (word (i+1)))
        "r1".toList (walk a (i+1) stride)) "r2".toList (walk a (i+1+hn) stride)).locals name := rfl
  rw [unfold]
  exact (FftLocalCells140.outside s "u".toList name (word (i+1)) different).trans rfl

theorem next_arrays (s : State) (a : ArrayPointer) (stride hn i : Nat) (name : Name)
    (first : name≠"r1".toList) (second : name≠"r2".toList) :
    (next s a stride hn i).arrays name=s.arrays name := by
  have unfold : (next s a stride hn i).arrays name=
      (bindPointer (bindPointer (FftLocalCells140.put s "u".toList (word (i+1)))
        "r1".toList (walk a (i+1) stride)) "r2".toList (walk a (i+1+hn) stride)).arrays name := rfl
  rw [unfold]
  rw [StepProductFixed191.bindPointer_arrays
    (bindPointer (FftLocalCells140.put s "u".toList (word (i+1)))
      "r1".toList (walk a (i+1) stride))
    "r2".toList (walk a (i+1+hn) stride) name second,
    StepProductFixed191.bindPointer_arrays
    (FftLocalCells140.put s "u".toList (word (i+1)))
    "r1".toList (walk a (i+1) stride) name first]
  rfl

theorem next_fixed (s : State) (a : ArrayPointer) (stride hn i : Nat) (p p0i w : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride hn p p0i w fv) :
    Fixed (next s a stride hn i) a stride hn p p0i w fv where
  hnBound := fixed.hnBound
  hnPositive := fixed.hnPositive
  strideBound := fixed.strideBound
  aWidth := fixed.aWidth
  aCapacity := fixed.aCapacity
  aWritable := fixed.aWritable
  hnCell := (next_locals s a stride hn i "hn".toList (by decide)).trans fixed.hnCell
  strideCell := (next_locals s a stride hn i "stride".toList (by decide)).trans fixed.strideCell
  pCell := (next_locals s a stride hn i "p".toList (by decide)).trans fixed.pCell
  iCell := (next_locals s a stride hn i "p0i".toList (by decide)).trans fixed.iCell
  wCell := (next_locals s a stride hn i "w".toList (by decide)).trans fixed.wCell
  separate := fixed.separate

theorem guard_run (s : State) (a : ArrayPointer) (stride hn i : Nat) (p p0i w : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride hn p p0i w fv) (iBound : i < 2^64)
    (uCell : Cell s "u".toList i) :
    C99ArrayReference.scalar s NttInversePrograms192.uGuard
      (C99ScalarReference.boolean (decide (i < hn))) :=
  C99LoopScalar141.less s (NttInversePrograms192.var "u") (NttInversePrograms192.var "hn")
    i hn iBound fixed.hnBound
    (C99LoopScalar141.read s "u".toList i uCell)
    (C99LoopScalar141.read s "hn".toList hn fixed.hnCell)

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
        after.arrays name=s.arrays name) := by
  induction count generalizing i s with
  | zero =>
    have equal : i=hn := by omega
    subst i
    have false : C99ArrayReference.scalar s NttInversePrograms192.uGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        guard_run s a stride hn hn p p0i w fv fixed fixed.hnBound uCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,uCell,r1Binding,r2Binding,
      image,fun _ _ => rfl,fun _ _ _ => rfl⟩
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
      finalArrays⟩ :=
      ih (i+1) tail tailFixed tailCell tailR1 tailR2 tailImage (by omega)
    refine ⟨after,?_,finalFixed,finalCell,finalR1,finalR2,finalImage,?_,?_⟩
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

end FT1536.Source3.NttInverseFinalLoop192
