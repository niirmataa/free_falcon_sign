import Source3.SelectedDeepestWorkspace175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMakeFgEntry175
open C99ArrayReference (State bindValue bindPointer)
open KeygenFullData127 (env)
open SelectedRootEntry175 (inputs)
open SelectedDeepestWorkspace175 (after pointer)

noncomputable def empty : State := ⟨after.heap,after.globals,after.tables,after.globals,after.tables⟩
noncomputable def withOutput := bindValue empty "out_ntt".toList .int32 (.int32 0)
noncomputable def withDepth := bindValue withOutput "depth".toList .uint32 (.uint32 10)
noncomputable def withLogn := bindValue withDepth "logn".toList .uint32 (.uint32 10)
noncomputable def withG := bindPointer withLogn "g".toList (inputs 1)
noncomputable def withF := bindPointer withG "f".toList (inputs 0)
noncomputable def bound := bindPointer withF "data".toList (pointer 2)
noncomputable def entry := bindValue bound "ter".toList .uint32 (.uint32 1)

theorem binding : C99ArrayReference.Bind after KeygenDeepestSource.makeParams KeygenDeepestSource.makeArgs bound :=
  .pointer "data".toList "fp".toList C99ProcedureParser.zero (pointer 2) _ _ _
    (RootBinding175.zero after "fp" (pointer 2) rfl (by decide))
    (.pointer "f".toList "f".toList C99ProcedureParser.zero (inputs 0) _ _ _
      (RootBinding175.zero after "f" (inputs 0) rfl (by decide))
      (.pointer "g".toList "g".toList C99ProcedureParser.zero (inputs 1) _ _ _
        (RootBinding175.zero after "g" (inputs 1) rfl (by decide))
        (.scalar .uint32 "logn".toList (.var "logn".toList) _ _ _ (.uint32 10)
          (.variable _ _ _ SelectedDeepestConfig175.logn_cell)
          (.scalar .uint32 "depth".toList (.var "logn".toList) _ _ _ (.uint32 10)
            (.variable _ _ _ SelectedDeepestConfig175.logn_cell)
            (.scalar .int32 "out_ntt".toList (.literal .i32 0) [] [] empty (.int32 0) (.literal .int32 0) .nil)))))

theorem ternary_read : KeygenSearchContext.ReadTernary env.ctx after 1 :=
  .read 1 rfl SelectedDeepestEntry175.object SelectedDeepestEntry175.profile.2

theorem source_call (out : C99ProcedureReference.Result)
    (source : KeygenMakeFgSource.Exec (KeygenMakeFgSource.code .make) entry out)
    (returned : C99ProcedureReference.ReturnValue none out.flow none) :
    KeygenDeepestSource.Exec env.ctx .make after ⟨{after with heap:=out.state.heap},.normal⟩ :=
  .make after bound out 1 binding ternary_read source returned

theorem f_words : Word16Memory158.Represents entry.heap (inputs 0) SelectedSamplerWords158.fValues :=
  SelectedRootWords175.f_words
theorem g_words : Word16Memory158.Represents entry.heap (inputs 1) SelectedSamplerWords158.gValues :=
  SelectedRootWords175.g_words
theorem logn_cell : entry.locals "logn".toList=some (.uint32,some (.uint32 10)) := rfl
theorem depth_cell : entry.locals "depth".toList=some (.uint32,some (.uint32 10)) := rfl
theorem ternary_cell : entry.locals "ter".toList=some (.uint32,some (.uint32 1)) := rfl
theorem out_cell : entry.locals "out_ntt".toList=some (.int32,some (.int32 0)) := rfl
theorem data_cell : entry.arrays "data".toList=some (pointer 2) := rfl

end FT1536.Source3.SelectedMakeFgEntry175
