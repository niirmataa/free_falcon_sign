import Source3.CrtPrimePrefix214
import Source3.CrtWalkWhole214
import Source3.CrtMulCall213
import Source3.ZintSignedWhole209
import Source3.ZintNormWalkFlat208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The composed CRT prime round of zint_rebuild_CRT for an arbitrary
   bounded loop index u = len: the generalized prime prefix
   (CrtPrimePrefix214), the complete coefficient walk
   (CrtWalkWhole214.Fixed), and the generic multiply call (CrtMulCall213),
   with the local names of CrtRoundShape205. The walk mutates the u+1
   coefficient words of every row; the multiply mutates the u+1 product
   words of tmp. The round is the body of the original co-reduction loop
   `for (u = 1; u < xlen; u++)`; its row index equals the reassembled
   length u, exactly as in the original source.

   Values stay executed words: no CRT/centering/NTT/root/table law is
   proved and no desired output or certificate is supplied as a premise.
   Ordinary scalar/memory/table/separation domains are preserved from the
   constituent engines. -/
namespace FT1536.Source3.CrtRound214
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open CrtState205 (Slot64)
open KeygenFullData127 (primes)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (elem)
open CrtWalkIncrement214 (row point)
open CrtWalkFixed214 (Fixed)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open KeygenZintCall (Stmt Exec)

/- The composed round body for one u iteration: the seven-statement
   prime prefix, walkInit, the counted coefficient walk, the multiply
   call with its return store and the trailing skip. -/
def round_body : Stmt :=
  CrtPrimePrefix214.prepend (.seq (.seq CrtRoundShape205.walkInit CrtRoundShape205.walk)
    (.seq CrtRoundShape205.mulCall CrtRoundShape205.skip))

theorem round_shape : CrtRoundShape205.inner = round_body := rfl

theorem localNames_restored : CrtPrimePrefix214.words ++ ["v".toList] = CrtRoundShape205.localNames := rfl

/- Ordinary input domain of one round iteration at the loop index len:
   the prime-table row read, the walk cells/geometry and data, and the
   tmp product capacity consumed by the multiply call. The private
   p/p0i/s/R2 words are bound by the prefix itself. -/
structure RoundInput (s : State) (root tmp : ArrayPointer) (num len stride : Nat)
    (W T : Nat → BitVec 32) (v : Nat×Nat×Nat) : Prop where
  nBound : num < 2^64
  strideBound : stride < 2^64
  room : len+1 ≤ stride
  width : root.elementBytes=4
  capacity : root.index+num*stride ≤ root.count
  rootWritable : s.heap.writable root.block=true
  xxBinding : s.arrays "xx".toList=some root
  tmpBinding : s.arrays "tmp".toList=some tmp
  numCell : Cell s "num".toList num
  strideCell : Cell s "xstride".toList stride
  prime : CrtPrimePrefix214.Input s len v
  data : ZintNormWalkFlat208.Data s root (num*stride) W
  tmpWidth : tmp.elementBytes=4
  tmpRoom : tmp.index+len+1 ≤ tmp.count
  tmpWritable : s.heap.writable tmp.block=true
  tmpAlloc : Allocated s.heap (elem tmp len)
  tmpRead : ∀ j, j < len → Load32 s.heap (elem tmp j) (T j)
  apart : ∀ i j k, i < num → j < stride → k ≤ len → Word32Memory176.Separate (point root stride i j) (elem tmp k)

theorem sep_symm {p q : ArrayPointer} (h : Word32Memory176.Separate p q) :
    Word32Memory176.Separate q p := by
  rcases h with h | h | h
  · exact Or.inl (Ne.symm h)
  · exact Or.inr (Or.inr h)
  · exact Or.inr (Or.inl h)

/- One full round iteration. The prefix binds the executed words
   pVal/sVal of the u-th PRIMES3 row and the derived words iVal/rVal;
   the walk rewrites the u+1 coefficient words of every row; the
   multiply call rewrites the u+1 product words of tmp. The output
   images are exact executed words of the constituent engines. -/
theorem round_source {s : State} {root tmp : ArrayPointer} {num len stride : Nat}
    {W T : Nat → BitVec 32} {v : Nat×Nat×Nat} (input : RoundInput s root tmp num len stride W T v) :
    ∃ out, Exec round_body s ⟨out,.normal⟩ ∧
      Fixed out root tmp num len stride (CrtMulCall213.words T (pVal v) len)
        (pVal v) (iVal v) (rVal v) (sVal v) ∧
      Cell out "v".toList num ∧ out.arrays "x".toList=some (row root stride num) ∧
      ZintNormWalkFlat208.Data out root (num*stride)
        (CrtWalkFlat214.words len stride W T (pVal v) (iVal v) (rVal v) (sVal v)) ∧
      ZintNormWalkFlat208.Data out tmp (len+1) (CrtMulCall213.words T (pVal v) len) ∧
      (∀ name : Name, name∉CrtRoundShape205.localNames → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i j, i < num → j ≤ len → Word32Memory176.Separate (point root stride i j) q) →
        (∀ k, k ≤ len → Word32Memory176.Separate (elem tmp k) q) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  have fixedA : Fixed (CrtPrimePrefix214.after_prefix s (pVal v) (sVal v)) root tmp num len stride T
      (pVal v) (iVal v) (rVal v) (sVal v) := by
    refine ⟨input.nBound,input.prime.uBound,input.strideBound,input.room,input.width,input.capacity,
      ?_,?_,?_,?_,?_,CrtPrimePrefix214.pCell s (pVal v) (sVal v),
      CrtPrimePrefix214.iCell s (pVal v) (sVal v),CrtPrimePrefix214.rCell s (pVal v) (sVal v),
      CrtPrimePrefix214.sCell s (pVal v) (sVal v),?_,?_,?_⟩
    · exact input.rootWritable
    · exact input.tmpBinding
    · exact (CrtPrimePrefix214.outside s (pVal v) (sVal v) "num".toList (by decide)).trans input.numCell
    · exact (CrtPrimePrefix214.outside s (pVal v) (sVal v) "u".toList (by decide)).trans input.prime.uCell
    · exact (CrtPrimePrefix214.outside s (pVal v) (sVal v) "xstride".toList (by decide)).trans input.strideCell
    · have h := input.tmpRoom; omega
    · exact input.tmpRead
    · intro i j k ib jb kb
      exact input.apart i j k ib (by have h := input.room; omega) (by omega)
  obtain ⟨out1,walkRun,fixed1,v1,x1,image1,ls1,ars1,keep1⟩ :=
    CrtWalkWhole214.source (CrtPrimePrefix214.after_prefix s (pVal v) (sVal v)) root tmp num len stride W T
      (pVal v) (iVal v) (rVal v) (sVal v) fixedA input.data none
      (CrtPrimePrefix214.vDeclared s (pVal v) (sVal v)) input.xxBinding
  have stable1 : KeygenMemoryStability.Stable (CrtPrimePrefix214.after_prefix s (pVal v) (sVal v)).heap out1.heap :=
    KeygenMemoryStability.zint _ _ _ walkRun
  have size1 : out1.heap.size=s.heap.size := stable1.size
  have writable1 : out1.heap.writable tmp.block=true := by rw [stable1.writable]; exact input.tmpWritable
  have alloc1 : Allocated out1.heap (elem tmp len) :=
    ⟨input.tmpAlloc.1,input.tmpAlloc.2.1,input.tmpAlloc.2.2.1,
      by rw [size1]; exact input.tmpAlloc.2.2.2.1,by rw [size1]; exact input.tmpAlloc.2.2.2.2⟩
  obtain ⟨out2,mulRun,image2,loc2,arr2,keep2⟩ :=
    CrtMulCall213.source out1 tmp len T (pVal v) fixed1.tmpBinding fixed1.uCell fixed1.pCell
      input.prime.uBound (by have h := input.tmpRoom; omega) input.tmpWidth alloc1 writable1 fixed1.tmpRead
  have skipRun : Exec CrtRoundShape205.skip out2 ⟨out2,.normal⟩ :=
    .word _ _ _ (ZintSubWord194.skip_run out2)
  have stable2 : KeygenMemoryStability.Stable out1.heap out2.heap := KeygenMemoryStability.zint _ _ _ mulRun
  have fixedFinal : Fixed out2 root tmp num len stride (CrtMulCall213.words T (pVal v) len)
      (pVal v) (iVal v) (rVal v) (sVal v) := by
    refine ⟨input.nBound,input.prime.uBound,input.strideBound,input.room,input.width,input.capacity,
      ?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
    · rw [stable2.writable]; exact fixed1.writable
    · exact (congrFun arr2 "tmp".toList).trans fixed1.tmpBinding
    · exact (congrFun loc2 "num".toList).trans fixed1.numCell
    · exact (congrFun loc2 "u".toList).trans fixed1.uCell
    · exact (congrFun loc2 "xstride".toList).trans fixed1.strideCell
    · exact (congrFun loc2 "p".toList).trans fixed1.pCell
    · exact (congrFun loc2 "p0i".toList).trans fixed1.iCell
    · exact (congrFun loc2 "R2".toList).trans fixed1.rCell
    · exact (congrFun loc2 "s".toList).trans fixed1.sCell
    · have h := input.tmpRoom; omega
    · intro j jb; exact image2 j (by omega)
    · intro i j k ib jb kb
      exact input.apart i j k ib (by have h := input.room; omega) (by omega)
  refine ⟨out2,?_,fixedFinal,(congrFun loc2 "v".toList).trans v1,?_,?_,?_,?_,?_,?_⟩
  · exact CrtPrimePrefix214.source s len v input.prime _ ⟨out2,.normal⟩
      (.seqNormal _ _ _ _ _ walkRun (.seqNormal _ _ _ _ _ mulRun skipRun))
  · rw [arr2]; exact x1
  · intro i ib
    have hb1 : i/stride < num := ZintNormWalkFlat208.quotient_bound num stride i ib
    have hb2 : i%stride < stride := Nat.mod_lt i (by have h := input.room; omega)
    exact keep2 (elem root i) _ (fun k kb => by
      rw [← CrtWalkFlat214.address root stride i]
      exact sep_symm (input.apart (i/stride) (i%stride) k hb1 hb2 kb)) (image1 i ib)
  · exact image2
  · intro name absent
    have nv : name≠"v".toList := fun eq => absent (eq ▸ (by decide))
    exact (congrFun loc2 name).trans ((ls1 name nv).trans
      (CrtPrimePrefix214.outside s (pVal v) (sVal v) name absent))
  · intro name nx
    exact (congrFun arr2 name).trans (ars1 name nx)
  · intro q old rows tmps read
    apply keep2 q old _ _
    · intro k kb; exact tmps k kb
    · apply keep1 q old _ read
      intro i j ib jb
      exact rows i j ib jb

/- Signed normalization of the make_fg CRT instance: after the
   co-reduction loop the original zint_rebuild_CRT runs zint_norm_zero
   over the num rows at xstride = xlen. The accepted ZintNormWalkFlat208
   engine is exactly that row walk at row stride = xlen, so this export
   states the make_fg instance with its exact executed-word image.
   No centering/sign law, CRT law, NTT/root/table property or desired
   output is claimed. -/
theorem make_fg_normalization {s : State} {root tmp : ArrayPointer} {num xlen : Nat}
    {W pv : Nat → BitVec 32} (fixed : ZintNormWalkFixed208.Fixed s root tmp num xlen pv)
    (uc : Cell s "u".toList 0) (xb : s.arrays "x".toList=some root)
    (data : ZintNormWalkFlat208.Data s root (num*xlen) W) :
    ∃ out, Exec ZintNormWalk194.walkLoop s ⟨out,.normal⟩ ∧
      ZintNormWalkFixed208.Fixed out root tmp num xlen pv ∧
      Cell out "u".toList num ∧
      out.arrays "x".toList=some (ZintNormWalkIncrement208.row root xlen num) ∧
      ZintNormWalkFlat208.Data out root (num*xlen) (ZintNormWalkFlat208.words xlen W pv) ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < num*xlen → Word32Memory176.Separate (elem root i) q) →
        Load32 s.heap q old → Load32 out.heap q old) :=
  ZintNormWalkFlat208.source s root tmp num xlen W pv fixed uc xb data

/- ===== The original co-reduction u-loop of zint_rebuild_CRT =====

   `for (u = 1; u < xlen; u++)` around the round body, source-bound as
   ZintRebuildCrt194.coLoop. At loop counter k the first k words of every
   row are reassembled and the first k words of tmp hold the product of
   the processed prime moduli; the families below record those executed
   word images. rowAt/tmpAt k are the images at loop counter u = k. -/

def tmpAt (fv : Nat → Nat×Nat×Nat) (T0 : Nat → BitVec 32) : (k : Nat) → Nat → BitVec 32
  | 0 => T0
  | 1 => T0
  | k+2 => CrtMulCall213.words (tmpAt fv T0 (k+1)) (pVal (fv (k+1))) (k+1)

def rowAt (fv : Nat → Nat×Nat×Nat) (T0 W0 : Nat → BitVec 32) (stride : Nat) :
    (k : Nat) → Nat → BitVec 32
  | 0 => W0
  | 1 => W0
  | k+2 => CrtWalkFlat214.words (k+1) stride (rowAt fv T0 W0 stride (k+1)) (tmpAt fv T0 (k+1))
      (pVal (fv (k+1))) (iVal (fv (k+1))) (rVal (fv (k+1))) (sVal (fv (k+1)))

theorem tmpAt_succ (fv : Nat → Nat×Nat×Nat) (T0 : Nat → BitVec 32) (m : Nat) :
    tmpAt fv T0 (m+2)=CrtMulCall213.words (tmpAt fv T0 (m+1)) (pVal (fv (m+1))) (m+1) := rfl

theorem rowAt_succ (fv : Nat → Nat×Nat×Nat) (T0 W0 : Nat → BitVec 32) (stride : Nat) (m : Nat) :
    rowAt fv T0 W0 stride (m+2)=CrtWalkFlat214.words (m+1) stride (rowAt fv T0 W0 stride (m+1))
      (tmpAt fv T0 (m+1)) (pVal (fv (m+1))) (iVal (fv (m+1))) (rVal (fv (m+1))) (sVal (fv (m+1))) := rfl

/- The loop guard and increment, source-bound to the parsed co-loop. -/
theorem coGuard_eval (s : State) (k L : Nat) (kb : k < 2^64) (Lb : L < 2^64)
    (uc : Cell s ZintNormWalk194.uName k) (lc : Cell s ZintNormWalk194.xlenName L) :
    KeygenWordExpr.Eval s ZintRebuildCrt194.coGuard (C99ScalarReference.boolean (decide (k < L))) := by
  rw [ZintRebuildCrt194.co_guard]
  exact .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s ZintNormWalk194.uName k uc))
    (.scalar _ _ (C99LoopScalar141.read s ZintNormWalk194.xlenName L lc)) (C99NatWord141.less k L kb Lb)

theorem coInc_shape : ZintRebuildCrt194.coInc=
    ZintNormWord194.wordScalar (.update ZintNormWalk194.uName .add (.literal .i32 1)) := by decide

theorem coInc_run (s : State) (k : Nat) (kb : k+1 < 2^64) (uc : Cell s ZintNormWalk194.uName k) :
    Exec ZintRebuildCrt194.coInc s ⟨CrtState205.set64 s "u" (C99NatWord141.word (k+1)),.normal⟩ := by
  rw [coInc_shape]
  exact ZintNormWord194.word_update s ZintNormWalk194.uName .add (.literal .i32 1) .uint64
    (.uint64 (C99NatWord141.word k)) (.int32 1) (.uint64 (C99NatWord141.word (k+1))) uc
    (.literal .int32 1) (C99NatWord141.add_one k (by omega))

/- PrimeObject transport across one round: the primes table is readonly
   in its own block, so the round writes never touch its words. -/
theorem object_keep {s out : State} {root tmp : ArrayPointer} {num len stride : Nat}
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (rootWritable : s.heap.writable root.block=true) (tmpWritable : s.heap.writable tmp.block=true)
    (writableEq : out.heap.writable=s.heap.writable) (sizeEq : out.heap.size=s.heap.size)
    (keep : ∀ q old, (∀ i j, i < num → j ≤ len → Word32Memory176.Separate (point root stride i j) q) →
      (∀ t, t ≤ len → Word32Memory176.Separate (elem tmp t) q) →
      Load32 s.heap q old → Load32 out.heap q old) :
    KeygenStaticTables.PrimeObject out.heap primes .ternary := by
  have nroot : primes.block≠root.block := by
    intro eq
    rw [← eq] at rootWritable
    have flip := object.2.2.2.1
    rw [rootWritable] at flip
    cases flip
  have ntmp : primes.block≠tmp.block := by
    intro eq
    rw [← eq] at tmpWritable
    have flip := object.2.2.2.1
    rw [tmpWritable] at flip
    cases flip
  refine ⟨object.1,object.2.1,object.2.2.1,?_,?_,?_,?_⟩
  · rw [writableEq]; exact object.2.2.2.1
  · rw [sizeEq]; exact object.2.2.2.2.1
  · rw [sizeEq]; exact object.2.2.2.2.2.1
  · intro i v hv field
    apply keep (KeygenStaticTables.primeField primes i field) _
      (fun j t _ _ => Or.inl (Ne.symm nroot)) (fun t _ => Or.inl (Ne.symm ntmp))
    exact object.2.2.2.2.2.2 i v hv field

/- The loop-level invariant at counter k: the one-round domain at
   counter k plus the loop cells and the global table/separation domain.
   rowAt/tmpAt k are the executed row/tmp images at this counter. -/
structure LoopInput (s : State) (root tmp : ArrayPointer) (num L stride : Nat)
    (fv : Nat → Nat×Nat×Nat) (W0 T0 : Nat → BitVec 32) (k : Nat) : Prop where
  nBound : num < 2^64
  LBound : L < 2^64
  strideBound : stride < 2^64
  roomL : L+1 ≤ stride
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
  data : ZintNormWalkFlat208.Data s root (num*stride) (rowAt fv T0 W0 stride k)
  tmpRead : ∀ j, j < k → Load32 s.heap (elem tmp j) (tmpAt fv T0 k j)

theorem loop_round {s : State} {root tmp : ArrayPointer} {num L stride : Nat}
    {fv : Nat → Nat×Nat×Nat} {W0 T0 : Nat → BitVec 32} {k : Nat}
    (input : LoopInput s root tmp num L stride fv W0 T0 k) :
    RoundInput s root tmp num k stride (rowAt fv T0 W0 stride k) (tmpAt fv T0 k) (fv k) := by
  have kpos : k < 2^64 := by have h := input.LBound; have b := input.kBound; omega
  have boundK : (elem tmp k).index<(elem tmp k).count := by
    show tmp.index+k<tmp.count
    have h := input.tmpRoomL; have b := input.kBound; omega
  have allocK : Allocated s.heap (elem tmp k) :=
    ZintRebuildCrt194.alloc_same_block input.tmpAlloc rfl rfl rfl rfl input.tmpAlloc.2.1 boundK
  refine ⟨input.nBound,input.strideBound,?_,input.width,input.capacity,input.rootWritable,
    input.xxBinding,input.tmpBinding,input.numCell,input.strideCell,?_,input.data,input.tmpWidth,?_,
    input.tmpWritable,allocK,?_,?_⟩
  · have h := input.roomL; have b := input.kBound; omega
  · exact ⟨kpos,input.uCell,input.rows k input.kBound,input.primesBinding,input.primeObject⟩
  · show tmp.index+k+1≤tmp.count
    have h := input.tmpRoomL; have b := input.kBound; omega
  · intro j jb; exact input.tmpRead j jb
  · intro i j t ib jb tb; exact input.apart i j t ib jb (by have b := input.kBound; omega)

/- Scope restoration of the round body: the private p/p0i/s/R2/v names
   return to their caller values; other locals, arrays and the heap come
   from the round output. -/
theorem restore_local {before after : State} {names : List Name} (name : Name)
    (absent : name∉names) :
    (C99ArrayReference.restoreScope before after names []).locals name=after.locals name := by
  have member : names.contains name = false := by
    apply Bool.eq_false_iff.mpr
    intro hc
    exact absent (List.contains_iff_mem.mp hc)
  simp only [C99ArrayReference.restoreScope,C99ScalarReference.restore]
  rw [member]
  simp

theorem restore_arrays {before after : State} {names : List Name} :
    (C99ArrayReference.restoreScope before after names []).arrays=after.arrays := by
  funext n
  simp only [C99ArrayReference.restoreScope]
  show (if ([].contains n : Bool) then before.arrays n else after.arrays n)=after.arrays n
  simp

theorem restore_heap {before after : State} {names : List Name} :
    (C99ArrayReference.restoreScope before after names []).heap=after.heap := rfl

/- Exit state of the completed co-reduction loop: u = xlen, the fully
   reassembled row image rowAt L and the product image tmpAt L. -/
structure LoopResult (s out : State) (root tmp : ArrayPointer) (num L stride : Nat)
    (fv : Nat → Nat×Nat×Nat) (W0 T0 : Nat → BitVec 32) : Prop where
  uCell : Cell out "u".toList L
  xlenCell : Cell out "xlen".toList L
  numCell : Cell out "num".toList num
  strideCell : Cell out "xstride".toList stride
  xxBinding : out.arrays "xx".toList=some root
  tmpBinding : out.arrays "tmp".toList=some tmp
  primesBinding : out.arrays "primes".toList=some primes
  data : ZintNormWalkFlat208.Data out root (num*stride) (rowAt fv T0 W0 stride L)
  tmpRead : ∀ j, j < L → Load32 out.heap (elem tmp j) (tmpAt fv T0 L j)
  primeObject : KeygenStaticTables.PrimeObject out.heap primes .ternary
  locals : ∀ name : Name, name≠"u".toList → name∉CrtRoundShape205.localNames → out.locals name=s.locals name
  keep : ∀ q old, (∀ i j, i < num → j < L → Word32Memory176.Separate (point root stride i j) q) →
    (∀ t, t < L → Word32Memory176.Separate (elem tmp t) q) → Load32 s.heap q old → Load32 out.heap q old

theorem remaining (count m : Nat) (s : State) (root tmp : ArrayPointer) (num L stride : Nat)
    (fv : Nat → Nat×Nat×Nat) (W0 T0 : Nat → BitVec 32)
    (input : LoopInput s root tmp num L stride fv W0 T0 (m+1)) (finish : m+1+count=L) :
    ∃ out, Exec ZintRebuildCrt194.coLoop s ⟨out,.normal⟩ ∧
      LoopResult s out root tmp num L stride fv W0 T0 := by
  induction count generalizing m s with
  | zero =>
    have eq : m+1=L := by omega
    subst eq
    have test : KeygenWordExpr.Eval s ZintRebuildCrt194.coGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean] using
        coGuard_eval s (m+1) (m+1) (by have h := input.LBound; omega) input.LBound
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
      round_source (loop_round input)
    have stable : KeygenMemoryStability.Stable s.heap out2.heap :=
      KeygenMemoryStability.zint _ _ _ roundRun
    have sizeEq : out2.heap.size=s.heap.size := stable.size
    have writableEq : out2.heap.writable=s.heap.writable := stable.writable
    have innerRun : Exec CrtRoundShape205.inner s ⟨out2,.normal⟩ := by
      rw [round_shape]; exact roundRun
    have scopeRun : Exec ZintRebuildCrt194.coBody s
        ⟨C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames [],.normal⟩ := by
      rw [CrtRoundShape205.shape]
      exact .scope _ _ _ _ _ innerRun
    have midU : Cell (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u".toList (m+1) :=
      (restore_local (names:=CrtRoundShape205.localNames) "u".toList (by decide)).trans fixed2.uCell
    have midNum : Cell (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "num".toList num :=
      (restore_local (names:=CrtRoundShape205.localNames) "num".toList (by decide)).trans fixed2.numCell
    have midXlen : Cell (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "xlen".toList L :=
      ((restore_local (names:=CrtRoundShape205.localNames) "xlen".toList (by decide)).trans
        (lsR "xlen".toList (by decide))).trans input.xlenCell
    have midStride : Cell (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "xstride".toList stride :=
      (restore_local (names:=CrtRoundShape205.localNames) "xstride".toList (by decide)).trans fixed2.strideCell
    have midData : ZintNormWalkFlat208.Data (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames [])
        root (num*stride) (rowAt fv T0 W0 stride (m+2)) := by
      intro i ib
      rw [restore_heap,rowAt_succ]
      exact imageRoot i ib
    have midTmp : ∀ j, j < m+2 → Load32 (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []).heap
        (elem tmp j) (tmpAt fv T0 (m+2) j) := by
      rw [restore_heap,tmpAt_succ]
      intro j jb; exact imageTmp j (by omega)
    have midObject : KeygenStaticTables.PrimeObject
        (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []).heap primes .ternary := by
      rw [restore_heap]
      exact object_keep input.primeObject input.rootWritable input.tmpWritable writableEq sizeEq
        (fun q old rows tmps read => keepR q old rows tmps read)
    have incRun : Exec ZintRebuildCrt194.coInc
        (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames [])
        ⟨CrtState205.set64 (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u"
          (C99NatWord141.word (m+2)),.normal⟩ :=
      coInc_run (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) (m+1)
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
      · exact coGuard_eval s (m+1) L (by have h := input.LBound; omega) input.LBound input.uCell input.xlenCell
      · simp [guardTrue,C99ScalarReference.boolean,Value.integer]
    · refine ⟨fin.uCell,fin.xlenCell,fin.numCell,fin.strideCell,fin.xxBinding,fin.tmpBinding,
        fin.primesBinding,fin.data,fin.tmpRead,fin.primeObject,?_,?_⟩
      · intro name nu nl
        exact (fin.locals name nu nl).trans
          ((SelectedStepAddPrime195.locals_keep
            (C99ArrayReference.restoreScope s out2 CrtRoundShape205.localNames []) "u".toList .uint64
            (.uint64 (C99NatWord141.word (m+2))) name nu).trans
            ((restore_local (names:=CrtRoundShape205.localNames) name nl).trans (lsR name nl)))
      · intro q old rows tmps read
        apply fin.keep q old rows tmps
        exact keepR q old (fun i j ib jb => rows i j ib (by have h := guardTrue; omega))
          (fun t tb => tmps t (by have h := guardTrue; omega)) read

theorem outer_loop_source {s : State} {root tmp : ArrayPointer} {num L stride : Nat}
    {fv : Nat → Nat×Nat×Nat} {W0 T0 : Nat → BitVec 32}
    (input : LoopInput s root tmp num L stride fv W0 T0 1) (Lpos : 0 < L) :
    ∃ out, Exec ZintRebuildCrt194.coLoop s ⟨out,.normal⟩ ∧
      LoopResult s out root tmp num L stride fv W0 T0 :=
  remaining (L-1) 0 s root tmp num L stride fv W0 T0 input (by omega)

end FT1536.Source3.CrtRound214
