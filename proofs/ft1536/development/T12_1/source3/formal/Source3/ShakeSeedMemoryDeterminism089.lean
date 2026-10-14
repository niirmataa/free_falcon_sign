import Source3.C99ArrayDeterminism089
import Source3.ShakeBlockDeterminism089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedMemoryDeterminism089
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99ScalarDeterminism089

theorem read8 (s : State) : Deterministic (ShakeSeedMemory.Read8 s) := by
  intro name args a b first second
  cases first
  cases second
  grind only [C99HeapDeterminism089.pointer_add]

theorem byte_expression (s : State) (e : C99ScalarReference.Expr) (a b : Value)
    (first : C99ScalarReference.Eval (ShakeSeedMemory.Read8 s) s.locals e a)
    (second : C99ScalarReference.Eval (ShakeSeedMemory.Read8 s) s.locals e b) : a = b :=
  expression_unique (ShakeSeedMemory.Read8 s) (read8 s) s.locals e a b first second

theorem decode (before : State) (p : ArrayPointer) (a b : BitVec 64)
    (first : ShakeSeedMemory.Decode before p a) (second : ShakeSeedMemory.Decode before p b) : a = b := by
  cases first
  cases second
  grind only [C99ArrayDeterminism089.execution, byte_expression]

/-- These two modular statement shapes execute only the already closed
    scalar/array layer. No determinism assumption about arbitrary modular
    calls is needed for the actual XOR loop's declaration and increment. -/
theorem base_statement (calls : C99ModularReference.CallRelation) (code : C99ArrayReference.Stmt)
    (before : State) (a b : Result)
    (first : C99ModularReference.GenExec calls (.base code) before a)
    (second : C99ModularReference.GenExec calls (.base code) before b) : a = b := by
  cases first
  cases second
  grind only [C99ArrayDeterminism089.execution]

theorem scalar_value (calls : C99ModularReference.CallRelation) (before : State)
    (e : CLogic.Expr) (a b : Value)
    (first : C99ModularReference.GenEval calls before (.scalar e) a)
    (second : C99ModularReference.GenEval calls before (.scalar e) b) : a = b := by
  cases first
  cases second
  grind only [C99ScalarCallsDeterminism089.array_scalar]

theorem assign_scalar (calls : C99ModularReference.CallRelation) (name : C99ArrayReference.Name)
    (e : CLogic.Expr) (before : State) (a b : Result)
    (first : C99ModularReference.GenExec calls (.assign name (.scalar e)) before a)
    (second : C99ModularReference.GenExec calls (.assign name (.scalar e)) before b) : a = b := by
  cases first
  cases second
  grind only [scalar_value]

theorem step (before a b : State) (first : ShakeSeedMemory.XorStep before a)
    (second : ShakeSeedMemory.XorStep before b) : a = b := by
  cases first
  cases second
  grind only [C99ScalarCallsDeterminism089.array_pointer, load64_deterministic,
    decode, C99IntegerReference.bitwise_deterministic, C99HeapDeterminism089.store64]

theorem increment (before a b : State)
    (first : C99ModularReference.Exec ShakeSeedMemory.increment before ⟨a, .normal⟩)
    (second : C99ModularReference.Exec ShakeSeedMemory.increment before ⟨b, .normal⟩) : a = b := by
  have same := base_statement C99ModularReference.ModCall _ before _ _ first second
  exact congrArg Result.state same

theorem loop (before a b : State) (first : ShakeSeedMemory.XorLoop before a)
    (second : ShakeSeedMemory.XorLoop before b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [step, increment, C99ScalarCallsDeterminism089.array_scalar]

theorem declaration (before a b : State)
    (first : C99ModularReference.Exec ShakeSeedMemory.declaration before ⟨a, .normal⟩)
    (second : C99ModularReference.Exec ShakeSeedMemory.declaration before ⟨b, .normal⟩) : a = b := by
  have same := base_statement C99ModularReference.ModCall _ before _ _ first second
  exact congrArg Result.state same

theorem initial (before a b : State)
    (first : C99ModularReference.Exec ShakeSeedMemory.initial before ⟨a, .normal⟩)
    (second : C99ModularReference.Exec ShakeSeedMemory.initial before ⟨b, .normal⟩) : a = b := by
  have same := assign_scalar C99ModularReference.ModCall _ _ before _ _ first second
  exact congrArg Result.state same

theorem xor_call (before : State) (ptr data : ArrayPointer) (rate : Value) (a b : State)
    (first : ShakeSeedMemory.XorCall before ptr data rate a)
    (second : ShakeSeedMemory.XorCall before ptr data rate b) : a = b := by
  cases first
  cases second
  grind only [declaration, initial, loop]

end FT1536.Source3.ShakeSeedMemoryDeterminism089
