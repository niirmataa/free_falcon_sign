import Source3.C99CheckCalls
import Source3.C99BodySound

/- Natural semantics of one uint32_t compound assignment between two pure
   scalar statement sequences. No evaluator occurs in the execution rule.
   The reference parameter denotes a live caller object. Other variables
   are callee-private by-value cells; the returned judgment drops them.
   The rhs and pointer/old-value evaluation commute because the rhs is in
   the pure scalar fragment; only Store32 modifies the caller memory. -/
namespace FT1536.Source3.C99CheckReference
open B20.C C99MemoryReference

structure Code where
  before : C99ScalarReference.Stmt
  rhs : C99ScalarReference.Expr
  op : BinOp
  after : C99ScalarReference.Stmt
  result : C99IntegerReference.Ty

inductive Exec (calls : C99ScalarReference.CallRelation) (code : Code)
    (env : C99ScalarReference.Env) (before : C99MemoryReference.Memory) (p : ArrayPointer) :
    C99IntegerReference.Value → C99MemoryReference.Memory → Prop where
  | step (locals : C99ScalarReference.Env) (old new : BitVec 32)
      (rhs merged result : C99IntegerReference.Value) (after : C99MemoryReference.Memory)
      (prefixExec : C99ScalarReference.Exec calls env code.before (.normal locals))
      (rhsExec : C99ScalarReference.Eval calls locals code.rhs rhs)
      (load : Load32 before p old)
      (operation : C99OperatorBridge.Binary code.op (.uint32 old) rhs merged)
      (conversion : C99IntegerReference.convert .uint32 merged.integer=.uint32 new)
      (write : Store32 before p new after)
      (suffixExec : C99ScalarReference.Exec calls locals code.after (.returned result)) :
      Exec calls code env before p (C99IntegerReference.convert code.result result.integer) after

def prelude : List CLogic.Stmt := [
  .declare .u64 ["mask".toList,"xb".toList],
  .declare .u32 ["valid".toList],
  .assign "valid".toList (.cast .u32 (.call1 KeygenHelpers.positiveName (.var "x".toList)))]
def rhs : CLogic.Expr := .bin .xor (.var "valid".toList) (.literal .u32 1)
def suffix : List CLogic.Stmt := [
  .assign "mask".toList (.bin .sub (.cast .u64 (.literal .i32 0)) (.cast .u64 (.var "valid".toList))),
  .assign "xb".toList (.call1 KeygenHelpers.bitsName (.var "x".toList)),
  .ret (.call1 KeygenHelpers.fromBitsName (.bin .bor
    (.bin .band (.var "xb".toList) (.var "mask".toList))
    (.bin .band (.call1 KeygenHelpers.bitsName (.var "fpr_one".toList)) (.bitNot (.var "mask".toList)))))]

def code : Code := ⟨C99Frontend.scalars prelude,C99Frontend.expression rhs,.bor,
  C99Frontend.scalars suffix,.uint64⟩

/- Source binding retains the pointer parameter and the exact RMW position.
   This is a syntactic decomposition, not a replacement by stableWord. -/
theorem source_body : StablePositive.program.body=
    prelude.map CRefWord.Stmt.localStmt ++ [.updateRef "bad".toList .bor rhs] ++
      suffix.map CRefWord.Stmt.localStmt := rfl
theorem source_parameters : StablePositive.program.params=[.word .u64 "x".toList,.ref32 "bad".toList] := rfl

def entry (w : BitVec 64) : C99ScalarReference.Env :=
  C99ScalarReference.set
    (C99ScalarReference.set (fun _ => none) "fpr_one".toList (.uint64,some (.uint64 Run2.KeygenLeafGate.oneBits)))
    "x".toList (.uint64,some (.uint64 w))

def Check (before : C99MemoryReference.Memory) (bad : ArrayPointer) (w z : BitVec 64)
    (after : C99MemoryReference.Memory) : Prop := Exec C99CheckCalls.calls code (entry w) before bad (.uint64 z) after

end FT1536.Source3.C99CheckReference
