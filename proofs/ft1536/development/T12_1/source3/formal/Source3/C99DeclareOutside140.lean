import Source3.C99DeclarationCells

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99DeclareOutside140

theorem source (ty : C99IntegerReference.Ty) (names : List C99ScalarReference.Name)
    (before : C99ScalarReference.Env) (name : C99ScalarReference.Name) (absent : name∉names) :
    (C99DeclarationCells.declareCells ty names before) name=before name := by
  induction names generalizing before with
  | nil => rfl
  | cons first rest ih =>
    have different : name≠first := fun same => absent (same ▸ List.mem_cons_self)
    have tail : name∉rest := fun member => absent (List.mem_cons_of_mem _ member)
    change (C99DeclarationCells.declareCells ty rest (C99ScalarReference.set before first (ty,none))) name=_
    rw [ih _ tail]
    simp [C99ScalarReference.set,different]

end FT1536.Source3.C99DeclareOutside140
