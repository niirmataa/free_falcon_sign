import Source3.NttInverseCorrection192
import Source3.StepProductFixed191

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The corrective Montgomery scaling loop of the accepted modp_iNTT3_ext
   corpus: all n iterations of `*r1 = modp_montymul(*r1, ni, p, p0i)`
   through the walked r1 pointer, with the executed image as Montgomery
   words over the input words. Values are only the executed word
   operations; no inverse or divisibility property is assumed. -/
namespace FT1536.Source3.NttInverseCorrectionLoop192
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open StepCopyBody190 (addr)

def scale (w ni p p0i : BitVec 32) : BitVec 32 := KeygenModpWord.montgomery w ni p p0i
def walk (a : ArrayPointer) (i stride : Nat) : ArrayPointer := addr a 0 i stride

def started (s : State) (a : ArrayPointer) (stride : Nat) : State :=
  bindPointer (C99ArrayReference.bindValue s "u".toList .uint64 (.uint64 (word 0)))
    "r1".toList (walk a 0 stride)

def output (s : State) (a : ArrayPointer) (stride i : Nat) (z : BitVec 32) : State :=
  {s with heap := Word32Memory176.write s.heap (walk a i stride) z}

def next (s : State) (a : ArrayPointer) (stride i : Nat) : State :=
  bindPointer (FftLocalCells140.put s "u".toList (word (i+1))) "r1".toList (walk a (i+1) stride)

def Image (s : State) (a : ArrayPointer) (stride n : Nat) (p p0i ni : BitVec 32)
    (fv : Nat → BitVec 32) (i : Nat) : Prop :=
  ∀ j : Nat, j < n → ((j < i → Load32 s.heap (walk a j stride) (scale (fv j) ni p p0i)) ∧
    (i ≤ j → Load32 s.heap (walk a j stride) (fv j)))

structure Fixed (s : State) (a : ArrayPointer) (stride n : Nat) (p p0i ni : BitVec 32)
    (fv : Nat → BitVec 32) : Prop where
  nBound : n < 2^64
  strideBound : stride < 2^64
  wideBound : n*stride < 2^64
  aWidth : a.elementBytes=4
  aCapacity : a.index+n*stride ≤ a.count
  aWritable : s.heap.writable a.block=true
  nCell : USlot s "n" n
  strideCell : USlot s "stride" stride
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  niCell : Slot s "ni" ni
  separate : ∀ j k : Nat, j < n → k < n → j ≠ k → Separate (walk a j stride) (walk a k stride)

theorem walk_index (a : ArrayPointer) (i stride : Nat) :
    (walk a i stride).index=a.index+i*stride := rfl
theorem walk_count (a : ArrayPointer) (i stride : Nat) : (walk a i stride).count=a.count := rfl
theorem walk_width (a : ArrayPointer) (i stride : Nat) :
    (walk a i stride).elementBytes=a.elementBytes := rfl

theorem walk_step (a : ArrayPointer) (stride i : Nat) :
    {walk a i stride with index := (walk a i stride).index+stride}=walk a (i+1) stride :=
  StepCopyBody190.addr_step a 0 stride i

theorem restore_empty (before after : State) :
    C99ArrayReference.restoreScope before after [] []=after := by
  have loc : (C99ArrayReference.restoreScope before after [] []).locals=after.locals := by
    funext name
    rfl
  have arr : (C99ArrayReference.restoreScope before after [] []).arrays=after.arrays := by
    funext name
    rfl
  exact StepProductBody191.state_ext rfl loc arr rfl rfl

theorem output_locals (s : State) (a : ArrayPointer) (stride i : Nat) (z : BitVec 32) (name : Name) :
    (output s a stride i z).locals name=s.locals name := rfl
theorem output_arrays (s : State) (a : ArrayPointer) (stride i : Nat) (z : BitVec 32) (name : Name) :
    (output s a stride i z).arrays name=s.arrays name := rfl

theorem output_fixed (s : State) (a : ArrayPointer) (stride n i : Nat) (p p0i ni : BitVec 32)
    (fv : Nat → BitVec 32) (z : BitVec 32) (fixed : Fixed s a stride n p p0i ni fv) :
    Fixed (output s a stride i z) a stride n p p0i ni fv where
  nBound := fixed.nBound
  strideBound := fixed.strideBound
  wideBound := fixed.wideBound
  aWidth := fixed.aWidth
  aCapacity := fixed.aCapacity
  aWritable := fixed.aWritable
  nCell := (output_locals s a stride i z "n".toList).trans fixed.nCell
  strideCell := (output_locals s a stride i z "stride".toList).trans fixed.strideCell
  pCell := (output_locals s a stride i z "p".toList).trans fixed.pCell
  iCell := (output_locals s a stride i z "p0i".toList).trans fixed.iCell
  niCell := (output_locals s a stride i z "ni".toList).trans fixed.niCell
  separate := fixed.separate

theorem next_fixed (s : State) (a : ArrayPointer) (stride n i : Nat) (p p0i ni : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride n p p0i ni fv) :
    Fixed (next s a stride i) a stride n p p0i ni fv where
  nBound := fixed.nBound
  strideBound := fixed.strideBound
  wideBound := fixed.wideBound
  aWidth := fixed.aWidth
  aCapacity := fixed.aCapacity
  aWritable := fixed.aWritable
  nCell := (FftLocalCells140.outside s "u".toList "n".toList (word (i+1)) (by decide)).trans fixed.nCell
  strideCell := (FftLocalCells140.outside s "u".toList "stride".toList (word (i+1)) (by decide)).trans
    fixed.strideCell
  pCell := (FftLocalCells140.outside s "u".toList "p".toList (word (i+1)) (by decide)).trans fixed.pCell
  iCell := (FftLocalCells140.outside s "u".toList "p0i".toList (word (i+1)) (by decide)).trans fixed.iCell
  niCell := (FftLocalCells140.outside s "u".toList "ni".toList (word (i+1)) (by decide)).trans fixed.niCell
  separate := fixed.separate

theorem output_image (s : State) (a : ArrayPointer) (stride n i : Nat) (p p0i ni : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride n p p0i ni fv) (slot : i < n)
    (image : Image s a stride n p p0i ni fv i) :
    Image (output s a stride i (scale (fv i) ni p p0i)) a stride n p p0i ni fv (i+1) := by
  intro j jBound
  have raw := (image j jBound).2
  have scaled := (image j jBound).1
  constructor
  · intro position
    by_cases same : j=i
    · subst same
      have allocatedJ : Allocated s.heap (walk a j stride) :=
        StepProductFixed191.load_allocated ((image j jBound).2 (Nat.le_refl j))
      have written : Load32 (Word32Memory176.write s.heap (walk a j stride)
          (scale (fv j) ni p p0i)) (walk a j stride) (scale (fv j) ni p p0i) :=
        Word32Memory176.here s.heap (walk a j stride) (scale (fv j) ni p p0i)
          allocatedJ ((walk_width a j stride).trans fixed.aWidth) fixed.aWritable
      rw [show (output s a stride j (scale (fv j) ni p p0i)).heap=
          Word32Memory176.write s.heap (walk a j stride) (scale (fv j) ni p p0i) from rfl]
      exact written
    · have lower : j < i := by omega
      have separateI : Separate (walk a i stride) (walk a j stride) :=
        fixed.separate i j slot jBound (fun equal => same equal.symm)
      exact Word32Memory176.outside s.heap (walk a i stride) (walk a j stride)
        (scale (fv i) ni p p0i) (scale (fv j) ni p p0i) separateI (scaled lower)
  · intro position
    have different : j ≠ i := by omega
    have separateI : Separate (walk a i stride) (walk a j stride) :=
      fixed.separate i j slot jBound (fun equal => different equal.symm)
    exact Word32Memory176.outside s.heap (walk a i stride) (walk a j stride)
      (scale (fv i) ni p p0i) (fv j) separateI (raw (by omega))

theorem next_locals (s : State) (a : ArrayPointer) (stride i : Nat) (name : Name)
    (different : name ≠ "u".toList) : (next s a stride i).locals name=s.locals name := by
  have first : (next s a stride i).locals name=
      (FftLocalCells140.put s "u".toList (word (i+1))).locals name := rfl
  rw [first]
  exact (FftLocalCells140.outside s "u".toList name (word (i+1)) different).trans rfl

theorem next_cell (s : State) (a : ArrayPointer) (stride i : Nat) (name : Name) (m : Nat)
    (different : name ≠ "u".toList) (cell : Cell s name m) : Cell (next s a stride i) name m :=
  (next_locals s a stride i name different).trans cell

theorem next_arrays (s : State) (a : ArrayPointer) (stride i : Nat) (name : Name)
    (different : name ≠ "r1".toList) : (next s a stride i).arrays name=s.arrays name := by
  have first : (next s a stride i).arrays name=
      (bindPointer (FftLocalCells140.put s "u".toList (word (i+1)))
        "r1".toList (walk a (i+1) stride)).arrays name := rfl
  rw [first]
  rw [StepProductFixed191.bindPointer_arrays
    (FftLocalCells140.put s "u".toList (word (i+1))) "r1".toList (walk a (i+1) stride) name different]
  rfl

theorem body_run (s : State) (a : ArrayPointer) (stride n i : Nat) (p p0i ni : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride n p p0i ni fv) (slot : i < n)
    (r1Binding : s.arrays "r1".toList=some (walk a i stride))
    (image : Image s a stride n p p0i ni fv i) :
    Exec NttInversePrograms192.cBody s ⟨output s a stride i (scale (fv i) ni p p0i),.normal⟩ := by
  have read : Load32 s.heap (walk a i stride) (fv i) := (image i slot).2 (Nat.le_refl i)
  have allocated : Allocated s.heap (walk a i stride) :=
    StepProductFixed191.load_allocated read
  have capacity : (walk a i stride).index ≤ (walk a i stride).count :=
    Nat.le_of_lt allocated.2.2.1
  have address : Pointer s "r1".toList NttInversePrograms192.zero (walk a i stride) :=
    StepCopyBody190.zero_pointer s "r1".toList (walk a i stride) r1Binding capacity
  have loadEval : C99ModularReference.Eval s
      (NttInversePrograms192.read "r1" NttInversePrograms192.zero) (.uint32 (fv i)) :=
    .load32 "r1".toList NttInversePrograms192.zero (walk a i stride) (fv i) address read
  have niEval : C99ModularReference.Eval s
      (NttInversePrograms192.scalar (NttInversePrograms192.var "ni")) (.uint32 ni) :=
    .scalar _ _ (.variable _ _ _ fixed.niCell)
  have valueRun : C99ModularReference.Eval s
      (NttInversePrograms192.call4 "modp_montymul"
        (NttInversePrograms192.read "r1" NttInversePrograms192.zero)
        (NttInversePrograms192.scalar (NttInversePrograms192.var "ni"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p0i")))
      (.uint32 (scale (fv i) ni p p0i)) :=
    ModularAtoms178.mont s
      (NttInversePrograms192.read "r1" NttInversePrograms192.zero)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "ni"))
      (fv i) ni p p0i loadEval niEval fixed.pCell fixed.iCell
  have stored : C99MemoryReference.Store32 s.heap (walk a i stride)
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 (scale (fv i) ni p p0i))))
      (Word32Memory176.write s.heap (walk a i stride) (scale (fv i) ni p p0i)) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq] using
      Word32Memory176.source s.heap (walk a i stride) (scale (fv i) ni p p0i)
        allocated ((walk_width a i stride).trans fixed.aWidth) fixed.aWritable
  have storeRun : C99ModularReference.Exec NttInversePrograms192.cScale s
      ⟨output s a stride i (scale (fv i) ni p p0i),.normal⟩ :=
    .store32 "r1".toList NttInversePrograms192.zero _
      s (Word32Memory176.write s.heap (walk a i stride) (scale (fv i) ni p p0i))
      (walk a i stride) (.uint32 (scale (fv i) ni p p0i)) address valueRun stored
  have inner : C99ModularReference.Exec (.seq NttInversePrograms192.cScale (.base .skip)) s
      ⟨output s a stride i (scale (fv i) ni p p0i),.normal⟩ :=
    .seqNormal _ _ s (output s a stride i (scale (fv i) ni p p0i)) _
      storeRun (.base _ _ _ (.skip _))
  exact .scope [] (.seq NttInversePrograms192.cScale (.base .skip)) s
    ⟨output s a stride i (scale (fv i) ni p p0i),.normal⟩ inner

theorem inc_run (s : State) (a : ArrayPointer) (stride n i : Nat) (p p0i ni : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride n p p0i ni fv) (slot : i < n)
    (uCell : Cell s "u".toList i) (r1Binding : s.arrays "r1".toList=some (walk a i stride)) :
    Exec NttInversePrograms192.cStep s ⟨next s a stride i,.normal⟩ := by
  have iBound : i < 2^64 := by have := fixed.nBound; omega
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (NttInversePrograms192.num 1)))
      s (FftLocalCells140.put s "u".toList (word (i+1))) := by
    cases C99LoopScalar141.increment (fun _ => none) s "u".toList i iBound uCell with
    | base _ _ _ source => exact source
  set mid : State := FftLocalCells140.put s "u".toList (word (i+1)) with midEq
  have r1After : mid.arrays "r1".toList=some (walk a i stride) := by
    rw [midEq]
    exact r1Binding
  have strideAfter : USlot mid "stride" stride := by
    rw [midEq]
    exact (FftLocalCells140.outside s "u".toList "stride".toList (word (i+1)) (by decide)).trans
      fixed.strideCell
  have walked : Pointer mid "r1".toList (NttInversePrograms192.var "stride")
      ({walk a i stride with index := (walk a i stride).index+stride}) := by
    refine .add _ _ (walk a i stride) _ (.uint64 (word stride)) r1After
      (.variable _ _ _ strideAfter) ?_ ?_
    · rw [C99NatWord141.integer stride fixed.strideBound]
      omega
    · rw [C99NatWord141.integer stride fixed.strideBound]
      refine .within (walk a i stride) stride ?_
      change a.index + i*stride + stride ≤ a.count
      exact StepProductFixed191.product_capacity_next a 0 stride n i fixed.aCapacity slot
  have walkedFinal : Pointer mid "r1".toList (NttInversePrograms192.var "stride")
      (walk a (i+1) stride) := by
    rw [← walk_step a stride i]
    exact walked
  have bind : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "r1".toList "r1".toList (NttInversePrograms192.var "stride")) mid
      (bindPointer mid "r1".toList (walk a (i+1) stride)) :=
    .bindPtr _ _ _ _ _ walkedFinal
  have first : C99ModularReference.Exec
      (.base (.scalar (.update "u".toList .add (NttInversePrograms192.num 1))))
      s ⟨mid,.normal⟩ := by
    rw [midEq]
    exact .base _ _ _ update
  have second : C99ModularReference.Exec
      (.base (.bindPtr "r1".toList "r1".toList (NttInversePrograms192.var "stride")))
      mid ⟨next s a stride i,.normal⟩ := by
    refine .base _ _ _ ?_
    rw [midEq]
    exact bind
  exact .seqNormal _ _ s mid _ first second

def scaleLoop : C99ModularReference.Stmt :=
  .loop NttInversePrograms192.cGuard NttInversePrograms192.cBody NttInversePrograms192.cStep

theorem guard_run (s : State) (a : ArrayPointer) (stride n i : Nat) (p p0i ni : BitVec 32)
    (fv : Nat → BitVec 32) (fixed : Fixed s a stride n p p0i ni fv) (iBound : i < 2^64)
    (uCell : Cell s "u".toList i) :
    C99ArrayReference.scalar s NttInversePrograms192.cGuard
      (C99ScalarReference.boolean (decide (i < n))) :=
  C99LoopScalar141.less s (NttInversePrograms192.var "u") (NttInversePrograms192.var "n")
    i n iBound fixed.nBound
    (C99LoopScalar141.read s "u".toList i uCell) (C99LoopScalar141.read s "n".toList n fixed.nCell)

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
      (∀ name : Name, name ≠ "r1".toList → after.arrays name=s.arrays name) := by
  induction count generalizing i s with
  | zero =>
    have equal : i=n := by omega
    subst i
    have false : C99ArrayReference.scalar s NttInversePrograms192.cGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        guard_run s a stride n n p p0i ni fv fixed fixed.nBound uCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,uCell,r1Binding,image,
      fun _ _ => rfl,fun _ _ => rfl⟩
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
    obtain ⟨after,rest,finalFixed,finalCell,finalX,finalImage,finalLocals,finalArrays⟩ :=
      ih (i+1) tail tailFixed tailCell tailX tailImage (by omega)
    refine ⟨after,?_,finalFixed,finalCell,finalX,finalImage,?_,?_⟩
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

end FT1536.Source3.NttInverseCorrectionLoop192
