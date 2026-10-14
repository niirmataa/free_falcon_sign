import Source3.KeygenMakeFgCall099

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSearchPointer100
open C99ArrayReference (State)
open C99MemoryReference
open KeygenSearchContext (Context)
open KeygenSearchExec (EvalPointer PointerExpr)

theorem cast (p : ArrayPointer) (width : Nat) (a b : ArrayPointer)
    (first : KeygenSearchMemory.Cast p width a) (second : KeygenSearchMemory.Cast p width b) : a = b :=
  first.2.2.2.2.trans second.2.2.2.2.symm

theorem logn (ctx : Context) (s : State) (a b : BitVec 32)
    (first : KeygenSearchContext.ReadLogn ctx s a) (second : KeygenSearchContext.ReadLogn ctx s b) : a = b := by
  cases first
  cases second
  exact Gate00Memory.load32_deterministic _ _ _ _ (by assumption) (by assumption)

theorem ternary (ctx : Context) (s : State) (a b : BitVec 32)
    (first : KeygenSearchContext.ReadTernary ctx s a) (second : KeygenSearchContext.ReadTernary ctx s b) : a = b := by
  cases first
  cases second
  exact Gate00Memory.load32_deterministic _ _ _ _ (by assumption) (by assumption)

theorem tmp (ctx : Context) (s : State) (a b : ArrayPointer)
    (first : KeygenSearchContext.ReadTmp ctx s a) (second : KeygenSearchContext.ReadTmp ctx s b) : a = b := by
  cases first
  cases second
  rfl

theorem rounding_checked : C99ModularArity096.checkedCode KeygenSearchMemory.rounding = true := by decide

theorem align (before : State) (base data a b : ArrayPointer)
    (first : KeygenSearchMemory.Align before base data a) (second : KeygenSearchMemory.Align before base data b) : a = b := by
  have rounding := C99ModularArity096.execution_unique KeygenSearchMemory.rounding
  cases first
  cases second
  have naturalUnique : ∀ x y : BitVec 64, (x.toNat : Int) = (y.toNat : Int) → x = y := by
    intro x y equal
    apply BitVec.eq_of_toNat_eq
    omega
  grind only [cast, rounding_checked, C99ScalarCallsDeterminism089.array_scalar,
    C99HeapDeterminism089.pointer_add]

theorem pointer (ctx : Context) (before : State) (e : PointerExpr) (a b : ArrayPointer)
    (first : EvalPointer ctx before e a) (second : EvalPointer ctx before e b) : a = b := by
  induction first generalizing b <;> cases second
  all_goals grind only [C99ScalarCallsDeterminism089.array_pointer, tmp, cast, align]

end FT1536.Source3.KeygenSearchPointer100
