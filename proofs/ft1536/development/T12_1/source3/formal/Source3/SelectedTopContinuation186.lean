import Source3.SelectedTopOutput186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopContinuation186
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open SelectedTopCall186 (before after)

theorem continue_make (out : State)
    (rest : Exec SelectedMakeFgTopEntry176.tail after ⟨out,.normal⟩) :
    Exec (KeygenMakeFgSource.code .make) SelectedMakeFgEntry175.entry ⟨out,.normal⟩ := by
  apply SelectedMakeFgDispatch176.continue_make ⟨out,.normal⟩
  rw [SelectedMakeFgTopEntry176.shape]
  have inner : Exec (.seq (.top SelectedMakeFgTopEntry176.arguments) SelectedMakeFgTopEntry176.tail) before ⟨out,.normal⟩ :=
    .seqNormal _ _ before after ⟨out,.normal⟩ SelectedTopCall186.instruction rest
  have branch : Exec (.branch (.var "ter".toList)
      (.scope [] [] (.seq (.top SelectedMakeFgTopEntry176.arguments) SelectedMakeFgTopEntry176.tail))
      SelectedMakeFgTopEntry176.binaryBody) before ⟨out,.normal⟩ :=
    .branchTrue _ _ _ before ⟨out,.normal⟩ (.uint32 1)
      (.variable _ _ _ SelectedMakeFgDispatch176.ternary_cell) (by decide)
      (.scope [] [] _ before ⟨out,.normal⟩ inner)
  exact .seqNormal _ _ before out ⟨out,.normal⟩ branch
    (MakeFgDeclarations176.array_source .skip out out (.skip out))

theorem logn_cell : after.locals "logn".toList=some (.uint32,some (.uint32 10)) := SelectedMakeFgDispatch176.logn_cell
theorem depth_cell : after.locals "depth".toList=some (.uint32,some (.uint32 10)) := SelectedMakeFgDispatch176.depth_cell
theorem ternary_cell : after.locals "ter".toList=some (.uint32,some (.uint32 1)) := SelectedMakeFgDispatch176.ternary_cell
theorem out_ntt_cell : after.locals "out_ntt".toList=some (.int32,some (.int32 0)) := SelectedMakeFgDispatch176.out_cell
theorem data_binding : after.arrays "data".toList=some SelectedMakeFgSetup176.ft := SelectedMakeFgTopEntry176.data_binding

end FT1536.Source3.SelectedTopContinuation186
