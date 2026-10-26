import Source3.SecondStepPrefix197

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepStatic200
open C99ArrayReference (State)
open C99MemoryReference (Memory Allocated ArrayPointer)
open KeygenFullData127 (primes rev)
open KeygenMakeFgSource (Exec)
open SecondStepLayout197 (fd fs)

noncomputable abbrev before (callee : State) := SecondStepMove197.after callee

theorem snapshot_block (heap : Memory) (block : Nat) (separate : block≠31) :
    KeygenMakeObjects.Block heap (MemmoveWord177.snapshot heap fs fd 4096) block := by
  refine ⟨rfl,rfl,?_⟩
  intro offset
  simp only [MemmoveWord177.snapshot,show fs.block=31 from rfl,separate,false_and,ite_false]

theorem move_block (callee : State) (block : Nat) (separate : block≠31) :
    KeygenMakeObjects.Block callee.heap (before callee).heap block := by
  change KeygenMakeObjects.Block callee.heap
    (MemmoveWord177.snapshot (SecondStepMove197.before callee).heap fs fd 4096) block
  rw [SecondStepMove197.before_heap callee]
  exact snapshot_block callee.heap block separate

theorem first_readonly (callee : State) (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (block : Nat) (readonly : FirstStepEntry187.entry.heap.writable block=false) :
    KeygenMakeObjects.Block FirstStepEntry187.entry.heap callee.heap block := by
  have stable:=KeygenHelperStability.make _ _ _ run
  exact ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset readonly⟩

theorem prime_object (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    KeygenStaticTables.PrimeObject (before callee).heap primes .ternary :=
  KeygenMakeEntry.prime_block _ _ primes (move_block callee primes.block (by decide))
    (KeygenMakeEntry.prime_block _ _ primes
      (first_readonly callee run primes.block StepStaticInputs187.prime_object.2.2.2.1)
      StepStaticInputs187.prime_object)

theorem rev_source (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    KeygenMkgm3RevMemory.SourceTable (before callee).heap rev :=
  KeygenMakeEntry.rev_block _ _ rev (move_block callee rev.block (by decide))
    (KeygenMakeEntry.rev_block _ _ rev
      (first_readonly callee run rev.block StepStaticInputs187.rev_source.1) StepStaticInputs187.rev_source)

theorem prime_binding (callee : State) : (before callee).arrays "primes".toList=some primes := rfl

theorem rev_binding (callee : State) : (before callee).tables "REV10".toList=some rev := by
  change FirstStepEntry187.entry.arrays "REV10".toList=some rev
  exact StepStaticInputs187.rev_binding

theorem allocated (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩)
    (index : Nat) (bound : index<71680) :
    Allocated (before callee).heap (⟨31,0,71680,4,index⟩ : ArrayPointer) := by
  have domain:=SecondStepMove197.memory_domains callee run
  have size : (before callee).heap.size=(SecondStepMove197.before callee).heap.size :=
    SecondStepMove197.snapshot_size _
  change 0<4 ∧ 0%4=0 ∧ index<71680 ∧ 0+4*71680≤(before callee).heap.size 31 ∧
    (before callee).heap.size 31<2^64
  rw [size]
  exact ⟨by decide,by decide,bound,domain.1,domain.2.1⟩

theorem writable (callee : State)
    (run : Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩) :
    (before callee).heap.writable 31=true := (SecondStepMove197.memory_domains callee run).2.2

end FT1536.Source3.SecondStepStatic200
