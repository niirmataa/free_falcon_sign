import Source3.NttInverseMiddleVLoop192
import Source3.NttInverseFinalPass192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The u1-group loop of the original intermediate doubling pass of the
   accepted modp_iNTT3_ext corpus at one round of the m loop: per group
   the executed s = igm[m+u1] load (the m+u1 index as the u64 add word),
   the r1 = a + v1*stride bind (the v1*stride product word) and the
   r1-relative r2 = r1 + ht*stride bind (the ht*stride product word),
   the closed radix-2 loop of the group and the u1/v1 two-clause
   increment (u1 += 1 through the counter cell, v1 += t through the t
   cell). The radix-2 execution is the closed NttInverseMiddleVLoop192
   work reused as an instance; vloop_keep below is the same induction
   with an added load-persistence component, required because the
   twiddle-table reads of the remaining groups and the raw words of the
   other groups must survive the writes of the current group. The
   exported image records the transformed group words as the executed
   word terms over the round input words and the loaded twiddle words;
   values stay executed words only. -/
namespace FT1536.Source3.NttInverseMiddleU1Loop192
open C99ArrayReference (State Name Pointer bindPointer bindValue restoreScope)
open C99MemoryReference (ArrayPointer Load32 PointerAdd)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrectionLoop192 (walk walk_index walk_count walk_width walk_step)
open NttInverseMiddleVLoop192 (lowWord highWord)

def u1Walk : C99ModularReference.Stmt :=
  .loop NttInversePrograms192.u1Guard NttInversePrograms192.u1Inner NttInversePrograms192.u1Step

def names : List Name := ["v".toList,"s".toList]

def declaredV (s : State) : State := C99DeclarationStatements.effect .u64 ["v".toList] s
def declaredS (s : State) : State := C99DeclarationStatements.effect .u32 ["s".toList] (declaredV s)
def withS (s : State) (tw : BitVec 32) : State := ModularAtoms178.set (declaredS s) "s" tw
def withR1 (s : State) (a : ArrayPointer) (stride v1 : Nat) (tw : BitVec 32) : State :=
  bindPointer (withS s tw) "r1".toList (walk a v1 stride)
def withR2 (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32) : State :=
  bindPointer (withR1 s a stride v1 tw) "r2".toList (walk a (v1+ht) stride)
def withV (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32) : State :=
  bindValue (withR2 s a stride v1 ht tw) "v".toList .uint64 (.int32 0)
def groupOut (s vo : State) : State := restoreScope s vo names []
def initial (s : State) : State :=
  bindValue (bindValue s "u1".toList .uint64 (.int32 0)) "v1".toList .uint64 (.int32 0)

/- Slot membership of the walked positions of one group; the group span
   2*ht fits its t slot. -/
def InSlot (t ht g x : Nat) : Prop := g*t ≤ x ∧ x < g*t+2*ht

theorem in_low (t ht g j : Nat) (bound : j < 2*ht) : InSlot t ht g (g*t+j) :=
  ⟨by omega,by omega⟩

theorem in_high (t ht g j : Nat) (bound : j < ht) : InSlot t ht g (g*t+ht+j) :=
  ⟨by omega,by omega⟩

theorem slot_upper (t ht m g : Nat) (span : 2*ht ≤ t) (slot : g < m) : g*t+2*ht ≤ m*t := by
  have edge : g*t+2*ht ≤ g*t+t := Nat.add_le_add_left span (g*t)
  have close : g*t+t = (g+1)*t := by rw [Nat.add_mul,Nat.one_mul]
  have step : (g+1)*t ≤ m*t := Nat.mul_le_mul_right t (Nat.succ_le_of_lt slot)
  calc g*t+2*ht ≤ g*t+t := edge
    _ = (g+1)*t := close
    _ ≤ m*t := step

theorem slot_order (t ht : Nat) (span : 2*ht ≤ t) (g g' x y : Nat)
    (left : InSlot t ht g x) (right : InSlot t ht g' y) (before : g < g') : x < y := by
  have edge : g*t+2*ht ≤ g*t+t := Nat.add_le_add_left span (g*t)
  have close : g*t+t = (g+1)*t := by rw [Nat.add_mul,Nat.one_mul]
  have step : (g+1)*t ≤ g'*t := Nat.mul_le_mul_right t (Nat.succ_le_of_lt before)
  have order : x < g'*t :=
    calc x < g*t+2*ht := left.2
      _ ≤ g*t+t := edge
      _ = (g+1)*t := close
      _ ≤ g'*t := step
  exact Nat.lt_of_lt_of_le order right.1

theorem slot_distinct (t ht : Nat) (span : 2*ht ≤ t) (g g' x y : Nat)
    (left : InSlot t ht g x) (right : InSlot t ht g' y) (different : g ≠ g') : x ≠ y := by
  intro same
  rcases Nat.lt_trichotomy g g' with order | impossible | order
  · exact absurd same (ne_of_lt (slot_order t ht span g g' x y left right order))
  · exact different impossible
  · exact absurd same (ne_of_gt (slot_order t ht span g' g y x right left order))

theorem walk_add (a : ArrayPointer) (stride j k : Nat) :
    {walk a j stride with index := (walk a j stride).index + k*stride} = walk a (j+k) stride :=
  congrArg (fun n : Nat => {walk a j stride with index := n})
    (show (walk a j stride).index + k*stride = (walk a (j+k) stride).index by
      rw [walk_index,walk_index]
      rw [Nat.add_mul]
      omega)

theorem effect_outside (ty : B20.C.Ty) (list : List Name) (s : State) (name : Name)
    (absent : name∉list) :
    (C99DeclarationStatements.effect ty list s).locals name=s.locals name :=
  StepProductBody191.cells_outside (C99ValueBridge.type ty) list s.locals name absent

theorem set_outside (s : State) (target : String) (other : Name) (w : BitVec 32)
    (different : other≠target.toList) :
    (ModularAtoms178.set s target w).locals other=s.locals other :=
  StepProductBody191.put32_outside s target.toList w other different

theorem setup_locals (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32)
    (name : Name) (first : name≠"v".toList) (second : name≠"s".toList) :
    (withV s a stride v1 ht tw).locals name=s.locals name := by
  have v : (withV s a stride v1 ht tw).locals name=
      (withR2 s a stride v1 ht tw).locals name := by
    simp only [withV,bindValue,C99ScalarReference.set,first,ite_false]
  have r2 : (withR2 s a stride v1 ht tw).locals name=(withR1 s a stride v1 tw).locals name := rfl
  have r1 : (withR1 s a stride v1 tw).locals name=(withS s tw).locals name := rfl
  have ss : (withS s tw).locals name=(declaredS s).locals name :=
    set_outside (declaredS s) "s" name tw second
  have ds : (declaredS s).locals name=(declaredV s).locals name :=
    effect_outside .u32 ["s".toList] (declaredV s) name
      (fun hit => second (by simpa using hit))
  have dv : (declaredV s).locals name=s.locals name :=
    effect_outside .u64 ["v".toList] s name
      (fun hit => first (by simpa using hit))
  exact v.trans (r2.trans (r1.trans (ss.trans (ds.trans dv))))

theorem setup_arrays (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32)
    (name : Name) (first : name≠"r1".toList) (second : name≠"r2".toList) :
    (withV s a stride v1 ht tw).arrays name=s.arrays name := by
  have v : (withV s a stride v1 ht tw).arrays name=
      (withR2 s a stride v1 ht tw).arrays name := rfl
  have r2 : (withR2 s a stride v1 ht tw).arrays name=(withR1 s a stride v1 tw).arrays name :=
    StepProductFixed191.bindPointer_arrays (withR1 s a stride v1 tw) "r2".toList
      (walk a (v1+ht) stride) name second
  have r1 : (withR1 s a stride v1 tw).arrays name=(withS s tw).arrays name :=
    StepProductFixed191.bindPointer_arrays (withS s tw) "r1".toList (walk a v1 stride) name first
  have rest : (withS s tw).arrays name=s.arrays name := rfl
  exact v.trans (r2.trans (r1.trans rest))

theorem setup_uslot (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32)
    (name : String) (n : Nat) (first : name.toList≠"v".toList) (second : name.toList≠"s".toList)
    (base : USlot s name n) : USlot (withV s a stride v1 ht tw) name n :=
  (setup_locals s a stride v1 ht tw name.toList first second).trans base

theorem setup_slot (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32)
    (name : String) (w : BitVec 32) (first : name.toList≠"v".toList)
    (second : name.toList≠"s".toList) (base : Slot s name w) :
    Slot (withV s a stride v1 ht tw) name w :=
  (setup_locals s a stride v1 ht tw name.toList first second).trans base

theorem s_declared (s : State) : (declaredS s).locals "s".toList=some (.uint32,none) := rfl

theorem v_fresh (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32) :
    (withR2 s a stride v1 ht tw).locals "v".toList=some (.uint64,none) := rfl

theorem group_vzero (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32) :
    Cell (withV s a stride v1 ht tw) "v".toList 0 := rfl

theorem group_r1 (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32) :
    (withV s a stride v1 ht tw).arrays "r1".toList=some (walk a (v1+0) stride) := rfl

theorem group_r2 (s : State) (a : ArrayPointer) (stride v1 ht : Nat) (tw : BitVec 32) :
    (withV s a stride v1 ht tw).arrays "r2".toList=some (walk a (v1+ht+0) stride) := rfl

/- Counter increments: u1 += 1 through the counter cell and v1 += t
   through the t cell. -/
theorem update_u1_run (s : State) (i : Nat) (bound : i<2^64) (cell : Cell s "u1".toList i) :
    C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u1".toList .add (NttInversePrograms192.num 1)))
      s (FftLocalCells140.put s "u1".toList (word (i+1))) := by
  cases C99LoopScalar141.increment (fun _ => none) s "u1".toList i bound cell with
  | base _ _ _ source => exact source

theorem update_v1_run (s : State) (a b : Nat) (boundA : a<2^64) (boundB : b<2^64)
    (cell : Cell s "v1".toList a) (tCell : USlot s "t" b) :
    C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "v1".toList .add (NttInversePrograms192.var "t")))
      s (FftLocalCells140.put s "v1".toList (word (a+b))) := by
  rw [FftLocalCells140.put_bind]
  refine .scalar s _ (.update "v1".toList .add (NttInversePrograms192.var "t")) ?_
  exact .assign s.locals "v1".toList _ .uint64 (some (.uint64 (word a))) (.uint64 (word (a+b)))
    cell (.arithmetic .plus _ _ _ _ _ (C99LoopScalar141.read s "v1".toList a cell)
      (C99LoopScalar141.read s "t".toList b tCell) (C99NatWord141.add a b boundA boundB))

theorem u1_guard_run (s : State) (i m : Nat) (iBound : i<2^64) (mBound : m<2^64)
    (u1Cell : USlot s "u1" i) (mCell : USlot s "m" m) :
    C99ArrayReference.scalar s NttInversePrograms192.u1Guard
      (C99ScalarReference.boolean (decide (i < m))) :=
  C99LoopScalar141.less s (NttInversePrograms192.var "u1") (NttInversePrograms192.var "m")
    i m iBound mBound (C99LoopScalar141.read s "u1".toList i u1Cell)
    (C99LoopScalar141.read s "m".toList m mCell)

/- The strengthened radix-2 instance: the closed
   NttInverseMiddleVLoop192.remaining induction plus load persistence
   outside the walked pair region of the group. All body, increment and
   transport steps are the closed NttInverseMiddleBody192 /
   NttInverseMiddleVLoop192 instances. -/
theorem vloop_keep (count i : Nat) (s : State) (a : ArrayPointer) (stride ht v1 : Nat)
    (p p0i tw : BitVec 32) (fv : Nat → BitVec 32)
    (fixed : NttInverseMiddleVLoop192.Fixed s a stride ht v1 p p0i tw fv)
    (vCell : Cell s "v".toList i)
    (r1Binding : s.arrays "r1".toList=some (walk a (v1+i) stride))
    (r2Binding : s.arrays "r2".toList=some (walk a (v1+ht+i) stride))
    (image : NttInverseMiddleVLoop192.Image s a stride ht v1 tw p p0i fv i) (finish : i+count=ht) :
    ∃ after, Exec NttInverseMiddleVLoop192.vWalk s ⟨after,.normal⟩ ∧
      NttInverseMiddleVLoop192.Image after a stride ht v1 tw p p0i fv ht ∧
      (∀ name : Name, name ≠ "v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name ≠ "r1".toList → name ≠ "r2".toList → after.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, v1 ≤ x → x < v1+2*ht → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) ∧
      after.heap.writable=s.heap.writable := by
  induction count generalizing i s with
  | zero =>
    have equal : i=ht := by omega
    subst i
    have false : C99ArrayReference.scalar s NttInversePrograms192.vGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        NttInverseMiddleVLoop192.guard_run s a stride ht v1 ht p p0i tw fv fixed fixed.htBound vCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),image,
      fun _ _ => rfl,fun _ _ _ => rfl,fun _ _ _ => id,rfl⟩
  | succ count ih =>
    have slot : i < ht := by omega
    have iBound : i < 2^64 := by have := fixed.htBound; omega
    have nonzero : (C99ScalarReference.boolean (decide (i < ht))).integer ≠ 0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    have body : Exec NttInversePrograms192.vBody s
        ⟨NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i,.normal⟩ :=
      NttInverseMiddleBody192.body_run s a stride (v1+i) (v1+ht+i) p p0i tw (fv (v1+i)) (fv (v1+ht+i))
        fixed.pCell fixed.iCell fixed.sCell r1Binding r2Binding
        ((image i slot).2 (Nat.le_refl i)).1 ((image i slot).2 (Nat.le_refl i)).2
        fixed.aWidth fixed.aWritable
    have bodyFixed : NttInverseMiddleVLoop192.Fixed
        (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride ht v1 p p0i tw fv :=
      NttInverseMiddleVLoop192.output_fixed s a stride ht v1 i p p0i tw fv
        (fv (v1+i)) (fv (v1+ht+i)) fixed
    have bodyImage : NttInverseMiddleVLoop192.Image
        (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride ht v1 tw p p0i fv (i+1) :=
      NttInverseMiddleVLoop192.output_image s a stride ht v1 i p p0i tw fv fixed slot image
    have update : Exec NttInversePrograms192.vStep
        (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i)
        ⟨NttInverseMiddleBody192.next (NttInverseMiddleBody192.output s a stride (v1+i)
          (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i,.normal⟩ :=
      NttInverseMiddleBody192.inc_run (NttInverseMiddleBody192.output s a stride (v1+i)
          (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i
        ((NttInverseMiddleVLoop192.out_local s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i "stride".toList).trans fixed.strideCell)
        fixed.strideBound
        ((NttInverseMiddleVLoop192.out_local s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i "v".toList).trans vCell)
        iBound
        ((NttInverseMiddleVLoop192.out_array s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i "r1".toList).trans r1Binding)
        ((NttInverseMiddleVLoop192.out_array s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i "r2".toList).trans r2Binding)
        (NttInverseMiddleVLoop192.step_capacity bodyFixed i slot).1
        (NttInverseMiddleVLoop192.step_capacity bodyFixed i slot).2
    set tail : State :=
      NttInverseMiddleBody192.next (NttInverseMiddleBody192.output s a stride (v1+i)
        (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i with tailEq
    have tailFixed : NttInverseMiddleVLoop192.Fixed tail a stride ht v1 p p0i tw fv := by
      rw [tailEq]
      exact NttInverseMiddleVLoop192.next_fixed (NttInverseMiddleBody192.output s a stride (v1+i)
        (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride ht v1 i p p0i tw fv bodyFixed
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
    have tailImage : NttInverseMiddleVLoop192.Image tail a stride ht v1 tw p p0i fv (i+1) := by
      rw [tailEq]
      intro j jBound
      have heap : (NttInverseMiddleBody192.next (NttInverseMiddleBody192.output s a stride
          (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i).heap=
          (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
            (fv (v1+i)) (fv (v1+ht+i)) tw p p0i).heap := rfl
      constructor
      · intro position
        rw [heap]
        exact (bodyImage j jBound).1 position
      · intro position
        rw [heap]
        exact (bodyImage j jBound).2 position
    have tailKeep : ∀ q : ArrayPointer,
        (∀ x : Nat, v1 ≤ x → x < v1+2*ht → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 tail.heap q w := by
      intro q qSep w loaded
      have heap : tail.heap=
          Word32Memory176.write
            (Word32Memory176.write s.heap (walk a (v1+i) stride)
              (NttInverseMiddleBody192.bb (fv (v1+i)) (fv (v1+ht+i)) p))
            (walk a (v1+ht+i) stride)
            (NttInverseMiddleBody192.high (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) := by
        rw [tailEq]
        rfl
      rw [heap]
      have lowSep : Separate (walk a (v1+i) stride) q := qSep (v1+i) (by omega) (by omega)
      have highSep : Separate (walk a (v1+ht+i) stride) q := qSep (v1+ht+i) (by omega) (by omega)
      exact Word32Memory176.outside _ (walk a (v1+ht+i) stride) q _ w highSep
        (Word32Memory176.outside _ (walk a (v1+i) stride) q _ w lowSep loaded)
    have tailWritable : tail.heap.writable=s.heap.writable := by
      rw [tailEq]
      rfl
    obtain ⟨after,rest,finalImage,finalLocals,finalArrays,finalKeep,finalWritable⟩ :=
      ih (i+1) tail tailFixed tailCell tailR1 tailR2 tailImage (by omega)
    refine ⟨after,?_,finalImage,?_,?_,?_,?_⟩
    · refine .loopNormal _ _ _ s
        (NttInverseMiddleBody192.output s a stride (v1+i) (v1+ht+i)
          (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) tail ⟨after,.normal⟩
        (C99ScalarReference.boolean (decide (i < ht))) ?_ nonzero body update rest
      exact NttInverseMiddleVLoop192.guard_run s a stride ht v1 i p p0i tw fv fixed iBound vCell
    · intro name different
      have first : tail.locals name=s.locals name := by
        rw [tailEq]
        exact (NttInverseMiddleVLoop192.next_locals (NttInverseMiddleBody192.output s a stride
          (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i
          name different).trans
          (NttInverseMiddleVLoop192.out_local s a stride (v1+i) (v1+ht+i)
            (fv (v1+i)) (fv (v1+ht+i)) tw p p0i name)
      exact (finalLocals name different).trans first
    · intro name first second
      have kept : tail.arrays name=s.arrays name := by
        rw [tailEq]
        exact (NttInverseMiddleVLoop192.next_arrays (NttInverseMiddleBody192.output s a stride
          (v1+i) (v1+ht+i) (fv (v1+i)) (fv (v1+ht+i)) tw p p0i) a stride (v1+i) (v1+ht+i) i
          name first second).trans
          (NttInverseMiddleVLoop192.out_array s a stride (v1+i) (v1+ht+i)
            (fv (v1+i)) (fv (v1+ht+i)) tw p p0i name)
      exact (finalArrays name first second).trans kept
    · intro q qSep w loaded
      exact finalKeep q qSep w (tailKeep q qSep w loaded)
    · exact finalWritable.trans tailWritable

/- Round image: group g < i holds the transformed word pair of the
   executed butterfly words over the round input words and the group
   twiddle word; the remaining groups hold their raw input words. -/
def Image (s : State) (a : ArrayPointer) (stride t ht m : Nat) (tws : Nat → BitVec 32)
    (p p0i : BitVec 32) (fv : Nat → BitVec 32) (i : Nat) : Prop :=
  ∀ g j : Nat, g < m → j < ht →
    ((g < i → Load32 s.heap (walk a (g*t+j) stride) (lowWord fv (g*t) ht j p) ∧
              Load32 s.heap (walk a (g*t+ht+j) stride) (highWord fv (g*t) ht j (tws g) p p0i)) ∧
     (i ≤ g → Load32 s.heap (walk a (g*t+j) stride) (fv (g*t+j)) ∧
              Load32 s.heap (walk a (g*t+ht+j) stride) (fv (g*t+ht+j))))

structure Fixed (s : State) (a igm : ArrayPointer) (stride t ht m : Nat) (p p0i : BitVec 32)
    (tws : Nat → BitVec 32) (fv : Nat → BitVec 32) : Prop where
  tBound : t < 2^64
  htBound : ht < 2^64
  mBound : m < 2^64
  strideBound : stride < 2^64
  htPositive : 0 < ht
  span : 2*ht ≤ t
  wideT : m*t < 2^64
  wideV : m*t*stride < 2^64
  wideHt : ht*stride < 2^64
  wideM : m+m < 2^64
  aWidth : a.elementBytes=4
  aCapacity : a.index+(m*t)*stride ≤ a.count
  aWritable : s.heap.writable a.block=true
  igmCapacity : igm.index+(m+m) ≤ igm.count
  tCell : USlot s "t" t
  htCell : USlot s "ht" ht
  mCell : USlot s "m" m
  strideCell : USlot s "stride" stride
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  aBinding : s.arrays "a".toList=some a
  igmBinding : s.arrays "igm".toList=some igm
  separate : ∀ j k : Nat, j < m*t → k < m*t → j ≠ k → Separate (walk a j stride) (walk a k stride)
  twSeparate : ∀ g : Nat, g < m → ∀ j : Nat, j < m*t →
    Separate (walk a j stride) ({igm with index := igm.index+(m+g)})
  twLoads : ∀ g : Nat, g < m → Load32 s.heap ({igm with index := igm.index+(m+g)}) (tws g)

theorem setup_fixed (s : State) (a igm : ArrayPointer) (stride t ht m g : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a igm stride t ht m p p0i tws fv) (slot : g < m) :
    NttInverseMiddleVLoop192.Fixed (withV s a stride (g*t) ht (tws g))
      a stride ht (g*t) p p0i (tws g) fv where
  htBound := fixed.htBound
  htPositive := fixed.htPositive
  strideBound := fixed.strideBound
  aWidth := fixed.aWidth
  aCapacity := by
    have bound := slot_upper t ht m g fixed.span slot
    have steps : (g*t+2*ht)*stride ≤ (m*t)*stride := Nat.mul_le_mul_right stride bound
    have grows : a.index+(g*t+2*ht)*stride ≤ a.index+(m*t)*stride :=
      Nat.add_le_add_left steps a.index
    exact Nat.le_trans grows fixed.aCapacity
  aWritable := fixed.aWritable
  htCell := setup_uslot s a stride (g*t) ht (tws g) "ht" ht (by decide) (by decide) fixed.htCell
  strideCell := setup_uslot s a stride (g*t) ht (tws g) "stride" stride (by decide) (by decide)
    fixed.strideCell
  pCell := setup_slot s a stride (g*t) ht (tws g) "p" p (by decide) (by decide) fixed.pCell
  iCell := setup_slot s a stride (g*t) ht (tws g) "p0i" p0i (by decide) (by decide) fixed.iCell
  sCell := ModularAtoms178.slot (declaredS s) "s" (tws g)
  separate := fun j k first second different => fixed.separate j k
    (Nat.lt_of_lt_of_le first (slot_upper t ht m g fixed.span slot))
    (Nat.lt_of_lt_of_le second (slot_upper t ht m g fixed.span slot)) different

theorem group_raw (s : State) (a : ArrayPointer) (stride t ht m : Nat) (tws : Nat → BitVec 32)
    (p p0i : BitVec 32) (fv : Nat → BitVec 32) (g : Nat) (slot : g < m)
    (image : Image s a stride t ht m tws p p0i fv g) :
    NttInverseMiddleVLoop192.Image (withV s a stride (g*t) ht (tws g))
      a stride ht (g*t) (tws g) p p0i fv 0 := by
  intro j jBound
  constructor
  · intro impossible
    exact absurd impossible (Nat.not_lt_zero j)
  · intro _
    exact (image g j slot jBound).2 (Nat.le_refl g)

/- One u1-group body: declarations, the s = igm[m+u1] load, the two
   product binds, the v = 0 initialization, the group radix-2 loop and
   the trailing skip, closed under the block scope. -/
theorem group_run (s : State) (a igm : ArrayPointer) (stride t ht m g : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a igm stride t ht m p p0i tws fv) (slot : g < m)
    (u1Cell : USlot s "u1" g) (v1Cell : USlot s "v1" (g*t))
    (image : Image s a stride t ht m tws p p0i fv g) :
    ∃ vo, Exec NttInversePrograms192.u1Inner s ⟨groupOut s vo,.normal⟩ ∧
      Image (groupOut s vo) a stride t ht m tws p p0i fv (g+1) ∧
      Fixed (groupOut s vo) a igm stride t ht m p p0i tws fv ∧
      USlot (groupOut s vo) "u1" g ∧ USlot (groupOut s vo) "v1" (g*t) ∧
      (groupOut s vo).heap.writable=s.heap.writable ∧
      (∀ q : ArrayPointer, (∀ x : Nat, g*t ≤ x → x < g*t+2*ht →
        Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 (groupOut s vo).heap q w) := by
  have gBound : g < 2^64 := by have := fixed.mBound; omega
  have productBound : g*t < 2^64 :=
    Nat.lt_of_le_of_lt (Nat.mul_le_mul_right t (Nat.le_of_lt slot)) fixed.wideT
  have vProduct : (g*t)*stride < 2^64 :=
    Nat.lt_of_le_of_lt
      (Nat.mul_le_mul_right stride (Nat.mul_le_mul_right t (Nat.le_of_lt slot))) fixed.wideV
  have indexBound : m+g < 2^64 := by have := fixed.wideM; omega
  have capacity : a.index+(g*t)*stride ≤ a.count := by
    have steps : (g*t)*stride ≤ (m*t)*stride :=
      Nat.mul_le_mul_right stride (Nat.mul_le_mul_right t (Nat.le_of_lt slot))
    have grows : a.index+(g*t)*stride ≤ a.index+(m*t)*stride := Nat.add_le_add_left steps a.index
    exact Nat.le_trans grows fixed.aCapacity
  have igmIndex : igm.index+(m+g) ≤ igm.count := by
    have := fixed.igmCapacity
    omega
  have v1At : USlot (withS s (tws g)) "v1" (g*t) :=
    (set_outside (declaredS s) "s" "v1".toList (tws g) (by decide)).trans
      ((effect_outside .u32 ["s".toList] (declaredV s) "v1".toList (by decide)).trans
        ((effect_outside .u64 ["v".toList] s "v1".toList (by decide)).trans v1Cell))
  have strideAt : USlot (withS s (tws g)) "stride" stride :=
    (set_outside (declaredS s) "s" "stride".toList (tws g) (by decide)).trans
      ((effect_outside .u32 ["s".toList] (declaredV s) "stride".toList (by decide)).trans
        ((effect_outside .u64 ["v".toList] s "stride".toList (by decide)).trans
          fixed.strideCell))
  have htAt : USlot (withS s (tws g)) "ht" ht :=
    (set_outside (declaredS s) "s" "ht".toList (tws g) (by decide)).trans
      ((effect_outside .u32 ["s".toList] (declaredV s) "ht".toList (by decide)).trans
        ((effect_outside .u64 ["v".toList] s "ht".toList (by decide)).trans fixed.htCell))
  have mAt : USlot (declaredS s) "m" m :=
    (effect_outside .u32 ["s".toList] (declaredV s) "m".toList (by decide)).trans
      ((effect_outside .u64 ["v".toList] s "m".toList (by decide)).trans fixed.mCell)
  have u1At : USlot (declaredS s) "u1" g :=
    (effect_outside .u32 ["s".toList] (declaredV s) "u1".toList (by decide)).trans
      ((effect_outside .u64 ["v".toList] s "u1".toList (by decide)).trans u1Cell)
  have indexRead : C99ArrayReference.scalar (declaredS s)
      (.bin .add (NttInversePrograms192.var "m") (NttInversePrograms192.var "u1"))
      (.uint64 (word (m+g))) :=
    C99LoopScalar141.add (declaredS s) (NttInversePrograms192.var "m")
      (NttInversePrograms192.var "u1") m g fixed.mBound gBound
      (C99LoopScalar141.read (declaredS s) "m".toList m mAt)
      (C99LoopScalar141.read (declaredS s) "u1".toList g u1At)
  have table : Pointer (declaredS s) "igm".toList
      (.bin .add (NttInversePrograms192.var "m") (NttInversePrograms192.var "u1"))
      ({igm with index := igm.index+(m+g)}) := by
    refine .add _ _ igm {igm with index := igm.index+(m+g)} (.uint64 (word (m+g)))
      fixed.igmBinding indexRead ?_ ?_
    · rw [C99NatWord141.integer (m+g) indexBound]
      omega
    · rw [C99NatWord141.integer (m+g) indexBound]
      exact .within igm (m+g) igmIndex
  have tableRead : Load32 (declaredS s).heap ({igm with index := igm.index+(m+g)}) (tws g) :=
    fixed.twLoads g slot
  have loadRun : Exec NttInversePrograms192.sAssign (declaredS s) ⟨withS s (tws g),.normal⟩ :=
    ModularAtoms178.assign (declaredS s) "s" none
      (NttInversePrograms192.read "igm"
        (.bin .add (NttInversePrograms192.var "m") (NttInversePrograms192.var "u1")))
      (tws g) (s_declared s)
      (.load32 "igm".toList
        (.bin .add (NttInversePrograms192.var "m") (NttInversePrograms192.var "u1"))
        ({igm with index := igm.index+(m+g)}) (tws g) table tableRead)
  have index1 : C99ArrayReference.scalar (withS s (tws g))
      (.bin .mul (NttInversePrograms192.var "v1") (NttInversePrograms192.var "stride"))
      (.uint64 (word ((g*t)*stride))) :=
    .arithmetic .times _ _ _ _ _
      (C99LoopScalar141.read (withS s (tws g)) "v1".toList (g*t) v1At)
      (C99LoopScalar141.read (withS s (tws g)) "stride".toList stride strideAt)
      (NttInverseFinalPass192.word_mul (g*t) stride productBound fixed.strideBound)
  have r1Run : Exec NttInversePrograms192.v1Bind (withS s (tws g))
      ⟨withR1 s a stride (g*t) (tws g),.normal⟩ := by
    have address : Pointer (withS s (tws g)) "a".toList
        (.bin .mul (NttInversePrograms192.var "v1") (NttInversePrograms192.var "stride"))
        (walk a (g*t) stride) := by
      refine .add _ _ a (walk a (g*t) stride) (.uint64 (word ((g*t)*stride)))
        fixed.aBinding index1 ?_ ?_
      · rw [C99NatWord141.integer ((g*t)*stride) vProduct]
        omega
      · rw [C99NatWord141.integer ((g*t)*stride) vProduct]
        exact .within a ((g*t)*stride) capacity
    exact .base _ _ _ (.bindPtr _ _ _ _ (walk a (g*t) stride) address)
  have r1Bind : (withR1 s a stride (g*t) (tws g)).arrays "r1".toList=some (walk a (g*t) stride) :=
    rfl
  have index2 : C99ArrayReference.scalar (withR1 s a stride (g*t) (tws g))
      (.bin .mul (NttInversePrograms192.var "ht") (NttInversePrograms192.var "stride"))
      (.uint64 (word (ht*stride))) :=
    .arithmetic .times _ _ _ _ _
      (C99LoopScalar141.read (withR1 s a stride (g*t) (tws g)) "ht".toList ht htAt)
      (C99LoopScalar141.read (withR1 s a stride (g*t) (tws g)) "stride".toList stride strideAt)
      (NttInverseFinalPass192.word_mul ht stride fixed.htBound fixed.strideBound)
  have walked : PointerAdd (walk a (g*t) stride) (ht*stride)
      {walk a (g*t) stride with index := (walk a (g*t) stride).index + ht*stride} := by
    refine .within (walk a (g*t) stride) (ht*stride) ?_
    rw [walk_index,walk_count]
    have edge : g*t+ht ≤ g*t+t := Nat.add_le_add_left (by have := fixed.span; omega) (g*t)
    have close : g*t+t = (g+1)*t := by rw [Nat.add_mul,Nat.one_mul]
    have step : (g+1)*t ≤ m*t := Nat.mul_le_mul_right t (Nat.succ_le_of_lt slot)
    have span : g*t+ht ≤ m*t :=
      calc g*t+ht ≤ g*t+t := edge
        _ = (g+1)*t := close
        _ ≤ m*t := step
    have bound : (g*t+ht)*stride ≤ (m*t)*stride := Nat.mul_le_mul_right stride span
    have product : (g*t)*stride + ht*stride = (g*t+ht)*stride := by rw [Nat.add_mul]
    have grow : a.index+((g*t)*stride + ht*stride) ≤ a.count := by
      rw [product]
      exact Nat.le_trans (Nat.add_le_add_left bound a.index) fixed.aCapacity
    rw [Nat.add_assoc]
    exact grow
  have walkedFinal : PointerAdd (walk a (g*t) stride) (ht*stride) (walk a (g*t+ht) stride) := by
    rw [← walk_add a stride (g*t) ht]
    exact walked
  have r2Run : Exec NttInversePrograms192.htBind (withR1 s a stride (g*t) (tws g))
      ⟨withR2 s a stride (g*t) ht (tws g),.normal⟩ := by
    have address : Pointer (withR1 s a stride (g*t) (tws g)) "r1".toList
        (.bin .mul (NttInversePrograms192.var "ht") (NttInversePrograms192.var "stride"))
        (walk a (g*t+ht) stride) := by
      refine .add _ _ (walk a (g*t) stride) (walk a (g*t+ht) stride)
        (.uint64 (word (ht*stride))) r1Bind index2 ?_ ?_
      · rw [C99NatWord141.integer (ht*stride) fixed.wideHt]
        omega
      · rw [C99NatWord141.integer (ht*stride) fixed.wideHt]
        exact walkedFinal
    exact .base _ _ _ (.bindPtr _ _ _ _ (walk a (g*t+ht) stride) address)
  have initRun : Exec NttInversePrograms192.vInit (withR2 s a stride (g*t) ht (tws g))
      ⟨withV s a stride (g*t) ht (tws g),.normal⟩ :=
    .assign _ _ _ .uint64 none (.int32 0) (v_fresh s a stride (g*t) ht (tws g))
      (.scalar _ _ (.literal .int32 0))
  obtain ⟨vo,vRun,vImage,vLocals,vArrays,vKeep,vWritable⟩ :=
    vloop_keep ht 0 (withV s a stride (g*t) ht (tws g)) a stride ht (g*t) p p0i (tws g) fv
      (setup_fixed s a igm stride t ht m g p p0i tws fv fixed slot)
      (group_vzero s a stride (g*t) ht (tws g)) (group_r1 s a stride (g*t) ht (tws g))
      (group_r2 s a stride (g*t) ht (tws g))
      (group_raw s a stride t ht m tws p p0i fv g slot image) (by omega)
  have vLoopRun : Exec NttInversePrograms192.vLoop (withR2 s a stride (g*t) ht (tws g))
      ⟨vo,.normal⟩ :=
    .seqNormal _ _ (withR2 s a stride (g*t) ht (tws g)) (withV s a stride (g*t) ht (tws g))
      ⟨vo,.normal⟩ initRun vRun
  have skipRun : Exec (.seq NttInversePrograms192.vLoop (.base .skip))
      (withR2 s a stride (g*t) ht (tws g)) ⟨vo,.normal⟩ :=
    .seqNormal _ _ (withR2 s a stride (g*t) ht (tws g)) vo ⟨vo,.normal⟩ vLoopRun
      (.base _ _ _ (.skip vo))
  have htRun : Exec (.seq NttInversePrograms192.htBind
      (.seq NttInversePrograms192.vLoop (.base .skip)))
      (withR1 s a stride (g*t) (tws g)) ⟨vo,.normal⟩ :=
    .seqNormal _ _ (withR1 s a stride (g*t) (tws g)) (withR2 s a stride (g*t) ht (tws g))
      ⟨vo,.normal⟩ r2Run skipRun
  have v1Run : Exec (.seq NttInversePrograms192.v1Bind
      (.seq NttInversePrograms192.htBind (.seq NttInversePrograms192.vLoop (.base .skip))))
      (withS s (tws g)) ⟨vo,.normal⟩ :=
    .seqNormal _ _ (withS s (tws g)) (withR1 s a stride (g*t) (tws g)) ⟨vo,.normal⟩ r1Run htRun
  have sRun : Exec (.seq NttInversePrograms192.sAssign
      (.seq NttInversePrograms192.v1Bind
        (.seq NttInversePrograms192.htBind (.seq NttInversePrograms192.vLoop (.base .skip)))))
      (declaredS s) ⟨vo,.normal⟩ :=
    .seqNormal _ _ (declaredS s) (withS s (tws g)) ⟨vo,.normal⟩ loadRun v1Run
  have sDecl : Exec (.seq (NttInversePrograms192.declareU32 ["s"])
      (.seq NttInversePrograms192.sAssign
        (.seq NttInversePrograms192.v1Bind
          (.seq NttInversePrograms192.htBind (.seq NttInversePrograms192.vLoop (.base .skip))))))
      (declaredV s) ⟨vo,.normal⟩ :=
    .seqNormal _ _ (declaredV s) (declaredS s) ⟨vo,.normal⟩
      (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
        ["s".toList] (declaredV s))) sRun
  have inner : Exec (.seq (NttInversePrograms192.declareU64 ["v"])
      (.seq (NttInversePrograms192.declareU32 ["s"])
        (.seq NttInversePrograms192.sAssign
          (.seq NttInversePrograms192.v1Bind
            (.seq NttInversePrograms192.htBind (.seq NttInversePrograms192.vLoop (.base .skip)))))))
      s ⟨vo,.normal⟩ :=
    .seqNormal _ _ s (declaredV s) ⟨vo,.normal⟩
      (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64
        ["v".toList] s)) sDecl
  have bodyRun : Exec NttInversePrograms192.u1Inner s ⟨groupOut s vo,.normal⟩ :=
    .scope names _ s ⟨vo,.normal⟩ inner
  have groupLocals : ∀ name : Name, name ∉ names →
      (groupOut s vo).locals name=s.locals name := by
    intro name absent
    have restore : (groupOut s vo).locals name=
        (if names.contains name then s.locals name else vo.locals name) := rfl
    rw [restore]
    have kept : ¬ names.contains name=true := by
      intro hit
      exact absent (List.contains_iff_mem.mp hit)
    simp only [kept]
    have first : name ≠ "v".toList := by
      intro same
      exact absent (by simp [names,same])
    have second : name ≠ "s".toList := by
      intro same
      exact absent (by simp [names,same])
    exact (vLocals name first).trans (setup_locals s a stride (g*t) ht (tws g) name first second)
  have groupArrays : ∀ name : Name, name ≠ "r1".toList → name ≠ "r2".toList →
      (groupOut s vo).arrays name=s.arrays name := by
    intro name first second
    have restore : (groupOut s vo).arrays name=vo.arrays name := rfl
    rw [restore]
    exact (vArrays name first second).trans
      (setup_arrays s a stride (g*t) ht (tws g) name first second)
  refine ⟨vo,bodyRun,?_,?_,?_,?_,?_,?_⟩
  · intro g' j slot' jBound
    by_cases same : g'=g
    · subst same
      constructor
      · intro _
        exact (vImage j jBound).1 (by omega)
      · intro impossible
        omega
    · have separateLow : ∀ x : Nat, g*t ≤ x → x < g*t+2*ht →
          Separate (walk a x stride) (walk a (g'*t+j) stride) := by
        intro x first second
        exact fixed.separate x (g'*t+j)
          (Nat.lt_of_lt_of_le second (slot_upper t ht m g fixed.span slot))
          (Nat.lt_of_lt_of_le (by omega : g'*t+j < g'*t+2*ht)
            (slot_upper t ht m g' fixed.span slot'))
          (slot_distinct t ht fixed.span g g' x (g'*t+j)
            ⟨first,second⟩ (in_low t ht g' j (by omega)) (Ne.symm same))
      have separateHigh : ∀ x : Nat, g*t ≤ x → x < g*t+2*ht →
          Separate (walk a x stride) (walk a (g'*t+ht+j) stride) := by
        intro x first second
        exact fixed.separate x (g'*t+ht+j)
          (Nat.lt_of_lt_of_le second (slot_upper t ht m g fixed.span slot))
          (Nat.lt_of_lt_of_le (by omega : g'*t+ht+j < g'*t+2*ht)
            (slot_upper t ht m g' fixed.span slot'))
          (slot_distinct t ht fixed.span g g' x (g'*t+ht+j)
            ⟨first,second⟩ (in_high t ht g' j jBound) (Ne.symm same))
      constructor
      · intro before
        obtain ⟨low,high⟩ := (image g' j slot' jBound).1
          (Nat.lt_of_le_of_ne (Nat.le_of_lt_succ before) same)
        exact ⟨vKeep _ separateLow _ low,vKeep _ separateHigh _ high⟩
      · intro after
        obtain ⟨low,high⟩ := (image g' j slot' jBound).2
          (Nat.le_of_lt (Nat.lt_of_succ_le after))
        exact ⟨vKeep _ separateLow _ low,vKeep _ separateHigh _ high⟩
  · refine Fixed.mk ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_
    · exact fixed.tBound
    · exact fixed.htBound
    · exact fixed.mBound
    · exact fixed.strideBound
    · exact fixed.htPositive
    · exact fixed.span
    · exact fixed.wideT
    · exact fixed.wideV
    · exact fixed.wideHt
    · exact fixed.wideM
    · exact fixed.aWidth
    · exact fixed.aCapacity
    · show (groupOut s vo).heap.writable a.block=true
      have writable : (groupOut s vo).heap.writable=vo.heap.writable := rfl
      rw [writable,vWritable]
      exact fixed.aWritable
    · exact fixed.igmCapacity
    · exact (groupLocals "t".toList (by simp [names])).trans fixed.tCell
    · exact (groupLocals "ht".toList (by simp [names])).trans fixed.htCell
    · exact (groupLocals "m".toList (by simp [names])).trans fixed.mCell
    · exact (groupLocals "stride".toList (by simp [names])).trans fixed.strideCell
    · exact (groupLocals "p".toList (by simp [names])).trans fixed.pCell
    · exact (groupLocals "p0i".toList (by simp [names])).trans fixed.iCell
    · exact (groupArrays "a".toList (by decide) (by decide)).trans fixed.aBinding
    · exact (groupArrays "igm".toList (by decide) (by decide)).trans fixed.igmBinding
    · exact fixed.separate
    · exact fixed.twSeparate
    · intro gg ggSlot
      show Load32 (groupOut s vo).heap {igm with index := igm.index+(m+gg)} (tws gg)
      have writable : (groupOut s vo).heap=vo.heap := rfl
      rw [writable]
      exact vKeep {igm with index := igm.index+(m+gg)}
        (fun x _ second => fixed.twSeparate gg ggSlot x
          (Nat.lt_of_lt_of_le second (slot_upper t ht m g fixed.span slot)))
        (tws gg) (fixed.twLoads gg ggSlot)
  · exact (groupLocals "u1".toList (by simp [names])).trans u1Cell
  · exact (groupLocals "v1".toList (by simp [names])).trans v1Cell
  · show (groupOut s vo).heap.writable=s.heap.writable
    have keep : (groupOut s vo).heap.writable=vo.heap.writable := rfl
    rw [keep]
    exact vWritable
  · intro q qSep w loaded
    exact vKeep q qSep w loaded

/- The complete u1-group loop of one round: u1/v1 initialization, the
   m iterations of the group body with the u1/v1 two-clause increment,
   and the final state export. -/
theorem remaining (count i : Nat) (s : State) (a igm : ArrayPointer) (stride t ht m : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a igm stride t ht m p p0i tws fv)
    (u1Cell : USlot s "u1" i) (v1Cell : USlot s "v1" (i*t))
    (image : Image s a stride t ht m tws p p0i fv i) (finish : i+count=m) :
    ∃ after, Exec u1Walk s ⟨after,.normal⟩ ∧
      Fixed after a igm stride t ht m p p0i tws fv ∧
      USlot after "u1" m ∧ USlot after "v1" (m*t) ∧
      Image after a stride t ht m tws p p0i fv m ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < m*t → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) ∧
      after.heap.writable=s.heap.writable := by
  induction count generalizing i s with
  | zero =>
    have equal : i=m := by omega
    subst i
    have false : C99ArrayReference.scalar s NttInversePrograms192.u1Guard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        u1_guard_run s m m fixed.mBound fixed.mBound u1Cell fixed.mCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) false (by decide),fixed,u1Cell,v1Cell,image,
      fun _ _ _ => id,rfl⟩
  | succ count ih =>
    have slot : i < m := by omega
    have iBound : i < 2^64 := by have := fixed.mBound; omega
    have nonzero : (C99ScalarReference.boolean (decide (i < m))).integer ≠ 0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    obtain ⟨vo,groupExec,groupImage,groupFixed,groupU1,groupV1,groupW,groupKeep⟩ :=
      group_run s a igm stride t ht m i p p0i tws fv fixed slot u1Cell v1Cell image
    have u1At : Cell (groupOut s vo) "u1".toList i := groupU1
    have incU1 : C99ArrayReference.Exec FftLeafPrograms.program
        (.scalar (.update "u1".toList .add (NttInversePrograms192.num 1)))
        (groupOut s vo) (FftLocalCells140.put (groupOut s vo) "u1".toList (word (i+1))) :=
      update_u1_run (groupOut s vo) i iBound u1At
    set mid : State := FftLocalCells140.put (groupOut s vo) "u1".toList (word (i+1)) with midEq
    have tAt : USlot mid "t" t := by
      rw [midEq]
      exact (FftLocalCells140.outside (groupOut s vo) "u1".toList "t".toList (word (i+1))
        (by decide)).trans groupFixed.tCell
    have v1At : USlot mid "v1" (i*t) := by
      rw [midEq]
      exact (FftLocalCells140.outside (groupOut s vo) "u1".toList "v1".toList (word (i+1))
        (by decide)).trans groupV1
    have v1Bound : i*t < 2^64 :=
      Nat.lt_of_le_of_lt (Nat.mul_le_mul_right t (Nat.le_of_lt slot)) fixed.wideT
    have incV1 : C99ArrayReference.Exec FftLeafPrograms.program
        (.scalar (.update "v1".toList .add (NttInversePrograms192.var "t")))
        mid (FftLocalCells140.put mid "v1".toList (word (i*t+t))) :=
      update_v1_run mid (i*t) t v1Bound fixed.tBound v1At tAt
    set next : State := FftLocalCells140.put mid "v1".toList (word (i*t+t)) with nextEq
    have stepRun : Exec NttInversePrograms192.u1Step (groupOut s vo) ⟨next,.normal⟩ :=
      .seqNormal _ _ (groupOut s vo) mid ⟨next,.normal⟩ (.base _ _ _ incU1) (.base _ _ _ incV1)
    have nextU1 : USlot next "u1" (i+1) := by
      rw [nextEq,midEq]
      exact (FftLocalCells140.outside _ "v1".toList "u1".toList (word (i*t+t)) (by decide)).trans
        (FftLocalCells140.cell_at (groupOut s vo) "u1".toList (word (i+1)))
    have nextV1 : USlot next "v1" ((i+1)*t) := by
      have base : USlot (FftLocalCells140.put mid "v1".toList (word (i*t+t))) "v1" (i*t+t) :=
        FftLocalCells140.cell_at mid "v1".toList (word (i*t+t))
      have e : i*t+t = (i+1)*t := by rw [Nat.add_mul,Nat.one_mul]
      rw [nextEq,← e]
      exact base
    have nextFixed : Fixed next a igm stride t ht m p p0i tws fv :=
      { tBound := groupFixed.tBound,
        htBound := groupFixed.htBound,
        mBound := groupFixed.mBound,
        strideBound := groupFixed.strideBound,
        htPositive := groupFixed.htPositive,
        span := groupFixed.span,
        wideT := groupFixed.wideT,
        wideV := groupFixed.wideV,
        wideHt := groupFixed.wideHt,
        wideM := groupFixed.wideM,
        aWidth := groupFixed.aWidth,
        aCapacity := groupFixed.aCapacity,
        aWritable := groupFixed.aWritable,
        igmCapacity := groupFixed.igmCapacity,
        tCell := (FftLocalCells140.outside mid "v1".toList "t".toList (word (i*t+t))
          (by decide)).trans tAt,
        htCell := (FftLocalCells140.outside mid "v1".toList "ht".toList (word (i*t+t))
          (by decide)).trans ((FftLocalCells140.outside (groupOut s vo) "u1".toList "ht".toList
            (word (i+1)) (by decide)).trans groupFixed.htCell),
        mCell := (FftLocalCells140.outside mid "v1".toList "m".toList (word (i*t+t))
          (by decide)).trans ((FftLocalCells140.outside (groupOut s vo) "u1".toList "m".toList
            (word (i+1)) (by decide)).trans groupFixed.mCell),
        strideCell := (FftLocalCells140.outside mid "v1".toList "stride".toList (word (i*t+t))
          (by decide)).trans ((FftLocalCells140.outside (groupOut s vo) "u1".toList "stride".toList
            (word (i+1)) (by decide)).trans groupFixed.strideCell),
        pCell := (FftLocalCells140.outside mid "v1".toList "p".toList (word (i*t+t))
          (by decide)).trans ((FftLocalCells140.outside (groupOut s vo) "u1".toList "p".toList
            (word (i+1)) (by decide)).trans groupFixed.pCell),
        iCell := (FftLocalCells140.outside mid "v1".toList "p0i".toList (word (i*t+t))
          (by decide)).trans ((FftLocalCells140.outside (groupOut s vo) "u1".toList "p0i".toList
            (word (i+1)) (by decide)).trans groupFixed.iCell),
        aBinding := groupFixed.aBinding,
        igmBinding := groupFixed.igmBinding,
        separate := groupFixed.separate,
        twSeparate := groupFixed.twSeparate,
        twLoads := groupFixed.twLoads }
    have nextImage : Image next a stride t ht m tws p p0i fv (i+1) := groupImage
    have nextKeep : ∀ q : ArrayPointer, (∀ x : Nat, x < m*t → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 next.heap q w := by
      intro q qSep w loaded
      exact groupKeep q (fun x _ second => qSep x
        (Nat.lt_of_lt_of_le second (slot_upper t ht m i fixed.span slot))) w loaded
    have nextWritable : next.heap.writable=s.heap.writable := by
      have keep : next.heap.writable=(groupOut s vo).heap.writable := rfl
      rw [keep]
      exact groupW
    obtain ⟨after,rest,finalFixed,finalU1,finalV1,finalImage,finalKeep,finalWritable⟩ :=
      ih (i+1) next nextFixed nextU1 nextV1 nextImage (by omega)
    refine ⟨after,?_,finalFixed,finalU1,finalV1,finalImage,?_,?_⟩
    · refine .loopNormal _ _ _ s (groupOut s vo) next ⟨after,.normal⟩
        (C99ScalarReference.boolean (decide (i < m))) ?_ nonzero groupExec stepRun rest
      exact u1_guard_run s i m iBound fixed.mBound u1Cell fixed.mCell
    · intro q qSep w loaded
      exact finalKeep q qSep w (nextKeep q qSep w loaded)
    · exact finalWritable.trans nextWritable

theorem initial_u1 (s : State) : USlot (initial s) "u1" 0 := rfl

theorem initial_outside (s : State) (name : Name) (first : name≠"u1".toList)
    (second : name≠"v1".toList) : (initial s).locals name=s.locals name := by
  have v : (initial s).locals name=
      (bindValue s "u1".toList .uint64 (.int32 0)).locals name := by
    simp only [initial,bindValue,C99ScalarReference.set,second,ite_false]
  have u : (bindValue s "u1".toList .uint64 (.int32 0)).locals name=s.locals name := by
    simp only [bindValue,C99ScalarReference.set,first,ite_false]
  exact v.trans u

theorem initial_fixed (s : State) (a igm : ArrayPointer) (stride t ht m : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a igm stride t ht m p p0i tws fv) :
    Fixed (initial s) a igm stride t ht m p p0i tws fv where
  tBound := fixed.tBound
  htBound := fixed.htBound
  mBound := fixed.mBound
  strideBound := fixed.strideBound
  htPositive := fixed.htPositive
  span := fixed.span
  wideT := fixed.wideT
  wideV := fixed.wideV
  wideHt := fixed.wideHt
  wideM := fixed.wideM
  aWidth := fixed.aWidth
  aCapacity := fixed.aCapacity
  aWritable := fixed.aWritable
  igmCapacity := fixed.igmCapacity
  tCell := (initial_outside s "t".toList (by decide) (by decide)).trans fixed.tCell
  htCell := (initial_outside s "ht".toList (by decide) (by decide)).trans fixed.htCell
  mCell := (initial_outside s "m".toList (by decide) (by decide)).trans fixed.mCell
  strideCell := (initial_outside s "stride".toList (by decide) (by decide)).trans fixed.strideCell
  pCell := (initial_outside s "p".toList (by decide) (by decide)).trans fixed.pCell
  iCell := (initial_outside s "p0i".toList (by decide) (by decide)).trans fixed.iCell
  aBinding := fixed.aBinding
  igmBinding := fixed.igmBinding
  separate := fixed.separate
  twSeparate := fixed.twSeparate
  twLoads := fixed.twLoads

theorem initial_image (s : State) (a : ArrayPointer) (stride t ht m : Nat)
    (tws : Nat → BitVec 32) (p p0i : BitVec 32) (fv : Nat → BitVec 32) (i : Nat)
    (image : Image s a stride t ht m tws p p0i fv i) :
    Image (initial s) a stride t ht m tws p p0i fv i :=
  fun g j slot jBound => image g j slot jBound

theorem full (s : State) (a igm : ArrayPointer) (stride t ht m : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv : Nat → BitVec 32)
    (fixed : Fixed s a igm stride t ht m p p0i tws fv)
    (oldU oldV : Option C99IntegerReference.Value)
    (du : s.locals "u1".toList=some (.uint64,oldU)) (dv : s.locals "v1".toList=some (.uint64,oldV))
    (image : Image s a stride t ht m tws p p0i fv 0) :
    ∃ after, Exec NttInversePrograms192.u1Loop s ⟨after,.normal⟩ ∧
      Fixed after a igm stride t ht m p p0i tws fv ∧
      USlot after "u1" m ∧ USlot after "v1" (m*t) ∧
      Image after a stride t ht m tws p p0i fv m ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < m*t → Separate (walk a x stride) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 after.heap q w) ∧
      after.heap.writable=s.heap.writable := by
  have u1InitRun : Exec NttInversePrograms192.u1Init s ⟨initial s,.normal⟩ := by
    refine .seqNormal _ _ s (bindValue s "u1".toList .uint64 (.int32 0)) ⟨initial s,.normal⟩ ?_ ?_
    · exact .assign _ _ _ .uint64 oldU (.int32 0) du (.scalar _ _ (.literal .int32 0))
    · have dv' : (bindValue s "u1".toList .uint64 (.int32 0)).locals "v1".toList=
          some (.uint64,oldV) := by
        have different : "v1".toList≠"u1".toList := by decide
        have update : (bindValue s "u1".toList .uint64 (.int32 0)).locals "v1".toList=
            s.locals "v1".toList := by
          simp only [bindValue,C99ScalarReference.set,different,ite_false]
        rw [update]
        exact dv
      exact .assign _ _ _ .uint64 oldV (.int32 0) dv' (.scalar _ _ (.literal .int32 0))
  obtain ⟨after,rest,finalFixed,finalU1,finalV1,finalImage,finalKeep,finalWritable⟩ :=
    remaining m 0 (initial s) a igm stride t ht m p p0i tws fv
      (initial_fixed s a igm stride t ht m p p0i tws fv fixed)
      (initial_u1 s) (by simp only [Nat.zero_mul]; rfl)
      (initial_image s a stride t ht m tws p p0i fv 0 image) (by omega)
  exact ⟨after,.seqNormal _ _ s (initial s) ⟨after,.normal⟩ u1InitRun rest,
    finalFixed,finalU1,finalV1,finalImage,finalKeep,finalWritable⟩

end FT1536.Source3.NttInverseMiddleU1Loop192
