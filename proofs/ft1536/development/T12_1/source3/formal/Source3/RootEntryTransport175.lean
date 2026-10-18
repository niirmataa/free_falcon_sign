import Source3.SelectedPublicSuccess174

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RootEntryTransport175
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open KeygenSearchContext (Context)

theorem legal (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) :
    KeygenRootCaller.Legal ctx s input primes rev :=
  ⟨initial.context,initial.inputs,initial.profile,initial.table,initial.primeObject,
    initial.revBinding,initial.revSource,initial.scratch,initial.width,
    fun slot => Or.inl (Ne.symm (initial.scratchSeparate slot)),
    fun a b different => Or.inl (initial.distinct a b different),
    ⟨initial.contextScratch,initial.contextTables⟩,
    ⟨initial.scratchSeparate 0,initial.inputTables 0⟩,
    ⟨initial.scratchSeparate 1,initial.inputTables 1⟩⟩

theorem context_prepared (ctx : Context) (s : State) (i : Nat)
    (input : Fin 4 → ArrayPointer) (h primes rev : ArrayPointer)
    (initial : KeygenCallerEntry.Initial ctx s input h primes rev) :
    KeygenAttemptNorm.Protected ctx (KeygenMakeSampling.prepared ctx (KeygenCapWords.advanced s i)) ctx.object.block := by
  refine ⟨initial.contextScratch,?_,initial.contextTables⟩
  intro name member p binding
  rw [KeygenMakeSampling.prepared_rt ctx (KeygenCapWords.advanced s i) name member p binding]
  exact initial.contextScratch

end FT1536.Source3.RootEntryTransport175
