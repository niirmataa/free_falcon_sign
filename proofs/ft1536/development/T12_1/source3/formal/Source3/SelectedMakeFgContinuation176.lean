import Source3.SelectedMakeFgTopEntry176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMakeFgContinuation176
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec Stmt)
open SelectedMakeFgConvert176 (after)
open SelectedMakeFgTopEntry176 (arguments tail binaryBody)

theorem ternary (topAfter last : State)
    (top : KeygenMakeFgTop.Call after arguments topAfter)
    (rest : Exec tail topAfter ⟨last,.normal⟩) :
    Exec (KeygenMakeFgSource.part .make 3) after ⟨last,.normal⟩ := by
  have inner : Exec (.seq (.top arguments) tail) after ⟨last,.normal⟩ :=
    .seqNormal _ _ after topAfter ⟨last,.normal⟩ (.top arguments after topAfter top) rest
  have scopeRun := KeygenMakeFgSource.Exec.scope [] [] _ after ⟨last,.normal⟩ inner
  have scopedRun : Exec (.scope [] [] (.seq (.top arguments) tail)) after ⟨last,.normal⟩ := by
    simpa only [KeygenPublicForwardCall.restore_empty] using scopeRun
  rw [SelectedMakeFgTopEntry176.shape]
  exact .seqNormal _ _ after last ⟨last,.normal⟩
    (.branchTrue _ _ _ _ _ (.uint32 1) (.variable _ _ _ SelectedMakeFgDispatch176.ternary_cell)
      (by decide) scopedRun) (MakeFgDeclarations176.array_source .skip last last (.skip last))

theorem source (topAfter last : State)
    (top : KeygenMakeFgTop.Call after arguments topAfter)
    (rest : Exec tail topAfter ⟨last,.normal⟩) :
    Exec (KeygenMakeFgSource.code .make) SelectedMakeFgEntry175.entry ⟨last,.normal⟩ :=
  SelectedMakeFgDispatch176.continue_make ⟨last,.normal⟩ (ternary topAfter last top rest)

end FT1536.Source3.SelectedMakeFgContinuation176
