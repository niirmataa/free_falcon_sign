import Source3.WordControl205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.WordAtoms205
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenWordExec (Exec)
open KeygenWordExpr (Eval)
open CrtState205

theorem assign32 (s : State) (name : String) (old : Option Value) (e : KeygenWordExpr.Expr) (w : BitVec 32)
    (declared : s.locals name.toList=some (.uint32,old)) (value : Eval s e (.uint32 w)) :
    Exec (.assign name.toList e) s ⟨set32 s name w,.normal⟩ := .assign _ _ _ _ _ _ declared value

theorem assign64 (s : State) (name : String) (old : Option Value) (e : KeygenWordExpr.Expr) (w : BitVec 64)
    (declared : s.locals name.toList=some (.uint64,old)) (value : Eval s e (.uint64 w)) :
    Exec (.assign name.toList e) s ⟨set64 s name w,.normal⟩ := .assign _ _ _ _ _ _ declared value

theorem widen (s : State) (e : KeygenWordExpr.Expr) (w : BitVec 32) (source : Eval s e (.uint32 w)) :
    Eval s (.cast .uint64 e) (.uint64 (CrtWordOps205.widen w)) := by
  rw [← CrtWordOps205.cast_widen w]
  exact .cast _ _ _ source

theorem narrow (s : State) (e : KeygenWordExpr.Expr) (w : BitVec 64) (source : Eval s e (.uint64 w)) :
    Eval s (.cast .uint32 e) (.uint32 (CrtWordOps205.narrow w)) := by
  rw [← CrtWordOps205.cast_narrow w]
  exact .cast _ _ _ source

theorem literal (s : State) (n : Nat) : Eval s (.scalar (.literal .i32 n)) (.int32 (BitVec.ofNat 32 n)) :=
  .scalar _ _ (.literal .int32 n)

theorem guard01 (s : State) (len : String) (u : Slot64 s "u" 0) (limit : Slot64 s len 1) :
    Eval s (.cmp .lt (.scalar (.var "u".toList)) (.scalar (.var len.toList))) (.int32 1) :=
  .cmp _ _ _ _ _ _ (expr64 s "u" 0 u) (expr64 s len 1 limit) ZintSubWord194.guard_true

theorem guard11 (s : State) (len : String) (u : Slot64 s "u" 1) (limit : Slot64 s len 1) :
    Eval s (.cmp .lt (.scalar (.var "u".toList)) (.scalar (.var len.toList))) (.int32 0) :=
  .cmp _ _ _ _ _ _ (expr64 s "u" 1 u) (expr64 s len 1 limit) ZintSubWord194.guard_false

end FT1536.Source3.WordAtoms205
