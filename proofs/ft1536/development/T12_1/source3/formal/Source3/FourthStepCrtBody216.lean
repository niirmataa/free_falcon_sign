import Source3.ThirdStepCrtLoop215
import Source3.FourthStepPrimeRows216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original zint_rebuild_CRT source body for d4: num64, xlen=xstride6,
   actual tmp[0] prime store, all co-loop rounds and signed normalization. -/
namespace FT1536.Source3.FourthStepCrtBody216
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99LoopScalar141 (Cell)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open CrtState205 (Slot64)
open KeygenFullData127 (primes)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open CrtWalkIncrement214 (row point)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open KeygenZintCall (Stmt Exec)
open ZintNormWalkFlat208 (Data)

def fv : Nat → Nat×Nat×Nat
  | 0 => (2147355649,1907584673,127999)
  | 1 => (2147346433,1119654270,238827065)
  | 2 => (2147309569,686923925,434763914)
  | 3 => (2147281921,658779219,742235228)
  | 4 => (2147235841,1567830083,1964117354)
  | 5 => (2147217409,273379403,890663385)
  | 6 => FourthStepPrimeRows216.v6
  | _n+7 => (0,0,0)

def p0 : BitVec 32 := pVal (fv 0)
 def t0 : Nat → BitVec 32 := fun _ => p0
 def words6 (W : Nat → BitVec 32) : Nat → BitVec 32 :=
  ZintNormWalkFlat208.words 6 (CrtRound214.rowAt fv t0 W 6 6) (CrtRound214.tmpAt fv t0 6)

theorem rows6 (i : Nat) (bound : i ≤ 6) : (KeygenStaticTables.values .ternary)[i]?=some (fv i) := by
  match i with
  | 0 => exact FourthStepGenerator216.row0_value
  | 1 => exact FourthStepGenerator216.row1_value
  | 2 => exact FourthStepGenerator216.row2_value
  | 3 => exact FourthStepGenerator216.row3_value
  | 4 => exact FourthStepGenerator216.row4_value
  | 5 => exact FourthStepGenerator216.row5_value
  | 6 => exact FourthStepPrimeRows216.row6_value
  | n+7 => omega

/- Ordinary input domain of one d=4 rebuild call at the callee entry
   state: the three parameter cells, the row data and the tmp scratch
   capacity of the make_fg instance. -/
structure CrtInput (s : State) (root tmp : ArrayPointer) : Prop where
  xxBinding : s.arrays "xx".toList=some root
  tmpBinding : s.arrays "tmp".toList=some tmp
  primesBinding : s.arrays "primes".toList=some primes
  lenCell : Cell s "xlen".toList 6
  strideCell : Cell s "xstride".toList 6
  numCell : Cell s "num".toList 64
  signCell : s.locals "normalize_signed".toList=some (.int32,some (.int32 1))
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  width : root.elementBytes=4
  capacity : root.index+384 ≤ root.count
  writable : s.heap.writable root.block=true
  tmpAllocated : Allocated s.heap tmp
  tmpWidth : tmp.elementBytes=4
  tmpCapacity : tmp.index+7 ≤ tmp.count
  tmpWritable : s.heap.writable tmp.block=true
  apart : ∀ i j, i < 384 → j ≤ 6 → Separate (elem root i) (elem tmp j)

/- Cell/array/heap keeps through the body prefix states. -/
theorem heap5 (s : State) (tmp : ArrayPointer) : (ZintRebuildCrt194.d5 s tmp p0).heap=
    Word32Memory176.write (ZintRebuildCrt194.d3 s).heap tmp p0 := rfl

theorem arrays5 (s : State) (tmp : ArrayPointer) (name : Name) (different : name≠"x".toList) :
    (ZintRebuildCrt194.d5 s tmp p0).arrays name=s.arrays name := by
  change (ZintRebuildCrt194.d2 s).arrays name=s.arrays name
  exact (ZintRebuildCrt194.d2_arrays s name different).trans (ZintRebuildCrt194.d1_arrays s name)

theorem locals5 (s : State) (tmp : ArrayPointer) (name : Name) (different : name≠"u".toList) :
    (ZintRebuildCrt194.d5 s tmp p0).locals name=s.locals name :=
  ZintRebuildCrt194.d5_locals s tmp p0 name different

theorem prime_load (s : State) (root tmp : ArrayPointer) (input : CrtInput s root tmp) :
    Load32 s.heap (KeygenLevelCalls.fieldPointer primes .p) p0 :=
  input.object.2.2.2.2.2.2 0 (fv 0) (rows6 0 (by decide)) .p

/- The four-statement body prefix: u/x declarations, the tmp[0] store
   of the row-0 prime word and the u = 1 init. -/
theorem prefix_source (s : State) (root tmp : ArrayPointer) (input : CrtInput s root tmp) :
    Exec MakeFgCrtShape194.crtDeclU s ⟨ZintRebuildCrt194.d1 s,.normal⟩ ∧
    Exec MakeFgCrtShape194.crtDeclX (ZintRebuildCrt194.d1 s) ⟨ZintRebuildCrt194.d3 s,.normal⟩ ∧
    Exec MakeFgCrtShape194.crtStore (ZintRebuildCrt194.d3 s) ⟨ZintRebuildCrt194.d4 s tmp p0,.normal⟩ ∧
    Exec ZintRebuildCrt194.coreHead (ZintRebuildCrt194.d4 s tmp p0)
      ⟨ZintRebuildCrt194.d5 s tmp p0,.normal⟩ := by
  have u : Exec MakeFgCrtShape194.crtDeclU s ⟨ZintRebuildCrt194.d1 s,.normal⟩ := by
    rw [ZintRebuildCrt194.declu_shape]
    exact ZintNormWord194.word_declare .u64 ["u".toList] s
  have x : Exec MakeFgCrtShape194.crtDeclX (ZintRebuildCrt194.d1 s) ⟨ZintRebuildCrt194.d3 s,.normal⟩ := by
    rw [ZintRebuildCrt194.declx_split,ZintRebuildCrt194.declx_ptr,ZintRebuildCrt194.declx_tail]
    exact .seqNormal _ _ _ _ _ (ZintRebuildCrt194.declarePtr_run _ "x".toList) (ZintNormWord194.word_skip _)
  have primesAt : (ZintRebuildCrt194.d3 s).arrays "primes".toList=some primes :=
    (ZintRebuildCrt194.d2_arrays s "primes".toList (by decide)).trans input.primesBinding
  have tmpAt : (ZintRebuildCrt194.d3 s).arrays "tmp".toList=some tmp :=
    (ZintRebuildCrt194.d2_arrays s "tmp".toList (by decide)).trans input.tmpBinding
  have primeRead : KeygenLevelCalls.PrimeRead (ZintRebuildCrt194.d3 s) "primes".toList
      (.literal .i32 0) .p (.uint32 p0) :=
    .read primes p0 (ZintRebuildCrt194.i32zero_pointer _ _ _ primesAt (by decide)) rfl (by decide)
      (prime_load s root tmp input)
  have store : Exec MakeFgCrtShape194.crtStore (ZintRebuildCrt194.d3 s)
      ⟨ZintRebuildCrt194.d4 s tmp p0,.normal⟩ := by
    rw [ZintRebuildCrt194.store_shape]
    exact .storePrime _ _ _ _ _ _ _ tmp p0 primeRead
      (ZintRebuildCrt194.i32zero_pointer _ _ _ tmpAt (by have h:=input.tmpCapacity; omega))
      (Word32Memory176.source _ _ _ input.tmpAllocated input.tmpWidth input.tmpWritable)
  have assign : Exec ZintRebuildCrt194.coreHead (ZintRebuildCrt194.d4 s tmp p0)
      ⟨ZintRebuildCrt194.d5 s tmp p0,.normal⟩ := by
    rw [ZintRebuildCrt194.core_head]
    exact ZintRebuildCrt194.assign_i32_run _ _ _ .uint64 none (.int32 1)
      (ZintRebuildCrt194.d4_u_decl s tmp p0) (WordAtoms205.literal _ 1)
  exact ⟨u,x,store,assign⟩

theorem object5 (s : State) (root tmp : ArrayPointer) (input : CrtInput s root tmp) :
    KeygenStaticTables.PrimeObject (ZintRebuildCrt194.d5 s tmp p0).heap primes .ternary := by
  have stable:=KeygenMemoryStability.store32 _ _ _ _
    (Word32Memory176.source s.heap tmp p0 input.tmpAllocated input.tmpWidth input.tmpWritable)
  exact KeygenMakeEntry.prime_block _ _ primes
    ⟨congrFun stable.size primes.block,congrFun stable.writable primes.block,
      fun offset => stable.readonly primes.block offset input.object.2.2.2.1⟩ input.object

theorem data_after (s : State) (root tmp : ArrayPointer) (W : Nat → BitVec 32)
    (input : CrtInput s root tmp) (data : Data s root 384 W) :
    Data (ZintRebuildCrt194.d5 s tmp p0) root 384 W := by
  intro i bound
  rw [heap5]
  exact Word32Memory176.outside _ _ _ _ _
    (CrtRound214.sep_symm (input.apart i 0 bound (by decide))) (data i bound)

theorem tmp_read0 (s : State) (root tmp : ArrayPointer) (input : CrtInput s root tmp) :
    ∀ j, j < 1 → Load32 (ZintRebuildCrt194.d5 s tmp p0).heap (elem tmp j) (CrtRound214.tmpAt fv t0 1 j) := by
  intro j bound
  have zero : j = 0 := by omega
  subst zero
  show Load32 (ZintRebuildCrt194.d5 s tmp p0).heap (elem tmp 0) p0
  rw [heap5]
  exact Word32Memory176.here _ _ _ input.tmpAllocated input.tmpWidth input.tmpWritable

/- The co-loop driver input at u = 1 over the store state. -/
theorem loop_input (s : State) (root tmp : ArrayPointer) (W0 : Nat → BitVec 32)
    (input : CrtInput s root tmp) (data : Data s root 384 W0) :
    ThirdStepCrtLoop215.LoopInput (ZintRebuildCrt194.d5 s tmp p0) root tmp 64 6 6 fv W0 t0 1 := by
  refine ⟨by decide,by decide,by decide,by decide,input.width,?_,?_,input.tmpWidth,?_,?_,?_,
    ?_,?_,?_,?_,?_,?_,?_,?_,rows6,?_,?_,?_,?_⟩
  · show root.index+64*6≤root.count
    have h := input.capacity; omega
  · show (ZintRebuildCrt194.d5 s tmp p0).heap.writable root.block=true
    rw [heap5]; exact input.writable
  · exact input.tmpCapacity
  · show (ZintRebuildCrt194.d5 s tmp p0).heap.writable tmp.block=true
    rw [heap5]; exact input.tmpWritable
  · exact ZintRebuildCrt194.alloc_same_block (h:=(ZintRebuildCrt194.d5 s tmp p0).heap)
      input.tmpAllocated rfl rfl rfl rfl input.tmpAllocated.2.1
      (by show tmp.index+6<tmp.count; have h := input.tmpCapacity; omega)
  · intro i j t ib jt tb
    show Separate (point root 6 i j) (elem tmp t)
    exact input.apart (i*6+j) t (by omega) (by omega)
  · exact (arrays5 s tmp "xx".toList (by decide)).trans input.xxBinding
  · exact (arrays5 s tmp "tmp".toList (by decide)).trans input.tmpBinding
  · exact (arrays5 s tmp "primes".toList (by decide)).trans input.primesBinding
  · exact object5 s root tmp input
  · exact (locals5 s tmp "num".toList (by decide)).trans input.numCell
  · exact (locals5 s tmp "xlen".toList (by decide)).trans input.lenCell
  · exact (locals5 s tmp "xstride".toList (by decide)).trans input.strideCell
  · exact ZintRebuildCrt194.d5_u_one s tmp p0
  · omega
  · exact data_after s root tmp W0 input data
  · exact tmp_read0 s root tmp input

/- One complete d=4 zint_rebuild_CRT body execution over an abstract
   callee entry state. The output image is words6; only root words and
   the three tmp words are written. -/
theorem source (s : State) (root tmp : ArrayPointer) (W0 : Nat → BitVec 32)
    (input : CrtInput s root tmp) (data : Data s root 384 W0) :
    ∃ out, Exec (KeygenZintCall.calleeBody .rebuildCrt) s ⟨out,.normal⟩ ∧
      Data out root 384 (words6 W0) ∧
      (∀ q old, (∀ i, i < 384 → Separate (elem root i) q) →
        (∀ j, j < 6 → Separate (elem tmp j) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨declU,declX,store,head⟩ := prefix_source s root tmp input
  obtain ⟨co,coRun,coResult⟩ :=
    ThirdStepCrtLoop215.outer_loop_source (loop_input s root tmp W0 input data) (by decide)
  have stable := KeygenMemoryStability.zint _ _ _ coRun
  have writableCo : co.heap.writable root.block=true := by
    rw [stable.writable,heap5]; exact input.writable
  have normFixed : ZintNormWalkFixed208.Fixed co root tmp 64 6 (CrtRound214.tmpAt fv t0 6) := by
    refine ⟨by decide,by decide,by decide,input.width,?_,writableCo,coResult.tmpBinding,
      coResult.numCell,coResult.xlenCell,coResult.strideCell,?_,?_,?_⟩
    · show root.index+64*6≤root.count
      have h := input.capacity; omega
    · show tmp.index+0≤tmp.count
      have h := input.tmpCapacity; omega
    · intro j bound; exact coResult.tmpRead j bound
    · intro i j k ib jb kb
      show Separate (point root 6 i j) (elem tmp k)
      exact input.apart (i*6+j) k (by omega) (by omega)
  have uc : Slot64 co "u" (C99NatWord141.word 6) := coResult.uCell
  have sign : co.locals "normalize_signed".toList=some (.int32,some (.int32 1)) :=
    ((coResult.locals "normalize_signed".toList (by decide) (by decide)).trans
      (locals5 s tmp "normalize_signed".toList (by decide))).trans input.signCell
  obtain ⟨out,normRun,outFixed,outU,outX,outData,outLocals,outArrays,normKeep⟩ :=
    ZintNormWalkBranch208.source co root tmp 64 6 (CrtRound214.rowAt fv t0 W0 6 6)
      (CrtRound214.tmpAt fv t0 6) (C99NatWord141.word 6) normFixed uc coResult.xxBinding sign coResult.data
  have core : Exec MakeFgCrtShape194.crtCore (ZintRebuildCrt194.d4 s tmp p0) ⟨co,.normal⟩ := by
    rw [ZintRebuildCrt194.core_split]
    exact .seqNormal _ _ _ _ _ head coRun
  have whole : Exec (KeygenZintCall.calleeBody .rebuildCrt) s ⟨out,.normal⟩ := by
    change Exec MakeFgCrtShape194.crtBody s ⟨out,.normal⟩
    rw [MakeFgCrtShape194.crt_split1,MakeFgCrtShape194.crt_split2,MakeFgCrtShape194.crt_split3,
      MakeFgCrtShape194.crt_split4]
    exact .seqNormal _ _ _ _ _ declU (.seqNormal _ _ _ _ _ declX
      (.seqNormal _ _ _ _ _ store (.seqNormal _ _ _ _ _ core normRun)))
  refine ⟨out,whole,outData,?_⟩
  intro q old rootSep tmpSep read
  have beforeRead : Load32 (ZintRebuildCrt194.d5 s tmp p0).heap q old := by
    rw [heap5]
    exact Word32Memory176.outside _ _ _ _ _ (tmpSep 0 (by decide)) read
  have coSep : ∀ i j, i < 64 → j < 6 → Separate (point root 6 i j) q := by
    intro i j ib jb
    show Separate (point root 6 i j) q
    exact rootSep (i*6+j) (by omega)
  have normRoot : ∀ i, i < 384 → Separate (elem root i) q := rootSep
  have coKeep := coResult.keep q old coSep (fun t tb => tmpSep t tb) beforeRead
  exact normKeep q old normRoot coKeep

end FT1536.Source3.FourthStepCrtBody216
