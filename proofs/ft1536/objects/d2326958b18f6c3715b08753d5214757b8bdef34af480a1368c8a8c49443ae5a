import Source3.C99ScalarReference

namespace FT1536.Source3.C99ControlInversion
open C99ScalarReference C99IntegerReference

theorem skip_inv (calls : CallRelation) (env : Env) (r : Result)
    (h : Exec calls env .skip r) : r=.normal env := by cases h; rfl

theorem declare_inv (calls : CallRelation) (env : Env) (t : Ty) (n : Name) (r : Result)
    (h : Exec calls env (.declare t n) r) : r=.normal (set env n (t,none)) := by cases h; rfl

theorem assign_inv (calls : CallRelation) (env : Env) (n : Name) (e : Expr) (r : Result)
    (h : Exec calls env (.assign n e) r) :
    ∃ t old v, env n=some (t,old) ∧ Eval calls env e v ∧
      r=.normal (set env n (t,some (convert t v.integer))) := by
  cases h
  exact ⟨_,_,_,by assumption,by assumption,rfl⟩

theorem seq_inv (calls : CallRelation) (env : Env) (a b : Stmt) (r : Result)
    (h : Exec calls env (.seq a b) r) :
    (∃ mid, Exec calls env a (.normal mid) ∧ Exec calls mid b r) ∨
      (∃ v, Exec calls env a (.returned v) ∧ r=.returned v) := by
  cases h
  · exact Or.inl ⟨_,by assumption,by assumption⟩
  · exact Or.inr ⟨_,by assumption,rfl⟩

theorem return_inv (calls : CallRelation) (env : Env) (e : Expr) (r : Result)
    (h : Exec calls env (.ret e) r) : ∃ v, Eval calls env e v ∧ r=.returned v := by
  cases h
  exact ⟨_,by assumption,rfl⟩

end FT1536.Source3.C99ControlInversion
