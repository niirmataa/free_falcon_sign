import Source3.ZintNormWalkFlat208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtEntry208
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open KeygenFullData127 (primes)
open SelectedTopInit178 (p)
open ZintNormWalkFlat208 (Data)
open KeygenZintCall (Exec)

structure Input (s : State) (root tmp : ArrayPointer) : Prop where
  xxBinding : s.arrays "xx".toList=some root
  tmpBinding : s.arrays "tmp".toList=some tmp
  primesBinding : s.arrays "primes".toList=some primes
  lenCell : Cell s "xlen".toList 2
  strideCell : Cell s "xstride".toList 2
  numCell : Cell s "num".toList 256
  signCell : s.locals "normalize_signed".toList=some (.int32,some (.int32 1))
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  width : root.elementBytes=4
  capacity : root.index+512 ≤ root.count
  writable : s.heap.writable root.block=true
  tmpAllocated : Allocated s.heap tmp
  tmpWidth : tmp.elementBytes=4
  tmpCapacity : tmp.index+2 ≤ tmp.count
  tmpWritable : s.heap.writable tmp.block=true
  apart : ∀ i j, i < 512 → j < 2 → Separate (elem root i) (elem tmp j)

def before (s : State) (tmp : ArrayPointer) := ZintRebuildCrt194.d5 s tmp p

theorem heap (s : State) (tmp : ArrayPointer) : (before s tmp).heap=Word32Memory176.write s.heap tmp p := rfl

theorem locals (s : State) (tmp : ArrayPointer) (name : Name) (different : name≠"u".toList) :
    (before s tmp).locals name=s.locals name := ZintRebuildCrt194.d5_locals s tmp p name different

theorem arrays (s : State) (tmp : ArrayPointer) (name : Name) (different : name≠"x".toList) :
    (before s tmp).arrays name=s.arrays name := by
  change (ZintRebuildCrt194.d2 s).arrays name=s.arrays name
  exact (ZintRebuildCrt194.d2_arrays s name different).trans (ZintRebuildCrt194.d1_arrays s name)

theorem prime_load (s : State) (root tmp : ArrayPointer) (input : Input s root tmp) :
    Load32 s.heap (KeygenLevelCalls.fieldPointer primes .p) p :=
  input.object.2.2.2.2.2.2 0 (KeygenStaticReads.first .ternary) (KeygenStaticReads.first_value .ternary) .p

theorem prefix_source (s : State) (root tmp : ArrayPointer) (input : Input s root tmp) :
    Exec MakeFgCrtShape194.crtDeclU s ⟨ZintRebuildCrt194.d1 s,.normal⟩ ∧
    Exec MakeFgCrtShape194.crtDeclX (ZintRebuildCrt194.d1 s) ⟨ZintRebuildCrt194.d3 s,.normal⟩ ∧
    Exec MakeFgCrtShape194.crtStore (ZintRebuildCrt194.d3 s) ⟨ZintRebuildCrt194.d4 s tmp p,.normal⟩ ∧
    Exec ZintRebuildCrt194.coreHead (ZintRebuildCrt194.d4 s tmp p) ⟨before s tmp,.normal⟩ := by
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
  have primeRead : KeygenLevelCalls.PrimeRead (ZintRebuildCrt194.d3 s) "primes".toList (.literal .i32 0) .p (.uint32 p) :=
    .read primes p (ZintRebuildCrt194.i32zero_pointer _ _ _ primesAt (by decide)) rfl (by decide) (prime_load s root tmp input)
  have store : Exec MakeFgCrtShape194.crtStore (ZintRebuildCrt194.d3 s) ⟨ZintRebuildCrt194.d4 s tmp p,.normal⟩ := by
    rw [ZintRebuildCrt194.store_shape]
    exact .storePrime _ _ _ _ _ _ _ tmp p primeRead
      (ZintRebuildCrt194.i32zero_pointer _ _ _ tmpAt (by have h:=input.tmpCapacity; omega))
      (Word32Memory176.source _ _ _ input.tmpAllocated input.tmpWidth input.tmpWritable)
  have assign : Exec ZintRebuildCrt194.coreHead (ZintRebuildCrt194.d4 s tmp p) ⟨before s tmp,.normal⟩ := by
    rw [ZintRebuildCrt194.core_head]
    exact ZintRebuildCrt194.assign_i32_run _ _ _ .uint64 none (.int32 1) (ZintRebuildCrt194.d4_u_decl s tmp p)
      (WordAtoms205.literal _ 1)
  exact ⟨u,x,store,assign⟩

theorem object_after (s : State) (root tmp : ArrayPointer) (input : Input s root tmp) :
    KeygenStaticTables.PrimeObject (before s tmp).heap primes .ternary := by
  have stable:=KeygenMemoryStability.store32 _ _ _ _ (Word32Memory176.source s.heap tmp p input.tmpAllocated input.tmpWidth input.tmpWritable)
  exact KeygenMakeEntry.prime_block _ _ primes
    ⟨congrFun stable.size primes.block,congrFun stable.writable primes.block,
      fun offset => stable.readonly primes.block offset input.object.2.2.2.1⟩ input.object

theorem round_input (s : State) (root tmp : ArrayPointer) (input : Input s root tmp) :
    CrtRoundReady206.Input (before s tmp) root tmp 256 p := by
  refine ⟨by decide,input.width,input.capacity,input.writable,?_,?_,?_,object_after s root tmp input,
    ZintRebuildCrt194.d5_u_one s tmp p,?_,?_,?_,?_,input.tmpWritable,?_,?_⟩
  · exact (arrays s tmp "xx".toList (by decide)).trans input.xxBinding
  · exact (arrays s tmp "tmp".toList (by decide)).trans input.tmpBinding
  · exact (arrays s tmp "primes".toList (by decide)).trans input.primesBinding
  · exact (locals s tmp "num".toList (by decide)).trans input.numCell
  · exact (locals s tmp "xstride".toList (by decide)).trans input.strideCell
  · rw [heap]
    exact Word32Memory176.here _ _ _ input.tmpAllocated input.tmpWidth input.tmpWritable
  · have h:=input.tmpCapacity; omega
  · intro i
    have bound:=i.isLt
    refine ⟨input.apart (2*i.val) 0 (by omega) (by decide),?_⟩
    rw [CrtWalkFixed206.high_eq]
    exact input.apart (2*i.val+1) 0 (by omega) (by decide)
  · intro i
    have bound:=i.isLt
    refine ⟨input.apart (2*i.val) 1 (by omega) (by decide),?_⟩
    rw [CrtWalkFixed206.high_eq]
    exact input.apart (2*i.val+1) 1 (by omega) (by decide)

theorem data_after (s : State) (root tmp : ArrayPointer) (W : Nat → BitVec 32) (input : Input s root tmp)
    (data : Data s root 512 W) : Data (before s tmp) root 512 W := by
  intro i bound
  rw [heap]
  exact Word32Memory176.outside _ _ _ _ _ (StepCopyFixed203.separate_symm (input.apart i 0 bound (by decide))) (data i bound)

end FT1536.Source3.CrtEntry208
