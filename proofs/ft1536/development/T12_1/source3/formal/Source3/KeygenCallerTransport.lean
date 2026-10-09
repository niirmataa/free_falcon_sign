import Source3.KeygenCallerEntry

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Derive legal root input through actual calls. A static table's own block
   is preserved by immutable-byte stability, not by requiring that table to
   be disjoint from every table (including itself). -/
namespace FT1536.Source3.KeygenCallerTransport
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenRootCaller (Legal)
open KeygenAttemptSlots (Slots)

theorem protected_slots (ctx : Context) (before after : State) (block : Nat) (slots : Slots before after)
    (source : KeygenRootSearch.Protected ctx before block) : KeygenRootSearch.Protected ctx after block := by
  exact ⟨source.1,by simpa only [slots.2] using source.2⟩
theorem profile_bytes (ctx : Context) (before after : Memory) (profile : KeygenSearchContext.M0 before ctx)
    (sizes : after.size=before.size) (bytes : ∀ offset, after.bytes ctx.object.block offset=before.bytes ctx.object.block offset) :
    KeygenSearchContext.M0 after ctx :=
  ⟨Gate00Memory.load32_transport _ _ _ _ profile.1 sizes (fun _ => bytes _),
    Gate00Memory.load32_transport _ _ _ _ profile.2 sizes (fun _ => bytes _)⟩
theorem legal_stable (ctx : Context) (before after : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx before input primes rev) (slots : Slots before after)
    (stable : KeygenMemoryStability.Stable before.heap after.heap) (profile : KeygenSearchContext.M0 after.heap ctx) :
    Legal ctx after input primes rev := by
  exact ⟨(congrFun slots.1 _).trans legal.context,fun slot => (congrFun slots.1 _).trans (legal.inputs slot),profile,
    (congrFun slots.2 _).trans legal.table,KeygenRootObjects.prime _ _ _ _ legal.primeObject stable,
    (congrFun slots.2 _).trans legal.revBinding,KeygenRootObjects.rev_table _ _ _ legal.revSource stable,
    KeygenRootObjects.scratch _ _ _ legal.scratch stable,legal.width,legal.separate,legal.disjoint,
    protected_slots _ _ _ _ slots legal.contextProtected,protected_slots _ _ _ _ slots legal.fProtected,
    protected_slots _ _ _ _ slots legal.gProtected⟩
theorem prime_same (before after : Memory) (p : ArrayPointer) (source : KeygenStaticTables.PrimeObject before p .ternary)
    (same : ShakeExtractFrame.SameBlock before after p.block) : KeygenStaticTables.PrimeObject after p .ternary := by
  obtain ⟨width,index,count,readonly,extent,bound,words⟩ := source
  refine ⟨width,index,count,by rw [same.2.1]; exact readonly,
    by rw [same.1]; exact extent,by rw [same.1]; exact bound,?_⟩
  intro i v hi field
  exact Gate00Memory.load32_transport _ _ _ _ (words i v hi field) same.1 (fun _ => same.2.2 _)
theorem rev_same (before after : Memory) (p : ArrayPointer) (source : KeygenMkgm3RevMemory.SourceTable before p)
    (same : ShakeExtractFrame.SameBlock before after p.block) : KeygenMkgm3RevMemory.SourceTable after p := by
  obtain ⟨readonly,data,parsed,words⟩ := source
  refine ⟨by rw [same.2.1]; exact readonly,data,parsed,?_⟩
  intro i n hi
  exact C99NarrowReads.load16_transport _ _ _ _ (words i n hi) same.1 (fun _ => same.2.2 _)
theorem sampler_locals (ctx : Context) (before after : State) (name : String) (source : KeygenSamplerContext.Call ctx before name after) :
    after.locals=before.locals := by
  cases source with
  | run resolved source => exact (KeygenSamplerCalls.slots _ _ _ _ source).1
theorem sampling_table (ctx : Context) (before middle after : State) (input : Fin 4 → ArrayPointer) (primes rev p : ArrayPointer)
    (name : C99ArrayReference.Name) (binding : before.tables name=some p) (live : 0<before.heap.size p.block)
    (entry : KeygenAttemptMaterial.Entry ctx before (input 0) (input 1)) (legal : Legal ctx before input primes rev)
    (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" after) :
    ShakeExtractFrame.SameBlock before.heap after.heap p.block := by
  have hc := Ne.symm (legal.contextProtected.2 name p binding)
  have hf := Ne.symm (legal.fProtected.2 name p binding)
  have hg := Ne.symm (legal.gProtected.2 name p binding)
  have middleSize : C99CountedWords.Limit middle := (congrFun (sampler_locals _ _ _ _ first) _).trans entry.size
  have middlePointer := (congrFun (KeygenAttemptMaterial.sampler_slots _ _ _ _ first).1 _).trans entry.gPointer
  cases first with
  | run resolved first =>
    cases second with
    | run resolved second =>
      have a := KeygenSamplerCalls.frame (KeygenSamplerContext.rng ctx) before middle "f" (input 0) p.block hc hf live entry.size entry.fPointer first
      have b := KeygenSamplerCalls.frame (KeygenSamplerContext.rng ctx) middle after "g" (input 1) p.block hc hg
        (by rw [a.1]; exact live) middleSize middlePointer second
      exact ShakeExtractFrame.same_trans _ _ _ p.block a b
theorem sampling_root (ctx : Context) (before middle after : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (entry : KeygenAttemptMaterial.Entry ctx before (input 0) (input 1)) (legal : Legal ctx before input primes rev)
    (primesLive : 0<before.heap.size primes.block) (revLive : 0<before.heap.size rev.block)
    (first : KeygenSamplerContext.Call ctx before "f" middle) (second : KeygenSamplerContext.Call ctx middle "g" after) :
    Legal ctx after input primes rev := by
  have slots := KeygenAttemptSlots.trans _ _ _ (KeygenAttemptMaterial.sampler_slots _ _ _ _ first)
    (KeygenAttemptMaterial.sampler_slots _ _ _ _ second)
  have metadata := KeygenAttemptMaterial.sampling_metadata ctx before middle after (input 0) (input 1) entry first second
  have middleSize : C99CountedWords.Limit middle := (congrFun (sampler_locals _ _ _ _ first) _).trans entry.size
  have gp := (congrFun (KeygenAttemptMaterial.sampler_slots _ _ _ _ first).1 _).trans entry.gPointer
  have firstProfile := KeygenSamplerContext.profile ctx before middle "f" (input 0) first (Ne.symm entry.fOutside) entry.size entry.fPointer legal.profile
  have finalProfile := KeygenSamplerContext.profile ctx middle after "g" (input 1) second (Ne.symm entry.gOutside) middleSize gp firstProfile
  have primesSame := sampling_table ctx before middle after input primes rev primes "PRIMES3".toList legal.table primesLive entry legal first second
  have revSame := sampling_table ctx before middle after input primes rev rev "REV10".toList legal.revBinding revLive entry legal first second
  exact ⟨(congrFun slots.1 _).trans legal.context,fun slot => (congrFun slots.1 _).trans (legal.inputs slot),finalProfile,
    (congrFun slots.2 _).trans legal.table,prime_same _ _ _ legal.primeObject primesSame,
    (congrFun slots.2 _).trans legal.revBinding,rev_same _ _ _ legal.revSource revSame,
    by simpa only [KeygenMkgm3Layout.Legal,metadata.1,metadata.2] using legal.scratch,
    legal.width,legal.separate,legal.disjoint,protected_slots _ _ _ _ slots legal.contextProtected,
    protected_slots _ _ _ _ slots legal.fProtected,protected_slots _ _ _ _ slots legal.gProtected⟩
theorem resultant_root (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx before input primes rev) (source : KeygenResultantGate.Exec before out) : Legal ctx out.state input primes rev := by
  have result := KeygenAttemptMaterial.resultants before out source
  exact legal_stable ctx before out.state input primes rev legal result.1 result.2
    (profile_bytes ctx before.heap out.state.heap legal.profile result.2.size
      (fun offset => congrFun (congrFun (KeygenResultantGate.bytes before out source) _) offset))
theorem norm_root (ctx : Context) (before : State) (out : Result) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx before input primes rev) (separate : KeygenAttemptNorm.Protected ctx before ctx.object.block)
    (source : KeygenAttemptNorm.Exec ctx before out) : Legal ctx out.state input primes rev := by
  have stable := KeygenAttemptNorm.stable ctx before out source
  exact legal_stable ctx before out.state input primes rev legal (KeygenAttemptSlots.norm ctx before out source) stable
    (profile_bytes ctx before.heap out.state.heap legal.profile stable.size (KeygenAttemptNorm.bytes ctx before out source ctx.object.block separate))
theorem public_slots (before after : State) (v : C99IntegerReference.Value) (source : KeygenPublicSource.Call before after v) : Slots before after := by
  cases source; exact ⟨rfl,rfl⟩
theorem load32_live (heap : Memory) (p : ArrayPointer) (word : BitVec 32) (read : Load32 heap p word) : 0<heap.size p.block := by
  cases read with
  | load data allocated width bytes => exact KeygenCallerEntry.allocated_live _ _ allocated
theorem context_live (ctx : Context) (heap : Memory) (profile : KeygenSearchContext.M0 heap ctx) : 0<heap.size ctx.object.block :=
  load32_live heap (KeygenSearchContext.field ctx 0 4) 10 profile.1
theorem public_root (ctx : Context) (before after : State) (v : C99IntegerReference.Value) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : Legal ctx before input primes rev) (separate : KeygenPublicFrame.Outside before ["h".toList] ctx.object.block)
    (source : KeygenPublicSource.Call before after v) : Legal ctx after input primes rev := by
  have stable := KeygenPublicStability.call before after v source
  have frame := KeygenPublicSource.frame before after v source ctx.object.block separate legal.contextProtected.2 (context_live ctx before.heap legal.profile)
  exact legal_stable ctx before after input primes rev legal (public_slots before after v source) stable
    (profile_bytes ctx before.heap after.heap legal.profile stable.size frame.2.2)

end FT1536.Source3.KeygenCallerTransport
