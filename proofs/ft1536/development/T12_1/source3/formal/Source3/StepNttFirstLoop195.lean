import Source3.StepNttPrologue195
import Source3.StepNttEntry195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The first-pass loop composition of the pinned modp_NTT3_ext forward
   body at the selected call words (logn = 9 / full = 0, n = 512,
   hn = 256): the per-iteration run (one StepNttBody195.block_run
   instance at the walked pair (a[u], a[hn+u]) plus the pinned u/r1/r2
   increment), next_image/next_fixed, the remaining induction, the
   whole firstInit + hn-step run (first_run) and the export at the
   StepNttEntry195 entry frame (entry_run, the prologue + w = gm[1] +
   firstInit + loop prefix of forwardBody, with the continuation hook
   prefix_continue along the pinned parse map). The parse map, the
   per-cell keeps and the step engine of the previous window are
   consumed, not re-derived.

   DEFECT NOTE (recorded, do not re-derive): StepNttFirst195.bodyHeap
   composes StepNttBody195.highHeap at the OUTPUT words
   lowWordAt/highWordAt, where highHeap expects the butterfly INPUT
   words; its written cells are therefore `lowWord (lowWordAt) …` /
   `highWord (lowWordAt) …` instead of the executed words
   lowWordAt/highWordAt, and the executed image does NOT hold at
   StepNttFirst195.stepState. The execution-derived equation
   StepNttBody195.body_state (bodyOut at the input words) is correct
   and is the iteration state used here (bodyAt/stepAt below, defeq to
   bodyOut and its increment closure). The job-570 bytes are untouched;
   its keeps (step_*) were heap-independent and remain valid facts
   about its own stepState. Values stay executed words: no transform
   property, table law, root law or positivity claim is made here. -/
namespace FT1536.Source3.StepNttFirstLoop195
open C99ModularReference (Stmt Exec Eval)
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer PointerAdd Allocated Load32 Memory)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)

/-! ## Read facts -/

theorem load_allocated {h : Memory} {p : ArrayPointer} {w : BitVec 32} (read : Load32 h p w) :
    Allocated h p := by
  cases read with | load b alloc width bytes => exact alloc

theorem load_width {h : Memory} {p : ArrayPointer} {w : BitVec 32} (read : Load32 h p w) :
    p.elementBytes=4 := by
  cases read with | load b alloc width bytes => exact width

/-! ## The corrected iteration states (execution-derived)

The two input words of the walked pair are precomputed in top-level defs
(trap wall: `⟨x, by omega⟩` inside a `{src with …}` record value breaks
the structure-instance parser). -/

def fvLo (hn : Nat) (fv : Fin (2*hn) → BitVec 32) (v : Nat) (bound : v < hn) : BitVec 32 :=
  fv ⟨v,by omega⟩
def fvHi (hn : Nat) (fv : Fin (2*hn) → BitVec 32) (v : Nat) (bound : v < hn) : BitVec 32 :=
  fv ⟨hn+v,by omega⟩

def bodyHeapAt (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) : Memory :=
  StepNttBody195.highHeap s (elem a v) (elem a (hn+v)) (fvLo hn fv v bound) (fvHi hn fv v bound)
    w pw p0i

def bodyAt (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) : State :=
  {s with heap := bodyHeapAt s a hn v fv bound w pw p0i}

def stepAt (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) : State :=
  bindPointer (bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
    "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)))
    "r2".toList (elem a (hn+v+1))

theorem bodyAt_locals (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (bodyAt s a hn v fv bound w pw p0i).locals = s.locals := rfl

theorem bodyAt_arrays (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (bodyAt s a hn v fv bound w pw p0i).arrays = s.arrays := rfl

theorem bodyAt_writes (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (bodyAt s a hn v fv bound w pw p0i).heap =
      Word32Memory176.write
        (Word32Memory176.write s.heap (elem a v)
          (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i))
        (elem a (hn+v))
        (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i) := rfl

/- The loop guard of the first pass (firstGuard verbatim). -/
theorem guard (s : State) (v hn : Nat) (vBound : v<2^64) (hnBound : hn<2^64)
    (counter : Cell s "u".toList v) (limit : Cell s "hn".toList hn) :
    C99ArrayReference.scalar s StepNttBody195.firstGuard
      (C99ScalarReference.boolean (decide (v<hn))) :=
  C99LoopScalar141.less s (KeygenNttForwardPrograms.var "u")
    (KeygenNttForwardPrograms.var "hn") v hn vBound hnBound
    (C99LoopScalar141.read s "u".toList v counter) (C99LoopScalar141.read s "hn".toList hn limit)

theorem stepAt_u (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    Cell (stepAt s a hn v fv bound w pw p0i) "u".toList (v+1) :=
  FftLocalCells140.cell_at (bodyAt s a hn v fv bound w pw p0i) "u".toList
    (C99NatWord141.word (v+1))

theorem stepAt_locals (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) (name : Name) (different : name≠"u".toList) :
    (stepAt s a hn v fv bound w pw p0i).locals name = s.locals name := by
  show (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i) "u".toList
    (C99NatWord141.word (v+1))).locals name = _
  rw [FftLocalCells140.outside (bodyAt s a hn v fv bound w pw p0i) "u".toList name
    (C99NatWord141.word (v+1)) different, bodyAt_locals s a hn v fv bound w pw p0i]

theorem stepAt_arrays (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) (name : Name)
    (first : name≠"r1".toList) (second : name≠"r2".toList) :
    (stepAt s a hn v fv bound w pw p0i).arrays name = s.arrays name := by
  show (bindPointer (bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
    "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)))
    "r2".toList (elem a (hn+v+1))).arrays name = _
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ second]
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ first]
  rfl

theorem stepAt_r1 (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (stepAt s a hn v fv bound w pw p0i).arrays "r1".toList = some (elem a (v+1)) := by
  show (bindPointer (bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
    "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)))
    "r2".toList (elem a (hn+v+1))).arrays "r1".toList = _
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ (by decide)]
  rfl

theorem stepAt_r2 (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (stepAt s a hn v fv bound w pw p0i).arrays "r2".toList = some (elem a (hn+v+1)) := rfl

theorem stepAt_heap (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (stepAt s a hn v fv bound w pw p0i).heap = (bodyAt s a hn v fv bound w pw p0i).heap := rfl

/-! ## One iteration: the butterfly block and the u/r1/r2 increment -/

theorem body_run (s : State) (a gm : ArrayPointer) (hn gmn : Nat) (fv : Fin (2*hn) → BitVec 32)
    (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32) (v : Nat) (bound : v<hn)
    (fixed : StepNttFirst195.Fixed s a gm hn gmn fv gvs w pw p0i)
    (r1Binding : s.arrays "r1".toList=some (elem a v))
    (r2Binding : s.arrays "r2".toList=some (elem a (hn+v)))
    (copied : StepNttFirst195.Image s a fv w pw p0i v) :
    Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) s
      ⟨bodyAt s a hn v fv bound w pw p0i,.normal⟩ := by
  have reads := copied.2 ⟨v,bound⟩ (Nat.le_refl v)
  have low := reads.1
  have high := reads.2
  have p1Alloc := load_allocated low
  have p2Alloc := load_allocated high
  have p1Width := load_width low
  have p2Width := load_width high
  have p1Writable : s.heap.writable (elem a v).block = true := fixed.aWritable
  have p2Writable : s.heap.writable (elem a (hn+v)).block = true := fixed.aWritable
  have run : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) s
      ⟨StepNttBody195.bodyOut s (elem a v) (elem a (hn+v)) (fvLo hn fv v bound)
        (fvHi hn fv v bound) w pw p0i,.normal⟩ :=
    StepNttBody195.block_run s (elem a v) (elem a (hn+v)) (fvLo hn fv v bound)
      (fvHi hn fv v bound) w pw p0i fixed.wSlot fixed.pSlot fixed.p0iSlot r1Binding r2Binding
      low high p1Alloc p1Width p1Writable p2Alloc p2Width p2Writable
  have key := StepNttBody195.body_state s (elem a v) (elem a (hn+v)) (fvLo hn fv v bound)
    (fvHi hn fv v bound) w pw p0i fixed.wSlot fixed.pSlot fixed.p0iSlot r1Binding r2Binding
    low high p1Alloc p1Width p1Writable p2Alloc p2Width p2Writable
  rw [key] at run
  exact run

theorem increment_run (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v<hn) (w pw p0i : BitVec 32) (hnBound : hn<2^64)
    (counter : Cell s "u".toList v) (strideCell : Cell s "stride".toList 1)
    (aCapacity : a.index+2*hn≤a.count)
    (r1Binding : s.arrays "r1".toList=some (elem a v))
    (r2Binding : s.arrays "r2".toList=some (elem a (hn+v))) :
    Exec StepNttBody195.stepU (bodyAt s a hn v fv bound w pw p0i)
      ⟨stepAt s a hn v fv bound w pw p0i,.normal⟩ := by
  have counter' : Cell (bodyAt s a hn v fv bound w pw p0i) "u".toList v := counter
  have stride' : Cell (bodyAt s a hn v fv bound w pw p0i) "stride".toList 1 := strideCell
  have r1' : (bodyAt s a hn v fv bound w pw p0i).arrays "r1".toList=some (elem a v) := r1Binding
  have r2' : (bodyAt s a hn v fv bound w pw p0i).arrays "r2".toList=some (elem a (hn+v)) :=
    r2Binding
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (KeygenNttForwardPrograms.num 1)))
      (bodyAt s a hn v fv bound w pw p0i)
      (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i) "u".toList
        (C99NatWord141.word (v+1))) := by
    cases C99LoopScalar141.increment (fun _ => none) (bodyAt s a hn v fv bound w pw p0i)
      "u".toList v (by have h := hnBound; omega) counter' with
    | base _ _ _ source => exact source
  have first : Exec (.base (.scalar (.update "u".toList .add (KeygenNttForwardPrograms.num 1))))
      (bodyAt s a hn v fv bound w pw p0i)
      ⟨FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i) "u".toList
        (C99NatWord141.word (v+1)),.normal⟩ := .base _ _ _ update
  have mid1Stride : Cell (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i) "u".toList
      (C99NatWord141.word (v+1))) "stride".toList 1 :=
    (FftLocalCells140.outside (bodyAt s a hn v fv bound w pw p0i) "u".toList "stride".toList
      (C99NatWord141.word (v+1)) (by decide)).trans stride'
  have mid1R1 : (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i) "u".toList
      (C99NatWord141.word (v+1))).arrays "r1".toList=some (elem a v) := r1'
  have step1 : (elem a v).index+1≤(elem a v).count := by
    change a.index+v+1≤a.count
    omega
  have r1Pointer : Pointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
      "u".toList (C99NatWord141.word (v+1))) "r1".toList
      (KeygenNttForwardPrograms.var "stride") (elem a (v+1)) := by
    refine Pointer.add "r1".toList (KeygenNttForwardPrograms.var "stride") (elem a v)
      (elem a (v+1)) (.uint64 (C99NatWord141.word 1)) mid1R1
      (C99LoopScalar141.read _ "stride".toList 1 mid1Stride) ?_ ?_
    · decide
    · have toNat : ((C99IntegerReference.Value.uint64 (C99NatWord141.word 1)).integer).toNat=1 := by
        decide
      rw [toNat]
      rw [← StepNttFirst195.elem_step a v]
      exact PointerAdd.within (elem a v) 1 step1
  have second : Exec (.base (.bindPtr "r1".toList "r1".toList
      (KeygenNttForwardPrograms.var "stride")))
      (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i) "u".toList
        (C99NatWord141.word (v+1)))
      ⟨bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i) "u".toList
        (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)),.normal⟩ :=
    .base _ _ _ (.bindPtr _ "r1".toList "r1".toList (KeygenNttForwardPrograms.var "stride")
      (elem a (v+1)) r1Pointer)
  have mid2Stride : Cell (bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
      "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1))) "stride".toList 1 :=
    mid1Stride
  have mid2R2 : (bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
      "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1))).arrays "r2".toList=
      some (elem a (hn+v)) :=
    (StepCopyFixed190.bindPointer_arrays (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
      "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)) "r2".toList
      (by decide)).trans r2'
  have step2 : (elem a (hn+v)).index+1≤(elem a (hn+v)).count := by
    change a.index+(hn+v)+1≤a.count
    omega
  have r2Pointer : Pointer (bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
      "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1))) "r2".toList
      (KeygenNttForwardPrograms.var "stride") (elem a (hn+v+1)) := by
    refine Pointer.add "r2".toList (KeygenNttForwardPrograms.var "stride") (elem a (hn+v))
      (elem a (hn+v+1)) (.uint64 (C99NatWord141.word 1)) mid2R2
      (C99LoopScalar141.read _ "stride".toList 1 mid2Stride) ?_ ?_
    · decide
    · have toNat : ((C99IntegerReference.Value.uint64 (C99NatWord141.word 1)).integer).toNat=1 := by
        decide
      rw [toNat]
      rw [← StepNttFirst195.elem_step a (hn+v)]
      exact PointerAdd.within (elem a (hn+v)) 1 step2
  have third : Exec (.base (.bindPtr "r2".toList "r2".toList
      (KeygenNttForwardPrograms.var "stride")))
      (bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i) "u".toList
        (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)))
      ⟨bindPointer (bindPointer (FftLocalCells140.put (bodyAt s a hn v fv bound w pw p0i)
        "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)))
        "r2".toList (elem a (hn+v+1)),.normal⟩ :=
    .base _ _ _ (.bindPtr _ "r2".toList "r2".toList (KeygenNttForwardPrograms.var "stride")
      (elem a (hn+v+1)) r2Pointer)
  exact .seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second third)

theorem iteration_run (s : State) (a gm : ArrayPointer) (hn gmn : Nat)
    (fv : Fin (2*hn) → BitVec 32) (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32) (v : Nat)
    (bound : v<hn) (fixed : StepNttFirst195.Fixed s a gm hn gmn fv gvs w pw p0i)
    (counter : Cell s "u".toList v) (r1Binding : s.arrays "r1".toList=some (elem a v))
    (r2Binding : s.arrays "r2".toList=some (elem a (hn+v)))
    (copied : StepNttFirst195.Image s a fv w pw p0i v) :
    Exec (.seq (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody)
      StepNttBody195.stepU) s ⟨stepAt s a hn v fv bound w pw p0i,.normal⟩ :=
  .seqNormal _ _ _ _ _ (body_run s a gm hn gmn fv gvs w pw p0i v bound fixed r1Binding r2Binding
    copied)
    (increment_run s a hn v fv bound w pw p0i fixed.hnBound counter fixed.strideCell
      fixed.aCapacity r1Binding r2Binding)

/-! ## Two-write keeps at the butterfly cells -/

theorem two_write_keep (h : Memory) (p q r : ArrayPointer) (wp wq old : BitVec 32)
    (sepP : Separate q p) (sepQ : Separate q r) (read : Load32 h q old) :
    Load32 (Word32Memory176.write (Word32Memory176.write h p wp) r wq) q old :=
  Word32Memory176.outside _ r q wq old (StepCopyFixed190.separate_symm sepQ)
    (Word32Memory176.outside h p q wp old (StepCopyFixed190.separate_symm sepP) read)

theorem two_write_here_left (h : Memory) (p r : ArrayPointer) (wp wq : BitVec 32)
    (alloc : Allocated h p) (width : p.elementBytes=4) (writable : h.writable p.block=true)
    (sep : Separate p r) :
    Load32 (Word32Memory176.write (Word32Memory176.write h p wp) r wq) p wp :=
  Word32Memory176.outside _ r p wq wp (StepCopyFixed190.separate_symm sep)
    (Word32Memory176.here h p wp alloc width writable)

theorem two_write_here_right (h : Memory) (p r : ArrayPointer) (wp wq : BitVec 32)
    (alloc : Allocated h r) (width : r.elementBytes=4) (writable : h.writable r.block=true) :
    Load32 (Word32Memory176.write (Word32Memory176.write h p wp) r wq) r wq :=
  Word32Memory176.here _ r wq (StepNttBody195.write_allocated h p r wp alloc) width
    (StepNttBody195.write_writable h p r wp writable)

/-! ## The step image and the step invariant -/

theorem next_image (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v<hn) (w pw p0i : BitVec 32) (aWidth : a.elementBytes=4)
    (aWritable : s.heap.writable a.block=true)
    (copied : StepNttFirst195.Image s a fv w pw p0i v) :
    StepNttFirst195.Image (stepAt s a hn v fv bound w pw p0i) a fv w pw p0i (v+1) := by
  have heap : (stepAt s a hn v fv bound w pw p0i).heap =
      Word32Memory176.write
        (Word32Memory176.write s.heap (elem a v)
          (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i))
        (elem a (hn+v))
        (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i) := rfl
  have lowRead : Load32 s.heap (elem a v) (fvLo hn fv v bound) :=
    (copied.2 ⟨v,bound⟩ (Nat.le_refl v)).1
  have highRead : Load32 s.heap (elem a (hn+v)) (fvHi hn fv v bound) :=
    (copied.2 ⟨v,bound⟩ (Nat.le_refl v)).2
  refine ⟨?_,?_⟩
  · intro j done
    by_cases same : j.val=v
    · have key : j=⟨v,bound⟩ := Fin.ext same
      subst key
      rw [heap]
      constructor
      · exact two_write_here_left s.heap (elem a v) (elem a (hn+v))
          (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
          (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
          (load_allocated lowRead) (load_width lowRead) aWritable
          (StepNttFirst195.elem_separate a aWidth v (hn+v) (by omega))
      · exact two_write_here_right s.heap (elem a v) (elem a (hn+v))
          (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
          (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
          (load_allocated highRead) (load_width highRead) aWritable
    · have low := (copied.1 j (by omega)).1
      have high := (copied.1 j (by omega)).2
      rw [heap]
      constructor
      · exact two_write_keep s.heap (elem a v) (elem a j.val) (elem a (hn+v))
          (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
          (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i) _
          (StepNttFirst195.elem_separate a aWidth j.val v (by omega))
          (StepNttFirst195.elem_separate a aWidth j.val (hn+v) (by omega)) low
      · exact two_write_keep s.heap (elem a v) (elem a (hn+j.val)) (elem a (hn+v))
          (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
          (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i) _
          (StepNttFirst195.elem_separate a aWidth (hn+j.val) v (by omega))
          (StepNttFirst195.elem_separate a aWidth (hn+j.val) (hn+v) (by omega)) high
  · intro j done
    have low := (copied.2 j (by omega)).1
    have high := (copied.2 j (by omega)).2
    rw [heap]
    constructor
    · exact two_write_keep s.heap (elem a v) (elem a j.val) (elem a (hn+v))
        (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
        (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i) _
        (StepNttFirst195.elem_separate a aWidth j.val v (by omega))
        (StepNttFirst195.elem_separate a aWidth j.val (hn+v) (by omega)) low
    · exact two_write_keep s.heap (elem a v) (elem a (hn+j.val)) (elem a (hn+v))
        (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
        (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i) _
        (StepNttFirst195.elem_separate a aWidth (hn+j.val) v (by omega))
        (StepNttFirst195.elem_separate a aWidth (hn+j.val) (hn+v) (by omega)) high

theorem next_fixed (s : State) (a gm : ArrayPointer) (hn gmn : Nat) (fv : Fin (2*hn) → BitVec 32)
    (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32) (v : Nat) (bound : v<hn)
    (fixed : StepNttFirst195.Fixed s a gm hn gmn fv gvs w pw p0i) :
    StepNttFirst195.Fixed (stepAt s a hn v fv bound w pw p0i) a gm hn gmn fv gvs w pw p0i := by
  refine ⟨fixed.hnBound,fixed.wide,fixed.hnPositive,fixed.aWidth,fixed.aCapacity,?_,?_,?_,?_,
    ?_,?_,?_,?_,?_,?_⟩
  · show (stepAt s a hn v fv bound w pw p0i).heap.writable a.block=true
    rw [stepAt_heap,bodyAt_writes]
    exact StepNttBody195.write_writable _ _ _ _
      (StepNttBody195.write_writable s.heap (elem a v) (elem a (hn+v))
        (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i) fixed.aWritable)
  · rw [stepAt_arrays s a hn v fv bound w pw p0i "a".toList (by decide) (by decide)]
    exact fixed.aBinding
  · rw [stepAt_arrays s a hn v fv bound w pw p0i "gm".toList (by decide) (by decide)]
    exact fixed.gmBinding
  · show (stepAt s a hn v fv bound w pw p0i).locals "hn".toList=
      some (.uint64,some (.uint64 (C99NatWord141.word hn)))
    rw [stepAt_locals s a hn v fv bound w pw p0i "hn".toList (by decide)]
    exact fixed.hnCell
  · show (stepAt s a hn v fv bound w pw p0i).locals "stride".toList=
      some (.uint64,some (.uint64 (C99NatWord141.word 1)))
    rw [stepAt_locals s a hn v fv bound w pw p0i "stride".toList (by decide)]
    exact fixed.strideCell
  · show (stepAt s a hn v fv bound w pw p0i).locals "w".toList=some (.uint32,some (.uint32 w))
    rw [stepAt_locals s a hn v fv bound w pw p0i "w".toList (by decide)]
    exact fixed.wSlot
  · show (stepAt s a hn v fv bound w pw p0i).locals "p".toList=some (.uint32,some (.uint32 pw))
    rw [stepAt_locals s a hn v fv bound w pw p0i "p".toList (by decide)]
    exact fixed.pSlot
  · show (stepAt s a hn v fv bound w pw p0i).locals "p0i".toList=
      some (.uint32,some (.uint32 p0i))
    rw [stepAt_locals s a hn v fv bound w pw p0i "p0i".toList (by decide)]
    exact fixed.p0iSlot
  · intro i j
    exact fixed.gmSeparate i j
  · intro i
    rw [stepAt_heap,bodyAt_writes]
    exact two_write_keep s.heap (elem a v) (elem gm i) (elem a (hn+v))
      (StepNttBody195.lowWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i)
      (StepNttBody195.highWord (fvLo hn fv v bound) (fvHi hn fv v bound) w pw p0i) (gvs i)
      (fixed.gmSeparate i ⟨v,by omega⟩) (fixed.gmSeparate i ⟨hn+v,by omega⟩) (fixed.gmLoads i)

/-! ## The remaining induction over the hn-step loop -/

theorem remaining (count v : Nat) (s : State) (a gm : ArrayPointer) (hn gmn : Nat)
    (fv : Fin (2*hn) → BitVec 32) (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32)
    (fixed : StepNttFirst195.Fixed s a gm hn gmn fv gvs w pw p0i)
    (counter : Cell s "u".toList v)
    (r1Binding : s.arrays "r1".toList=some (elem a v))
    (r2Binding : s.arrays "r2".toList=some (elem a (hn+v)))
    (copied : StepNttFirst195.Image s a fv w pw p0i v) (finish : v+count=hn) :
    ∃ after, Exec StepNttBody195.firstWalk s ⟨after,.normal⟩ ∧
      StepNttFirst195.Fixed after a gm hn gmn fv gvs w pw p0i ∧
      StepNttFirst195.Image after a fv w pw p0i hn ∧
      Cell after "u".toList hn ∧
      after.arrays "r1".toList=some (elem a hn) ∧
      after.arrays "r2".toList=some (elem a (hn+hn)) ∧
      (∀ name : Name, name≠"u".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"r1".toList → name≠"r2".toList → after.arrays name=s.arrays name) := by
  induction count generalizing v s with
  | zero =>
      have equal : v=hn := by omega
      subst v
      have guardFalse : C99ArrayReference.scalar s StepNttBody195.firstGuard (.int32 0) := by
        simpa [C99ScalarReference.boolean] using
          guard s hn hn fixed.hnBound fixed.hnBound counter fixed.hnCell
      exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guardFalse (by decide),fixed,copied,counter,
        r1Binding,r2Binding,fun _ _ => rfl,fun _ _ _ => rfl⟩
  | succ count ih =>
      have slot : v<hn := by omega
      have nonzero : (C99ScalarReference.boolean (decide (v<hn))).integer≠0 := by
        simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
      have guardTrue : C99ArrayReference.scalar s StepNttBody195.firstGuard
          (C99ScalarReference.boolean (decide (v<hn))) :=
        guard s v hn (by have h := fixed.hnBound; omega) fixed.hnBound counter fixed.hnCell
      have bodyRun : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) s
          ⟨bodyAt s a hn v fv slot w pw p0i,.normal⟩ :=
        body_run s a gm hn gmn fv gvs w pw p0i v slot fixed r1Binding r2Binding copied
      have updateRun : Exec StepNttBody195.stepU (bodyAt s a hn v fv slot w pw p0i)
          ⟨stepAt s a hn v fv slot w pw p0i,.normal⟩ :=
        increment_run s a hn v fv slot w pw p0i fixed.hnBound counter fixed.strideCell
          fixed.aCapacity r1Binding r2Binding
      obtain ⟨after,rest,finalFixed,finalImage,finalU,finalR1,finalR2,finalLocals,finalArrays⟩ :=
        ih (v+1) (stepAt s a hn v fv slot w pw p0i)
          (next_fixed s a gm hn gmn fv gvs w pw p0i v slot fixed)
          (stepAt_u s a hn v fv slot w pw p0i)
          (stepAt_r1 s a hn v fv slot w pw p0i)
          (stepAt_r2 s a hn v fv slot w pw p0i)
          (next_image s a hn v fv slot w pw p0i fixed.aWidth fixed.aWritable copied)
          (by omega)
      refine ⟨after,?_,finalFixed,finalImage,finalU,finalR1,finalR2,?_,?_⟩
      · refine .loopNormal _ _ _ s (bodyAt s a hn v fv slot w pw p0i)
          (stepAt s a hn v fv slot w pw p0i) ⟨after,.normal⟩
          (C99ScalarReference.boolean (decide (v<hn))) guardTrue nonzero bodyRun updateRun rest
      · intro name different
        exact (finalLocals name different).trans
          (stepAt_locals s a hn v fv slot w pw p0i name different)
      · intro name first second
        exact (finalArrays name first second).trans
          (stepAt_arrays s a hn v fv slot w pw p0i name first second)

/-! ## The whole first pass: firstInit + hn steps -/

theorem init_fixed (s : State) (a gm : ArrayPointer) (hn gmn : Nat)
    (fv : Fin (2*hn) → BitVec 32) (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32)
    (fixed : StepNttFirst195.Fixed s a gm hn gmn fv gvs w pw p0i) :
    StepNttFirst195.Fixed (StepNttPrologue195.initState s a hn) a gm hn gmn fv gvs w pw p0i := by
  refine ⟨fixed.hnBound,fixed.wide,fixed.hnPositive,fixed.aWidth,fixed.aCapacity,?_,?_,?_,?_,
    ?_,?_,?_,?_,?_,?_⟩
  · exact fixed.aWritable
  · exact (StepNttPrologue195.init_arrays s a hn "a".toList (by decide) (by decide)).trans
      fixed.aBinding
  · exact (StepNttPrologue195.init_arrays s a hn "gm".toList (by decide) (by decide)).trans
      fixed.gmBinding
  · show (StepNttPrologue195.initState s a hn).locals "hn".toList=
      some (.uint64,some (.uint64 (C99NatWord141.word hn)))
    rw [StepNttPrologue195.init_locals s a hn "hn".toList (by decide)]
    exact fixed.hnCell
  · show (StepNttPrologue195.initState s a hn).locals "stride".toList=
      some (.uint64,some (.uint64 (C99NatWord141.word 1)))
    rw [StepNttPrologue195.init_locals s a hn "stride".toList (by decide)]
    exact fixed.strideCell
  · show (StepNttPrologue195.initState s a hn).locals "w".toList=some (.uint32,some (.uint32 w))
    rw [StepNttPrologue195.init_locals s a hn "w".toList (by decide)]
    exact fixed.wSlot
  · show (StepNttPrologue195.initState s a hn).locals "p".toList=some (.uint32,some (.uint32 pw))
    rw [StepNttPrologue195.init_locals s a hn "p".toList (by decide)]
    exact fixed.pSlot
  · show (StepNttPrologue195.initState s a hn).locals "p0i".toList=
      some (.uint32,some (.uint32 p0i))
    rw [StepNttPrologue195.init_locals s a hn "p0i".toList (by decide)]
    exact fixed.p0iSlot
  · exact fixed.gmSeparate
  · intro i
    exact fixed.gmLoads i

theorem first_run (s : State) (a gm : ArrayPointer) (hn gmn : Nat) (fv : Fin (2*hn) → BitVec 32)
    (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32)
    (fixed : StepNttFirst195.Fixed s a gm hn gmn fv gvs w pw p0i)
    (uDeclared : ∃ old, s.locals "u".toList=some (.uint64,old))
    (pending : StepNttFirst195.Pending0 s a fv) :
    ∃ after, Exec KeygenNttForwardPrograms.firstLoop s ⟨after,.normal⟩ ∧
      StepNttFirst195.Fixed after a gm hn gmn fv gvs w pw p0i ∧
      StepNttFirst195.Image after a fv w pw p0i hn ∧
      Cell after "u".toList hn ∧
      after.arrays "r1".toList=some (elem a hn) ∧
      after.arrays "r2".toList=some (elem a (hn+hn)) ∧
      (∀ name : Name, name≠"u".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"r1".toList → name≠"r2".toList → after.arrays name=s.arrays name) := by
  have initRun : Exec KeygenNttForwardPrograms.firstInit s
      ⟨StepNttPrologue195.initState s a hn,.normal⟩ :=
    StepNttPrologue195.init_run s a hn fixed.hnBound fixed.hnCell fixed.strideCell uDeclared
      fixed.aBinding fixed.aCapacity
  have midFixed : StepNttFirst195.Fixed (StepNttPrologue195.initState s a hn) a gm hn gmn fv gvs
      w pw p0i := init_fixed s a gm hn gmn fv gvs w pw p0i fixed
  have pending0 : StepNttFirst195.Pending0 (StepNttPrologue195.initState s a hn) a fv := pending
  have zero0 : StepNttFirst195.Image (StepNttPrologue195.initState s a hn) a fv w pw p0i 0 :=
    StepNttFirst195.pending_image (StepNttPrologue195.initState s a hn) a fv w pw p0i pending0
  obtain ⟨after,rest,finalFixed,finalImage,finalU,finalR1,finalR2,finalLocals,finalArrays⟩ :=
    remaining hn 0 (StepNttPrologue195.initState s a hn) a gm hn gmn fv gvs w pw p0i midFixed
      (StepNttPrologue195.init_u s a hn) (StepNttPrologue195.init_r1 s a hn)
      (StepNttPrologue195.init_r2 s a hn) zero0 (by omega)
  refine ⟨after,?_,finalFixed,finalImage,finalU,finalR1,finalR2,?_,?_⟩
  · refine .seqNormal _ _ s (StepNttPrologue195.initState s a hn) ⟨after,.normal⟩ initRun rest
  · intro name different
    exact (finalLocals name different).trans
      (StepNttPrologue195.init_locals s a hn name different)
  · intro name first second
    exact (finalArrays name first second).trans
      (StepNttPrologue195.init_arrays s a hn name first second)

/-! ## The export at the StepNttEntry195 entry frame -/

def frame (before : State) (t1 gm : ArrayPointer) (pw p0w : BitVec 32) : State :=
  StepNttEntry195.entry before t1 gm 9 pw p0w

def firstTail : Stmt := .seq KeygenNttForwardPrograms.wAssign KeygenNttForwardPrograms.firstLoop
def entryPrefix : Stmt := .seq KeygenNttForwardPrograms.locals
  (.seq KeygenNttForwardPrograms.word (.seq KeygenNttForwardPrograms.pointers
    (.seq KeygenNttForwardPrograms.earlyExit (.seq KeygenNttForwardPrograms.nAssign
      (.seq KeygenNttForwardPrograms.hnAssign firstTail)))))

def firstNames : List Name :=
  [['n'],['h','n'],['u'],['r'],['m'],['t'],['w']]

theorem frame_logn (before : State) (t1 gm : ArrayPointer) (pw p0w : BitVec 32) :
    StepNttPrologue195.lognAt (frame before t1 gm pw p0w) := by
  simp [frame,StepNttPrologue195.lognAt,StepNttEntry195.entry,StepNttEntry195.entryA,
    StepNttEntry195.entryStride,StepNttEntry195.entryGm,StepNttEntry195.entryLogn,
    StepNttEntry195.entryFull,StepNttEntry195.entryP,StepNttEntry195.entryP0i,
    StepNttEntry195.nttFresh,C99ArrayReference.bindValue,C99ArrayReference.bindPointer,
    C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem frame_full (before : State) (t1 gm : ArrayPointer) (pw p0w : BitVec 32) :
    StepNttPrologue195.fullAt (frame before t1 gm pw p0w) := by
  simp [frame,StepNttPrologue195.fullAt,StepNttEntry195.entry,StepNttEntry195.entryA,
    StepNttEntry195.entryStride,StepNttEntry195.entryGm,StepNttEntry195.entryLogn,
    StepNttEntry195.entryFull,StepNttEntry195.entryP,StepNttEntry195.entryP0i,
    StepNttEntry195.nttFresh,C99ArrayReference.bindValue,C99ArrayReference.bindPointer,
    C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem frame_p (before : State) (t1 gm : ArrayPointer) (pw p0w : BitVec 32) :
    (frame before t1 gm pw p0w).locals "p".toList=some (.uint32,some (.uint32 pw)) := by
  simp [frame,StepNttEntry195.entry,StepNttEntry195.entryA,
    StepNttEntry195.entryStride,StepNttEntry195.entryGm,StepNttEntry195.entryLogn,
    StepNttEntry195.entryFull,StepNttEntry195.entryP,StepNttEntry195.entryP0i,
    StepNttEntry195.nttFresh,C99ArrayReference.bindValue,C99ArrayReference.bindPointer,
    C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem frame_p0i (before : State) (t1 gm : ArrayPointer) (pw p0w : BitVec 32) :
    (frame before t1 gm pw p0w).locals "p0i".toList=some (.uint32,some (.uint32 p0w)) := by
  simp [frame,StepNttEntry195.entry,StepNttEntry195.entryA,
    StepNttEntry195.entryStride,StepNttEntry195.entryGm,StepNttEntry195.entryLogn,
    StepNttEntry195.entryFull,StepNttEntry195.entryP,StepNttEntry195.entryP0i,
    StepNttEntry195.nttFresh,C99ArrayReference.bindValue,C99ArrayReference.bindPointer,
    C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem frame_stride (before : State) (t1 gm : ArrayPointer) (pw p0w : BitVec 32) :
    Cell (frame before t1 gm pw p0w) "stride".toList 1 := by
  simp [frame,C99LoopScalar141.Cell,C99NatWord141.word,StepNttEntry195.entry,
    StepNttEntry195.entryA,StepNttEntry195.entryStride,StepNttEntry195.entryGm,
    StepNttEntry195.entryLogn,StepNttEntry195.entryFull,StepNttEntry195.entryP,
    StepNttEntry195.entryP0i,StepNttEntry195.nttFresh,C99ArrayReference.bindValue,
    C99ArrayReference.bindPointer,C99ScalarReference.set,C99IntegerReference.convert,
    C99IntegerReference.Value.integer]

theorem frame_a (before : State) (t1 gm : ArrayPointer) (pw p0w : BitVec 32) :
    (frame before t1 gm pw p0w).arrays "a".toList=some t1 := by
  simp [frame,StepNttEntry195.entry,StepNttEntry195.entryA,
    StepNttEntry195.entryStride,StepNttEntry195.entryGm,StepNttEntry195.entryLogn,
    StepNttEntry195.entryFull,StepNttEntry195.entryP,StepNttEntry195.entryP0i,
    StepNttEntry195.nttFresh,C99ArrayReference.bindValue,C99ArrayReference.bindPointer]

theorem frame_gm (before : State) (t1 gm : ArrayPointer) (pw p0w : BitVec 32) :
    (frame before t1 gm pw p0w).arrays "gm".toList=some gm := by
  simp [frame,StepNttEntry195.entry,StepNttEntry195.entryA,
    StepNttEntry195.entryStride,StepNttEntry195.entryGm,StepNttEntry195.entryLogn,
    StepNttEntry195.entryFull,StepNttEntry195.entryP,StepNttEntry195.entryP0i,
    StepNttEntry195.nttFresh,C99ArrayReference.bindValue,C99ArrayReference.bindPointer]

/- The ready-state keeps outside the prologue names. -/
theorem ready_w_free (before : State) :
    (StepNttPrologue195.ready before).locals "w".toList=some (.uint32,none) := by
  simp [StepNttPrologue195.ready,StepNttPrologue195.afterCompute,StepNttPrologue195.afterN,
    KeygenNttForwardExec.afterPointers,KeygenNttForwardExec.afterWord,
    KeygenNttForwardExec.afterLocals,KeygenNttForwardExec.env6,
    KeygenNttForwardExec.declareCell,C99ScalarReference.set]

theorem ready_u_free (before : State) :
    (StepNttPrologue195.ready before).locals "u".toList=some (.uint64,none) := by
  simp [StepNttPrologue195.ready,StepNttPrologue195.afterCompute,StepNttPrologue195.afterN,
    KeygenNttForwardExec.afterPointers,KeygenNttForwardExec.afterWord,
    KeygenNttForwardExec.afterLocals,KeygenNttForwardExec.env6,
    KeygenNttForwardExec.declareCell,C99ScalarReference.set]

theorem ready_locals_keep (before : State) (name : Name) (absent : name∉firstNames) :
    (StepNttPrologue195.ready before).locals name=before.locals name := by
  have nDiff : name≠['n'] := by intro h; simp [firstNames,h] at absent
  have hnDiff : name≠['h','n'] := by intro h; simp [firstNames,h] at absent
  have uDiff : name≠['u'] := by intro h; simp [firstNames,h] at absent
  have rDiff : name≠['r'] := by intro h; simp [firstNames,h] at absent
  have mDiff : name≠['m'] := by intro h; simp [firstNames,h] at absent
  have tDiff : name≠['t'] := by intro h; simp [firstNames,h] at absent
  have wDiff : name≠['w'] := by intro h; simp [firstNames,h] at absent
  simp [StepNttPrologue195.ready,StepNttPrologue195.afterCompute,StepNttPrologue195.afterN,
    KeygenNttForwardExec.afterPointers,KeygenNttForwardExec.afterWord,
    KeygenNttForwardExec.afterLocals,KeygenNttForwardExec.env6,
    KeygenNttForwardExec.declareCell,C99ScalarReference.set,
    nDiff,hnDiff,uDiff,rDiff,mDiff,tDiff,wDiff]

theorem ready_arrays_keep (before : State) (name : Name)
    (first : name≠"r1".toList) (second : name≠"r2".toList) :
    (StepNttPrologue195.ready before).arrays name=before.arrays name := by
  have first' : name≠['r','1'] := first
  have second' : name≠['r','2'] := second
  simp [StepNttPrologue195.ready,StepNttPrologue195.afterCompute,StepNttPrologue195.afterN,
    KeygenNttForwardExec.afterPointers,KeygenNttForwardExec.afterWord,
    KeygenNttForwardExec.afterLocals,first',second']

theorem w_set_locals_keep (s : State) (w : BitVec 32) (name : Name) (different : name≠"w".toList) :
    (ModularAtoms178.set s "w" w).locals name=s.locals name := by
  have diff : name≠['w'] := different
  simp [ModularAtoms178.set,C99ArrayReference.bindValue,C99ScalarReference.set,diff]

theorem w_set_arrays (s : State) (w : BitVec 32) :
    (ModularAtoms178.set s "w" w).arrays=s.arrays := rfl

/- The loop input state of the export (w = gm[1] bound at the ready frame). -/
def wState (before : State) (t1 gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32)
    (pw p0w : BitVec 32) (gmOne : 1<gmn) : State :=
  ModularAtoms178.set (StepNttPrologue195.ready (frame before t1 gm pw p0w)) "w" (gvs ⟨1,gmOne⟩)

theorem entry_fixed (before : State) (t1 gm : ArrayPointer) {gmn : Nat}
    (fv : Fin (2*256) → BitVec 32) (gvs : Fin gmn → BitVec 32) (pw p0w : BitVec 32)
    (gmOne : 1<gmn) (t1Width : t1.elementBytes=4) (t1Capacity : t1.index+512≤t1.count)
    (t1Writable : before.heap.writable t1.block=true)
    (gmSeparate : ∀ i : Fin gmn, ∀ j : Fin (2*256), Separate (elem gm i) (elem t1 j))
    (gmLoads : ∀ i : Fin gmn, Load32 before.heap (elem gm i) (gvs i)) :
    StepNttFirst195.Fixed (wState before t1 gm gvs pw p0w gmOne) t1 gm 256 gmn fv gvs
      (gvs ⟨1,gmOne⟩) pw p0w := by
  refine ⟨by decide,by decide,by decide,t1Width,t1Capacity,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · show (wState before t1 gm gvs pw p0w gmOne).heap.writable t1.block=true
    exact t1Writable
  · change (ModularAtoms178.set (StepNttPrologue195.ready (frame before t1 gm pw p0w))
      "w" (gvs ⟨1,gmOne⟩)).arrays "a".toList=some t1
    rw [w_set_arrays,StepNttPrologue195.ready_a,frame_a]
  · change (ModularAtoms178.set (StepNttPrologue195.ready (frame before t1 gm pw p0w))
      "w" (gvs ⟨1,gmOne⟩)).arrays "gm".toList=some gm
    rw [w_set_arrays,StepNttPrologue195.ready_gm,frame_gm]
  · change (ModularAtoms178.set (StepNttPrologue195.ready (frame before t1 gm pw p0w))
      "w" (gvs ⟨1,gmOne⟩)).locals "hn".toList=
      some (.uint64,some (.uint64 (C99NatWord141.word 256)))
    rw [w_set_locals_keep _ _ "hn".toList (by decide)]
    exact StepNttPrologue195.ready_hn _
  · change (ModularAtoms178.set (StepNttPrologue195.ready (frame before t1 gm pw p0w))
      "w" (gvs ⟨1,gmOne⟩)).locals "stride".toList=
      some (.uint64,some (.uint64 (C99NatWord141.word 1)))
    rw [w_set_locals_keep _ _ "stride".toList (by decide),StepNttPrologue195.ready_stride]
    exact frame_stride before t1 gm pw p0w
  · exact ModularAtoms178.slot _ "w" (gvs ⟨1,gmOne⟩)
  · change (ModularAtoms178.set (StepNttPrologue195.ready (frame before t1 gm pw p0w))
      "w" (gvs ⟨1,gmOne⟩)).locals "p".toList=some (.uint32,some (.uint32 pw))
    rw [w_set_locals_keep _ _ "p".toList (by decide),StepNttPrologue195.ready_p]
    exact frame_p before t1 gm pw p0w
  · change (ModularAtoms178.set (StepNttPrologue195.ready (frame before t1 gm pw p0w))
      "w" (gvs ⟨1,gmOne⟩)).locals "p0i".toList=some (.uint32,some (.uint32 p0w))
    rw [w_set_locals_keep _ _ "p0i".toList (by decide),StepNttPrologue195.ready_p0i]
    exact frame_p0i before t1 gm pw p0w
  · intro i j
    exact gmSeparate i j
  · intro i
    show Load32 (wState before t1 gm gvs pw p0w gmOne).heap (elem gm i) (gvs i)
    exact gmLoads i

/- Main export: the prologue + w = gm[1] + firstInit + hn steps of the
   first pass run in full at the StepNttEntry195 entry frame words
   (logn = 9 / full = 0, n = 512, hn = 256), with the executed butterfly
   image over the input words and the exit cells u = hn, r1 = a + hn,
   r2 = a + hn + hn. -/
theorem entry_run (before : State) (t1 gm : ArrayPointer) {gmn : Nat}
    (fv : Fin (2*256) → BitVec 32) (gvs : Fin gmn → BitVec 32) (pw p0w : BitVec 32)
    (gmOne : 1<gmn) (t1Width : t1.elementBytes=4) (t1Capacity : t1.index+512≤t1.count)
    (t1Writable : before.heap.writable t1.block=true)
    (gmSeparate : ∀ i : Fin gmn, ∀ j : Fin (2*256), Separate (elem gm i) (elem t1 j))
    (gmLoads : ∀ i : Fin gmn, Load32 before.heap (elem gm i) (gvs i))
    (input : StepNttFirst195.Pending0 (frame before t1 gm pw p0w) t1 fv) :
    ∃ after, Exec entryPrefix (frame before t1 gm pw p0w) ⟨after,.normal⟩ ∧
      StepNttFirst195.Fixed after t1 gm 256 gmn fv gvs (gvs ⟨1,gmOne⟩) pw p0w ∧
      StepNttFirst195.Image after t1 fv (gvs ⟨1,gmOne⟩) pw p0w 256 ∧
      Cell after "u".toList 256 ∧
      after.arrays "r1".toList=some (elem t1 256) ∧
      after.arrays "r2".toList=some (elem t1 (256+256)) ∧
      (∀ name : Name, name∉firstNames → after.locals name=(frame before t1 gm pw p0w).locals name) ∧
      (∀ name : Name, name≠"r1".toList → name≠"r2".toList →
        after.arrays name=(frame before t1 gm pw p0w).arrays name) := by
  have logn : StepNttPrologue195.lognAt (frame before t1 gm pw p0w) := frame_logn before t1 gm pw p0w
  have full : StepNttPrologue195.fullAt (frame before t1 gm pw p0w) := frame_full before t1 gm pw p0w
  have prologueRun : Exec KeygenNttForwardPrograms.prologue (frame before t1 gm pw p0w)
      ⟨StepNttPrologue195.ready (frame before t1 gm pw p0w),.normal⟩ :=
    StepNttPrologue195.prologue_run (frame before t1 gm pw p0w) logn full
  have readyGm : (StepNttPrologue195.ready (frame before t1 gm pw p0w)).arrays "gm".toList=some gm :=
    (StepNttPrologue195.ready_gm (frame before t1 gm pw p0w)).trans (frame_gm before t1 gm pw p0w)
  have gmAlloc : Allocated before.heap (elem gm 1) := load_allocated (gmLoads ⟨1,gmOne⟩)
  have gmCapacity : gm.index+1≤gm.count := by
    have h := gmAlloc.2.2.1
    change gm.index+1<gm.count at h
    omega
  have gmRead : Load32 (StepNttPrologue195.ready (frame before t1 gm pw p0w)).heap (elem gm 1)
      (gvs ⟨1,gmOne⟩) := gmLoads ⟨1,gmOne⟩
  have wRun : Exec KeygenNttForwardPrograms.wAssign
      (StepNttPrologue195.ready (frame before t1 gm pw p0w))
      ⟨wState before t1 gm gvs pw p0w gmOne,.normal⟩ :=
    (StepNttPrologue195.w_run (StepNttPrologue195.ready (frame before t1 gm pw p0w)) gm gvs gmOne
      ⟨none,ready_w_free (frame before t1 gm pw p0w)⟩ readyGm gmCapacity gmRead).1
  have fixed : StepNttFirst195.Fixed (wState before t1 gm gvs pw p0w gmOne) t1 gm 256 gmn fv gvs
      (gvs ⟨1,gmOne⟩) pw p0w :=
    entry_fixed before t1 gm fv gvs pw p0w gmOne t1Width t1Capacity t1Writable gmSeparate gmLoads
  have uDeclared : ∃ old,
      (wState before t1 gm gvs pw p0w gmOne).locals "u".toList=some (.uint64,old) := by
    refine ⟨none,?_⟩
    change (ModularAtoms178.set (StepNttPrologue195.ready (frame before t1 gm pw p0w))
      "w" (gvs ⟨1,gmOne⟩)).locals "u".toList=some (.uint64,none)
    rw [w_set_locals_keep _ _ "u".toList (by decide)]
    exact ready_u_free (frame before t1 gm pw p0w)
  have pending : StepNttFirst195.Pending0 (wState before t1 gm gvs pw p0w gmOne) t1 fv := input
  obtain ⟨after,loopRun,finalFixed,finalImage,finalU,finalR1,finalR2,finalLocals,finalArrays⟩ :=
    first_run (wState before t1 gm gvs pw p0w gmOne) t1 gm 256 gmn fv gvs (gvs ⟨1,gmOne⟩) pw p0w
      fixed uDeclared pending
  refine ⟨after,?_,finalFixed,finalImage,finalU,finalR1,finalR2,?_,?_⟩
  · refine .seqNormal _ _ _ _ _ (StepNttPrologue195.locals_run (frame before t1 gm pw p0w)) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.word_run _) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.pointers_run _) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.early_run _
      (StepNttPrologue195.logn_keep _ logn)) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.n_run _
      (StepNttPrologue195.logn_keep _ logn) (StepNttPrologue195.full_keep _ full)
      (KeygenNttForwardExec.n_free _)) ?_
    refine .seqNormal _ _ _ _ _ (StepNttPrologue195.hn_run _
      (StepNttPrologue195.n_bound _) (StepNttPrologue195.hn_free _)) ?_
    exact .seqNormal _ _ _ _ _ wRun loopRun
  · intro name absent
    have uDiff : name≠['u'] := by intro h; simp [firstNames,h] at absent
    have wDiff : name≠['w'] := by intro h; simp [firstNames,h] at absent
    exact (finalLocals name uDiff).trans
      ((w_set_locals_keep _ _ name wDiff).trans
        (ready_locals_keep _ name absent))
  · intro name first second
    exact (finalArrays name first second).trans
      ((congrArg (fun f : Name → Option ArrayPointer => f name) (w_set_arrays _ _)).trans
        (ready_arrays_keep _ name first second))

/-! ## The continuation hook along the pinned parse map -/

theorem seq_parts (a b : Stmt) (s mid : State) (h : Exec (.seq a b) s ⟨mid,.normal⟩) :
    ∃ k, Exec a s ⟨k,.normal⟩ ∧ Exec b k ⟨mid,.normal⟩ := by
  obtain h | h := KeygenNttForwardExec.seq_inv a b s ⟨mid,.normal⟩ h
  · exact h
  · obtain ⟨r,_,ne,eq⟩ := h
    subst r
    exact absurd rfl ne

theorem prefix_continue (before mid : State) (result : Result)
    (head : Exec entryPrefix before ⟨mid,.normal⟩)
    (rest : Exec StepNttBody195.tailT mid result) :
    Exec KeygenNttForwardPrograms.forwardBody before result := by
  obtain ⟨k1,run1,rest1⟩ := seq_parts _ _ before mid head
  obtain ⟨k2,run2,rest2⟩ := seq_parts _ _ k1 mid rest1
  obtain ⟨k3,run3,rest3⟩ := seq_parts _ _ k2 mid rest2
  obtain ⟨k4,run4,rest4⟩ := seq_parts _ _ k3 mid rest3
  obtain ⟨k5,run5,rest5⟩ := seq_parts _ _ k4 mid rest4
  obtain ⟨k6,run6,rest6⟩ := seq_parts _ _ k5 mid rest5
  obtain ⟨k7,run7,run8⟩ := seq_parts _ _ k6 mid rest6
  rw [StepNttBody195.body_spine,StepNttBody195.locals_split,StepNttBody195.word_split,
    StepNttBody195.pointers_split,StepNttBody195.exit_split,StepNttBody195.n_split,
    StepNttBody195.hn_split,StepNttBody195.w_split,StepNttBody195.loop_split]
  exact .seqNormal _ _ _ _ _ run1
    (.seqNormal _ _ _ _ _ run2
      (.seqNormal _ _ _ _ _ run3
        (.seqNormal _ _ _ _ _ run4
          (.seqNormal _ _ _ _ _ run5
            (.seqNormal _ _ _ _ _ run6
              (.seqNormal _ _ _ _ _ run7 (.seqNormal _ _ _ _ _ run8 rest)))))))

end FT1536.Source3.StepNttFirstLoop195
