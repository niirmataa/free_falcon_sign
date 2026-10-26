import Source3.SecondStepCrtPair208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepCrtStatics208
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes)

theorem prime_object (callee out : State)
    (firstRun : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (run : Exec SecondStepLoop204.fragment (SecondStepStatics204.entry callee) ⟨out,.normal⟩) :
    KeygenStaticTables.PrimeObject out.heap primes .ternary := by
  have first:=KeygenHelperStability.make _ _ _ firstRun
  have later:=KeygenHelperStability.make _ _ _ run
  change KeygenMemoryStability.Stable (SecondStepStatics204.entry callee).heap out.heap at later
  rw [SecondStepStatics204.entry_heap] at later
  have stable:=KeygenMemoryStability.trans _ _ _ first later
  exact KeygenMakeEntry.prime_block FirstStepEntry187.entry.heap out.heap primes
    ⟨congrFun stable.size primes.block,congrFun stable.writable primes.block,
      fun offset => stable.readonly primes.block offset StepStaticInputs187.prime_object.2.2.2.1⟩ StepStaticInputs187.prime_object

end FT1536.Source3.SecondStepCrtStatics208
