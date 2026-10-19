import Source3.NttInverseMiddleBody192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete original intermediate-pass radix-2 loop of the accepted
   modp_iNTT3_ext corpus at one u1 group: ht paired iterations through
   the walked r1/r2 pointers starting at the v1 block, the executed
   two-sided image of the a+v1+j / a+v1+ht+j walks, the v/r1/r2
   increment and the whole loop statement execution. Values are only the
   executed operations; no transform property is assumed. -/
namespace FT1536.Source3.NttInverseMiddleVLoop192
open C99ArrayReference (State Name Pointer bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk walk_index walk_count walk_width walk_step)
open NttInverseMiddleBody192 (bb subA high declared withX withY first second output next
  body_run inc_run after_locals after_arrays)

def vWalk : C99ModularReference.Stmt :=
  .loop NttInversePrograms192.vGuard NttInversePrograms192.vBody NttInversePrograms192.vStep

def lowWord (fv : Nat → BitVec 32) (v1 ht : Nat) (j : Nat) (p : BitVec 32) : BitVec 32 :=
  bb (fv (v1+j)) (fv (v1+ht+j)) p
def highWord (fv : Nat → BitVec 32) (v1 ht : Nat) (j : Nat) (tw p p0i : BitVec 32) : BitVec 32 :=
  high (fv (v1+j)) (fv (v1+ht+j)) tw p p0i

def Image (s : State) (a : ArrayPointer) (stride ht v1 : Nat) (tw p p0i : BitVec 32)
    (fv : Nat → BitVec 32) (i : Nat) : Prop :=
  ∀ j : Nat, j < ht →
    ((j < i → Load32 s.heap (walk a (v1+j) stride) (lowWord fv v1 ht j p) ∧
              Load32 s.heap (walk a (v1+ht+j) stride) (highWord fv v1 ht j tw p p0i)) ∧
     (i ≤ j → Load32 s.heap (walk a (v1+j) stride) (fv (v1+j)) ∧
              Load32 s.heap (walk a (v1+ht+j) stride) (fv (v1+ht+j))))

structure Fixed (s : State) (a : ArrayPointer) (stride ht v1 : Nat) (p p0i tw : BitVec 32)
    (fv : Nat → BitVec 32) : Prop where
  htBound : ht < 2^64
  htPositive : 0 < ht
  strideBound : stride < 2^64
  aWidth : a.elementBytes=4
  aCapacity : a.index+(v1+2*ht)*stride ≤ a.count
  aWritable : s.heap.writable a.block=true
  htCell : USlot s "ht" ht
  strideCell : USlot s "stride" stride
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  sCell : Slot s "s" tw
  separate : ∀ j k : Nat, j < v1+2*ht → k < v1+2*ht → j ≠ k →
    Separate (walk a j stride) (walk a k stride)

theorem out_local (s : State) (a : ArrayPointer) (stride j k : Nat)
    (x y tw p p0i : BitVec 32) (name : Name) :
    (NttInverseMiddleBody192.output s a stride j k x y tw p p0i).locals name=s.locals name :=
  congrFun (NttInverseMiddleBody192.after_locals s a stride j k x y tw p p0i) name

theorem out_array (s : State) (a : ArrayPointer) (stride j k : Nat)
    (x y tw p p0i : BitVec 32) (name : Name) :
    (NttInverseMiddleBody192.output s a stride j k x y tw p p0i).arrays name=s.arrays name :=
  congrFun (NttInverseMiddleBody192.after_arrays s a stride j k x y tw p p0i) name

theorem pair_capacity_low (a : ArrayPointer) (stride ht v1 i : Nat)
    (capacity : a.index+(v1+2*ht)*stride≤a.count) (slot : i<ht) :
    a.index+(v1+i)*stride+stride≤a.count := by
  have bound : v1+i+1≤v1+2*ht := by omega
  have steps : (v1+i)*stride+stride≤(v1+2*ht)*stride := by
    have := Nat.mul_le_mul_right stride bound
    rw [Nat.succ_mul] at this
    exact this
  omega

theorem pair_capacity_high (a : ArrayPointer) (stride ht v1 i : Nat)
    (capacity : a.index+(v1+2*ht)*stride≤a.count) (slot : i<ht) :
    a.index+(v1+ht+i)*stride+stride≤a.count := by
  have bound : v1+ht+i+1≤v1+2*ht := by omega
  have steps : (v1+ht+i)*stride+stride≤(v1+2*ht)*stride := by
    have := Nat.mul_le_mul_right stride bound
    rw [Nat.succ_mul] at this
    exact this
  omega

theorem step_capacity (fixed : Fixed s a stride ht v1 p p0i tw fv) (i : Nat) (slot : i < ht) :
    (walk a (v1+i) stride).index+stride≤(walk a (v1+i) stride).count ∧
    (walk a (v1+ht+i) stride).index+stride≤(walk a (v1+ht+i) stride).count := by
  constructor
  · rw [walk_index,walk_count]
    exact pair_capacity_low a stride ht v1 i fixed.aCapacity slot
  · rw [walk_index,walk_count]
    exact pair_capacity_high a stride ht v1 i fixed.aCapacity slot

theorem write_allocated (h : C99MemoryReference.Memory) (p q : ArrayPointer) (w : BitVec 32)
    (allocated : Allocated h q) : Allocated (Word32Memory176.write h p w) q := allocated

theorem low_separate (fixed : Fixed s a stride ht v1 p p0i tw fv) (i : Nat) (slot : i < ht) :
    Separate (walk a (v1+i) stride) (walk a (v1+ht+i) stride) :=
  fixed.separate (v1+i) (v1+ht+i) (by omega) (by omega) (by
    intro equal
    have := fixed.htPositive
    omega)

theorem output_fixed (s : State) (a : ArrayPointer) (stride ht v1 i : Nat) (p p0i tw : BitVec 32)
    (fv : Nat → BitVec 32) (x y : BitVec 32)
    (fixed : Fixed s a stride ht v1 p p0i tw fv) :
    Fixed (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i) x y tw p p0i)
      a stride ht v1 p p0i tw fv where
  htBound := fixed.htBound
  htPositive := fixed.htPositive
  strideBound := fixed.strideBound
  aWidth := fixed.aWidth
  aCapacity := fixed.aCapacity
  aWritable := fixed.aWritable
  htCell := (out_local s a stride (v1+i) (v1+ht+i) x y tw p p0i "ht".toList).trans
    fixed.htCell
  strideCell := (out_local s a stride (v1+i) (v1+ht+i) x y tw p p0i "stride".toList).trans
    fixed.strideCell
  pCell := (out_local s a stride (v1+i) (v1+ht+i) x y tw p p0i "p".toList).trans
    fixed.pCell
  iCell := (out_local s a stride (v1+i) (v1+ht+i) x y tw p p0i "p0i".toList).trans
    fixed.iCell
  sCell := (out_local s a stride (v1+i) (v1+ht+i) x y tw p p0i "s".toList).trans
    fixed.sCell
  separate := fixed.separate

theorem output_image (s : State) (a : ArrayPointer) (stride ht v1 i : Nat) (p p0i tw : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride ht v1 p p0i tw fv) (slot : i < ht)
    (image : Image s a stride ht v1 tw p p0i fv i) :
    Image (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
      (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride ht v1 tw p p0i fv (i+1) := by
  intro j jBound
  have raw := (image j jBound).2
  have scaled := (image j jBound).1
  have heap : (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
      (fv (v1+i)) (fv (v1+ht+i)) tw p p0i).heap=
      NttInverseMiddleBody192.secondHeap s a stride (v1+i) (v1+ht+i)
        (fv (v1+i)) (fv (v1+ht+i)) tw p p0i := rfl
  have separateLow : Separate (walk a (v1+ht+i) stride) (walk a (v1+i) stride) := by
    cases low_separate fixed i slot with
    | inl different => exact Or.inl (Ne.symm different)
    | inr side =>
      cases side with
      | inl left => exact Or.inr (Or.inr left)
      | inr right => exact Or.inr (Or.inl right)
  have separateJ : v1+j < v1+2*ht := by omega
  have separateJH : v1+ht+j < v1+2*ht := by omega
  have separateI : v1+i < v1+2*ht := by omega
  have separateIH : v1+ht+i < v1+2*ht := by omega
  constructor
  · intro position
    have jle : j ≤ i := by omega
    by_cases same : j=i
    · subst same
      constructor
      · rw [heap]
        exact Word32Memory176.outside _ (walk a (v1+ht+j) stride) (walk a (v1+j) stride) _ _
          separateLow
          (Word32Memory176.here
            (NttInverseMiddleBody192.withY s (fv (v1+j)) (fv (v1+ht+j))).heap
            (walk a (v1+j) stride) (bb (fv (v1+j)) (fv (v1+ht+j)) p)
            (StepProductFixed191.load_allocated ((image j slot).2 (Nat.le_refl j)).1)
            ((walk_width a (v1+j) stride).trans fixed.aWidth) fixed.aWritable)
      · rw [heap]
        exact Word32Memory176.here
          (NttInverseMiddleBody192.firstHeap s a stride (v1+j) (fv (v1+j)) (fv (v1+ht+j)) p)
          (walk a (v1+ht+j) stride)
          (high (fv (v1+j)) (fv (v1+ht+j)) tw p p0i)
          (write_allocated
            (NttInverseMiddleBody192.withY s (fv (v1+j)) (fv (v1+ht+j))).heap
            (walk a (v1+j) stride) (walk a (v1+ht+j) stride)
            (bb (fv (v1+j)) (fv (v1+ht+j)) p)
            (StepProductFixed191.load_allocated ((image j slot).2 (Nat.le_refl j)).2))
          ((walk_width a (v1+ht+j) stride).trans fixed.aWidth) fixed.aWritable
    · constructor
      · rw [heap]
        exact Word32Memory176.outside _ (walk a (v1+ht+i) stride) (walk a (v1+j) stride) _ _
          (fixed.separate (v1+ht+i) (v1+j) separateIH separateJ (by omega))
          (Word32Memory176.outside _ (walk a (v1+i) stride) (walk a (v1+j) stride) _ _
            (fixed.separate (v1+i) (v1+j) separateI separateJ (by omega))
            (scaled (by omega)).1)
      · rw [heap]
        exact Word32Memory176.outside _ (walk a (v1+ht+i) stride) (walk a (v1+ht+j) stride) _ _
          (fixed.separate (v1+ht+i) (v1+ht+j) separateIH separateJH (by omega))
          (Word32Memory176.outside _ (walk a (v1+i) stride) (walk a (v1+ht+j) stride) _ _
            (fixed.separate (v1+i) (v1+ht+j) separateI separateJH (by omega))
            (scaled (by omega)).2)
  · intro position
    constructor
    · rw [heap]
      exact Word32Memory176.outside _ (walk a (v1+ht+i) stride) (walk a (v1+j) stride) _ _
        (fixed.separate (v1+ht+i) (v1+j) separateIH separateJ (by omega))
        (Word32Memory176.outside _ (walk a (v1+i) stride) (walk a (v1+j) stride) _ _
          (fixed.separate (v1+i) (v1+j) separateI separateJ (by omega))
          (raw (by omega)).1)
    · rw [heap]
      exact Word32Memory176.outside _ (walk a (v1+ht+i) stride) (walk a (v1+ht+j) stride) _ _
        (fixed.separate (v1+ht+i) (v1+ht+j) separateIH separateJH (by omega))
        (Word32Memory176.outside _ (walk a (v1+i) stride) (walk a (v1+ht+j) stride) _ _
          (fixed.separate (v1+i) (v1+ht+j) separateI separateJH (by omega))
          (raw (by omega)).2)

theorem next_locals (s : State) (a : ArrayPointer) (stride j k i : Nat) (name : Name)
    (different : name≠"v".toList) :
    (NttInverseMiddleBody192.next s a stride j k i).locals name=s.locals name := by
  have unfold : (NttInverseMiddleBody192.next s a stride j k i).locals name=
      (bindPointer (bindPointer (FftLocalCells140.put s "v".toList (word (i+1)))
        "r1".toList (walk a (j+1) stride)) "r2".toList (walk a (k+1) stride)).locals name := rfl
  rw [unfold]
  exact (FftLocalCells140.outside s "v".toList name (word (i+1)) different).trans rfl

theorem next_arrays (s : State) (a : ArrayPointer) (stride j k i : Nat) (name : Name)
    (first : name≠"r1".toList) (second : name≠"r2".toList) :
    (NttInverseMiddleBody192.next s a stride j k i).arrays name=s.arrays name := by
  have unfold : (NttInverseMiddleBody192.next s a stride j k i).arrays name=
      (bindPointer (bindPointer (FftLocalCells140.put s "v".toList (word (i+1)))
        "r1".toList (walk a (j+1) stride)) "r2".toList (walk a (k+1) stride)).arrays name := rfl
  rw [unfold]
  rw [StepProductFixed191.bindPointer_arrays
    (bindPointer (FftLocalCells140.put s "v".toList (word (i+1)))
      "r1".toList (walk a (j+1) stride))
    "r2".toList (walk a (k+1) stride) name second,
    StepProductFixed191.bindPointer_arrays
    (FftLocalCells140.put s "v".toList (word (i+1)))
    "r1".toList (walk a (j+1) stride) name first]
  rfl

theorem next_fixed (s : State) (a : ArrayPointer) (stride ht v1 i : Nat) (p p0i tw : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride ht v1 p p0i tw fv) :
    Fixed (NttInverseMiddleBody192.next s a stride (v1+i) (v1+ht+i) i)
      a stride ht v1 p p0i tw fv where
  htBound := fixed.htBound
  htPositive := fixed.htPositive
  strideBound := fixed.strideBound
  aWidth := fixed.aWidth
  aCapacity := fixed.aCapacity
  aWritable := fixed.aWritable
  htCell := (next_locals s a stride (v1+i) (v1+ht+i) i "ht".toList (by decide)).trans fixed.htCell
  strideCell := (next_locals s a stride (v1+i) (v1+ht+i) i "stride".toList (by decide)).trans
    fixed.strideCell
  pCell := (next_locals s a stride (v1+i) (v1+ht+i) i "p".toList (by decide)).trans fixed.pCell
  iCell := (next_locals s a stride (v1+i) (v1+ht+i) i "p0i".toList (by decide)).trans fixed.iCell
  sCell := (next_locals s a stride (v1+i) (v1+ht+i) i "s".toList (by decide)).trans fixed.sCell
  separate := fixed.separate

theorem guard_run (s : State) (a : ArrayPointer) (stride ht v1 i : Nat) (p p0i tw : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride ht v1 p p0i tw fv) (iBound : i < 2^64)
    (vCell : Cell s "v".toList i) :
    C99ArrayReference.scalar s NttInversePrograms192.vGuard
      (C99ScalarReference.boolean (decide (i < ht))) :=
  C99LoopScalar141.less s (NttInversePrograms192.var "v") (NttInversePrograms192.var "ht")
    i ht iBound fixed.htBound
    (C99LoopScalar141.read s "v".toList i vCell)
    (C99LoopScalar141.read s "ht".toList ht fixed.htCell)

theorem remaining (count i : Nat) (s : State) (a : ArrayPointer) (stride ht v1 : Nat)
    (p p0i tw : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a stride ht v1 p p0i tw fv)
    (vCell : Cell s "v".toList i)
    (r1Binding : s.arrays "r1".toList=some (walk a (v1+i) stride))
    (r2Binding : s.arrays "r2".toList=some (walk a (v1+ht+i) stride))
    (image : Image s a stride ht v1 tw p p0i fv i) (finish : i+count=ht) :
    ∃ after, Exec vWalk s ⟨after,.normal⟩ ∧
      Fixed after a stride ht v1 p p0i tw fv ∧ Cell after "v".toList ht ∧
      after.arrays "r1".toList=some (walk a (v1+ht) stride) ∧
      after.arrays "r2".toList=some (walk a (v1+ht+ht) stride) ∧
      Image after a stride ht v1 tw p p0i fv ht ∧
      (∀ name : Name, name ≠ "v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name ≠ "r1".toList → name ≠ "r2".toList →
        after.arrays name=s.arrays name) := by
  induction count generalizing i s with
  | zero =>
    have equal : i=ht := by omega
    subst i
    have false : C99ArrayReference.scalar s NttInversePrograms192.vGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        guard_run s a stride ht v1 ht p p0i tw fv fixed fixed.htBound vCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,vCell,r1Binding,r2Binding,
      image,fun _ _ => rfl,fun _ _ _ => rfl⟩
  | succ count ih =>
    have slot : i < ht := by omega
    have iBound : i < 2^64 := by have := fixed.htBound; omega
    have nonzero : (C99ScalarReference.boolean (decide (i < ht))).integer ≠ 0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    have body : Exec NttInversePrograms192.vBody s
        ⟨NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i,.normal⟩ :=
      body_run s a stride (v1+i) (v1+ht+i) p p0i tw (fv (v1+i)) (fv (v1+ht+i))
        fixed.pCell fixed.iCell fixed.sCell r1Binding r2Binding
        ((image i slot).2 (Nat.le_refl i)).1 ((image i slot).2 (Nat.le_refl i)).2
        fixed.aWidth fixed.aWritable
    have bodyFixed : Fixed (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
        (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride ht v1 p p0i tw fv :=
      output_fixed s a stride ht v1 i p p0i tw fv (fv (v1+i)) (fv (v1+ht+i)) fixed
    have bodyImage : Image (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
        (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride ht v1 tw p p0i fv (i+1) :=
      output_image s a stride ht v1 i p p0i tw fv fixed slot image
    have update : Exec NttInversePrograms192.vStep
        (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i)
        ⟨NttInverseMiddleBody192.next (NttInverseMiddleBody192.output s a stride (v1+i)
          (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i,.normal⟩ :=
      inc_run (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i
        ((out_local s a stride (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i
          "stride".toList).trans fixed.strideCell)
        fixed.strideBound
        ((out_local s a stride (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i
          "v".toList).trans vCell)
        iBound
        ((out_array s a stride (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i
          "r1".toList).trans r1Binding)
        ((out_array s a stride (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i
          "r2".toList).trans r2Binding)
        (step_capacity bodyFixed i slot).1 (step_capacity bodyFixed i slot).2
    set tail : State :=
      NttInverseMiddleBody192.next (NttInverseMiddleBody192.output s a stride (v1+i)
        (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i with tailEq
    have tailFixed : Fixed tail a stride ht v1 p p0i tw fv := by
      rw [tailEq]
      exact next_fixed (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
        (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride ht v1 i p p0i tw fv bodyFixed
    have tailCell : Cell tail "v".toList (i+1) := by
      rw [tailEq]
      exact FftLocalCells140.cell_at
        (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) "v".toList (word (i+1))
    have tailR1 : tail.arrays "r1".toList=some (walk a (v1+(i+1)) stride) := by
      rw [tailEq]
      rfl
    have tailR2 : tail.arrays "r2".toList=some (walk a (v1+ht+(i+1)) stride) := by
      rw [tailEq]
      rfl
    have tailImage : Image tail a stride ht v1 tw p p0i fv (i+1) := by
      rw [tailEq]
      intro j jBound
      have keep : (NttInverseMiddleBody192.next (NttInverseMiddleBody192.output s a stride
          (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i).heap=
          (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
            (fv (v1+i)) (fv (v1+ht+i)) tw p p0i).heap := rfl
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
        (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) tail ⟨after,.normal⟩
        (C99ScalarReference.boolean (decide (i < ht))) ?_ nonzero body update rest
      exact guard_run s a stride ht v1 i p p0i tw fv fixed iBound vCell
    · intro name different
      have first : tail.locals name=s.locals name := by
        rw [tailEq]
        exact (next_locals (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i
          name different).trans
          (out_local s a stride (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i
            name)
      exact (finalLocals name different).trans first
    · intro name first second
      have kept : tail.arrays name=s.arrays name := by
        rw [tailEq]
        exact (next_arrays (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i
          name first second).trans
          (out_array s a stride (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i
            name)
      exact (finalArrays name first second).trans kept

end FT1536.Source3.NttInverseMiddleVLoop192
