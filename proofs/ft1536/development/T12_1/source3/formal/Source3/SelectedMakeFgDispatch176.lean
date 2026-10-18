import Source3.SelectedMakeFgRange176

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedMakeFgDispatch176
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec Stmt)
open SelectedMakeFgConvert176 (after frame)

def condition : CLogic.Expr := .land (.cmp .eq (.var "depth".toList) (.literal .i32 0)) (.var "out_ntt".toList)
def activeBody : Stmt := match KeygenMakeFgSource.part .make 2 with
  | .seq (.branch _ body _) _ => body
  | _ => KeygenMakeFgSource.skip

theorem shape : KeygenMakeFgSource.part .make 2=
    .seq (.branch condition activeBody KeygenMakeFgSource.skip) KeygenMakeFgSource.skip := by decide

theorem depth_cell : after.locals "depth".toList=some (.uint32,some (.uint32 10)) :=
  (frame.locals _ (by decide)).trans rfl
theorem logn_cell : after.locals "logn".toList=some (.uint32,some (.uint32 10)) :=
  (frame.locals _ (by decide)).trans rfl
theorem ternary_cell : after.locals "ter".toList=some (.uint32,some (.uint32 1)) :=
  (frame.locals _ (by decide)).trans rfl
theorem out_cell : after.locals "out_ntt".toList=some (.int32,some (.int32 0)) :=
  (frame.locals _ (by decide)).trans rfl

theorem guard : C99ArrayReference.scalar after condition (C99ScalarReference.boolean false) :=
  .andFalse _ _ (C99ScalarReference.boolean false)
    (.compare .eq _ _ _ _ _ (.variable _ _ _ depth_cell) (.literal .int32 0)
      (.step .eq (.uint32 10) (.int32 0) .uint32 rfl (.uint32 10) (.uint32 0) rfl rfl))
    (by decide)

theorem source : Exec (KeygenMakeFgSource.part .make 2) after ⟨after,.normal⟩ := by
  rw [shape]
  exact .seqNormal _ _ after after ⟨after,.normal⟩
    (.branchFalse _ _ _ _ _ (C99ScalarReference.boolean false) guard (by decide)
      (MakeFgDeclarations176.array_source .skip after after (.skip after)))
    (MakeFgDeclarations176.array_source .skip after after (.skip after))

theorem continue_make (out : C99ProcedureReference.Result)
    (rest : Exec (KeygenMakeFgSource.part .make 3) after out) :
    Exec (KeygenMakeFgSource.code .make) SelectedMakeFgEntry175.entry out := by
  apply SelectedMakeFgConvert176.continue_make out
  cases out with
  | mk state flow =>
    cases flow with
    | normal =>
      exact .seqNormal _ _ after after ⟨state,.normal⟩ source
        (.seqNormal _ _ after state ⟨state,.normal⟩ rest (MakeFgDeclarations176.array_source .skip state state (.skip state)))
    | returned value =>
      exact .seqNormal _ _ after after ⟨state,.returned value⟩ source
        (.seqExit _ _ after ⟨state,.returned value⟩ rest (by intro impossible; cases impossible))
    | breakLoop =>
      exact .seqNormal _ _ after after ⟨state,.breakLoop⟩ source
        (.seqExit _ _ after ⟨state,.breakLoop⟩ rest (by intro impossible; cases impossible))
    | continueLoop =>
      exact .seqNormal _ _ after after ⟨state,.continueLoop⟩ source
        (.seqExit _ _ after ⟨state,.continueLoop⟩ rest (by intro impossible; cases impossible))

end FT1536.Source3.SelectedMakeFgDispatch176
