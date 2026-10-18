import Source3.RootSizeSource175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedRootStart175
open C99ArrayReference (State)
open KeygenFullData127 (env primes rev)
open SelectedRootEntry175 (inputs)

noncomputable def caller := SelectedPublicSuccess174.after
noncomputable def entry := KeygenRootCaller.bound caller env.ctx inputs
noncomputable def ready := KeygenRootSearch.ready entry

theorem binding : C99ArrayReference.Bind caller KeygenRootSource.params KeygenRootSource.arguments entry :=
  RootBinding175.source env.ctx caller inputs primes rev SelectedRootEntry175.source
    (by decide) (by intro i; fin_cases i <;> decide)

theorem legal : KeygenRootSource.Entry env.ctx entry inputs primes rev :=
  KeygenRootCaller.bound_entry env.ctx caller inputs primes rev SelectedRootEntry175.source

theorem logn_read : KeygenSearchContext.ReadLogn env.ctx (KeygenRootSearch.declared entry) 10 :=
  .read 10 rfl SelectedRootContext175.object legal.profile.1

theorem ternary_read : KeygenSearchContext.ReadTernary env.ctx (KeygenRootSearch.logged entry 10) 1 :=
  .read 1 rfl SelectedRootContext175.object legal.profile.2

theorem source : KeygenRootSearch.Start env.ctx entry ready :=
  .run 10 1 (.uint64 1536) logn_read ternary_read (RootSizeSource175.source _ rfl rfl)

theorem continue_search (deep : State) (out : C99ProcedureReference.Result)
    (deepest : KeygenRootSearch.Gate env.ctx .deepest ready ⟨deep,.normal⟩)
    (dispatch : KeygenRootSearch.Dispatch env.ctx deep out) :
    KeygenRootSearch.Exec env.ctx entry out := .searched ready deep out source deepest dispatch

theorem continue_call (out : C99ProcedureReference.Result)
    (body : KeygenRootSource.Exec env.ctx entry out)
    (returned : out.flow=.returned (some (.int32 1))) :
    KeygenRootSource.Call env.ctx caller {caller with heap:=out.state.heap} (.int32 1) := by
  apply KeygenRootSource.Call.run entry out (.int32 1) binding body
  rw [returned]
  exact C99ProcedureReference.ReturnValue.value .int32 (.int32 1)

end FT1536.Source3.SelectedRootStart175
