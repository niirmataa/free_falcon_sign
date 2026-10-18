import Source3.MakeFgTopSizes177

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTopLayout177
open C99ArrayReference (State bindValue bindPointer)
open KeygenLevelExec (Exec)
open LevelSequence177 (Run array_source)
open MakeFgTopShape177
open SelectedMakeFgTopEntry176 (entry)

def fd := SelectedMakeFgSetup176.ft
def gd := KeygenSmallOutput.element fd 512
def fs := KeygenSmallOutput.element gd 512
def gs := KeygenSmallOutput.element fs 1536
def gm := KeygenSmallOutput.element gs 1536
def igm := KeygenSmallOutput.element gm 1024
noncomputable def before := MakeFgTopDeclarations177.after entry
noncomputable def withN := bindValue before "n".toList .uint64 (.uint64 1536)
noncomputable def withDn := bindValue withN "dn".toList .uint64 (.uint64 1024)
noncomputable def sized := bindValue withDn "tn".toList .uint64 (.uint64 512)
noncomputable def withFd := bindPointer sized "fd".toList fd
noncomputable def withGd := bindPointer withFd "gd".toList gd
noncomputable def withFs := bindPointer withGd "fs".toList fs
noncomputable def withGs := bindPointer withFs "gs".toList gs
noncomputable def withGm := bindPointer withGs "gm".toList gm
noncomputable def after := bindPointer withGm "igm".toList igm

theorem sizes : Run sizeSteps before sized := by
  have n : Exec (assign "n" nExpr) before ⟨withN,.normal⟩ :=
    .modular _ _ _ (.assign _ _ _ .uint64 none (.uint64 1536) rfl
      (.scalar _ _ (MakeFgTopSizes177.ternary before _ (.variable _ _ _ rfl))))
  have dn : Exec (assign "dn" dnExpr) withN ⟨withDn,.normal⟩ :=
    .modular _ _ _ (.assign _ _ _ .uint64 none (.uint64 1024) rfl
      (.scalar _ _ (MakeFgTopSizes177.binary10 withN _ (.variable _ _ _ rfl))))
  have tn : Exec (assign "tn" tnExpr) withDn ⟨sized,.normal⟩ :=
    .modular _ _ _ (.assign _ _ _ .uint64 none (.uint64 512) rfl
      (.scalar _ _ (MakeFgTopSizes177.tn withDn rfl)))
  exact .cons _ _ _ _ _ n (.cons _ _ _ _ _ dn (.cons _ _ _ _ _ tn (.nil sized)))

theorem pointers : Run pointerSteps sized after := by
  have f : Exec (LevelSequence177.arrayCode (.bindPtr "fd".toList "data".toList C99ProcedureParser.zero)) sized ⟨withFd,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ fd (RootBinding175.zero sized "data" fd rfl (by decide)))
  have g : Exec (LevelSequence177.arrayCode (.bindPtr "gd".toList "fd".toList (.var "tn".toList))) withFd ⟨withGd,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gd (.add _ _ fd gd (.uint64 512) rfl (.variable _ _ _ rfl)
      (by decide) (.within fd 512 (by decide))))
  have fsrc : Exec (LevelSequence177.arrayCode (.bindPtr "fs".toList "gd".toList (.var "tn".toList))) withGd ⟨withFs,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ fs (.add _ _ gd fs (.uint64 512) rfl (.variable _ _ _ rfl)
      (by decide) (.within gd 512 (by decide))))
  have gsrc : Exec (LevelSequence177.arrayCode (.bindPtr "gs".toList "fs".toList (.var "n".toList))) withFs ⟨withGs,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gs (.add _ _ fs gs (.uint64 1536) rfl (.variable _ _ _ rfl)
      (by decide) (.within fs 1536 (by decide))))
  have forward : Exec (LevelSequence177.arrayCode (.bindPtr "gm".toList "gs".toList (.var "n".toList))) withGs ⟨withGm,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ gm (.add _ _ gs gm (.uint64 1536) rfl (.variable _ _ _ rfl)
      (by decide) (.within gs 1536 (by decide))))
  have inverse : Exec (LevelSequence177.arrayCode (.bindPtr "igm".toList "gm".toList (.var "dn".toList))) withGm ⟨after,.normal⟩ :=
    array_source _ _ _ (.bindPtr _ _ _ _ igm (.add _ _ gm igm (.uint64 1024) rfl (.variable _ _ _ rfl)
      (by decide) (.within gm 1024 (by decide))))
  exact .cons _ _ _ _ _ f (.cons _ _ _ _ _ g (.cons _ _ _ _ _ fsrc
    (.cons _ _ _ _ _ gsrc (.cons _ _ _ _ _ forward (.cons _ _ _ _ _ inverse (.nil after))))))

theorem heap : after.heap=entry.heap := by
  calc
    after.heap=before.heap := by
      dsimp only [after,withGm,withGs,withFs,withGd,withFd,sized,withDn,withN,bindPointer,bindValue]
    _=entry.heap := MakeFgTopDeclarations177.heap entry

theorem fd_shape : fd=⟨31,0,71680,4,670⟩ := rfl
theorem gd_shape : gd=⟨31,0,71680,4,1182⟩ := rfl
theorem fs_shape : fs=⟨31,0,71680,4,1694⟩ := rfl
theorem gs_shape : gs=⟨31,0,71680,4,3230⟩ := rfl
theorem gm_shape : gm=⟨31,0,71680,4,4766⟩ := rfl
theorem igm_shape : igm=⟨31,0,71680,4,5790⟩ := rfl

theorem continue_body (out : C99ProcedureReference.Result)
    (rest : Exec (.seq move remaining) after out) :
    Exec KeygenMakeFgTop.code entry out := by
  rw [shape]
  exact LevelSequence177.source declarationSteps entry before (MakeFgTopDeclarations177.source entry) _ out
    (LevelSequence177.source sizeSteps before sized sizes _ out
      (LevelSequence177.source pointerSteps sized after pointers _ out rest))

end FT1536.Source3.SelectedTopLayout177
