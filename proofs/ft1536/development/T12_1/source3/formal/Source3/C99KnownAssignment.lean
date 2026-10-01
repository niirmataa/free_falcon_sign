import Source3.C99ArrayReference

namespace FT1536.Source3.C99KnownAssignment
open C99ArrayReference

theorem source_result (program : Program) (name : Name) (e : Expr) (before after : State)
    (ty : C99IntegerReference.Ty) (old : Option C99IntegerReference.Value) (value : C99IntegerReference.Value)
    (binding : before.locals name=some (ty,old))
    (exactValue : ∀ v, Eval before e v → v=value)
    (source : Exec program (.assign name e) before after) : after=bindValue before name ty value := by
  cases source with
  | assign before name expression actualType oldValue v declaration evaluated =>
      have ht : actualType=ty := congrArg Prod.fst (Option.some.inj (declaration.symm.trans binding))
      subst actualType
      have hv := exactValue v evaluated
      subst v
      rfl

end FT1536.Source3.C99KnownAssignment
