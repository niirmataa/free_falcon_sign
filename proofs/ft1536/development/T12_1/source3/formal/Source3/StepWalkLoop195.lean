import Source3.StepWalkFixed195
import Source3.StepCopyLoop190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Loop composition of the additional-prime marches
   (MakeFgAddPrimeShape194.walkF "fs"/"gs"): the walk loop runs n steps
   (the selected instance is n = 512), each one exactly one
   ZintModSignedWord194.ms_call instance at the marched word with its
   executed word stored to t1[v], followed by the shared increment. The
   exported image is the executed march word

     modSignedWord (fv i) pw p0w r2w rxw

   loaded at t1[i] after the loop, with the Word32Memory176 keep
   discipline outside the t1 region and the exit cells v = n and
   x = addr src 0 n 1. The walk statements are the pinned projections of
   MakeFgAddPrimeShape194 (walkInit/walkBody/walkInc/walkLoop); no new
   parse recognition is performed. Values stay executed words: no
   transform property, table law, root law or positivity claim. -/
namespace FT1536.Source3.StepWalkLoop195
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open C99ProcedureReference (Result)
open C99LoopScalar141 (Cell)
open KeygenMakeFgSource (Exec)
open ZintModSignedWord194 (modSignedWord)
open StepCopyBody190 (addr elem output next)
open StepWalkFixed195 (Fixed PrefixImage)

/- The loop guard of the walk (the condition clause of walkLoop, the
   copy-loop guard verbatim). -/
def walkGuard : CLogic.Expr :=
  .cmp .lt MakeFgAddPrimeShape194.varV MakeFgAddPrimeShape194.varN

theorem walk_loop_shape :
    MakeFgAddPrimeShape194.walkLoop=.loop walkGuard MakeFgAddPrimeShape194.walkBody
      MakeFgAddPrimeShape194.walkInc := rfl

theorem guard (s : State) (v n : Nat) (vBound : v<2^64) (nBound : n<2^64)
    (vCell : Cell s "v".toList v) (nCell : Cell s "n".toList n) :
    C99ArrayReference.scalar s walkGuard
      (C99ScalarReference.boolean (decide (v<n))) :=
  StepCopyLoop190.guard s v n vBound nBound vCell nCell

/- The n-step loop run from the walked position v. -/
theorem remaining (count v : Nat) (s : State) (srcName : Name) (src t1 : ArrayPointer) (n : Nat)
    (fv : Fin n → BitVec 32) (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s srcName src t1 n fv pw p0w r2w rxw)
    (vCell : Cell s "v".toList v) (xBinding : s.arrays "x".toList=some (addr src 0 v 1))
    (copied : PrefixImage s t1 fv pw p0w r2w rxw v) (finish : v+count=n) :
    ∃ after, Exec MakeFgAddPrimeShape194.walkLoop s ⟨after,.normal⟩ ∧
      Fixed after srcName src t1 n fv pw p0w r2w rxw ∧ Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr src 0 n 1) ∧
      PrefixImage after t1 fv pw p0w r2w rxw n ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) := by
  induction count generalizing v s with
  | zero =>
    have equal : v=n := by omega
    subst v
    have guard : C99ArrayReference.scalar s MakeFgTailShape190.copyCondition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        StepCopyLoop190.guard s n n fixed.nBound fixed.nBound vCell fixed.nCell
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guard (by decide),fixed,vCell,xBinding,copied,
      fun _ _ => rfl,fun _ _ => rfl⟩
  | succ count ih =>
    have slot : v<n := by omega
    have nonzero : (C99ScalarReference.boolean (decide (v<n))).integer≠0 := by
      simp [slot,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    have body : Exec MakeFgAddPrimeShape194.walkBody s
        ⟨output s t1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw),.normal⟩ :=
      StepWalkBody195.body_source s src t1 v (fv ⟨v,slot⟩) pw p0w r2w rxw
        (by have h := fixed.nBound; omega)
        (StepWalkBody195.march_capacity src n v fixed.srcCapacity slot)
        (by have := fixed.t1Capacity; omega)
        fixed.t1Binding xBinding vCell fixed.slenCell fixed.pSlot fixed.p0iSlot fixed.r2Slot
        fixed.rxSlot (fixed.loads ⟨v,slot⟩) (fixed.t1Allocated ⟨v,slot⟩) fixed.t1Width
        fixed.t1Writable
    have update : Exec MakeFgAddPrimeShape194.walkInc
        (output s t1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        ⟨next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw),.normal⟩ :=
      StepWalkBody195.inc_source s src t1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
        (by have h := fixed.nBound; omega)
        (StepWalkBody195.march_capacity_next src n v fixed.srcCapacity slot)
        vCell fixed.slenCell xBinding
    obtain ⟨after,rest,finalFixed,finalV,finalX,finalPrefix,finalLocals,finalArrays⟩ :=
      ih (v+1) (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        (StepWalkFixed195.next_fixed s srcName src t1 n v fv pw p0w r2w rxw fixed slot)
        (StepCopyLoop190.next_v s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        (StepCopyFixed190.next_x s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        (StepWalkFixed195.next_prefix s srcName src t1 n v fv pw p0w r2w rxw fixed slot copied)
        (by omega)
    refine ⟨after,?_,finalFixed,finalV,finalX,finalPrefix,?_,?_⟩
    · refine .loopNormal _ _ _ s (output s t1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        (next s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw))
        ⟨after,.normal⟩ (C99ScalarReference.boolean (decide (v<n))) ?_ nonzero body update rest
      exact StepCopyLoop190.guard s v n (by have h := fixed.nBound; omega) fixed.nBound vCell
        fixed.nCell
    · intro name different
      exact (finalLocals name different).trans
        (StepCopyFixed190.next_locals s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
          name different)
    · intro name different
      exact (finalArrays name different).trans
        (StepCopyFixed190.next_arrays s src t1 0 1 v (modSignedWord (fv ⟨v,slot⟩) pw p0w r2w rxw)
          name different)

/- The walk initialiser (walkInit of any source name): v = 0 and
   x = src + 0. -/
def initOf (srcName : Name) : KeygenMakeFgSource.Stmt := KeygenMakeFgSource.modular
  (.seq (.assign "v".toList (.scalar (MakeFgAddPrimeShape194.num 0)))
    (.base (.bindPtr "x".toList srcName MakeFgAddPrimeShape194.at0)))

theorem init_shape (src : String) : MakeFgAddPrimeShape194.walkInit src=initOf src.toList := rfl

/- The post-init walk state: the counter word 0 and the walked pointer at
   the source base. -/
def midState (s : State) (src : ArrayPointer) : State :=
  bindPointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
    "x".toList (addr src 0 0 1)

theorem mid_heap (s : State) (src : ArrayPointer) : (midState s src).heap=s.heap := rfl

theorem mid_locals (s : State) (src : ArrayPointer) (other : Name) (different : other≠"v".toList) :
    (midState s src).locals other=s.locals other := by
  have first : (midState s src).locals other=
      (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)).locals other := rfl
  rw [first]
  exact (FftLocalCells140.outside s "v".toList other (C99NatWord141.word 0) different).trans rfl

theorem mid_arrays (s : State) (src : ArrayPointer) (other : Name)
    (different : other≠"x".toList) : (midState s src).arrays other=s.arrays other := by
  have first : (midState s src).arrays other=
      (C99ArrayReference.bindPointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
        "x".toList (addr src 0 0 1)).arrays other := rfl
  rw [first]
  rw [StepCopyFixed190.bindPointer_arrays _ _ _ _ different]
  rfl

theorem mid_x (s : State) (src : ArrayPointer) :
    (midState s src).arrays "x".toList=some (addr src 0 0 1) := rfl

theorem mid_v (s : State) (src : ArrayPointer) : Cell (midState s src) "v".toList 0 := by
  exact FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)

/- The initialiser run of any walk instance. -/
theorem init_source (s : State) (srcName : Name) (src : ArrayPointer)
    (vDeclared : ∃ old, s.locals "v".toList=some (.uint64,old))
    (srcBinding : s.arrays srcName=some src) (capacity : src.index≤src.count) :
    Exec (initOf srcName) s ⟨midState s src,.normal⟩ := by
  obtain ⟨old,declared⟩ := vDeclared
  have assign : C99ModularReference.Exec
      (.assign "v".toList (.scalar (MakeFgAddPrimeShape194.num 0))) s
      ⟨FftLocalCells140.put s "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have walked : Pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      srcName MakeFgAddPrimeShape194.at0 (addr src 0 0 1) :=
    StepCopyBody190.zero_pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      srcName src srcBinding capacity
  have bind : C99ModularReference.Exec
      (.base (.bindPtr "x".toList srcName MakeFgAddPrimeShape194.at0))
      (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) ⟨midState s src,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ walked)
  have combined : C99ModularReference.Exec
      (.seq (.assign "v".toList (.scalar (MakeFgAddPrimeShape194.num 0)))
        (.base (.bindPtr "x".toList srcName MakeFgAddPrimeShape194.at0))) s
      ⟨midState s src,.normal⟩ :=
    .seqNormal _ _ _ _ _ assign bind
  exact .level _ _ _ (.modular _ _ _ combined)

/- The post-init invariant. -/
theorem mid_fixed (s : State) (srcName : Name) (src t1 : ArrayPointer) (n : Nat)
    (fv : Fin n → BitVec 32) (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s srcName src t1 n fv pw p0w r2w rxw) :
    Fixed (midState s src) srcName src t1 n fv pw p0w r2w rxw := by
  refine ⟨fixed.nBound,fixed.srcWidth,fixed.t1Width,fixed.srcCapacity,fixed.t1Capacity,?_,?_,
    ?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact fixed.t1Writable
  · exact fixed.srcName_different
  · rw [mid_arrays s src srcName fixed.srcName_different]
    exact fixed.srcBinding
  · rw [mid_arrays s src "t1".toList (by decide)]
    exact fixed.t1Binding
  · show (midState s src).locals "n".toList=some (.uint64,some (.uint64 (C99NatWord141.word n)))
    rw [mid_locals s src "n".toList (by decide)]
    exact fixed.nCell
  · show (midState s src).locals "slen".toList=
      some (.uint64,some (.uint64 (C99NatWord141.word 1)))
    rw [mid_locals s src "slen".toList (by decide)]
    exact fixed.slenCell
  · show (midState s src).locals "p".toList=some (.uint32,some (.uint32 pw))
    rw [mid_locals s src "p".toList (by decide)]
    exact fixed.pSlot
  · show (midState s src).locals "p0i".toList=some (.uint32,some (.uint32 p0w))
    rw [mid_locals s src "p0i".toList (by decide)]
    exact fixed.p0iSlot
  · show (midState s src).locals "R2".toList=some (.uint32,some (.uint32 r2w))
    rw [mid_locals s src "R2".toList (by decide)]
    exact fixed.r2Slot
  · show (midState s src).locals "Rx".toList=some (.uint32,some (.uint32 rxw))
    rw [mid_locals s src "Rx".toList (by decide)]
    exact fixed.rxSlot
  · intro i
    exact fixed.t1Allocated i
  · intro v i
    exact fixed.t1Separate v i
  · intro i j different
    exact fixed.prefixSeparate i j different
  · intro i
    exact fixed.loads i

/- The whole walk statement of any source name (init + loop). -/
def walkOf (srcName : Name) : KeygenMakeFgSource.Stmt :=
  .seq (initOf srcName) MakeFgAddPrimeShape194.walkLoop

theorem walk_shape (src : String) : MakeFgAddPrimeShape194.walkF src=walkOf src.toList := rfl

/- Main export: the full walk run of any instance (init + n steps), the
   executed march image over t1, the keeps outside the walk cells and the
   exit cells. -/
theorem walk_run (s : State) (srcName : Name) (src t1 : ArrayPointer) (n : Nat)
    (fv : Fin n → BitVec 32) (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s srcName src t1 n fv pw p0w r2w rxw)
    (vDeclared : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec (walkOf srcName) s ⟨after,.normal⟩ ∧
      Fixed after srcName src t1 n fv pw p0w r2w rxw ∧
      PrefixImage after t1 fv pw p0w r2w rxw n ∧
      Cell after "v".toList n ∧
      after.arrays "x".toList=some (addr src 0 n 1) ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) := by
  have srcCapacity : src.index≤src.count := by
    have h := fixed.srcCapacity
    omega
  have initRun : Exec (initOf srcName) s ⟨midState s src,.normal⟩ :=
    init_source s srcName src vDeclared fixed.srcBinding srcCapacity
  have midFixed : Fixed (midState s src) srcName src t1 n fv pw p0w r2w rxw :=
    mid_fixed s srcName src t1 n fv pw p0w r2w rxw fixed
  obtain ⟨after,rest,finalFixed,finalV,finalX,finalPrefix,finalLocals,finalArrays⟩ :=
    remaining n 0 (midState s src) srcName src t1 n fv pw p0w r2w rxw midFixed
      (mid_v s src) (mid_x s src)
      (fun i bound => absurd bound (by omega)) (by omega)
  refine ⟨after,?_,finalFixed,finalPrefix,finalV,finalX,?_,?_⟩
  · exact .seqNormal _ _ s (midState s src) ⟨after,.normal⟩ initRun rest
  · intro name different
    exact (finalLocals name different).trans (mid_locals s src name different)
  · intro name different
    exact (finalArrays name different).trans (mid_arrays s src name different)

end FT1536.Source3.StepWalkLoop195
