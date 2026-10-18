import Source3.SelectedRootWords175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedDeepestEntry175
open C99ArrayReference (State bindPointer)
open KeygenFullData127 (env)
open SelectedRootEntry175 (inputs)

noncomputable def caller := SelectedRootStart175.ready
noncomputable def entry : State :=
  bindPointer (bindPointer (bindPointer
    ⟨caller.heap,caller.globals,caller.tables,caller.globals,caller.tables⟩
    "g".toList (inputs 1)) "f".toList (inputs 0)) "fk".toList env.ctx.object

theorem binding : C99ArrayReference.Bind caller KeygenDeepestSource.params KeygenDeepestSource.arguments entry :=
  .pointer "fk".toList "fk".toList C99ProcedureParser.zero env.ctx.object _ _ _
    (RootBinding175.zero caller "fk" env.ctx.object rfl (by decide))
    (.pointer "f".toList "f".toList C99ProcedureParser.zero (inputs 0) _ _ _
      (RootBinding175.zero caller "f" (inputs 0) rfl (by decide))
      (.pointer "g".toList "g".toList C99ProcedureParser.zero (inputs 1) _ _ _
        (RootBinding175.zero caller "g" (inputs 1) rfl (by decide)) .nil))

theorem object : KeygenSearchContext.ObjectLegal entry.heap env.ctx := SelectedRootContext175.object
theorem profile : KeygenSearchContext.M0 entry.heap env.ctx := SelectedRootEntry175.source.profile
theorem tmp : C99MemoryReference.Load64 entry.heap (KeygenSearchContext.field env.ctx 432 8)
    (KeygenSearchContext.pointerWord env.ctx) := SelectedRootContext175.tmp

theorem f_words : Word16Memory158.Represents entry.heap (inputs 0) SelectedSamplerWords158.fValues :=
  SelectedRootWords175.f_words
theorem g_words : Word16Memory158.Represents entry.heap (inputs 1) SelectedSamplerWords158.gValues :=
  SelectedRootWords175.g_words

theorem continue_call (out : C99ProcedureReference.Result)
    (body : KeygenDeepestSource.Exec env.ctx KeygenDeepestSource.code entry out)
    (returned : out.flow=.returned (some (.int32 1))) :
    KeygenDeepestSource.Call env.ctx caller {caller with heap:=out.state.heap} (.int32 1) := by
  apply KeygenDeepestSource.Call.run entry out (.int32 1) binding body
  rw [returned]
  exact C99ProcedureReference.ReturnValue.value .int32 (.int32 1)

end FT1536.Source3.SelectedDeepestEntry175
