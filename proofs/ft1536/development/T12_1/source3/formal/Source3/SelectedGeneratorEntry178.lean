import Source3.SelectedTopInit178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorEntry178
open C99ArrayReference (State bindValue bindPointer)
open KeygenFullData127 (primes rev)
open SelectedTopLayout177 (gm igm)
open SelectedTopInit178 (after p p0i)

noncomputable def empty : State := ⟨after.heap,after.globals,after.tables,after.globals,after.tables⟩
noncomputable def withI := bindValue empty "p0i".toList .uint32 (.uint32 p0i)
noncomputable def withP := bindValue withI "p".toList .uint32 (.uint32 p)
noncomputable def withG := bindValue withP "g".toList .uint32 (.uint32 KeygenFirstPrime.generator)
noncomputable def withFull := bindValue withG "full".toList .uint32 (.int32 1)
noncomputable def withLogn := bindValue withFull "logn".toList .uint32 (.uint32 10)
noncomputable def withIgm := bindPointer withLogn "igm".toList igm
noncomputable def entry := bindPointer withIgm "gm".toList gm

theorem generator_read : KeygenLevelCalls.PrimeRead after "PRIMES3".toList (.literal .i32 0) .g (.uint32 KeygenFirstPrime.generator) :=
  .read primes KeygenFirstPrime.generator
    (.add _ _ primes primes (.int32 0) SelectedTopStatics178.prime_binding (.literal .int32 0)
      (by decide) (.within primes 0 (by change 0≤_; exact Nat.zero_le _)))
    rfl (by decide) SelectedTopStatics178.g_bytes

theorem binding : KeygenLevelCalls.Bind after (KeygenLevelCalls.params .generate) TopInitShape178.args entry :=
  .pointer "gm".toList "gm".toList C99ProcedureParser.zero gm _ _ _
    (RootBinding175.zero after "gm" gm rfl (by decide))
    (.pointer "igm".toList "igm".toList C99ProcedureParser.zero igm _ _ _
      (RootBinding175.zero after "igm" igm rfl (by decide))
      (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 10)
        (.modular _ _ (.scalar _ _ (.variable _ _ _ rfl)))
        (.scalar .uint32 "full".toList _ _ _ _ (.int32 1)
          (.modular _ _ (.scalar _ _ (.literal .int32 1)))
          (.scalar .uint32 "g".toList _ _ _ _ (.uint32 KeygenFirstPrime.generator)
            (.prime _ _ _ _ generator_read)
            (.scalar .uint32 "p".toList _ _ _ _ (.uint32 p)
              (.modular _ _ (.scalar _ _ (.variable _ _ _ SelectedTopInit178.p_cell)))
              (.scalar .uint32 "p0i".toList _ [] [] empty (.uint32 p0i)
                (.modular _ _ (.scalar _ _ (.variable _ _ _ SelectedTopInit178.i_cell))) .nil))))))

theorem source_call (out : C99ProcedureReference.Result)
    (source : C99ModularReference.Exec KeygenMkgm3Program.code entry out)
    (returned : C99ProcedureReference.ReturnValue none out.flow none) :
    KeygenLevelCalls.Call .generate after TopInitShape178.args {after with heap:=out.state.heap} :=
  .run entry out binding source returned

theorem rev_binding : entry.arrays "REV10".toList=some rev := by
  change SelectedMakeFgConvert176.after.tables "REV10".toList=some rev
  rw [SelectedMakeFgConvert176.frame.tables]
  exact SelectedRootEntry175.source.revBinding

theorem rev_source : KeygenMkgm3RevMemory.SourceTable entry.heap rev := SelectedTopStatics178.rev_source

theorem allocated (index : Nat) (inside : index<71680) :
    C99MemoryReference.Allocated entry.heap {KeygenFullData127.env.ctx.scratch with index:=index} :=
  SelectedTopMove177.allocated index inside

theorem writable : entry.heap.writable 31=true := SelectedTopMove177.writable

end FT1536.Source3.SelectedGeneratorEntry178
