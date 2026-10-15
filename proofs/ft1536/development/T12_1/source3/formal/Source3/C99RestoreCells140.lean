import Source3.C99DeclarationCells

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99RestoreCells140
open C99ScalarReference (Env Name restore)

theorem inside (outer inner : Env) (names : List Name) (name : Name)
    (cell : C99IntegerReference.Ty × Option C99IntegerReference.Value) (member : name∈names) :
    restore outer (C99ScalarReference.set inner name cell) names=restore outer inner names := by
  funext other
  by_cases same : other=name
  · subst other
    simp [restore,member]
  · simp [restore,C99ScalarReference.set,same]

theorem outside (outer inner : Env) (names : List Name) (name : Name)
    (cell : C99IntegerReference.Ty × Option C99IntegerReference.Value) (absent : name∉names) :
    restore outer (C99ScalarReference.set inner name cell) names=C99ScalarReference.set (restore outer inner names) name cell := by
  funext other
  by_cases same : other=name
  · subst other
    simp [restore,C99ScalarReference.set,absent]
  · simp [restore,C99ScalarReference.set,same]

theorem declarations (outer inner : Env) (scope names : List Name) (ty : C99IntegerReference.Ty)
    (subset : ∀ name∈names, name∈scope) :
    restore outer (C99DeclarationCells.declareCells ty names inner) scope=restore outer inner scope := by
  induction names generalizing inner with
  | nil => rfl
  | cons name rest ih =>
    have tail := ih (C99ScalarReference.set inner name (ty,none)) (fun n h => subset n (List.mem_cons_of_mem _ h))
    exact tail.trans (inside outer inner scope name (ty,none) (subset name (List.mem_cons_self)))

theorem self (outer : Env) (names : List Name) : restore outer outer names=outer := by
  funext name
  simp [restore]

end FT1536.Source3.C99RestoreCells140
