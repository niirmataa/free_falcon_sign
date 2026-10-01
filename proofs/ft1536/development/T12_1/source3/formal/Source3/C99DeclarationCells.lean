import Source3.C99Frontend

namespace FT1536.Source3.C99DeclarationCells
open C99ScalarReference

def declareCells (ty : C99IntegerReference.Ty) : List Name → Env → Env
  | [],env => env
  | name::rest,env => declareCells ty rest (set env name (ty,none))

theorem complete (calls : CallRelation) (ty : C99IntegerReference.Ty) (names : List Name)
    (before : Env) (result : Result) (source : Exec calls before (C99Frontend.declarations ty names) result) :
    result=.normal (declareCells ty names before) := by
  induction names generalizing before with
  | nil => cases source; rfl
  | cons name rest ih =>
      cases source with
      | seqNormal env middle a b out first second =>
          cases first
          exact ih _ second
      | seqReturn env a b v first => cases first

theorem exists_execution (calls : CallRelation) (ty : C99IntegerReference.Ty) (names : List Name) (before : Env) :
    Exec calls before (C99Frontend.declarations ty names) (.normal (declareCells ty names before)) := by
  induction names generalizing before with
  | nil => exact .skip before
  | cons name rest ih => exact .seqNormal _ _ _ _ _ (.declare before ty name) (ih _)

end FT1536.Source3.C99DeclarationCells
