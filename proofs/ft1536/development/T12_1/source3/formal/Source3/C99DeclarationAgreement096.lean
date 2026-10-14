import Source3.C99ModularAgreement096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99DeclarationAgreement096
open C99ArrayReference (State Name)
open C99IntegerReference (Value Ty)
open C99ProcedureReference (Result)
open C99ExpressionEnvironment (Agree)
open C99ModularReference

theorem set_extend (names : List Name) (a b : C99ScalarReference.Env) (name : Name)
    (cell : Ty × Option Value) (same : Agree a b names) :
    Agree (C99ScalarReference.set a name cell) (C99ScalarReference.set b name cell) (name :: names) := by
  intro key member
  rcases List.mem_cons.mp member with equal | member
  · subst key
    simp only [C99ScalarReference.set, ite_true]
  · exact C99ScalarAgreement096.set_agree names a b name cell same key member

theorem declarations (tracked locals : List Name) (ty : Ty) (a b : C99ScalarReference.Env)
    (same : Agree a b tracked) :
    Agree (C99DeclarationCells.declareCells ty locals a) (C99DeclarationCells.declareCells ty locals b) (locals ++ tracked) := by
  induction locals generalizing tracked a b with
  | nil => exact same
  | cons name rest ih =>
      have next := ih (name :: tracked) _ _ (set_extend tracked a b name (ty, none) same)
      intro key member
      apply next key
      simp only [List.mem_append, List.mem_cons] at member ⊢
      tauto

def declaredNames : Stmt → Option (List Name)
  | .base (.scalar (.declare _ names)) => some names
  | _ => none

theorem declaration_shape (code : Stmt) (names : List Name) (shape : declaredNames code = some names) :
    ∃ ty, code = .base (.scalar (.declare ty names)) := by
  cases code <;> simp only [declaredNames] at shape
  case base code =>
    cases code
    case scalar code =>
      cases code
      case declare ty declared =>
        have equal := Option.some.inj shape
        subst declared
        exact ⟨ty, rfl⟩
      all_goals cases shape
    all_goals cases shape
  all_goals cases shape

theorem declaration_result (calls : CallRelation) (ty : B20.C.Ty) (names : List Name) (before : State) (out : Result)
    (source : GenExec calls (.base (.scalar (.declare ty names))) before out) :
    out = ⟨C99DeclarationStatements.effect ty names before, .normal⟩ := by
  cases source with
  | base code before after body =>
      rw [C99DeclarationStatements.source_result ty names before after body]

theorem normal (calls : CallRelation) (code : Stmt) (names : List Name) (before : State) (out : Result)
    (shape : declaredNames code = some names) (source : GenExec calls code before out) : out.flow = .normal := by
  obtain ⟨ty, rfl⟩ := declaration_shape code names shape
  exact congrArg Result.flow (declaration_result calls ty names before out source)

theorem source_pair (calls : CallRelation) (tracked locals : List Name) (code : Stmt)
    (s t : State) (a b : Result) (shape : declaredNames code = some locals)
    (same : Agree s.locals t.locals tracked) (first : GenExec calls code s a) (second : GenExec calls code t b) :
    a.flow = .normal ∧ b.flow = .normal ∧ Agree a.state.locals b.state.locals (locals ++ tracked) := by
  obtain ⟨ty, rfl⟩ := declaration_shape code locals shape
  rw [declaration_result calls ty locals s a first, declaration_result calls ty locals t b second]
  exact ⟨rfl, rfl, declarations tracked locals (C99ValueBridge.type ty) s.locals t.locals same⟩

theorem restrict (tracked locals : List Name) (a b : C99ScalarReference.Env) (same : Agree a b (locals ++ tracked)) : Agree a b tracked :=
  fun name member => same name (List.mem_append.mpr (Or.inr member))

end FT1536.Source3.C99DeclarationAgreement096
