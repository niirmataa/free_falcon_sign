import Source3.KeygenWordArity096

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLevelReads097
open C99ArrayReference (State)
open C99MemoryReference
open C99IntegerReference (Value)
open KeygenLevelCalls (PrimeRead Expr Eval Bind Arg)

theorem memmove (before : Memory) (dst src : ArrayPointer) (count : Nat) (a b : Memory)
    (first : KeygenSearchMemory.Memmove before dst src count a)
    (second : KeygenSearchMemory.Memmove before dst src count b) : a = b := by
  obtain ⟨_, _, _, _, _, _, _, _, sa, wa, ba, fa⟩ := first
  obtain ⟨_, _, _, _, _, _, _, _, sb, wb, bb, fb⟩ := second
  apply RngTemporarySwap090.memory_ext
  · funext block offset
    by_cases inside : block = dst.block ∧ dst.offset ≤ offset ∧ offset < dst.offset + count
    · obtain ⟨rfl, lower, upper⟩ := inside
      have range : offset - dst.offset < count := by omega
      have position : dst.offset + (offset - dst.offset) = offset := by omega
      have firstByte := ba (offset - dst.offset) range
      have secondByte := bb (offset - dst.offset) range
      rw [position] at firstByte secondByte
      exact firstByte.trans secondByte.symm
    · have outside : block ≠ dst.block ∨ offset < dst.offset ∨ dst.offset + count ≤ offset := by omega
      exact (fa block offset outside).trans (fb block offset outside).symm
  · exact sa.trans sb.symm
  · exact wa.trans wb.symm

theorem prime (before : State) (name : C99ArrayReference.Name) (index : CLogic.Expr) (field : KeygenLevelCalls.Field)
    (a b : Value) (first : PrimeRead before name index field a) (second : PrimeRead before name index field b) : a = b := by
  cases first
  cases second
  grind only [C99ScalarCallsDeterminism089.array_pointer, Gate00Memory.load32_deterministic]

def checkedExpr : Expr → Bool
  | .modular e => C99ModularArity096.checkedExpr e
  | .prime _ _ _ => true

def checkedArgs : List Arg → Bool
  | [] => true
  | .scalar e :: rest => checkedExpr e && checkedArgs rest
  | .pointer _ _ :: rest => checkedArgs rest

theorem expression (before : State) (e : Expr) (a b : Value) (checked : checkedExpr e = true)
    (first : Eval before e a) (second : Eval before e b) : a = b := by
  cases first <;> cases second
  all_goals grind only [checkedExpr, C99ModularArity096.expression_unique, prime]

theorem parameters (before : State) (params : List C99ArrayReference.Param) (args : List Arg) (a b : State)
    (checked : checkedArgs args = true) (first : Bind before params args a) (second : Bind before params args b) : a = b := by
  revert checked
  induction first generalizing b <;> intro checked <;> cases second
  all_goals simp only [checkedArgs, Bool.and_eq_true] at *
  all_goals grind only [expression, C99ScalarCallsDeterminism089.array_pointer]

end FT1536.Source3.KeygenLevelReads097
