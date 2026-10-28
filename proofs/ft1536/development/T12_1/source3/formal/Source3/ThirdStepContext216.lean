import Source3.ThirdStepLoop215
import Source3.ThirdStepPrefix215

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepContext216
open C99ArrayReference (State)
open C99MemoryReference (Allocated ArrayPointer)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)
open ThirdStepGenerator215 (Outer)
open ThirdStepLoop215 (init0)

noncomputable abbrev before (caller : State) := ThirdStepMove215.after caller
 noncomputable abbrev entry (caller : State) := init0 (before caller)

theorem outer (caller : State) (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap caller.heap) :
    Outer (entry caller) 0 := by
  have dim:=ThirdStepMove215.memory_domains caller stable
  refine ⟨rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,rfl,?_,?_⟩
  · exact dim.2.2
  · intro i bound
    change 0<4 ∧ 0%4=0 ∧ i<71680 ∧ 0+4*71680 ≤ (ThirdStepMove215.before caller).heap.size 31 ∧
      (ThirdStepMove215.before caller).heap.size 31 < 2^64
    exact ⟨by decide,by decide,bound,dim.1,dim.2.1⟩

theorem u_declared (caller : State) : (before caller).locals "u".toList=some (.uint64,none) := by rfl

theorem stable_entry (caller : State) (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap caller.heap)
    (run : Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (ThirdStepEntry215.entry caller) ⟨before caller,.normal⟩) :
    KeygenMemoryStability.Stable FirstStepEntry187.entry.heap (entry caller).heap := by
  have later:=KeygenHelperStability.make _ _ _ run
  change KeygenMemoryStability.Stable (ThirdStepEntry215.entry caller).heap (entry caller).heap at later
  rw [ThirdStepEntry215.entry_heap] at later
  exact KeygenMemoryStability.trans _ _ _ stable later

theorem object (caller : State) (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap (entry caller).heap) :
    KeygenStaticTables.PrimeObject (entry caller).heap primes .ternary :=
  KeygenMakeEntry.prime_block _ _ primes
    ⟨congrFun stable.size primes.block,congrFun stable.writable primes.block,
      fun offset => stable.readonly primes.block offset StepStaticInputs187.prime_object.2.2.2.1⟩ StepStaticInputs187.prime_object

theorem rev_source (caller : State) (stable : KeygenMemoryStability.Stable FirstStepEntry187.entry.heap (entry caller).heap) :
    KeygenMkgm3RevMemory.SourceTable (entry caller).heap rev :=
  KeygenMakeEntry.rev_block _ _ rev
    ⟨congrFun stable.size rev.block,congrFun stable.writable rev.block,
      fun offset => stable.readonly rev.block offset StepStaticInputs187.rev_source.1⟩ StepStaticInputs187.rev_source

theorem rev_binding (caller : State) (initial : caller.tables "REV10".toList=some rev)
    (run : Exec (.seq (KeygenMakeFgSource.part .step 0) (KeygenMakeFgSource.part .step 1))
      (ThirdStepEntry215.entry caller) ⟨before caller,.normal⟩) :
    (entry caller).tables "REV10".toList=some rev := by
  exact (congrFun (KeygenTables204.make _ _ _ run) "REV10".toList).trans initial

end FT1536.Source3.ThirdStepContext216
