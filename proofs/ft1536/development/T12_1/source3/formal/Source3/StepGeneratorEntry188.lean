import Source3.SelectedStepPrime188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepGeneratorEntry188
open C99ArrayReference (State bindValue bindPointer)
open SelectedStepLayout187 (gm igm)
open KeygenFullData127 (primes rev)
open SelectedTopInit178 (p p0i)

noncomputable abbrev before := SelectedStepPrime188.after
noncomputable def empty : State := ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩
noncomputable def withI := bindValue empty "p0i".toList .uint32 (.uint32 p0i)
noncomputable def withP := bindValue withI "p".toList .uint32 (.uint32 p)
noncomputable def withG := bindValue withP "g".toList .uint32 (.uint32 KeygenFirstPrime.generator)
noncomputable def withFull := bindValue withG "full".toList .uint32 (.int32 0)
noncomputable def withLogn := bindValue withFull "logn".toList .uint32 (.uint32 9)
noncomputable def withIgm := bindPointer withLogn "igm".toList igm
noncomputable def entry := bindPointer withIgm "gm".toList gm

theorem g_bytes : C99MemoryReference.Load32 before.heap (KeygenLevelCalls.fieldPointer primes .g) KeygenFirstPrime.generator := by
  rw [SelectedStepPrime188.heap]
  exact SelectedStepReady187.prime_object.2.2.2.2.2.2 0 (KeygenStaticReads.first .ternary) (KeygenStaticReads.first_value .ternary) .g

theorem generator_read : KeygenLevelCalls.PrimeRead before "primes".toList (FirstStepEntry187.var "u") .g (.uint32 KeygenFirstPrime.generator) :=
  .read primes KeygenFirstPrime.generator
    (.add _ _ primes primes (.uint64 0) rfl (.variable _ _ _ rfl) (by decide)
      (.within primes 0 (by change 0≤_; exact Nat.zero_le _))) rfl (by decide) g_bytes

theorem binding : KeygenLevelCalls.Bind before (KeygenLevelCalls.params .generate) StepPrimeShape188.args entry :=
  .pointer "gm".toList "gm".toList C99ProcedureParser.zero gm _ _ _
    (RootBinding175.zero before "gm" gm rfl (by decide))
    (.pointer "igm".toList "igm".toList C99ProcedureParser.zero igm _ _ _
      (RootBinding175.zero before "igm" igm rfl (by decide))
      (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 9) (.modular _ _ (.scalar _ _ (.variable _ _ _ rfl)))
        (.scalar .uint32 "full".toList _ _ _ _ (.int32 0) (.modular _ _ (.scalar _ _ (.literal .int32 0)))
          (.scalar .uint32 "g".toList _ _ _ _ (.uint32 KeygenFirstPrime.generator) (.prime _ _ _ _ generator_read)
            (.scalar .uint32 "p".toList _ _ _ _ (.uint32 p) (.modular _ _ (.scalar _ _ (.variable _ _ _ rfl)))
              (.scalar .uint32 "p0i".toList _ [] [] empty (.uint32 p0i)
                (.modular _ _ (.scalar _ _ (.variable _ _ _ rfl))) .nil))))))

theorem entry_heap : entry.heap=SelectedStepMove187.after.heap :=
  (KeygenLevelCalls.bind_heap before entry _ _ binding).trans SelectedStepPrime188.heap

theorem source_call (out : C99ProcedureReference.Result)
    (source : C99ModularReference.Exec KeygenMkgm3Program.code entry out)
    (returned : C99ProcedureReference.ReturnValue none out.flow none) :
    KeygenLevelCalls.Call .generate before StepPrimeShape188.args {before with heap:=out.state.heap} :=
  .run entry out binding source returned

theorem rev_binding : entry.arrays "REV10".toList=some rev := StepStaticInputs187.rev_binding

theorem rev_source : KeygenMkgm3RevMemory.SourceTable entry.heap rev := by
  rw [entry_heap]
  exact SelectedStepReady187.rev_source

theorem allocated (index : Nat) (inside : index<71680) :
    C99MemoryReference.Allocated entry.heap {KeygenFullData127.env.ctx.scratch with index:=index} := by
  rw [entry_heap]
  exact SelectedStepMove187.allocated index inside

theorem writable : entry.heap.writable 31=true := by
  rw [entry_heap]
  exact SelectedStepReady187.scratch_writable

end FT1536.Source3.StepGeneratorEntry188
