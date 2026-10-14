import Source3.KeygenCappedSampler092
import Source3.C99ArrayRename093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWordDeterminism093
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenWordExpr
open C99Metadata091 (Stable)

def checkedExpr : Expr → Bool
  | .scalar _ | .load32 _ _ | .load16 _ _ => true
  | .cast _ e | .neg e | .bitNot e | .lnot e => checkedExpr e
  | .bin _ a b | .cmp _ a b | .land a b | .lor a b => checkedExpr a && checkedExpr b
  | .call1 _ _ | .call2 _ _ _ | .call3 _ _ _ _ | .call4 _ _ _ _ _ | .call5 _ _ _ _ _ _ => false

def checkedCode : KeygenWordExec.Stmt → Bool
  | .modular code => C99SimpleModular091.checkedCode code
  | .assign _ e | .store _ _ e | .ret e => checkedExpr e
  | .seq a b => checkedCode a && checkedCode b
  | .branch e a b | .loop e a b => checkedExpr e && checkedCode a && checkedCode b
  | .scope _ body => checkedCode body

theorem binary (op : B20.C.BinOp) (x y a b : Value)
    (first : C99OperatorBridge.Binary op x y a) (second : C99OperatorBridge.Binary op x y b) : a = b := by
  cases op
  all_goals first
    | exact C99IntegerReference.arithmetic_deterministic _ x y a b first second
    | exact C99IntegerReference.bitwise_deterministic _ x y a b first second
    | exact C99IntegerReference.shift_deterministic _ x y a b first second

theorem expression (s : State) (e : Expr) (a b : Value) (checked : checkedExpr e = true)
    (first : Eval s e a) (second : Eval s e b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedExpr, Bool.and_eq_true, Bool.false_eq_true] at *
  all_goals grind only [C99ScalarCallsDeterminism089.array_scalar,
    C99ScalarCallsDeterminism089.array_pointer, Gate00Memory.load32_deterministic,
    C99NarrowReads.load16_deterministic, C99IntegerReference.neg_deterministic,
    C99ScalarDeterminism089.complement_unique, C99ScalarDeterminism089.compare_unique, binary]

theorem execution (code : KeygenWordExec.Stmt) (before : State) (a b : Result)
    (checked : checkedCode code = true) (first : KeygenWordExec.Exec code before a)
    (second : KeygenWordExec.Exec code before b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedCode, Bool.and_eq_true] at *
  all_goals grind only [expression, C99SimpleModular091.execution,
    C99ScalarCallsDeterminism089.array_pointer, C99HeapDeterminism089.store32]

theorem metadata (code : KeygenWordExec.Stmt) (before : State) (out : Result)
    (source : KeygenWordExec.Exec code before out) : Stable before out.state := by
  induction source with
  | modular code before out source => exact C99Metadata091.modular _ code before out source
  | assign | ret | loopFalse => exact ⟨rfl, rfl, rfl, rfl⟩
  | store name index e before after p v address value write => exact ⟨write.2.2.2.1, write.2.2.2.2.1, rfl, rfl⟩
  | seqNormal a b before middle out head tail ih1 ih2 => exact C99Metadata091.trans before middle out.state ih1 ih2
  | seqExit a b before out head exit ih => exact ih
  | scope locals body before out inner ih => exact ⟨ih.sizes, ih.writable, ih.tables, ih.globals⟩
  | branchTrue condition yes no before out v guard nonzero body ih => exact ih
  | branchFalse condition yes no before out v guard zero body ih => exact ih
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact C99Metadata091.trans before next out.state (C99Metadata091.trans before middle next ih1 ih2) ih3
  | loopReturn condition body increment before after v ret guard nonzero iteration ih => exact ih

end FT1536.Source3.KeygenWordDeterminism093
