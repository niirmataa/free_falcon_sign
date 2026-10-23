import Source3.StepNttBody195
import Source3.StepCopyFixed190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The first pass of the pinned modp_NTT3_ext forward body: the w = gm[1]
   load, the walk initialiser (u = 0, r1 = a, r2 = a + hn * stride at the
   pinned stride = 1) and the hn-step loop of degree-1 butterflies, each
   one exactly one StepNttBody195.block_run instance at the walked pair
   (a[u], a[hn+u]) followed by the pinned u/r1/r2 increment. The exported
   image is the executed butterfly words over the input words: cell u
   holds lowWord (fv u) (fv (hn+u)) and cell hn+u holds highWord
   (fv u) (fv (hn+u)), with the Word32Memory176 keep discipline outside
   the butterfly cells (the gm words survive the pass) and the exit cells
   u = hn, r1 = a + hn, r2 = a + hn + hn. The loop is stated over a
   generic hn; the selected call instance (n = 512, hn = 256 at the
   StepNttEntry195 frame words) binds in the composition step. Values
   stay executed words: no transform property, table law, root law or
   positivity claim. -/
namespace FT1536.Source3.StepNttFirst195
open C99ModularReference (Stmt Exec Eval)
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open StepNttBody195 (lowWord highWord)

/-! ## Pointer and word arithmetic -/

theorem elem_step (a : ArrayPointer) (v : Nat) :
    {elem a v with index := (elem a v).index+1} = elem a (v+1) :=
  congrArg (fun k : Nat => {elem a v with index := k})
    (show (elem a v).index+1 = a.index+(v+1) by
      change a.index + v + 1 = a.index + (v+1)
      omega)

theorem elem_half (a : ArrayPointer) (hn : Nat) :
    {a with index := a.index+hn*1} = elem a hn :=
  congrArg (fun k : Nat => {a with index := k}) (by omega)

theorem elem_double (a : ArrayPointer) (hn : Nat) : elem a (hn+hn) = elem a (2*hn) :=
  congrArg (fun k : Nat => {a with index := a.index+k}) (by omega)

theorem elem_separate (a : ArrayPointer) (width : a.elementBytes = 4) (i j : Nat)
    (different : i ≠ j) : Separate (elem a i) (elem a j) :=
  StepCopyFixed190.elem_separate a width i j different

theorem times_word (a b : Nat) (boundA : a < 2^64) (boundB : b < 2^64) :
    C99IntegerReference.ArithmeticExec .times (.uint64 (C99NatWord141.word a))
      (.uint64 (C99NatWord141.word b)) (.uint64 (C99NatWord141.word (a*b))) := by
  have raw := C99IntegerReference.ArithmeticExec.step .times
    (.uint64 (C99NatWord141.word a)) (.uint64 (C99NatWord141.word b)) .uint64 rfl
    (.uint64 (C99NatWord141.word a)) (.uint64 (C99NatWord141.word b))
    (C99CountedWords.convert_self (.uint64 (C99NatWord141.word a))).symm
    (C99CountedWords.convert_self (.uint64 (C99NatWord141.word b))).symm
    (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .times (.uint64 (C99NatWord141.word a))
    (.uint64 (C99NatWord141.word b))
    (.uint64 (BitVec.ofInt 64 ((Value.uint64 (C99NatWord141.word a)).integer *
      (Value.uint64 (C99NatWord141.word b)).integer))) at raw
  rw [C99NatWord141.integer a boundA,C99NatWord141.integer b boundB] at raw
  have product : (a : Int)*(b : Int)=((a*b : Nat) : Int) := by omega
  rw [product,BitVec.ofInt_natCast] at raw
  exact raw

/-! ## The executed image of the pass -/

def lowWordAt (hn : Nat) (fv : Fin (2*hn) → BitVec 32) (w pw p0i : BitVec 32) (v : Nat)
    (bound : v < hn) : BitVec 32 :=
  lowWord (fv ⟨v, by omega⟩) (fv ⟨hn+v, by omega⟩) w pw p0i

def highWordAt (hn : Nat) (fv : Fin (2*hn) → BitVec 32) (w pw p0i : BitVec 32) (v : Nat)
    (bound : v < hn) : BitVec 32 :=
  highWord (fv ⟨v, by omega⟩) (fv ⟨hn+v, by omega⟩) w pw p0i

def Image (s : State) (a : ArrayPointer) {hn : Nat} (fv : Fin (2*hn) → BitVec 32)
    (w pw p0i : BitVec 32) (v : Nat) : Prop :=
  (∀ j : Fin hn, j.val < v →
    Load32 s.heap (elem a j.val) (lowWordAt hn fv w pw p0i j.val j.isLt) ∧
    Load32 s.heap (elem a (hn+j.val)) (highWordAt hn fv w pw p0i j.val j.isLt)) ∧
  (∀ j : Fin hn, v ≤ j.val →
    Load32 s.heap (elem a j.val) (fv ⟨j.val, by omega⟩) ∧
    Load32 s.heap (elem a (hn+j.val)) (fv ⟨hn+j.val, by omega⟩))

def Pending0 (s : State) (a : ArrayPointer) {hn : Nat} (fv : Fin (2*hn) → BitVec 32) :
    Prop := ∀ j : Fin hn,
    Load32 s.heap (elem a j.val) (fv ⟨j.val, by omega⟩) ∧
    Load32 s.heap (elem a (hn+j.val)) (fv ⟨hn+j.val, by omega⟩)

theorem pending_image (s : State) (a : ArrayPointer) {hn : Nat} (fv : Fin (2*hn) → BitVec 32)
    (w pw p0i : BitVec 32) (pending : Pending0 s a fv) : Image s a fv w pw p0i 0 :=
  ⟨fun j bound => absurd bound (by omega), fun j _ => pending j⟩

/-! ## The loop invariant -/

structure Fixed (s : State) (a gm : ArrayPointer) (hn gmn : Nat)
    (fv : Fin (2*hn) → BitVec 32) (gvs : Fin gmn → BitVec 32) (w pw p0i : BitVec 32) : Prop where
  hnBound : hn < 2^64
  wide : 2*hn < 2^64
  hnPositive : 0 < hn
  aWidth : a.elementBytes = 4
  aCapacity : a.index + 2*hn ≤ a.count
  aWritable : s.heap.writable a.block = true
  aBinding : s.arrays "a".toList = some a
  gmBinding : s.arrays "gm".toList = some gm
  hnCell : Cell s "hn".toList hn
  strideCell : Cell s "stride".toList 1
  wSlot : Slot s "w" w
  pSlot : Slot s "p" pw
  p0iSlot : Slot s "p0i" p0i
  gmSeparate : ∀ i : Fin gmn, ∀ j : Fin (2*hn), Separate (elem gm i) (elem a j)
  gmLoads : ∀ i : Fin gmn, Load32 s.heap (elem gm i) (gvs i)

/-! ## One butterfly iteration -/

def bodyHeap (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) : C99MemoryReference.Memory :=
  StepNttBody195.highHeap s (elem a v) (elem a (hn+v)) (lowWordAt hn fv w pw p0i v bound)
    (highWordAt hn fv w pw p0i v bound) w pw p0i

def bodyState (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) : State :=
  {s with heap := bodyHeap s a hn v fv bound w pw p0i}

def stepState (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) : State :=
  bindPointer (bindPointer (FftLocalCells140.put (bodyState s a hn v fv bound w pw p0i)
    "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1))) "r2".toList (elem a (hn+v+1))

theorem bodyState_locals (s : State) (a : ArrayPointer) (hn v : Nat)
    (fv : Fin (2*hn) → BitVec 32) (bound : v < hn) (w pw p0i : BitVec 32) :
    (bodyState s a hn v fv bound w pw p0i).locals = s.locals := rfl

theorem step_locals (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    ∀ name : Name, name ≠ "u".toList →
      (stepState s a hn v fv bound w pw p0i).locals name = s.locals name := by
  intro name different
  show (FftLocalCells140.put (bodyState s a hn v fv bound w pw p0i) "u".toList
    (C99NatWord141.word (v+1))).locals name = s.locals name
  rw [FftLocalCells140.outside (bodyState s a hn v fv bound w pw p0i) "u".toList name
    (C99NatWord141.word (v+1)) different, bodyState_locals s a hn v fv bound w pw p0i]

theorem step_arrays (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    ∀ name : Name, name ≠ "r1".toList → name ≠ "r2".toList →
      (stepState s a hn v fv bound w pw p0i).arrays name = s.arrays name := by
  intro name first second
  show (bindPointer (bindPointer (FftLocalCells140.put (bodyState s a hn v fv bound w pw p0i)
    "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)))
    "r2".toList (elem a (hn+v+1))).arrays name = s.arrays name
  rw [StepCopyFixed190.bindPointer_arrays
    (bindPointer (FftLocalCells140.put (bodyState s a hn v fv bound w pw p0i)
      "u".toList (C99NatWord141.word (v+1))) "r1".toList (elem a (v+1)))
    "r2".toList (elem a (hn+v+1)) name second]
  rw [StepCopyFixed190.bindPointer_arrays
    (FftLocalCells140.put (bodyState s a hn v fv bound w pw p0i)
      "u".toList (C99NatWord141.word (v+1)))
    "r1".toList (elem a (v+1)) name first]
  rfl

theorem step_heap (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (stepState s a hn v fv bound w pw p0i).heap = bodyHeap s a hn v fv bound w pw p0i := rfl

theorem step_u (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    Cell (stepState s a hn v fv bound w pw p0i) "u".toList (v+1) :=
  FftLocalCells140.cell_at (bodyState s a hn v fv bound w pw p0i) "u".toList
    (C99NatWord141.word (v+1))

theorem step_r1 (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (stepState s a hn v fv bound w pw p0i).arrays "r1".toList = some (elem a (v+1)) := rfl

theorem step_r2 (s : State) (a : ArrayPointer) (hn v : Nat) (fv : Fin (2*hn) → BitVec 32)
    (bound : v < hn) (w pw p0i : BitVec 32) :
    (stepState s a hn v fv bound w pw p0i).arrays "r2".toList = some (elem a (hn+v+1)) := rfl

end FT1536.Source3.StepNttFirst195
