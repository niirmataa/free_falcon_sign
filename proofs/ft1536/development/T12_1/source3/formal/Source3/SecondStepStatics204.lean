import Source3.SecondStepFirstBodyKeep204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepStatics204
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes rev)

noncomputable abbrev entry (callee : State) := SecondStepEntry196.entry (SecondStepLengths197.caller callee)

theorem entry_heap (callee : State) : (entry callee).heap=callee.heap :=
  (SecondStepEntry196.entry_heap _).trans
    ((SecondStepStart196.heap _).symm.trans (SecondStepLengths197.before_heap callee))

theorem readonly_block (callee out : State)
    (firstRun : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (run : Exec SecondStepFirstBody203.fragment (entry callee) ⟨out,.normal⟩)
    (block : Nat) (readonly : FirstStepEntry187.entry.heap.writable block=false) :
    KeygenMakeObjects.Block FirstStepEntry187.entry.heap out.heap block := by
  have first:=KeygenHelperStability.make _ _ _ firstRun
  have later:=KeygenHelperStability.make _ _ _ run
  change KeygenMemoryStability.Stable (entry callee).heap out.heap at later
  rw [entry_heap] at later
  have stable:=KeygenMemoryStability.trans _ _ _ first later
  exact ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset readonly⟩

theorem prime_object (callee out : State)
    (firstRun : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (run : Exec SecondStepFirstBody203.fragment (entry callee) ⟨out,.normal⟩) :
    KeygenStaticTables.PrimeObject out.heap primes .ternary :=
  KeygenMakeEntry.prime_block _ _ primes
    (readonly_block callee out firstRun run primes.block StepStaticInputs187.prime_object.2.2.2.1)
    StepStaticInputs187.prime_object

theorem rev_source (callee out : State)
    (firstRun : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (run : Exec SecondStepFirstBody203.fragment (entry callee) ⟨out,.normal⟩) :
    KeygenMkgm3RevMemory.SourceTable out.heap rev :=
  KeygenMakeEntry.rev_block _ _ rev
    (readonly_block callee out firstRun run rev.block StepStaticInputs187.rev_source.1) StepStaticInputs187.rev_source

theorem entry_rev (callee : State) : (entry callee).tables "REV10".toList=some rev := by
  change FirstStepEntry187.entry.arrays "REV10".toList=some rev
  exact StepStaticInputs187.rev_binding

theorem rev_binding (callee out : State) (run : Exec SecondStepFirstBody203.fragment (entry callee) ⟨out,.normal⟩) :
    out.tables "REV10".toList=some rev :=
  (congrFun (KeygenTables204.make _ _ _ run) "REV10".toList).trans (entry_rev callee)

end FT1536.Source3.SecondStepStatics204
