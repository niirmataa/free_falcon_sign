import Source3.ModularAtoms178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ScalarArgumentValues178
open C99ScalarReference (BindArgs FunctionExec)
open C99IntegerReference (Value)

theorem binding (ps : List (C99IntegerReference.Ty×C99ScalarReference.Name)) (xs ys : List Value)
    (env : C99ScalarReference.Env) (same : xs.map Value.integer=ys.map Value.integer)
    (source : BindArgs ps xs env) : BindArgs ps ys env := by
  induction source generalizing ys with
  | nil =>
    cases ys with
    | nil => exact .nil
    | cons y ys => cases same
  | cons ty name ps x xs env _ ih =>
    cases ys with
    | nil => cases same
    | cons y ys =>
      have pair := List.cons.inj same
      have run := BindArgs.cons ty name ps y ys env (ih ys pair.2)
      rw [←pair.1] at run
      exact run

theorem function (calls : C99ScalarReference.CallRelation) (f : C99ScalarReference.Function)
    (xs ys : List Value) (out : Value) (same : xs.map Value.integer=ys.map Value.integer)
    (source : FunctionExec calls f xs out) : FunctionExec calls f ys out := by
  cases source with
  | call env result parameters body =>
    exact .call ys env result (binding f.params xs ys env same parameters) body

theorem mont_one (a p p0i : BitVec 32) :
    FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction KeygenModpWord.montgomeryCode)
      [.uint32 a,.int32 1,.uint32 p,.uint32 p0i] (.uint32 (KeygenModpWord.montgomery a 1 p p0i)) :=
  function _ _ [.uint32 a,.uint32 1,.uint32 p,.uint32 p0i]
    [.uint32 a,.int32 1,.uint32 p,.uint32 p0i] _ rfl (KeygenModpWord.source_exists a 1 p p0i)

end FT1536.Source3.ScalarArgumentValues178
