import Source3.C99DeclarationCells
import Source3.FftLeafPrograms

namespace FT1536.Source3.C99DeclarationStatements
open C99ArrayReference (Name State)

def effect (ty : B20.C.Ty) (names : List Name) (before : State) : State :=
  {before with locals := C99DeclarationCells.declareCells (C99ValueBridge.type ty) names before.locals}

theorem source_result (ty : B20.C.Ty) (names : List Name) (before after : State)
    (source : C99ArrayReference.Exec FftLeafPrograms.program (.scalar (.declare ty names)) before after) :
    after=effect ty names before := by
  cases source with
  | scalar before env statement body =>
      have he := C99DeclarationCells.complete FprPrefixCalls.calls (C99ValueBridge.type ty) names before.locals (.normal env) body
      have hh := C99ScalarReference.Result.normal.inj he
      rw [hh]
      rfl

theorem source_exists (program : C99ArrayReference.Program) (ty : B20.C.Ty) (names : List Name) (before : State) :
    C99ArrayReference.Exec program (.scalar (.declare ty names)) before (effect ty names before) :=
  .scalar before _ (.declare ty names) (C99DeclarationCells.exists_execution FprPrefixCalls.calls (C99ValueBridge.type ty) names before.locals)

end FT1536.Source3.C99DeclarationStatements
