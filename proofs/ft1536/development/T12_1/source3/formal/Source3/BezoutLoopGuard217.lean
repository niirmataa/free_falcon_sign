import Source3.BezoutNormalNinvCells217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact first-iteration guard of the original Bezout loop. -/
namespace FT1536.Source3.BezoutLoopGuard217
open C99ArrayReference (State)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open KeygenWordExpr (Expr Eval)
open KeygenZintCall (Stmt Exec)

def loop : Stmt := match KeygenZintCall.bezoutPart 7 with | .seq l _ => l | _ => KeygenZintCall.skip
def body : Stmt := match loop with | .loop _ b _ => b | _ => KeygenZintCall.skip
def branch : Stmt := match body with | .scope _ _ (.seq _ (.seq b _)) => b | _ => KeygenZintCall.skip
def var (s : String) : CLogic.Expr := .var s.toList
def test (s : String) : Expr := .cmp .ge (.scalar (var s)) (.scalar (.literal .i32 3))
def condition : Expr := .lor (test "alen") (test "blen")
def accelerated (a b : Nat) : Bool := decide (a≥3) || decide (b≥3)

theorem ge_three (n : Nat) (bound : n<2^64) :
    C99IntegerReference.CompareExec .ge (.uint64 (word n)) (.int32 3) (C99ScalarReference.boolean (decide (n≥3))) := by
  have raw := C99IntegerReference.CompareExec.step .ge (.uint64 (word n)) (.int32 3) .uint64 rfl
    (.uint64 (word n)) (.uint64 3) (C99CountedWords.convert_self (.uint64 (word n))).symm rfl
  change C99IntegerReference.CompareExec .ge (.uint64 (word n)) (.int32 3)
    (C99ScalarReference.boolean (decide ((C99IntegerReference.Value.uint64 (word n)).integer≥3))) at raw
  rw [C99NatWord141.integer n bound] at raw
  have eq : ((n : Int)≥3) ↔ n≥3 := by omega
  simpa only [eq] using raw

theorem test_eval (s : State) (name : String) (n : Nat) (bound : n<2^64) (cell : Cell s name.toList n) :
    Eval s (test name) (C99ScalarReference.boolean (decide (n≥3))) :=
  .cmp .ge _ _ _ _ _ (.scalar _ _ (.variable _ _ _ cell)) (.scalar _ _ (.literal .int32 3)) (ge_three n bound)

theorem or_eval (s : State) (a b : Expr) (p q : Bool)
    (left : Eval s a (C99ScalarReference.boolean p)) (right : Eval s b (C99ScalarReference.boolean q)) :
    Eval s (.lor a b) (C99ScalarReference.boolean (p || q)) := by
  cases p <;> cases q
  · exact .orFalse _ _ (.int32 0) (.int32 0) left rfl right
  · exact .orFalse _ _ (.int32 0) (.int32 1) left rfl right
  · exact .orTrue _ _ (.int32 1) left (by decide)
  · exact .orTrue _ _ (.int32 1) left (by decide)

theorem guard (s : State) (a b : Nat) (ab : a<2^64) (bb : b<2^64)
    (ac : Cell s "alen".toList a) (bc : Cell s "blen".toList b) :
    Eval s condition (C99ScalarReference.boolean (accelerated a b)) :=
  or_eval s _ _ _ _ (test_eval s "alen" a ab ac) (test_eval s "blen" b bb bc)

end FT1536.Source3.BezoutLoopGuard217
