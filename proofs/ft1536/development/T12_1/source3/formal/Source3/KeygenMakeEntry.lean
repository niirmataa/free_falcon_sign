import Source3.KeygenMakeObjects

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The ORIGINAL call memory contains only arguments, profile/static objects
   and legal scratch. All coefficient allocation/separation premises of the
   earlier caller interface are derived from fresh automatic declarations. -/
namespace FT1536.Source3.KeygenMakeEntry
open C99ArrayReference (State Name)
open C99MemoryReference
open KeygenSearchContext (Context)
open KeygenMakeObjects (Exec Block pointer)

structure Original (ctx : Context) (s : State) (primes rev : ArrayPointer) : Prop where
  context : s.arrays "fk".toList=some ctx.object
  objectLegal : KeygenSearchContext.ObjectLegal s.heap ctx
  profile : KeygenSearchContext.M0 s.heap ctx
  table : s.tables "PRIMES3".toList=some primes
  primeObject : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revBinding : s.tables "REV10".toList=some rev
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  scratch : KeygenMkgm3Layout.Legal s.heap ctx.scratch
  contextScratch : ctx.scratch.block≠ctx.object.block
  contextTables : ∀ name p, s.tables name=some p → p.block≠ctx.object.block
  staticLive : ∀ name p, s.tables name=some p → 0<s.heap.size p.block

def input (blocks : Fin 6 → Nat) (slot : Fin 4) : ArrayPointer :=
  pointer blocks ⟨slot.val,by have := slot.isLt; omega⟩
def publicPointer (blocks : Fin 6 → Nat) : ArrayPointer := pointer blocks 4
theorem input_name (slot : Fin 4) : KeygenMakeObjects.name ⟨slot.val,by have := slot.isLt; omega⟩=
    (KeygenResidueTrace.names slot).2.toList := by fin_cases slot <;> rfl
theorem input_width (blocks : Fin 6 → Nat) (slot : Fin 4) : (input blocks slot).elementBytes=2 := by
  fin_cases slot <;> rfl
theorem object_live (ctx : Context) (s : State) (primes rev : ArrayPointer)
    (original : Original ctx s primes rev) : 0<s.heap.size ctx.object.block := by
  have h := original.objectLegal.2.1; omega
theorem scratch_live (ctx : Context) (s : State) (primes rev : ArrayPointer)
    (original : Original ctx s primes rev) : 0<s.heap.size ctx.scratch.block := by
  obtain ⟨width,align,count,extent,fit,writable⟩ := original.scratch
  dsimp [KeygenMkgm3Layout.scratchWords] at count
  omega
theorem outside_fk : ∀ slot : Fin 6, "fk".toList≠KeygenMakeObjects.name slot := by
  intro slot; fin_cases slot <;> decide
theorem allocated_block (before after : Memory) (p : ArrayPointer)
    (same : Block before after p.block) (source : Allocated before p) : Allocated after p := by
  simpa only [Allocated,same.1] using source
theorem load32_block (before after : Memory) (p : ArrayPointer) (w : BitVec 32)
    (same : Block before after p.block) (source : Load32 before p w) : Load32 after p w := by
  cases source with
  | load bytes legal width values =>
    exact .load after p bytes (allocated_block before after p same legal) width
      (fun i => (same.2.2 _).trans (values i))
theorem load16_block (before after : Memory) (p : ArrayPointer) (w : BitVec 16)
    (same : Block before after p.block) (source : C99NarrowReads.Load16 before p w) : C99NarrowReads.Load16 after p w := by
  cases source with
  | load bytes legal width values =>
    exact .load after p bytes (allocated_block before after p same legal) width
      (fun i => (same.2.2 _).trans (values i))
theorem prime_block (before after : Memory) (p : ArrayPointer)
    (same : Block before after p.block) (source : KeygenStaticTables.PrimeObject before p .ternary) :
    KeygenStaticTables.PrimeObject after p .ternary := by
  obtain ⟨width,index,count,readonly,extent,fit,values⟩ := source
  refine ⟨width,index,count,by rw [same.2.1]; exact readonly,
    by rw [same.1]; exact extent,by rw [same.1]; exact fit,?_⟩
  intro i v member field
  exact load32_block before after _ _ same (values i v member field)
theorem rev_block (before after : Memory) (p : ArrayPointer)
    (same : Block before after p.block) (source : KeygenMkgm3RevMemory.SourceTable before p) :
    KeygenMkgm3RevMemory.SourceTable after p := by
  obtain ⟨readonly,data,parsed,values⟩ := source
  refine ⟨by rw [same.2.1]; exact readonly,data,parsed,?_⟩
  intro i n member
  exact load16_block before after _ _ same (values i n member)
theorem original_transport (ctx : Context) (before after : State) (primes rev : ArrayPointer)
    (original : Original ctx before primes rev) (blocks : Fin 6 → Nat)
    (source : Exec 0 before blocks after) : Original ctx after primes rev := by
  have sameContext := KeygenMakeObjects.live_frame 0 before after blocks source ctx.object.block
    (object_live ctx before primes rev original)
  have sameScratch := KeygenMakeObjects.live_frame 0 before after blocks source ctx.scratch.block
    (scratch_live ctx before primes rev original)
  have tables := (KeygenMakeObjects.slots 0 before after blocks source).2
  have tableFrame : ∀ name p, before.tables name=some p → Block before.heap after.heap p.block :=
    fun name p binding => KeygenMakeObjects.live_frame 0 before after blocks source p.block (original.staticLive name p binding)
  refine ⟨(KeygenMakeObjects.outside_name 0 before after blocks source _ (fun slot _ => outside_fk slot)).trans original.context,
    ?_,?_,tables ▸ original.table,prime_block _ _ primes (tableFrame _ primes original.table) original.primeObject,
    tables ▸ original.revBinding,rev_block _ _ rev (tableFrame _ rev original.revBinding) original.revSource,
    ?_,original.contextScratch,?_,?_⟩
  · simpa only [KeygenSearchContext.ObjectLegal,sameContext.1] using original.objectLegal
  · exact ⟨load32_block _ _ _ _ sameContext original.profile.1,load32_block _ _ _ _ sameContext original.profile.2⟩
  · simpa only [KeygenMkgm3Layout.Legal,sameScratch.1,sameScratch.2.1] using original.scratch
  · simpa only [tables] using original.contextTables
  · intro name p binding
    have old := tables ▸ binding
    rw [(tableFrame name p old).1]
    exact original.staticLive name p old
theorem initial (ctx : Context) (before after : State) (primes rev : ArrayPointer)
    (original : Original ctx before primes rev) (blocks : Fin 6 → Nat) (source : Exec 0 before blocks after) :
    KeygenCallerEntry.Initial ctx after (input blocks) (publicPointer blocks) primes rev := by
  have retained := original_transport ctx before after primes rev original blocks source
  have separate := KeygenMakeObjects.distinct 0 before after blocks source
  have liveContext := object_live ctx before primes rev original
  have liveScratch := scratch_live ctx before primes rev original
  refine ⟨retained.context,?_,(KeygenMakeObjects.object 0 before after blocks source 4 (by decide)).1,
    retained.profile,retained.table,retained.primeObject,retained.revBinding,retained.revSource,retained.scratch,
    ?_,input_width blocks,?_,?_,?_,retained.contextScratch,retained.contextTables,?_,?_,?_,retained.staticLive⟩
  · intro slot
    rw [← input_name slot]
    exact (KeygenMakeObjects.object 0 before after blocks source _ (by omega)).1
  · intro slot; exact KeygenMakeObjects.allocated_object before after blocks source _
  · intro slot; exact KeygenMakeObjects.fresh_separate 0 before after blocks source _ (by omega) _ liveScratch
  · intro a b different
    exact separate _ _ (by omega) (by omega) (fun h => different (Fin.ext (congrArg (fun j : Fin 6 => j.val) h)))
  · intro slot; exact KeygenMakeObjects.fresh_separate 0 before after blocks source _ (by omega) _ liveContext
  · intro slot name p binding
    have tables := (KeygenMakeObjects.slots 0 before after blocks source).2
    exact KeygenMakeObjects.fresh_separate 0 before after blocks source _ (by omega) _
      (original.staticLive name p (tables ▸ binding))
  · intro slot
    exact separate 4 _ (by decide) (by omega) (fun h => by
      have equal := congrArg (fun j : Fin 6 => j.val) h
      change 4=slot.val at equal
      have := slot.isLt; omega)
  · exact Ne.symm (KeygenMakeObjects.fresh_separate 0 before after blocks source 4 (by decide) _ liveContext)

end FT1536.Source3.KeygenMakeEntry
