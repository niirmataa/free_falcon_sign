import Source3.KeygenSearchPointer100

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSearchValue100
open C99ArrayReference (State Name)
open C99IntegerReference (Value)
open C99MemoryReference
open KeygenSearchContext (Context)
open KeygenSearchExec (Expr Eval)

theorem signed_read (s : State) (name : Name) (a b : Value)
    (first : KeygenSmallSource.SignedLocalRead s name a) (second : KeygenSmallSource.SignedLocalRead s name b) : a = b := by
  cases first
  cases second
  grind

theorem plain_checked : C99ModularArity096.checkedCode KeygenSmallSource.plainPrefix = true := by decide

theorem plain (before : State) (p : ArrayPointer) (a b : Value)
    (first : KeygenSmallSource.PlainCall before p a) (second : KeygenSmallSource.PlainCall before p b) : a = b := by
  cases first
  cases second
  have unique := C99ModularArity096.execution_unique KeygenSmallSource.plainPrefix (KeygenSmallSource.plainEntry before p)
  grind only [plain_checked, signed_read]

theorem expression (ctx : Context) (before : State) (e : Expr) (a b : Value)
    (first : Eval ctx before e a) (second : Eval ctx before e b) : a = b := by
  have calls := KeygenNormLanguage094.scalar_calls
  unfold C99ScalarDeterminism089.Deterministic at calls
  induction first generalizing b <;> cases second
  all_goals grind only [C99ArrayDeterminism089.expression, KeygenSearchPointer100.pointer, plain]

end FT1536.Source3.KeygenSearchValue100
