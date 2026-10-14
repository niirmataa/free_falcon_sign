import Source3.C99ModularRename093
import Source3.KeygenWordDeterminism093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordRename093
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenWordExpr
open C99BlockRename090
open C99ModularRename093 (result)

theorem expression (r : Renaming) (s : State) (e : Expr) (v : Value) (source : Eval s e v) :
    Eval (state r s) e v := by
  induction source with
  | scalar e v source => exact .scalar e v source
  | load32 name index p word address read =>
      exact .load32 name index (ptr r p) word (C99StateRename090.pointer r s name index p address)
        (load32 r s.heap p word read)
  | load16 name index p word address read =>
      exact .load16 name index (ptr r p) word (C99StateRename090.pointer r s name index p address)
        (C99ArrayRename093.load16 r s.heap p word read)
  | cast ty e v source ih => exact .cast ty e v ih
  | neg e v z source op ih => exact .neg e v z ih op
  | bitNot e v z source op ih => exact .bitNot e v z ih op
  | lnot e v source ih => exact .lnot e v ih
  | bin op a b x y z left right operation ih1 ih2 => exact .bin op a b x y z ih1 ih2 operation
  | cmp op a b x y z left right operation ih1 ih2 => exact .cmp op a b x y z ih1 ih2 operation
  | andFalse a b x left zero ih => exact .andFalse a b x ih zero
  | andTrue a b x y left nonzero right ih1 ih2 => exact .andTrue a b x y ih1 nonzero ih2
  | orTrue a b x left nonzero ih => exact .orTrue a b x ih nonzero
  | orFalse a b x y left zero right ih1 ih2 => exact .orFalse a b x y ih1 zero ih2
  | call1 name a x out first source ih => exact .call1 name a x out ih source
  | call2 name a b x y out first second source ih1 ih2 => exact .call2 name a b x y out ih1 ih2 source
  | call3 name a b c x y z out first second third source ih1 ih2 ih3 =>
      exact .call3 name a b c x y z out ih1 ih2 ih3 source
  | call4 name a b c d x y z t out first second third fourth source ih1 ih2 ih3 ih4 =>
      exact .call4 name a b c d x y z t out ih1 ih2 ih3 ih4 source
  | call5 name a b c d e x y z t u out first second third fourth fifth source ih1 ih2 ih3 ih4 ih5 =>
      exact .call5 name a b c d e x y z t u out ih1 ih2 ih3 ih4 ih5 source

theorem execution (r : Renaming) (code : KeygenWordExec.Stmt) (before : State) (out : Result)
    (source : KeygenWordExec.Exec code before out) : KeygenWordExec.Exec code (state r before) (result r out) := by
  induction source with
  | modular code before out source => exact .modular code _ _ (C99ModularRename093.execution r _ code before out source)
  | assign name e before ty old v declared source => exact .assign name e _ ty old v declared (expression r before e v source)
  | store name index e before after p v address value write =>
      exact .store name index e _ (heap r after) (ptr r p) v
        (C99StateRename090.pointer r before name index p address) (expression r before e v value)
        (store32 r before.heap after p _ write)
  | seqNormal a b before middle out head tail ih1 ih2 => exact .seqNormal a b _ _ _ ih1 ih2
  | seqExit a b before out head exit ih => exact .seqExit a b _ _ ih exit
  | scope locals body before out inner ih =>
      change KeygenWordExec.Exec (.scope locals body) (state r before)
        ⟨state r (C99ArrayReference.restoreScope before out.state locals []), out.flow⟩
      rw [C99StateRename090.restoreScope]
      exact .scope locals body _ _ ih
  | branchTrue c yes no before out v guard nonzero body ih => exact .branchTrue c yes no _ _ v (expression r before c v guard) nonzero ih
  | branchFalse c yes no before out v guard zero body ih => exact .branchFalse c yes no _ _ v (expression r before c v guard) zero ih
  | loopFalse c body increment before v guard zero => exact .loopFalse c body increment _ v (expression r before c v guard) zero
  | loopNormal c body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact .loopNormal c body increment _ _ _ _ v (expression r before c v guard) nonzero ih1 ih2 ih3
  | loopReturn c body increment before after v value guard nonzero iteration ih =>
      exact .loopReturn c body increment _ _ v value (expression r before c v guard) nonzero ih
  | ret e before v source => exact .ret e _ v (expression r before e v source)

end FT1536.Source3.KeygenWordRename093
