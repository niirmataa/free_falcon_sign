import Source3.CrtRound214

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The co-reduction loop driver for the make_fg zint_rebuild_CRT calls at
   the exact instance xstride = xlen. The accepted generic engine
   CrtRound214 instantiates one round (round_source) and the loop
   invariant of CrtRound214 demands roomL : L+1 <= stride, one spare
   column beyond the reassembled words. The original make_fg calls pass
   xstride = xlen exactly, so the last round at len = L-1 rewrites the
   L words of each row and needs only L <= stride. This module restates
   the loop invariant with that exact room bound and re-drives the
   original co-loop `for (u = 1; u < xlen; u++)` to its exit, reusing
   the accepted one-round engine, guard, increment and scope transports
   of CrtRound214 unchanged. All words stay executed words; no CRT,
   centering or table law is claimed. -/
namespace FT1536.Source3.ThirdStepCrtLoop215
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open CrtState205 (Slot64)
open KeygenFullData127 (primes)
open StepCopyBody190 (elem)
open CrtWalkIncrement214 (row point)
open CrtWalkFixed214 (Fixed)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open KeygenZintCall (Stmt Exec)

structure LoopInput (s : State) (root tmp : ArrayPointer) (num L stride : Nat)
    (fv : Nat → Nat×Nat×Nat) (W0 T0 : Nat → BitVec 32) (k : Nat) : Prop where
  nBound : num < 2^64
  LBound : L < 2^64
  strideBound : stride < 2^64
  roomL : L ≤ stride
  width : root.elementBytes=4
  capacity : root.index+num*stride ≤ root.count
  rootWritable : s.heap.writable root.block=true
  tmpWidth : tmp.elementBytes=4
  tmpRoomL : tmp.index+L+1 ≤ tmp.count
  tmpWritable : s.heap.writable tmp.block=true
  tmpAlloc : Allocated s.heap (elem tmp L)
  apart : ∀ i j t, i < num → j < stride → t ≤ L → Word32Memory176.Separate (point root stride i j) (elem tmp t)
  xxBinding : s.arrays "xx".toList=some root
  tmpBinding : s.arrays "tmp".toList=some tmp
  primesBinding : s.arrays "primes".toList=some primes
  primeObject : KeygenStaticTables.PrimeObject s.heap primes .ternary
  numCell : Cell s "num".toList num
  xlenCell : Cell s "xlen".toList L
  strideCell : Cell s "xstride".toList stride
  rows : ∀ i, i ≤ L → (KeygenStaticTables.values .ternary)[i]?=some (fv i)
  uCell : Cell s "u".toList k
  kBound : k ≤ L
  data : ZintNormWalkFlat208.Data s root (num*stride) (CrtRound214.rowAt fv T0 W0 stride k)
  tmpRead : ∀ j, j < k → Load32 s.heap (elem tmp j) (CrtRound214.tmpAt fv T0 k j)

/- One round at a counter strictly inside the loop: the room bound is
   k+1 <= stride from k < L and L <= stride. -/
theorem loop_round {s : State} {root tmp : ArrayPointer} {num L stride : Nat}
    {fv : Nat → Nat×Nat×Nat} {W0 T0 : Nat → BitVec 32} {k : Nat}
    (input : LoopInput s root tmp num L stride fv W0 T0 k) (running : k < L) :
    CrtRound214.RoundInput s root tmp num k stride (CrtRound214.rowAt fv T0 W0 stride k)
      (CrtRound214.tmpAt fv T0 k) (fv k) := by
  have kpos : k < 2^64 := by have h := input.LBound; omega
  have boundK : (elem tmp k).index<(elem tmp k).count := by
    show tmp.index+k<tmp.count
    have h := input.tmpRoomL; omega
  have allocK : Allocated s.heap (elem tmp k) :=
    ZintRebuildCrt194.alloc_same_block input.tmpAlloc rfl rfl rfl rfl input.tmpAlloc.2.1 boundK
  refine ⟨input.nBound,input.strideBound,?_,input.width,input.capacity,input.rootWritable,
    input.xxBinding,input.tmpBinding,input.numCell,input.strideCell,?_,input.data,input.tmpWidth,?_,
    input.tmpWritable,allocK,?_,?_⟩
  · show k+1≤stride
    have h := input.roomL; omega
  · exact ⟨kpos,input.uCell,input.rows k input.kBound,input.primesBinding,input.primeObject⟩
  · show tmp.index+k+1≤tmp.count
    have h := input.tmpRoomL; have b := input.kBound; omega
  · intro j jb; exact input.tmpRead j jb
  · intro i j t ib jb tb; exact input.apart i j t ib jb (by have b := input.kBound; omega)

/- The remaining loop from counter m+1 while m+1+count = xlen. -/
theorem remaining (count m : Nat) (s : State) (root tmp : ArrayPointer) (num L stride : Nat)
    (fv : Nat → Nat×Nat×Nat) (W0 T0 : Nat → BitVec 32)
    (input : LoopInput s root tmp num L stride fv W0 T0 (m+1)) (finish : m+1+count=L) :
    ∃ out, Exec ZintRebuildCrt194.coLoop s ⟨out,.normal⟩ ∧
      CrtRound214.LoopResult s out root tmp num L stride fv W0 T0 := by
  induction count generalizing m s with
  | zero =>
    have eq : m+1=L := by omega
    subst eq
    have test : KeygenWordExpr.Eval s ZintRebuildCrt194.coGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        CrtRound214.coGuard_eval s (m+1) (m+1) (by have h := input.LBound; omega) input.LBound
          input.uCell input.xlenCell
    exact ⟨s,by
      rw [ZintRebuildCrt194.co_split]
      exact .loopFalse _ _ _ _ (.int32 0) test (by decide),
      ⟨input.uCell,input.xlenCell,input.numCell,input.strideCell,input.xxBinding,input.tmpBinding,
        input.primesBinding,input.data,input.tmpRead,input.primeObject,
        fun name _ _ => rfl,fun q old _ _ read => read⟩⟩
  | succ count ih =>
    have guardTrue : m+1 < L := by omega
    obtain ⟨out2,roundRun,fixed2,v2,x2,imageRoot,imageTmp,lsR,arsR,keepR⟩ :=
      CrtRound214.round_source (loop_round input guardTrue)
    have stable : KeygenMemoryStability.Stable s.heap out2.heap :=
      KeygenMemoryStability.zint _ _ _ roundRun
    have sizeEq : out2.heap.size=s.heap.size := stable.size
    have writableEq : out2.heap.writable=s.heap.writable := stable.writable
    have innerRun : Exec CrtRoundShape205.inner s ⟨out2,.normal⟩ := by
      rw [CrtRound214.round_shape]; exact roundRun
    have scopeRun : Exec ZintRebuildCrt194.coBody s
        ⟨C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames [],.normal⟩ := by
      rw [CrtRoundShape205.shape]
      exact .scope _ _ _ _ _ innerRun
    have midU : Cell (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u".toList (m+1) :=
      (CrtRound214.restore_local (names:=CrtRoundShape205.localNames) "u".toList (by decide)).trans fixed2.uCell
    have midNum : Cell (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "num".toList num :=
      (CrtRound214.restore_local (names:=CrtRoundShape205.localNames) "num".toList (by decide)).trans fixed2.numCell
    have midXlen : Cell (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "xlen".toList L :=
      ((CrtRound214.restore_local (names:=CrtRoundShape205.localNames) "xlen".toList (by decide)).trans
        (lsR "xlen".toList (by decide))).trans input.xlenCell
    have midStride : Cell (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "xstride".toList stride :=
      (CrtRound214.restore_local (names:=CrtRoundShape205.localNames) "xstride".toList (by decide)).trans fixed2.strideCell
    have midData : ZintNormWalkFlat208.Data (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames [])
        root (num*stride) (CrtRound214.rowAt fv T0 W0 stride (m+2)) := by
      intro i ib
      rw [CrtRound214.restore_heap,CrtRound214.rowAt_succ]
      exact imageRoot i ib
    have midTmp : ∀ j, j < m+2 → Load32 (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []).heap
        (elem tmp j) (CrtRound214.tmpAt fv T0 (m+2) j) := by
      rw [CrtRound214.restore_heap,CrtRound214.tmpAt_succ]
      intro j jb; exact imageTmp j (by omega)
    have midObject : KeygenStaticTables.PrimeObject
        (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []).heap primes .ternary := by
      rw [CrtRound214.restore_heap]
      exact CrtRound214.object_keep input.primeObject input.rootWritable input.tmpWritable writableEq sizeEq
        (fun q old rows tmps read => keepR q old rows tmps read)
    have incRun : Exec ZintRebuildCrt194.coInc
        (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames [])
        ⟨CrtState205.set64 (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u"
          (C99NatWord141.word (m+2)),.normal⟩ :=
      CrtRound214.coInc_run (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) (m+1)
        (by have h := input.LBound; omega) midU
    have nextInv : LoopInput (CrtState205.set64
        (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u"
        (C99NatWord141.word (m+2))) root tmp num L stride fv W0 T0 (m+2) := by
      refine ⟨input.nBound,input.LBound,input.strideBound,input.roomL,input.width,input.capacity,?_,
        input.tmpWidth,input.tmpRoomL,?_,?_,input.apart,?_,?_,?_,?_,?_,?_,?_,input.rows,?_,?_,?_,?_⟩
      · exact fixed2.writable
      · show out2.heap.writable tmp.block=true
        rw [writableEq]; exact input.tmpWritable
      · have hs : (CrtState205.set64 (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames [])
          "u" (C99NatWord141.word (m+2))).heap.size=s.heap.size := sizeEq
        refine ⟨input.tmpAlloc.1,input.tmpAlloc.2.1,input.tmpAlloc.2.2.1,?_,?_⟩
        · rw [hs]; exact input.tmpAlloc.2.2.2.1
        · rw [hs]; exact input.tmpAlloc.2.2.2.2
      · exact (arsR "xx".toList (by decide)).trans input.xxBinding
      · exact (arsR "tmp".toList (by decide)).trans input.tmpBinding
      · exact (arsR "primes".toList (by decide)).trans input.primesBinding
      · exact midObject
      · exact (CrtState205.keep64 _ "u" "num" (C99NatWord141.word (m+2)) (by decide)).trans midNum
      · exact (CrtState205.keep64 _ "u" "xlen" (C99NatWord141.word (m+2)) (by decide)).trans midXlen
      · exact (CrtState205.keep64 _ "u" "xstride" (C99NatWord141.word (m+2)) (by decide)).trans midStride
      · exact CrtState205.cell64 _ "u" (C99NatWord141.word (m+2))
      · omega
      · exact midData
      · intro j jb; exact midTmp j jb
    obtain ⟨final,rest,fin⟩ := ih (m+1) (CrtState205.set64
      (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u"
      (C99NatWord141.word (m+2))) nextInv (by omega)
    refine ⟨final,?_,?_⟩
    · rw [ZintRebuildCrt194.co_split]
      refine .loopNormal _ _ _ s (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames [])
        (CrtState205.set64 (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u"
          (C99NatWord141.word (m+2))) ⟨final,.normal⟩
        (C99ScalarReference.boolean (decide (m+1 < L))) ?_ ?_ scopeRun incRun rest
      · exact CrtRound214.coGuard_eval s (m+1) L (by have h := input.LBound; omega) input.LBound input.uCell input.xlenCell
      · simp [guardTrue,C99ScalarReference.boolean,Value.integer]
    · refine ⟨fin.uCell,fin.xlenCell,fin.numCell,fin.strideCell,fin.xxBinding,fin.tmpBinding,
        fin.primesBinding,fin.data,fin.tmpRead,fin.primeObject,?_,?_⟩
      · intro name nu nl
        exact (fin.locals name nu nl).trans
          ((SelectedStepAddPrime195.locals_keep
            (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u".toList .uint64
            (.uint64 (C99NatWord141.word (m+2))) name nu).trans
            ((CrtRound214.restore_local (names:=CrtRoundShape205.localNames) name nl).trans (lsR name nl)))
      · intro q old rows tmps read
        apply fin.keep q old rows tmps
        exact keepR q old (fun i j ib jb => rows i j ib (by have h := guardTrue; omega))
          (fun t tb => tmps t (by have h := guardTrue; omega)) read

theorem outer_loop_source {s : State} {root tmp : ArrayPointer} {num L stride : Nat}
    {fv : Nat → Nat×Nat×Nat} {W0 T0 : Nat → BitVec 32}
    (input : LoopInput s root tmp num L stride fv W0 T0 1) (Lpos : 0 < L) :
    ∃ out, Exec ZintRebuildCrt194.coLoop s ⟨out,.normal⟩ ∧
      CrtRound214.LoopResult s out root tmp num L stride fv W0 T0 :=
  remaining (L-1) 0 s root tmp num L stride fv W0 T0 input (by omega)

end FT1536.Source3.ThirdStepCrtLoop215
