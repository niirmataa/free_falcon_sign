import Source3.NttInverseFinalLoop192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One original intermediate-pass butterfly iteration of the accepted
   modp_iNTT3_ext corpus and its three-clause increment: the x/y block
   declarations, the two r1/r2 loads, the exact modp_add/modp_sub/
   modp_montymul words, the two stores and the v/r1/r2 updates. The
   walked positions stay generic (j for r1, k for r2); no transform
   property is assumed. -/
namespace FT1536.Source3.NttInverseMiddleBody192
open C99ArrayReference (State Name Pointer bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk walk_index walk_count walk_width walk_step)

def bb (x y p : BitVec 32) : BitVec 32 := KeygenModpAddSub.result .add x y p
def subA (x y p : BitVec 32) : BitVec 32 := KeygenModpAddSub.result .sub x y p
def high (x y tw p p0i : BitVec 32) : BitVec 32 := KeygenModpWord.montgomery (subA x y p) tw p p0i

def names : List Name := ["x".toList,"y".toList]

def declared (s : State) : State := C99DeclarationStatements.effect .u32 names s
def withX (s : State) (x : BitVec 32) : State := ModularAtoms178.set (declared s) "x" x
def withY (s : State) (x y : BitVec 32) : State := ModularAtoms178.set (withX s x) "y" y
def firstHeap (s : State) (a : ArrayPointer) (stride j : Nat) (x y p : BitVec 32) :
    C99MemoryReference.Memory :=
  Word32Memory176.write (withY s x y).heap (walk a j stride) (bb x y p)
def first (s : State) (a : ArrayPointer) (stride j : Nat) (x y p : BitVec 32) : State :=
  {withY s x y with heap := firstHeap s a stride j x y p}
def secondHeap (s : State) (a : ArrayPointer) (stride j k : Nat) (x y tw p p0i : BitVec 32) :
    C99MemoryReference.Memory :=
  Word32Memory176.write (firstHeap s a stride j x y p) (walk a k stride)
    (high x y tw p p0i)
def second (s : State) (a : ArrayPointer) (stride j k : Nat) (x y tw p p0i : BitVec 32) : State :=
  {first s a stride j x y p with heap := secondHeap s a stride j k x y tw p p0i}
def output (s : State) (a : ArrayPointer) (stride j k : Nat) (x y tw p p0i : BitVec 32) : State :=
  restoreScope s (second s a stride j k x y tw p p0i) names []

def next (s : State) (a : ArrayPointer) (stride j k i : Nat) : State :=
  bindPointer (bindPointer (FftLocalCells140.put s "v".toList (word (i+1)))
    "r1".toList (walk a (j+1) stride)) "r2".toList (walk a (k+1) stride)

theorem cells_outside (ty : C99IntegerReference.Ty) : ∀ (list : List Name)
    (env : C99ScalarReference.Env) (name : Name), name∉list →
    C99DeclarationCells.declareCells ty list env name=env name :=
  StepProductBody191.cells_outside ty

theorem declared_outside (s : State) (name : Name) (absent : name∉names) :
    (declared s).locals name=s.locals name :=
  cells_outside .uint32 names s.locals name absent

theorem set_outside (s : State) (target : String) (other : Name) (w : BitVec 32)
    (different : other≠target.toList) :
    (ModularAtoms178.set s target w).locals other=s.locals other :=
  StepProductBody191.put32_outside s target.toList w other different

theorem block_outside (name : Name) (first : name≠"x".toList) (second : name≠"y".toList) :
    name∉names := by
  intro hit
  simp only [names,List.mem_cons,List.not_mem_nil,or_false] at hit
  cases hit with
  | inl left => exact first left
  | inr rest => exact second rest

theorem block_absent (name : Name) (first : name≠"x".toList) (second : name≠"y".toList) :
    ¬ names.contains name=true :=
  fun hit => block_outside name first second (List.contains_iff_mem.mp hit)

theorem after_locals (s : State) (a : ArrayPointer) (stride j k : Nat) (x y tw p p0i : BitVec 32) :
    (output s a stride j k x y tw p p0i).locals=s.locals := by
  funext name
  by_cases h0 : name="x".toList
  · subst h0
    rfl
  · by_cases h1 : name="y".toList
    · subst h1
      rfl
    · show C99ScalarReference.restore s.locals (second s a stride j k x y tw p p0i).locals
        names name=s.locals name
      have kept : ¬ names.contains name=true := block_absent name h0 h1
      simp only [C99ScalarReference.restore,kept]
      exact ((set_outside _ "y" name y h1).trans
        ((set_outside _ "x" name x h0).trans
          (declared_outside s name (block_outside name h0 h1))))

theorem after_arrays (s : State) (a : ArrayPointer) (stride j k : Nat) (x y tw p p0i : BitVec 32) :
    (output s a stride j k x y tw p p0i).arrays=s.arrays := by
  funext name
  rfl

theorem body_state (s : State) (a : ArrayPointer) (stride j k : Nat) (x y tw p p0i : BitVec 32) :
    output s a stride j k x y tw p p0i=
      {second s a stride j k x y tw p p0i with locals := s.locals, arrays := s.arrays} :=
  StepProductBody191.state_ext rfl (after_locals s a stride j k x y tw p p0i)
    (after_arrays s a stride j k x y tw p p0i) rfl rfl

theorem x_fresh (s : State) : (declared s).locals "x".toList=some (.uint32,none) := rfl
theorem y_fresh (s : State) (x : BitVec 32) : (withX s x).locals "y".toList=some (.uint32,none) := rfl

theorem set_keep (s : State) (target : String) (w : BitVec 32) (name : String) (v : BitVec 32)
    (different : name.toList≠target.toList) (base : Slot s name v) :
    Slot (ModularAtoms178.set s target w) name v :=
  (ModularAtoms178.outside s target name w different).trans base

theorem declared_keep (s : State) (name : String) (v : BitVec 32) (base : Slot s name v)
    (absent : name.toList∉names) : Slot (declared s) name v :=
  (declared_outside s name.toList absent).trans base

theorem x_slot (s : State) (x : BitVec 32) : Slot (withX s x) "x" x :=
  ModularAtoms178.slot (declared s) "x" x

theorem body_run (s : State) (a : ArrayPointer) (stride j k : Nat) (p p0i tw : BitVec 32)
    (x y : BitVec 32) (pCell : Slot s "p" p) (iCell : Slot s "p0i" p0i) (sCell : Slot s "s" tw)
    (r1Binding : s.arrays "r1".toList=some (walk a j stride))
    (r2Binding : s.arrays "r2".toList=some (walk a k stride))
    (r1Read : Load32 s.heap (walk a j stride) x) (r2Read : Load32 s.heap (walk a k stride) y)
    (aWidth : a.elementBytes=4) (aWritable : s.heap.writable a.block=true) :
    Exec NttInversePrograms192.vBody s ⟨output s a stride j k x y tw p p0i,.normal⟩ := by
  have r1Alloc : Allocated s.heap (walk a j stride) :=
    StepProductFixed191.load_allocated r1Read
  have r2Alloc : Allocated s.heap (walk a k stride) :=
    StepProductFixed191.load_allocated r2Read
  have r1Cap : (walk a j stride).index≤(walk a j stride).count := Nat.le_of_lt r1Alloc.2.2.1
  have r2Cap : (walk a k stride).index≤(walk a k stride).count := Nat.le_of_lt r2Alloc.2.2.1
  have declareRun : Exec (NttInversePrograms192.declareU32 ["x","y"]) s
      ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 names s)
  have xAddress : Pointer (declared s) "r1".toList NttInversePrograms192.zero
      (walk a j stride) :=
    StepCopyBody190.zero_pointer (declared s) "r1".toList (walk a j stride) r1Binding r1Cap
  have xRun : Exec NttInversePrograms192.xRead (declared s) ⟨withX s x,.normal⟩ :=
    ModularAtoms178.assign (declared s) "x" none
      (NttInversePrograms192.read "r1" NttInversePrograms192.zero) x (x_fresh s)
      (.load32 "r1".toList NttInversePrograms192.zero (walk a j stride) x xAddress r1Read)
  have yAddress : Pointer (withX s x) "r2".toList NttInversePrograms192.zero
      (walk a k stride) :=
    StepCopyBody190.zero_pointer (withX s x) "r2".toList (walk a k stride) r2Binding r2Cap
  have yRun : Exec NttInversePrograms192.yRead (withX s x) ⟨withY s x y,.normal⟩ :=
    ModularAtoms178.assign (withX s x) "y" none
      (NttInversePrograms192.read "r2" NttInversePrograms192.zero) y (y_fresh s x)
      (.load32 "r2".toList NttInversePrograms192.zero (walk a k stride) y yAddress r2Read)
  have lowEval : C99ModularReference.Eval (withY s x y)
      (NttInversePrograms192.call3 "modp_add"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "x"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "y"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
      (.uint32 (bb x y p)) :=
    ModularWordOps182.add (withY s x y) _ _ x y p
      (ModularAtoms178.cell (withY s x y) "x" x
        (set_keep (withX s x) "y" y "x" x (by decide) (x_slot s x)))
      (ModularAtoms178.cell (withY s x y) "y" y
        (ModularAtoms178.slot (withX s x) "y" y))
      (set_keep (withX s x) "y" y "p" p (by decide)
        (declared_keep s "p" p pCell (by decide)))
  have lowAddress : Pointer (withY s x y) "r1".toList NttInversePrograms192.zero
      (walk a j stride) :=
    StepCopyBody190.zero_pointer (withY s x y) "r1".toList (walk a j stride) r1Binding r1Cap
  have lowStored : C99MemoryReference.Store32 (withY s x y).heap (walk a j stride)
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 (bb x y p))))
      (Word32Memory176.write (withY s x y).heap (walk a j stride) (bb x y p)) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq] using
      Word32Memory176.source (withY s x y).heap (walk a j stride) (bb x y p) r1Alloc
        ((walk_width a j stride).trans aWidth) aWritable
  have lowRun : Exec NttInversePrograms192.vWriteLow (withY s x y)
      ⟨first s a stride j x y p,.normal⟩ :=
    .store32 "r1".toList NttInversePrograms192.zero _
      (withY s x y)
      (Word32Memory176.write (withY s x y).heap (walk a j stride) (bb x y p))
      (walk a j stride) (.uint32 (bb x y p)) lowAddress lowEval lowStored
  have subEval : C99ModularReference.Eval (first s a stride j x y p)
      (NttInversePrograms192.call3 "modp_sub"
        (NttInversePrograms192.scalar (NttInversePrograms192.var "x"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "y"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
      (.uint32 (subA x y p)) :=
    ModularWordOps182.sub (first s a stride j x y p) _ _ x y p
      (ModularAtoms178.cell (first s a stride j x y p) "x" x
        (by
          show Slot (withY s x y) "x" x
          exact set_keep (withX s x) "y" y "x" x (by decide) (x_slot s x)))
      (ModularAtoms178.cell (first s a stride j x y p) "y" y
        (by
          show Slot (withY s x y) "y" y
          exact ModularAtoms178.slot (withX s x) "y" y))
      (set_keep (withX s x) "y" y "p" p (by decide)
        (declared_keep s "p" p pCell (by decide)))
  have twEval : C99ModularReference.Eval (first s a stride j x y p)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "s")) (.uint32 tw) :=
    .scalar _ _ (.variable _ _ _
      (set_keep (withX s x) "y" y "s" tw (by decide)
        (set_keep (declared s) "x" x "s" tw (by decide)
          (declared_keep s "s" tw sCell (by decide)))))
  have highEval : C99ModularReference.Eval (first s a stride j x y p)
      (NttInversePrograms192.call4 "modp_montymul"
        (NttInversePrograms192.call3 "modp_sub"
          (NttInversePrograms192.scalar (NttInversePrograms192.var "x"))
          (NttInversePrograms192.scalar (NttInversePrograms192.var "y"))
          (NttInversePrograms192.scalar (NttInversePrograms192.var "p")))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "s"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p"))
        (NttInversePrograms192.scalar (NttInversePrograms192.var "p0i")))
      (.uint32 (high x y tw p p0i)) :=
    ModularAtoms178.mont (first s a stride j x y p) _ _
      (subA x y p) tw p p0i subEval twEval
      (set_keep (withX s x) "y" y "p" p (by decide)
        (declared_keep s "p" p pCell (by decide)))
      (set_keep (withX s x) "y" y "p0i" p0i (by decide)
        (declared_keep s "p0i" p0i iCell (by decide)))
  have highAddress : Pointer (first s a stride j x y p) "r2".toList
      NttInversePrograms192.zero (walk a k stride) :=
    StepCopyBody190.zero_pointer (first s a stride j x y p) "r2".toList
      (walk a k stride) r2Binding r2Cap
  have highStored : C99MemoryReference.Store32 (first s a stride j x y p).heap
      (walk a k stride)
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 (high x y tw p p0i))))
      (Word32Memory176.write (first s a stride j x y p).heap (walk a k stride)
        (high x y tw p p0i)) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq] using
      Word32Memory176.source (first s a stride j x y p).heap (walk a k stride)
        (high x y tw p p0i) r2Alloc ((walk_width a k stride).trans aWidth) aWritable
  have highRun : Exec NttInversePrograms192.vWriteHigh (first s a stride j x y p)
      ⟨second s a stride j k x y tw p p0i,.normal⟩ :=
    .store32 "r2".toList NttInversePrograms192.zero _
      (first s a stride j x y p)
      (Word32Memory176.write (first s a stride j x y p).heap (walk a k stride)
        (high x y tw p p0i))
      (walk a k stride) (.uint32 (high x y tw p p0i)) highAddress highEval highStored
  have tail : Exec (.seq NttInversePrograms192.vWriteHigh (.base .skip))
      (first s a stride j x y p) ⟨second s a stride j k x y tw p p0i,.normal⟩ :=
    .seqNormal _ _ (first s a stride j x y p)
      (second s a stride j k x y tw p p0i) ⟨second s a stride j k x y tw p p0i,.normal⟩
      highRun (.base _ _ _ (.skip _))
  have lowBoth : Exec (.seq NttInversePrograms192.vWriteLow
      (.seq NttInversePrograms192.vWriteHigh (.base .skip)))
      (withY s x y) ⟨second s a stride j k x y tw p p0i,.normal⟩ :=
    .seqNormal _ _ (withY s x y) (first s a stride j x y p)
      ⟨second s a stride j k x y tw p p0i,.normal⟩ lowRun tail
  have yBoth : Exec (.seq NttInversePrograms192.yRead
      (.seq NttInversePrograms192.vWriteLow
        (.seq NttInversePrograms192.vWriteHigh (.base .skip))))
      (withX s x) ⟨second s a stride j k x y tw p p0i,.normal⟩ :=
    .seqNormal _ _ (withX s x) (withY s x y)
      ⟨second s a stride j k x y tw p p0i,.normal⟩ yRun lowBoth
  have xBoth : Exec (.seq NttInversePrograms192.xRead
      (.seq NttInversePrograms192.yRead
        (.seq NttInversePrograms192.vWriteLow
          (.seq NttInversePrograms192.vWriteHigh (.base .skip)))))
      (declared s) ⟨second s a stride j k x y tw p p0i,.normal⟩ :=
    .seqNormal _ _ (declared s) (withX s x)
      ⟨second s a stride j k x y tw p p0i,.normal⟩ xRun yBoth
  have inner : Exec (.seq (NttInversePrograms192.declareU32 ["x","y"])
      (.seq NttInversePrograms192.xRead
        (.seq NttInversePrograms192.yRead
          (.seq NttInversePrograms192.vWriteLow
            (.seq NttInversePrograms192.vWriteHigh (.base .skip))))))
      s ⟨second s a stride j k x y tw p p0i,.normal⟩ :=
    .seqNormal _ _ s (declared s) ⟨second s a stride j k x y tw p p0i,.normal⟩
      declareRun xBoth
  exact .scope names (.seq (NttInversePrograms192.declareU32 ["x","y"])
    (.seq NttInversePrograms192.xRead
      (.seq NttInversePrograms192.yRead
        (.seq NttInversePrograms192.vWriteLow
          (.seq NttInversePrograms192.vWriteHigh (.base .skip))))))
    s ⟨second s a stride j k x y tw p p0i,.normal⟩ inner

theorem inc_run (s : State) (a : ArrayPointer) (stride j k i : Nat)
    (strideCell : USlot s "stride" stride) (strideBound : stride<2^64)
    (vCell : Cell s "v".toList i) (iBound : i<2^64)
    (r1Binding : s.arrays "r1".toList=some (walk a j stride))
    (r2Binding : s.arrays "r2".toList=some (walk a k stride))
    (r1Capacity : (walk a j stride).index+stride≤(walk a j stride).count)
    (r2Capacity : (walk a k stride).index+stride≤(walk a k stride).count) :
    Exec NttInversePrograms192.vStep s ⟨next s a stride j k i,.normal⟩ := by
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "v".toList .add (NttInversePrograms192.num 1)))
      s (FftLocalCells140.put s "v".toList (word (i+1))) := by
    cases C99LoopScalar141.increment (fun _ => none) s "v".toList i iBound vCell with
    | base _ _ _ source => exact source
  set mid : State := FftLocalCells140.put s "v".toList (word (i+1)) with midEq
  have r1After : mid.arrays "r1".toList=some (walk a j stride) := by
    rw [midEq]
    exact r1Binding
  have r2After : mid.arrays "r2".toList=some (walk a k stride) := by
    rw [midEq]
    exact r2Binding
  have strideAfter : USlot mid "stride" stride := by
    rw [midEq]
    exact (FftLocalCells140.outside s "v".toList "stride".toList (word (i+1)) (by decide)).trans
      strideCell
  have walked : Pointer mid "r1".toList (NttInversePrograms192.var "stride")
      ({walk a j stride with index := (walk a j stride).index+stride}) := by
    refine .add _ _ (walk a j stride) _ (.uint64 (word stride)) r1After
      (.variable _ _ _ strideAfter) ?_ ?_
    · rw [C99NatWord141.integer stride strideBound]
      omega
    · rw [C99NatWord141.integer stride strideBound]
      exact .within (walk a j stride) stride r1Capacity
  have walkedFinal : Pointer mid "r1".toList (NttInversePrograms192.var "stride")
      (walk a (j+1) stride) := by
    rw [← walk_step a stride j]
    exact walked
  have bind1 : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "r1".toList "r1".toList (NttInversePrograms192.var "stride")) mid
      (bindPointer mid "r1".toList (walk a (j+1) stride)) :=
    .bindPtr _ _ _ _ _ walkedFinal
  have r2FinalBinding :
      (bindPointer mid "r1".toList (walk a (j+1) stride)).arrays "r2".toList
        =some (walk a k stride) := by
    rw [StepProductFixed191.bindPointer_arrays mid "r1".toList (walk a (j+1) stride)
      "r2".toList (by decide)]
    exact r2After
  have strideFinal : USlot (bindPointer mid "r1".toList (walk a (j+1) stride))
      "stride" stride := strideAfter
  have walked2 : Pointer (bindPointer mid "r1".toList (walk a (j+1) stride)) "r2".toList
      (NttInversePrograms192.var "stride")
      ({walk a k stride with index := (walk a k stride).index+stride}) := by
    refine .add _ _ (walk a k stride) _ (.uint64 (word stride)) r2FinalBinding
      (.variable _ _ _ strideFinal) ?_ ?_
    · rw [C99NatWord141.integer stride strideBound]
      omega
    · rw [C99NatWord141.integer stride strideBound]
      exact .within (walk a k stride) stride r2Capacity
  have walked2Final : Pointer (bindPointer mid "r1".toList (walk a (j+1) stride)) "r2".toList
      (NttInversePrograms192.var "stride") (walk a (k+1) stride) := by
    rw [← walk_step a stride k]
    exact walked2
  have bind2 : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "r2".toList "r2".toList (NttInversePrograms192.var "stride"))
      (bindPointer mid "r1".toList (walk a (j+1) stride))
      (bindPointer (bindPointer mid "r1".toList (walk a (j+1) stride)) "r2".toList
        (walk a (k+1) stride)) :=
    .bindPtr _ _ _ _ _ walked2Final
  have r1Step : C99ModularReference.Exec
      (.base (.bindPtr "r1".toList "r1".toList (NttInversePrograms192.var "stride")))
      mid ⟨bindPointer mid "r1".toList (walk a (j+1) stride),.normal⟩ := by
    exact .base _ _ _ bind1
  have r2Step : C99ModularReference.Exec
      (.base (.bindPtr "r2".toList "r2".toList (NttInversePrograms192.var "stride")))
      (bindPointer mid "r1".toList (walk a (j+1) stride))
      ⟨next s a stride j k i,.normal⟩ := by
    refine .base _ _ _ ?_
    rw [midEq]
    exact bind2
  have pair : C99ModularReference.Exec NttInversePrograms192.pairStep mid
      ⟨next s a stride j k i,.normal⟩ :=
    .seqNormal _ _ mid (bindPointer mid "r1".toList (walk a (j+1) stride))
      ⟨next s a stride j k i,.normal⟩ r1Step r2Step
  have head : C99ModularReference.Exec
      (.base (.scalar (.update "v".toList .add (NttInversePrograms192.num 1))))
      s ⟨mid,.normal⟩ := by
    rw [midEq]
    exact .base _ _ _ update
  exact .seqNormal _ _ s mid ⟨next s a stride j k i,.normal⟩ head pair

end FT1536.Source3.NttInverseMiddleBody192
